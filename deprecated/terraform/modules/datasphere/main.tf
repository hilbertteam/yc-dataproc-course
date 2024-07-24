resource "yandex_datasphere_community" "community" {
  count = var.datasphere_community_name != null ? 1 : 0
  name = var.datasphere_community_name
  billing_account_id = var.yc_billing_account_id
  organization_id = var.yc_organisation_id
}

resource "yandex_datasphere_project" "project" {
  name = var.datasphere_project_name
  description = var.datasphere_project_descr

  community_id = var.datasphere_community_id != null ? var.datasphere_community_id : yandex_datasphere_community.community[0].id

  limits = {
    max_units_per_hour = 99999999
    max_units_per_execution = 99999999
    balance = 99999999
  }

  settings = {
    service_account_id = var.service_account_id
    subnet_id = var.vpc_subnet_id
    commit_mode = "AUTO"
    # commit_mode = "COMMIT_MODE_UNSPECIFIED"
    data_proc_cluster_id = var.dataproc_cluster_id
    security_group_ids = var.security_group_ids
    ide = "JUPYTER_LAB"
    default_folder_id = var.default_folder_id
    stale_exec_timeout_mode = var.stale_exec_timeout_mode
  }
}
