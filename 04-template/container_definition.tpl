[
  {
    "name": "${container_name}",
    "image": "alpine", 
    "command": [
        "echo $SERVICE_TYPE"
    ],
    "entryPoint": [
        "sh",
        "-c"
    ],    
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group" : "true",
        "awslogs-group" : "/ecs/${log_group}",
        "awslogs-stream-prefix" : "${log_group}",
        "awslogs-region": "eu-west-1"
      }
    },
    "environment" : [
      { "name" : "SERVICE_TYPE", "value" : "${service_type}" }
    ]
  }
]