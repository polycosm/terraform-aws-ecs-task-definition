# terraform-aws-ecs-task-definition

Terraform module to create an ECS task definition.

Creates:

 - A task definition (from inputted JSON)
 - An IAM role used by ECS to execute the task.
 - An IAM role used by the task at runtime.
