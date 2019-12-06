require_relative '../ext/cfndsl/role'

context "service_assume_role_policy" do
  
  it "Allows an EC2 instance to assume the role" do
    expect(service_assume_role_policy('ec2')).to eq({
      :Statement=>[
        {
          :Action=>"sts:AssumeRole", 
          :Effect=>"Allow", 
          :Principal=>{:Service=>"ec2.amazonaws.com"}
        }
      ], 
      :Version=>"2012-10-17"
    })
  end

  it 'Allows a EC2 instance and ssm to assume the role' do
    expect(service_assume_role_policy(['ec2','ssm'])).to eq({
      :Statement=>[
        {
          :Action=>"sts:AssumeRole", 
          :Effect=>"Allow", 
          :Principal=>{:Service=>"ec2.amazonaws.com"}
        },
        {
          :Action=>"sts:AssumeRole", 
          :Effect=>"Allow", 
          :Principal=>{:Service=>"ssm.amazonaws.com"}
        }
      ], 
      :Version=>"2012-10-17"
    })
  end

end

context "iam_role_policies" do
  
  it 'Allows an EC2 Instance to Describe all Instances in the Account' do
    expect(iam_role_policies({'my-policy'=>{'action'=>'ec2:DescribeInstances'}})).to eq([{
      :PolicyDocument=>{
        :Statement=>[{
          :Action=>"ec2:DescribeInstances", 
          :Effect=>"Allow", 
          :Resource=>["*"], 
          :Sid=>"mypolicy"
        }]
      }, 
      :PolicyName=>"my-policy"
    }])
  end
  
  it 'Allows an EC2 Instance to Attach or Detach Volumes' do
    policy = {
      'ec2-volumes'=>{
        'action'=>[
          'ec2:AttachVolume',
          'ec2:DetachVolume'
        ],
        'resource'=>[
          'arn:aws:ec2:*:*:volume/*',
          'arn:aws:ec2:*:*:instance/*'
        ],
        'condition'=>[
          'ArnEquals'=>{
            'ec2:SourceInstanceARN'=>'arn:aws:ec2:*:*:instance/i-123456abcdefg'
          }
        ]
      }
    }
    expect(iam_role_policies(policy)).to eq([{
      :PolicyDocument=>{
        :Statement=>[{
          :Action=>[
            "ec2:AttachVolume", 
            "ec2:DetachVolume"
          ],
          :Resource=>[
            "arn:aws:ec2:*:*:volume/*", 
            "arn:aws:ec2:*:*:instance/*"
          ],
          :Condition=>[
            {
              "ArnEquals"=>{
                "ec2:SourceInstanceARN"=>"arn:aws:ec2:*:*:instance/i-123456abcdefg"
              }
            }
          ],
          :Effect=>"Allow",
          :Sid=>"ec2volumes"
        }]
      }, 
      :PolicyName=>"ec2-volumes"
    }])
  end
  
end