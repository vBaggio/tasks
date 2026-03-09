# Desafio Técnico Delphi - Tasks App

Projeto Full-Stack Delphi desenvolvido como solução para prova técnica. Ele engloba a gestão de Tarefas (CRUD), contando com indicadores de estatísticas.

O projeto foi dividido em duas pontas: um **Backend (API REST)** e um **Frontend (Cliente VCL)**. A comunicação entre ambos é feita unicamente via JSON.

---

## Arquitetura e Estrutura

```text
📦 tasks
 ┣ 📂 backend
 ┃ ┣ 📂 bin
 ┃ ┣ 📂 modules
 ┃ ┣ 📂 src
 ┃ ┃ ┣ 📂 controller
 ┃ ┃ ┣ 📂 infra
 ┃ ┃ ┣ 📂 model
 ┃ ┃ ┣ 📂 repository
 ┃ ┃ ┗ 📂 service
 ┃ ┣ 📂 tests
 ┃ ┗ 📜 TasksAPI.dpr
 ┣ 📂 frontend
 ┃ ┣ 📂 bin
 ┃ ┣ 📂 modules
 ┃ ┣ 📂 src
 ┃ ┃ ┣ 📂 client
 ┃ ┃ ┣ 📂 controller
 ┃ ┃ ┣ 📂 model
 ┃ ┃ ┗ 📂 view
 ┃ ┗ 📜 TasksClient.dpr
 ┣ 📜 docker-compose.yml
 ┗ 📜 README.md
```

### Backend (Horse + FireDAC)
Construído utilizando o clássico padrão de **Arquitetura em 3 Camadas (3-Tier Architecture)** focado em APIs, separando perfeitamente a exposição HTTP, a lógica de negócios e a persistência:
- **Controller:** Ponto de entrada (endpoints). Responsável pelo roteamento gerido pelo middleware do Horse, tratando requisições e formatando respostas JSON.
- **Service:** Onde habitam as regras de negócio. Orquestra a lógica isolada da persistência, intermediando as requisições dos Controllers para os Repositórios.
- **Repository:** Camada de acesso a dados, responsável por executar as query SQLs e traduzir os retornos de banco para as entidades (Models) do sistema.
- **Model:** Entidades e DTOs que representam os dados do sistema.
- **Infra:** Camada que contém implementações de infraestrutura, como a conexão com o banco de dados e as migrações.

**Alta Concorrência e Escalabilidade:** 
A API foi projetada para processar múltiplas requisições simultâneas sem bloqueios (*Thread Locks*). Para isso, foi implementado um ciclo de vida transiente nas injeções de dependências (*Transient DI*): cada requisição HTTP aciona Fábricas que instanciam seus próprios Serviços e Repositórios, obtendo uma conexão isolada com o MSSQL através do **Connection Pooling nativo do FireDAC**. Essa arquitetura isola o tráfego, elimina gargalos de concorrência e garante estabilidade.

**Testes Unitários (DUnitX):**
O backend conta com testes unitários desenvolvidos com o framework nativo **DUnitX** e biblioteca externa [Delphi Mocks](https://github.com/VSoftTechnologies/Delphi-Mocks). Devido à restrição de tempo máximo de entrega, a cobertura priorizou apenas a regra de negócio central da aplicação: o **`TaskService`**. A arquitetura do projeto baseada em *Interfaces* facilitou a criação de testes robustos que não dependem do banco de dados. Os repositórios irreais (*Mocks*) foram injetados simulando o comportamento do MSSQL, o projeto de testes está localizado no diretório `/backend/tests`. 

### Frontend (VCL + RESTRequest4Delphi)
Construído utilizando padrão MVC (Model-View-Controller):
- **Model:** DTOs para receber os dados da requisição e Exceptions personalizadas.
- **View:** Interface gráfica e componentes visuais.
- **Controller:** Intermediador entre View e Client HTTP.
- **Client:** Client HTTP responsável por fazer as requisições para a API.

**User Interface (UI):** 
O design prioriza a leveza estética, tipografia limpa e fácil acesso sem poluição visual.

**Assincronismo (PPL):** 
Requisições com alto volume de dados ou interações com a API (como marcar as Tarefas e as chamadas de atualização das estatísticas) são intermediadas por `System.Threading.TTask`. Assinaturas de *Callbacks* em `TThread.Queue` cuidam da alteração dos formulários VCL sem travar a interface do usuário. Você pode acessar e re-clicar nas checkboxes sem engasgos de rede, contando com *Rollbacks* visuais em caso de falha de conexão.

**Data Transfer Objects (DTO):**
A extração de dados não vem acoplada à persistência (o frontend dispensa *MemTables* acopladas ao banco). A formatação do texto (Datas relativas, status) já é processada no *Modelo DTO* assincronamente.

---

## Padrões de Projeto (Design Patterns)
Este projeto exibe domínio sólido na orientação a objetos (POO), empregando diversos padrões arquiteturais:

- **Abstract Factory:** Implementado na arquitetura do Backend (`TasksAPI.Factory.*`). Contratos (`IServiceFactory`, `IRepositoryFactory`, `IConnectionFactory`) encapsulam a criação das instâncias transientes (Services e Repositories de `Tasks` e `User`). Desacoplando o ecossistema inteiro e facilitando Mocking de testes unitários.
- **Dependency Injection (DI):** Princípio de Inversão de Controle amplamente aplicado. O Controlador não conhece a regra de instanciar os repositórios; recebe apenas a fábrica pronta via construtor (Injeção de dependência via Construtor e Factories).
- **Transient DI:** O ciclo de vida do Serviço morre no fim da requisição.
- **Singleton (GoF):** Utilizado de forma nativa/contextual pelo FireDAC (em seu `FDManager`) para administrar as conexões ociosas em *Pool*, e no Startup estático da API para manter os Middlewares globais como o *HorseBasicAuthentication*.
- **Observer / Callbacks:** O Controller do VCL dispara eventos genéricos e processa Callbacks Anônimos para avisar a View de que a thread VCL principal precisa ser atualizada após processamentos longos no background.

---

## Tecnologias e Dependências

A aplicação foi desenvolvida no **Delphi 10.3 Rio**. No desenvolvimento, foi utilizado o **Microsoft SQL Server 2022**.

> [!WARNING]
> **Aviso de Compilação:** O projeto **NÃO** poderá ser compilado no *Delphi Community*, pois a edição não contempla o driver FireDAC para o SQL Server.

> [!NOTE]
> **Gerenciamento de Pacotes:** Todas as bibliotecas de terceiros listadas abaixo dependem do **Boss** (Dependency Manager para Delphi) para funcionarem. Elas devem ser restauradas via linha de comando (`boss install`), conforme detalhado mais adiante no Guia de Setup.

### Dependências Backend
- [Horse](https://github.com/HashLoad/horse) - Framework web extremamento rápido para criar APIs REST em Delphi.
- [Horse Basic Auth](https://github.com/HashLoad/horse-basic-auth) - Middleware para proteção das rotas contra acessos não autorizados.
- [Handle Exception](https://github.com/HashLoad/handle-exception) - Middleware global adotado no projeto para centralizar, catalogar e padronizar o payload de erros HTTP (`Status 500, 404, 401...`) lançados pelas APIs (*Exceptions* do código).
- [Neon](https://github.com/paolo-rossi/delphi-neon) - Biblioteca de serialização em JSON com suporte a records.
- [Delphi Mocks](https://github.com/VSoftTechnologies/Delphi-Mocks) - Biblioteca para criação de mocks para testes unitários. (Usado apenas no projeto de testes unitários)

### Dependências Frontend
- [RESTRequest4Delphi](https://github.com/viniciussanchez/RESTRequest4Delphi) - Biblioteca para abstração de consumo de APIs REST.
- [Neon](https://github.com/paolo-rossi/delphi-neon) - Biblioteca de serialização em JSON com suporte a records.

---

## Guia de Setup e Execução

> [!NOTE]
> Para facilitar a avaliação, os **executáveis foram pré-compilados** e disponibilizados na pasta `/bin` de cada respectivo projeto, caso não queira compilar.

### 1. Restaurando Dependências (Boss)
Caso queira abrir os projetos em sua IDE, compilar ou inspecionar o código fonte do zero, é necessário instalar as dependências de terceiros usando o gerenciador de pacotes [Boss](https://github.com/HashLoad/boss). Abra o terminal e execute:
```bash
cd backend
boss install

cd ../frontend
boss install
```

### 2. Iniciar o Banco de Dados
A aplicação requer uma instância do Microsoft SQL Server. Para facilitar, na raiz do repositório existe um arquivo `docker-compose.yml` pré-configurado. Se desejar usar o Docker, basta executar:
```bash
docker-compose up -d
```
*(Caso queira usar uma instalação já existente do MSSQL Server, basta apontar as credenciais para o seu servidor no arquivo `TasksAPI.ini`, pulando a etapa do Docker. O sistema se encarregará de auto-criar o banco de dados (com o nome definido no `.ini`) e as tabelas em tempo de execução, caso não existam).*

### 3. Configurações de Acesso (.ini)
- Em `backend/bin` existe o arquivo `TasksAPI.ini`, onde é possível configurar as credenciais do banco de dados (Sessão `[Database]`) e a porta do servidor da API (Sessão `[Server]`, Padrão: 9000).
- Em `frontend/bin` existe o arquivo `TasksClient.ini`, onde é possível configurar a url da API e as credenciais de autenticação.

Ambos são autogerados na primeira execução, mas também estão presentes no repositório, pré-configurados com valores padrão.

### 4. Rodando o Backend (Migrate Automático)
Acesse a pasta `backend/bin/` e inicie o executável **`TasksAPI.exe`**.
- O sistema exibirá o log *"Testando conexão inicial e preparando tabelas do banco..."*.
- Nos bastidores, a ferramenta executa silenciosamente o arquivo _`TasksAPI.Database.SetupMSSQL.pas`_. Ele é responsável por verificar a infraestrutura e auto-criar tanto a *database* quanto as tabelas necessárias em tempo de execução, permitindo que a aplicação suba pronta para uso.

### 5. Abrindo o Frontend
Acesse a pasta `frontend/bin/` e execute o **`TasksClient.exe`**.
- As estatísticas (Dashboards no topo), as filtragens e os Checklists já aparecerão renderizados comunicando com a API instantaneamente.

### Login de Teste
A camada de **Autenticação (Auth Service)** do Backend já foi construída e abstraída para validar solicitações usando o *Horse Basic Auth*. Para fins de demonstração na prova técnica, há um usuário inicial validado (*hardcoded* na implementação inicial):
- **Usuário:** `admin`
- **Senha:** `123456`

> [!NOTE]
> O Frontend já vem pré-configurado com as credenciais padrão através do arquivo `TasksClient.ini`. É possível provocar falhas de autenticação propositalmente alterando a senha diretamente lá e observando o comportamento da aplicação ao receber o *Status 401 Unauthorized*.
