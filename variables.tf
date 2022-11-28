variable "container_definitions_json" {
  description = "The container defintions to use for the task, as JSON"
  type        = string
}

variable "cpu" {
  description = "The number of CPU units required by the task"
  type        = number
}

variable "memory" {
  description = "The amount of memory required by the task"
  type        = number
}

variable "name" {
  description = "The name of the ECS service."
  type        = string
}

variable "policy_json" {
  description = "IAM policy JSON for the ECS runtime, if any."
  type        = string
  default     = null
}

variable "secrets" {
  description = "The secrets that should be passed to the task at runtime, if any."
  type = list(object({
    arn = string
  }))
  default = []
}
