resource "helm_release" "nginx" {
  name        = "./charts/nginx"
  chart       = "nginx"
  namespace   = "nginx"
  max_history = 3
  create_namespace = true
  wait             = true
  reset_values     = true
}