#!/usr/bin/env bash
set -euo pipefail

version="${1:-${npm_package_version:-}}"
if [ -z "${version}" ]; then
  echo "version is required. Pass it as the first argument or run via pnpm so npm_package_version is available." >&2
  exit 1
fi

group_id="com.bombom"
artifact_id="bom-bom-api-spec"
spec_path="openapi.yaml"
publish_dir="build/maven"
jar_path="${publish_dir}/${artifact_id}-${version}.jar"
pom_path="${publish_dir}/pom.xml"

if [ ! -f "${spec_path}" ]; then
  echo "openapi.yaml not found. Run pnpm build first." >&2
  exit 1
fi

mkdir -p "${publish_dir}"
rm -f "${jar_path}" "${pom_path}"

jar --create --file "${jar_path}" "${spec_path}"

cat > "${pom_path}" <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>${group_id}</groupId>
  <artifactId>${artifact_id}</artifactId>
  <version>${version}</version>
  <packaging>jar</packaging>
  <name>BomBom API Spec</name>
  <description>Versioned OpenAPI artifact for BomBom backend and frontend code generation.</description>
</project>
EOF

echo "Created ${jar_path}"
echo "Created ${pom_path}"
