variable "parameters" {
  description = "The parameters to create."
  type = map(object({
    Type  = string
    Value = string
  }))
}

variable "application_name" {
  description = "The name of the application to which the parameters belong."
  type        = string
}

variable "environment_name" {
  description = "The name of the environment to which the parameters belong."
  type        = string
}

variable "maintainer_email" {
  description = "The email address of the maintainer for the parameters."
  type        = string
}

variable "parameter_group_name" {
  description = "The name to use for the parameter group on resources."
  type        = string
}