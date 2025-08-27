# Authenticated Service Deployment Demo

This demo showcases a minimal compose-based service using GitHub OAuth Device Flow for authentication. Upon successful device flow login, the service internally mints a narrowly scoped token for each authenticated user, restricting resource access to only their own data. Deployment is automated to Hetzner via Infrastructure as Code and a GitOps pull-based Terraform module, enabling hands-off deployment through branch promotion.

The system is intended as an end-to-end example of a basic RESTful service, with resources securely scoped to users authenticated through GitHub.

## Overview

- [Setup Steps](#setup-steps)
  - [Local Development](#local-development)
  - [Deploy](#deploy)
  - [Teardown](#teardown)
- [Stack](#stack)
- [Out of Scope](#out-of-scope)

## Setup Steps

> [!IMPORTANT]
> If not using Dev Containers **or** you have Nix installed. You have to ensure dependencies are installed.
>
> - [Git](https://git-scm.com/)
> - [Docker Compose](https://docs.docker.com/compose/)
> - [.NET SDK 9.x.x](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)
> - [Terraform](https://www.terraform.io/)

### Local Development

1. Spin up services

```sh
docker compose up
```

2. Query Endpoints

**Authentication**

| Method | Endpoint                    | Access | Request Schema | Response Schema |
| ------ | --------------------------- | ------ | -------------- | --------------- |
| POST   | http://localhost/auth/login | Open   | -              | (TBD)           |
| POST   | http://localhost/auth/token | Open   | (TBD)          | (TBD)           |

<details>
<summary>Schemas</summary>

- **POST /auth/login**

  - Request:
    ```json
    {}
    ```
  - Response:
    ```json
    {}
    ```

- **POST /auth/token**
  - Request:
    ```json
    {}
    ```
  - Response:
    ```json
    {}
    ```

</details>

**Thought Resource**

| Method | Endpoint                      | Access                  | Request Schema | Response Schema |
| ------ | ----------------------------- | ----------------------- | -------------- | --------------- |
| GET    | http://localhost/thought      | Open                    | -              | (TBD)           |
| POST   | http://localhost/thought      | Authenticated           | (TBD)          | (TBD)           |
| PUT    | http://localhost/thought/{id} | Authenticated and Owner | (TBD)          | (TBD)           |
| DELETE | http://localhost/thought/{id} | Authenticated and Owner | -              | (TBD)           |

<details>
<summary>Schemas</summary>

- **POST /thought**

  - Request:
    ```json
    {}
    ```
  - Response:
    ```json
    {}
    ```

- **PUT /thought/{id}**

  - Request:
    ```json
    {}
    ```
  - Response:
    ```json
    {}
    ```

- **GET /thought**

  - Response:
    ```json
    {}
    ```

- **DELETE /thought/{id}**
  - Response:
    ```json
    {}
    ```

</details>

### Deploy

> [!NOTE]
> Only needed once, or after updating infrastructure configuration

1. Prepare credentials and configuration

   1. Make your repository web-accessible:

      - Publish this repo to a public Git platform.
      - Update the repository URL in [./infrastructure/main.tf](/infrastructure/main.tf).

   2. Set up Infrastructure as Code (IaC) credentials:
      - Obtain a Hetzner API token (requires a Hetzner account).
      - Add the token to [./infrastructure/.auto.tfvars](/infrastructure/.auto.tfvars).

2. Apply the configuration

```sh
terraform -chdir=infrastructure apply
```

### Teardown

```sh
terraform -chdir=infrastructure destroy
```

## Stack

**Development**:

- [Git](https://git-scm.com/): Distributed version control system
- [Nix](https://nixos.org/) (**optional**): Used for declarative development environments. If not using Nix, install dependencies manually.
- [VS Code](https://code.visualstudio.com/): Integrated Development environment
  - Extension - [SQLite Viewer](https://marketplace.visualstudio.com/items?itemName=qwtel.sqlite-viewer): Introspect development database
  - Extension - [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers): Sandboxed and clean development environment
  - Extension - [C# DevKit](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit): IDE integration for .NET development
- [.NET 9.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/9.0): Runtime and tools for .NET development
- [Docker Engine](https://docs.docker.com/engine/): Container runtime
- [Docker Compose](https://docs.docker.com/compose/): Container composer

**Infrastructure**:

- [GitHub](): Version control and collaborative software development platform
- [GitHub Actions](): Continuous Delivery of containers to GitHub Container Registry
- [GitHub OAuth App](https://github.com/): For user authentication
- [Hetzner Cloud Server](https://www.hetzner.com/cloud/): Cloud provider
  - Cloud Server: Compute
  - Block Storage: Persistence

**Services**:

- [Traefik](https://traefik.io/): Reverse proxy for services
- [.NET 9.0 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/9.0): Runtime for .NET based services
- [SQLite](https://www.sqlite.org/index.html): Simple relational database

## Out of scope

> [!NOTE]
> These are just some examples of areas you might explore when moving toward production-grade deployments.
> You don't need to tackle everything at once. Focus on learning and addressing them as your needs evolve.

> [!TIP]
> Discuss with a collegue or an LLM to figure out what your next steps should be.

- Setup TLS certificate through Traefik (not attested) for HTTPS communication
  - Buy a domain and have Let's Encrypt sign the certificate
- Database schema migration
- Migrate to a production-grade database (e.g. PostgreSQL)
- Instrument services with telemetry (OpenTelemetry) endpoints
  - Deploy an observability stack (Grafana, Prometheus)
- Setup Continuous Integration with gated environment promotion
  - Enhance with more comprehensive test suite (Unit, Integration, End-to-End)
  - Setup security scanning
  - Setup dependency updating (dependabot)
- Deployment hardening
  - Disable SSH access
  - Setup firewall
