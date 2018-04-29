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

$CONDA_EXE install $CONDAPACKAGES -y 


echo "from notebook.auth import passwd
from os import environ
print(passwd(environ['NOTEBOOKPASSWORD']))" >> pwgen.py

export NOTEBOOKPASSWORDHASHED=$($CONDA_PYTHON_EXE pwgen.py)

/opt/conda/bin/jupyter notebook --notebook-dir=\'$JUPYTER_SERVER_ROOT\' --ip=\'$NOTEBOOKIP\' --port=$NOTEBOOKPORT --no-browser --allow-root --NotebookApp.password=\'$NOTEBOOKPASSWORDHASHED\'


