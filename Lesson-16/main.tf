provider "aws" {
  region = "us-east-2"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.ya.ru"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print('Hello Worlds!')"
    interpreter = ["python3", "-c"]
  }
}
resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Tatiana"
      NAME2 = "Galina"
      NAME3 = "Albina"
    }
  }
}
resource "aws_instance" "my_server" {
  ami           = "ami-0715c1897453cabd1"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo Hello!"
  }
}

resource "null_resource" "command6" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.my_server]
}

