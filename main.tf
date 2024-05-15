module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "main"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source  = "./modules/ec2"
  sg_id   = module.sg.sg_id
  subnets = module.vpc.public_subnet_id
}

module "alb" {
  source    = "./modules/alb"
  sg_id     = module.sg.sg_id
  subnets   = module.vpc.public_subnet_id
  vpc_id    = module.vpc.vpc_id
  instances = module.ec2.instance_id
}