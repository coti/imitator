IMI_FILES=$(shell find . -name '*.imi' -a -type f)
VO_FILES=$(patsubst %.imi,%.v0, $(IMI_FILES))
VANILLA_LOGS=$(patsubst %.imi,%.vanilla_log, $(IMI_FILES))
Z3_LOGS=$(patsubst %.imi,%.z3_log, $(IMI_FILES))
ALL_LOGS=$(sort $(VANILLA_LOGS) $(Z3_LOGS))

DONE_LOGS=$(sort $(shell find . -name '*_log' -a -type f))
SMALL_LOGS=$(sort $(shell find . -name '*_log' -a -type f -a -size -10M))

SUMMARIES=timings.dat log_lengths.dat

ULIMIT=ulimit -v 6000000 && ulimit -t 36000

summaries: $(SUMMARIES)

clean:
	-rm $(SUMMARIES)

timings.dat: $(DONE_LOGS)
	grep elapsed $(DONE_LOGS) > $@

log_lengths.dat: $(DONE_LOGS)
	wc -l $(DONE_LOGS) > $@

timings.tar.xz: $(SUMMARIES) $(SMALL_LOGS)
	tar cvfJ $@ $(SUMMARIES) $(SMALL_LOGS)

logs: $(ALL_LOGS)

%.z3_log: %.imi %.v0
	$(ULIMIT) && /usr/bin/time ../imitator_z3 -no-random -mode cover $*.imi $*.v0 > $@ 2>&1

%.vanilla_log: %.imi %.v0
	$(ULIMIT) && /usr/bin/time ../imitator_vanilla -no-random -mode cover $*.imi $*.v0 > $@ 2>&1

.PHONY: logs summary
