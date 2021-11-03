#!/bin/bash

exec python3 `dirname $0`/cull-idle-servers.py "$@"
