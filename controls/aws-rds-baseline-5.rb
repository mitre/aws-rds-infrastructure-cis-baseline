control 'aws-rds-baseline-5' do
  title ' Ensure a SNS topic is created for sending out notifications from RDS
  events.'
  desc 'For the RDS event subscriptions to be able to send out notifications, a
  SNS topic should be created.
  Amazon Simple Notification Service (Amazon SNS) is a web service that
  coordinates and manages the delivery or sending of messages to subscribing
  endpoints or clients.
  When using Amazon SNS, you (as the owner) create a topic and control access to
  it by defining policies that determine which publishers and subscribers can
  communicate with the topic.'
  impact 0.3
  tag "rationale": 'RDS events generaged through defined RDS event subscriptions
  needs to be sent out to administrators, in order to be acted upon.'
  tag "cis_rid": '4.2'
  tag "cis_level": 1
  tag "nist": ['IA-5(1)', 'Rev_4']
  tag "check": "Using the Amazon unified CLI:
  * List all RDS event subscriptions in order to capture the topic-arn:

  aws rds describe-event-subscriptions --query
  'EventSubscriptionsList[*].{SourceType:SourceType,
  SourceIdsList:SourceIdsList,
  EventCategoriesList:EventCategoriesList}'

  * List SNS topic attributes:

  aws sns list-topic-attributes --topic-arn <sns_topic_arn>

  * List SNS topic subscriptions (endpoint which receives messages captured by
  the SNS topic):

  aws sns list-subscriptions-by-topic --topic-arn <sns_topic_arn>
  "

  tag "fix": "Using the Amazon unified CLI:

  * Create a new topic, and note the topic-arn value:

  aws sns create-topic --name <sns_topic_name>

  * Create a subscription to the new topic:

  aws sns subscribe --topic-arn <sns_topic_arn> --protocol <protocol_for_sns> --
  notification-endpoint <sns_subscription_endpoints>
  "
end
