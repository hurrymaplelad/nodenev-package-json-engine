EXAMPLE_PACKAGE_DIR="$BATS_TMPDIR/example_package"
TEST_BASENAME="$(basename $BATS_TEST_DIRNAME)"
# TODO: Should this just be $(dirname ...) ?
PLUGIN_ROOT="${BATS_TEST_DIRNAME%${TEST_BASENAME}}"

setup() {
  export NODENV_ROOT="$BATS_TMPDIR/nodenv_root"
  mkdir -p "$NODENV_ROOT/plugins"
  ln -s "$PLUGIN_ROOT" "$NODENV_ROOT/plugins/package-json-engine"
}

teardown() {
  rm -r "$EXAMPLE_PACKAGE_DIR"
  rm -r "$NODENV_ROOT"
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

# cd_into_package nodeVersion [extraArgs]
cd_into_package() {
  local version="$1"
  local packageJson="{
    \"engines\": {
      \"node\": \"${version}\"
    }
  }"
  mkdir -p "$EXAMPLE_PACKAGE_DIR"
  cd "$EXAMPLE_PACKAGE_DIR"
  echo "$packageJson" > "$EXAMPLE_PACKAGE_DIR/package.json"
}

# Creates fake version directory
create_version() {
  d="$NODENV_ROOT/versions/$1/bin"
  mkdir -p "$d"
  ln -s /bin/echo "$d/node"
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } >&2
  return 1
}
