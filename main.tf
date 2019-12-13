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
  vpc_security_group_ids      = concat([aws_security_group.jmeter_instance.id], var.security_groups)

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
    script = "${path.module}/startup-script.sh"
  }
}

resource "aws_security_group" "jmeter_instance" {
  name   = "${var.name}-ec2-jmeter"
  vpc_id = var.vpc_id
  tags   = var.tags

  ingress {
    description = "Allow ICMP ingress from trusted IP ranges"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.trusted_ip_ranges
  }

  ingress {
    description = "Allow SSH ingress from trusted IP ranges"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.trusted_ip_ranges
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
