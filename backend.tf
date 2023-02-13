terraform {
  backend "gcs" {
      bucket = "terraformbackendgp"
      prefix = "backend"
     credentials = "sa.json"
  }
}
