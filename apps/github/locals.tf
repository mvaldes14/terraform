locals {
  repositories = {
    "meal-notifier" = {
      name         = "meal-notifier"
      private      = false
      license      = "MIT"
      topics       = ["automation"]
      visibility   = "public"
    }

    "api-go-templ" = {
      name         = "api-go-templ"
      private       = false 
      license      = "MIT"
      topics       = ["homelab"]
      visibility   = "public"
    }

    "k8s-apps" = {
      name         = "k8s-apps"
      private      = false
      license      = "MIT"
      topics        = ["homelab"]
      visibility   = "public"
    }

    "ansible_playbooks" = {
      name         = "ansible_playbooks"
      private      = false
      license      = "MIT"
      topics       = ["automation"]
      visibility   = "public"
    }

    "dotfiles" = {
      name         = "dotfiles"
      private      = false
      license      = "MIT"
      topics       = ["homelab"]
      visibility   = "public"
    }

    "chef" = {
      name         = "chef"
      private      = false
      license      = "MIT"
      topics       = ["automation"]
      visibility   = "public"
    }

    "pulumi" = {
      name         = "pulumi"
      private      = false
      license      = "MIT"
      topics       = ["automation"]
      visibility   = "public"
    }

    "obs-wiki" = {
      name         = "obs-wiki"
      private      = false
      license      = "MIT"
      topics       = ["homelab"]
      visibility   = "private"
    }
  }
}
