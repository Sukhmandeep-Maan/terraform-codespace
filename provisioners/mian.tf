provider "aws" {
    region = "ap-south-1"  
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

resource "aws_vpc" "VPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}
resource "aws_instance" "ec2_instance" {
  ami           = "ami-006f82a1d5a27da54" # replace this with a valid AMI ID
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.sg.name]
  connection {
    type        = "ssh"
    user        = "EC2 Instance"
    private_key = file("~/.ssh/id_rsa") # replace with your private key path    
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3-pip",
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py",
    ]
  }
  tags = {
    Name = "EC2 Instance"
  }
}