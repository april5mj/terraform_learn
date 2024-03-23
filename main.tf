
# define variables
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "myofficeip" {}
variable "key_file_location" {}
variable "instance_type" {}
variable "myhomeip" {}

resource "aws_vpc" "new_app_vpc" {  
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"    #引用内部的variable
    }
}

resource "aws_subnet" "subnet_01" {
    vpc_id = aws_vpc.new_app_vpc.id  #引用还没生成的vpc的id
    cidr_block =  var.subnet_cidr_block   #use variable
    availability_zone = var.avail_zone
    tags = {
        Name:"${var.env_prefix}-subnet-1"
    }
}

#route table & internet gateway
resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.new_app_vpc.id
    route {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.myapp-igateway.id
    }
    tags = {
        Name:"${var.env_prefix}-RTB"
    }
}

resource "aws_internet_gateway" "myapp-igateway" {
    vpc_id = aws_vpc.new_app_vpc.id
    tags = {
        Name:"${var.env_prefix}-IGW"
    }
}

#associate subnet with route table
resource "aws_route_table_association" "myapp-rtb-subnet-asso" {
    subnet_id = aws_subnet.subnet_01.id
    route_table_id = aws_route_table.myapp-route-table.id
}

#create security group
resource "aws_default_security_group" "apr-default-sg" {
    vpc_id = aws_vpc.new_app_vpc.id

    ingress {         #inbound rule
        from_port=22    #for ssh
        to_port=22      #port range
        protocol="tcp"
        cidr_blocks=[var.myofficeip,var.myhomeip] #list type
    }
    ingress {         
        from_port=8080  #for nginx
        to_port=8080      
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"] #anybody can access
    }
    egress {         
        from_port=0  #any port
        to_port=0      
        protocol = "-1" #any protocol
        cidr_blocks=["0.0.0.0/0"] #anybody can access
        prefix_list_ids=[] #any VPC
    } 
    tags = {
        Name:"${var.env_prefix}-sec_grp"
    }
}
# create EC2
data "aws_ami" "amzn_linux2_latest"{     #find a specific ami
    most_recent = true
    owners = ["amazon"]
    filter{
        name="name"
        values = ["amzn2-ami-kernel-*-x86_64-gp2"]   #name filter
    }
    filter {
        name="virtualization-type"
        values = ["hvm"]        #Virtualization filter
    }   
}

resource "aws_key_pair" "ssh_key" {         #auto create ssh key pair
  key_name = "spsapr-server-ssh-key"
  public_key =file(var.key_file_location)    #get the value from a file
  
}
resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.amzn_linux2_latest.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.subnet_01.id
    vpc_security_group_ids = [ aws_default_security_group.apr-default-sg.id ]
    availability_zone = var.avail_zone

    associate_public_ip_address = true   #create public ip

    key_name = aws_key_pair.ssh_key.key_name   #use ~~key pair name~~

    user_data = file("entry-script.sh")
    tags = {
      Name:"${var.env_prefix}-amzn_linux2_server"
    }
}

output "ami_info_public_ip" {
  value=aws_instance.myapp-server.public_ip     #output EC2 instance public ip
}

