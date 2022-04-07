locals {
  alb_controller_helm_repo     = "https://aws.github.io/eks-charts"
  alb_controller_chart_name    = "aws-load-balancer-controller"
  alb_controller_chart_version = var.aws_load_balancer_controller_chart_version
  aws_alb_ingress_class        = "alb"
  aws_vpc_id                   = data.aws_vpc.selected.id
  aws_region_name              = data.aws_region.current.name
  aws_iam_path_prefix          = var.aws_iam_path_prefix == "" ? null : var.aws_iam_path_prefix
}
resource "helm_release" "sep" {
  name             = "sep-server"
  chart            = "./charts/sep"
  namespace        = "anchor-platform"
  version          = "17.1.3"
  create_namespace = true
  wait             = true
  reset_values     = true
  max_history      = 3
  timeout          = 600

    values = [
    file("${path.module}/anchor-platform-sep-server-values.yaml")
  ]
}

resource "helm_release" "alb_controller" {

  name       = "aws-load-balancer-controller"
  repository = local.alb_controller_helm_repo
  chart      = local.alb_controller_chart_name
  version    = local.alb_controller_chart_version
  namespace  = var.k8s_namespace
  atomic     = true
  timeout    = 900

  dynamic "set" {

    for_each = {
      "clusterName"           = var.k8s_cluster_name
      "serviceAccount.create" = (var.k8s_cluster_type != "eks")
      "serviceAccount.name"   = (var.k8s_cluster_type == "eks") ? kubernetes_service_account.this.metadata[0].name : null
      "region"                = local.aws_region_name
      "vpcId"                 = local.aws_vpc_id
      "hostNetwork"           = var.enable_host_networking
    }
    content {
      name  = set.key
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.chart_env_overrides
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [var.alb_controller_depends_on]
}