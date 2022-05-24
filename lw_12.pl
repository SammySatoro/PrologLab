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

sumOfDigits(0, 0):-!.
sumOfDigits(N, Sum):-
	NextN is N div 10,
	Num is N mod 10,
	sumOfDigits(NextN, NextSum),
	Sum is NextSum + Num.

productOfDigits(0, 0):-!.
productOfDigits(N, 1):- N > 0, N < 10, !.
productOfDigits(N, Product):-
	NextN is N div 10,
	Num is N mod 10,
	productOfDigits(NextN, NextProduct),
	Product is NextProduct * Num.


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
	
% 12 Найти сумму всех делителей числа, взаимно простых с суммой цифр числа и не взаимно простых с произведением цифр числа.

sumOfDivs(N, Sum):- sumOfDivs(N, 0, 0, Sum).
sumOfDivs(N, N, Sum, Sum):-!.
sumOfDivs(N, Div, Summutor, Sum):-
	NextDiv is Div + 1,
	NextSummutor is Summutor + NextDiv,
	0 is N mod NextDiv,
	sumOfDigits(N, S), mutuallyPrime(NextDiv, S), 
	productOfDigits(N, P), \+mutuallyPrime(NextDiv, P),
	sumOfDivs(N, NextDiv, NextSummutor, Sum), !;
	NextDiv is Div + 1,
	sumOfDivs(N, NextDiv, Summutor, Sum), !.

/* 13
Удивительно, но есть только три числа, которые можно записать как сумму
четвертых степеней их цифр:
1634 = 1 4 + 6 4 + 3 4 + 4 4
8208 = 8 4 + 2 4 + 0 4 + 8 4
9474 = 9 4 + 4 4 + 7 4 + 4 4
Так как 1 = 1 4 не сумма, она не включена.
Сумма этих чисел составляет 1634 + 8208 + 9474 = 19316
Найдите сумму всех чисел, которые можно записать как сумму пятых
степеней их цифр.
Задача должна быть решена без использования списков.
*/

myPow(_, 0, 1):-!.
myPow(N, P, Res):-
	NextP is P - 1,
	myPow(N, NextP, NextRes),
	Res is NextRes * N.

isSumOfPows(N):- isSumOfPows(N, N, 0).	
isSumOfPows(N, 0, Sum):- N is Sum, !.
isSumOfPows(N, N2, Sum):-
	N2 > 0,
	NextN2 is N2 div 10,
	Num is N2 mod 10,
	myPow(Num, 5, Res),
	NextSum is Sum + Res,
	isSumOfPows(N, NextN2, NextSum),!.
	
sumOfSumsOfPows(N, Sum):- sumOfSumsOfPows(N, 0, Sum).
sumOfSumsOfPows(0, Sum, Sum):-!.
sumOfSumsOfPows(N, Summator, Sum):-
	NextN is N - 1,
	isSumOfPows(N),
	NextSummator is Summator + N,
	sumOfSumsOfPows(NextN, NextSummator, Sum),!;
	NextN is N - 1,
	sumOfSumsOfPows(NextN, Summator, Sum),!.

% 14 Построить предикат, получающий длину списка.
listLength([], 0):- !.
listLength([_|Tail], Length):- listLength(Tail, NextLength), Length is NextLength + 1, !.

/*
1.5
Дан целочисленный массив и натуральный индекс (число, меньшее
размера массива). Необходимо определить является ли элемент по указан-
ному индексу глобальным минимумом.
*/

min([Head|Tail], Min):- min(Tail, Head, Min).
min([], Min, Min).
min([Head|Tail], CurMin, Min):-
	Head < CurMin,
	NextCurMin is Head,
	min(Tail, NextCurMin, Min),!;
	Head > CurMin,
	NextCurMin is CurMin,
	min(Tail, NextCurMin, Min),!.
	
isGlobalMin(List, Index):- isGlobalMin(List, List, Index).
isGlobalMin(List,[Head|_], 0):- min(List, Head), !.
isGlobalMin(List, [_|Tail], Index):-
	NextIndex is Index - 1,
	isGlobalMin(List, Tail, NextIndex).
