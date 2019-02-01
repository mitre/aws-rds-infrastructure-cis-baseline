control 'aws-rds-baseline-3' do
  title 'Ensure Relational Database Service Instances have Auto Minor Version
  Upgrade Enabled.'
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
  If the database engine used by your application supports it, ensure that the
  RDS Instances have Auto Minor Version Upgrade Enabled.
  '
  impact 0.3
  tag "rationale": 'Ensures automated patch management is in place on the RDS
  instance to ensure the database engine has all the latest patches applied.'
  tag "cis_rid": '3.6'
  tag "cis_level": 1
  tag "nist": ['IA-5(1)', 'Rev_4']
  tag "check": "Using the Amazon unified command line interface:
  * Check if your application DB instances have Auto Minor Version Upgrade
  enabled:

  aws rds describe-db-instances --filters
  Name=tag:<data_tier_tag>,Values=<data_tier_tag_value> --query
  'DBInstances[*].{AutoMinorVersionUpgrade:AutoMinorVersionUpgrade,
  DBInstanceIdentifier:DBInstanceIdentifier}'
  "

  tag "fix": "Using the Amazon unified command line interface:
  * Modify each DB instance with auto-minor-version-upgrade set to False, and
  enable auto-minor-version-upgrade:

  aws rds modify-db-instance --db-instance-identifier <your_db_instance>
  --auto-minor- version-upgrade"
end
