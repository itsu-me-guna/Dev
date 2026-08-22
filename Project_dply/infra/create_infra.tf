provider "aws" {
  region = "us-east-1"
}

# Look up existing bucket
data "aws_s3_bucket" "glue_scripts" {
  bucket = "my-glue-scripts-bucket-from-tf-20260823-000001"
}

# Upload script into that bucket
resource "aws_s3_object" "script" {
  bucket = data.aws_s3_bucket.glue_scripts.id
  key    = "scripts/My_Source_ingest.py"
  source = "src/My_Source_ingest.py"
}

# Look up existing IAM role
data "aws_iam_role" "glue_role" {
  name = "glue-job-role-guna-from-tf"
}

resource "aws_iam_role_policy_attachment" "glue_policy_attach" {
  role       = data.aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_glue_job" "my_job" {
  name     = "my-source-ingest-job"
  role_arn = data.aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.glue_scripts.id}/${aws_s3_object.script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"      = "s3://${data.aws_s3_bucket.glue_scripts.id}/tmp/"
    "--job-language" = "python"
  }

  max_capacity = 2
}
