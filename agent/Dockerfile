FROM golang:1.18.1 as dagger
USER root
RUN apt-get update \
    && apt-get install -y lsb-release curl git make wge jq
RUN /bin/bash -c 'git clone --depth 1 --branch $(curl -sL https://api.github.com/repos/dagger/dagger/releases/latest | jq -r ".tag_name") https://github.com/dagger/dagger /dagger'
WORKDIR /dagger
RUN make dagger

FROM jenkins/agent as agent
USER root
RUN apt-get update \
    && apt-get install -y lsb-release curl
COPY --from=dagger /dagger/cmd/dagger/dagger /usr/local/bin/dagger
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
