#!/bin/bash
export CONDA_EXE='/opt/conda/bin/conda'
export CONDA_PYTHON_EXE='opt/conda/bin/python'

$CONDA_EXE config --remove pkgs_dirs /opt/conda_pkgs_cache
cp -n /opt/conda/pkgs/* /opt/conda_pkgs_cache/
$CONDA_EXE clean --all -y  
$CONDA_EXE config --prepend pkgs_dirs /opt/conda_pkgs_cache

$CONDA_EXE update -n base conda -y 
$CONDA_EXE install jupyter -y 
$CONDA_EXE install -c conda-forge jupyter_contrib_nbextensions -y 

$CONDA_EXE install $CONDA_PACKAGES -y 
pip install $PIP_PACKAGES


echo "from notebook.auth import passwd
from os import environ
print(passwd(environ['NOTEBOOK_PASSWORD']))" > pwgen.py

export NOTEBOOK_PASSWORD_HASHED=$($CONDA_PYTHON_EXE pwgen.py)

if [ ! -f /root/.jupyter/jupyter_notebook_config.py];then
    /opt/conda/bin/jupyter notebook --generate-config
fi

/opt/conda/bin/jupyter notebook --notebook-dir=\'$NOTEBOOK_DIR\' --ip=\'$NOTEBOOK_IP\' --port=$NOTEBOOK_PORT --no-browser --allow-root --NotebookApp.password=\'$NOTEBOOK_PASSWORD_HASHED\'


