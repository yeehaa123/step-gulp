#!/bin/sh
gulp_command="gulp test"

debug "$gulp_command"

set +e
$gulp_command
result="$?"
set -e

if [[ result -ne 0 && result -ne 6 ]]
then
  warn "$result"
else
  success "finished $gulp_command"
fi
