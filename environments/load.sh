#!/bin/sh

load() {
  while IFS= read -r line; do
    environments_load_key="${line%=*}"
    environments_load_value="${line#*=}"
    environments_load_value_trim_quote=$(echo "$environments_load_value" | sed -e 's/^"//' -e 's/"$//')
    if [ "$environments_load_key" != "" ]; then
      export "$environments_load_key=$environments_load_value_trim_quote"
      if [ "$2" != "" ]; then
        echo "$environments_load_key=$environments_load_value_trim_quote" >>"$2"
      fi
    fi
  done <$1
}

load ".common/.env" "$2"
if [ "$1" != "" ]; then
  load "$1/.env" "$2"
fi