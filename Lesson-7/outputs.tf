output "webserver_instanceid" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "sg_id" {

  value = aws_security_group.my_webserver.id
}

output "sg_arn" {
  value       = aws_security_group.my_webserver.arn
  description = "Security group ARN"
}

