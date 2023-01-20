#!/usr/bin/env sh
set -ex

coverage run --source=. test.py -v
coverage report