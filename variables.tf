
# Parameters authorized:
# project (mandatory)
# region (mandatory)
variable "provider" {
  type        = "map"
  description = "Google provider parameters"
}

# Parameters authorized:
# name - name for the database instance (mandatory)
# database_version (default: POSTGRES_9_6)
# master_instance_name - the name of the master instance to replicate (default: "")
variable "db_instance" {
  type        = "map"
  description = "Database instance main parametes."
}

# Parameters authorized:
# tier - the machine tier (default: "db-f1-micro")
# activation_policy - when the instance should be active (default: "ALWAYS")
# disk_autoresize - second generation only, configuration to increase storage size automatically (default: true)
# disk_size - the size of data disk, in GB (default: 10)
# disk_type - the type of data disk (default: "PD_SSD")
# pricing_plan - pricing plan for this instance (default: "PER_USE")
# replication_type - replication type for this instance (default: "SYNCHRONOUS")
 variable "db_instance_settings" {
  type        = "map"
  description = "Database instance settings."
  default     = {}
}

# Parameters authorized:
# name - name of the default database to create (mandatory)
# charset - the charset for the default database (default: "")
# collation - the collation for the default database (default: "en_US.UTF8")
variable "default_db" {
  type        = "map"
  description = "Default database settings."
}

# Parameters authorized:
# name - the name of the default user (mandatory)
# host - the host for the default user (default: "%")
# password - the password for the default user, if not set, a random one will be generated
variable "db_user" {
  type        = "map"
  description = "Databes default user settings."
}

variable replica_configuration {
  description = "The optional replica_configuration block for the database instance"
  type        = "list"
  default     = []
}

variable authorized_gae_applications {
  description = "A list of Google App Engine (GAE) project names that are allowed to access this instance."
  type        = "list"
  default     = []
}

variable backup_configuration {
  description = "The backup_configuration settings subblock for the database setings"
  type        = "map"
  default     = {}
}

variable ip_configuration {
  description = "The ip_configuration settings subblock"
  type        = "list"
  default     = [{}]
}

variable location_preference {
  description = "The location_preference settings subblock"
  type        = "list"
  default     = []
}

variable maintenance_window {
  description = "The maintenance_window settings subblock"
  type        = "list"
  default     = []
}

variable database_flags {
  description = "List of Cloud SQL flags that are applied to the database server"
  default     = []
}