# main.tf

provider "aws" {
  region = "us-east-1"
}

module "ec2_asg" {
  source     = "./modules/ec2-asg"
  
  ec2_sg_id  = module.security_groups.ec2_sg_id
  postgres_instance = module.rds.postgres_instance
  postgres_connection_url = module.rds.postgres_connection_url
}
module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = var.vpc_id
  
}
module "subnet" {
  source = "./modules/subnet"
  vpc_id = var.vpc_id
  
}
module "rds" {
  source = "./modules/rds"
  rds_sg_id = module.security_groups.rds_sg_id
  rds_subnetgroup_name = module.subnet.rds_subnetgroup_name
  
}

module "alb" {
  source = "./modules/alb"
  vpc_id = var.vpc_id
  asg_name = module.ec2_asg.asg_name
  alb_sg_id = module.security_groups.alb_sg_id
  depends_on = [ module.ec2_asg ]
  
}
module "route53" {
  source = "./modules/route53"
  ec2_instance_public_ip = module.ec2_asg.ec2_insance_ip
  alb_dns_name = module.alb.alb_dns
  alb_zone_id = module.alb.load_balancer_zone_id
  depends_on = [ module.alb ]
}