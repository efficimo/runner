FROM docker:stable-dind

ARG KUBERNETES_VERSION=1.12.7
ARG HELM_VERSION=2.14.2

RUN apk add --update alpine-sdk && \
    apk add --update bash python python-dev py-pip build-base openssh jq rsync && \
    apk add -U --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing aufs-util && \
    apk add libffi-dev openssl-dev libgcc && \
    pip install docker-compose && \
    pip install awscli && \
    mkdir -p ~/.ssh/ && \
    echo -e "Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null" > ~/.ssh/config && \
    apk add -U openssl curl tar gzip bash ca-certificates git && \
    curl -sS "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar zx && \
    mv linux-amd64/helm /usr/bin/ && \
    mv linux-amd64/tiller /usr/bin/ && \
    curl -sSL -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x /usr/bin/kubectl && \
    git config --global http.postBuffer 157286400

COPY start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

CMD /etc/start.sh
