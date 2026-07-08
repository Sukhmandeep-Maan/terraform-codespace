provider "aws" {
    region = "ap-south-1"
}

module "ec2_inst" {
  source = "./module"
  ami_value = "ami-006f82a1d5a27da54" # replace this
  instance_type_value = "t3.micro"
}