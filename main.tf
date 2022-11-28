resource "aws_ecs_task_definition" "task" {
  container_definitions    = var.container_definitions_json
  cpu                      = var.cpu
  execution_role_arn       = aws_iam_role.execution.arn
  family                   = var.name
  memory                   = var.memory
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.runtime.arn
  requires_compatibilities = ["FARGATE"]

  tags = {
    Name = var.name
  }
}
