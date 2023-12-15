locals {
  repositories = {
    "meal-notifier" = {
      username     = "mvaldes"
      name         = "meal-notifier"
      private       = false
      git_template = "Go"
      license      = "MIT"
    }

    "api-go-templ" = {
      username     = "mvaldes"
      name         = "api-go-templ"
      private       = false 
      git_template = "Go"
      license      = "MIT"
    }

    "k8s-apps" = {
      username     = "mvaldes"
      name         = "k8s-apps"
      private       = false
      git_template = "default"
      license      = "MIT"
    }
    
  }
}
