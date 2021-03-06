#
# Copyright (C) 1996-2001, Thomas Andrews
#
# $Id: score.tcl 367 2010-03-10 16:46:34Z thomasoa $
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#

namespace eval score {
    variable words
    set words(doubled) 1
    set words(undoubled) 0
    set words(redoubled) 2
    set words(vul) 1
    set words(nonvul) 0
    set words(0) 0
    set words(1) 1
    set words(2) 2
    set words() 0
    variable IMPTable {
        10 40 80 120 160
        210 260 310 360 420
	490 590 740 890 1090
        1290 1490 1740 1990 2240
        2490 2990 3490 3990
    }
        

    #
    # - contract should be something like:
    #     2 spades
    #     6 notrump doubled
    #
    # - vulword should be one of "vul" or "nonvul"
    #
    # - tricks should be the number of tricks taken
    #
    # So you might say:
    #
    #     % score {6 spades doubled} vul 12
    #     1660
    proc score {contract vulword tricks} {
	set bid [lindex $contract 0]
	set denom [lindex $contract 1]
	set dword [lindex $contract 2]
        variable words
        set dlevel $words($dword)
	set vul $words($vulword)
	if {$tricks>=$bid+6} {
	    return [score_make $vul $denom $bid $tricks $dlevel]
	} else {
	    return [score_set $vul [expr {$bid+6-$tricks}] $dlevel]
	}
    }

    proc is_minor {suit} {
	expr {"$suit"=="clubs"||"$suit"=="diamonds"}
    }

    proc is_major {suit} {
	expr {"$suit"=="spades"||"$suit"=="hearts"}
    }

    variable downdoubled
    set downdoubled(1) [list 0 200 500 800 1100 1400 1700 2000 2300 2600 2900 3200 3500 3800]
    set downdoubled(0) [list 0 100 300 500 800 1100 1400 1700 2000 2300 2600 2900 3200 3500]

    proc score_set {vul deficit dlevel} {
	if {$dlevel==0} {
	    return [expr {-50*$deficit*($vul+1)}]
	}
	variable downdoubled
	expr {[lindex $downdoubled($vul) $deficit]*$dlevel*-1}
    }

    proc score_make {vul denom bid tricks dlevel} {

	set firstv 0

	if {[is_minor $denom]} {
	    set trickv 20
	} elseif {[is_major $denom]} {
	    set trickv 30
	} else {    
	    set trickv 30
	    set firstv 10
	}

	set base 0

	if {$dlevel>0} {
	    set trickv [expr {$dlevel*2*$trickv}]
	    set firstv [expr {$dlevel*2*$firstv}]
	    set overtrickv [expr {100*$dlevel*($vul+1)}]
	    incr base [expr {50*$dlevel}]
	} else {
	    set overtrickv $trickv
	}

	set bidtricks [expr 6+$bid]
	set overtricks [expr {$tricks-$bidtricks}]

	set contractvalue [expr {$trickv*$bid+$firstv}]

	if {$contractvalue>=100} {
	    # game!
	    incr base [expr {$vul? 500 : 300}]
	} else {
	    # partscore
	    incr base 50
	}

	incr base $contractvalue

	incr base [expr {$overtricks*$overtrickv}]

	if {12==$bidtricks} {
	    incr base [expr {$vul?750:500}]
	}
	if {13==$bidtricks} {
	    incr base [expr {$vul?1500:1000}]
	}

	set base
    }
    namespace export score

    variable scoredata
    proc initdata {} {
	variable scoredata
	foreach {result score} {
	    {1 clubs vul} {-700 -600 -500 -400 -300 -200 -100 70 90 110 130 150 170 190}
	    {1 clubs nonvul} {-350 -300 -250 -200 -150 -100 -50 70 90 110 130 150 170 190}
	    {1 clubs doubled vul} {-2000 -1700 -1400 -1100 -800 -500 -200 140 340 540 740 940 1140 1340}
	    {1 clubs doubled nonvul} {-1700 -1400 -1100 -800 -500 -300 -100 140 240 340 440 540 640 740}
	    {1 clubs redoubled vul} {-4000 -3400 -2800 -2200 -1600 -1000 -400 230 630 1030 1430 1830 2230 2630}
	    {1 clubs redoubled nonvul} {-3400 -2800 -2200 -1600 -1000 -600 -200 230 430 630 830 1030 1230 1430}
	    {1 diamonds vul} {-700 -600 -500 -400 -300 -200 -100 70 90 110 130 150 170 190}
	    {1 diamonds nonvul} {-350 -300 -250 -200 -150 -100 -50 70 90 110 130 150 170 190}
	    {1 diamonds doubled vul} {-2000 -1700 -1400 -1100 -800 -500 -200 140 340 540 740 940 1140 1340}
	    {1 diamonds doubled nonvul} {-1700 -1400 -1100 -800 -500 -300 -100 140 240 340 440 540 640 740}
	    {1 diamonds redoubled vul} {-4000 -3400 -2800 -2200 -1600 -1000 -400 230 630 1030 1430 1830 2230 2630}
	    {1 diamonds redoubled nonvul} {-3400 -2800 -2200 -1600 -1000 -600 -200 230 430 630 830 1030 1230 1430}
	    {1 hearts vul} {-700 -600 -500 -400 -300 -200 -100 80 110 140 170 200 230 260}
	    {1 hearts nonvul} {-350 -300 -250 -200 -150 -100 -50 80 110 140 170 200 230 260}
	    {1 hearts doubled vul} {-2000 -1700 -1400 -1100 -800 -500 -200 160 360 560 760 960 1160 1360}
	    {1 hearts doubled nonvul} {-1700 -1400 -1100 -800 -500 -300 -100 160 260 360 460 560 660 760}
	    {1 hearts redoubled vul} {-4000 -3400 -2800 -2200 -1600 -1000 -400 720 1120 1520 1920 2320 2720 3120}
	    {1 hearts redoubled nonvul} {-3400 -2800 -2200 -1600 -1000 -600 -200 520 720 920 1120 1320 1520 1720}
	    {1 spades vul} {-700 -600 -500 -400 -300 -200 -100 80 110 140 170 200 230 260}
	    {1 spades nonvul} {-350 -300 -250 -200 -150 -100 -50 80 110 140 170 200 230 260}
	    {1 spades doubled vul} {-2000 -1700 -1400 -1100 -800 -500 -200 160 360 560 760 960 1160 1360}
	    {1 spades doubled nonvul} {-1700 -1400 -1100 -800 -500 -300 -100 160 260 360 460 560 660 760}
	    {1 spades redoubled vul} {-4000 -3400 -2800 -2200 -1600 -1000 -400 720 1120 1520 1920 2320 2720 3120}
	    {1 spades redoubled nonvul} {-3400 -2800 -2200 -1600 -1000 -600 -200 520 720 920 1120 1320 1520 1720}
	    {1 notrump vul} {-700 -600 -500 -400 -300 -200 -100 90 120 150 180 210 240 270}
	    {1 notrump nonvul} {-350 -300 -250 -200 -150 -100 -50 90 120 150 180 210 240 270}
	    {1 notrump doubled vul} {-2000 -1700 -1400 -1100 -800 -500 -200 180 380 580 780 980 1180 1380}
	    {1 notrump doubled nonvul} {-1700 -1400 -1100 -800 -500 -300 -100 180 280 380 480 580 680 780}
	    {1 notrump redoubled vul} {-4000 -3400 -2800 -2200 -1600 -1000 -400 760 1160 1560 1960 2360 2760 3160}
	    {1 notrump redoubled nonvul} {-3400 -2800 -2200 -1600 -1000 -600 -200 560 760 960 1160 1360 1560 1760}
	    {2 clubs vul} {-800 -700 -600 -500 -400 -300 -200 -100 90 110 130 150 170 190}
	    {2 clubs nonvul} {-400 -350 -300 -250 -200 -150 -100 -50 90 110 130 150 170 190}
	    {2 clubs doubled vul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -200 180 380 580 780 980 1180}
	    {2 clubs doubled nonvul} {-2000 -1700 -1400 -1100 -800 -500 -300 -100 180 280 380 480 580 680}
	    {2 clubs redoubled vul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 760 1160 1560 1960 2360 2760}
	    {2 clubs redoubled nonvul} {-4000 -3400 -2800 -2200 -1600 -1000 -600 -200 560 760 960 1160 1360 1560}
	    {2 diamonds vul} {-800 -700 -600 -500 -400 -300 -200 -100 90 110 130 150 170 190}
	    {2 diamonds nonvul} {-400 -350 -300 -250 -200 -150 -100 -50 90 110 130 150 170 190}
	    {2 diamonds doubled vul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -200 180 380 580 780 980 1180}
	    {2 diamonds doubled nonvul} {-2000 -1700 -1400 -1100 -800 -500 -300 -100 180 280 380 480 580 680}
	    {2 diamonds redoubled vul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 760 1160 1560 1960 2360 2760}
	    {2 diamonds redoubled nonvul} {-4000 -3400 -2800 -2200 -1600 -1000 -600 -200 560 760 960 1160 1360 1560}
	    {2 hearts vul} {-800 -700 -600 -500 -400 -300 -200 -100 110 140 170 200 230 260}
	    {2 hearts nonvul} {-400 -350 -300 -250 -200 -150 -100 -50 110 140 170 200 230 260}
	    {2 hearts doubled vul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -200 670 870 1070 1270 1470 1670}
	    {2 hearts doubled nonvul} {-2000 -1700 -1400 -1100 -800 -500 -300 -100 470 570 670 770 870 970}
	    {2 hearts redoubled vul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 840 1240 1640 2040 2440 2840}
	    {2 hearts redoubled nonvul} {-4000 -3400 -2800 -2200 -1600 -1000 -600 -200 640 840 1040 1240 1440 1640}
	    {2 spades vul} {-800 -700 -600 -500 -400 -300 -200 -100 110 140 170 200 230 260}
	    {2 spades nonvul} {-400 -350 -300 -250 -200 -150 -100 -50 110 140 170 200 230 260}
	    {2 spades doubled vul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -200 670 870 1070 1270 1470 1670}
	    {2 spades doubled nonvul} {-2000 -1700 -1400 -1100 -800 -500 -300 -100 470 570 670 770 870 970}
	    {2 spades redoubled vul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 840 1240 1640 2040 2440 2840}
	    {2 spades redoubled nonvul} {-4000 -3400 -2800 -2200 -1600 -1000 -600 -200 640 840 1040 1240 1440 1640}
	    {2 notrump vul} {-800 -700 -600 -500 -400 -300 -200 -100 120 150 180 210 240 270}
	    {2 notrump nonvul} {-400 -350 -300 -250 -200 -150 -100 -50 120 150 180 210 240 270}
	    {2 notrump doubled vul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -200 690 890 1090 1290 1490 1690}
	    {2 notrump doubled nonvul} {-2000 -1700 -1400 -1100 -800 -500 -300 -100 490 590 690 790 890 990}
	    {2 notrump redoubled vul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 880 1280 1680 2080 2480 2880}
	    {2 notrump redoubled nonvul} {-4000 -3400 -2800 -2200 -1600 -1000 -600 -200 680 880 1080 1280 1480 1680}
	    {3 clubs vul} {-900 -800 -700 -600 -500 -400 -300 -200 -100 110 130 150 170 190}
	    {3 clubs nonvul} {-450 -400 -350 -300 -250 -200 -150 -100 -50 110 130 150 170 190}
	    {3 clubs doubled vul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 670 870 1070 1270 1470}
	    {3 clubs doubled nonvul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 470 570 670 770 870}
	    {3 clubs redoubled vul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 840 1240 1640 2040 2440}
	    {3 clubs redoubled nonvul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 640 840 1040 1240 1440}
	    {3 diamonds vul} {-900 -800 -700 -600 -500 -400 -300 -200 -100 110 130 150 170 190}
	    {3 diamonds nonvul} {-450 -400 -350 -300 -250 -200 -150 -100 -50 110 130 150 170 190}
	    {3 diamonds doubled vul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 670 870 1070 1270 1470}
	    {3 diamonds doubled nonvul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 470 570 670 770 870}
	    {3 diamonds redoubled vul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 840 1240 1640 2040 2440}
	    {3 diamonds redoubled nonvul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 640 840 1040 1240 1440}
	    {3 hearts vul} {-900 -800 -700 -600 -500 -400 -300 -200 -100 140 170 200 230 260}
	    {3 hearts nonvul} {-450 -400 -350 -300 -250 -200 -150 -100 -50 140 170 200 230 260}
	    {3 hearts doubled vul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 730 930 1130 1330 1530}
	    {3 hearts doubled nonvul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 530 630 730 830 930}
	    {3 hearts redoubled vul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 960 1360 1760 2160 2560}
	    {3 hearts redoubled nonvul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 760 960 1160 1360 1560}
	    {3 spades vul} {-900 -800 -700 -600 -500 -400 -300 -200 -100 140 170 200 230 260}
	    {3 spades nonvul} {-450 -400 -350 -300 -250 -200 -150 -100 -50 140 170 200 230 260}
	    {3 spades doubled vul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 730 930 1130 1330 1530}
	    {3 spades doubled nonvul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 530 630 730 830 930}
	    {3 spades redoubled vul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 960 1360 1760 2160 2560}
	    {3 spades redoubled nonvul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 760 960 1160 1360 1560}
	    {3 notrump vul} {-900 -800 -700 -600 -500 -400 -300 -200 -100 600 630 660 690 720}
	    {3 notrump nonvul} {-450 -400 -350 -300 -250 -200 -150 -100 -50 400 430 460 490 520}
	    {3 notrump doubled vul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 750 950 1150 1350 1550}
	    {3 notrump doubled nonvul} {-2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 550 650 750 850 950}
	    {3 notrump redoubled vul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1000 1400 1800 2200 2600}
	    {3 notrump redoubled nonvul} {-4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 800 1000 1200 1400 1600}
	    {4 clubs vul} {-1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 130 150 170 190}
	    {4 clubs nonvul} {-500 -450 -400 -350 -300 -250 -200 -150 -100 -50 130 150 170 190}
	    {4 clubs doubled vul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 710 910 1110 1310}
	    {4 clubs doubled nonvul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 510 610 710 810}
	    {4 clubs redoubled vul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 920 1320 1720 2120}
	    {4 clubs redoubled nonvul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 720 920 1120 1320}
	    {4 diamonds vul} {-1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 130 150 170 190}
	    {4 diamonds nonvul} {-500 -450 -400 -350 -300 -250 -200 -150 -100 -50 130 150 170 190}
	    {4 diamonds doubled vul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 710 910 1110 1310}
	    {4 diamonds doubled nonvul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 510 610 710 810}
	    {4 diamonds redoubled vul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 920 1320 1720 2120}
	    {4 diamonds redoubled nonvul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 720 920 1120 1320}
	    {4 hearts vul} {-1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 620 650 680 710}
	    {4 hearts nonvul} {-500 -450 -400 -350 -300 -250 -200 -150 -100 -50 420 450 480 510}
	    {4 hearts doubled vul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 790 990 1190 1390}
	    {4 hearts doubled nonvul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 590 690 790 890}
	    {4 hearts redoubled vul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1080 1480 1880 2280}
	    {4 hearts redoubled nonvul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 880 1080 1280 1480}
	    {4 spades vul} {-1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 620 650 680 710}
	    {4 spades nonvul} {-500 -450 -400 -350 -300 -250 -200 -150 -100 -50 420 450 480 510}
	    {4 spades doubled vul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 790 990 1190 1390}
	    {4 spades doubled nonvul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 590 690 790 890}
	    {4 spades redoubled vul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1080 1480 1880 2280}
	    {4 spades redoubled nonvul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 880 1080 1280 1480}
	    {4 notrump vul} {-1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 630 660 690 720}
	    {4 notrump nonvul} {-500 -450 -400 -350 -300 -250 -200 -150 -100 -50 430 460 490 520}
	    {4 notrump doubled vul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 810 1010 1210 1410}
	    {4 notrump doubled nonvul} {-2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 610 710 810 910}
	    {4 notrump redoubled vul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1120 1520 1920 2320}
	    {4 notrump redoubled nonvul} {-5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 920 1120 1320 1520}
	    {5 clubs vul} {-1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 600 620 640}
	    {5 clubs nonvul} {-550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 400 420 440}
	    {5 clubs doubled vul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 750 950 1150}
	    {5 clubs doubled nonvul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 550 650 750}
	    {5 clubs redoubled vul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1000 1400 1800}
	    {5 clubs redoubled nonvul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 800 1000 1200}
	    {5 diamonds vul} {-1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 600 620 640}
	    {5 diamonds nonvul} {-550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 400 420 440}
	    {5 diamonds doubled vul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 750 950 1150}
	    {5 diamonds doubled nonvul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 550 650 750}
	    {5 diamonds redoubled vul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1000 1400 1800}
	    {5 diamonds redoubled nonvul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 800 1000 1200}
	    {5 hearts vul} {-1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 650 680 710}
	    {5 hearts nonvul} {-550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 450 480 510}
	    {5 hearts doubled vul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 850 1050 1250}
	    {5 hearts doubled nonvul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 650 750 850}
	    {5 hearts redoubled vul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1200 1600 2000}
	    {5 hearts redoubled nonvul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1000 1200 1400}
	    {5 spades vul} {-1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 650 680 710}
	    {5 spades nonvul} {-550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 450 480 510}
	    {5 spades doubled vul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 850 1050 1250}
	    {5 spades doubled nonvul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 650 750 850}
	    {5 spades redoubled vul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1200 1600 2000}
	    {5 spades redoubled nonvul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1000 1200 1400}
	    {5 notrump vul} {-1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 660 690 720}
	    {5 notrump nonvul} {-550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 460 490 520}
	    {5 notrump doubled vul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 870 1070 1270}
	    {5 notrump doubled nonvul} {-2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 670 770 870}
	    {5 notrump redoubled vul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1240 1640 2040}
	    {5 notrump redoubled nonvul} {-5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1040 1240 1440}
	    {6 clubs vul} {-1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 1370 1390}
	    {6 clubs nonvul} {-600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 920 940}
	    {6 clubs doubled vul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 1540 1740}
	    {6 clubs doubled nonvul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1090 1190}
	    {6 clubs redoubled vul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1830 2230}
	    {6 clubs redoubled nonvul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1380 1580}
	    {6 diamonds vul} {-1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 1370 1390}
	    {6 diamonds nonvul} {-600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 920 940}
	    {6 diamonds doubled vul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 1540 1740}
	    {6 diamonds doubled nonvul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1090 1190}
	    {6 diamonds redoubled vul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 1830 2230}
	    {6 diamonds redoubled nonvul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1380 1580}
	    {6 hearts vul} {-1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 1430 1460}
	    {6 hearts nonvul} {-600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 980 1010}
	    {6 hearts doubled vul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 1660 1860}
	    {6 hearts doubled nonvul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1210 1310}
	    {6 hearts redoubled vul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2070 2470}
	    {6 hearts redoubled nonvul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1620 1820}
	    {6 spades vul} {-1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 1430 1460}
	    {6 spades nonvul} {-600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 980 1010}
	    {6 spades doubled vul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 1660 1860}
	    {6 spades doubled nonvul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1210 1310}
	    {6 spades redoubled vul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2070 2470}
	    {6 spades redoubled nonvul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1620 1820}
	    {6 notrump vul} {-1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 1440 1470}
	    {6 notrump nonvul} {-600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 990 1020}
	    {6 notrump doubled vul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 1680 1880}
	    {6 notrump doubled nonvul} {-3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1230 1330}
	    {6 notrump redoubled vul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2110 2510}
	    {6 notrump redoubled nonvul} {-6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1660 1860}
	    {7 clubs vul} {-1300 -1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 2140}
	    {7 clubs nonvul} {-650 -600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 1440}
	    {7 clubs doubled vul} {-3800 -3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 2330}
	    {7 clubs doubled nonvul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1630}
	    {7 clubs redoubled vul} {-7600 -7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2660}
	    {7 clubs redoubled nonvul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1960}
	    {7 diamonds vul} {-1300 -1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 2140}
	    {7 diamonds nonvul} {-650 -600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 1440}
	    {7 diamonds doubled vul} {-3800 -3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 2330}
	    {7 diamonds doubled nonvul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1630}
	    {7 diamonds redoubled vul} {-7600 -7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2660}
	    {7 diamonds redoubled nonvul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 1960}
	    {7 hearts vul} {-1300 -1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 2210}
	    {7 hearts nonvul} {-650 -600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 1510}
	    {7 hearts doubled vul} {-3800 -3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 2470}
	    {7 hearts doubled nonvul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1770}
	    {7 hearts redoubled vul} {-7600 -7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2940}
	    {7 hearts redoubled nonvul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 2240}
	    {7 spades vul} {-1300 -1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 2210}
	    {7 spades nonvul} {-650 -600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 1510}
	    {7 spades doubled vul} {-3800 -3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 2470}
	    {7 spades doubled nonvul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1770}
	    {7 spades redoubled vul} {-7600 -7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2940}
	    {7 spades redoubled nonvul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 2240}
	    {7 notrump vul} {-1300 -1200 -1100 -1000 -900 -800 -700 -600 -500 -400 -300 -200 -100 2220}
	    {7 notrump nonvul} {-650 -600 -550 -500 -450 -400 -350 -300 -250 -200 -150 -100 -50 1520}
	    {7 notrump doubled vul} {-3800 -3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -200 2490}
	    {7 notrump doubled nonvul} {-3500 -3200 -2900 -2600 -2300 -2000 -1700 -1400 -1100 -800 -500 -300 -100 1790}
	    {7 notrump redoubled vul} {-7600 -7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -400 2980}
	    {7 notrump redoubled nonvul} {-7000 -6400 -5800 -5200 -4600 -4000 -3400 -2800 -2200 -1600 -1000 -600 -200 2280}
	    
	} {
	    set scoredata($result) $score
	}
    }
    initdata
    proc fastscore {contract vul tricks} {
	variable scoredata
	lappend contract $vul
	return [lindex $scoredata($contract) $tricks]
    }

    proc IMPs {difference} {
       variable IMPTable

       set absValue [expr {abs($difference)}]
       if {$difference>0} { set sign 1 } { set sign -1 }
       set impsValue 0

       foreach tableValue $IMPTable {
          if {$tableValue>=$absValue} { break } 
          incr impsValue
       }

       return [expr {$sign*$impsValue}]
    }

}


proc score {contract vul tricks} {
    score::fastscore $contract $vul $tricks
}

proc IMPs {theirScore ourScore} {
    score::IMPs [expr {$ourScore-$theirScore}]
}
