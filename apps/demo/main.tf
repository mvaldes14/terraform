terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

provider "local" {}

resource "local_file" "foo" {
  content  = "foo!"
  filename = "foo.bar.baz"
}

resource "local_file" "bar" {
  content  = "bar!"
  filename = "bar.baz.qux"
}
