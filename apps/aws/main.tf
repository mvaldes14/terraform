resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "meal-notifier" {
  filename      = "~/git/meal-notifier/lambda/meal-notifier.zip"
  function_name = "meal-notifier"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "go1.x"
  environment {
    variables = {
      BASE_URL = var.base_url
      TELEMGRAM_CHAT = var.telegram_chat_id
      TELEGRAM_TOKEN = var.telegram_token
    }
  }
}


resource "aws_cloudwatch_event_rule" "meal-notifier-timer" {
  name                = "everyday_at_7"
  description         = "Runs at 7am every weekday"
  schedule_expression = "cron(0 7 * * 1-5)"
}

resource "aws_cloudwatch_event_rule_target" "meal-notifier-lambda-rule" {
  rule      = aws_cloudwatch_event_rule.meal-notifier-timer.name
  target_id = "meal-notifier-lambda-rule"
  arn       = aws_lambda_function.meal-notifier.arn
}
