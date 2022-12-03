.PHONY: all

test: day01.tcl day02.tcl day03.tcl day04.tcl day05.tcl day06.tcl day07.tcl day08.tcl day09.tcl day10.tcl day14.tcl day15.tcl all.tcl
	tclsh8.7 all.tcl


%.tcl: %.ipynb
	jupyter nbconvert --to script $<
