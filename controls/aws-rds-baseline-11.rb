control 'aws-rds-baseline-11' do
  title 'Ensure RDS Database is configured to use the Data Tier Security Group'
  desc 'Amazon Relational Database Service (RDS) is a managed relational database
  service which handles routine database tasks such as provisioning, patching,
  backup, recovery, failure detection, and repair.
  There are 6 database engines available for customer to run their database
  workloads on:
  * Amazon Aurora (MySQL Compatible)
  * MySQL
  * MariaDB
  * Oracle
  * Microsoft SQL Server
  * PostgreSQL
  Customers can deploy RDS databases within a VPC through the configuration of:
  * Subnet Group for RDS, this group will be used for deployment of single or
  Multi-AZ RDS instances.
  * Network access through configuration of Security Groups for RDS
  * Access from outside the VPC hosting the DB instance by enabling/disabling a
  Public
  IP address'
  impact 0.3
  tag "rationale": 'Network access to the managed Data-Tier must be tightly
  controlled using Security Groups for RDS and non local accessibility of the DB
  instance.'
  tag "cis_rid": '6.34'
  tag "cis_level": 1
  tag "nist": ['IA-5(1)', 'Rev_4']
  tag "check": "Using the Amazon unified command line interface:
  * Check if your application DB instances are configured to use the Data Tier
  Security Group:

  aws rds describe-db-instances --filters
  Name=tag:<data_tier_tag>,Values=<data_tier_tag_value> --query
  'DBInstances[*].{VpcSecurityGroups:VpcSecurityGroups,
  DBInstanceIdentifier:DBInstanceIdentifier}'
  "

  tag "fix": "Using the Amazon unified command line interface:
  * Modify each non-compliant DB instance, and configure it to use the Data Tier
  Security Group:

  aws rds modify-db-instance --db-instance-identifier <your_db_instance>
  --vpc-security- group-ids <data_tier_security_group>
  "
end
