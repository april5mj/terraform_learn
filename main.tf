module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]

  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = {Name:"${var.env_prefix}-apr_subnet1"}  #tag for subnet

  tags = {
      Name:"${var.env_prefix}-apr_vpc"
    }
}

module "myapp-server" {
    source = "./modules/webserver"
    vpc_id=module.vpc.vpc_id
    myofficeip=var.myofficeip
    myhomeip=var.myhomeip
    env_prefix=var.env_prefix
    image_name=var.image_name
    pub_key_file_location=var.pub_key_file_location
    instance_type=var.instance_type
    avail_zone=var.avail_zone
    subnet_id= module.vpc.public_subnets[0] # get subnet id
}