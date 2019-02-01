control 'aws-rds-baseline-2' do
  title 'Ensure Relational Database Service is Multi-AZ Enabled.'
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
  * PostgreSQL'
  impact 0.3
  tag "rationale": 'Provides AWS managed high availability of the Database Tier
  across 2 availability zones within a region through asynchronous replication at
  the data layer.'
  tag "cis_rid": '3.5'
  tag "cis_level": 1
  tag "nist": ['IA-5(1)', 'Rev_4']
  tag "check": "Using the Amazon unified command line interface:
  * Check if your application DB instances are Multi-AZ enabled:

  aws rds describe-db-instances --filters
  Name=tag:<data_tier_tag>,Values=<data_tier_tag_value> --query
  'DBInstances[*].{MultiAZ:MultiAZ, DBInstanceIdentifier:DBInstanceIdentifier}'
  "

  tag "fix": "Using the Amazon unified command line interface:
  * Modify each no-multi-az DB instance, and make it Multi-AZ enabled:
  aws rds modify-db-instance --db-instance-identifier <your_db_instance>
  --multi-az"
end
