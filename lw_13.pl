/* 11

*/
abs1(X, AbsX):-
    X >= 0, AbsX is X,!;
    X < 0, AbsX is -X,!.


sumOfAbs([], Res):- Res is 0,!.
sumOfAbs(List, Res):- sumOfAbs(List, 0, 0, Res),!.
sumOfAbs([], Count, Sum, Res):- Res is Sum / Count.
sumOfAbs([Head|Tail], Count, Sum, Res):-
    NextCount is Count + 1,
    abs(Head, AbsHead),
    NextSum is Sum + AbsHead,
    sumOfAbs(Tail, NextCount, NextSum, Res).
