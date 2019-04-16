data "template_file" "connectorJson" {

  template = "${file("../tpl/connector.json")}"

  vars {

    endpoint = "${var.google_function_endpoint}"

  }

}

data "template_file" "connectorScript" {

  template = "${file("../tpl/connector.sh")}"

  vars {

    kafkaConnectUrl = "${join(",", formatlist("http://%s", google_compute_global_address.kafka_connect.*.address))}"

  }

}

resource "local_file" "connectorJson" {

  content  = "${data.template_file.connectorJson.rendered}"
  filename = "connector.json"

}

resource "local_file" "connectorScript" {

  content  = "${data.template_file.connectorScript.rendered}"
  filename = "connector.sh"

}

resource "null_resource" "connectorScript" {

    depends_on = ["local_file.connectorScript"]
    provisioner "local-exec" {

        command = "chmod 775 connector.sh"
        interpreter = ["bash", "-c"]
        on_failure = "continue"

    }

}