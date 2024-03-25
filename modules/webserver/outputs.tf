output "ami_id" {
    value = data.aws_ami.amzn_linux2_latest.id
}

output "instance" {
  value=aws_instance.myapp-server    #output EC2 instance public ip
}
