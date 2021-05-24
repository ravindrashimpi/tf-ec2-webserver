/**
* First step is to select the provider
**/
//Step1
provider "aws" {
  region = "ap-south-1"
}

/**
* Provision a new EC2 instance
**/
//Step1-2
resource "aws_instance" "ec2-instance" {
  ami                    = "ami-0c1a7f89451184c8b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance-web.id, aws_security_group.instance-ssh.id]

  //Step-1-2-3-4
  key_name = "tf-tutorial"

  //Step1-2-3-4-5
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  //Step1-2-3
  tags = {
    Name = "Terraform-EC2-Instance"
  }
}

/**
* Setup a security group to access webserver
*/
resource "aws_security_group" "instance-web" {
  name = "Terraform-EC2-Web"

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

/**
* Setup a security group to access server
*/
resource "aws_security_group" "instance-ssh" {
  name = "Terraform-EC2-SSH"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

