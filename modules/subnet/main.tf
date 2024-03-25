resource "aws_subnet" "subnet_01" {
    vpc_id = var.vpc_id #引用还没生成的vpc的id
    cidr_block =  var.subnet_cidr_block   #use variable
    availability_zone = var.avail_zone
    tags = {
        Name:"${var.env_prefix}-subnet-1"
    }
}

#route table & internet gateway
resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = var.default_route_table_id
    route {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.myapp-igateway.id
    }
    tags = {
        Name:"${var.env_prefix}-RTB"
    }
}

resource "aws_internet_gateway" "myapp-igateway" {
    vpc_id = var.vpc_id
    tags = {
        Name:"${var.env_prefix}-IGW"
    }
}

