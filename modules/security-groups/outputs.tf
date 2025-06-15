output "ec2_sg_id" {
  value = aws_security_group.amazon_linux_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
output "rds_sg_name" {
  value = aws_security_group.rds_sg.name
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}