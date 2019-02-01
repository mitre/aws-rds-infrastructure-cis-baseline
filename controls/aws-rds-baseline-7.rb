control 'aws-rds-baseline-7' do
  title ' Ensure RDS event subscriptions are enabled for DB security groups.'
  desc 'AWS Relational Database Services offers customers a managed database
  engine solution for hosting customer created databases which can allow for a
  reduction in operational burden on customers.
  RDS event subscriptions provide notification of selected event changes at a DB
  security group level'
  impact 0.3
  tag "rationale": 'Event subscriptions are designed to provide incident
  notification of events which may affect the network availability of the RDS
  instance.'
  tag "cis_rid": '4.4'
  tag "cis_level": 1
  tag "nist": ['IA-5(1)', 'Rev_4']
  tag "check": "Using the Amazon unified CLI:
  * List all present event subscriptions and review the value of
  'db-security-group' associated with 'SourceType' element:

  aws rds describe-event-subscriptions --query
  'EventSubscriptionsList[*].{SourceType:SourceType,
  SourceIdsList:SourceIdsList,
  EventCategoriesList:EventCategoriesList}'

  * 'EventCategoriesList' will list all event categories which will be reported
  on
  * 'SourceIdsList' will list all RDS DB instances included (null=all
  instances)"

  tag "fix": "Using the Amazon unified CLI:
  * Create a new event subscription for DB Security Group events:
  aws rds create-event-subscription --subscription-name <rds_event_subscription>
  --sns- topic-arn <sns_topic_arn> --source-type db-security-group
  --event-categories <rds_events> --source-ids <events_source_ids> --enabled
  "
end
