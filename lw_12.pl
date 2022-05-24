gcd(A, B, X):-
	A1 is A mod B,
	B1 is B mod A,
	(
		A1 == 0, !, X is B;
		B1 == 0, !, X is A;
		A > B, !, gcd(A1, B, X);
		gcd(A, B1, X)
	).	
mutuallyPrime(X, Y):- 1 is gcd(X, Y).

% 11 Найти количество делителей числа, не делящихся на 3

countDivsUp(N, N, 0):-!.
countDivsUp(N, Div, Count):-
	NextDiv is Div + 1,
	0 is N mod NextDiv, 0 =\= NextDiv mod 3, 	 
	countDivsUp(N, NextDiv, NextCount),
	Count is NextCount + 1,!;
	NextDiv is Div + 1,
	0 is N mod NextDiv, 0 is NextDiv mod 3, 	 
	countDivsUp(N, NextDiv, NextCount),
	Count is NextCount,!;
	NextDiv is Div + 1,
	0 =\= N mod NextDiv,	 
	countDivsUp(N, NextDiv, NextCount),
	Count is NextCount,!.
countDivsUp(N, Count):- countDivsUp(N, 0, Count).
%------------------------------------------------------
countDivsDown(N, Count):- countDivsDown(N, 0, 0, Count).
countDivsDown(N, N, Count, Count):-!.
countDivsDown(N, Div, Counter, Count):-
	NextDiv is Div + 1,
	NextCounter is Counter + 1,
	0 is N mod NextDiv, 0 =\= NextDiv mod 3,
	countDivsDown(N, NextDiv, NextCounter, Count),!;
	NextDiv is Div + 1,
	countDivsDown(N, NextDiv, Counter, Count),!.
