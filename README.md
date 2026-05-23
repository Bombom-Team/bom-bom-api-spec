# bom-bom-api-spec

봄봄 백엔드와 프론트엔드 간 API 계약을 위한 OpenAPI 명세

## 구조

- `tsp/` — TypeSpec 소스 (편집은 이쪽에서)
  - `main.tsp` — 진입점, `@service` / `@server` / `@info`
  - `common/` — 공통 모델 (`Page<T>`, `sessionCookie` 인증)
  - `domains/` — 도메인별 엔드포인트와 응답 모델
- `openapi.yaml` — TypeSpec 컴파일 산출물 (BE/FE codegen 입력). **직접 편집하지 마세요.**

## 사용법

패키지 매니저는 [pnpm](https://pnpm.io)을 사용합니다 (`package.json`의 `packageManager` 필드로 고정).

```bash
pnpm install       # 최초 1회 (pre-commit hook 자동 등록)
pnpm build         # tsp → openapi.yaml
pnpm watch         # 파일 변경 감지 컴파일
pnpm format        # .tsp 포맷팅
```

## 동기화 보장

**pre-commit hook** — `.tsp` 변경이 staged면 자동으로 `pnpm build`를 돌리고
갱신된 `openapi.yaml`을 같은 커밋에 추가합니다 (`scripts/precommit-build.sh`).
스킵이 필요하면 `SKIP_SIMPLE_GIT_HOOKS=1 git commit ...` 또는 `git commit --no-verify`.

**CI (`.github/workflows/spec-check.yml`)** — PR과 main push마다
`pnpm build` 후 `git diff --exit-code openapi.yaml`로 yaml이 `.tsp`와
일치하는지 검증합니다. 누락된 경우 워크플로우가 실패하며, 로컬에서
`pnpm build` 다시 돌려 커밋하라는 안내가 표시됩니다.

## 에디터

VS Code 확장 [TypeSpec for VS Code](https://marketplace.visualstudio.com/items?itemName=typespec.typespec-vscode)
를 설치하면 syntax highlighting, 자동완성, 진단, 포맷팅이 동작합니다.

```bash
code --install-extension typespec.typespec-vscode
# 또는
pnpm exec tsp code install
```

JetBrains는 [TypeSpec for IntelliJ Platform](https://plugins.jetbrains.com/plugin/23107-typespec)
플러그인을 사용합니다.
