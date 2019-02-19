terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "google" {
  region      = "${var.provider["region"]}"
  project     = "${var.provider["project"]}"
}

resource "google_sql_database_instance" "default" {
  name                 = "${var.db_instance["name"]}"
  project              = "${var.provider["project"]}"
  region               = "${var.provider["region"]}"
  database_version     = "${lookup(var.db_instance, "database_version", "POSTGRES_9_6")}"
  master_instance_name = "${lookup(var.db_instance, "master_instance_name", "")}"

  settings {
    tier                        = "${lookup(var.db_instance_settings, "tier", "db-f1-micro")}"
    activation_policy           = "${lookup(var.db_instance_settings, "activation_policy", "ALWAYS")}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    disk_autoresize             = "${lookup(var.db_instance_settings, "disk_autoresize", true)}"
    backup_configuration        = ["${var.backup_configuration}"]
    ip_configuration            = ["${var.ip_configuration}"]
    location_preference         = ["${var.location_preference}"]
    maintenance_window          = ["${var.maintenance_window}"]
    disk_size                   = "${lookup(var.db_instance_settings, "disk_size", 10)}"
    disk_type                   = "${lookup(var.db_instance_settings, "disk_type", "PD_SSD")}"
    pricing_plan                = "${lookup(var.db_instance_settings, "pricing_plan", "PER_USE")}"
    replication_type            = "${lookup(var.db_instance_settings, "replication_type", "SYNCHRONOUS")}"
    database_flags              = ["${var.database_flags}"]
  }

  replica_configuration = ["${var.replica_configuration}"]

  lifecycle {
    ignore_changes = ["settings.0.ip_configuration"]
  }
}

resource "google_sql_database" "default" {
  count     = "${lookup(var.db_instance, "master_instance_name", "") == "" ? 1 : 0}"
  name      = "${var.default_db["name"]}"
  project   = "${var.provider["project"]}"
  instance  = "${google_sql_database_instance.default.name}"
  charset   = "${lookup(var.default_db, "charset", "")}"
  collation = "${lookup(var.default_db, "collation", "en_US.UTF8")}"
}

resource "random_id" "user-password" {
  byte_length = 8
}

resource "google_sql_user" "users" {
  count    = "${lookup(var.db_instance, "master_instance_name", "") == "" ? 1 : 0}"
  name     = "${var.db_user["name"]}"
  project  = "${var.provider["project"]}"
  instance = "${google_sql_database_instance.default.name}"
  host     = "${lookup(var.db_user, "host", "")}"
  password = "${lookup(var.db_user, "password", random_id.user-password.hex)}"

  lifecycle {
    ignore_changes = ["password"]
  }
}