data "aws_prefix_list" "s3_pl" { #マネージドプレフィックスリストからプレフィックスリストの取り込み
  name = "com.amazonaws.*.s3"    #*にすることで、全リージョンのプレフィックスリストが取り込める
}

# ----------------------------
# 自分のAMIカタログからAMI取得
# ----------------------------

data "aws_ami" "app" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}