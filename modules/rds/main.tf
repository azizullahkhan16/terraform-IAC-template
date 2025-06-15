resource "aws_db_instance" "mysql" {
  identifier              = "mysql-instance"
  engine                  = "mysql"
  engine_version          = "8.0.41"
  db_name                 = "FitnessCenterDB"
  instance_class          = "db.t3.micro"
   storage_type            = "gp2"
  allocated_storage       = 10
  username                = var.username
  password                = var.password
  db_subnet_group_name    = var.rds_subnetgroup_name
  vpc_security_group_ids  = [var.rds_sg_id]
  skip_final_snapshot     = true
  publicly_accessible     = false  
}

resource "aws_db_instance" "postgres" {
  identifier              = "postgres-instance"
  engine                  = "postgres"
  db_name                 = "ShoppinglistApp"
  engine_version          = "17.2"
  instance_class          = "db.t3.micro"
   storage_type            = "gp2"
  allocated_storage       = 10
  username                = var.username
  password                = var.password
  db_subnet_group_name    = var.rds_subnetgroup_name
  vpc_security_group_ids  = [var.rds_sg_id]
  skip_final_snapshot     = true
  publicly_accessible     = false 
}
