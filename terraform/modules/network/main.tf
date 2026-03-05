resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" : "${var.name}_vpc"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.avz_cidrs[count.index]
  availability_zone = data.aws_availability_zones.avz.names[count.index]

  count = var.az_count

  tags = {
    "Name" : "${var.name}_private${count.index}_subnet"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.avz_cidrs[count.index + var.az_count]
  availability_zone = data.aws_availability_zones.avz.names[count.index]

  count = var.az_count

  tags = {
    "Name" : "${var.name}_public${count.index}_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" : "${var.name}_igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    "Name" : "${var.name}_rt_public"
  }
}

resource "aws_route_table_association" "public_subnets" {
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id

  count = length(aws_subnet.public_subnets)
}

resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.gw]

  tags = {
    "Name" : "${var.name}_eip_nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id
  depends_on    = [aws_internet_gateway.gw]
  tags = {
    "Name" : "${var.name}_nat"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  count = length(aws_subnet.private_subnets)

  tags = {
    "Name" : "${var.name}_rt${count.index}_private"
  }
}


resource "aws_route_table_association" "private_subnets" {
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private[count.index].id

  count = length(aws_subnet.private_subnets)
}
