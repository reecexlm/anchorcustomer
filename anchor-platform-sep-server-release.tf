data "kubernetes_ingress" "reference" {
  metadata {
    name = "reference-server-ingress"
  }
}
locals {
  template_vars = {
    reference_endpoint = data.kubernetes_ingress.reference.status.0.load_balancer.0.ingress.0.hostname
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

    values = templatefile("${path.module}/anchor-platform-sep-server-values.yaml",
    local.template_vars)
}






  helm_chart_values = templatefile(
      "${path.module}/anchor-platform-reference-server-values.yaml",
      local.template_vars
  )
}
