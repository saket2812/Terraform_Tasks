provider "aws" {
  region = var.region
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Security group for Flask (backend)
resource "aws_security_group" "flask_sg" {
  name        = "flask_sg"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # allow frontend and external access
  }
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # or restrict to your IP: ["203.0.113.1/32"]
 }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for Express (frontend)
resource "aws_security_group" "express_sg" {
  name        = "express_sg"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # or restrict to your IP: ["203.0.113.1/32"]
}


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Flask backend EC2
resource "aws_instance" "flask_backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "tutedude-aws-key" 
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  user_data              = file("backend_user_data.sh")
  tags = {
    Name = "Flask-Backend"
  }
}

# Express frontend EC2
resource "aws_instance" "express_frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "tutedude-aws-key" 
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.express_sg.id]
  user_data              = templatefile("frontend_user_data.sh", {
    backend_ip = aws_instance.flask_backend.public_ip
  })
  tags = {
    Name = "Express-Frontend"
  }
}
