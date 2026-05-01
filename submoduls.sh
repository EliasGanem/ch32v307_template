#!/bin/bash

# Configuración del repositorio de OpenWCH
REPO_OWNER="openwch"
REPO_NAME="ch32v307"
BRANCH="main"
# Ruta exacta a los archivos Core/Peripheral
FOLDER_PATH="EVT/EXAM/SRC"
DEST_FOLDER="./vendor"

echo "🚀 Iniciando descarga de archivos SRC para CH32V307..."

# 1. Crear carpeta de destino y limpiar si ya existía
mkdir -p $DEST_FOLDER
rm -rf ${DEST_FOLDER:?}/*

# 2. Descarga selectiva usando la API de GitHub (baja un tarball solo de esa subcarpeta)
# Usamos el endpoint de 'archive' filtrado por la ruta
curl -L "https://codeload.github.com/$REPO_OWNER/$REPO_NAME/tar.gz/$BRANCH" \
  | tar -xzC "$DEST_FOLDER" --strip-components=4 "$REPO_NAME-$BRANCH/$FOLDER_PATH"

if [ $? -eq 0 ]; then
    echo "✅ ¡Listo! Los archivos están en: $DEST_FOLDER"
    echo "📂 Contenido de la carpeta:"
    ls -F $DEST_FOLDER
else
    echo "❌ Hubo un error en la descarga."
fi