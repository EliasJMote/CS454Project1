# Authors: Ryan Moeller and Elias Mote

OPAMSWITCH = .switch
OPAMDEPS = dune core base

# Override this in the environment if the system OCaml is too old for base.
OCAMLVERSION := ocaml-system

all: depends problem2
	@echo
	@echo '# The project is ready, now run:'
	@echo 'make run'
	@echo

run:
	OPAMSWITCH=${OPAMSWITCH} ./project1

depends: problem1-deps problem2-deps

problem1-deps: problem1/requirements.txt problem1/.venv27
	cd problem1 && . ./.venv27/bin/activate && pip install -r requirements.txt

problem1/.venv27:
	python2.7 -m pip install virtualenv || sudo python2.7 -m pip install virtualenv
	python2.7 -m virtualenv problem1/.venv27

problem2-deps: ${OPAMSWITCH}
	opam install -y --switch=${OPAMSWITCH} ${OPAMDEPS}
	@echo
	@echo '# NOTE: Dependencies have been installed in a new opam switch.'
	@echo

${OPAMSWITCH}:
	opam switch create ${OPAMSWITCH} ${OCAMLVERSION}

problem2: problem2/lib/dune problem2/lib/dfa.ml problem2/bin/dune problem2/bin/main.ml
	eval `opam env --switch=${OPAMSWITCH} --set-switch` && cd problem2 && dune build bin/main.exe

# TODO: clean target

.PHONY: all run depends problem1-deps problem2-deps problem2
