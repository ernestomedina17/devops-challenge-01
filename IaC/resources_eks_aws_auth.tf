resource "local_file" "aws_auth_configmap" {
  content         = local.config_map_aws_auth
  filename        = "${path.root}/config_map_aws_auth.yaml"
  file_permission = "0644"
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command     = "[ -e config_map_aws_auth.yaml ] && rm -v ~/.kube/config || echo 0"
    interpreter = ["/bin/bash", "-c"]
  }
  provisioner "local-exec" {
    command     = "aws eks update-kubeconfig --region eu-central-1 --name unicron"
    interpreter = ["/bin/bash", "-c"]
  }
  provisioner "local-exec" {
    command     = "kubectl apply -f config_map_aws_auth.yaml"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    local_file.aws_auth_configmap,
    aws_eks_cluster.unicron
  ]
}
