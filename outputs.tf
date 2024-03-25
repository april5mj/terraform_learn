output "ec2_public_ip" {
  value=module.myapp-server.instance.public_ip     #output EC2 instance public ip
}

output "ami_id" {
  value = module.myapp-server.ami_id
}