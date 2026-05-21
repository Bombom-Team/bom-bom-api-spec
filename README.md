# bom-bom-api-spec

봄봄 백엔드와 프론트엔드 간 API 계약을 위한 OpenAPI 명세

## 구조

- `tsp/` — TypeSpec 소스 (편집은 이쪽에서)
  - `main.tsp` — 진입점, `@service` / `@server` / `@info`
  - `common/` — 공통 모델 (`Page<T>`, `sessionCookie` 인증)
  - `domains/` — 도메인별 엔드포인트와 응답 모델
- `openapi.yaml` — TypeSpec 컴파일 최종 산출물. **직접 편집하지 마세요.**
- `scripts/package-maven-artifact.sh` — `openapi.yaml`을 Maven artifact(`jar`)로 패키징

## 사용법

패키지 매니저는 [pnpm](https://pnpm.io)을 사용합니다 (`package.json`의 `packageManager` 필드로 고정).

```bash
pnpm install       # 최초 1회 (pre-commit hook 자동 등록)
pnpm build         # tsp → openapi.yaml
pnpm watch         # 파일 변경 감지 컴파일
pnpm format        # .tsp 포맷팅
pnpm validate      # openapi.yaml YAML 문법 검증
pnpm package:maven # package.json version으로 Maven artifact 패키징
```

## 동기화 보장

**pre-commit hook** — `.tsp` 변경이 staged면 자동으로 `pnpm build`를 돌리고
갱신된 `openapi.yaml`을 같은 커밋에 추가합니다 (`scripts/precommit-build.sh`).
스킵이 필요하면 `SKIP_SIMPLE_GIT_HOOKS=1 git commit ...` 또는 `git commit --no-verify`.

**CI (`.github/workflows/spec-check.yml`)** — PR과 main push마다
`pnpm build` 후 `openapi.yaml` 생성 여부, YAML validation, 그리고
`git diff --exit-code openapi.yaml`로 yaml이 `.tsp`와 일치하는지 검증합니다.
누락된 경우 워크플로우가 실패하며, 로컬에서 `pnpm build` 다시 돌려 커밋하라는 안내가 표시됩니다.

## 배포 규칙

이 저장소는 spec 레포를 직접 checkout하지 않고도 백엔드가 version 고정으로
소비할 수 있게 GitHub Packages Maven registry에 artifact를 배포합니다.

- Maven coordinates: `com.bombom:bom-bom-api-spec:<version>`
- registry: `https://maven.pkg.github.com/Bombom-Team/bom-bom-api-spec`
- artifact 형식: `jar` (`zip`과 동일한 포맷)
- artifact 내부 파일명: `openapi.yaml` (루트에 고정)

백엔드는 artifact를 받은 뒤 unzip해서 `openapi.yaml`만 추출해
`openapi-generator` 입력으로 사용하면 됩니다.

예를 들어 Gradle Kotlin DSL에서는 다음처럼 version 고정으로 참조할 수 있습니다.

```kotlin
openapiSpec("com.bombom:bom-bom-api-spec:1.4.2")
```

### 릴리스 버저닝

- publish는 `vMAJOR.MINOR.PATCH` 형식의 Git tag에서만 실행됩니다.
- 실제 Maven version은 tag의 `v`를 제거한 값입니다.
  - 예: `v1.4.2` tag → `com.bombom:bom-bom-api-spec:1.4.2`
- `main`과 PR은 검증만 수행하고 publish하지 않습니다.
- 호환성 기준 권장안:
  - breaking change: `MAJOR`
  - backward-compatible spec 추가/확장: `MINOR`
  - 설명/오타/비기능 수정: `PATCH`

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
