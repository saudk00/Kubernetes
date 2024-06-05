//Security Group
resource "aws_security_group" "tfeks-sg" {
  name        = "tfeks-sg"
  description = "secuirty group for eks"
  vpc_id      = var.vpcid

  ingress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "cluster_lt" {
  name = "cluster_lt"
  vpc_security_group_ids = [aws_security_group.tfeks-sg.id]

  depends_on = [ aws_security_group.tfeks-sg ]
}