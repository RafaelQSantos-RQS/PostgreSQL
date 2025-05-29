#!/bin/sh
set -e

# O $PGPASSFILE é definido no Dockerfile (ex: /app/.pgpass)
# Checa se o arquivo de senha não existe
if [ ! -f "$PGPASSFILE" ]; then
    echo "=> Arquivo .pgpass não encontrado. Criando a partir das variáveis de ambiente..."
    
    # Cria o arquivo com as credenciais do .env
    echo "database:5432:*:*:$POSTGRES_PASSWORD" > "$PGPASSFILE"
    
    # Define as permissões restritas, essenciais para a segurança
    chmod 0600 "$PGPASSFILE"
    
    echo "   Arquivo .pgpass criado com sucesso."
fi
# ----------------------------------------

echo "----------------------------------------"
echo "Processo de backup iniciado: $(date)"

# O resto do script continua igual, mas agora ele tem certeza que o .pgpass existe
if [ -n "$POSTGRES_MULTIPLE_DBS" ]; then
    for db in $POSTGRES_MULTIPLE_DBS; do
        echo "=> Iniciando backup para o banco de dados: '$db'"
        FILENAME="/backups/backup_${db}_$(date +%Y-%m-%dT%H-%M-%S).dump"
        pg_dump -h database -U "$POSTGRES_USER" -d "$db" -F c -b -v -w -f "$FILENAME"
        echo "   Backup do banco '$db' concluído: $FILENAME"
    done
else
    echo "=> Iniciando backup para o banco de dados único: '$POSTGRES_DB'"
    FILENAME="/backups/backup_${POSTGRES_DB}_$(date +%Y-%m-%dT%H-%M-%S).dump"
    pg_dump -h database -U "$POSTGRES_USER" -d "$POSTGRES_DB" -F c -b -v -w -f "$FILENAME"
    echo "   Backup do banco '$POSTGRES_DB' concluído: $FILENAME"
fi

echo "Processo de backup finalizado: $(date)"
echo "----------------------------------------"