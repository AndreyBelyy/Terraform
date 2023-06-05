# Auto Fill parameters for Dev"

region              = "us-east-1"
instance_type       = "t2.micro"
detailed_monitoring = false

inbound_ports = ["80", "443", "22", "8080"]

common-tags = {
  Owner            = "Andrei Belyi"
  Project          = "Nautilus"
  OperationsCenter = "SPB-NW-1"
  Environment      = "study"
}
