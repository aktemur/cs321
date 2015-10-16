FSC=fsharpc --nologo
FSI=fsharpi
FSYACC=fsyacc
FSLEX=fslex
HW=exp

all: FSharp.PowerPack.dll $(HW).dll $(HW)-parse.dll $(HW)-lex.dll $(HW)-examples.fs
	$(FSI) -r FSharp.PowerPack.dll -r $(HW).dll -r $(HW)-parse.dll -r $(HW)-lex.dll $(HW)-examples.fs

compile: FSharp.PowerPack.dll $(HW).dll $(HW)-parse.dll $(HW)-lex.dll $(HW)-examples.fs

###################################
ifneq "$(wildcard FSharp.PowerPack.dll)" "FSharp.PowerPack.dll"
FSharp.PowerPack.dll:
	ln -s ~/Programs/FSharpPowerPack-4.0.0.0/bin/FSharp.PowerPack.dll
endif

#########################################################
$(HW)-examples.dll: FSharp.PowerPack.dll $(HW).dll $(HW)-parse.dll $(HW)-lex.dll $(HW)-examples.fs 
	$(FSC) -r FSharp.PowerPack.dll -r $(HW).dll -r $(HW)-parse.dll -r $(HW)-lex.dll -a $(HW)-examples.fs
$(HW).dll: $(HW).fs
	$(FSC) -a $(HW).fs
$(HW)-parse.dll: FSharp.PowerPack.dll $(HW).dll $(HW)-parse.fs
	$(FSC) -r $(HW).dll -r FSharp.PowerPack.dll -a $(HW)-parse.fs
$(HW)-parse.fs: $(HW)-parse.fsy
	$(FSYACC) --module Parser $(HW)-parse.fsy
$(HW)-lex.dll: $(HW)-parse.dll $(HW)-lex.fs
	$(FSC) -r $(HW)-parse.dll -a $(HW)-lex.fs
$(HW)-lex.fs: $(HW)-lex.fsl
	$(FSLEX) --unicode $(HW)-lex.fsl
#########################################################

clean: 
	rm -f $(HW)*.dll $(HW)-parse.fs $(HW)-lex.fs *.fsi

commit:  FSharp.PowerPack.dll $(HW).dll $(HW)-parse.dll $(HW)-lex.dll $(HW)-examples.fs
	echo svn commit -m "" $(HW).fs $(HW)-parse.fsy $(HW)-lex.fsl $(HW)-examples.fs; \
	svn commit -m "" $(HW).fs $(HW)-parse.fsy $(HW)-lex.fsl $(HW)-examples.fs

