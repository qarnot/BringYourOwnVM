FROM debian:12

WORKDIR /work

RUN apt-get update && apt-get install -y \
        iproute2 \
        curl \
        dnsmasq \
        genisoimage \
        git \
        iptables \
        procps \
        python3 \
        python3-pip \
        qemu-kvm \
        unzip \
        util-linux \
        wget \
        openssh-server \
        python3-ansible-runner \
        lsb-release \
        && rm -rf /var/lib/apt/lists/*

RUN git clone https://git.qarnot.net/open/bash-utils.git /work/bash-utils && \
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list && \
apt update && apt install packer

COPY src/run.bash /work/run.bash
COPY src/ /work/

RUN packer init /work/templates

ENTRYPOINT [ "/work/run.bash" ]
