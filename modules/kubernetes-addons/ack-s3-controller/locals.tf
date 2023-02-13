locals {

  name                  = "ack-s3-controller"
  namespace             = "ack-system"
  service_account_name  = "${local.name}"
  erc_region            = "us-east-1"
  policy_arn_prefix     = "arn:${var.addon_context.aws_partition_id}:iam::aws:policy"


  default_helm_config = {
    name             = local.name
    chart            = "s3-chart"
    repository       = "oci://public.ecr.aws/aws-controllers-k8s"
    version          = "v0.1.5"
    namespace        = local.namespace
    timeout          = 1200
    create_namespace = true
    values           = local.default_helm_values
    description      = "ack-s3-controller Helm Chart"
    wait             = false
  }
  
  default_helm_values  = ["${file("${path.module}/values.yaml")}"]
  # default_helm_values = [templatefile("${path.module}/values.yaml", {
  #   aws_region = var.addon_context.aws_region_name
  # })]

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  set_values = concat(
    [
      # {
      #   name  = "aws.region"
      #   value = local.erc_region
      # },
      {
        name  = "serviceAccount.create"
        value = false
      }
    ],
    try(var.helm_config.set_values, [])
  )

  irsa_config = {
    kubernetes_namespace              = local.helm_config["namespace"]
    kubernetes_service_account        = local.service_account_name
    create_kubernetes_namespace       = try(local.helm_config["create_namespace"], true)
    create_kubernetes_service_account = true
    irsa_iam_policies                 = ["${local.policy_arn_prefix}/AmazonS3FullAccess"] 
  }

  argocd_gitops_config = {
    enable             = true
    serviceAccountName = local.service_account_name
  }

  # meta.helm.sh/release-name: ack-s3-controller
  # meta.helm.sh/release-namespace: ack-system

  # ack_policies = { for k, v in toset(concat([
  #   "${local.policy_arn_prefix}/AmazonS3FullAccess"],
  #   local.managed_node_group["additional_iam_policies"
  # ])) : k => v if local.managed_node_group["create_iam_role"] }


}
