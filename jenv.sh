#!/bin/bash

# Function to extract environment variables as command line arguments
extract_env_args() {
  local args=""

  # Iterate over all environment variables
  for env in $(printenv); do
    # Split the environment variable into a name and value
    local name=$(echo $env | cut -d'=' -f1)
    local value=$(echo $env | cut -d'=' -f2)

    # Check if the name starts with a dash
    if [[ ! "$name" =~ ^- ]]; then
      # Append the argument to the list of args
      args="$args --arg $name \"$value\""
    fi
  done

  # Return the final list of args
  echo "$args"
}

# Declare a function to execute the jq command with the arguments
execute_jq() {
  # Check if any arguments were passed to the function
  if [ $# -eq 0 ]; then
    # Display an error message and exit with a non-zero exit code
    echo "Error: No arguments were passed to jenv" >&2
    exit 1
  fi

  # Extract the environment variables as arguments
  local args=$(extract_env_args)

  # Store the last argument in a separate variable
  local last_arg=${!#}

  # Remove the last argument from the list of arguments
  local base="$@"
  last_arg_len=${#last_arg}
  result=${base:0:${#base}-$last_arg_len}

  # Append any remaining optional arguments passed to the function
  args="$args $result"

  # Execute the command with the arguments
  #echo "jq -n $args '$last_arg'"
  eval "jq -n $args '$last_arg'"
}

wrap_execute_jq() {
  # Initialize a variable to store the presence of the -w flag
  local wrap=false

  # Initialize an empty array to store the remaining arguments
  local remaining_args=()

  # Iterate over the arguments
  for arg in "$@"; do
    # If the argument is -w, set the wrap variable to true
    if [ "$arg" = "-w" ]; then
      wrap=true
      continue
    fi

    # Otherwise, add the argument to the remaining_args array
    remaining_args+=("$arg")
  done

  # Call execute_jq with the remaining arguments and store the result in a variable
  local result=$(execute_jq "${remaining_args[@]}")

  # If the -w flag was present, wrap the result in single quotes and echo it
  if [ "$wrap" = true ]; then
    echo "'$result'"
  else
    # Otherwise, just echo the result
    echo "$result"
  fi
}
# Call the execute_jq function with any optional jq arguments
wrap_execute_jq "$@"
