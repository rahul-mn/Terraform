variable "account_id" {
#    type = list(string)
    description = " Account_IDs to allow Cross-account access of bucket for listing and getting the objects"
#    default = []
#   account_id_arns = [ for IDs in account_id: "arn:aws:iam::${IDs}:root" ]
}
variable "bucket_prefix" {
    description = "Prefix for the bucket name followed by adding “-lambda-functions” as suffix. "
#    default     = ""
}
variable "log_bucket_name" {
    description = "The name of the bucket that will receive the log objects."
#    default     = ""
}