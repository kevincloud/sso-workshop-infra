locals {
  parameters = { for name, parameter in var.parameters : name => {
    name : "/${var.application_name}/${var.environment_name}/${name}"
    type : parameter.Type
    value : parameter.Value
  } }
}