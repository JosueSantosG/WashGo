terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type        = string
  description = "The GCP Project ID for WashGo"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The target GCP region"
}

variable "billing_account_id" {
  type        = string
  description = "The GCP Billing Account ID"
}

variable "monthly_budget_amount" {
  type        = number
  default     = 100
  description = "Monthly budget amount in USD"
}

# SECTION 6: MONITOREO Y ALERTAS (GCP Billing Budget & Alerts)
resource "google_billing_budget" "washgo_budget" {
  billing_account = var.billing_account_id
  display_name    = "WashGo Production Monthly Budget"

  budget_filter {
    projects = ["projects/${var.project_id}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = tostring(var.monthly_budget_amount)
    }
  }

  # Cost Alerts at 50%, 80%, and 100% of the budget
  threshold_rules {
    threshold_percent = 0.5
    spend_basis       = "CURRENT_SPEND"
  }

  threshold_rules {
    threshold_percent = 0.8
    spend_basis       = "CURRENT_SPEND"
  }

  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "CURRENT_SPEND"
  }

  threshold_rules {
    threshold_percent = 1.2
    spend_basis       = "CURRENT_SPEND"
  }

  all_updates_rule {
    disable_default_iam_recipients = false
  }
}

# SECTION 7: RESPALDOS DE BASE DE DATOS (Cloud SQL Backups)
resource "google_sql_database_instance" "washgo_postgres" {
  name             = "washgo-fdc"
  database_version = "POSTGRES_15"
  region           = var.region
  deletion_protection = true

  settings {
    tier = "db-f1-micro" # Default cost-effective tier, scalable for prod

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00" # 3 AM UTC (Low-traffic period in Ecuador)
      point_in_time_recovery_enabled = true    # Point-in-Time Recovery (PITR) for transaction-level rollbacks
      transaction_log_retention_days = 7
      
      backup_retention_settings {
        retention_unit   = "COUNT"
        retained_backups = 30 # Retain last 30 daily backups
      }
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = null # Set to VPC path if using private IP
    }
  }
}
