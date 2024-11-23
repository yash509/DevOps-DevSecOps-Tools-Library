# Checkov Installation Commands
deactivate --commmand to exit from the python virual env
source ~/py_envs/bin/activate --cmd to activate the python virtual env

apt install python3-pip
python3 -m venv ~/py_envs 
source ~/py_envs/bin/activate
python3 -m pip install checkov
checkov -d . ---cmd to test the checkov
