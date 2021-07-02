variable "key_name" {
  type    = string
}

variable "prefix" {
  type = string
}

variable "resources" {
    type = map(object({
        name          = string
        version       = number
        instance_type = string
        is_public     = bool
      }))
}
