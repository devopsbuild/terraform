resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "example" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.medium" 
  vpc_security_group_ids = ["sg-acb9ccd9"]
  key_name = "${aws_key_pair.mykey.key_name}"

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }
  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
 tags {
    Name = "Terraform_Jenkins"
  }
}
resource "aws_ebs_volume" "ebs-volume-1" {
    availability_zone = "us-east-1b"
    size = 200
    type = "gp2" 
    tags {
        Name = "extra volume data"
    }
}
