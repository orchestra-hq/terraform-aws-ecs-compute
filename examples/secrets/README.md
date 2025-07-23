# Secrets

This example shows how to pass in secrets to the ECS task using AWS Secrets Manager or AWS SSM parameters. The full ARNs of the secrets must be provided for this module.

The module will create a suitable IAM policy in order for the ECS execution role to access the secrets. If the secrets are encrypted using a customer managed key, then you will additionally require `kms:Decrypt` permissions to be attached to the execution role. This needs to be done separately from the module:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["kms:Decrypt"],
      "Resource": ["arn:aws:kms:region:aws_account_id:key/key_id"]
    }
  ]
}
```
