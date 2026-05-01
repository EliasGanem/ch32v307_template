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
mkdir -p "$DEST_FOLDER"
rm -rf ${DEST_FOLDER:?}/*

# 2. Descarga selectiva usando la API de GitHub
curl -L "https://codeload.github.com/$REPO_OWNER/$REPO_NAME/tar.gz/$BRANCH" \
  | tar -xzC "$DEST_FOLDER" --strip-components=4 "$REPO_NAME-$BRANCH/$FOLDER_PATH"

if [ $? -eq 0 ]; then
    echo "✅ ¡Listo! Los archivos están en: $DEST_FOLDER"
    
    # 3. Renombrar extensiones .S a .s en vendor/Startup
    echo "🔄 Cambiando extensiones .S a .s en $DEST_FOLDER/Startup..."
    
    if [ -d "$DEST_FOLDER/Startup" ]; then
        # Buscamos archivos que terminen en .S y los renombramos
        find "$DEST_FOLDER/Startup" -name "*.S" -type f | while read -r file; do
            mv "$file" "${file%.S}.s"
        done
        echo "✨ Renombrado completado."
    else
        echo "⚠️ No se encontró la carpeta Startup dentro de $DEST_FOLDER"
    fi

    echo "📂 Contenido de la carpeta:"
    ls -R $DEST_FOLDER
else
    echo "❌ Hubo un error en la descarga."
fi