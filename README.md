# tf-eks-iam-roles

Generates IAM Roles for use with Service Accounts on EKS

## Usage

```
module "eks-iam" {
  source = "git@github.com/thomasv314/terraform-eks-iam-roles.git?ref=master"

  # Name of an existing EKS cluster
  cluster = "dev-cluster"

  # An array of roles, namespace, and policies to attach to the new role
  roles = [
    {
      namespace = "ops"
      name      = "external-dns"
      policies = [
        "arn:aws:iam::123456789:policy/external-dns"
      ]
    }
  ]

  # Optional: A role prefix to append prior to the namespace/name of the service account
  role_prefix = "eks-iam-role"
}
```
