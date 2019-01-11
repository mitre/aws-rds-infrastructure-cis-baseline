# author: Mohamed El-Sharkawi, Rony Xavier
class AwsRdsInstance < Inspec.resource(1)
  name 'aws_rds_instance'
  desc 'Verifies settings for an rds instance'
  example "
    describe aws_rds_instance(db_instance_identifier: 'test-instance-id') do
      it { should exist }
    end
  "
  supports platform: 'aws'

  include AwsSingularResourceMixin

  attr_reader :db_instance_identifier, :db_instance, :vpc_security_group_id,
              :vpc_security_group_status, :db_parameter_group_name,
              :db_parameter_apply_status, :endpoint_address, :endpoint_port,
              :endpoint_hosted_zone_id, :db_subnet_group_name,
              :db_subnet_group_description, :vpc_id, :subnet_group_status,
              :option_group_name, :option_group_status

  def to_s
    "RDS blah Instance #{@db_instance_identifier}"
  end

  def subnets
    return nil unless exists?
    subnet_list = db_subnet_group.to_h[:subnets]
    SubnetFilter.new(subnet_list)
  end

  def vpc_security_groups
    return nil unless exists?
    vpc_security_group_list = db_instance.to_h[:vpc_security_groups]
    VPCSecurityGroupFilter.new(vpc_security_group_list)
  end

  def method_missing(name)
    # extract values
    db_instance[name.to_s] unless @db_instance.nil?
  end

  private

  def validate_params(raw_params)
    validated_params = check_resource_param_names(
      raw_params: raw_params,
      allowed_params: [:db_instance_identifier],
      allowed_scalar_name: :db_instance_identifier,
      allowed_scalar_type: String,
    )
    if validated_params.empty? or !validated_params.key?(:db_instance_identifier)
      raise ArgumentError, 'You must provide an id for the aws_rds_instance.'
    end

    if validated_params.key?(:db_instance_identifier) && validated_params[:db_instance_identifier] !~ /^[a-z]{1}[0-9a-z\-]{0,62}$/
      raise ArgumentError, 'aws_rds_instance Database Instance ID must be in the format: start with a letter followed by up to 62 letters/numbers/hyphens.'
    end

    validated_params
  end

  def fetch_from_api
    backend = BackendFactory.create(inspec_runner)
    dsg_response = nil
    catch_aws_errors do
      begin
        dsg_response = backend.describe_db_instances(db_instance_identifier: db_instance_identifier)
        @exists = true
      rescue Aws::RDS::Errors::DBInstanceNotFound
        @exists = false
        return
      end
    end

    if dsg_response.db_instances.empty?
      @exists = false
      return
    end
    @db_instance = dsg_response.db_instances[0]
    @vpc_security_group_id       = @db_instance.vpc_security_groups[0].vpc_security_group_id
    @vpc_security_group_status   = @db_instance.vpc_security_groups[0].status
    @db_parameter_group_name     = @db_instance.db_parameter_groups[0].db_parameter_group_name
    @db_parameter_apply_status   = @db_instance.db_parameter_groups[0].parameter_apply_status
    @endpoint_address            = @db_instance.endpoint.address
    @endpoint_port               = @db_instance.endpoint.port
    @endpoint_hosted_zone_id     = @db_instance.endpoint.hosted_zone_id
    @db_subnet_group_name        = @db_instance.db_subnet_group.db_subnet_group_name
    @db_subnet_group_description = @db_instance.db_subnet_group.db_subnet_group_description
    @vpc_id                      = @db_instance.db_subnet_group.vpc_id
    @subnet_group_status         = @db_instance.db_subnet_group.subnet_group_status
    @option_group_name           = @db_instance.option_group_memberships[0].option_group_name
    @option_group_status         = @db_instance.option_group_memberships[0].status
  end

  # Uses the SDK API to really talk to AWS
  class Backend
    class AwsClientApi < AwsBackendBase
      BackendFactory.set_default_backend(self)
      self.aws_client_class = Aws::RDS::Client

      def describe_db_instances(query)
        aws_service_client.describe_db_instances(query)
      end
    end
  end
end

class SubnetFilter
  filter = FilterTable.create
  filter.add_accessor(:entries)
        .add_accessor(:where)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:subnet_identifiers, field: :subnet_identifier)
        .add(:subnet_availability_zones, field: :subnet_availability_zone)
        .add(:subnet_statuses, field: :subnet_status)
  filter.connect(self, :subnets)

  def to_s
    "Subnets"
  end

  attr_reader :subnets
  def initialize(subnets=nil)
    @subnets = subnets
  end
end

class VPCSecurityGroupFilter
  filter = FilterTable.create
  filter.add_accessor(:entries)
        .add_accessor(:where)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:vpc_security_group_ids, field: :vpc_security_group_id)
        .add(:statuses, field: :status)
  filter.connect(self, :vpc_security_groups)

  def to_s
    "VPC Security Groups"
  end

  attr_reader :vpc_security_groups
  def initialize(vpc_security_groups=nil)
    @vpc_security_groups = vpc_security_groups
  end
end