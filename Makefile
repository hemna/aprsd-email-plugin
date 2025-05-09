REQUIREMENTS_TXT ?= requirements.txt requirements-dev.txt
.DEFAULT_GOAL := help

.PHONY: help dev test

include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2022.07.20/Makefile.venv"
	echo "147b164f0cbbbe4a2740dcca6c9adb6e9d8d15b895be3998697aa6a821a277d8 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv

help:	# Help for the Makefile
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

dev: venv  ## Create the virtualenv with all the requirements installed

docs: build
	cp README.rst docs/readme.rst
	cp Changelog docs/changelog.rst
	tox -edocs

clean: clean-build clean-pyc clean-test clean-pyenv ## remove all build, test, coverage and Python artifacts

clean-pyenv:
	rm -rf .venv
	rm Makefile.venv

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

coverage: ## check code coverage quickly with the default Python
	coverage run --source aprsd_email_plugin setup.py test
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

test: dev  ## Run all the tox tests
	tox -p all

build: test  ## Make the build artifact prior to doing an upload
	$(VENV)/python3 setup.py sdist bdist_wheel
	$(VENV)/twine check dist/*

upload: build  ## Upload a new version of the plugin
	$(VENV)/twine upload dist/*

check: dev ## Code format check with tox and pep8
	tox -epep8

fix: dev ## fixes code formatting with gray
	tox -efmt

update-requirements: dev  ## Update the requirements.txt and dev-requirements.txt files
	rm requirements.txt
	rm requirements-dev.txt
	touch requirements.txt
	touch requirements-dev.txt
	$(VENV)/pip-compile --resolver backtracking --annotation-style=line requirements.in
	$(VENV)/pip-compile --resolver backtracking --annotation-style=line requirements-dev.in
