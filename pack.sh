#!/usr/bin/env bash
set -e
zip -r dist/LuaVM-FunctionTester-Production.zip . -x .git/* dist/*
echo "Packaged into dist/LuaVM-FunctionTester-Production.zip"
