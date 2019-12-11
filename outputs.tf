output "instance_name" {
  value = aws_instance.jmeter_instance.tags["Name"]
}

output "instance_address" {
  value = aws_instance.jmeter_instance.public_ip
}
