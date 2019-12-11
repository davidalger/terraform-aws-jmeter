data "aws_ami" "centos" {
  most_recent = true
  owners      = ["aws-marketplace"]

  ## CentOS Linux 7 x86_64 HVM EBS ENA 1804_2
  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

resource "aws_instance" "jmeter_instance" {
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  tags = merge(var.tags, {
    Name = var.name
  })

  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_groups

  root_block_device {
    delete_on_termination = true
  }

  connection {
    user = "centos"
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      <<-EOT
        set -x
        sudo hostname "${var.name}"
        echo "${var.name}" | sudo tee /etc/hostname
      EOT
    ]
  }

  provisioner "remote-exec" {
    script = "startup-script.sh"
  }
}
