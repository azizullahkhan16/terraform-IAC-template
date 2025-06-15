variable "alb_dns_name" {
  description = "The DNS name of the ALB to create a Route53 record for"
  type        = string
}

variable "alb_zone_id" {
  description = "The Zone ID of the ALB to create a Route53 record for"
  type        = string
}

variable "ec2_instance_public_ip" {
  description = "The public IP of the EC2 instance to create a Route53 record for"
  type        = string
}