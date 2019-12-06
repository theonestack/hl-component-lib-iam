# iam-role CfHighlander component

## Methods

**service_assume_role_policy(services)**

`services` - Array or String of aws services

```ruby
IAM_ROLE(:Role) {
  AssumeRolePolicyDocument service_assume_role_policy('ec2')
  ...
} 
```

**iam_role_policies(iam_policy_yaml)**

`iam_policy_yaml` - yaml hash config of iam policies

```yaml
iam_policies:
  policy_name:
    action:
      - ec2:describeInstances
    resource:
      - arn:aws:ec2:${AWS::Region}:${AWS::AccountId}:instance/${InstanceId}
    effect: Allow
    condition:
      StringLike:
        ec2:ResourceTag/EnvironmentName: dev
``` 

```ruby
IAM_ROLE(:Role) {
  Policies iam_role_policies(iam_policies)
  ...
} 
```