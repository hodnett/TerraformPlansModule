resource "kubernetes_pod" "echo" {
  metadata {
    name = "echo-example"
    labels {
      App = "echo"
  } }
  spec {
    container {
      image = "hashicorp/http-echo:0.2.1"
      name  = "example2"
      args = ["-listen=:80", "-text='Hello World'"]
      port {
        container_port = 80
} } } }

output "podName" { value =  "${kubernetes_pod.echo.metadata.0.name}"  }
