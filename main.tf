provider "aws" {
  region = var.aws_region

}

resource "aws_vpc" "Custom-Vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name      = var.vpc_name
    owner     = local.owner
    Costcente = local.Costcente
    TeamDL    = local.TeamDL
  }
}

resource "aws_subnet" "P-Subnets" {
  # count             = 2
  count             = length(var.P_cidr_block)
  vpc_id            = aws_vpc.Custom-Vpc.id
  cidr_block        = element(var.P_cidr_block, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name      = "${var.P-Subnets_name}-${count.index + 1}"
    owner     = local.owner
    Costcente = local.Costcente
    TeamDL    = local.TeamDL
  }
}

resource "aws_subnet" "Pri-Subnets" {
  # count             = 4
  count             = length(var.Pri_cidr_block)
  vpc_id            = aws_vpc.Custom-Vpc.id
  cidr_block        = element(var.Pri_cidr_block, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name      = "${var.Pri_Subnets_name}-${count.index + 1}"
    owner     = local.owner
    Costcente = local.Costcente
    TeamDL    = local.TeamDL
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.Custom-Vpc.id

  tags = {
    Name = "${var.aws_internet_gateway_name}"
  }
}

resource "aws_eip" "Nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "Nat" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.P-Subnets[0].id
  allocation_id     = aws_eip.Nat.id

  tags = {
    name = var.aws_nat_gateway_name
  }
}


resource "aws_route_table_association" "public" {
  count = length(aws_subnet.P-Subnets)

  subnet_id      = aws_subnet.P-Subnets[count.index].id
  route_table_id = aws_route_table.rts[0].id # public RT
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.Pri-Subnets)

  subnet_id      = aws_subnet.Pri-Subnets[count.index].id
  route_table_id = aws_route_table.rts[1].id # private RT
}
