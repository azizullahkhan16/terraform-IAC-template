variable "al2023_ami_id" {
  description = "AMI ID for Amazon Linux 2023"
  default     = "ami-09e6f87a47903347c" 
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "project_key"
}

variable "desired_capacity" {
  default = 2
}

variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 3
}
variable "ec2_sg_id" {
  description = "EC2 Security Group ID"
  type        = string
}

variable "postgres_instance" {
  description = "instance"
  type        = any
}

variable "postgres_connection_url" {
  description = "instance"
  type        = string
}