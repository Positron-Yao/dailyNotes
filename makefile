all: dn

dn: Main.hs
	ghc $^ -o $@
