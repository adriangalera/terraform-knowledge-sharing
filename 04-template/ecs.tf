provider "aws" {
  profile = "gal"
  region = "eu-west-1"
}

variable "app-prefix" {
  type = string
  default = "comms-ks-04"
}

resource "aws_ecs_cluster" "test-cluster" {
  name = "${var.app-prefix}_test_cluster"
}

# Prepare a cloudwatch log group for backend
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.app-prefix}_backend_container"
  retention_in_days = 14
}

# Prepare a cloudwatch log group for frontend
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.app-prefix}_frontend_container"
  retention_in_days = 14
}

resource "aws_iam_role" "ecs_container_iam_role" {
  name = "${var.app-prefix}_ecs_execution_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "",
    "Effect": "Allow",
    "Principal": {
      "Service": "ecs-tasks.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
POLICY
}

resource "aws_iam_role_policy" "ecs_container_iam_role_policy" {
  name = "${var.app-prefix}_ecs_execution_role_policy"
  role = "${aws_iam_role.ecs_container_iam_role.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

data "template_file" "container_backend" {
  template = "${file("container_definition.tpl")}"
  vars = {
    container_name = "${var.app-prefix}_backend_container"
    log_group = "${var.app-prefix}_backend_container"
    service_type = "backend"
  }
}

data "template_file" "container_frontend" {
  template = "${file("container_definition.tpl")}"
  vars = {
    container_name = "${var.app-prefix}_frontend_container"
    log_group = "${var.app-prefix}_frontend_container"
    service_type = "frontend"
  }
}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family = "${var.app-prefix}_backend_task_definition"
  requires_compatibilities = [ "FARGATE" ]
  network_mode =  "awsvpc"
  execution_role_arn = "${aws_iam_role.ecs_container_iam_role.arn}"
  cpu = 256
  memory = 512
  container_definitions = "${data.template_file.container_backend.rendered}"
}

resource "aws_ecs_task_definition" "frontend_task_definition" {
  family = "${var.app-prefix}_frontend_task_definition"
  requires_compatibilities = [ "FARGATE" ]
  network_mode =  "awsvpc"
  execution_role_arn = "${aws_iam_role.ecs_container_iam_role.arn}"
  cpu = 256
  memory = 512
  container_definitions = "${data.template_file.container_frontend.rendered}"
}

resource "aws_vpc" "main" {
  cidr_block = "172.17.0.0/16"
}

resource "aws_subnet" "public" {
  cidr_block              = "${aws_vpc.main.cidr_block}"
  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

output "frontend-task-definition" {
    value = "${aws_ecs_task_definition.frontend_task_definition.id}"
}

output "backend-task-definition" {
    value = "${aws_ecs_task_definition.backend_task_definition.id}"
}

output "cluster-id" {
    value = "${aws_ecs_cluster.test-cluster.id}"
}

output "subnet-id" {
    value = "${aws_subnet.public.id}"
}

output "frontend-log-group" {
  value = "${aws_cloudwatch_log_group.frontend.id}"
}

output "backend-log-group" {
  value = "${aws_cloudwatch_log_group.backend.id}"
}