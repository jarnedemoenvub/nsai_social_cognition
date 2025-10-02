0.2::earthquake.
0.1::burglary.
0.5::mary_hears_alarm.

alarm :- earthquake.
alarm :- burglary.
calls_mary :- alarm, mary_hears_alarm.