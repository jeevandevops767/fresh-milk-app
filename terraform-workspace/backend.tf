terraform {
    backend "gcs" {
        bucket = "jeeva-tfstate-bucket-backend"
        prefix = "bld"
    }
}