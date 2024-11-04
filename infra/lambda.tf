data "archive_file" "minecraft_server_controller" {
  type        = "zip"
  source_dir  = "../backend/lambda_functions/minecraft_server_controller"
  output_path = "minecraft_server_controller.zip"
}

resource "aws_lambda_function" "minecraft_server_controller" {
  description      = "Controll minecraft server"
  function_name    = "minecraft_server_controller"
  role             = "arn:aws:iam::925849551550:role/aws-minecraft-controller-role"
  handler          = "main.handler"
  filename         = basename(data.archive_file.minecraft_server_controller.output_path)
  source_code_hash = data.archive_file.minecraft_server_controller.output_base64sha256

  timeout                        = 60
  reserved_concurrent_executions = -1
  memory_size                    = 128
  runtime                        = "python3.12"
  architectures = [
    "x86_64",
  ]

  layers = []

  environment {
    variables = {
      "INSTANCE_ID" = "i-04876c4b53e15f93d"
    }
  }

  ephemeral_storage {
    size = 512
  }

  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.allow_for_minecraft_controller.id,
    ]
    subnet_ids = [
      "subnet-00978068bc36a01e8",
    ]
  }
}

resource "aws_security_group" "allow_for_minecraft_controller" {
  description = "Allow for minecraft controller"
  name        = "allow_for_minecraft_controller"
  vpc_id      = aws_vpc.main.id

  tags = {
    "Name" = "For minecraft controller"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_for_minecraft_controller_from_all" {
  security_group_id            = aws_security_group.allow_for_minecraft_controller.id
  referenced_security_group_id = aws_security_group.allow_for_minecraft_controller.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_for_minecraft_controller_to_all_ipv4" {
  security_group_id = aws_security_group.allow_for_minecraft_controller.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_for_minecraft_controller_to_all_ipv6" {
  security_group_id = aws_security_group.allow_for_minecraft_controller.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
}
