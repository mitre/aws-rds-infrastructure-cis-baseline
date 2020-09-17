# aws-rds-infrastructure-cis-baseline

InSpec Profile to validate the secure configuration of aws-rds-infrastructure-cis-baseline, against CIS's Amazon Web Services Three-tier Web Architecture Benchmark V1.0.0

## Getting Started  
It is intended and recommended that InSpec run this profile from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target remotely over __<transport_protocol>__.


Latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

The following attributes must be configured in an attributes file for the profile to run correctly. More information about InSpec attributes can be found in the [InSpec Profile Documentation](https://www.inspec.io/docs/reference/profiles/).

```
# Description of input value
input-name: default-value

# Database instance identifier
db_instance_identifier: []

# VPC Security Group Id
vpc_security_group_id: []]

# Allowed IP address range
allowed_ip_address_range: ''
```

## Usage

InSpec makes it easy to run your tests wherever you need. More options listed here: [InSpec cli](http://inspec.io/docs/reference/cli/)

```
# Clone Inspec Profile
$ git clone https://github.com/mitre/aws-rds-infrastructure-cis-baseline

# Set required ENV variables
$ export AWS_ACCESS_KEY_ID=key-id
$ export AWS_SECRET_ACCESS_KEY=access-key
$ export AWS_SESSION_TOKEN=session_token
$ export AWS_REGION=us-west-1

# To run profile locally and directly from Github
$ inspec exec /path/to/profile -t aws:// 

# To run profile locally and directly from Github with cli & json output 
$ inspec exec /path/to/profile -t aws:// --reporter cli json:rds-results.json

# To run profile locally and directly from Github with cli & json output, in a specific region with a specific AWS profile
$ inspec exec /path/to/profile -t aws://us-east-1/<mycreds-profile> --reporter cli json:rds-results.json

```
## Viewing the JSON Results

The JSON results output file can be loaded into __[heimdall-lite](https://mitre.github.io/heimdall-lite/)__ for a user-interactive, graphical view of the InSpec results. 

The JSON InSpec results file may also be loaded into a __full heimdall server__, allowing for additional functionality such as to store and compare multiple profile runs.

## Contributing and Getting Help
To report a bug or feature request, please open an issue at https://github.com/mitre/ <project> /issues/new .

For other help, please send a message to [inspec@mitre.org](mailto:inspec@mitre.org).

To contribute, please review the [contribution guidelines](https://github.com/mitre/docs-mitre-inspec/blob/master/CONTRIBUTING.md).

## Authors
* Alicia Sturtevant
* Rony Xavier

## Special Thanks 
* The MITRE InSpec Team

## License
This is licensed under the Apache 2.0 license excepted as noted in [LICENSE.MD](https://github.com/mitre/project/blob/master/LICENSE.md). 

### NOTICE

© 2019 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.  

### NOTICE
MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

### NOTICE  

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.  

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.

### NOTICE
< DISA STIGs | CIS Benchmarks > are published by < DISA IASE | the Center for Internet Security (CIS) >, see: 
< https://iase.disa.mil/Pages/privacy_policy.aspx | https://www.cisecurity.org/ >.
