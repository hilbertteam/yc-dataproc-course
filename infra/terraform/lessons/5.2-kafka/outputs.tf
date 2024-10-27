output "topics" {
  value       = module.kafka.topics
}

output "kafka_cluster_host_names_list" {
  value = module.kafka.cluster_host_names_list
}

output "users_data" {
  value = module.kafka.users_data
  sensitive = true
}