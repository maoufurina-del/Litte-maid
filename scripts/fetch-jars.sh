#!/usr/bin/env bash
set -eu

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
LIBS_DIR="$ROOT_DIR/libs"
mkdir -p "$LIBS_DIR"

PROPS_FILE="$ROOT_DIR/gradle.properties"
function prop() {
  local key="$1"
  if [ -f "$PROPS_FILE" ]; then
    awk -F'=' -v k="$key" '$1==k{print substr($0,index($0,"=")+1)}' "$PROPS_FILE" | tr -d '\r' || true
  fi
}

ARCHITECTURY_VER=$(prop architectury_api_version || echo "4.3.61")
FORGE_CONFIG_VER=$(prop forge_config_api_port_version || echo "21.11.1")
GECKOLIB_VER=$(prop geckolib_version || echo "5.4.5")

declare -a artifacts
artifacts=(
  "architectury:${ARCHITECTURY_VER}:dev/architectury/architectury"
  "forge-config-api-port:${FORGE_CONFIG_VER}:maven/modrinth/forge-config-api-port"
  "geckolib-fabric:${GECKOLIB_VER}:software/bernie/geckolib-fabric"
)

function try_download() {
  local gavpath="$1"
  local ver="$2"
  local target="$3"

  local maven_url="https://repo1.maven.org/maven2/${gavpath}/${ver}/${gavpath##*/}-${ver}.jar"
  echo "Trying Maven Central: $maven_url"
  if curl -fsSL "$maven_url" -o "$target"; then
    echo "Downloaded $target from Maven Central"
    return 0
  fi

  local jitpack_url="https://jitpack.io/com/${gavpath}/${ver}/${gavpath##*/}-${ver}.jar"
  echo "Trying JitPack: $jitpack_url"
  if curl -fsSL "$jitpack_url" -o "$target"; then
    echo "Downloaded $target from JitPack"
    return 0
  fi

  local terraformers_url="https://maven.terraformersmc.com/${gavpath}/${ver}/${gavpath##*/}-${ver}.jar"
  echo "Trying Terraformers: $terraformers_url"
  if curl -fsSL "$terraformers_url" -o "$target"; then
    echo "Downloaded $target from Terraformers"
    return 0
  fi

  return 1
}

for entry in "${artifacts[@]}"; do
  IFS=":" read -r short ver path <<< "$entry"
  target_file="$LIBS_DIR/${short}-${ver}.jar"
  if [ -f "$target_file" ]; then
    echo "$target_file already exists — skip"
    continue
  fi
  if try_download "$path" "$ver" "$target_file"; then
    echo "OK: $target_file"
  else
    echo "WARN: failed to download $short $ver — please add manually to ./libs if build fails"
  fi
done

ls -1 "$LIBS_DIR" || true
