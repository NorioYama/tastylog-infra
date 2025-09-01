# Tastylog Infra (Terraform)

ポートフォリオ用の IaC。**VPC / EC2 (app) / RDS (MySQL) / SSM Parameter Store / IAM** を Terraform v1.6+ / AWS Provider v5 で構築。

## 構成
- VPC: /16, Public/Private Subnet (1a/1c)
- EC2 (t3.micro): app 用。systemd で `load-params.service` → `tastylog.service`
- RDS (MySQL 8.0): `db.t3.micro`（例）。SSM へ接続情報を投入
- SSM Parameter Store: `/${project}/${environment}/app/*`
- IAM: EC2 Role に `AmazonSSMManagedInstanceCore` 等を付与

## アーキテクチャ（Mermaid）
```mermaid
flowchart LR
  Internet(((Internet)))
  IGW[Internet Gateway]
  EC2[EC2 app]
  RDS[(RDS MySQL)]
  SSM[(SSM Parameter Store)]

  Internet --> IGW --> EC2
  EC2 -->|3306| RDS
  EC2 -.->|GetParameter| SSM

  subgraph VPC
    direction LR
    subgraph Public_Subnet["Public Subnet"]
      EC2
    end
    subgraph Private_Subnet["Private Subnet"]
      RDS
    end
  end
