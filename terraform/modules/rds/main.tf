resource "aws_db_subnet_group" "db" {
  name       = lower(var.name)
  subnet_ids = var.subnets
}

resource "aws_db_instance" "db" {
  allocated_storage                   = 10
  identifier                          = var.name
  db_name                             = var.name
  engine                              = "postgres"
  engine_version                      = "17.6"
  instance_class                      = "db.t4g.micro"
  manage_master_user_password         = true
  username                            = "postgres"
  parameter_group_name                = "default.postgres17"
  multi_az                            = false
  storage_encrypted                   = true
  publicly_accessible                 = false
  db_subnet_group_name                = aws_db_subnet_group.db.name
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
}
