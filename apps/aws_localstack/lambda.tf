resource "aws_lambda_function" "meal-notifier" {
  filename      = "/home/mvaldes/git/meal-notifier/meal_notifier.zip"
  function_name = "meal-notifier"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "go1.x"
  handler       = "meal_notifier"
}
