.PHONY: all
all:
	cabal build
	mv ./dist-newstyle/build/x86_64-linux/ghc-9.12.2/dailyNotes-0.1.0.0/x/dailyNotes/build/dailyNotes/dailyNotes dn

