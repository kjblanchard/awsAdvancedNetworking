resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "MainIG"
  }
}

resource "aws_egress_only_internet_gateway" "gwv6" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "MainIG EgressOnly"
  }
}
