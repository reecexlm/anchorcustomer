resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace        = "ingress-nginx"
  version          = "17.1.3"
  create_namespace = true
  wait             = true
  reset_values     = true
  max_history      = 3
  timeout          = 600

    values = [
    file("${path.module}/nginx-values.yaml")
  ]
}