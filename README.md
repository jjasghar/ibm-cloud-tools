# IBM cloud Docker container

[![Build Status](https://travis-ci.org/jjasghar/ibm-cloud-tools.svg?branch=master)](https://travis-ci.org/jjasghar/ibm-cloud-tools)

## Scope

This is so you can have all of the tooling you need to start using
the IBM :cloud: in one spot.

## Build

Here is how to build it:

```shell
git clone https://github.com/jjasghar/ibm-cloud-tools/
cd ibm-cloud-tools
docker build .
```

## Running the container

```shell
docker run -it jjasghar/ibm-cloud-tools

```

### Using Softlayer

```shell
docker run -it -v ~/.softlayer:/root/.softlayer jjasghar/ibm-cloud-tools
```

### Using BlueMix

```shell
docker run -it jjasghar/ibm-cloud-tools
IBM☁️  # ibmcloud login
```

### Using Terraform

```shell
cd terraform_plans # Where every you have your .tf files
docker run -it -v $PWD:/root/terraform_plans jjasghar/ibm-cloud-tools
cd terraform_plans
terraform init
terraform apply
```

### Using wskdeploy

```shell
cd wskdeploy_manifests # Where you have you wskdeploy manifest
docker run -it -v $PWD:/root/wskdeploy_manifests jjasghar/ibm-cloud-tools
IBM☁️  # ibmcloud login
IBM☁️  # ibmcloud wsk api list # Generate the .wskprops file
IBM☁️  # wskdeploy
```

## Questions?

Come join us on [Freenode](http://webchat.freenode.net/?channels=ibmcloud) if you have
any questions.

## License & Authors

If you would like to see the detailed LICENCE click [here](./LICENCE).

- Author: JJ Asghar <jja@ibm.com>

```text
Copyright:: 2018- IBM, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
