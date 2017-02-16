module "ami-builder" {
  source      = "../../modules/ami-builder"
  region      = "${var.region}"
  environment = "${var.environment}"
}

module "security-logs" {
  source      = "../../modules/security"
  name        = "secruity-logs"
  region      = "${var.region}"
  environment = "${var.environment}"
  accountId   = "${var.accountId}"
}

module "vpc" {
  cidr_range      = "${var.cidr_range}"
  source          = "../../modules/network"
  environment     = "${var.environment}"
  region          = "${var.region}"
  key_pair        = "${var.key_pair}"
  bastion_zone_id = "${var.bastion_zone_id}"
  bastion_dns     = "${var.bastion_dns}"
}

module "application-logs" {
  bastion_ip  = "${module.vpc.bastion_ip}"
  source      = "../../modules/logging"
  environment = "${var.environment}"
  region      = "${var.region}"
  accountId   = "${var.accountId}"
}

module "artifacts" {
  source      = "../../modules/artifact-store"
  environment = "${var.environment}"
  region      = "${var.region}"
}

module "app-secrets" {
  source      = "../../modules/secret-store"
  environment = "${var.environment}"
  region      = "${var.region}"
}

module "api" {
  source           = "../../modules/web-service"
  name             = "nginx"
  service          = "api"
  environment      = "${var.environment}"
  region           = "${var.region}"
  domain           = "${var.root_domain}"
  key_pair         = "${var.key_pair}"
  min_size         = 1
  max_size         = 1
  vpc_range        = "${module.vpc.block}"
  vpc_id           = "${module.vpc.id}"
  bastion_sg       = "${module.vpc.bastion_sg}"
  logging_policy   = "${module.application-logs.WO_policies[0]}"
  credstash_policy = "${module.app-secrets.RO_policies[0]}"
  public_subnets   = "${module.vpc.public_subnets}"
  private_subnets  = "${module.vpc.private_subnets}"
  accountId        = "${var.accountId}"
}
