output "public-ip" {
  description = "public IP for ec-2"
  value = aws_instance.ec2_instance.public_ip
}