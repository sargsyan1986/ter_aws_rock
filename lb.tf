resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_1stsg.id]

  subnets = [aws_subnet.public-us-east-1a.id, aws_subnet.public-us-east-1b.id]

}

resource "aws_lb_listener" "listener1" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "http"
}
