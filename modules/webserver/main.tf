
#create security group
resource "aws_security_group" "apr-app-sg" {
    vpc_id = var.vpc_id
    name = "apr-app-sg"

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
        values = [var.image_name]   
    }
    filter {
        name="virtualization-type"
        values = ["hvm"]        #Virtualization filter
    }   
}

resource "aws_key_pair" "ssh_key" {         #auto create ssh key pair
  key_name = "spsapr-server-ssh-key"
  public_key =file(var.pub_key_file_location)    #get the value from a file
  
}
resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.amzn_linux2_latest.id
    instance_type = var.instance_type

    # subnet_id = module.myapp-subnet.subnet.id # ref a module output
    subnet_id = var.subnet_id

    vpc_security_group_ids = [ aws_security_group.apr-app-sg.id ]
    availability_zone = var.avail_zone

    associate_public_ip_address = true   #create public ip

    key_name = aws_key_pair.ssh_key.key_name   #use ~~key pair name~~

    user_data = file("entry-script.sh")

    tags = {
      Name:"${var.env_prefix}-amzn_linux2_server"
    }
}

