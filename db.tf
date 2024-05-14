resource "aws_db_instance" "my_database" {
  identifier            = "my-postgresql-db"
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "postgres"
  engine_version        = "12.5"
  instance_class        = "db.t2.micro"
  db_name               = "mlflow_registry"
  username              = "admin"
  password              = random_password.db_password.result
  publicly_accessible   = false
  skip_final_snapshot   = true

  tags = {
    Name = "mlflow"
  }

  depends_on = [aws_internet_gateway.main]

}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "db_password"
  type  = "SecureString"
  value = random_password.db_password.result
  
}