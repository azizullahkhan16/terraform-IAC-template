variable "rds_subnetgroup_name" {
  description = "rds_subnetgroup_NAME"
  type        = string
}
variable "rds_sg_id" {
  description = "rds_sg_ID"
  type        = string
}
variable "username" {
  description = "username"
  type        = string
  default = "azizkhan"
}
variable "password" {
  description = "password"
  type        = string
  default = "123456789"
}
