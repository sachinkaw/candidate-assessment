resource "aws_security_group" "this" {
  name        = "${var.name}-database"
  description = "PostgreSQL access from explicitly authorized security groups only."
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_security_group_ids
    content {
      description     = "PostgreSQL from an approved security group"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-database-private"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-database-private"
  })
}

resource "random_password" "this" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "this" {
  name                    = var.database_secret_name
  recovery_window_in_days = 7

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier                 = "${var.name}-postgres"
  engine                     = "postgres"
  engine_version             = var.postgres_engine_version
  instance_class             = var.database_instance_class
  allocated_storage          = var.database_allocated_storage
  max_allocated_storage      = var.database_max_allocated_storage
  storage_encrypted          = true
  db_name                    = var.database_name
  username                   = var.database_username
  password                   = random_password.this.result
  port                       = 5432
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.this.id]
  publicly_accessible        = false
  multi_az                   = true
  backup_retention_period    = 7
  auto_minor_version_upgrade = true
  deletion_protection        = true
  skip_final_snapshot        = false
  final_snapshot_identifier  = "${var.name}-postgres-final"
  copy_tags_to_snapshot      = true

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    dbname   = var.database_name
    username = var.database_username
    password = random_password.this.result
  })
}
