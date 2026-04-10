#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skip_existing=false

if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo "Usage: $0 <source-directory> <target-prefix> <copy-count> [--skip-existing]" >&2
  exit 1
fi

source_arg="$1"
target_prefix_arg="$2"
copy_count="$3"

if [[ $# -eq 4 ]]; then
  if [[ "$4" == "--skip-existing" ]]; then
    skip_existing=true
  else
    echo "Usage: $0 <source-directory> <target-prefix> <copy-count> [--skip-existing]" >&2
    exit 1
  fi
fi

if [[ "$source_arg" = /* ]]; then
  source_dir="$source_arg"
else
  source_dir="$script_dir/$source_arg"
fi

if [[ "$target_prefix_arg" = /* ]]; then
  target_prefix="$target_prefix_arg"
else
  target_prefix="$script_dir/$target_prefix_arg"
fi

if [[ ! -d "$source_dir" ]]; then
  echo "Source directory not found: $source_dir" >&2
  exit 1
fi

if ! [[ "$copy_count" =~ ^[1-9][0-9]*$ ]]; then
  echo "Copy count must be a positive integer: $copy_count" >&2
  exit 1
fi

if [[ "$skip_existing" == false ]]; then
  for copy_number in $(seq 1 "$copy_count"); do
    target_dir="${target_prefix}${copy_number}"
    if [[ -e "$target_dir" ]]; then
      echo "Target directory already exists: $target_dir" >&2
      echo "Re-run with --skip-existing to leave existing directories untouched." >&2
      exit 1
    fi
  done
fi

for copy_number in $(seq 1 "$copy_count"); do
  target_dir="${target_prefix}${copy_number}"
  if [[ -e "$target_dir" ]]; then
    echo "Skipping existing directory: $target_dir"
    continue
  fi
  cp -R "$source_dir" "$target_dir"
  echo "Created $target_dir"
done