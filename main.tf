

resource "aws_vpc" "new_app_vpc" {  
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"    #引用内部的variable
    }
}

#create subnet module
module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block=var.subnet_cidr_block #传参
    avail_zone=var.avail_zone
    env_prefix=var.env_prefix
    vpc_id=aws_vpc.new_app_vpc.id
    default_route_table_id=aws_vpc.new_app_vpc.default_route_table_id
}

module "myapp-server" {
    source = "./modules/webserver"
    vpc_id=aws_vpc.new_app_vpc.id
    myofficeip=var.myofficeip
    myhomeip=var.myhomeip
    env_prefix=var.env_prefix
    image_name=var.image_name
    pub_key_file_location=var.pub_key_file_location
    instance_type=var.instance_type
    avail_zone=var.avail_zone
    subnet_id= module.myapp-subnet.subnet.id  #use module subnet id
}