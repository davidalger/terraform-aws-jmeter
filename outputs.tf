output "instance_id" {
  value = aws_instance.jmeter_instance.id
}

output "instance_arn" {
  value = aws_instance.jmeter_instance.arn
}

output "instance_name" {
  value = aws_instance.jmeter_instance.tags["Name"]
}

output "instance_user" {
  value = var.instance_user
}

output "instance_address" {
  value = aws_eip.jmeter_instance.public_ip
}
