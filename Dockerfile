FROM ubuntu

LABEL Description="Bigillu's Development Environment"

ARG user=bigillu
ARG uid=1000
ARG shell=/bin/bash

RUN apt-get update -y && apt-get install -y apt-utils software-properties-common \ 
    build-essential sudo \
    xz-utils curl wget unzip \
    git ssh cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 


# Installing LLVM toolchain 
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# --- User environment configuration ---
# Create and add user
RUN useradd -ms ${shell} ${user} \
  && export uid=${uid} gid=${uid} \
  && mkdir -p /etc/sudoers.d \
  && echo "${user}:x:${uid}:" >> /etc/group \
  && echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" \
  && chmod 0440 "/etc/sudoers.d/${user}"

# Switch to bigillu
ENV USER=${user}
USER ${user}

WORKDIR /home/${user}/code
# Checkout the repositories from GitHub
RUN sudo git clone https://github.com/bigillu/ab-print.git \
    && sudo git clone https://github.com/bigillu/ab-utils.git
