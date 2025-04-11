module "toolbox-sg" {
  source    = "../../modules/security-group"
  name      = "toolbox-sg"
  vpc_id    = module.vpc.vpc_id
  folder_id = var.yc_folder_id

  ingress_rules = {
    allow_ssh = {
      protocol       = "TCP"
      port           = 22
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
    allow_vscode = {
      protocol       = "TCP"
      port           = 8080
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}