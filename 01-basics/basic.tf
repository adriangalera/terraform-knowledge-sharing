provider "aws" {
  profile = "gal"
  region = "eu-west-1"
}

variable "app-prefix" {
  type = string
  default = "comms-ks-01"
}

resource "aws_dynamodb_table" "configuration" {
  name           = "${var.app-prefix}_timeserie_configuration"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "timeserie1"

  attribute {
    name = "timeserie1"
    type = "S"
  }

}

resource "aws_s3_bucket" "s3-bucket-rnd-name" {
    bucket = "${var.app-prefix}-timeserie-configuration"
} 

output "bucket-arn" {
  value = "${aws_s3_bucket.s3-bucket-rnd-name.arn}"
}
output "table-arn" {
  value = "${aws_dynamodb_table.configuration.arn}"
}