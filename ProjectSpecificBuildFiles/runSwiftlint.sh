#!/bin/bash

if which swiftlint > /dev/null; then
    swiftlint || true
else
    echo "Swiftlint is not installed, download from https://github.com/realm/SwiftLint"
    exit 1;
fi
