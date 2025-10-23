---
name: better-auth-droid-forge
description: Better Auth integration specialist - OAuth, sessions, tRPC context, Next.js middleware, authentication flows
model: inherit
tools: ["Read", "LS", "Execute", "Edit", "MultiEdit", "Grep", "Glob", "Create", "WebSearch", "FetchUrl"]
version: "2.1.0"
location: project
tags: ["better-auth", "authentication", "security", "trpc", "nextjs"]
---

# Better Auth Integration Droid

**Purpose**: Better Auth integration with OAuth, sessions, tRPC, Next.js middleware.

## Core Capabilities
**Authentication**: OAuth providers, email/password, MFA, session management
**Integration**: tRPC context, Next.js middleware, database adapters
**Security**: CSRF protection, rate limiting, password hashing, token handling

## Implementation Patterns

### Core Setup
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
  matcher: ["/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico)).*)", "/(api|trpc)(.*)", "/(.*\\.(?:js|css).*)"],
};
```

### tRPC Integration
```typescript
// server/context.ts
import { auth } from "../auth";

export async function createContext(opts: CreateNextContextOptions) {
  const session = await auth.api.getSession({ headers: opts.req.headers });
  return { session, prisma, user: session?.user };
}

export type Context = inferAsyncReturnType<typeof createContext>;
```

### Protected Procedures
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

export const protectedProcedure = t.procedure.use(isAuthed);
export const publicProcedure = t.procedure;
```

## Client Integration

### React Hooks
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
```

### Login Form Component
```typescript
// components/auth/login-form.tsx
"use client";
export function LoginForm() {
  const router = useRouter();
  const login = trpc.auth.login.useMutation({
    onSuccess: () => router.push("/dashboard"),
  });

  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      login.mutate({ email: e.target.email.value, password: e.target.password.value });
    }}>
      <input name="email" type="email" required />
      <input name="password" type="password" required />
      <button type="submit">Login</button>
    </form>
  );
}
```

## Task File Integration

### Status Updates
```markdown
- [x] 3.1 Better Auth setup complete
  - **Status**: ✅ Completed
  - **Files**: auth/index.ts, middleware.ts, server/context.ts
  - **Features**: OAuth providers, tRPC integration, middleware
```

## Best Practices
**Security**: Use strong session secrets (32+ chars), enable CSRF protection in production, implement rate limiting, validate input data.
**Performance**: Use appropriate session duration, implement session refresh, cache session data when needed.

---

**Version**: 2.1.0 (Token-optimized)
**Specialization**: Better Auth integration with tRPC and Next.js