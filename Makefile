test: ert

ert:
	~/.cask/bin/cask exec ert-runner || cat test/sandbox/test.org && exit 1

ecukes:
	~/.cask/bin/cask exec ecukes
