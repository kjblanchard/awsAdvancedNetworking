# Gateway endpoints are associated with a route table.
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.network.region}.s3"
  tags = {
    Name = "S3-Gateway-Endpoint-Default"
  }
  route_table_ids = [ for table in aws_route_table.private : table.id ]
}
