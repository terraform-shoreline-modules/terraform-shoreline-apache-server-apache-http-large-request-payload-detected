resource "shoreline_notebook" "large_request_payloads_in_apache_http" {
  name       = "large_request_payloads_in_apache_http"
  data       = file("${path.module}/data/large_request_payloads_in_apache_http.json")
  depends_on = [shoreline_action.invoke_set_max_payload_size]
}

resource "shoreline_file" "set_max_payload_size" {
  name             = "set_max_payload_size"
  input_file       = "${path.module}/data/set_max_payload_size.sh"
  md5              = filemd5("${path.module}/data/set_max_payload_size.sh")
  description      = "Increase the maximum allowed size for request payloads in the Apache settings."
  destination_path = "/agent/scripts/set_max_payload_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_set_max_payload_size" {
  name        = "invoke_set_max_payload_size"
  description = "Increase the maximum allowed size for request payloads in the Apache settings."
  command     = "`chmod +x /agent/scripts/set_max_payload_size.sh && /agent/scripts/set_max_payload_size.sh`"
  params      = ["APACHE_CONFIG_FILE_PATH","MAXIMUM_PAYLOAD_SIZE"]
  file_deps   = ["set_max_payload_size"]
  enabled     = true
  depends_on  = [shoreline_file.set_max_payload_size]
}

