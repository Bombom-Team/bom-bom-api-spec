# BomBom TypeSpec Authoring Guide

## Purpose

This document describes how to write and update BomBom TypeSpec contracts in a way that stays compatible with backend OpenAPI generator customizations.

It is written to be tool-agnostic. Any engineer or AI agent can follow it.

## Source of Truth Order

1. User-provided GitHub PR, branch, commit, or file URL in `woowacourse-teams/2025-bom-bom`
2. Local backend checkout, if available: `../2025-bom-bom/backend/bom-bom-server/src/main/resources/openapi-templates/*.mustache`
3. Default GitHub path: `backend/bom-bom-server/src/main/resources/openapi-templates/*.mustache`
4. Existing usage in this spec repo under `tsp/` and generated `openapi.yaml`

If none of the above are available, use only the confirmed extensions listed here and avoid inventing new ones.

## Local Repo Conventions

- Edit TypeSpec under `tsp/`.
- `tsp/main.tsp` is the entrypoint and owns imports plus service metadata.
- Shared primitives live in `tsp/common/`.
- Domain operations and DTOs live in `tsp/domains/`.
- `openapi.yaml` is generated output. Do not edit it directly.
- Keep the TypeSpec file name, `@tag(...)`, and intended generated Spring `*Api` grouping aligned unless the user explicitly asks otherwise.
  For example, `tsp/domains/mypage/monthlyreport.tsp` should normally use `@tag("MonthlyReport")`, because the backend generator uses tags for API interface names such as `MonthlyReportApi`.

## Standard Workflow

### 1. Gather local context

- Find the target domain file in `tsp/domains/` or create one that matches the existing structure.
- Check `tsp/main.tsp` imports if a new domain file is added.
- Reuse nearby code patterns before introducing a new structure.
- Check whether the change should create or avoid a generated Spring API interface by looking at the operation tag.

### 2. Confirm backend template rules from GitHub

- Default source is `woowacourse-teams/2025-bom-bom`.
- Default path is `backend/bom-bom-server/src/main/resources/openapi-templates/`.
- If a local backend checkout exists, inspect it first for the exact active templates. In this workspace that is usually `../2025-bom-bom/backend/bom-bom-server/src/main/resources/openapi-templates/`.
- If a PR, branch, commit, or file URL is given, prefer that exact revision.
- Scan the mustache templates for `vendorExtensions.x-`.
- Only use `x-*` extensions that are confirmed in those templates or already used in this spec repo.
- If a needed behavior is not confirmed, do not invent a new extension.

### 2.5. Confirm the authentication policy with the user

Before writing or changing an endpoint, explicitly ask the user to confirm the intended authentication policy.

At minimum, confirm:

- whether authentication is required
- whether `@useAuth(sessionCookie)` should be applied
- whether login-member injection is needed
- if login-member injection is needed, whether the backend expects `Member member` or `Long memberId`
- whether anonymous or invalid-token handling is intended

Treat this as a required confirmation step even if a similar existing endpoint already exists.

### 3. Author TypeSpec in repo style

- Put shared auth or pagination primitives in `tsp/common/`.
- Keep domain endpoints and DTOs in `tsp/domains/`.
- Use explicit response wrapper models such as `GetThingOk`, `GetThingUnauthorized`, `CreateThingBadRequest`.
- Prefer `@summary`, `@doc`, `@operationId`, `@tag`, `@route`, `@get` or `@post`, and `@useAuth(...)` consistently.
- Model nullable optional fields as `field?: T | null`.
- For multiple query values that the backend should receive as one Spring `@ModelAttribute`, define a request model and pass it as a single `@query` parameter. The current backend `queryParams.mustache` uses `@ModelAttribute` when the query parameter is a model; there is no separate `x-*` flag for this.
- Name query condition models as request DTOs when they become backend method parameters, for example `MonthlyReportRequest` and operation parameter `request`.
- If the intended DTO does not already exist in the backend or spec, ask the user to confirm the DTO name and sharing scope before finalizing it. Mention that existing backend DTO conventions use `...Request` for request-side models.
- Avoid unnecessary generated records. If a response model only wraps one field such as `{ days: [...] }`, consider returning the array directly when that API shape is acceptable.
- Avoid `@doc` on properties whose type is another model or enum unless the generated OpenAPI has been checked. TypeSpec may emit `$ref` plus `description` as `allOf`, which can create awkward generated Java shapes.
- Do not try to force Java primitive types such as `int` or `double` from TypeSpec. OpenAPI Generator Java primitive-vs-wrapper output is controlled by backend generator templates/options, not by standard OpenAPI schema alone.

### 4. Validate generated output

- Run `pnpm format`.
- Run `pnpm build`.
- Check `openapi.yaml` to verify descriptions, auth, params, and any `x-*` extensions were emitted as expected.
- For backend-sensitive changes, copy or update the generated `openapi.yaml` in the local backend checkout only for verification, run `openApiGenerate`, and inspect generated API/model signatures. Do not stage unrelated backend generated files.
- If the generated OpenAPI shape does not match the intended backend customization, revise the `.tsp` rather than patching YAML.

## When To Ask For Clarification

Ask a human only when the answer cannot be derived from the repo or the referenced GitHub templates, except for authentication policy. Authentication policy must always be confirmed with the user before changing an endpoint.

Ask when one of these is true:

- The target GitHub PR, branch, commit, or file path is ambiguous.
- The authentication policy for the endpoint has not been explicitly confirmed yet.
- A needed `x-*` extension is not confirmed from GitHub templates or existing spec usage.
- The user wants generated Java behavior that OpenAPI cannot express directly, such as primitive `int`/`double` record components instead of `Integer`/`Double`.
- Multiple existing TypeSpec patterns fit and they would change public API behavior differently.
- The intended auth behavior is unclear, especially around login-member injection semantics.
- The backend template appears to support a feature, but the expected TypeSpec value shape is still unclear.
- The generated `openapi.yaml` conflicts with the requested behavior and there is more than one reasonable fix.

Do not ask for things that can be verified from:

- existing `tsp/` files
- generated `openapi.yaml`
- the referenced GitHub mustache templates
- the local backend mustache templates and generated code, when a local backend checkout exists
- the repo build and format output

Exception:

- still ask to confirm authentication policy, even if nearby code suggests the likely answer

## Current TypeSpec Patterns In This Repo

### Service setup

```tsp
@service({
  title: "BomBom API",
})
@info({
  version: "1.0.0",
})
@server("https://api.bombom.news", "BomBom Production API")
namespace BomBomAPI;
```

### Auth

```tsp
@doc("세션 쿠키 기반 인증")
model sessionCookie
  is ApiKeyAuth<ApiKeyLocation.cookie, "JSESSIONID">;
```

Use auth on operations like this:

```tsp
@useAuth(sessionCookie)
```

### Response wrapper pattern

```tsp
model GetThingOk {
  @statusCode statusCode: 200;
  @body body: ThingResponse;
}

model GetThingUnauthorized {
  @statusCode statusCode: 401;
}
```

### Nullable fields

```tsp
thumbnailUrl?: string | null;
```

### Pagination

Reuse `Page<T>` from `tsp/common/pagination.tsp` for Spring-style paged results.

### Tags and generated API names

The backend generator uses OpenAPI tags to group generated Spring interfaces.
Choose `@tag(...)` deliberately:

```tsp
@tag("MonthlyReport")
@route("/api/v1/members/me/reading")
namespace Reading;
```

This generates `MonthlyReportApi`. A tag like `Member` would generate `MemberApi`, even if the file lives under `mypage/`.

### Query model as `@ModelAttribute`

The backend `queryParams.mustache` treats model-typed query parameters specially:

```mustache
{{#isModel}}
@Valid @ModelAttribute {{>optionalDataType}} {{paramName}}
{{/isModel}}
```

Use this TypeSpec shape when several query fields should be bound as one Spring model attribute:

```tsp
model MonthlyReportRequest {
  @minValue(1)
  @extension("x-message", "year는 1 이상의 값이어야 합니다.")
  year: int32;

  @minValue(1)
  @maxValue(12)
  @extension("x-message", "month는 1 이상 12 이하의 값이어야 합니다.")
  month: int32;
}

op getReadingDashboard(
  @query
  request: MonthlyReportRequest,
): GetReadingDashboardOk | GetReadingDashboardBadRequest | GetReadingDashboardUnauthorized;
```

The HTTP request remains `?year=2026&month=5`; only the generated Java method signature changes to `@ModelAttribute MonthlyReportRequest request`.

When creating a new query/request model that is not named in an existing backend controller, DTO, or spec, do not silently invent the name or reuse scope. Ask for confirmation with the local convention:

> `calendar`와 `dashboard`가 같은 `year/month` 조회 조건을 쓰므로 `MonthlyReportRequest`를 공용으로 쓰는 게 자연스러워 보입니다. 백엔드 요청 DTO 컨벤션도 `...Request`인데, 이 이름과 공용 사용으로 확정할까요?

If the fields are identical and belong to one cohesive domain concept, propose a shared request DTO first. If the operations may evolve independently or the same fields have different meanings, ask whether to split them per operation, such as `CalendarRequest` and `DashboardRequest`.

### Avoiding generated wrapper records

Keep DTOs that represent real JSON objects or array items. Avoid DTOs that only wrap one field when the API contract does not need that wrapper:

```tsp
// Prefer, if the response shape can be a bare array
model GetReadingCalendarOk {
  @statusCode statusCode: 200;
  @body body: ReadingCalendarDayResponse[];
}
```

For object or enum reference properties, avoid property-level `@doc` unless needed and verified. A description on a `$ref` property can produce `allOf` in OpenAPI:

```yaml
readArticles:
  allOf:
    - $ref: '#/components/schemas/ReadingDashboardReadArticles'
  description: ...
```

Prefer a plain `$ref` when backend codegen should stay simple.

## Confirmed Vendor Extensions

These are confirmed from the current spec repo and backend mustache templates that were inspected while drafting this guide.

### `x-needs-login-member`

TypeSpec:

```tsp
@extension("x-needs-login-member", true)
```

Observed effect:

- Triggers a custom injected controller parameter through `loginMemberParam.mustache`.
- Default generated parameter is `me.bombom.api.v1.member.domain.Member member`.

Use when:

- The backend controller should receive the current logged-in member via custom argument resolution.

### `x-login-member-id`

TypeSpec:

```tsp
@extension("x-needs-login-member", true)
@extension("x-login-member-id", true)
```

Observed effect:

- The injected controller parameter becomes `java.lang.Long memberId` instead of `Member member`.

Use when:

- The backend template should inject only the logged-in member ID.

### `x-login-member-anonymous`

TypeSpec:

```tsp
@extension("x-needs-login-member", true)
@extension("x-login-member-anonymous", true)
```

Observed effect:

- The generated `@LoginMember` annotation receives `anonymous = true`.

Use when:

- The endpoint can resolve login context anonymously according to backend resolver semantics.

### `x-login-member-allow-invalid-token`

TypeSpec:

```tsp
@extension("x-needs-login-member", true)
@extension("x-login-member-allow-invalid-token", true)
```

Observed effect from the current mustache template:

- The generated `@LoginMember` annotation includes `allowInvalidToken = true`.
- In the current template, this branch also emits `anonymous = true` even when `x-login-member-anonymous` is absent.

Use when:

- The exact backend PR or branch confirms this behavior is intended. Do not assume broader semantics than the template proves.

### `x-spring-paginated`

TypeSpec:

```tsp
@extension("x-spring-paginated", true)
```

Observed effect:

- Adds `Pageable pageable` to generated Spring controller method parameters.

Use when:

- The backend controller should receive Spring pagination arguments outside the declared OpenAPI query parameters.

### `x-spring-provide-args`

TypeSpec:

```tsp
@extension("x-spring-provide-args", #{
  // verify exact shape from the target template revision before use
})
```

Observed effect:

- Appends additional provided method arguments in `operationMethodParams.mustache`.

Use when:

- The target backend template revision explicitly supports the exact value shape you need.
- This extension must be re-verified from GitHub before each real use.

### `x-message`

TypeSpec:

```tsp
@minValue(1)
@extension("x-message", "id는 1 이상의 값이어야 합니다.")
newsletterId?: int64,
```

Observed effect:

- Emitted into generated OpenAPI alongside the validated parameter or schema.

Use when:

- The backend generator or validation layer consumes a custom validation message from the OpenAPI extension.

## Authoring Checklist

- Reused an existing domain file pattern or added a new import in `tsp/main.tsp`
- Added `@summary` and `@doc` for operations and user-facing models
- Added `@operationId`
- Added auth and confirmed any `x-*` extensions
- Used explicit response wrapper models with status codes
- Ran `pnpm format`
- Ran `pnpm build`
- Verified `openapi.yaml` instead of editing it

## Fallback Rule

If GitHub template inspection fails:

- Use only the extensions already confirmed in this document.
- Mention that no fresh backend template verification was possible.
- Do not introduce a new `x-*` extension or a new value shape for an existing one.
