resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = merge(
    {
      Name       = var.name
      CostCenter = var.cost_center
    },
    var.extra_tags
  )
}
