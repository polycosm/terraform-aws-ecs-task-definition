output "arn" {
  value = aws_ecs_task_definition.task.arn
}

output "id" {
  value = aws_ecs_task_definition.task.id
}

output "execution_role" {
  value = aws_iam_role.execution
}

output "runtime_role" {
  value = aws_iam_role.runtime
}
