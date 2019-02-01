# author: Rony Xavier
class AwsRdsEventSubscriptions < Inspec.resource(1)
  name 'aws_rds_event_subscriptions'
  desc 'Queries AWS RDS Event Subscriptions'
  example "
    describe aws_rds_event_subscriptions do
      it { should_not be_empty }
    end
  "
  supports platform: 'aws'

  include AwsSingularResourceMixin

  attr_reader :table

  filter = FilterTable.create
  filter.add_accessor(:entries)
        .add_accessor(:where)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:customer_aws_ids,            field: :customer_aws_id)
        .add(:cust_subscription_ids,       field: :cust_subscription_id)
        .add(:sns_topic_arns,              field: :sns_topic_arn)
        .add(:statuses,                    field: :status)
        .add(:subscription_creation_times, field: :subscription_creation_time)
        .add(:source_types,                field: :source_type)
        .add(:source_ids_lists,            field: :source_ids_list)
        .add(:event_categories_lists,      field: :event_categories_list)
        .add(:enabled_subscriptions,       field: :enabled)
        .add(:event_subscription_arns,     field: :event_subscription_arn)
  filter.install_filter_methods_on_resource(self, :table)

  def validate_params(resource_params)
    unless resource_params.empty?
      raise ArgumentError, 'aws_rds_event_subscriptions does not accept resource parameters.'
    end

    resource_params
  end

  def to_s
    'AWS RDS Event Subscriptions'
  end

  def fetch_from_api
    @table = []
    backend = BackendFactory.create(inspec_runner)
    @table = []
    pagination_opts = {}
    loop do
      api_result = backend.describe_event_subscriptions(pagination_opts)
      @table += api_result.event_subscriptions_list.map(&:to_h)
      pagination_opts = { marker: api_result.marker }
      break if api_result.marker.nil?
    end
    @table.each do |entry|
      # if all rds instance are defined as source `source_ids_list` the API
      # returns a nil hence the field is marked all
      entry[:source_ids_list]       = ['all'] if entry[:source_ids_list].nil?
      # if all event categories are defined in the event `event_categories_list`
      # the API returns a nil hence the field is marked all
      entry[:event_categories_list] = ['all'] if entry[:event_categories_list].nil?
    end
  end

  # Uses the SDK API to really talk to AWS
  class Backend
    class AwsClientApi < AwsBackendBase
      BackendFactory.set_default_backend(self)
      self.aws_client_class = Aws::RDS::Client

      def describe_event_subscriptions(query)
        aws_service_client.describe_event_subscriptions(query)
      end
    end
  end
end
