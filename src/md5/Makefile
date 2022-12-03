.PHONY: tclstubs-nimble

all: tclstubs-nimble libaocmd5.so

libaocmd5.so: aocmd5.nim
	nim c --app:lib -d:release -o:$@ $<

tclstubs-nimble:
	nimble install -y https://github.com/mpcjanssen/tclstubs-nimble


clean:
	rm libaocmd5.so
