resource "aws_launch_template" "lt" {
  name_prefix   = "al2023-launch-template-"
  image_id      = var.al2023_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # user_data = filebase64("${path.module}/scripts/al_userdata.sh")
  user_data = base64encode(templatefile("${path.module}/scripts/al_userdata.sh", {
    POSTGRES_URL = var.postgres_connection_url
  }))

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups      = [var.ec2_sg_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-instance"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = ["subnet-0c336b21b414e476c"]
  depends_on          = [var.postgres_instance]
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG-Instance"
    propagate_at_launch = true
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
}



resource "aws_instance" "amazon_linux_2023_instance" {
  ami             = var.al2023_ami_id
  instance_type   = var.instance_type
  subnet_id       = "subnet-0c336b21b414e476c"
  key_name        = var.key_name
  security_groups = [var.ec2_sg_id]
  user_data       = base64encode(file("${path.module}/scripts/al_metabase.sh"))
  tags = {
    Name = "Metabase-Instance"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}
