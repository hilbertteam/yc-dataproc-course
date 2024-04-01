data "yandex_iam_service_account" "datasphere-sa" {
  name = "datasphere-sa"
}

data "yandex_vpc_subnet" "dataproc-ru-central1-a" {
  name = "dataproc-ru-central1-a"
}

data "yandex_dataproc_cluster" "dataproc-course" {
  name = "dataproc-course"
}

data "yandex_vpc_security_group" "datasphere-sg" {
  name = "datasphere-sg"
}

data "yandex_resourcemanager_folder" "dataproc" {
  name     = "dataproc"
}

# data "yandex_datasphere_community" "dataproc-course" {
#   id = "bt1g53ngordkcgksu4ut"
# }