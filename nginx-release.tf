resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
  reset_values     = true
  max_history      = 3
  timeout          = 600
  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "false"
  }
    values = [
    file("${path.module}/nginx-values.yaml")
  ]
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "${helm_release.ingress-nginx.name}-nginx-ingress-controller"
    namespace = kubernetes_namespace.ingress-nginx.metadata[0].name
  }
}

resource "aws_route53_record" "anchor_record" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "www.stellaranchordemo.com"
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress_nginx.load_balancer_ingress[0].hostname
    zone_id                = data.kubernetes_service.ingress_nginx.load_balancer_ingress[0].zone_id
    evaluate_target_health = true
  }
}