resource "aws_db_subnet_group" "studentus_db" {
  name       = "studentus_db"
  subnet_ids = var.subnets
}

resource "aws_db_instance" "studentus_db" {
  allocated_storage           = 10
  db_name                     = "studentus_db"
  engine                      = "postgres"
  engine_version              = "17.6"
  instance_class              = "db.t4g.micro"
  manage_master_user_password = true
  username                    = "postgres"
  parameter_group_name        = "default.postgres17"
  multi_az                    = false
  storage_encrypted           = true
  publicly_accessible         = false
  db_subnet_group_name        = aws_db_subnet_group.studentus_db.name
  skip_final_snapshot         = true
}
