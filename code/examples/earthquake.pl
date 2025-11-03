0.2::earthquake.
0.1::burglary.

0.5::hears_alarm(mary).
0.4::hears_alarm(john).

alarm :- earthquake.
alarm :- burglary.

calls(X):- alarm, hears_alarm(X).