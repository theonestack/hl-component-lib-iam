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

single statement policies

```yaml
iam_policies:
  policy_name:
    action:
      - ec2:DescribeInstances
    resource:
      - Fn::Sub: arn:aws:ec2:${AWS::Region}:${AWS::AccountId}:instance/${InstanceId}
    effect: Allow
    condition:
      StringLike:
        ec2:ResourceTag/EnvironmentName: dev
``` 

multi statement policies

```yaml
iam_policies:
  policy_name:
  -
    action:
      - ec2:DescribeInstances
    resource:
      - Fn::Sub: arn:aws:ec2:${AWS::Region}:${AWS::AccountId}:instance/${InstanceId}
    effect: Allow
    condition:
      StringLike:
        ec2:ResourceTag/EnvironmentName: dev
  -
    action:
      - ec2:DescribeRegions
``` 


```ruby
IAM_ROLE(:Role) {
  Policies iam_role_policies(iam_policies)
  ...
} 
```