resource "aws_instance" "bastion" {
  ami             = "ami-00bf4ae5a7909786c"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public-subnet-1.id
  security_groups = ["${aws_security_group.bastion-security-roup.id}"]
  key_name        = "${aws_key_pair.petclinic.key_name}"
  tags = {
    Name = "bastion"
  }
}
