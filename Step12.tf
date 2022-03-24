provider "aws" {
  profile = "ppclassic"
  region  = "us-east-1"
}
resource "aws_vpc" "training" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "training"
	Location="India"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.training.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet1"
  }
}

resource "aws_security_group" "SGTEST" {
  name        = "SGTEST"
  description = "Allow traffic"
  vpc_id      = aws_vpc.training.id

  ingress {
    description      = "rules"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "rules1"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   
  }
  
  ingress {
    description      = "rules2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["1.1.1.1", "8.8.8.8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rule"
  }
}

resource "aws_network_interface" "testinterface" {
  subnet_id   = aws_subnet.subnet1.id
  private_ips = ["10.0.1.0/24"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "testinstance" {
  ami           = "ami-0c02fb55956c7d316" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.testinterface.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}