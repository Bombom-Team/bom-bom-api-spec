# BomBom TypeSpec Skill Reference

The shared guidance lives in [docs/typespec-authoring.md](../../../docs/typespec-authoring.md).

## Agent-Specific Reminders

- Start from the shared guide, not from memory.
- Treat GitHub mustache templates as the source of truth for backend-specific behavior.
- Always confirm the endpoint authentication policy with the user before changing `.tsp`.
- Ask the user only when the repo and referenced GitHub templates still leave a real ambiguity.
- Do not invent a new `x-*` extension or a new value shape for an existing one.

## Typical Clarification Questions

- Should this endpoint require authentication at all?
- Should `@useAuth(sessionCookie)` be applied here?
- Which GitHub PR, branch, or commit should be treated as the backend source of truth?
- Should this endpoint inject `Member member` or `Long memberId`?
- Should login-member resolution allow anonymous access or invalid-token handling?
- Is Spring pagination intended, or should pagination be modeled only as explicit OpenAPI query parameters?
- When two existing endpoint patterns differ, which one should this new endpoint follow?
