.PHONY: install
install: pip
	pip install .[all]

.PHONY: dev
dev: pip
	pip install --upgrade -e .[dev]
	pre-commit install -f --install-hooks

.PHONY: pip
pip:
	pip install "pip>=7.1.2"

.PHONY: format
format:
	pre-commit autoupdate
	pre-commit run --allow-unstaged-config --all-files

.PHONY: docs
docs:
	sphinx-build -b html . ./docs
	pushd ./docs
	cp ./README.html ./index.html
	zip -r ./docs.zip ./*
	popd

.PHONY: test
test:
	pytest --strict -s tests

.PHONY: clean
clean:
	rm -rf ./docs
	rm -rf ./dist
	rm -rf ./build
	rm -rf ./tests/dest
	find . -name '*.pyc' -delete
	find . -name '__pycache__' -delete

.PHONY: build
build: clean
	python setup.py sdist bdist_wheel

.PHONY: upload
upload: build
	pip install --upgrade twine
	twine upload dist/*