datacenter = "dc1"
node_name  = "consul-server"
server     = true

bootstrap_expect = 1

bind_addr      = "0.0.0.0"
advertise_addr = "192.168.56.20"
client_addr    = "0.0.0.0"

ui_config {
  enabled = true
}

data_dir = "/opt/consul/data"

log_level = "INFO"
