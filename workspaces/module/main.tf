provider "aws" {
    region = "ap-south-1"
}

variable "instance_type" {
    description = "Type of instance to launch"
}
variable "ami_id" {
    description = "AMI ID to use for the instance"
}

resource "aws_instance" "ec2_instance" {
    ami           = var.ami_id
    instance_type = var.instance_type

    tags = {
        Name = "workspaceInstance"
    }
}