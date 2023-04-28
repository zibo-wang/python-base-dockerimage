#!/bin/bash

chsh -s /bin/bash
apt-get update -y && apt-get install -y wget
wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O ~/mamba.sh
bash ~/mamba.sh -b -p /opt/conda
rm ~/mamba.sh
/opt/conda/bin/mamba init
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node && \
    nvm use node && \
    nvm alias default node && \
    npm install -g jupyterlab && \
    npm install -g @jupyter-widgets/jupyterlab-manager
export PATH=/opt/conda/bin:$PATH
source $HOME/.bashrc
mamba install -y jupyterlab ipympl
mamba update --all
jupyter lab build

mamba env export | grep -v "^prefix: " > environment.yml
cat environment.yml