

############################################################
##############            MAIN           ###################
############################################################

#-----------Aws Controller K8s [S3]-----------------------

module "ack_s3_controller" {
  source            = "./ack-s3-controller"
  count             = var.enable_ack_s3_controller ? 1 : 0
  helm_config       = var.ack_s3_controller_helm_config
  manage_via_gitops = var.argocd_manage_add_ons
  addon_context     = local.addon_context
}


############################################################
##############          OUTPUT           ###################
############################################################

#-----------Aws Controller K8s [S3]-----------------------
variable "enable_ack_s3_controller" {
  description = "Enable Aws Controller K8s"
  type        = bool
  default     = false
}
variable "ack_s3_controller_helm_config" {
  description = "Aws S3 Controller Kubernetes add-on config"
  type        = any
  default     = {}
}



############################################################
##@@############         VARIABLE          #################
############################################################

variable "ack_eks_controller_irsa_policies" {
  description = "Additional IAM policies for a IAM role for service accounts"
  type        = list(string)
  default     = []
}
