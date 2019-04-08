control 'aws-rds-baseline-8' do
  title "Create the Data tier Security Group and ensure it allows inbound
  connections from App tier Security Group for explicit ports.'
  desc 'A security group acts as a virtual firewall for your instance to control
  inbound and outbound traffic. When you launch an instance in the AWS Virtual
  Private Cloud (VPC), you can assign the instance to up to five security groups.
  Security groups act at the instance level, not the subnet level. Therefore,
  each instance in a subnet in your VPC could be assigned to a different set of
  security groups. If you don't specify a particular group at launch time, the
  instance is automatically assigned to the default security group for the VPC.
  For each security group, you add rules that control the inbound traffic to
  instances, and a separate set of rules that control the outbound traffic.
  The port for these inbound rules would depend on the Database engine used and
  the configured port.

  The default values are:
  MySQL - TCP 3306
  MSSQL - TCP 1433
  Oracle SQL - TCP 1521
  PostgreSQL - TCP 5432
  MariaDB - TCP 3306
  Amazon Aurora DB - TCP 3306"
  impact 0.3
  tag "rationale": 'This protects the Data tier from unauthorized access, it is
  recommended to add inbound security group rules that allow traffic for the
  specific database protocol and ports by referencing as source the security
  group associated with the App tier instances.'
  tag "cis_rid": '6.24'
  tag "cis_level": 1
  tag "nist": ['IA-5(1)', 'Rev_4']
  tag "check": "Using the Amazon unified command line interface:
  Using the Amazon unified command line interface:

  * Retrieve the Data tier security group configured for your RDS DB instance:

  aws rds describe-db-instances --db-instance-identifier <your_db_instance>
  --query 'DBInstances[*].VpcSecurityGroups'

  * List the ingress rules for the above security group, and make sure that
  allows connections only from App tier security group on specific ports:

  aws ec2 describe-security-groups --group-ids <data_tier_security_group> --query
  'SecurityGroups[*].{GroupName:GroupName, IpPermissions:IpPermissions}' --output
  table
  "

  tag "fix": "Using the Amazon unified command line interface:

  * First remove all the ingress rules for the security group configured for your
  RDS DB instance:

  aws ec2 describe-security-groups --group-id <data_tier_security_group> --query
  'SecurityGroups[0].IpPermissions' > /tmp/IpPermissions.json
  aws ec2 revoke-security-group-ingress --group-id <data_tier_security_group>
  --ip- permissions file:///tmp/IpPermissions.json

  * Add an ingress rule for a specific port, using --source-group option to
  specify the App tier security group as the source of the connections:

  aws ec2 authorize-security-group-ingress --group-id <data_tier_security_group>
  -- protocol tcp --port <specific_port> --source-group <app_tier_security_group>'

  "

  attribute('db_instance_identifier').each do | identifier|
    rds_vpc_security_groups = aws_rds_instance("#{identifier}").vpc_security_groups.where(status: 'active').vpc_security_group_ids

    publicly_accessible = aws_rds_instance("#{identifier}").publicly_accessible
  
    if publicly_accessible
      rds_vpc_security_groups.each do |security_group|
        describe aws_security_group(id: security_group) do
          it { should allow_in(port: 3306, ipv4_range: '0.0.0.0/0') }
        end
        describe aws_security_group(id: security_group) do
          it { should allow_in(port: 1433, ipv4_range: '0.0.0.0/0') }
        end
        describe aws_security_group(id: security_group) do
          it { should allow_in(port: 1521, ipv4_range: '0.0.0.0/0') }
        end
        describe aws_security_group(id: security_group) do
          it { should allow_in(port: 5432, ipv4_range: '0.0.0.0/0') }
        end
      end
    else
      describe aws_rds_instance("#{identifier}") do
        its('publicly_accessible') { should_not be_true }
      end
    end
  end 
end
