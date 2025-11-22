FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base tools, Python3, Git, SSH, GPG, etc.
RUN apt-get update && apt-get install -y \
    curl unzip git openssh-client \
    python3 python3-pip \
    software-properties-common gnupg \
    vim && \
    apt-get clean

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

# Install Ansible
RUN add-apt-repository --yes ppa:ansible/ansible && \
    apt-get update && apt-get install -y ansible

# Install Google Cloud SDK
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloudsdk.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloudsdk.gpg] \
    https://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y google-cloud-cli

WORKDIR /project
CMD ["bash"]
