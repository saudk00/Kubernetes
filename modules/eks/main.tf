//IAM Cluster Role
resource "aws_iam_role" "tfeksclusterrole" {
  name = "tfeksclusterrole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tfpolicyattach1" {
  role       = aws_iam_role.tfeksclusterrole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

//IAM Node Group Role
resource "aws_iam_role" "tfnodegrouprole" {
  name = "tfnodegrouprole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tfpolicyattach2" {
  role       = aws_iam_role.tfnodegrouprole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "tfpolicyattach3" {
  role       = aws_iam_role.tfnodegrouprole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "tfpolicyattach4" {
  role       = aws_iam_role.tfnodegrouprole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name        = "AmazonEBSCSIDriverPolicy"
  description = "Policy for EBS CSI Driver"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DetachVolume"
        ],
        "Resource" : "*"
      }
    ]
  })
}

// Attach the Policy to the Node Group Role
resource "aws_iam_role_policy_attachment" "tfpolicyattach5" {
  role       = aws_iam_role.tfnodegrouprole.name
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
}

//EKS Cluster
resource "aws_eks_cluster" "tfcluster" {
  name     = "tfcluster"
  role_arn = aws_iam_role.tfeksclusterrole.arn
  vpc_config {
    subnet_ids = [
      var.subnet_id1,
      var.subnet_id2
    ]
    endpoint_public_access = true
    security_group_ids     = [ var.sg_id ]
  }
  access_config {
    bootstrap_cluster_creator_admin_permissions = true
  }
  depends_on = [aws_iam_role_policy_attachment.tfpolicyattach1]
}

resource "aws_eks_node_group" "tfnodegroup" {
  cluster_name    = aws_eks_cluster.tfcluster.name
  node_role_arn   = aws_iam_role.tfnodegrouprole.arn
  subnet_ids      = [ var.subnet_id1, var.subnet_id2 ]
  ami_type        = "AL2_x86_64"
  instance_types  = [ "t2.medium" ]
  node_group_name = "tfnodegroup"
  launch_template {
    id = var.lt_id
    version = var.lt_version
  }
  scaling_config {
    desired_size = 4
    max_size     = 4
    min_size     = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.tfpolicyattach2,
    aws_iam_role_policy_attachment.tfpolicyattach3,
    aws_iam_role_policy_attachment.tfpolicyattach4
  ]
}
