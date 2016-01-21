.PHONY: install
BLAS_VERSION=3.6.0

all: install

.venv-clean: .venv-clean/src/BLAS
	virtualenv -p $(shell which python2.7) $@
	BLAS_SRC=.venv-clean/src/BLAS .venv-clean/bin/pip install -r requirements.txt

venv: .venv-clean
	.venv-clean/bin/virtualenv-clone $< $@

.venv-clean/src/BLAS:
	mkdir -p .venv-clean/src
	(cd .venv-clean/src ; \
         curl http://www.netlib.org/blas/blas-$(BLAS_VERSION).tgz | tar zxfv - ; \
         ln -s BLAS-$(BLAS_VERSION) BLAS)

install:
	make -C .. install_testsuite

clean:
	rm -rf .venv-clean/ venv/
