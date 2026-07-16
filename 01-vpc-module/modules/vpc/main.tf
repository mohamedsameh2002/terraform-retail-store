# vpc
resource "aws_vpc" "mainvpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, { Name = "${var.environment_name}-vpc" })
  lifecycle {
    prevent_destroy = false
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = merge(var.tags, { Name = "${var.environment_name}-igw" })
}


# public subnets
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.mainvpc.id
  for_each = {for idx , az in local.azs : az => local.public_subnets[idx]}
  availability_zone = each.key
  cidr_block = each.value
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.environment_name}-public-${each.key}" })
}


# private subnets
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.mainvpc.id
  for_each = {for idx , az in local.azs : az => local.privet_subnets[idx]}
  availability_zone = each.key
  cidr_block = each.value
  tags = merge(var.tags, { Name = "${var.environment_name}-private-${each.key}" })
}




# elastic ip for nat gatway
resource "aws_eip" "eip_nat" {
    # for_each = aws_subnet.public
    tags = merge(var.tags, { Name = "${var.environment_name}-nat-eip" })
}

# nat gatway
resource "aws_nat_gateway" "nat" {
#   for_each = aws_subnet.public
#   allocation_id = aws_eip.eip_nat[each.key].id
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = values(aws_subnet.public)[0].id
#   subnet_id     = each.value.id
  tags = merge(var.tags, { Name = "${var.environment_name}-nat" })
  depends_on = [aws_internet_gateway.igw]
}


# public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-public-rt" })
}


# public route table associate to public subnet 
resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


# privet route table
resource "aws_route_table" "privet_rt" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-privet-rt" })
}



# privet route table associate to public privet 
resource "aws_route_table_association" "privet_rt_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.privet_rt.id
}
