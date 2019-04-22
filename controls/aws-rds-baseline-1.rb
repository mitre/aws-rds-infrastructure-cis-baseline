control 'aws-rds-baseline-1' do
  title 'Ensure Databases running on RDS have encryption at rest enabled'
  desc  'Amazon RDS instances and snapshots can be encrypted at rest by
  enabling the encryption option on the Amazon RDS DB instance. Data that is
  encrypted at rest includes the underlying storage for a DB instance, its
  automated backups, read replicas, and snapshots. It is recommended that
  encryption at rest be enabled.'
  impact 0.3
  tag "rationale": 'Enabling encryption at rest will help ensure that the
  confidentiality of data stored in RDS, snapshots, and backups, is maintained.
'
  tag "cis_rid": '1.4'
  tag "cis_level": 1
  tag "nist": ['SC-28(1)', 'Rev_4']
  tag "check": "Using the Amazon unified CLI:
  * List all current RDS instances and review the encryption status of the
  DB instance:

  aws rds describe-db-instances --query 'DBInstances[*].{DBName:DBName,
  EncryptionEnabled:StorageEncrypted, CMK:KmsKeyId}' "

  tag "fix": "Using the Amazon unified CLI:
  * Perform a snapshot of the DB instance:

  aws rds create-db-snapshot --db-snapshot-identifier <db_snapshot>
  --db-instance- identifier <your_db_instance>

  * Confirm created snapshot is available (once snapshot process has
  completed):

  aws rds describe-db-snapshots --query
  'DBSnapshots[*].{DBSnapshotIdentifier:DBSnapshotIdentifier,
  DBInstanceIdentifier:DBInstanceIdentifier, Snapshotstatus:Status}'

  * List all KMS Customer Managed Keys: aws kms list-aliases

  aws kms list-aliases

  * Copy to source RDS snapshot (from previous step) to a destination snapshot
  which will be encrypted:

  aws rds copy-db-snapshot --source-db-snapshot-identifier <db_snapshot>
  --target-db- snapshot-identifier <encrypted_db_snapshot>
  --kms-key-id <data_tier_kms_key>

  * Restore a snapshot to the target DB instance(from previous step) with same
  values as original db instance with additional encrypted storage values:

  aws rds restore-db-instance-from-db-snapshot --db-instance-identifier
  <your_db_instance> --db-snapshot-identifier <encrypted_db_snapshot>

" 
  attribute('db_instance_identifier').each do | identifier|
    describe aws_rds_instance("#{identifier}") do
      its('storage_encrypted') { should be_true }
    end
  end
end
