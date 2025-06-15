output "alb_dns" {
  value = aws_lb.app_lb.dns_name
}
output "load_balancer_zone_id" {
  description = "The Zone ID of the load balancer for Route 53 alias records"
  value       = aws_lb.app_lb.zone_id
}
output "load_balancer_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.app_lb.arn
}

output "load_balancer_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.app_lb.id
}