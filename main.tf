terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.130"
}

provider "yandex" {
  service_account_key_file = "/root/yandex-cloud/key.json"
  cloud_id           = "b1gp6qjp3sreksmq9ju1"
  folder_id          = "b1g3hhpc4sj7fmtmdccu"
  zone               = "ru-central1-a" # или другая зона
}

resource "yandex_compute_instance" "vm" {
  count = 3

  name = "vm-${count.index + 1}"
  zone = "ru-central1-a"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tvc3529h2cpjvpkr5" # ID образа, например, Ubuntu
    }
  }

  network_interface {
    subnet_id = "e9bang8tpj4mbo92gvr6"
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

output "instance_ips" {
  value = [for instance in yandex_compute_instance.vm : instance.network_interface[0].nat_ip_address]
}
