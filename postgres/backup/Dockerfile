# Etapa 1: Base
FROM postgres:17-alpine

# Etapa 2: Pacotes
RUN apk add --no-cache cronie

# Etapa 3: Diretório de backup
RUN mkdir -p /backups

# Etapa 4: Definir a variável de ambiente, como você sugeriu.
# Esta é a fonte da verdade para a nossa imagem.
ENV PGPASSFILE /app/.pgpass

# Etapa 5: Diretório de trabalho e cópia de scripts
WORKDIR /app
COPY backup.sh .
COPY crontab.txt .

# Etapa 6: Permissões
RUN chmod +x backup.sh && \
    crontab crontab.txt

# Etapa 7: O novo CMD que faz a "mágica" acontecer.
CMD printenv | grep -v "no_proxy" > /etc/environment && crond -f