/* The task uses this role at runtime to enable AWS service usage (if any)
 */
resource "aws_iam_role" "runtime" {
  name               = "${var.name}-ecs-runtime"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecs.json
}

/* ECS uses this role to execute the task.
 */
resource "aws_iam_role" "execution" {
  name               = "${var.name}-ecs-execution"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecs.json
}

/* The task uses a customer policy for its runtime permissions.
 */
resource "aws_iam_role_policy" "runtime" {
  role   = aws_iam_role.runtime.id
  name   = "${var.name}-ecs-runtime"
  policy = var.policy_json != null ? var.policy_json : data.aws_iam_policy_document.noop.json
}

/* ECS can use a pre-existing policy for its execution role.
 */
resource "aws_iam_role_policy_attachment" "execution_ecs" {
  role       = aws_iam_role.execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

/* ECS may need to read secrets so it can pass them along to the task.
 */
resource "aws_iam_role_policy" "execution_secrets" {
  role   = aws_iam_role.execution.id
  name   = "${var.name}-ecs-execution-secrets"
  policy = length(var.secrets) > 0 ? data.aws_iam_policy_document.secrets.json : data.aws_iam_policy_document.noop.json
}

/* ECS supports reading secrets from both secrets manager and parameter store.
 */
data "aws_iam_policy_document" "secrets" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters",
    ]

    # NB: this policy will be invalid if the secrets input is empty
    resources = [
      for secret in var.secrets :
      secret.arn
    ]
  }
}

/* It's easier to always create a task role and policy (than to conditionally supply nulls),
 * so we define a noop policy document in case the task doesn't need any permissions.
 */
data "aws_iam_policy_document" "noop" {
  statement {
    sid    = "Placeholder"
    effect = "Allow"

    actions = [
      // NB: policy documents cannot actually be empty, but we this permission is safe
      "sts:GetCallerIdentity"
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "assume_role_ecs" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}
