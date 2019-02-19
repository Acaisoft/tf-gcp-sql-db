terragrunt = {
  terraform {
    source = "../"
    # Configure source as repository link
    # source = "git::git@github.com:Acaisoft/tf-gcp-sql-db.git?ref=v0.1.0"
  }
  
  remote_state {
    backend = "gcs"
    config {
      # Bucket must exists
      bucket  = "bucket-name"
      prefix  = "dev/sql-db/state"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
provider = {
  # GCS project name
  project          = "project-name"
  region           = "europe-west1"
}

db_instance = {
  name = "default"
}

default_db = {
  name = "default"
}

db_user = {
  name = "default"
}