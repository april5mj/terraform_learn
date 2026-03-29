provider "aws" {
  # region 从环境变量 AWS_REGION 读取
}

# 动态查询最新的 Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

module "ec2_example" {
  source = "app.terraform.io/Coach-learn/ec2/aws"
  #"./modules/ec2"
  version = "1.0.0" 
  name        = "april5-instance"
  ami_id      = data.aws_ami.al2023.id  # 自动获取最新 AL2023
  subnet_id   = "subnet-0fcb87ab84b39a2ce"
  cost_center = "team-backend"          # 必填，不传会报错

  # extra_tags 可选
  extra_tags = {
    Environment = "dev"
  }
}
