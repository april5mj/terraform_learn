
variable "cidr_blocks" {
    description = "vpc , subnet cider block"
    type = list(object({
      cidr_block = string
      name = string
    }))   #list type
}         

# define variables


resource "aws_vpc" "vpc_dev" {  
    cidr_block = var.cidr_blocks[0].cidr_block  
    tags = {
        Name: var.cidr_blocks[0].name
        owner:"spsapr"
    }
}

resource "aws_subnet" "subnet_01" {
    vpc_id = aws_vpc.vpc_dev.id  #引用还没生成的vpc的id
    cidr_block =  var.cidr_blocks[1].cidr_block    #use variable
    availability_zone = "ap-northeast-3a"
        tags = {
        Name:var.cidr_blocks[1].name
    }
}
