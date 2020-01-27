FROM ubuntu

LABEL Description="Bigillu's Development Environment"

ARG user=bigillu
ARG uid=1000
ARG shell=/bin/bash

RUN apt-get update -y && apt-get install -y apt-utils software-properties-common \ 
    build-essential sudo \
    xz-utils curl wget unzip \
    git ssh cmake

# Installing LLVM toolchain 
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# --- User environment configuration ---
# Create and add user
RUN useradd -ms ${shell} ${user}
ENV USER=${user}

RUN export uid=${uid} gid=${uid}

RUN \
  mkdir -p /etc/sudoers.d && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"

# Switch to bigillu
USER ${user}

WORKDIR /home/${user}/code
