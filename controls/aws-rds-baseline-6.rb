control 'aws-rds-baseline-6' do
  title 'Ensure RDS event subscriptions are enabled for Instance level events'
  desc  'AWS Relational Database Services offers customers a managed database
  engine solution for hosting customer created databases which can allow for a
  reduction in operational burden on customers.
  RDS event subscriptions provide notification of selected event changes at
  DataBase engine level such as:
    * Deletion
    * Failure
    * Failover
    * Low Storage
    * Maintenance'
  impact 0.3
  tag "rationale": 'Event subscriptions are designed to provide incident
  notification of events which may affect the availability of a RDS database
  instance.'
  tag "cis_rid": '4.3'
  tag "cis_level": 1
  tag "nist": ['IR-6', 'Rev_4']
  tag "check": "Using the Amazon unified CLI:
  * List all present event subscriptions and review the value of \'db-instance\'
    associated with 'SourceType' element:

    aws rds describe-event-subscriptions --query
    'EventSubscriptionsList[*].{SourceType:SourceType, SourceIdsList:SourceIdsList,
    EventCategoriesList:EventCategoriesList}'

    * 'EventCategoriesList' will list all event categories which will be reported on
    * 'SourceIdsList' will list all RDS DB instances included (null=all instances)
    "

  tag "fix": "Using the Amazon unified CLI:
  * Create a new event subscription for DB instance level events:
    aws rds create-event-subscription --subscription-name <rds_event_subscription>
    --sns- topic-arn <sns_topic_arn> --source-type db-instance --event-categories
    <rds_events> -- source-ids <events_source_ids> --enabled
  "

  entries = aws_rds_event_subscriptions.where(source_type: 'db-instance').where(status: 'active').where(enabled: true)

  # aws_rds_event_subscriptions.where{source_type.flatten.include?('all')}
  describe.one do
    describe 'DB-Instance Event Subscriptions' do
      subject { entries }
      it { should exist }
      its('event_categories_lists.flatten') { should include 'all' }
    end
    describe 'DB-Instance Event Subscriptions' do
      subject { entries }
      it { should exist }
      its('event_categories_lists.flatten') { should include 'deletion' }
      its('event_categories_lists.flatten') { should include 'failure' }
      its('event_categories_lists.flatten') { should include 'failover' }
      its('event_categories_lists.flatten') { should include 'low storage' }
      its('event_categories_lists.flatten') { should include 'maintenance' }
      its('event_categories_lists.flatten') { should include 'notification' }
    end
  end
end
