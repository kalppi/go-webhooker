terraform {
  backend "gcs" {
    bucket = "poetic-dock-495515-f9-tfstate"
    prefix = "terraform/state"
  }
}