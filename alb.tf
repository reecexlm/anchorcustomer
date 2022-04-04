resource "aws_eip" "lb_eip" {
  vpc = true
}

resource "aws_lb" "dev" {
  name               = "anchor-platform-dev"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = module.vpc.public_subnets 
  allocation_id = aws_eip.lb_eip.id
  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}