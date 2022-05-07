
resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "jetstack/cert-manager"
  namespace        = "cert-manager"
  version          = "17.1.3"
  create_namespace = true
  wait             = true
  reset_values     = true
  max_history      = 3
  timeout          = 600
}

