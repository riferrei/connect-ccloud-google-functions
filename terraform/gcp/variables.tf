variable "global_prefix" {

  default = "myfunction"

}

variable "gcp_region" {

  default = "us-central1"

}

variable "gcp_availability_zones" {

  type = "list"

  default = ["us-central1-a"]

}

variable "confluent_platform_location" {

  default = "http://packages.confluent.io/archive/5.2/confluent-5.2.1-2.12.zip"

}

variable "confluent_home_value" {

  default = "/etc/confluent/confluent-5.2.1"

}