# -*- coding: utf-8; tab-width: 4 -*-
# Author: Yasutaka SHINDOH

INPUT_1	:= 京都市:35.0061,135.76095 大阪市:34.6784,135.49515 那覇市:24.4728048,124.204993
INPUT_2	:= 35.0061,135.76095 34.6784,135.49515 24.4728048,124.204993

check:
	# first check
	$(shell which ruby) -Ku earth_surface_distance.rb $(INPUT_1)
	# second check
	$(shell which ruby) -Ku earth_surface_distance.rb $(INPUT_2)

clean:
	find . -name '*~' -print0 | xargs -0 rm -f

.PHONY: all clean
