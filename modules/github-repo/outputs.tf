output "repository_id" {
  description = "The ID of the repository"
  value       = github_repository.repo.id
}

output "repository_node_id" {
  description = "The Node ID of the repository"
  value       = github_repository.repo.node_id
}

output "repository_name" {
  description = "The name of the repository"
  value       = github_repository.repo.name
}

output "repository_full_name" {
  description = "The full name of the repository (owner/repo)"
  value       = github_repository.repo.full_name
}

output "repository_html_url" {
  description = "The HTML URL of the repository"
  value       = github_repository.repo.html_url
}

output "repository_ssh_clone_url" {
  description = "The SSH clone URL of the repository"
  value       = github_repository.repo.ssh_clone_url
}

output "repository_http_clone_url" {
  description = "The HTTP clone URL of the repository"
  value       = github_repository.repo.http_clone_url
}

output "repository_git_clone_url" {
  description = "The Git clone URL of the repository"
  value       = github_repository.repo.git_clone_url
}

output "repository_visibility" {
  description = "The visibility of the repository"
  value       = github_repository.repo.visibility
}

output "repository_topics" {
  description = "The topics of the repository"
  value       = github_repository.repo.topics
}
