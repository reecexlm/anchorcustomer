data "aws_secretsmanager_secret" "sep-cert-arn" {
  arn = "arn:aws:secretsmanager:us-east-2:245943599471:secret:sep_cert-m8hg7I"
}

resource "kubernetes_secret" "sep_cert" {
  metadata {
    name = "anchor-platform-sep-server-cert"
  }

  data = {
      tls.crt = aws_secretsmanager_secret.sep-cert-arn.secret_string
      }
      type = "kubernetes.io/tls"
}