# Fetch hosted zone
data "aws_route53_zone" "main" {
  name = "azizullahkhan.tech."  # Ensure trailing dot
  private_zone = false  
}

resource "aws_route53_record" "amazon_linux_2" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "shoppinglist.azizullahkhan.tech"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# A record for Metabase Instance
resource "aws_route53_record" "metabase_instance" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "mb.azizullahkhan.tech"
  type    = "A"
  ttl     = 60
  records = [var.ec2_instance_public_ip]
}
