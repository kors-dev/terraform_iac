variable "GOOGLE_PROJECT" {
  type        = string
  description = "gcp project name"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = "us-central1-c"
  description = "gcp region for GKE"
}

variable "GKE_NUM_NODES" {
  type        = number
  description = "default number of gke nodes"
}

variable "DELETION_PROTECTION" {
  type        = bool
  description = "Prevent Terraform from destroying the cluster"
  default     = false
}