# GCP Project
variable "project_id" {
  description = "The GCP Project ID"
  type = string
}

# Region & Zone
variable "region" {
  description = "GCP Region"
  type = string
  default = "asia-southeast1"
}

variable "zone" {
  description = "GCP Zone"
  type = string
  default = "asia-southeast1-c"
}

# SSH Configuration
variable "ssh_user" {
  description = "User to create on the VM"
  type = string
  default = "ubuntu"
}

variable "ssh_pub_key_path" {
  description = "Path to the public SSH key"
  type = string
  default = "../keys/spark_key.pub"
}

