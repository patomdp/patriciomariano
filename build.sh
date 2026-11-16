#!/usr/bin/env bash
# Build para Cloudflare Pages: copia el sitio estático a dist/ sin archivos privados
# (proyectos de Mobirise, historial, config de Firebase) ni imágenes de más de 25 MB,
# que es el límite por archivo de Cloudflare Pages.
set -euo pipefail
rm -rf dist
mkdir -p dist
tar \
  --exclude=./dist \
  --exclude=./.git \
  --exclude=./.github \
  --exclude=./history \
  --exclude='*.mobirise' \
  --exclude='*.mobirise_history' \
  --exclude=./firebase.json \
  --exclude=./.firebaserc \
  --exclude=./build.sh \
  --exclude=./wrangler.jsonc \
  --exclude=./README.md \
  --exclude=./screenshot.png \
  --exclude='screen-.png' \
  -cf - . | tar -xf - -C dist
# Seguridad extra: no publicar nada que supere el límite de 25 MB de Pages.
find dist -type f -size +25M -print -delete
echo "dist listo: $(find dist -type f | wc -l) archivos, $(du -sh dist | cut -f1)"
