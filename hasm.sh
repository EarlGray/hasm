#!/bin/bash

EXEC="stack exec hasm"

RLWRAP=`which rlwrap`
[[ "$RLWRAP" ]] && RLWRAP="$RLWRAP -H .hasm_history"
exec $RLWRAP $EXEC
