provider "yandex" {
  cloud_id  = "${YC_CLOUD_ID}"
  folder_id = "${YC_FOLDER_ID}"
  zone      = "ru-central1-a"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}