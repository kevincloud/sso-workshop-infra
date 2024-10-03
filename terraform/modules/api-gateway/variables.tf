variable "application_name" {
  description = "The name of the application to which the API belongs."
  type        = string
}

variable "environment_name" {
  description = "The name of the environment to which the API belongs."
  type        = string
}

variable "maintainer_email" {
  description = "The email address of the maintainer for the API."
  type        = string
}

variable "api_name" {
  description = "The short name for the API."
  type        = string
}

variable "api_route_mappings" {
  description = "The mapping of route keys to lambda function invoke ARNs."
  type        = map(string)
}