output "server_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "my_instance_id" {
  value = aws_instance.server.id
}

output "my_sg_id" {
  value = aws_security_group.web.id
}
