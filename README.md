# AWS Event-Driven Architecture with Terraform & LocalStack

Este projeto implementa uma arquitetura orientada a eventos (*Event-Driven*) na AWS simulada localmente via **LocalStack**, utilizando **Terraform** como ferramenta de Infraestrutura como Código (IaC) e **GitHub Actions** para CI/CD.

## 🏗️ Arquitetura

1. **S3 Bucket**: Recebe arquivos de telemetria/logs.
2. **SQS Queue**: Atua como buffer de eventos desassincronizados.
3. **AWS Lambda (Python)**: Processa automaticamente as mensagens acionadas pela fila SQS.

```mermaid
graph LR
    A[📦 S3 Bucket] -->|Event Trigger| B[✉️ SQS Queue]
    B -->|Event Source Mapping| C[⚡ AWS Lambda]
````


## 🛠️ Tecnologias Utilizadas

* **Infraestrutura como Código:** Terraform v1.5+
* **Ambiente de Nuvem Local:** LocalStack v3.8.0 & Docker Compose
* **Linguagem de Runtime:** Python 3.9 (AWS Lambda)
* **CI/CD:** GitHub Actions (Linting & Validations)

## 🚀 Como Executar Localmente

1. Suba o container do LocalStack:
   ```bash
   docker compose up -d
Inicialize e aplique o Terraform:

terraform init
terraform apply -parallelism=1 -auto-approve
Teste a arquitetura enviando um arquivo para o S3:

docker exec -it localstack_main awslocal s3 cp /etc/hosts s3://cloudstatus-telemetry-data/dados-lambda.txt

---

### Desenvolvido por Pedro Henrique 🚀
