variable "cluster" {
  description = "The EKS Cluster Name"
  type        = string
}

variable "roles" {
  description = "List of roles"
  type = list(
    object(
      {
        namespace = string,
        name      = string,
        policies  = list(string)
      }
    )
  )
}

variable "role_prefix" {
  description = "prefix the roles provisioned"
  default     = "eks-iam"
}

locals {
  account_id = data.aws_caller_identity.current.account_id

  computed_roles_policies = flatten([
    for role in var.roles : [
      for policy in role.policies : {
        role       = "${var.role_prefix}-${role.namespace}-${role.name}"
        role_spec  = role
        policy_arn = policy
      }
    ]
  ])

  computed_roles = { for item in local.computed_roles_policies : item.role => item.role_spec }

  cluster_oidc_issuer = replace(
    data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer,
    "https://",
    ""
  )
}
