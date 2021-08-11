provider "aws" {
  access_key = "AKIA2FAMRCQ6RX2BEZDM"
  secret_key = "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"
  region     = "us-east-2"
}

# data "aws_vpc" "selected" {
#   id = "aws_vpc.terraform-vpc.id"
# }

# resource "aws_subnet" "pubsubnet-1" {
#   vpc_id            = data.aws_vpc.selected.id
#   availability_zone = "us-east-2a"
#   cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 
# }



# resource "aws_instance" "jenkins" {
#   ami             = "ami-0443305dabd4be2bc"
#   instance_type   = "t2.micro"
#   subnet_id       = aws_subnet.pubsubnet-1.id
#   security_groups = ["${aws_security_group.apache2-security-group.id}"]
#   key_name        = "${aws_key_pair.devops.id}"
#   user_data       = file("jenkins.sh")
#   tags = {
#     Name = "jenkins"
#   }
# }












data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["Default"]
  }
}

resource "aws_subnet" "example1" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "172.31..0/20"
  map_public_ip_on_launch = true
}
data "template_file" "user_data" {
  template = "${file("jenkins.sh")}"
}

resource "aws_instance" "jenkins" {
  ami             = "ami-0443305dabd4be2bc"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.example1.id
  security_groups = ["${aws_security_group.jenkins-security-group.id}"]
  key_name        = "${aws_key_pair.devops1.id}"
  user_data       = file("jenkins.sh")
  tags = {
    Name = "jenkins"
  }
}
output "jenkins_endpoint" {
  value = formatlist("/var/lib/jenkins/secrets/initialAdminPassword")
}
resource "aws_security_group" "jenkins-security-group" {
  name        = "jenkins-security-group"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    # SSH Port 22 allowed from any IP
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
      # SSH Port 80 allowed from any IP
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





resource "aws_key_pair" "id_rsa.pub" {
  key_name   = "pub-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7y0FrLmokst638qQuEnrA4f9feFhHsfDEF/0gtvTaxIW+AuWT74I5k8yZgSXhB7RcKaLohwrTs9JLpTuED/4yxemzWk6vamxHMdIT8phw/uIfKP52rcCwKrRbgPxOkhJdLkjh651is9b87dbyZ4J9p9rQuIi3+5mB9IRkX4f5c+wjUN9tTJftyQI02LFLlE3+FtrR6gSH9fzE8MLG+2UHRBCSOzi5mUXh7JhX74BN9RnXvdowsfeeLnSc764s21FeRZeJ1C8mbmwOl4pAf2DjSfGN6j2RT3ceYQkwQPCcR9ne66/cn0CHqUvcH84Byjy8YwBhSAm2yRB+eoxAI301Gj4P8ZF5fKVW/yPwrno0p7OS/9yrAWjy1gyiH21QrDBK9nGd/OYIrpW2nABHR2qUTNOHkbV9P8aJ9wsh2WlRD5ZDTwfogpp0gDN5YjO7F8A0ohWZ8UFFnWUzW4/zgq4V+pTMPujL/FUQkab9X4ODf8XnCtyJaEPl7Edl315O800= admin@DESKTOP-0A4UJ7F}
