resource "kubernetes_namespace" "little_caesar" {
  metadata {
    annotations = {
      name = local.name
    }

    labels = local.labels

    name = local.name
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    namespace = local.name
    name      = local.name
    labels    = local.labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${local.name}-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "${local.name}-frontend"
        }
      }

      spec {
        container {
          image = "arm64v8/httpd:2.4.57-alpine3.18"
          name  = "${local.name}-frontend"
          port {
            name           = "www"
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = local.svcacc_aws_lb_ctr
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = local.svcacc_aws_lb_ctr
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lb_controller.arn
    }
  }
}

resource "null_resource" "aws_load_balancer_controller" {
  provisioner "local-exec" {
    command     = "helm repo add eks https://aws.github.io/eks-charts"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "helm repo update eks"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=${local.cluster_name} --set serviceAccount.create=false --set serviceAccount.name=${local.svcacc_aws_lb_ctr}"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    kubernetes_service_account.aws_load_balancer_controller
  ]
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "${local.name}-frontend"
    namespace = local.name
  }
  spec {
    selector = {
      app = "${local.name}-frontend"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name      = local.name
    namespace = local.name
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      #"alb.ingress.kubernetes.io/scheme"      = "internal"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    default_backend {
      service {
        name = "${local.name}-frontend"
        port {
          number = 80
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = "${local.name}-frontend"
              port {
                number = 80
              }
            }
          }

          path      = "/"
          path_type = "Prefix"
        }
      }
    }

    #tls {
    #  secret_name = "tls-secret"
    #}
  }
  depends_on = [kubernetes_namespace.little_caesar]
}
