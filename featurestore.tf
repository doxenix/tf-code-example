# LOCAL MODE
resource "aws_iam_role" "feature_store_local" {
  name = "feature_store_local"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "sagemaker.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "feature_store_local-AmazonSageMakerFeatureStoreAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFeatureStoreAccess"
  role       = aws_iam_role.feature_store_local.name
}

resource "aws_sagemaker_feature_group" "stock_predictions" {
  feature_group_name             = "stock_predictions"
  record_identifier_feature_name = "id"
  event_time_feature_name        = "timestamp"
  role_arn                       = aws_iam_role.feature_store_local.arn

  dynamic "feature_definition" {
    for_each = var.features
    content {
      feature_name = feature_definition.value["name"]
      feature_type = feature_definition.value["type"]
    }
  }

  offline_store_config {
    s3_storage_config {
      s3_uri = aws_s3_bucket.fs_config_local_mode.id
    }
  }

  online_store_config {
    enable_online_store = true
  }
}

# CENTRAL MODE

resource "aws_iam_role" "feature_store_central" {
  name = "feature_store_central"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "sagemaker.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "feature_store_central-AmazonSageMakerFeatureStoreAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFeatureStoreAccess"
  role       = aws_iam_role.feature_store_central.name
}

resource "aws_sagemaker_feature_group" "stock_predictions" {
  feature_group_name             = "stock_predictions"
  record_identifier_feature_name = "id"
  event_time_feature_name        = "timestamp"
  role_arn                       = aws_iam_role.feature_store_central.arn

  dynamic "feature_definition" {
    for_each = var.features
    content {
      feature_name = feature_definition.value["name"]
      feature_type = feature_definition.value["type"]
    }
  }

  offline_store_config {
    s3_storage_config {
      s3_uri = aws_s3_bucket.fs_config_central_mode.id
    }
  }

  online_store_config {
    enable_online_store = true
  }
}