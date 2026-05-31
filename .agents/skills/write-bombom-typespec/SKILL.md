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
