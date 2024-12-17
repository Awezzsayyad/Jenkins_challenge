resource "aws_instance" "amazon_linux" {
  ami           = "ami-0dbd9c83830eecdb7" 
  instance_type = "t2.micro"
  key_name = "ubuntu"
  tags = {
    Name = "c8.local"
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-040e71e7b8391cae4" 
  instance_type = "t2.micro"
  key_name = "ubuntu"
  tags = {
    Name = "u21.local"
  }
}

output "instances" {
  value = {
    frontend = aws_instance.amazon_linux.public_ip
    backend  = aws_instance.ubuntu.public_ip
  }
}
