#!/bin/bash

# Configuración del repositorio de OpenWCH
REPO_OWNER="openwch"
REPO_NAME="ch32v307"
BRANCH="main"

# Rutas de origen y destino
SRC_FOLDER_PATH="EVT/EXAM/SRC"
SYSTEM_FILES_PATH="EVT/EXAM/GPIO/GPIO_Toggle/User"
DEST_FOLDER="./vendor"
CORE_FOLDER="$DEST_FOLDER/Core"

echo "🚀 Iniciando descarga de archivos para CH32V307..."

# 1. Crear estructura de carpetas y limpiar
mkdir -p "$DEST_FOLDER"
mkdir -p "$CORE_FOLDER"
rm -rf ${DEST_FOLDER:?}/*
mkdir -p "$CORE_FOLDER" # Recreamos Core tras la limpieza

# 2. Descarga de la carpeta SRC (Startup, Peripheral, etc.)
curl -L "https://codeload.github.com/$REPO_OWNER/$REPO_NAME/tar.gz/$BRANCH" \
  | tar -xzC "$DEST_FOLDER" --strip-components=4 "$REPO_NAME-$BRANCH/$SRC_FOLDER_PATH"

# 3. Descarga de archivos de sistema específicos (system_ch32v30x.c/h)
echo "📦 Descargando archivos de sistema en $CORE_FOLDER..."
RAW_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$SYSTEM_FILES_PATH"

curl -sL "$RAW_URL/system_ch32v30x.c" -o "$CORE_FOLDER/system_ch32v30x.c"
curl -sL "$RAW_URL/system_ch32v30x.h" -o "$CORE_FOLDER/system_ch32v30x.h"

if [ $? -eq 0 ]; then
    echo "✅ ¡Listo! Archivos descargados."
    
    # 4. Renombrar extensiones .S a .s en vendor/Startup
    if [ -d "$DEST_FOLDER/Startup" ]; then
        echo "🔄 Cambiando extensiones .S a .s en $DEST_FOLDER/Startup..."
        find "$DEST_FOLDER/Startup" -name "*.S" -type f | while read -r file; do
            mv "$file" "${file%.S}.s"
        done
        echo "✨ Renombrado completado."
    fi
else
    echo "❌ Hubo un error en la descarga."
fi