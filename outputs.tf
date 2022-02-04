output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = join("", aws_sns_topic.default.*.arn)
}

output "burst_balance_too_low_name" {
  description = "Average database storage burst balance over last 10 minutes too low, expect a significant performance drop soon"
  value       = aws_cloudwatch_metric_alarm.burst_balance_too_low.alarm_name
}

output "cpu_utilization_too_high_name" {
  description = "Average database CPU utilization over last 10 minutes too high"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization_too_high.alarm_name
}

output "cpu_credit_balance_too_low_name" {
  description = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon"
  value       = aws_cloudwatch_metric_alarm.cpu_credit_balance_too_low.alarm_name
}

output "disk_queue_depth_too_high_name" {
  description = "Average database disk queue depth over last 10 minutes too high, performance may suffer"
  value       = aws_cloudwatch_metric_alarm.disk_queue_depth_too_high.alarm_name
}

output "freeable_memory_too_low_name" {
  description = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  value       = aws_cloudwatch_metric_alarm.freeable_memory_too_low.alarm_name
}

output "free_storage_space_too_low_name" {
  description = "Average database free storage space over last 10 minutes too low"
  value       = aws_cloudwatch_metric_alarm.free_storage_space_too_low.alarm_name
}

output "swap_usage_too_high_name" {
  description = "Average database swap usage over last 10 minutes too high, performance may suffer"
  value       = aws_cloudwatch_metric_alarm.swap_usage_too_high.alarm_name
}

output "disk_queue_depth_too_high_metric_query" {
  value       = aws_cloudwatch_metric_alarm.disk_queue_depth_too_high.metric_query
}
