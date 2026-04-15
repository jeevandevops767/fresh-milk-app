# Configure the Google Cloud provider
provider "google" {
    project = "web-application-deploy-489908"
    region = "us-central1"

}
# Configure the Terraform backend to use Google Cloud Storage


# Create a Google Cloud Storage bucket
resource "google_storage_bucket" "demo_bucket" {
    name = "jeeva-demo-bucket-12345"
    location = "US"
}

