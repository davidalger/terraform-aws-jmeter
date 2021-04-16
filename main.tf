locals {
  # Rendered user-data can be fetched and reviewed on the resulting instance via following:
  #
  #   curl -s http://169.254.169.254/latest/user-data | gunzip -c | tail -n1 | jq -r
  #
  user_data = {
    fqdn         = var.name
    hostname     = var.name
    disable_root = true
    ssh_pwauth   = false

    users = [{
      name                = var.instance_user
      groups              = ["wheel", "adm", "systemd-journal"]
      sudo                = ["ALL=(ALL) NOPASSWD:ALL"]
      ssh_authorized_keys = var.authorized_keys
    }]

    runcmd = [
      # Disable ability to login via SSH as root user
      "perl -i -pe 's/#PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config",
      "systemctl reload sshd.service",

      # Install packages which must be installed after epel-release 
      "yum install -y jq",

      # Install jmeter and all it's dependencies as the operating user
      "sudo -i -u ${var.instance_user} /usr/local/bin/setup-jmeter.sh",
    ]

    packages = [
      "epel-release", # required for installing things like fail2ban
      "perl",         # required for adjusting sshd_config on startup
    ]

    write_files = [for file in local.instance_files : {
      path        = "/${trimprefix(file.path, "/")}"
      owner       = lookup(file, "owner", "root:root")
      permissions = lookup(file, "permissions", "0600")
      encoding    = lookup(file, "encoding", "base64")
      content = lookup(
        file,
        "content",
        lookup(file, "content", "") == "" ? filebase64("${abspath(path.root)}/files/${file.path}") : ""
      )
    }]
  }

  instance_files = [
    {
      path        = "/etc/profile.d/boilerplate.sh"
      permissions = "0755"
      content     = filebase64("${path.module}/files/profile.d/boilerplate.sh")
    },
    {
      path        = "/usr/local/bin/setup-jmeter.sh"
      permissions = "0755"
      content     = base64encode(replace(
        file("${path.module}/files/setup-jmeter.sh"),
        "/JMETER_VERSION=.*/",
        "JMETER_VERSION=${var.jmeter_version}",
      ))
    },
  ]
}

data "aws_ami" "centos" {
  owners      = ["125523088429"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS 7.9.2009 x86_64"]
  }
}

resource "aws_instance" "jmeter_instance" {
  ami              = data.aws_ami.centos.image_id
  instance_type    = var.instance_type
  user_data_base64 = base64gzip("#cloud-config\n${jsonencode(local.user_data)}")
  subnet_id        = var.subnet_id
  tags             = merge(var.tags, { Name = var.name })

  associate_public_ip_address = true
  vpc_security_group_ids      = concat([aws_security_group.jmeter_instance.id], var.security_groups)

  root_block_device {
    delete_on_termination = true
  }
}

resource "aws_eip" "jmeter_instance" {
  instance = aws_instance.jmeter_instance.id
  vpc      = true
  tags     = merge(var.tags, { Name = var.name })
}

resource "aws_security_group" "jmeter_instance" {
  name   = var.name
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
