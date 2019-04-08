
# cis-aws-rds-infrastructure-baseline

ALPHA WIP- AWS RDS infrastructure validation

InSpec Profile to validate the secure configuration of cis-aws-rds-infrastructure-baseline, against CIS's Amazon Web Services Three-tier Web Architecture Benchmark V1.2.0

## Getting Started  
It is intended and recommended that InSpec run this profile from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target remotely over __<transport_protocol>__.

    Note to be removed: Changed it from "component" to "the target" because we talk about "Ruby language components" below. 
    
__For the best security of the runner, always install on the runner the _latest version_ of InSpec and supporting Ruby language components.__ 

Latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

## Required Configurations (OPTIONAL SECTION)
    NOTE: This is for situations where you need to provide attribute configurations, 
    credentials, etc. to inspec (e.g., rsa archer instance, database, etc.) so 
    it knows what to target. Displaying in a table (like tomcat) seems nice 
    and provide instructions on where/how people can configure them.

    Also, provide links to how to create attribute files or tailor attributes 
    in inspec.yml as well as templates. Projects should provide inspec.yml 
    attributes configured to default values (i.e. controls should be written 
    to use these attributes).
The following attributes must be configured in order for the profile to run correctly. These attributes can be configured in inspec.yml file or in an attributes file. More information about InSpec attributes can be found [here](https://www.inspec.io/docs/reference/profiles/).
    
| Attribute      | Type                            | Required | Default        | Description               |
| :---           | :---                            | :---     | :---           | :---                      |
| attribute-name | array/numeric/string/etc.yes/no | yes/no   | default-value  | Description of attribute. |

    NOTE: This section can also be used to set any required environment variables

The following environment variablers must also be set in order for the profile to run correctly. 

| Environment Variable |  Description              |
| :---                 | :---                      | 
| variable-name        | Description of attribute. |


Windows
```
$ setx VARIABLE_NAME=value
```

UNIX/Linux/MacOS
```
$ export VARIABLE_NAME=value
```

## Running This Profile

    inspec exec -t aws://https://github.com/mitre/cis-aws-rds-infrastructure-baseline/archive/master.tar.gz -t <transport-protocol>://<hostip> --user '<admin-account>' --password=<password> --reporter cli json:<filename>.json

Runs this profile over __<transport_protocol>__ to the host at IP address __hostip__ as a privileged user account (i.e., an account with administrative privileges), reporting results to both the command line interface (cli) and to a machine-readable JSON file. 

    NOTE: Provide a usable example based on instructions above. 
    Example:
    inspec exec https://github.com/mitre/cis-aws-rds-infrastructure-baseline/archive/master.tar.gz -t winrm://$winhostip --user 'Administrator --password=Pa55w0rd --reporter cli json:my-iis-site.json

## Viewing the JSON Results

The JSON results output file can be loaded into __[heimdall-lite](https://mitre.github.io/heimdall-lite/)__ for a user-interactive, graphical view of the InSpec results. 

The JSON InSpec results file may also be loaded into a __full heimdall server__, allowing for additional functionality such as to store and compare multiple profile runs.

## Contributing and Getting Help
To report a bug or feature request, please open an [issue](https://github.com/ejaronne/readmes/issues/new).

For other help, please send a message to [inspec@mitre.org](mailto:inspec@mitre.org).

To contribute, please review the [contribution guidelines](https://github.com/mitre/docs-mitre-inspec/blob/master/CONTRIBUTING.md).

## Authors
* Alicia Sturtevant
* Rony Xavier

## Special Thanks 
* The MITRE InSpec Team
* person_2
 

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
