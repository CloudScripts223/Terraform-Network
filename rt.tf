resource "aws_route_table" "rts" {
  count  = length(var.rt_types)
  vpc_id = aws_vpc.Custom-Vpc.id

  dynamic "route" {
    for_each = var.rt_types[count.index] == "public" ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IG.id
    }
  }

  dynamic "route" {
    for_each = var.rt_types[count.index] == "private" ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.Nat.id
    }
  }

  tags = {
    Name = "${var.rt_types[count.index]}-rt"
  }
}
