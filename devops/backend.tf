
#terraform {
#  backend "s3" {
#    bucket = "kishq-terraform-backend"
#    key    = "kishq_jenkins.tfstate"
#    region = "ap-south-1"
#    encrypt = true
#    dynamodb_table = "terraform-state-lock-dynamo"
#    }
#  }

