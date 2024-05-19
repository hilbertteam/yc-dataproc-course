resource "yandex_datasphere_community" "dataproc-course" {
  name = "dataproc-course"
  description = "dataproc-course community"
  billing_account_id = var.yc_billing_account_id
  organization_id = var.yc_organisation_id
}

resource "yandex_datasphere_project" "dataproc-course" {
  name = "dataproc-course"
  description = "dataproc-course Datasphere Project"

  community_id = yandex_datasphere_community.dataproc-course.id

  # limits = {
  #   max_units_per_hour = 10
  #   max_units_per_execution = 10
  #   balance = 10
  # }

  settings = {
    service_account_id = data.yandex_iam_service_account.datasphere-sa.id
    subnet_id = data.yandex_vpc_subnet.dataproc-ru-central1-a.id
    commit_mode = "AUTO"
    data_proc_cluster_id = data.yandex_dataproc_cluster.dataproc-course.id
    security_group_ids = [data.yandex_vpc_security_group.datasphere-sg.id]
    ide = "JUPYTER_LAB"
    default_folder_id = data.yandex_resourcemanager_folder.dataproc.id
    stale_exec_timeout_mode = "ONE_HOUR"
  }
}
