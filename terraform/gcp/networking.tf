###########################################
################### VPC ###################
###########################################
resource "google_compute_network" "default" {

  name = "${var.global_prefix}"
  auto_create_subnetworks = false

}

###########################################
################# Subnets #################
###########################################

resource "google_compute_subnetwork" "private_subnet" {

  name = "private-subnet-${var.global_prefix}"
  project = "${var.gcp_project}"
  region = "${var.gcp_region}"
  network = "${google_compute_network.default.id}"
  ip_cidr_range = "10.0.1.0/24"

}

resource "google_compute_subnetwork" "public_subnet" {

  name = "public-subnet-${var.global_prefix}"
  project = "${var.gcp_project}"
  region = "${var.gcp_region}"
  network = "${google_compute_network.default.id}"
  ip_cidr_range = "10.0.2.0/24"

}

###########################################
############ Compute Firewalls ############
###########################################

resource "google_compute_firewall" "kafka_connect" {

  name = "kafka-connect-${var.global_prefix}"
  network = "${google_compute_network.default.name}"

  allow {

    protocol = "tcp"
    ports = ["22", "8083"]

  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["kafka-connect-${var.global_prefix}"]

}
