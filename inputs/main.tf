variable "etcd_endpoints" {}

terraform {
  backend "etcd" {
    path      = "terraform-tfstate"
    endpoints = "${var.etcd_endpoints}"
  }
}
