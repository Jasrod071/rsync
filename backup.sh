#!/bin/bash

# 1. Configuración de variables
# Permite pasar el día como parámetro o detectarlo automáticamente 
DIA=${1:-$(date +%A | tr '[:upper:]' '[:lower:]')}
AYER=$(date -d "yesterday" +%A | tr '[:upper:]' '[:lower:]')
FECHA_REMOTO=$(date +%Y-%m-%d)
LOG="/var/log/backup-jsanrod.log" 
ORIGEN="/root/datos/" 
DESTINO="/backup/$DIA/" 

# Asegurar que el directorio de logs existe
touch $LOG

echo "--- INICIO BACKUP: $(date) ---" >> $LOG
echo "Día detectado: $DIA" >> $LOG

# 2. Lógica de Copias de Seguridad
if [[ "$DIA" =~ ^(monday|lunes)$ ]]; then
    echo "Tipo: Copia Completa (Lunes)" >> $LOG
    # Copia completa local 
    rsync -av --delete "$ORIGEN" "$DESTINO" >> $LOG 2>&1

    # TAREA ADICIONAL 1: Copia remota vía SSH 
    # Reemplaza 'IP_BACKUP' por la IP de tu segundo contenedor
    echo "Iniciando copia remota..." >> $LOG
    rsync -avz "$ORIGEN" root@IP_BACKUP:/backup/backup-$FECHA_REMOTO/ >> $LOG 2>&1

else
    echo "Tipo: Copia Incremental (Referencia: $AYER)" >> $LOG 
    # Copia incremental usando hard links al día anterior para ahorrar espacio 
    rsync -av --delete --link-dest="/backup/$AYER/" "$ORIGEN" "$DESTINO" >> $LOG 2>&1
fi

echo "--- FIN BACKUP: $(date) ---" >> $LOG
echo "--------------------------------------" >> $LOG
