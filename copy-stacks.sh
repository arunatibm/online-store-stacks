#!/usr/bin/env bash

# Fail fast on command errors, unset variables, and pipeline failures.
set -euo pipefail

# Resolve the script location so relative paths work from any current directory.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skip_existing=false

# Validate the required arguments and optional skip flag.
if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo "Usage: $0 <source-directory> <target-prefix> <copy-count> [--skip-existing]" >&2
  exit 1
fi

# Capture the positional arguments used to build the copy plan.
source_arg="$1"
target_prefix_arg="$2"
copy_count="$3"

# Enable skip mode only when the optional flag is provided.
if [[ $# -eq 4 ]]; then
  if [[ "$4" == "--skip-existing" ]]; then
    skip_existing=true
  else
    echo "Usage: $0 <source-directory> <target-prefix> <copy-count> [--skip-existing]" >&2
    exit 1
  fi
fi

# Accept either an absolute source path or one relative to the script directory.
if [[ "$source_arg" = /* ]]; then
  source_dir="$source_arg"
else
  source_dir="$script_dir/$source_arg"
fi

# Accept either an absolute target prefix or one relative to the script directory.
if [[ "$target_prefix_arg" = /* ]]; then
  target_prefix="$target_prefix_arg"
else
  target_prefix="$script_dir/$target_prefix_arg"
fi

# Stop early if the source directory does not exist.
if [[ ! -d "$source_dir" ]]; then
  echo "Source directory not found: $source_dir" >&2
  exit 1
fi

# Require a positive integer so the sequence generation is predictable.
if ! [[ "$copy_count" =~ ^[1-9][0-9]*$ ]]; then
  echo "Copy count must be a positive integer: $copy_count" >&2
  exit 1
fi

# In strict mode, fail before copying anything if any target already exists.
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

# Create each target directory by copying the source, optionally skipping conflicts.
for copy_number in $(seq 1 "$copy_count"); do
  target_dir="${target_prefix}${copy_number}"
  if [[ -e "$target_dir" ]]; then
    echo "Skipping existing directory: $target_dir"
    continue
  fi
  cp -R "$source_dir" "$target_dir"
  echo "Created $target_dir"
done