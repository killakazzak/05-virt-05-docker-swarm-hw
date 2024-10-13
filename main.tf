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
  cloud_id                 = "b1gp6qjp3sreksmq9ju1"
  folder_id                = "b1g3hhpc4sj7fmtmdccu"
  zone                     = "ru-central1-a" # или другая зона
}

resource "yandex_compute_instance" "vm" {
  count = 3

  name = "vm-${count.index + 1}"
  zone = "ru-central1-a"

  resources {
    core_fraction = 5
    cores  = 2
    memory = 2
  }
  
  scheduling_policy {
    preemptible = true
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
    ssh-keys = "tenda:AAAAB3NzaC1yc2EAAAADAQABAAABgQCz4K1dgy26iIm/HDIcHi3th6mr0uYcRztQuAqhmpRjGEaHz1TJBXYawTFgXKv3td/Iq2BflWIVZJUadj5VTQUHb5oy0qKsGWShp7wycs+dUHroXcZmS4ysrGnXcZgrveLwU1YFgBNSxDRNm7kHBeOfoqh06a/zsUNqLPEEHsF+tfEuF4T1gOFFcDDDYsTJM/91Cw6zRWHYYeUFsPWHZIRjv1b0EM2jopUOLrI6xgCSptFkJWFsGqXogWJZgM/5zNjlerddl3YoahauaSGiB0ajCGS/3RycvVF+mxlY/jCTnvyx02UxhCYON4NpTLHAPWYjI4nsR0w/08BsS+1NU+ma1C+dmyl8qNG9sibw6wmoC5aMyXWIQa2/MrVGP/2/9gn1yERWtcWsUyfdTWKy2N6VqRGb+3Ub3fyEl0SFDcXszl5aNBN5co58S16SrsDojx5Vhdt7e88Y+AJseFNsIg/gguSabwN8a8/umRY6XsgTzqqxTfmFDe6jRXkMshEaO10= root@killakazzak.fvds.ru"
  }
}

output "instance_ips" {
  value = [for instance in yandex_compute_instance.vm : instance.network_interface[0].nat_ip_address]
}
