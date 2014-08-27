#!/bin/bash

EXEC=dist/build/hasm/hasm

RLWRAP=`which rlwrap`
[[ "$RLWRAP" ]] && RLWRAP="$RLWRAP -H .hasm_history"
exec $RLWRAP $EXEC
