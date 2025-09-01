# Tastylog Infra (Terraform)

ポートフォリオ用の IaC。**VPC / EC2 (app) / RDS (MySQL) / SSM Parameter Store / IAM** を Terraform v1.6+ / AWS Provider v5 で構築。

## ざっくり構成
- VPC: /16, Public/Private Subnet (1a/1c)
- EC2 (t3.micro): app 用。systemd で `load-params.service` → `tastylog.service`
- RDS (MySQL 8.0): `db.t3.micro`（例）。SSM へ接続情報を投入
- SSM Parameter Store: `/${project}/${environment}/app/*`
- IAM: EC2 Role に `AmazonSSMManagedInstanceCore` 等を付与

## アーキテクチャ（Mermaid）
```mermaid
flowchart LR
  Internet --> IGW --> ALB((Optional))
  ALB --> EC2[EC2 app]
  EC2 -->|3306| RDS[(RDS MySQL)]
  EC2 -.->|GetParameter| SSM[(SSM Parameter Store)]
  subgraph VPC
    EC2
    RDS
  end