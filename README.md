# PostgreSQL as a Service - V1 (Nó Único)

## 📄 Descrição

Este projeto provisiona um serviço de banco de dados **PostgreSQL de nó único** utilizando Docker e Docker Compose. O objetivo é fornecer uma base robusta, segura e configurável, seguindo as melhores práticas de DevOps, que possa servir como a fundação para aplicações ou evoluir para arquiteturas mais complexas de alta disponibilidade.

## ✨ Features (Boas Práticas Implementadas)

- **Persistência Segura:** Utiliza um volume Docker externo para garantir que os dados do banco de dados não sejam perdidos quando os containers são recriados e para proteger contra a remoção acidental com `docker-compose down -v`.
- **Configuração Externalizada:** As configurações do PostgreSQL (`postgresql.conf`) são gerenciadas fora do container, permitindo que sejam versionadas em Git.
- **Segurança de Credenciais:** Nenhuma senha ou dado sensível é escrito diretamente no código. Todas as credenciais são carregadas a partir de um arquivo `.env`.
- **Flexibilidade e Parametrização:** O projeto é altamente configurável através de variáveis de ambiente, permitindo definir nomes de projeto, volumes, portas e tags de imagem de forma flexível.
- **Healthcheck Integrado:** O Docker Compose monitora a saúde do banco de dados, garantindo que o container só seja considerado "saudável" quando o Postgres estiver pronto para aceitar conexões.
- **Inicialização Customizável:** Suporte a scripts de inicialização (`.sh`, `.sql`) para criar bancos de dados, usuários ou tabelas na primeira execução do serviço.

## 🔧 Pré-requisitos

Para executar este projeto, você precisará ter instalado:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## 📁 Estrutura do Projeto

```
.
├── docker-compose.yml   # Arquivo principal que orquestra o serviço.
├── .env.example         # Template com as variáveis de ambiente necessárias.
├── .env                 # Arquivo local (NÃO versionado) com suas configurações.
├── postgres/
│   ├── postgresql.conf  # Configurações customizadas do Postgres.
│   └── init/
│       └── (opcional)   # Coloque aqui seus scripts .sh ou .sql de inicialização.
└── README.md            # Este arquivo de documentação.
```

## 🚀 Configuração e Setup

Siga os passos abaixo para configurar e iniciar o serviço.

**1. Clone este repositório (se aplicável)**
```bash
git clone <url-do-seu-repositorio>
cd <nome-do-repositorio>
```

**2. Crie seu arquivo de ambiente (`.env`)**

Copie o arquivo de exemplo para criar seu arquivo de configuração local.

```bash
cp .env.example .env
```
Agora, **edite o arquivo `.env`** com suas configurações. É crucial definir uma `POSTGRES_PASSWORD` segura.

**3. Crie o Volume Externo**

Este passo é fundamental para a persistência dos dados. O nome do volume deve ser o mesmo definido na variável `VOLUME_NAME` do seu arquivo `.env`.

```bash
# Leia o nome do volume do seu .env
source .env

# Crie o volume com uma etiqueta para organização
docker volume create --label project=${PROJECT_NAME} ${VOLUME_NAME}
```

## ▶️ Executando o Serviço

Com tudo configurado, você pode iniciar o serviço em modo "detached" (em segundo plano):

```bash
docker-compose up -d
```

**Outros comandos úteis:**

- **Verificar os logs em tempo real:**
  ```bash
  docker-compose logs -f database
  ```
- **Parar e remover os containers:**
  ```bash
  docker-compose down
  ```
  *(Lembre-se: este comando é seguro para seus dados, pois o volume é externo.)*

## 🔌 Conectando ao Banco de Dados

Você pode usar qualquer cliente de banco de dados (DBeaver, DataGrip, pgAdmin, psql) para se conectar ao serviço usando as credenciais definidas no seu arquivo `.env`.

- **Host:** `localhost` (ou o IP do seu servidor Docker)
- **Porta:** O valor de `DATABASE_PORT` (padrão: `5432`)
- **Usuário:** O valor de `POSTGRES_USER`
- **Senha:** O valor de `POSTGRES_PASSWORD`
- **Banco de Dados:** O valor de `POSTGRES_DB`

## 🛣️ Roadmap (Próximos Passos)

Esta é a Versão 1 do nosso serviço. Os próximos passos para evoluí-lo para um ambiente de produção ainda mais robusto incluem:

- [ ] **V1.1:** Implementar uma estratégia de **Backup e Restore** automatizados (ex: `pg_dump` via cron job para um S3).
- [ ] **V1.2:** Adicionar **Monitoramento e Observabilidade** (ex: Prometheus + Grafana).
- [ ] **V1.3:** Configurar **Logs Centralizados** (ex: ELK Stack ou Loki).
- [ ] **V2.0:** Evoluir para uma arquitetura de **Alta Disponibilidade (HA)** com Patroni.