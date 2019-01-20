#!/usr/bin/env bats

load test_helper

@test 'Recognizes simple node version specified in package.json engines' {
  in_package_for_engine 4.2.1

  run nodenv package-json
  assert_success
  assert_output '4.2.1'
}

@test 'Prefers the greatest installed version matching a range' {
  in_package_for_engine '^4.0.0'

  run nodenv package-json
  assert_success
  assert_output '4.2.1'
}

@test 'Ignores non-matching installed versions' {
  in_package_for_engine '^1.0.0'

  run nodenv package-json
  assert_failure
  assert_output "package-json-engine: no version found satisfying \`^1.0.0'"
}

@test 'Does not match arbitrary "node" key in package.json' {
  in_package_with_babel_env

  run nodenv package-json

  assert_failure
  assert_output 'package-json-engine: no engine version configured for this package'
}

@test 'Handles malformed package.json' {
  in_example_package

  # non json
  echo "foo" > package.json
  run nodenv package-json
  assert_failure
  assert_output 'package-json-engine: no engine version configured for this package'

  # malformed
  echo "{" > package.json
  run nodenv package-json
  assert_failure
  assert_output 'package-json-engine: no engine version configured for this package'
}

@test 'Handles multiple occurrences of "node" key' {
  in_example_package
  cat << JSON > package.json
{
  "engines": {
    "node": "4.2.1"
  },
  "presets": [
    ["env", {
      "targets": {
        "node": "current"
      }
    }]
  ]
}
JSON

  run nodenv package-json
  assert_success
  assert_output '4.2.1'
}
