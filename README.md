# Tastylog Infra (Terraform)

ポートフォリオ用の IaC。**VPC / EC2 (app) / RDS (MySQL) / SSM Parameter Store / IAM** を Terraform v1.6+ / AWS Provider v5 で構築。

使用テキスト:
udemy AWS と Terraformで実現するInfrastructure as Code


## 構成
VPC: /16, Public/Private Subnet（Publicは1a/1c）

EC2 (t3.micro): app 用（:3000 を 0.0.0.0 で listen）

RDS (MySQL 8.0)

SSM Parameter Store

IAM: EC2 Role に AmazonSSMManagedInstanceCore 等

ALB (internet-facing): Listener :80 → Target Group :3000（EC2）

Route53: dev-elb.terraform-test.jp の A(エイリアス) → ALB

## アーキテクチャ（Mermaid）
```mermaid
flowchart LR
  Client[[Internet]]
  Route53[Route53<br/>dev-elb.terraform-test.jp]

  subgraph VPC
    direction TB
    IGW[Internet Gateway]

    subgraph Public_Subnets_1a_1c["Public Subnets 1a & 1c"]
      ALB[ALB HTTP 80]
    end

    subgraph AZ1["AZ ap-northeast-1a (Single AZ)"]
      direction TB
      subgraph Public_1a["Public Subnet 1a"]
        EC2[EC2 app :3000]
      end
      subgraph Private_1a["Private Subnet 1a"]
        RDS[(RDS MySQL)]
      end
    end

    SSM[(SSM Parameter Store)]
  end

  Client --> Route53
  Route53 -. "A alias" .-> ALB
  Client --> IGW --> ALB
  ALB -->|80 to 3000| EC2
  EC2 -->|3306| RDS
  EC2 -.->|GetParameter| SSM