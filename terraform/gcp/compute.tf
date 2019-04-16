###########################################
########### Kafka Connect LBR #############
###########################################

resource "google_compute_global_address" "kafka_connect" {

    name = "kafka-connect-global-address-${var.global_prefix}"

}

resource "google_compute_global_forwarding_rule" "kafka_connect" {

    name = "kafka-connect-global-forwarding-rule-${var.global_prefix}"
    target = "${google_compute_target_http_proxy.kafka_connect.self_link}"
    ip_address = "${google_compute_global_address.kafka_connect.self_link}"
    port_range = "80"

}

resource "google_compute_target_http_proxy" "kafka_connect" {

    name = "kafka-connect-http-proxy-${var.global_prefix}"
    url_map = "${google_compute_url_map.kafka_connect.self_link}"

}

resource "google_compute_url_map" "kafka_connect" {

    name = "kafka-connect-url-map-${var.global_prefix}"
    default_service = "${google_compute_backend_service.kafka_connect.self_link}"

}

resource "google_compute_backend_service" "kafka_connect" {

    name = "kafka-connect-backend-service-${var.global_prefix}"
    port_name = "http"
    protocol = "HTTP"
    timeout_sec = 5

    backend = {

        group = "${google_compute_instance_group_manager.kafka_connect.instance_group}"

    }

    health_checks = ["${google_compute_http_health_check.kafka_connect.self_link}"]

}

resource "google_compute_instance_group_manager" "kafka_connect" {

    name = "kafka-connect-instance-group-${var.global_prefix}"
    base_instance_name = "connect"
    instance_template = "${google_compute_instance_template.kafka_connect.self_link}"
    update_strategy = "NONE"
    zone = "${var.gcp_availability_zones[0]}"
   
    target_size = 1

    named_port = {

        name = "http"
        port = 8083

    }

}

resource "google_compute_http_health_check" "kafka_connect" {

    name = "kafka-connect-http-health-check-${var.global_prefix}"
    request_path = "/"
    port = "8083"
    healthy_threshold = 3
    unhealthy_threshold = 3
    check_interval_sec = 5
    timeout_sec = 3

}

resource "google_compute_instance_template" "kafka_connect" {

    name = "kafka-connect-template-${var.global_prefix}"
    machine_type = "n1-standard-2"

    metadata_startup_script = "${data.template_file.kafka_connect_bootstrap.rendered}"

    disk {

        source_image = "centos-7"
        disk_size_gb = 100

    }    

    network_interface {

        subnetwork = "${google_compute_subnetwork.private_subnet.self_link}"

        access_config {}

    }

    tags = ["kafka-connect-${var.global_prefix}"]

}
