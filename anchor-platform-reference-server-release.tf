provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "reference" {
  name             = "reference-server"
  chart            = "./charts/reference"
  namespace        = "anchor-platform"
  version          = "17.1.3"
  create_namespace = true
  wait             = true
  reset_values     = true
  max_history      = 3
  timeout          = 600

    values = [
    file("${path.module}/anchor-platform-reference-server-values.yaml")
  ]
}











