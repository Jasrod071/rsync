#!/bin/bash

# Comprobar si se ha pasado el día como argumento 
if [ -z "$1" ]; then
    echo "Uso: $0 <dia_a_recuperar>"
    exit 1
fi

DIA=$1
ORIGEN_BACKUP="/backup/$DIA/"
DESTINO_DATOS="/root/datos/"

echo "Recuperando copia del día: $DIA..."

# 1. Borrar datos actuales (simulación de pérdida) 
rm -rf ${DESTINO_DATOS}*

# 2. Restaurar desde el backup [cite: 85]
if [ -d "$ORIGEN_BACKUP" ]; then
    rsync -av "$ORIGEN_BACKUP" "$DESTINO_DATOS"
    echo "Restauración completada con éxito."
else
    echo "Error: No existe copia de seguridad para el día $DIA."
fi
