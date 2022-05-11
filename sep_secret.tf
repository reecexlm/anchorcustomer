data "aws_secretsmanager_secret" "sep_cert" {
  arn = "arn:aws:secretsmanager:us-east-2:245943599471:secret:sep_cert-m8hg7I"
}

esource "kubernetes_secret" "sep_cert" {
  metadata {
    name = "anchor-platform-sep-server-cert"
  }


  data = {
    "tls.crt" = jsondecode(data.aws_secretsmanager_secret.sep_cert.secret_string)["crt"]
    "tls.key" = jsondecode(data.aws_secretsmanager_secret.sep_cert.secret_string)("key")
}
  type = "kubernetes.io/tls"
}