resource "aws_instance" "web" {
  count = length(var.ec2_names)
  ami           = "ami-0cf10cdf9fcd62d37" # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  security_groups = [var.sg_id]
  subnet_id = var.subnets[count.index]
  

 user_data = file("${path.module}/script.sh")


  tags = {
    Name = var.ec2_names[count.index]
  }
}