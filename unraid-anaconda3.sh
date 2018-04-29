#!/bin/sh -v
export CONDA_EXE='/opt/conda/bin/conda'
$CONDA_EXE clean --all -y  
$CONDA_EXE config --prepend pkgs_dirs /opt/conda_cache

$CONDA_EXE update -n base conda -y 
$CONDA_EXE install jupyter -y 
$CONDA_EXE install -c conda-forge jupyter_contrib_nbextensions -y 

$CONDA_EXE install $CONDAPACKAGES -y 

export NOTEBOOKPASSWORDHASHED=$($CONDA_PYTHON_EXE -c "from notebook.auth import passwd
from os import environ
print(passwd(environ['NOTEBOOKPASSWORD']))")

/opt/conda/bin/jupyter notebook --notebook-dir=\'$JUPYTER_SERVER_ROOT\' --ip=\'$NOTEBOOKIP\' --port=$NOTEBOOKPORT --no-browser --allow-root --NotebookApp.password=\'$NOTEBOOKPASSWORDHASHED\'


