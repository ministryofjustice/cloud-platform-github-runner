FROM debian:buster-slim

ENV GITHUB_PAT ""
ENV GITHUB_TOKEN ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
# curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | jq -r '.tag_name[1:]'
ENV GITHUB_RUNNER_VERSION "2.278.0"
ENV RUNNER_WORKDIR "_work"
ENV RUNNER_LABELS ""
ENV ADDITIONAL_PACKAGES ""

RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        gnupg2 \
        iputils-ping \
        jq \
        software-properties-common \
        sudo \
        tar \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" \
    && apt-get update && apt-get -y install docker-ce-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m github \
    && usermod -aG sudo github && groupadd docker && usermod -aG docker github \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER github
WORKDIR /home/github

RUN curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz \
    && sudo ./bin/installdependencies.sh

COPY --chown=github:github entrypoint.sh runsvc.sh ./
RUN sudo chmod u+x ./entrypoint.sh ./runsvc.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
