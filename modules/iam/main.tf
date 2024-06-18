# Create IAM user
resource "aws_iam_user" "k8user" {
  name = "k8tfuser"
}
# Define policy for EKS permissions
data "aws_iam_policy_document" "eks_policy" {
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters"
    ]
    resources = ["*"]
  }
}
# Create the EKS policy
resource "aws_iam_policy" "eks_policy" {
  name        = "EKSDescribeListPolicy"
  description = "Policy for EKS describe and list clusters"
  policy      = data.aws_iam_policy_document.eks_policy.json
}

# Attach the EKS policy to the user
resource "aws_iam_user_policy_attachment" "eks_policy_attachment" {
  user       = aws_iam_user.k8user.name
  policy_arn = aws_iam_policy.eks_policy.arn
}
# Define policy for EC2 permissions
data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }
}
# Create the EC2 policy
resource "aws_iam_policy" "ec2_policy" {
  name        = "EC2DescribePolicy"
  description = "Policy for EC2 describe instances, instance status, and tags"
  policy      = data.aws_iam_policy_document.ec2_policy.json
}
# Attach the EC2 policy to the user
resource "aws_iam_user_policy_attachment" "ec2_policy_attachment" {
  user       = aws_iam_user.k8user.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}