---
name: write-bombom-typespec
description: Writes and updates BomBom TypeSpec API contracts while preserving backend OpenAPI generator customizations. Use when adding or editing `.tsp` files, OpenAPI endpoints or schemas, or when work must match BomBom backend `x-*` vendor extensions from GitHub-hosted mustache templates.
---

# Write BomBom TypeSpec

Use the shared guide at [docs/typespec-authoring.md](../../../docs/typespec-authoring.md).

## Agent Notes

- Treat [docs/typespec-authoring.md](../../../docs/typespec-authoring.md) as the primary writing guide.
- Use [REFERENCE.md](REFERENCE.md) only for agent-specific reminders.
- Before writing or changing an endpoint, ask the user to confirm the intended authentication policy.
- Ask the user only for ambiguities that the repo, generated output, or referenced GitHub templates cannot resolve.
- Prefer acting on verified repo and GitHub evidence over asking broad process questions.
- When backend codegen behavior matters, inspect the local `2025-bom-bom/backend/bom-bom-server/src/main/resources/openapi-templates/` templates if present before assuming an `x-*` extension exists.
- Keep TypeSpec file names, `@tag(...)`, and expected generated `*Api` names aligned unless the user explicitly wants a different grouping.
- For multi-field query conditions that should generate Spring `@ModelAttribute`, use a single `@query` model parameter; the backend template detects query models rather than an `x-*` flag.
- If this requires inventing a DTO that is not in the existing backend/spec names, mention the backend `...Request` naming convention and ask the user to confirm both the DTO name and whether it should be shared across operations or split per operation.
- Avoid unnecessary generated DTOs and `allOf` wrappers: flatten one-field response wrappers when the API shape allows it, and avoid `@doc` on `$ref`-typed object/enum properties unless the generated OpenAPI has been checked.
