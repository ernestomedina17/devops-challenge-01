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
