terraform {
  backend "gcs" {
      bucket = "terraformbackendgp"
      prefix = "backend"
  }
}
