resource "aws_instance" "node1" {
  ami                    = "ami-04a0ae173da5807d3"
  vpc_security_group_ids = [aws_security_group.WebServer.id]
  instance_type          = "t2.micro"
  tags = {
    "Name"  = "Test-import"
    "Owner" = "Andrei Belyi"
  }
}

resource "aws_instance" "node2" {
  ami                    = "ami-04a0ae173da5807d3"
  vpc_security_group_ids = [aws_security_group.WebServer.id]
  instance_type          = "t2.micro"
  tags = {
    "Name"  = "Test-import"
    "Owner" = "Andrei Belyi"
  }
}

resource "aws_instance" "node3" {
  ami                    = "ami-04a0ae173da5807d3"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.WebServer.id]
  tags = {
    "Name"  = "Test-import"
    "Owner" = "Andrei Belyi"
  }
}


resource "aws_security_group" "WebServer" {
  description = "WebServer"
  ingress {
    from_port   = 0
    to_port     = 65535
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
    Name  = "Nomad Cluster"
    Owner = "Andrei Belyi"
  }
}
