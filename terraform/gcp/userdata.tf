###########################################
######## Kafka Connect Bootstrap ##########
###########################################

data "template_file" "kafka_connect_properties" {

  template = "${file("../util/kafka-connect.properties")}"

  vars {

    global_prefix = "${var.global_prefix}"
    broker_list = "${var.ccloud_broker_list}"
    access_key = "${var.ccloud_access_key}"
    secret_key = "${var.ccloud_secret_key}"
    confluent_home_value = "${var.confluent_home_value}"

    schema_registry_url = "${var.ccloud_schema_registry_url}"
    schema_registry_basic_auth = "${var.ccloud_schema_registry_basic_auth}"

  }

}

data "template_file" "kafka_connect_bootstrap" {

  template = "${file("../util/kafka-connect.sh")}"

  vars {

    confluent_platform_location = "${var.confluent_platform_location}"
    kafka_connect_properties = "${data.template_file.kafka_connect_properties.rendered}"
    confluent_home_value = "${var.confluent_home_value}"

  }

}
