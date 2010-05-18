###############################################################
#
#                    IMITATOR II
#
#  Laboratoire Specification et Verification (ENS Cachan & CNRS, France)
#
#  Author:        Etienne Andre
#  Created:       2009/09/07
#  Last modified: 2010/05/07
#  Ocaml version: 3.11.2
###############################################################

# CONSTANTS
OCAMLIB_PATH = /usr/lib/ocaml/extlib
#APRON_PATH = /home/andre/local/lib
APRON_PATH = /import/kuehne/local/apron/lib
OUNIT_PATH = /import/kuehne/local/ounit

INCLUDE = -I $(SRC) -I $(OCAMLIB_PATH) -I $(APRON_PATH)
LIBS = str.cma unix.cma extLib.cma bigarray.cma gmp.cma apron.cma polkaMPQ.cma

# OCAML_PPL_PATH = /home/andre/Prog/local/lib/ppl
# OCAML_GMP_PATH = /home/andre/Prog/local/lib/gmp
# OCAML_GMP_PATH = /usr/lib/ocaml/gmp

SRC = src

# FILES
.PREFIXES : +.
.SUFFIXES : .cmo .cmi .ml .mli


FILES =  $(SRC)/Global.+ $(SRC)/NumConst.+ $(SRC)/LinearConstraint.+ $(SRC)/Automaton.+ $(SRC)/Pi0Lexer.+ $(SRC)/Pi0Parser.+ $(SRC)/Pi0CubeLexer.+ $(SRC)/Pi0CubeParser.+ $(SRC)/ImitatorLexer.+ $(SRC)/ImitatorParser.+ $(SRC)/ImitatorPrinter.+ $(SRC)/ProgramConverter.+ $(SRC)/Graph.+ $(SRC)/IMITATOR.+
FILESMLI = $(SRC)/Global.+ $(SRC)/NumConst.+ $(SRC)/LinearConstraint.+ $(SRC)/Automaton.+ $(SRC)/ParsingStructure.+ $(SRC)/AbstractImitatorFile.+ $(SRC)/ImitatorPrinter.+ $(SRC)/ProgramConverter.+ $(SRC)/Graph.+ 
LEXERS = $(SRC)/Pi0Lexer.+ $(SRC)/Pi0CubeLexer.+ $(SRC)/ImitatorLexer.+
PARSERS = $(SRC)/Pi0Parser.+ $(SRC)/Pi0CubeParser.+ $(SRC)/ImitatorParser.+

TARGET = bin/IMITATOR

all: compil

compil: header parser $(FILES:+=cmo)
	@ echo [LINK] $(TARGET)
	@ ocamlc -o $(TARGET) $(INCLUDE) $(LIBS) $(FILES:+=cmo)

header: $(FILESMLI:+=cmi)

parser: $(PARSERS:+=ml) $(LEXERS:+=ml) header $(PARSERS:+=cmi)
	
$(SRC)/%.cmo: $(SRC)/%.ml
	@ echo [OCAMLC] $<
	@ ocamlc -c $(INCLUDE) $<	
	
$(SRC)/%.cmi: $(SRC)/%.mli
	@ echo [OCAMLC] $<
	@ ocamlc -c $(INCLUDE) $<

$(SRC)/%.cmi: $(SRC)/%.mly
	@ echo [YACC] $<
	@ ocamlyacc $<
	@ echo [OCAMLC] $(SRC)/$*.mli
	@ ocamlc -c $(INCLUDE) $(SRC)/$*.mli

$(SRC)/%.ml: $(SRC)/%.mly 
	@ echo [YACC] $<
	@ ocamlyacc $<
	
$(SRC)/%.ml: $(SRC)/%.mll 
	@ echo [LEX] $<
	@ ocamllex $< 
	 


test: compil 
	cd test; make unit

exe:

##### GATES #####

# 	./IMITATOR Examples/Gates/NorGate.imi -mode reachability -with-parametric-log

##### TESTS #####

# 	./IMITATOR Examples/exCTL.imi Examples/exCTL.pi0


##### CASE STUDIES : HARDWARE #####

# 	./IMITATOR Examples/AndOr/AndOr.imi -mode reachability -debug low
# 	./IMITATOR Examples/AndOr/AndOr.imi Examples/AndOr/AndOr.pi0
# 	./IMITATOR Examples/AndOr/AndOr.imi Examples/AndOr/AndOr.v0 -mode cover

# 	./IMITATOR Examples/Flipflop/flipflop.imi -mode reachability
# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.pi0
# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.v0 -mode cover -log-prefix Examples/Flipflop/carto_d3_d4/carto_d3_d4
# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.v0 -mode cover -log-prefix Examples/Flipflop/carto_d3_d4_timeafterCK/carto_d3_d4_timeafterCK
# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.v0 -mode cover -log-prefix Examples/Flipflop/test/test
# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.v0 -mode random1000  -log-prefix Examples/Flipflop/test2/test
# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.v0 -mode cover
# 	# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.v0 -mode cover -no-log -time-limit 1 -post-limit 25
# 	./IMITATOR Examples/Flipflop/flipflop.imi Examples/Flipflop/flipflop.v0 -mode cover -no-log -no-dot

# 	./IMITATOR Examples/Flipflop/flipflop_CC.imi -mode reachability -with-parametric-log
# 	./IMITATOR Examples/Flipflop/flipflop_CC.imi Examples/Flipflop/flipflop_CC.pi0
# 	./IMITATOR Examples/Flipflop/flipflop_CC.imi Examples/Flipflop/flipflop_CC.v0 -mode cover -log-prefix Examples/Flipflop/carto1/carto

# 	./IMITATOR Examples/Flipflop-inverse/flipflop-inverse.imi -mode reachability

# 	./IMITATOR Examples/Latch/latchValmem.imi -mode reachability
# 	./IMITATOR Examples/Latch/latchValmem.imi Examples/Latch/latchValmem.pi0 

# 	./IMITATOR Examples/SRlatch/SRlatch.imi -mode reachability
# 	./IMITATOR Examples/SRlatch/SRlatch.imi Examples/SRlatch/SRlatch.pi0
# 	./IMITATOR Examples/SRlatch/SRlatch.imi Examples/SRlatch/SRlatch.v0 -mode cover

# 	./IMITATOR Examples/SRlatch/SRlatch_delais_fixes.imi -mode reachability
# 	./IMITATOR Examples/SRlatch/SRlatch_delais_fixes.imi Examples/SRlatch/SRlatch_delais_fixes.pi0
# 	./IMITATOR Examples/SRlatch/SRlatch_delais_fixes.imi Examples/SRlatch/SRlatch_delais_fixes.v0 -mode cover -no-dot

# 	./IMITATOR Examples/SRlatch/sr_latch.hy -mode reachability
# 	./IMITATOR Examples/SRlatch/sr_latch_nand.hy -mode reachability


##### CASE STUDIES : PROTOCOLS #####

# 	./IMITATOR Examples/BangOlufsen.imi -mode reachability
# 	./IMITATOR Examples/BangOlufsen.imi Examples/BangOlufsen.pi0 -post-limit 25 -timed

# 	./IMITATOR Examples/BangOlufsen/BangOlufsen2.imi -mode reachability -no-dot
# 	./IMITATOR Examples/BangOlufsen/BangOlufsen2.imi -mode reachability -no-dot -post-limit 30 -debug low

# 	./IMITATOR Examples/BRP/brp.imi -mode reachability
# 	./IMITATOR Examples/BRP/brp.imi Examples/BRP/brp.pi0
# 	./IMITATOR Examples/BRP/brp.imi Examples/BRP/brp.pi0 -post-limit 10 -time-limit 2
# 	./IMITATOR Examples/BRP/brp.imi Examples/BRP/brp.v0 -mode cover

# 	./IMITATOR Examples/RCP/RCP.imi -mode reachability
# 	./IMITATOR Examples/RCP/RCP.imi Examples/RCP/RCP.pi0 -no-dot -no-log
# 	./IMITATOR Examples/RCP/RCP.imi Examples/RCP/RCP.v0 -mode cover -no-dot -log-prefix Examples/RCP/temp/RCP -no-log

# 	./IMITATOR Examples/RCP/RCP_bounded.imi Examples/RCP/RCP_bounded.pi0 -no-dot -no-log

# 	./IMITATOR Examples/CSMACD/csmacdPrism.imi -mode reachability 
# 	./IMITATOR Examples/CSMACD/csmacdPrism.imi Examples/CSMACD/csmacdPrism.pi0 
# 	./IMITATOR Examples/CSMACD/csmacdPrism.imi Examples/CSMACD/csmacdPrism.v0 -mode cover -no-dot -no-log
# -log-prefix Examples/CSMACD/carto2/csmacdPrism 

# 	./IMITATOR Examples/CSMACD/csmacdPrism_2p.imi -mode reachability
# 	./IMITATOR Examples/CSMACD/csmacdPrism_2p.imi Examples/CSMACD/csmacdPrism_2p.pi0 
# 	./IMITATOR Examples/CSMACD/csmacdPrism_2p.imi Examples/CSMACD/csmacdPrism_2p.v0 -mode cover -log-prefix Examples/CSMACD/carto_2p/csmacdPrism_2p

# 	./IMITATOR Examples/Wlan/wlan.imi -mode reachability
# 	./IMITATOR Examples/Wlan/wlan.imi Examples/Wlan/wlan.pi0 -timed

# 	./IMITATOR Examples/Wlan/wlan_boff2.imi Examples/Wlan/wlan_boff2.pi0 -timed

	./IMITATOR Examples/Wlan/wlan2_for_im2.imi -mode reachability -debug low
# 	./IMITATOR Examples/Wlan/wlan2_for_im2.imi Examples/Wlan/wlan2_for_im2.pi0 -timed

##### CASE STUDIES : VALMEM #####

# 	./IMITATOR Examples/Valmem/spsmall.imi -mode reachability -timed -time-limit 60
# 	./IMITATOR Examples/Valmem/spsmall.imi Examples/Valmem/spsmall.pi0
# -debug medium -inclusion -post-limit 2 -sync-auto-detect
# 	./IMITATOR Examples/Valmem/spsmall.imi Examples/Valmem/spsmall.v0 -mode cover -no-dot -no-log

# 	./IMITATOR Examples/Valmem/spsmall_obs.imi -mode reachability -with-parametric-log
# 	./IMITATOR Examples/Valmem/spsmall_obs.imi Examples/Valmem/spsmall.pi0
# 	./IMITATOR Examples/Valmem/spsmall_obs.imi Examples/Valmem/spsmall.v0 -mode cover -log-prefix Examples/Valmem/carto/spsmall

# 	./IMITATOR Examples/Valmem/LSV.imi Examples/Valmem/delais1_hy.pi0 -timed
# 	./IMITATOR Examples/Valmem/sp_1x2_md_no.imi Examples/Valmem/sp_1x2_md_no.pi0 -debug total

##### CASE STUDIES : SIMOP #####
# 	./IMITATOR Examples/SIMOP/simop.imi -mode reachability


##### ANCIEN #####

# 	./IMITATOR Examples/test.imi Examples/test.pi0 -debug total
# 	./IMITATOR Examples/testBoucle.imi Examples/vide.pi0 -debug high
# 	./IMITATOR Examples/testPost.imi Examples/testPost.pi0 -debug total
# 	./IMITATOR Examples/testPost.imi Examples/testPost.pi0 -debug total -sync-auto-detect
# 	./IMITATOR Examples/testPost2.imi Examples/vide.pi0 -debug nodebug -timed

# 	./IMITATOR Examples/flipflop-inverse.imi Examples/flipflop.pi0cube -mode cover -debug low
# 	./IMITATOR Examples/flipflop-inverse.imi Examples/flipflop.pi0 -debug total
# 	./IMITATOR Examples/flipflop-inverse.imi Examples/flipflop.pi0


count:
	make clean
	python lineCounter.py


clean:
	make rmtpf
	make rmuseless
	rm -rf $(LEXERS:+=ml) $(PARSERS:+=mli) $(PARSERS:+=ml)
	rm -rf $(TARGET)
	cd test; make clean


rmtpf:
	rm -rf *~


rmuseless:
	rm -rf $(FILES:+=cmo) $(FILES:+=cmi) $(FILES:+=o)
	rm -rf $(FILESMLI:+=cmi)

# ppl:
# 	ocamlc -I $(OCAML_GMP_PATH) -I $(OCAML_PPL_PATH) -c test1.ml
# # 	ocamlc -I +gmp libmlgmp.a -I $(OCAML_PPL_PATH) -o TEST ppl2.cmo
# 	ocamlc -o TEST -I $(OCAML_GMP_PATH) -I $(OCAML_PPL_PATH)  gmp.cma ppl_ocaml.cma test1.cmo
# # 	ocamlc -o TEST -I +gmp -I $(OCAML_PPL_PATH) -cclib -lppl -cclib -lm -cclib -lgmpxx -cclib -lgmp   ppl2.cmo
# 	./TEST
# #	-I $(OCAML_GMP_PATH)
# # libppl_ocaml.a gmp.cma nums.cma str.cma unix.cma  libmlgmp.a libppl_ocaml.a gmp.cma 
# 
# ppl2:
# 	OCAMLRUNPARAM='l=1M' ocamlc -o test2.cmo -c -I $(OCAML_GMP_PATH) -I $(OCAML_PPL_PATH)  gmp.cma ppl_ocaml.cma -ccopt -g test2.ml
# 	OCAMLRUNPARAM='l=1M' ocamlc -o TEST2 -I $(OCAML_GMP_PATH) -I $(OCAML_PPL_PATH)  gmp.cma ppl_ocaml.cma -ccopt -g test2.cmo

