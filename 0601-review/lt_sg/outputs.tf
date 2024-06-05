output "sg_id" {
  value = aws_security_group.tfeks-sg.id
}

output "lt_id" {
  value = aws_launch_template.cluster_lt.id
}

output "lt_version" {
  value = aws_launch_template.cluster_lt.latest_version
}