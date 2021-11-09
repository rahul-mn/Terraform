#Define the variable values as required

variable "principal_arns" {
    type = list(string)
    description = " Account_IDs to allow Cross-account access of bucket for listing and getting the objects. Ex - arn:aws:iam::ID:root ( Replace ID with account id )"
    default = [""]
}
variable "bucket_prefix" {
    description = "Prefix for the bucket name followed by adding “-lambda-functions” as suffix. "
    default     = ""
}
variable "log_bucket_name" {
    description = "The name of the bucket that will receive the log objects."
    default     = ""
}