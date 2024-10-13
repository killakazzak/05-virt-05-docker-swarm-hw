provider "yandex" {
  service_account_key_file = "path/to/your/service-account-key.json"
  cloud_id                 = "your-cloud-id"
  folder_id                = "your-folder-id"
  zone                     = "ru-central1-a" # или другая зона
}

resource "yandex_compute_instance" "vm" {
  count        = 3
  name         = "docker-vm-${count.index + 1}"
  zone         = "ru-central1-a"
  platform_id  = "standard-v1"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8g0g0g0g0g0g0g0g0g" # ID образа, например, Ubuntu
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.main.id
    nat       = true
  }
  metadata = {
    user_data = <<-EOF
                #!/bin/bash
                apt-get update
                apt-get install -y docker.io
                systemctl start docker
                systemctl enable docker
                EOF
  }
}

resource "yandex_vpc_network" "main" {
  name = "my-network"
}

resource "yandex_vpc_subnet" "main" {
  name           = "my-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}

