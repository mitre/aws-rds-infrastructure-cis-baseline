control 'aws-rds-baseline-9' do
  title 'Ensure Data tier Security Group has no inbound rules for CIDR of 0
  (Global Allow).'
  desc "A security group acts as a virtual firewall for your instance to control
  inbound and outbound traffic. When you launch an instance in the AWS Virtual
  Private Cloud (VPC), you can assign the instance to up to five security groups.
  Security groups act at the instance level, not the subnet level. Therefore,
  each instance in a subnet in your VPC could be assigned to a different set of
  security groups. If you don't specify a particular group at launch time, the
  instance is automatically assigned to the default security group for the VPC.
  For each security group, you add rules that control the inbound traffic to
  instances, and a separate set of rules that control the outbound traffic."
  impact 0.3
  tag "rationale": 'Considering any of the non-public tiers receive requests only
  either from the upper tier or from resources inside the same VPC, any inbound
  rules that allow traffic from any source (0.0.0.0/0) are not necessary and
  should be removed.'
  tag "cis_rid": '6.25'
  tag "cis_level": 1
  tag "nist": ['SC-7', 'Rev_4']
  tag "check": "Using the Amazon unified command line interface:
  Using the Amazon unified command line interface:

  * Retrieve the Data tier security group configured for your RDS DB instance:

  aws rds describe-db-instances --db-instance-identifier <your_db_instance>

  * List the ingress rules for the above security group, and make sure it has no
  inbound rules for CIDR of 0.0.0.0/0:

  aws ec2 describe-security-groups --group-ids <data_tier_security_group> --query
  'SecurityGroups[*].{GroupName:GroupName, IpPermissions:IpPermissions}' --output
  table
  "

  tag "fix": "Using the Amazon unified command line interface:

  * Remove the ingress rules for CIDR 0.0.0.0/0:
  aws ec2 revoke-security-group-ingress --group-id <data_tier_security_group>
  --protocol tcp/udp --port <specific_port> --cidr 0.0.0.0/0
  "
  attribute('db_instance_identifier').each do |identifier|
    rds_vpc_security_groups = aws_rds_instance(identifier.to_s).vpc_security_groups.where(status: 'active').vpc_security_group_ids

    publicly_accessible = aws_rds_instance(identifier.to_s).publicly_accessible
    if publicly_accessible
      rds_vpc_security_groups.each do |security_group|
        describe aws_security_group(id: security_group) do
          it { should_not allow_in(ipv4_range: '0.0.0.0/0') }
        end
      end
    else
      describe aws_rds_instance(identifier.to_s) do
        its('publicly_accessible') { should_not be_true }
      end
    end
  end
end
