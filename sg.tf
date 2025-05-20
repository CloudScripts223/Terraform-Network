resource "aws_security_group" "Aws-SG" {
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.Custom-Vpc.id

  tags = {
    Name      = var.aws_security_group_name
    owner     = local.owner
    Costcente = local.Costcente
    TeamDL    = local.TeamDL

  }
  #  resource "aws_security_group" "SG" {
  dynamic "ingress" {
    for_each = var.ingress_values
    content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
    }
  }


  #  resource "aws_security_group" "SG" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

}

