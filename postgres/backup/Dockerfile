# Etapa 1: Imagem Base
FROM postgres:17-alpine

# =================================================================
# SEÇÃO DE SETUP (EXECUTADA COMO ROOT)
# =================================================================

# Etapa 2: Instalar pacotes e criar diretórios
RUN apk add --no-cache cronie && \
    mkdir -p /backups

# Etapa 3: Copiar todos os arquivos da aplicação
WORKDIR /app
COPY backup.sh .
COPY crontab.txt .

# Etapa 4: Criar usuário e definir todas as permissões de uma vez
RUN addgroup -S backupgroup && adduser -S backupuser -G backupgroup && \
    # Mudar o dono das pastas e arquivos necessários para o novo usuário
    chown -R backupuser:backupgroup /app /backups && \
    # Tornar o script de backup executável
    chmod +x /app/backup.sh

# =================================================================
# SEÇÃO DE EXECUÇÃO (EXECUTADA COMO USUÁRIO NÃO-ROOT)
# =================================================================

# Etapa 5: Mudar para o usuário não-root
# USER backupuser # Consertar depois

# Etapa 6: Como 'backupuser', instalar o seu próprio crontab
RUN crontab /app/crontab.txt

# Etapa 7: Definir a variável de ambiente (o 'backupuser' a herdará)
ENV PGPASSFILE /app/.pgpass

# Etapa 8: Comando final para iniciar o serviço
CMD touch /app/cron.log && crond -f
