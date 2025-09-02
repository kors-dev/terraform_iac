terraform {
  backend "gcs" {
    bucket = "ak-gke-lab-bucket"
    prefix = "terraform/state"
  }
}

module "gke_cluster" {
  source         = "github.com/kors-dev/tf-google-gke-cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = var.GKE_NUM_NODES

}

