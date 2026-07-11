
# STEP1: CREATE SG
resource "aws_security_group" "mern-sg" {
  name        = "MERN-SERVER-SG"
  description = "MERN Server Ports"
  vpc_id      = module.vpc.vpc_id

  # Port 22 is required for SSH Access
  ingress {
    description = "SSH Port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 80 is required for HTTP
  ingress {
    description = "HTTP Port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 443 is required for HTTPS
  ingress {
    description = "HTTPS Port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }





  # Port 8080 is required for Jenkins
  ingress {
    description = "Jenkins Port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Port 9000 is required for SonarQube
  ingress {
    description = "SonarQube Port"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Define outbound rules to allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# STEP2: CREATE EC2 USING PEM & SG
resource "aws_instance" "mern-ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.mern-sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data             = file("${path.module}/user.sh")

  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = var.server_name
  }

}

# STEP3: GET EC2 USER NAME AND PUBLIC IP 
output "SERVER-SSH-ACCESS" {
  value = "ec2-user@${aws_instance.mern-ec2.public_ip}"
}

# STEP4: GET EC2 PUBLIC IP 
output "PUBLIC-IP" {
  value = aws_instance.mern-ec2.public_ip
}

# STEP5: GET EC2 PRIVATE IP 
output "PRIVATE-IP" {
  value = aws_instance.mern-ec2.private_ip
}

output "instance_id" {
  value = aws_instance.mern-ec2.id
}

output "public_dns" {
  value = aws_instance.mern-ec2.public_dns
}

output "ssh_command" {
  value = "ssh -i \"/c/Users/lohit/Desktop/key2/linuxkey.pem\" ec2-user@${aws_instance.mern-ec2.public_ip}"
}