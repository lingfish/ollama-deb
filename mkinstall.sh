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
      echo "tmp/lib/ollama/$f usr/lib/ollama/" >> debian/install
    fi
  done
}

# AMD64
do_bin
do_libs

# ARM64
for file in tmp-arm64/bin/*; do
  if [ -f "$file" ]; then
    f=$(basename -- "$file")
    echo "tmp-arm64/bin/$f usr/bin/" >> debian/install
  fi
done

# ARM64 libs
for file in tmp-arm64/lib/ollama/*; do
  if [ -f "$file" ]; then
    f=$(basename -- "$file")
    echo "tmp-arm64/lib/ollama/$f usr/lib/ollama/" >> debian/install
  fi
done

# ARM64 JetPack 5
for file in tmp-arm64-jetpack5/bin/*; do
  if [ -f "$file" ]; then
    f=$(basename -- "$file")
    echo "tmp-arm64-jetpack5/bin/$f usr/bin/" >> debian/install
  fi
done

# ARM64 JetPack 5 libs
for file in tmp-arm64-jetpack5/lib/ollama/*; do
  if [ -f "$file" ]; then
    f=$(basename -- "$file")
    echo "tmp-arm64-jetpack5/lib/ollama/$f usr/lib/ollama/" >> debian/install
  fi
done

# ARM64 JetPack 6
for file in tmp-arm64-jetpack6/bin/*; do
  if [ -f "$file" ]; then
    f=$(basename -- "$file")
    echo "tmp-arm64-jetpack6/bin/$f usr/bin/" >> debian/install
  fi
done

# ARM64 JetPack 6 libs
for file in tmp-arm64-jetpack6/lib/ollama/*; do
  if [ -f "$file" ]; then
    f=$(basename -- "$file")
    echo "tmp-arm64-jetpack6/lib/ollama/$f usr/lib/ollama/" >> debian/install
  fi
done
