control 'aws-rds-baseline-4' do
  title 'Ensure Relational Database Service backup retention policy is set.'
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
  * PostgreSQL.
  '
  impact 0.3
  tag "rationale": 'Provides a managed backup function of the RDS Database, it is
  possible to define the backup window and retention period of the backup. Each
  customer should have a retention policy set for the type of data being stored.
  Recommend setting this to at least 7.
  Possible values are from 0 to 35 days.'
  tag "cis_rid": '3.8'
  tag "cis_level": 1
  tag "nist": ['CP-9', 'Rev_4']
  tag "check": "Using the Amazon unified command line interface:
  * Check if your application DB instances have a Backup Retention Period set (0
  = there is no backup retention in place, 7 = there are 7 daily backups
  retained):

  aws rds describe-db-instances --filters
  Name=tag:<data_tier_tag>,Values=<data_tier_tag_value> --query
  'DBInstances[*].{BackupRetentionPeriod:BackupRetentionPeriod,
  DBInstanceIdentifier:DBInstanceIdentifier}'
  "

  tag "fix": "Using the Amazon unified command line interface:
  * Modify each DB instance with Backup Retention Period of 0, and set a desired
  Backup Retention Period in days (recommended value = 7):

  aws rds modify-db-instance --db-instance-identifier <your_db_instance>
  --backup- retention-period <backup_retention_period>"
  input('db_instance_identifier').each do |identifier|
    describe aws_rds_instance(identifier.to_s) do
      its('backup_retention_period') { should cmp >= 7 }
    end
  end
end
