# Run your DB instance in an Amazon Virtual Private Cloud (VPC) for the greatest possible network access control.
# For more information about creating a DB instance in a VPC,
#  see Using Amazon RDS with Amazon Virtual Private Cloud (VPC).

describe aws_rds_instance(db_instance_identifier: attribute('db_instance_identifier')) do
  its ('vpc_id') { should cmp attribute('vpc_id') }
end

# Use AWS Identity and Access Management (IAM) policies to assign permissions that determine who is allowed to manage RDS resources.
# For example, you can use IAM to determine who is allowed to create, describe, modify, and
# delete DB instances, tag resources, or modify security groups.
describe aws_rds_instance(db_instance_identifier: attribute('db_instance_identifier')) do
  its ('iam_database_authentication_enabled') { should be_true }
end

# Use security groups to control what IP addresses or Amazon EC2 instances can connect to your
# databases on a DB instance. When you first create a DB instance, its firewall prevents any
# database access except through rules specified by an associated security group.
rds_vpc_security_groups = aws_rds_instance(attribute('db_instance_identifier'))
                          .vpc_security_groups
                          .where(status: 'active')
                          .vpc_security_group_ids

publicly_accessible = aws_rds_instance(attribute('db_instance_identifier'))
                      .publicly_accessible
if publicly_accessible
  rds_vpc_security_groups.each do |security_group|
    describe aws_security_group(id: security_group) do
      it { should_not allow_in(ipv4_range: '0.0.0.0/0') }
    end
  end
else
  describe aws_rds_instance(attribute('db_instance_identifier')) do
    its('publicly_accessible') { should_not be_true }
  end
end

storage_encrypted
# Use RDS encryption to secure your RDS instances and snapshots at rest. RDS encryption uses the
# industry standard AES-256 encryption algorithm to encrypt your data on the server that hosts
# your RDS instance. For more information, see Encrypting Amazon RDS Resources.
describe aws_rds_instance(attribute('db_instance_identifier')) do
  its('storage_encrypted') { should be_true }
end
