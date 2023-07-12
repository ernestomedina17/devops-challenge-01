variable "environment" {}
variable "aws_region" {}
variable "availability_zone_names" {}
variable "aws_account_id" {
  type        = string
  description = "TF_VAR_aws_account_id is a zsh env variable"
}
variable "myhome" {
  type        = string
  description = "TF_VAR_myhome is a zsh env variable"
}
