FROM debian:buster-slim

ENV IBM_CLOUD_TOOLS=1.2.0
ENV DEBIAN_FRONTEND=noninteractive
ENV ISTIO_VERSION=1.0.2
ENV TERRAFORM_VERSION=0.11.8
ENV TERRAFORM_IBMCLOUD_VERSION=0.12.0
ENV WSKDEPLOY_VERSION=0.9.9

# Update the OS & Install pkgs that are needed
RUN apt-get update && apt-get install wget curl unzip nano python-softlayer -y

# IBMcloud CLI
WORKDIR "/root"
RUN curl -sL https://ibm.biz/idt-installer | bash
RUN cd /root/
RUN mkdir /root/bin

# Terraform
WORKDIR "/root"
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        chmod +x terraform && \
        mv terraform /root/bin && \
        rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Terraform IBM Provider
RUN echo "providers { \n \
ibm = "/root/terraform-provider-ibm_v${TERRAFORM_IBMCLOUD_VERSION}" \n \
}" > /root/.terraformrc
RUN wget https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v${TERRAFORM_IBMCLOUD_VERSION}/linux_amd64.zip && \
        unzip linux_amd64.zip && \
        chmod +x terraform-provider-ibm_* && \
        rm -rf linux_amd64.zip

# Istio
WORKDIR "/root"
RUN wget https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux.tar.gz && \
        tar -xvzf istio-${ISTIO_VERSION}-linux.tar.gz && \
        rm -rf istio-${ISTIO_VERSION}-linux.tar.gz

# wskdeploy
WORKDIR "/root"
RUN wget https://github.com/apache/incubator-openwhisk-wskdeploy/releases/download/0.9.9/openwhisk_wskdeploy-${WSKDEPLOY_VERSION}-linux-amd64.tgz && \
        tar -xvzf openwhisk_wskdeploy-${WSKDEPLOY_VERSION}-linux-amd64.tgz && \
        chmod +x wskdeploy && \
        mv wskdeploy /root/bin && \
        rm -rf openwhisk_wskdeploy-${WSKDEPLOY_VERSION}-linux-amd64.tgz

# Cleanup
WORKDIR "/root"
RUN  apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*log /var/log/apt/* /var/lib/dpkg/*-old /var/cache/debconf/*-old
RUN echo 'export PS1="\[\e[34m\]IBM\[\e[m\]☁️  # "' > /root/.bashrc
RUN echo 'export PATH=$PATH:/root/bin:/root/helm-${HELM_VERSION}:/root/istio-${ISTIO_VERSION}/bin/' >> /root/.bashrc
RUN echo 'cat /etc/motd' >> /root/.bashrc
RUN echo '\
\n \
\n \
\n \
Thank you for using the IBM Cloud Docker Container. \n \
\n \
\n \
\n \
You have the following tools at your disposal: \n \
  - git (git cli) \n \
  - helm (helm cli) \n \
  - ibmcloud (ibmcloud cli) \n \
  - ibmcloud cf (ibmcloud cloud foundry cli) \n \
  - istioctl (istio cli) \n \
  - kubectl (kubernetes cli) \n \
  - nano (if you need to edit any text) \n \
  - slcli (softlayer cli) \n \
  - terraform (terraform with the IBM cloud provider) \n \
  - wskdeploy (openwhisk deployment tool) \n \
\n \
\n \
Hopefully you bound mounted your credentials from the README \n \
otherwise you will need to copy paste them into this container.  \n \
' > /etc/motd

CMD ["/bin/bash"]
