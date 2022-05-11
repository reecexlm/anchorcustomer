

resource "kubernetes_secret" "sep_cert" {
  metadata {
    name = "anchor-platform-sep-server-cert"
  }

  data "aws_secretsmanager_secret" "sep-cert" {
  arn = "arn:aws:secretsmanager:us-east-2:245943599471:secret:sep_cert-m8hg7I"
}
  data = {
    "tls.crt" = data.aws_secretsmanager_secret.sep-cert.crt
    "tls.key" = data.aws_secretsmanager_secret.sep-cert.key
}
  type = "kubernetes.io/tls"
}