data "aws_availability_zones" "available" {
  state = "available"
}



locals {
  azs=slice(data.aws_availability_zones.available.names,0,3)
  public_subnets=[for i , v in local.azs : cidrsubnet(var.vpc_cidr,var.subnet_newbits,i)]
  privet_subnets=[for i , v in local.azs : cidrsubnet(var.vpc_cidr,var.subnet_newbits,i+10) ]
}