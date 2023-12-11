#!/bin/bash
# moves given file to a timestamped version of itself.
set -eux
test -f "$1" && mv "$1" "$1.$(date +%s)"
