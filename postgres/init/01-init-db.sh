#!/bin/bash
set -e # Para o script se qualquer comando falhar

# Usa as variáveis de ambiente para se conectar e executar o comando SQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE meu_segundo_db;
EOSQL
