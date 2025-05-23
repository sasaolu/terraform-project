
resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}


#Create security group with firewall rules
resource "aws_security_group" "new-terraform-sg" {
  name        = var.security_group
  description = "security group for jenkins"
                                        
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from Jenkins server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}


#Create Multiple EC2 Instances
resource "aws_instance" "terraform-ec2" {
  count         = var.instance_count
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.new-terraform-sg.id]
  tags= {
    Name = "${var.tag_name}-${count.index + 1}"
  }
}
