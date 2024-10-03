variable "application_name" {
  description = "The name of the application to which the table belongs."
  type        = string
}

variable "environment_name" {
  description = "The name of the environment to which the table belongs."
  type        = string
}

variable "maintainer_email" {
  description = "The email address of the maintainer for the table."
  type        = string
}

variable "table_name" {
  description = "The short name for the table."
  type        = string
}

variable "attributes" {
  description = "The attribute names and types map for the table."
  type        = map(string)
}

variable "hash_key" {
  description = "The attribute to use as the hash key for the table."
  type        = string
}