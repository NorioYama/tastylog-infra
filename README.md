# Tastylog Infra (Terraform)

ポートフォリオ用の IaC。**VPC / EC2 (app) / RDS (MySQL) / SSM Parameter Store / IAM** を Terraform v1.6+ / AWS Provider v5 で構築。

使用テキスト:
udemy AWS と Terraformで実現するInfrastructure as Code


## 構成
- VPC: /16, Public/Private Subnet (1a)
- EC2 (t3.micro): app 用。
- RDS (MySQL 8.0):
- SSM Parameter Store: 
- IAM: EC2 Role に `AmazonSSMManagedInstanceCore` 等を付与

## アーキテクチャ（Mermaid）
```mermaid
flowchart LR
  Internet(((Internet)))
  IGW[Internet Gateway]
  SSM[(SSM Parameter Store)]

  %% --- VPC / Single-AZ (1a) ---
  subgraph VPC
    direction TB
    subgraph AZ1["AZ:(Single-AZ)"]
      direction LR
      subgraph Public_Subnet["Public Subnet 1a"]
        EC2[EC2 app]
      end
      subgraph Private_Subnet["Private Subnet 1a"]
        RDS[(RDS MySQL)]
      end
    end
  end

  %% --- Edges ---
  Internet --> IGW
  IGW -->  EC2
  EC2 -->|3306| RDS
  EC2 -.->|GetParameter| SSM
