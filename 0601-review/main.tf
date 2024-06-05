module "aws_vpc" {
  source        = "./vpc"
  cidr_block    = "192.168.0.0/16"
  cidr_block_s1 = "192.168.1.0/24"
  cidr_block_s2 = "192.168.2.0/24"
  az            = "us-east-1a"
  az2           = "us-east-1b"
  route_cidr    = "0.0.0.0/0"
}

module "lt_sg" {
  source     = "./lt_sg"
  vpcid      = module.aws_vpc.vpcid
  depends_on = [module.aws_vpc]
}
module "eks" {
  source     = "./eks"
  subnet_id1 = module.aws_vpc.subnet1
  subnet_id2 = module.aws_vpc.subnet2
  sg_id      = module.lt_sg.sg_id
  lt_id      = module.lt_sg.lt_id
  lt_version = module.lt_sg.lt_version
  depends_on = [module.lt_sg]
}