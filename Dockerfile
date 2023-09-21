FROM troykinsella/concourse-ansible-playbook-resource:2.0.0 as base
LABEL maintainer="Tomas Trnka <tt@tomastrnka.net>"
RUN apt-get update -y
RUN apt-get install -y jq apache2-utils git-crypt

FROM base AS tools
COPY requirements.txt /requirements.txt
RUN pip3 install -r requirements.txt \
    && wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.5/kubeseal-0.17.5-linux-amd64.tar.gz -O kubeseal.tar.gz \
    && tar -xf kubeseal.tar.gz \
    && rm kubeseal.tar.gz \
    && install -m 755 kubeseal /usr/local/bin/kubeseal \
    && wget https://github.com/mikefarah/yq/releases/download/v4.13.5/yq_linux_amd64 -O yq \
    && install -m 755 yq /usr/local/bin/yq \
    && wget https://storage.googleapis.com/kubernetes-release/release/v1.25.0/bin/linux/amd64/kubectl -O kubectl \
    && install -m 755 kubectl /usr/local/bin/kubectl \
    && wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.1.1/kustomize_v5.1.1_linux_amd64.tar.gz -O kustomize-install.tar.gz \
    && tar -xf kustomize-install.tar.gz \
    && rm kustomize-install.tar.gz \
    && install -m 755 kustomize /usr/local/bin/kustomize \
    && wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O awscliv2.zip \
    && unzip awscliv2.zip \
    && rm awscliv2.zip \
    && ./aws/install \
    && wget https://get.helm.sh/helm-v3.12.3-linux-amd64.tar.gz -O helm-v3.12.3-linux-amd64.tar.gz \
    && tar -xf helm-v3.12.3-linux-amd64.tar.gz \
    && rm helm-v3.12.3-linux-amd64.tar.gz \
    && install -m 755 linux-amd64/helm /usr/local/bin/helm 