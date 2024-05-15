#Create VPC
resource "aws_vpc" "my-main-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_name
  }
}

#Create IGW
resource "aws_internet_gateway" "my-main-igw" {
  vpc_id = aws_vpc.my-main-vpc.id

  tags = {
    Name = "my-main-igw"
  }
}

#Create Public Subnets
data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.my-main-vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

#Create Public Route Table and Associate with Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my-main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-main-igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
