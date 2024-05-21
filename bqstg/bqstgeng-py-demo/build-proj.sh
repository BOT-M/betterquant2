#!/bin/bash
set -u
set -e

readonly SOLUTION_ROOT_DIR=/home/jasper/work/betterquant2

black stgeng-10000.py
cp stgeng-10000.py $SOLUTION_ROOT_DIR/bin/
