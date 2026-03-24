#congifure the provider
provider "aws" {
  # 不指定 region，让 AWS Provider 从环境变量 AWS_REGION 读取
}

resource "aws_vpc" "vpc_dev" {  
    cidr_block = "10.0.0.0/16"
    tags = {
        Name:"VPC_dev"
        owner:"spsapr"
    }                  #加了名字, owner tag
}

resource "aws_subnet" "subnet_01" {
    vpc_id = aws_vpc.vpc_dev.id  #引用还没生成的vpc的id
    cidr_block = "10.0.10.0/24"
    availability_zone = "ap-northeast-3a"
        tags = {
        Name:"subnet_01_dev"
    }
}

data "aws_vpc" "exsiting_vpc" {
    default = false
    cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "subnet_02" {
    vpc_id = data.aws_vpc.exsiting_vpc.id  #引用query到的vpc id
    cidr_block = "192.168.5.0/24"
    availability_zone = "ap-northeast-3a"
        tags = {
        Name:"subnet_02_dev"
    }
}