#!/bin/bash

set -e

explicit_run_cmd() {
  local cmd="$*"
  printf '%s\n' "$> $cmd"
  eval "$cmd"
}

# Convert "true"/"false" into command line args, returns "" if not defined
eval_boolean_action_input() {
	local -r input_name="$1"
	shift
	local -r flag_value="$1"
	shift
	local -r if_true="$1"
	shift
	local -r if_false="$1"

	if [ -z "$flag_value" ]; then
		printf ""
	elif [ "$flag_value" = "true" ]; then
		printf '%s\n' "$if_true"
	elif [ "$flag_value" = "false" ]; then
		printf '%s\n' "$if_false"
	else
		printf 'Error: Invalid value for input %s: %s is not "true" or "false\n"' \
			"$input_name" "$flag_value" >&2
		return 1
	fi
}

# Convert string input into command line args, returns "" if undefined
eval_string_input() {
	local -r input_name="$1"
	shift
	local -r if_defined="$1"
	shift
	local value
	value="$(printf '%s' "$1" | tr -d ' ')"

	if [ -z "$value" ]; then
		printf ""
		return 0
	fi

	printf '%s' "${if_defined/\%s/$value}"
}

# See https://github.com/actions/runner-images/issues/6775#issuecomment-1409268124
# and https://github.com/actions/runner-images/issues/6775#issuecomment-1410270956
git config --system --add safe.directory "*"

# Change to configured directory
cd "${INPUT_DIRECTORY}" || exit 1

# Make Token available as a correctly-named environment variables
export GH_TOKEN="${INPUT_GITHUB_TOKEN}"

# Bash array to store semantic release root options
ROOT_OPTIONS=()

if ! printf '%s\n' "$INPUT_VERBOSITY" | grep -qE '^[0-9]+$'; then
	printf "Error: Input 'verbosity' must be a positive integer\n" >&2
	exit 1
fi

VERBOSITY_OPTIONS=""
for ((i = 0; i < INPUT_VERBOSITY; i++)); do
	[ "$i" -eq 0 ] && VERBOSITY_OPTIONS="-"
	VERBOSITY_OPTIONS+="v"
done

ROOT_OPTIONS+=("$VERBOSITY_OPTIONS")

if [ -n "$INPUT_CONFIG_FILE" ]; then
	# Check if the file exists
	if [ ! -f "$INPUT_CONFIG_FILE" ]; then
		printf "Error: Input 'config_file' does not exist: %s\n" "$INPUT_CONFIG_FILE" >&2
		exit 1
	fi

	ROOT_OPTIONS+=("$(eval_string_input "config_file" "--config %s" "$INPUT_CONFIG_FILE")") || exit 1
fi

ROOT_OPTIONS+=("$(eval_boolean_action_input "no_operation_mode" "$INPUT_NO_OPERATION_MODE" "--noop" "")") || exit 1

# Bash array to store publish arguments
PUBLISH_ARGS=()
PUBLISH_ARGS+=("$(eval_string_input "tag" "--tag %s" "$INPUT_TAG")") || exit 1

# Run Semantic Release
explicit_run_cmd "$PSR_VENV_BIN/semantic-release ${ROOT_OPTIONS[*]} publish ${PUBLISH_ARGS[*]}"
