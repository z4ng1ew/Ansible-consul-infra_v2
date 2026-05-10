datacenter = "dc1"
node_name  = "consul-client"
server     = false

bind_addr      = "0.0.0.0"
advertise_addr = "192.168.56.21"
client_addr    = "0.0.0.0"

data_dir = "/opt/consul/data"

retry_join = ["192.168.56.20"]

log_level = "INFO"
