resource "helm_release" "nginx" {
  name        = "./charts"
  chart       = "nginx"
  namespace   = "nginx"
  repository  = "./charts"
  max_history = 3
  create_namespace = true
  wait             = true
  reset_values     = true
}