# Provider
provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
  credentials = file("credentials.json")
}

# VPC & Subnet
resource "google_compute_network" "spark_vpc" {
  name                    = "spark-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "spark_subnet" {
  name          = "spark-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "asia-southeast1"
  network       = google_compute_network.spark_vpc.id
}

# Internal communication
resource "google_compute_firewall" "allow_internal" {
  name = "allow-internal"
  network = google_compute_network.spark_vpc.name

  allow { protocol = "icmp" }

  allow {
    protocol = "tcp"
    ports = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/16"]
}

# SSH access
resource "google_compute_firewall" "allow_ssh" {
  name = "allow-ssh"
  network = google_compute_network.spark_vpc.name

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Spark Web UI (8080 – master, 4040 – job UI)
resource "google_compute_firewall" "allow_spark_ui" {
  name = "allow-spark-ui"
  network = google_compute_network.spark_vpc.name

  allow {
    protocol = "tcp"
    ports = ["8080", "4040"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Master Node
resource "google_compute_instance" "spark_master" {
  name = "spark-master"
  machine_type = "e2-medium"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.spark_subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

# Worker Node 1
resource "google_compute_instance" "spark_worker_1" {
  name = "spark-worker-1"
  machine_type = "e2-medium"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.spark_subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

# Worker Node 2
resource "google_compute_instance" "spark_worker_2" {
  name = "spark-worker-2"
  machine_type = "e2-medium"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.spark_subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

# Edge Node
resource "google_compute_instance" "spark_edge" {
  name = "spark-edge"
  machine_type = "e2-small"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.spark_subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

# Outputs
output "master_ip" {
  value = google_compute_instance.spark_master.network_interface.0.access_config.0.nat_ip
}

output "worker_ip" {
  value = google_compute_instance.spark_worker_1.network_interface.0.access_config.0.nat_ip
}

output "worker_2_ip" {
  value = google_compute_instance.spark_worker_2.network_interface.0.access_config.0.nat_ip
}

output "edge_ip" {
  value = google_compute_instance.spark_edge.network_interface.0.access_config.0.nat_ip
}

