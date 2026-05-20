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
pnpm install       # 최초 1회
pnpm build         # tsp → openapi.yaml
pnpm watch         # 파일 변경 감지 컴파일
pnpm format        # .tsp 포맷팅
```

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
