data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "meal_notifier_lambda" {
  type = "zip"
  source_file = "/home/mvaldes/git/meal-notifier/main.go"
  output_path = "/home/mvaldes/git/meal-notifier/meal_notifier.zip"
}
