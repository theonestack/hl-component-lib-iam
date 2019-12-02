def service_assume_role_policy(services)

  services = (services.kind_of?(Array) ? services : [services])
  statement = []

  services.each do |service|
    unless service.end_with? '.amazonaws.com'
      service = "#{service}.amazonaws.com"
    end
    statement << { Effect: 'Allow', Principal: { Service: "#{service}" }, Action: 'sts:AssumeRole' }
  end
  return {
      Version: '2012-10-17',
      Statement: statement
  }
end

"""
Returns an array of defined policies
YAML Structure
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
"""
def iam_role_policies(iam_policy_config={})
  policies = []
  iam_policy_config.each do |name,policy|
    policies << iam_policy(
      name,
      policy['action'],
      policy['resource'] || '*',
      policy['condition'] || {},
      policy['effect'] || 'Allow')
  end
  return policies
end

def iam_policy(name,actions,resources='*',condition={},effect='Allow')
  
  resources = (resources.kind_of?(Array) ? resources : [resources])
  
  statement = {
      Sid: name.gsub('_', '').gsub('-', '').downcase,
      Action: actions,
      Resource: resources.map {|res| FnSub(res)},
      Effect: effect
  }

  if !condition.empty?
    statement[:Condition] = condition
  end
  
  policy = {
    PolicyName: name,
    PolicyDocument: {
      Statement: [statement]
    }
  }
  
  return policy
end