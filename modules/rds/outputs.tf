output "postgres_instance" {
  value = aws_db_instance.postgres
}
output "postgres_connection_url" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${aws_db_instance.postgres.username}:${aws_db_instance.postgres.password}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}?sslmode=require"
  sensitive   = true
}
