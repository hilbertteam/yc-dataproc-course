output "sa_id" {
  value = yandex_iam_service_account.sa.id
}

output "sa_name" {
  value = yandex_iam_service_account.sa.name
}

output "sa_static_access_keys" {
  value = { 
    for key, value in yandex_iam_service_account_static_access_key.sa-static-keys : key => { access_key = value.access_key, secret_key = value.secret_key }
  }
}