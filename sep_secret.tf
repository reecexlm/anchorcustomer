

resource "kubernetes_secret" "sep_cert" {
  metadata {
    name = "anchor-platform-sep-server-cert"
  }
  data = {
    "tls.crt" = <<EOT
    -----BEGIN CERTIFICATE-----
MIIDCDCCAfACCQDttooKqNvmZzANBgkqhkiG9w0BAQsFADBGMSEwHwYDVQQDDBhS
ZWVjZXMtTWFjQm9vay1Qcm8ubG9jYWwxITAfBgNVBAoMGFJlZWNlcy1NYWNCb29r
LVByby5sb2NhbDAeFw0yMjA1MDcxNjEwNDJaFw0yMzA1MDcxNjEwNDJaMEYxITAf
BgNVBAMMGFJlZWNlcy1NYWNCb29rLVByby5sb2NhbDEhMB8GA1UECgwYUmVlY2Vz
LU1hY0Jvb2stUHJvLmxvY2FsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA5Ewx5YBg4bBWdBJAwzi0FwqNiwq2xrSrdv6pDewf1/evBIi5ymLORROmDN/m
ZebOPcrGz6mKDOYPi3yF6a+GaGmj2eWqaBuQb+iemIi05bf/4m5JSFTSIYMXIkKW
NdGt9o8UOKuPs1/uNl/opwbFh11NIHdMamhgj7gk9Rkb7hpZmrZIjzjeuFNo8Qg0
CrcrpasnVBxSbmSwW7FWgiDmVYSPdLaKenIw4QOZfS5dlO7yvjEhgUwpgHhfr9M9
Ho1Vbh1mSEkbUZnc/NNK8nC8g431SuaWs1BRBSjc7QW4PZHcotAvhfPlRC8hbtKt
mr8IveB2e6dM+FtgCETWd0r7UQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQA9QH6y
QxmuauglBI9uNGbKJu5vwoBkG37mShNnzbhGgOq8PCoQYEcN+3/K5WqiDMgcDO8L
ZNiWhVGb+chlu2TX7eSKTsoo8nFvj9ikIZw4IkgouN07w5eUdK6Y4bzAcw6U1KsY
fZ9dsluUuwMXShjsw9IKMptsA++Y9UbaZ0HnoAyUzP4mHj59OFcV4QKhMddcb8Se
+gYK1BQWMzJNjqlE+AIw76yOuX4O+NzG/ngT9IV0M8YGZJP+ECMwdXu/lNsMv/QE
iALp8aKCvXGiA+PS7222H8LBdg9FHzuxFe+NPS7jaYblhW1Ncd8oVZZljEJDYPhH
8nLE2ZxtKKtAyX/e
-----END CERTIFICATE-----
EOT
  type = "kubernetes.io/tls"
}