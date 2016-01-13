IMI_FILES=$(shell find . -name '*.imi' -a -type f)
VO_FILES=$(patsubst %.imi,%.v0, $(IMI_FILES))
VANILLA_LOGS=$(patsubst %.imi,%.vanilla_log, $(IMI_FILES))
Z3_LOGS=$(patsubst %.imi,%.z3_log, $(IMI_FILES))
ALL_LOGS=$(sort $(VANILLA_LOGS) $(Z3_LOGS))
ULIMIT=ulimit -v 6000000 -t 36000

all: $(ALL_LOGS)

%.z3_log: %.imi %.v0
	$(ULIMIT) /usr/bin/time ../imitator_z3 -no-random -mode cover $*.imi $*.v0 > $@ 2>&1

%.vanilla_log: %.imi %.v0
	$(ULIMIT) /usr/bin/time ../imitator_vanilla -no-random -mode cover $*.imi $*.v0 > $@ 2>&1

.PHONY: all
