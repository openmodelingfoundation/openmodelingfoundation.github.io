#!/usr/bin/env bash
set -euo pipefail

IFS=$'\n\t'

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
cd "$repo_root"

fonts_root="static/fonts"
tmpdir="$(mktemp -d)"

cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

mkdir -p "$fonts_root"

declare -a FONT_SPECS=()

font_spec() {
  FONT_SPECS+=("${1}|${2}|${3}|${4}|${5}")
}

download() {
  local url="$1"
  local out="$2"

  curl \
    --fail \
    --location \
    --silent \
    --show-error \
    --proto '=https' \
    --tlsv1.2 \
    "$url" \
    -o "$out"
}

verify_integrity() {
  local package_spec="$1"
  local tarball="$2"
  local expected_integrity expected_b64 actual_b64

  expected_integrity="$(npm view "$package_spec" dist.integrity --json | tr -d '"')"
  if [[ -z "$expected_integrity" || "$expected_integrity" == "null" ]]; then
    echo "Missing dist.integrity for $package_spec" >&2
    exit 1
  fi

  case "$expected_integrity" in
    sha512-*) expected_b64="${expected_integrity#sha512-}" ;;
    *)
      echo "Unexpected integrity format for $package_spec: $expected_integrity" >&2
      exit 1
      ;;
  esac

  actual_b64="$(openssl dgst -sha512 -binary "$tarball" | openssl base64 -A)"

  if [[ "$actual_b64" != "$expected_b64" ]]; then
    echo "Integrity mismatch for $package_spec" >&2
    echo "expected: $expected_integrity" >&2
    echo "actual:   sha512-$actual_b64" >&2
    exit 1
  fi
}

copy_license() {
  local package_dir="$1"
  local dest_dir="$2"

  for candidate in LICENSE OFL.txt LICENSE.txt LICENSE.md; do
    if [[ -f "$package_dir/$candidate" ]]; then
      install -m 0644 "$package_dir/$candidate" "$dest_dir/OFL.txt"
      return
    fi
  done

  echo "No license file found in $package_dir" >&2
  exit 1
}

install_family() {
  local display_name="$1"
  local family_slug="$2"
  local package="$3"
  local version="$4"
  local files_csv="$5"

  local package_spec="${package}@${version}"
  local tarball_url tarball unpack dest_dir

  tarball_url="$(npm view "$package_spec" dist.tarball --json | tr -d '"')"
  tarball="$tmpdir/${family_slug}.tgz"
  unpack="$tmpdir/${family_slug}"
  dest_dir="$fonts_root/$family_slug"

  mkdir -p "$dest_dir" "$unpack"
  download "$tarball_url" "$tarball"
  verify_integrity "$package_spec" "$tarball"
  tar -xzf "$tarball" -C "$unpack"

  local file
  IFS=',' read -r -a files <<< "$files_csv"
  for file in "${files[@]}"; do
    install -m 0644 "$unpack/package/files/$file" "$dest_dir/"
  done

  copy_license "$unpack/package" "$dest_dir"
  echo "Installed $display_name $version"
}

source "$script_dir/fonts.env"

for spec in "${FONT_SPECS[@]}"; do
  IFS='|' read -r display_name family_slug package version files_csv <<< "$spec"
  install_family "$display_name" "$family_slug" "$package" "$version" "$files_csv"
done

{
  echo "This directory contains self-hosted WOFF2 fonts used by the site."
  echo
  echo "Families:"
  for spec in "${FONT_SPECS[@]}"; do
    IFS='|' read -r display_name family_slug package version files_csv <<< "$spec"
    echo "- ${display_name} (${version})"
  done
  echo
  echo "Each family directory includes its upstream license file as OFL.txt."
} > "$fonts_root/README.md"

ls -lh \
  "$fonts_root/public-sans" \
  "$fonts_root/source-serif-4" \
  "$fonts_root/ibm-plex-mono"

echo "Font files and license files downloaded and installed successfully."
