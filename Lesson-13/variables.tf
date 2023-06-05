variable "region" {
  description = "Please, choose a server"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "inbound_ports" {
  description = "Open ports"
  #type = list
  default = ["80", "443", "22", "8080"]
}

variable "detailed_monitoring" {
  type    = bool
  default = false
}


variable "common-tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
    Owner       = "Andrei Belyi"
    Project     = "Nautilus"
    CostCenter  = "wR-45"
    Environment = "Study"
  }
}
