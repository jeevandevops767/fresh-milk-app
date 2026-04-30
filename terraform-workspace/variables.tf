variable "project_id" {}
variable "region" { default = "us-central1" }
variable "zone" { default = "us-central1-a" }

variable "vpc_name" { default = "my-vpc" }
variable "subnet_name" { default = "private-subnet" }

variable "cluster_name" { default = "gke-cluster" }