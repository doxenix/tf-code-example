resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
}

data "aws_iam_policy" "bucket_access" {
  name = "AmazonS3FullAccess"
}


#mlflow registry
resource "aws_iam_user" "mlflow_s3" {
  name = "mlflow-access-s3"
  permissions_boundary = data.aws_iam_policy.bucket_access.arn
    
}
resource "aws_iam_user_policy_attachment" "attach-policy" {
  user       = aws_iam_user.mlflow_s3.name
  policy_arn = data.aws_iam_policy.bucket_access.arn
}

resource "aws_s3_bucket" "mlflow_storage" {
  bucket = "mlflow_storage-${random_string.bucket_suffix.result}" 

}

#local-mode feature store
resource "aws_s3_bucket" "fs_config_local_mode" {
  bucket = "fs_config_local_mode-${random_string.bucket_suffix.result}" 

}


#central-mode feature store
resource "aws_s3_bucket" "fs_config_central_mode" {
  bucket = "fs_config_central_mode-${random_string.bucket_suffix.result}" 

}

