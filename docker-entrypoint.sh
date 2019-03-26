#!/bin/bash
#path to conda binary
export CONDA_BIN='/opt/conda/bin/conda'
#path to conda python binary
export CONDA_PYTHON_BIN='opt/conda/bin/python'

echo setting conda cache
#temporarily remove the external conda package cache
$CONDA_BIN config --remove pkgs_dirs /opt/conda_pkgs_cache
#copy any cached packages to the external conda package cache
cp -n -r /opt/conda/pkgs/* /opt/conda_pkgs_cache/
#empty internal conda package cache
$CONDA_BIN clean --all -y  
#re add the external conda package cache
$CONDA_BIN config --prepend pkgs_dirs /opt/conda_pkgs_cache

echo update conda cache
#set where conda will install these packages
export CONDA_INSTALL_PATH='/opt/conda/dist-packages'
#update conda
$CONDA_BIN update -n base conda -y 
#install jupyter
$CONDA_BIN install -p $CONDA_INSTALL_PATH jupyter -y 
#install notebook extensions
$CONDA_BIN install -p $CONDA_INSTALL_PATH -c conda-forge jupyter_contrib_nbextensions -y 
echo install conda packages
#install custom packages
$CONDA_BIN install -p $CONDA_INSTALL_PATH $CONDA_PACKAGES -y 

#pip --cache-dir /opt/pip_pkgs_cache
echo install pip packages

#set the pip install path
export PIP_INSTALL_PATH='/opt/pip/dist-packages'
export PYTHONPATH=$PIP_INSTALL_PATH:$PYTHONPATH
pip install --target=$PIP_INSTALL_PATH $PIP_PACKAGES


echo "from notebook.auth import passwd
from os import environ
print(passwd(environ['NOTEBOOK_PASSWORD']))" > pwgen.py

export NOTEBOOK_PASSWORD_HASHED=$($CONDA_PYTHON_BIN pwgen.py)

if [ ! -f /root/.jupyter/jupyter_notebook_config.py ]; then
    /opt/conda/bin/jupyter notebook --generate-config
fi

/opt/conda/bin/jupyter notebook --notebook-dir=\'$NOTEBOOK_DIR\' --ip=\'$NOTEBOOK_IP\' --port=$NOTEBOOK_PORT --no-browser --allow-root --NotebookApp.password=\'$NOTEBOOK_PASSWORD_HASHED\'


