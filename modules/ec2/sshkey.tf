resource "aws_key_pair" "pwx" {
  key_name   = "pwx"
  public_key = file("pwx.pub")
}
