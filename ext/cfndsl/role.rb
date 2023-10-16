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

def iam_role_policies(iam_policy_config={})
  policies = []
  iam_policy_config.each do |name,policy|
    if policy.kind_of?(Array)
      statements = policy.map.with_index {|pol, index| get_statement("#{name}#{index}", pol)}
      policies << get_policy(name, statements)
    elsif policy.kind_of?(Hash)
      statement = get_statement(name, policy)
      policies << get_policy(name, statement)
    else
      raise ArgumentError.new("iam role policies expecting policy to be of type Array or Hash, recieved type #{policy.class}")      
    end
  end
  return policies
end

def get_policy(name, statement)
  statements = (statement.kind_of?(Array) ? statement : [statement])
   
  return {
    PolicyName: name,
    PolicyDocument: {
      Version: '2012-10-17',
      Statement: statements
    }
  }
end

def get_statement(name, policy)
  if !policy.has_key?('action')
    raise ArgumentError.new("iam role policy must have an action defined")
  end

  actions = policy['action']
  effect = policy.fetch('effect', 'Allow')
  resources = policy.fetch('resource', '*')
  condition = policy.fetch('condition', {})

  resources = (resources.kind_of?(Array) ? resources : [resources])
  
  statement = {
      Sid: name.gsub('_', '').gsub('-', '').downcase,
      Action: actions,
      Resource: resources,
      Effect: effect
  }

  if !condition.empty?
    statement[:Condition] = condition
  end

  return statement
end