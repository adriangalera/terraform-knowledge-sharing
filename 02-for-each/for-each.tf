provider "aws" {
  profile = "gal"
  region = "eu-west-1"
}

variable "app-prefix" {
  type = string
  default = "comms-ks-02"
}

# Create multiple tables with only one resources
resource "aws_dynamodb_table" "configuration" {

  for_each = {
    test1: "${var.app-prefix}_configuration_test_1",
    test2: "${var.app-prefix}_configuration_test_2",
    test3: "${var.app-prefix}_configuration_test_3",
  }

  name           = each.value
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "timeserie"

  attribute {
    name = "timeserie"
    type = "S"
  }
}

output "table-arn" {
  value = "${values(aws_dynamodb_table.configuration)[*].arn}"
}