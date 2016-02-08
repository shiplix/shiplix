pip/install:
	pip --version > /dev/null 2>&1 || sudo easy_install pip

ansible/install_roles: pip/install
	pip install ansible
	sudo ansible-galaxy install -f -r requirements.yml
