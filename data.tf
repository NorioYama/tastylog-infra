data "aws_prefix_list" "s3_pl" { #マネージドプレフィックスリストからプレフィックスリストの取り込み
  name = "com.amazonaws.*.s3"    #*にすることで、全リージョンのプレフィックスリストが取り込める
}

# ----------------------------
# 最新の Amazon Linux 2023 AMI を取得
# ----------------------------

data "aws_ami" "app" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.8.*.0-kernel-6.1-x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}