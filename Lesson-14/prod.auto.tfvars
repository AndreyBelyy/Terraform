# Auto Fill parameters for Dev"

region              = "us-east-1"
instance_type       = "t2.micro"
detailed_monitoring = true

inbound_ports = ["80", "443"]

common-tags = {
  Owner            = "Andrei Belyi"
  Project          = "Nautilus"
  OperationsCenter = "SPB-C-1"
  Environment      = "study"
}
