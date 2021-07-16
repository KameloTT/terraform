resource "aws_key_pair" "gitlab" {
  key_name   = "gitlab"
  public_key = file("gitlab.pub")
}
