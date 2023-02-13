


module "helm_addon" {
  source            = "../helm-addon"
  manage_via_gitops = var.manage_via_gitops
  set_values        = local.set_values
  helm_config       = local.helm_config
  irsa_config       = local.irsa_config
  # irsa_policies     = local.irsa_config.irsa_iam_policies
  addon_context     = var.addon_context
}



#------------------------------------
# IAM Policy
#------------------------------------

# resource "aws_iam_policy" "ack_s3_controller" {
#   description = "ACK-S3-Controller IAM policy."
#   name        = "${var.addon_context.eks_cluster_id}-${local.helm_config["name"]}-irsa"
#   path        = var.addon_context.irsa_iam_role_path
#   policy      = data.aws_iam_policy_document.external_dns_iam_policy_document.json
# }


