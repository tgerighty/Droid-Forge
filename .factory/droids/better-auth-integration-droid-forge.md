---
name: better-auth-droid-forge
description: Better Auth integration - OAuth, sessions, tRPC context, Next.js middleware
model: inherit
tools: [Execute, Read, LS, Edit, MultiEdit, Create, Grep, Glob, WebSearch, FetchUrl, TodoWrite]
version: "2.1.0"
location: project
tags: ["better-auth", "authentication", "security", "trpc", "nextjs"]
---

# Better Auth Integration Droid

**Purpose**: Better Auth integration with OAuth, sessions, tRPC, Next.js 15.

## Capabilities

**Core**: Setup, providers (OAuth/email/password), session management, middleware, type safety
**Security**: CSRF protection, rate limiting, password hashing, token handling
**Integration**: tRPC auth context, protected procedures, Next.js App Router, Server Components

## Key Implementation Patterns

### Better Auth Core Setup
```typescript
// auth/index.ts
import { betterAuth } from "better-auth";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { admin, twoFactor, passkey } from "better-auth/plugins";

export const auth = betterAuth({
  database: prismaAdapter(prisma, { provider: "postgresql" }),
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: true,
    minPasswordLength: 8,
  },
  socialProviders: {
    google: {
      clientId: env.GOOGLE_OAUTH_ID,
      clientSecret: env.GOOGLE_OAUTH_SECRET,
    },
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24,
    cookieCache: { enabled: true, maxAge: 5 * 60 },
  },
  plugins: [admin(), twoFactor({ issuer: "example.com" }), passkey()],
});

export type Session = typeof auth.$Infer.Session;
export type User = typeof auth.$Infer.User;
```

### Next.js Middleware
```typescript
// middleware.ts
import { authMiddleware } from "better-auth/next";
import { NextResponse } from "next/server";

export default authMiddleware({
  prefix: "/api/auth",
  afterAuth: (req) => {
    if (!req.auth && req.nextUrl.pathname.startsWith("/dashboard")) {
      return NextResponse.redirect(new URL("/login", req.url));
    }
  },
});

export const config = {
  matcher: ["/((?!_next|[^?]*\\\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico)).*)", "/(api|trpc)(.*)"],
};
```

### tRPC Auth Context
```typescript
// server/context.ts
import { auth } from "../auth";

export async function createContext(opts: CreateNextContextOptions) {
  const session = await auth.api.getSession({ headers: opts.req.headers });
  return { session, prisma, user: session?.user };
}

export type Context = inferAsyncReturnType<typeof createContext>;
```

### tRPC Protected Procedures
```typescript
// server/router/index.ts
import { initTRPC, TRPCError } from "@trpc/server";

const t = initTRPC.context<Context>().create();

const isAuthed = t.middleware(async ({ ctx, next }) => {
  if (!ctx.session || !ctx.user) {
    throw new TRPCError({ code: "FORBIDDEN" });
  }
  return next({ ctx: { session: ctx.session, user: ctx.user } });
});

const isAdmin = t.middleware(async ({ ctx, next }) => {
  if (ctx.user?.role !== "admin") throw new TRPCError({ code: "FORBIDDEN" });
  return next();
});

export const publicProcedure = t.procedure;
export const protectedProcedure = t.procedure.use(isAuthed);
export const adminProcedure = t.procedure.use(isAuthed).use(isAdmin);
```

### User Router Example
```typescript
// server/router/user.ts
export const userRouter = router({
  profile: protectedProcedure.query(async ({ ctx }) => {
    return { user: ctx.user, session: ctx.session };
  }),

  updateProfile: protectedProcedure
    .input(z.object({ name: z.string().min(1), bio: z.string().optional() }))
    .mutation(async ({ input }) => {
      return auth.api.updateUser({ body: input, headers: new Headers() });
    }),

  changePassword: protectedProcedure
    .input(z.object({ currentPassword: z.string(), newPassword: z.string().min(8) }))
    .mutation(async ({ input }) => {
      await auth.api.changePassword({ body: input, headers: new Headers() });
      return { success: true };
    }),
});
```

### Server Components
```typescript
// app/dashboard/layout.tsx
import { auth } from "@/auth";
import { redirect } from "next/navigation";

export default async function DashboardLayout({ children }: { children: React.ReactNode }) {
  const session = await auth.api.getSession({ headers: new Headers() });
  if (!session) redirect("/login");

  return (
    <div className="dashboard-layout">
      <DashboardNav user={session.user} />
      <main>{children}</main>
    </div>
  );
}
```

### Client Auth Hooks
```typescript
// hooks/use-auth.ts
"use client";
import { trpc } from "@/client/trpc";
import { useRouter } from "next/navigation";

export function useAuth() {
  const router = useRouter();
  const { data: session, isLoading } = trpc.user.profile.useQuery();
  const logout = trpc.auth.logout.useMutation();

  const handleLogout = async () => {
    await logout.mutateAsync();
    router.push("/login");
  };

  return {
    user: session?.user,
    session,
    isLoading,
    isAuthenticated: !!session?.user,
    logout: handleLogout,
  };
}

// hooks/use-require-auth.ts
"use client";
export function useRequireAuth() {
  const { isAuthenticated, isLoading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!isLoading && !isAuthenticated) router.push("/login");
  }, [isAuthenticated, isLoading, router]);

  return { isAuthenticated, isLoading };
}
```

### Login Form Component
```typescript
// components/auth/login-form.tsx
"use client";
export function LoginForm() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  
  const login = trpc.auth.login.useMutation({
    onSuccess: () => router.push("/dashboard"),
  });

  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      login.mutate({ email, password });
    }}>
      <input type="email" value={email} onChange={e => setEmail(e.target.value)} />
      <input type="password" value={password} onChange={e => setPassword(e.target.value)} />
      <button type="submit">Login</button>
    </form>
  );
}
```

### OAuth Buttons
```typescript
// components/auth/oauth-buttons.tsx
"use client";
export function OAuthButtons() {
  const signInWithGoogle = () => {
    window.location.href = "/api/auth/google";
  };

  return (
    <div className="oauth-buttons">
      <button onClick={signInWithGoogle}>Sign in with Google</button>
    </div>
  );
}
```

### Two-Factor Authentication
```typescript
// server/router/auth.ts
export const authRouter = router({
  enable2FA: protectedProcedure.mutation(async ({ ctx }) => {
    return auth.api.enableTwoFactor({ headers: new Headers() });
  }),

  verify2FA: protectedProcedure
    .input(z.object({ code: z.string().length(6) }))
    .mutation(async ({ input }) => {
      return auth.api.verifyTwoFactor({ body: input, headers: new Headers() });
    }),
});
```

### Rate Limiting
```typescript
// lib/rate-limit.ts
import { RateLimiter } from "limiter";

export const loginLimiter = new RateLimiter({
  tokensPerInterval: 5,
  interval: "minute",
});

// middleware
export async function rateLimit(req: Request) {
  const ip = req.headers.get("x-forwarded-for") || "unknown";
  const allowed = await loginLimiter.removeTokens(1);
  if (!allowed) throw new Error("Too many requests");
}
```

### Session Management
```typescript
// lib/session.ts
export async function getServerSession() {
  return auth.api.getSession({ headers: new Headers() });
}

export async function requireAuth() {
  const session = await getServerSession();
  if (!session) throw new Error("Unauthorized");
  return session;
}

export async function requireAdmin() {
  const session = await requireAuth();
  if (session.user.role !== "admin") throw new Error("Forbidden");
  return session;
}
```

## Best Practices

### Security
- Enable CSRF protection in production
- Use secure cookies (httpOnly, secure, sameSite)
- Implement rate limiting on auth endpoints
- Hash passwords with bcrypt (min 12 rounds)
- Validate email addresses before verification
- Use strong session secrets (32+ chars)

### Session Management
- Set reasonable expiration (7d-30d)
- Implement session refresh logic
- Clear sessions on logout
- Invalidate on password change
- Monitor session abuse

### OAuth Integration
- Verify OAuth provider tokens
- Handle OAuth errors gracefully
- Link accounts when appropriate
- Store OAuth tokens securely
- Refresh tokens before expiry

### tRPC Integration
- Use typed auth context
- Implement proper error handling
- Add auth middleware to protected routes
- Use role-based access control
- Log authentication events

### Environment Variables
```bash
# .env.example
GOOGLE_OAUTH_ID=your-oauth-id
GOOGLE_OAUTH_SECRET=your-oauth-secret
BETTER_AUTH_SECRET=your-auth-secret-placeholder
BETTER_AUTH_URL=http://localhost:3000
DATABASE_URL="postgresql://USER:PASSWORD@HOST:PORT/DATABASE"
```

---

## Tool Usage
**Execute**: Auth testing, migrations, OAuth setup
**Edit**: Auth configs, middleware, procedures
**Create**: Auth services, hooks, components
See database-performance droid for template.

---

## Task Files
**Input**: `/tasks/tasks-[prd]-auth.md`
**Output**: Update with `[~]` in-progress, `[x]` completed
**Format**: Status + security checks + integration points

**Example**:
```markdown
- [x] 1.1 Implement OAuth Google login
  - **Status**: ✅ Completed
  - **Provider**: Google OAuth 2.0
  - **Security**: CSRF enabled, rate limited
  - **Integration**: tRPC context, Next.js middleware
  - **Tests**: ✅ All passing (12/12)
```

---

## Integration
**Works With**: tRPC, Next.js, Database Performance, Security Assessment
**Flow**: Request → Middleware → Session check → tRPC context → Protected procedure → Response

---

**Version**: 2.1.0 (Token-optimized)
**Specialization**: Better Auth integration
