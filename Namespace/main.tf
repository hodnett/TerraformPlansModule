resource "kubernetes_namespace" "example" {
  metadata {
    annotations {
      name = "example-annotation"
    }

    labels {
      mylabel = "label-value"
    }

    name = "terraformexample1"
  }
}


output "nameSpace" { value =  "${kubernetes_namespace.example.metadata.0.name}"  }
