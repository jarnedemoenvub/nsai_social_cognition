nn(baseline_dpl, [X], Y, [0, 1, 2, 3, 4, 5, 6, 7]) :: get_baseline_pred(X, Y).

final_emo(Features, FindingEmo):-
    get_baseline_pred(Features, FindingEmo).
