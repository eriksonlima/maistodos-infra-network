# Resources related to the VPC: vpc, peering, default_sg, route_tables.
resource "aws_vpc" "main" {
  #checkov:skip=CKV2_AWS_11: Flow logs may be enabled in the future.
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true

  tags = merge(
    local.tags,
    { Name = "${local.project_name}/${local.environment}" }
  )
}
output "vpc_id" { value = aws_vpc.main.id }
output "vpc_arn" { value = aws_vpc.main.arn }
output "vpc_cidr" { value = aws_vpc.main.cidr_block }

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.tags,
    { Name = local.project_name }
  )
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_route_table.public.id
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.tags,
    { Name = "${local.project_name}/${local.environment}/default" }
  )
}

resource "aws_route_table" "public" {
  tags = merge(
    local.tags,
    { Name = "${local.project_name}/${local.environment}/public" }
  )
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_internet_gateway.main]
}


resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}