data "kubernetes_ingress" "sep" {
  metadata {
    name = "sep-server-ingress"
    namespace = "anchor-platform"
  }
  depends_on = [resource.helm_release.sep.status] 
}

data "kubernetes_ingress" "reference" {
  metadata {
    name = "reference-server-ingress"
    namespace = "anchor-platform"
  }
  depends_on = [resource.helm_release.reference.status]
}
locals {
  sep_template_vars = {
    reference_endpoint = data.kubernetes_ingress.reference.status.0.load_balancer.0.ingress.0.hostname
    sep_endpoint = data.kubernetes_ingress.sep.status.0.load_balancer.0.ingress.0.hostname
  }
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

    #values = []#"${path.module}/anchor-platform-sep-server-values.yaml"]
    values = [templatefile("${path.module}/anchor-platform-sep-server-values.yaml",
    local.sep_template_vars)]
    depends_on = [module.eks.cluster_id]
}

