###########################################
################# Outputs #################
###########################################

output "Kafka Connect" {

  value = "${join(",", formatlist("http://%s", google_compute_global_address.kafka_connect.*.address))}"

}
