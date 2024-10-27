#!/bin/bash

rm -f debian/install

do_bin () {
  for file in tmp/bin/*; do
    # Skip directories (only process files)
    if [ -f "$file" ]; then
      f=$(basename -- "$file")
      echo "tmp/bin/$f usr/bin/" >> debian/install
    fi
  done
}

do_libs () {
  for file in tmp/lib/ollama/*; do
    # Skip directories (only process files)
    if [ -f "$file" ]; then
      f=$(basename -- "$file")
      echo "tmp/lib/ollama/$f usr/lib/" >> debian/install
    fi
  done
}

do_bin
