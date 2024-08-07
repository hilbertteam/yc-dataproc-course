resource "yandex_lockbox_secret" "secret" {
  name                = var.name
  folder_id           = var.folder_id
  description         = var.description
  labels              = var.labels
  kms_key_id          = var.kms_key_id
  deletion_protection = var.deletion_protection
}

resource "yandex_lockbox_secret_version" "secret_version" {
  secret_id = yandex_lockbox_secret.secret.id

  dynamic "entries" {
    for_each = var.secret_version_text_entries
    content {
      key        = entries.value["key"]
      text_value = entries.value["text_value"]
    }
  }

  dynamic "entries" {
    for_each = var.secret_version_command_entries
    content {
      key = entries.value["key"]
      command {
        path = entries.value["command_path"]
        args = entries.value["command_args"]
        env = entries.value["command_env"]
      }
    }
  }

  # entries {
  #   key = "k2"
  #   // value generated by a command won't be visible in Terraform state
  #   command {
  #     path = "my_secret_generator.sh"
  #   }
  # }
}
