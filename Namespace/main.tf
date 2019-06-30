resource "kubernetes_namespace" "example" {
  metadata {
#    annotations {
#      name = "example-annotation"
#    }

#    labels {
#      mylabel = "label-value"
#    }

    name = "dev-terraform-system"
  }
}


#output "nameSpace" { value =  "${kubernetes_namespace.example.metadata.0.name}"  }
#output "nameSpace" { value =  module.terraModule.kubernetes_namespace.example.metadata.0.name }
output "nameSpace" { value = resources.instances.0.metadata.0.name }
