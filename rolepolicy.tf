provider "aws" {
  profile = "ppclassic"
  region  = "us-east-1"
}
resource "aws_iam_role" "EC2_role" {
  name = "EC2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      Name = "EC2_role"
  }
}

resource "aws_iam_instance_profile" "EC2_profile" {
  name = "EC2_profile"
  role = "${aws_iam_role.EC2_role.name}"
  }
  
resource "aws_iam_role_policy" "EC2_policy" {
  name = "EC2_policy"
  role = "${aws_iam_role.EC2_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::trainbucket"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::trainbucket/*"]
        }
    ]
}
EOF
}

resource "aws_instance" "role-testing" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.EC2_profile.name}"
}