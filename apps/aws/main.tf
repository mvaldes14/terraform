resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

  

resource "aws_lambda_function" "meal-notifier" {
  filename      = "meal_notifier.zip"
  function_name = "meal-notifier"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "go1.x"
}
