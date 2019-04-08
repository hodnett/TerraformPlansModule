provider "kubernetes" {
config_path = "/home/opsmxuser/.kube/config"
}

resource "kubernetes_service" "echo" {
  metadata {
    name = "echo-example"
  }
  spec {
    selector {
      App = "${kubernetes_pod.echo.metadata.0.labels.App}"
    }
    port {
      port        = 80
      target_port = 80
    }
    #type = "LoadBalancer"
    type = "NodePort"	
} }
