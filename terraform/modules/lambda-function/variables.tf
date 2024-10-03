variable "application_name" {
  description = "The name of the application to which the lambda function belongs."
  type        = string
}

variable "environment_name" {
  description = "The name of the environment to which the lambda function belongs."
  type        = string
}

variable "maintainer_email" {
  description = "The email address of the maintainer for the lambda function."
  type        = string
}

variable "function_source" {
  description = "The source zip file for the source code for the lambda function."
  type        = string
}

variable "function_name" {
  description = "The short name for the lambda function."
  type        = string
}

variable "function_handler" {
  description = "The handler for the lambda function."
  type        = string
}

variable "function_runtime" {
  description = "The runtime for the lambda function."
  type        = string
}

variable "function_memory" {
  description = "The memory allocation (in MB) for the lambda function."
  type        = string
  default     = 128
}

variable "environment_variables" {
  description = "The environment variables for the lambda function."
  type        = map(string)
  default     = {}
}

variable "policy_attachments" {
  description = "The name to ARNs of policies to attach to the function's execution role."
  type        = map(string)
}