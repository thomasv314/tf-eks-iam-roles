resource "aws_iam_role" "role" {
  for_each           = local.computed_roles
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.trust_relationship[each.key].json
}

resource "aws_iam_role_policy_attachment" "policy" {
  count      = length(local.computed_roles_policies)
  role       = local.computed_roles_policies[count.index].role
  policy_arn = local.computed_roles_policies[count.index].policy_arn

  depends_on = [aws_iam_role.role]
}

data "aws_iam_policy_document" "trust_relationship" {
  for_each = local.computed_roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${local.account_id}:oidc-provider/${local.cluster_oidc_issuer}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.cluster_oidc_issuer}:sub"
      values   = ["system:serviceaccount:${each.value.namespace}:${each.value.name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.cluster_oidc_issuer}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}
