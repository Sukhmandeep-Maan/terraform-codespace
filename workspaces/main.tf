provider "aws" {
  region = "ap-south-1"
}

variable "instance_type" {
  description = "Type of instance to launch"
  type = map(string)
  default = ({
    "dev"  = "t3.micro"
    "prod" = "t3.small"
  })
}
variable "ami_id" {
    description = "AMI ID to use for the instance"
}
module "ec2_instance" {
  source = "./module"
  instance_type = lookup(var.instance_type, terraform.workspace, "t3.micro")
  ami_id = var.ami_id
}
