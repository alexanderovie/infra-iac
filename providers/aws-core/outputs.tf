output "s3_buckets" {
  description = "Map of S3 bucket information"
  value = {
    for k, v in aws_s3_bucket.generic_buckets : k => {
      id   = v.id
      arn  = v.arn
      name = v.name
    }
  }
}

output "sqs_queues" {
  description = "Map of SQS queue information"
  value = {
    for k, v in aws_sqs_queue.generic_queues : k => {
      id   = v.id
      arn  = v.arn
      name = v.name
      url  = v.url
    }
  }
}

output "dead_letter_queues" {
  description = "Map of dead letter queue information"
  value = {
    for k, v in aws_sqs_queue.dead_letter_queues : k => {
      id   = v.id
      arn  = v.arn
      name = v.name
      url  = v.url
    }
  }
}

output "iam_roles" {
  description = "Map of IAM role information"
  value = {
    for k, v in aws_iam_role.basic_roles : k => {
      id   = v.id
      arn  = v.arn
      name = v.name
    }
  }
}
