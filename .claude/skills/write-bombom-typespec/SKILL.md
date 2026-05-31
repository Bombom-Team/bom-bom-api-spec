---
name: write-bombom-typespec
description: Writes and updates BomBom TypeSpec API contracts while preserving backend OpenAPI generator customizations. Use when adding or editing `.tsp` files, OpenAPI endpoints or schemas, or when work must match BomBom backend `x-*` vendor extensions from GitHub-hosted mustache templates.
---

# Write BomBom TypeSpec

Read `docs/typespec-authoring.md` before doing any work.

Treat that document as the shared source of truth for:

- TypeSpec authoring workflow
- backend mustache customization checks from GitHub
- confirmed `x-*` vendor extensions
- when to ask the user for clarification
- the required authentication policy confirmation step

## Skill Notes

- Start from repo evidence and the referenced GitHub templates, not from memory.
- Before writing or changing an endpoint, ask the user to confirm the intended authentication policy.
- Ask the user only when the repo, generated OpenAPI output, and referenced GitHub templates still leave a real ambiguity.
- Do not invent a new `x-*` extension or a new value shape for an existing one.
- Revise `.tsp` files rather than patching `openapi.yaml` by hand.
