provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu oficial)

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = "iac"
  user_data = <<-EOF
		 #!/bin/bash
		 cd /home/ubuntu
		 echo "<h1>Feito com Terraform</h1>" > index.html
		 nohup busybox httpd -f -p 8080 &
		 EOF
  tags = {
    Name = "IaC"
  }
}
