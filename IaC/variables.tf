variable "environment" {}
variable "aws_region" {}
variable "availability_zone_names" {}
variable "aws_account_id" {
  description = "TF_VAR_aws_account_id is a zsh env variable"
}
variable "home" {
  description = "TF_VAR_home is a zsh env variable"
}
