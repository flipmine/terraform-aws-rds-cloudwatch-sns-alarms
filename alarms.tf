locals {
  thresholds = {
    BurstBalanceThreshold     = min(max(var.burst_balance_threshold, 0), 100)
    CPUUtilizationThreshold   = min(max(var.cpu_utilization_threshold, 0), 100)
    CPUCreditBalanceThreshold = max(var.cpu_credit_balance_threshold, 0)
    DiskQueueDepthThreshold   = max(var.disk_queue_depth_threshold, 0)
    FreeableMemoryThreshold   = max(var.freeable_memory_threshold, 0)
    FreeStorageSpaceThreshold = max(var.free_storage_space_threshold, 0)
    SwapUsageThreshold        = max(var.swap_usage_threshold, 0)
  }
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"
  name    = coalesce(module.this.name, var.db_instance_id)
  context = module.this.context
}

module "burst_balance_too_low_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["burst_balance_too_low"]
  context    = module.label.context
}

module "cpu_utilization_too_high_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["cpu_utilization_too_high"]
  context    = module.label.context
}

module "cpu_credit_balance_too_low_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["cpu_credit_balance_too_low"]
  context    = module.label.context
}

module "disk_queue_depth_too_high_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["disk_queue_depth_too_high"]
  context    = module.label.context
}

module "freeable_memory_too_low_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["freeable_memory_too_low"]
  context    = module.label.context
}

module "free_storage_space_threshold_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["free_storage_space_threshold"]
  context    = module.label.context
}

module "swap_usage_too_high_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["swap_usage_too_high"]
  context    = module.label.context
}

resource "aws_cloudwatch_metric_alarm" "burst_balance_too_low" {
  alarm_name          = module.burst_balance_too_low_label.id
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["BurstBalanceThreshold"]
  alarm_description   = "Average database storage burst balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = aws_sns_topic.default.*.arn
  ok_actions          = aws_sns_topic.default.*.arn

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  alarm_name          = module.cpu_utilization_too_high_label.id
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = aws_sns_topic.default.*.arn
  ok_actions          = aws_sns_topic.default.*.arn

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  alarm_name          = module.cpu_credit_balance_too_low_label.id
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["CPUCreditBalanceThreshold"]
  alarm_description   = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = aws_sns_topic.default.*.arn
  ok_actions          = aws_sns_topic.default.*.arn

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  alarm_name          = module.disk_queue_depth_too_high_label.id
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description   = "Average database disk queue depth over last 10 minutes too high, performance may suffer"
  alarm_actions       = aws_sns_topic.default.*.arn
  ok_actions          = aws_sns_topic.default.*.arn

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  alarm_name          = module.freeable_memory_too_low_label.id
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["FreeableMemoryThreshold"]
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = aws_sns_topic.default.*.arn
  ok_actions          = aws_sns_topic.default.*.arn

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = module.free_storage_space_threshold_label.id
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space over last 10 minutes too low"
  alarm_actions       = aws_sns_topic.default.*.arn
  ok_actions          = aws_sns_topic.default.*.arn

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  alarm_name          = module.swap_usage_too_high_label.id
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["SwapUsageThreshold"]
  alarm_description   = "Average database swap usage over last 10 minutes too high, performance may suffer"
  alarm_actions       = aws_sns_topic.default.*.arn
  ok_actions          = aws_sns_topic.default.*.arn

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}
