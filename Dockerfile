FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HELM_VERSION=2.11.0
ENV ISTIO_VERSION=1.0.2
ENV TERRAFORM_VERSION=0.11.8
ENV TERRAFORM_IBMCLOUD_VERSION=0.12.0

# Update the OS
RUN apt-get update

# Install deps that are needed
RUN apt-get install wget curl unzip nano -y

# Softlayer CLI
WORKDIR "/root"
RUN apt-get install python-softlayer -y

# IBMcloud CLI
WORKDIR "/root"
RUN curl -sL https://ibm.biz/idt-installer | bash
RUN cd /root/
RUN mkdir /root/bin

# Terraform
WORKDIR "/root"
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN chmod +x terraform
RUN mv terraform /root/bin
RUN rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Terraform IBM Provider
RUN echo "providers { \n \
ibm = "/root/terraform-provider-ibm_v${TERRAFORM_IBMCLOUD_VERSION}" \n \
}" > /root/.terraformrc
RUN wget https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v${TERRAFORM_IBMCLOUD_VERSION}/linux_amd64.zip
RUN unzip linux_amd64.zip
RUN chmod +x terraform-provider-ibm_*
RUN rm -rf linux_amd64.zip

# Istio
WORKDIR "/root"
RUN wget https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux.tar.gz
RUN tar -xvzf istio-${ISTIO_VERSION}-linux.tar.gz
RUN rm -rf istio-${ISTIO_VERSION}-linux.tar.gz

# Helm
WORKDIR "/root"
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN tar -xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN mv linux-amd64 helm-${HELM_VERSION}
RUN rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz

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
  - helm (helm cli) \n \
  - ibmcloud (ibmcloud cli) \n \
  - ibmclodu cf (ibmcloud cloud foundry cli) \n \
  - istioctl (istio cli) \n \
  - kubectl (kubernetes cli) \n \
  - nano (if you need to edit any text) \n \
  - slcli (softlayer cli) \n \
  - terraform (terraform with the IBM cloud provider) \n \
\n \
\n \
Hopefully you bound mounted your credentials from the README \n \
otherwise you will need to copy paste them into this container.  \n \
' > /etc/motd

CMD ["/bin/bash"]
