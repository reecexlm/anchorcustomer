resource "aws_security_group" "sg" {
  vpc_id = module.vpc.id
}

resource "aws_msk_cluster" "anchorkafka" {
  cluster_name           = "anchorkafka"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 1000
    client_subnets = module.vpc.private_subnets
    security_groups = [aws_security_group.sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = false
      }
      node_exporter {
        enabled_in_broker = false
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = false
        #log_group = aws_cloudwatch_log_group.test.name
      }
      firehose {
        enabled         = false
        #delivery_stream = aws_kinesis_firehose_delivery_stream.test_stream.name
      }
      s3 {
        enabled = false
        #bucket  = aws_s3_bucket.bucket.id
        #prefix  = "logs/msk-"
      }
    }
  }

  tags = {
    foo = "bar"
  }
}
