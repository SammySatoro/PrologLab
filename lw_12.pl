% Найти количество делителей числа, не делящихся на 3

countDivs(N, N, 0):-!.
countDivs(N, Div, Count):-
	NextDiv is Div + 1,
	0 is N mod NextDiv, 0 =\= NextDiv mod 3, 	 
	countDivs(N, NextDiv, NextCount),
	Count is NextCount + 1,!;
	NextDiv is Div + 1,
	0 is N mod NextDiv, 0 is NextDiv mod 3, 	 
	countDivs(N, NextDiv, NextCount),
	Count is NextCount,!;
	NextDiv is Div + 1,
	0 =\= N mod NextDiv,	 
	countDivs(N, NextDiv, NextCount),
	Count is NextCount,!.
countDivs(N, Count):- countDivs(N, 0, Count).
