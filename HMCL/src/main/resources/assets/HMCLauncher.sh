#!/usr/bin/env bash

set -e

_HMCL_USE_CHINESE=true
_HMCL_OS="linux"
_HMCL_ARCH="x86_64";;
_HMCL_PATH="${BASH_SOURCE[0]}"
_HMCL_DIR=$(dirname "$_HMCL_PATH")
_HMCL_JAVA_EXE_NAME="java"

if [ -n "${HMCL_JAVA_OPTS+x}" ]; then
  _HMCL_VM_OPTIONS=${HMCL_JAVA_OPTS}
else
  _HMCL_VM_OPTIONS="-XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=15"
fi

function show_warning_console() {
    echo -e "\033[1;31m$1\033[0m" >&2
}

function show_warning_dialog() {}

function show_warning() {
    show_warning_console "$1: $2"
    show_warning_dialog "$1" "$2"
}

if [ -n "${HMCL_JAVA_HOME+x}" ]; then
  if [ -x "$HMCL_JAVA_HOME/bin/$_HMCL_JAVA_EXE_NAME" ]; then
    exec "$HMCL_JAVA_HOME/bin/$_HMCL_JAVA_EXE_NAME" $_HMCL_VM_OPTIONS -jar "$_HMCL_PATH"
  else
    show_warning "Error" "The value of the environment variable HMCL_JAVA_HOME is invalid"
    exit 1
  fi
fi

if [ -f "$JAVA_HOME/bin/$_HMCL_JAVA_EXE_NAME" ]; then
  exec "$JAVA_HOME/bin/$_HMCL_JAVA_EXE_NAME" $_HMCL_VM_OPTIONS -jar "$_HMCL_PATH"
fi

if [ -x "$(command -v $_HMCL_JAVA_EXE_NAME)" ]; then
  exec $_HMCL_JAVA_EXE_NAME $_HMCL_VM_OPTIONS -jar "$_HMCL_PATH"
fi

_HMCL_JAVA_DOWNLOAD_PAGE="$_HMCL_ARCH"
_HMCL_WARNING_MESSAGE="The Java runtime environment is required."
if [ -n "$_HMCL_JAVA_DOWNLOAD_PAGE" ]; then
  show_warning_console "Error" "$_HMCL_WARNING_MESSAGE"
  show_warning_dialog  "Error" "$_HMCL_WARNING_MESSAGE"
else
  show_warning "Error" "$_HMCL_WARNING_MESSAGE"
fi

exit 1
