FROM ubuntu:22.04

LABEL maintainer="Zibo Wang <zibo.w@outlook.com>"

USER root

ARG USERNAME=docker-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install Ubuntu packages
RUN apt-get update && \
    apt-get install -y wget fonts-liberation pandoc run-one sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/${USERNAME}

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    sudo chown $USERNAME:$USERNAME /opt && \
    sudo chown $USERNAME:$USERNAME /home/${USERNAME} && \
    bash ~/miniconda.sh -b -p /opt/miniconda3 && \
    rm ~/miniconda.sh && \
    /opt/miniconda3/bin/conda init

ENV NVM_DIR /home/${USERNAME}/.nvm
# Install Node.js
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="/home/${USERNAME}/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm use default

# Update environment variable
ENV PATH="${PATH}:/opt/miniconda3/bin"

RUN conda config --add channels conda-forge && \
    conda config --add channels R && \
    conda config --add channels bioconda && \
    conda config --set channel_priority true && \
    conda update -n base --all --yes && \
    conda install -n base conda-libmamba-solver && \
    conda config --set solver libmamba


SHELL ["/bin/bash", "-euo", "pipefail", "-c", "source /home/${USERNAME}/.bashrc"]

RUN conda clean -afy

ENV USERNAME=${USERNAME}
# Start bash shell
CMD ["/bin/bash"]

