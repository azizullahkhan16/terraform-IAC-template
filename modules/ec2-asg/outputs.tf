output "asg_name" {
  value = aws_autoscaling_group.asg.name
}
output "ec2_insance_ip" {
  value = aws_instance.amazon_linux_2023_instance.public_ip
}