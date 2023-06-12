resource "aws_eip" "prod-ip1" { vpc = true } # Need to add in new AWS Provider version
resource "aws_eip" "prod-ip2" { vpc = true } # Need to add in new AWS Provider version

resource "aws_eip" "myip--0-prod" { vpc = true } # Need to add in new AWS Provider version
