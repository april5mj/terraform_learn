variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "cost_center" {
  description = "CostCenter tag (required)"
  type        = string
  # 没有 default，调用时必须传，否则 terraform plan 直接报错
}

variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "extra_tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}
