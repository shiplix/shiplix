#!/bin/bash
set -e

source /home/worker/.rvm/scripts/rvm
rvm use 2.3.0

exec "$@"
