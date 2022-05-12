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

  values = [templatefile("${path.module}/nginx-values.yaml",
    local.s_template_vars)]
    depends_on = [module.eks.cluster_id]
}

data "kubernetes_ingress" "example" {
  metadata {
    name = "ingress-nginx"
    namespace = "ingress-nginx"
  }
  depends_on = [module.eks.cluster_id]
}

resource "aws_route53_zone" "anchorzone" {
  name = "www.stellaranchordemo.com"
}

data "aws_route53_zone" "anchorzonedata" {
  name         = aws_route53_zone.anchorzone.name
  private_zone = false
}

resource "aws_route53_record" "anchor_record" {
  zone_id = data.aws_route53_zone.anchorzonedata.zone_id
  name    = "www.stellaranchordemo.com"
  type    = "A"
  ttl     = "300"
  records = [data.kubernetes_ingress.example.status.0.load_balancer.0.ingress.0.hostname]
}