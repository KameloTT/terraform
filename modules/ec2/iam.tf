resource "aws_iam_role" "all_role" {
  name = "test_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
            "Sid": "Vivi",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "all_policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.all_role.name
  policy_arn = aws_iam_policy.all_policy.arn
}


resource "aws_iam_instance_profile" "all_profile" {
  name  = "mon_ec2_profile"
  role = aws_iam_role.all_role.name
}


