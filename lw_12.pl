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
15
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
	
/* 16 Дан целочисленный массив. Необходимо переставить в обратном
порядке элементы массива, расположенные между его минимальным и
максимальным элементами.

Отче наш, Иже еси на небесех!
Да святится имя Твое,
да приидет Царствие Твое,
да будет воля Твоя,
яко на небеси и на земли.
Хлеб наш насущный даждь нам днесь;
и остави нам долги наша,
якоже и мы оставляем должником нашим;
и не введи нас во искушение,
но избави нас от лукаваго.
Ибо Твое есть Царство и сила и слава во веки.
Аминь.
*/

appendList([], List2, List2).
appendList([Head|Tail], List2, [Head|TailResult]):-
   appendList(Tail, List2, TailResult).

maxItemIndex([Head|Tail], Index):- maxItemIndex([Head|Tail], Head, 0, 0, Index).
maxItemIndex([], _, _, Index, Index).
maxItemIndex([Head|Tail], Max, Index, MaxIndex, Res):-
	NextIndex is Index + 1,
	Max =< Head, NextMax is Head, NextMaxIndex is Index,
	maxItemIndex(Tail, NextMax, NextIndex, NextMaxIndex, Res),!; 
	NextIndex is Index + 1, 
	Max > Head, maxItemIndex(Tail, Max, NextIndex, MaxIndex, Res),!.


minItemIndex([Head|Tail], Index):- minItemIndex([Head|Tail], Head, 0, 0, Index).
minItemIndex([], _, _, Index, Index).
minItemIndex([Head|Tail], Min, Index, MinIndex, Res):-
	NextIndex is Index + 1,
	Min >= Head, NextMin is Head, NextMinIndex is Index,
	minItemIndex(Tail, NextMin, NextIndex, NextMinIndex, Res),!; 
	NextIndex is Index + 1, 
	Min < Head, minItemIndex(Tail, Min, NextIndex, MinIndex, Res),!.

lowerBound(List, Res):- 
	maxItemIndex(List, Max), 
	minItemIndex(List, Min),
	Max > Min,
	Res is Min,!;
	maxItemIndex(List, Max), 
	minItemIndex(List, Min),
	Max < Min,
	Res is Max,!.
	
upperBound(List, Res):- 
	maxItemIndex(List, Max), 
	minItemIndex(List, Min),
	Max < Min,
	Res is Min,!;
	maxItemIndex(List, Max), 
	minItemIndex(List, Min),
	Max > Min,
	Res is Max,!.
	
reverseList(List, Reversed):- reverseList(List, [], Reversed).
reverseList([], Reversed, Reversed).
reverseList([Head|Tail], Buffer, Reversed):-
	reverseList(Tail, [Head|Buffer], Reversed).
	
reverseSegment(List, Processed):- 
	lowerBound(List, Lower), upperBound(List, Upper),
	reverseSegment(List, [], [], Lower, Upper, 0, Processed),!.
reverseSegment([H|[]], [H]):-!.	
reverseSegment([H1,H2|[]], [H1,H2]):-!.	
reverseSegment(List, [], [], Lower, Upper, 0, List):- Lower is Upper - 1,!.	
reverseSegment([], Processed, [_|_], _, _, _, Processed):-!.
reverseSegment([Head|Tail], Buffer, RevSegment, Lower, Upper, Index, Processed):-	
	Index =< Lower, NextIndex is Index + 1,
	appendList(Buffer, [Head], NextBuffer),
	reverseSegment(Tail, NextBuffer, RevSegment, Lower, Upper, NextIndex, Processed),!;
	Index > Lower, Index < Upper,
	NextIndex is Index + 1,    
	appendList(RevSegment, [Head], NextRevSegment),
	reverseSegment(Tail, Buffer, NextRevSegment, Lower, Upper, NextIndex, Processed),!;	
	Index = Upper, reverseList(RevSegment, Reversed), 
	appendList(Reversed, [Head], NextRevSegment),
	appendList(Buffer, NextRevSegment, NextBuffer),
	NextIndex is Index + 1, 
	reverseSegment(Tail, NextBuffer, RevSegment, Lower, Upper, NextIndex, Processed),!;
	Index > Upper, NextIndex is Index + 1,
	appendList(Buffer, [Head], NextBuffer),
	reverseSegment(Tail, NextBuffer, RevSegment, Lower, Upper, NextIndex, Processed),!.
	
/* 17 
Дан целочисленный массив. Необходимо поменять местами мини-
мальный и максимальный элементы массива.
*/	


max([Max], Max):-!.
max([Head|Tail], Max):-
   max(Tail, TailMax),
   TailMax > Head, !, Max is TailMax;
   Max is Head.

min([Min], Min):-!.
min([Head|Tail], Min):-
   min(Tail, TailMin),
   TailMin < Head, !, Min is TailMin;
   Min is Head.
	
swapMinAndMax(List, Swapped):-
	maxItemIndex(List, MaxIndex),
	minItemIndex(List, MinIndex),
	max(List, Max),
	min(List, Min),
	swapMinAndMax(List, [], 0, Min, Max, MinIndex, MaxIndex, Swapped),!.
	
swapMinAndMax([], Swapped, _, _, _, _, _, Swapped):- !.
swapMinAndMax([Head|Tail], Buffer, Index, Min, Max, MinIndex, MaxIndex, Swapped):-	
	Index is MinIndex, NextIndex is Index + 1,
	append(Buffer, [Max], NextSwapped), write(Buffer), nl,
	swapMinAndMax(Tail, NextSwapped, NextIndex, Min, Max, MinIndex, MaxIndex, Swapped),!; 
	Index is MaxIndex, NextIndex is Index + 1,
	append(Buffer, [Min], NextSwapped), write(Buffer), nl,
	swapMinAndMax(Tail, NextSwapped, NextIndex, Min, Max, MinIndex, MaxIndex, Swapped),!;
	NextIndex is Index + 1,
	append(Buffer, [Head], NextSwapped), write(Buffer), nl,
	swapMinAndMax(Tail, NextSwapped, NextIndex, Min, Max, MinIndex, MaxIndex, Swapped),!.
	
/*18 
Дан целочисленный массив. Необходимо осуществить циклический
сдвиг элементов массива вправо на одну позицию.
*/

cyclicalRightShift([Head|Tail], Shifted):- 
	reverseList([Head|Tail], [RHead|RTail]), 
	reverseList(RTail, ReversedRTail), append([RHead], ReversedRTail, Shifted),!.

/* 19
Дан целочисленный массив. Необходимо найти количество элемен-
тов между первым и последним минимальным.
*/

countBetweenMins(List, Count):-
	minItemIndex(List, LastMin),
	reverseList(List, Reversed),
	minItemIndex(Reversed, NotFirstMin),
	listLength(List, Length),
	FirstMin is (Length - NotFirstMin) - 1,
	countBetweenMins(List, 0, FirstMin, LastMin, Count),!.

countBetweenMins([], _, _, _, 0).	
countBetweenMins([_|Tail], Index, FirstMin, LastMin, Count):-
	NextIndex is Index + 1,	
	countBetweenMins(Tail, NextIndex, FirstMin, LastMin, NextCount),	
	(Index > FirstMin, Index < LastMin, Count is NextCount + 1; Count is NextCount).

/* 20
Дан целочисленный массив и интервал a..b. Необходимо проверить
наличие максимального элемента массива в этом интервале.
*/


getListOfMaxsIndexes(List, Maxs):-
	max(List, Max),
	getListOfMaxsIndexes(List, [], 0, Max, Maxs),!.

getListOfMaxsIndexes([], Maxs, _, _, Maxs):-!.
getListOfMaxsIndexes([Head|Tail], Buffer, Index, Max, Maxs):-
	Head is Max,
	NextIndex is Index + 1,
	appendList(Buffer, [Index], NextBuffer),
	getListOfMaxsIndexes(Tail, NextBuffer, NextIndex, Max, Maxs),!;
	NextIndex is Index + 1,
	getListOfMaxsIndexes(Tail, Buffer, NextIndex, Max, Maxs).
	
isWithinBounds(List, A, B):- 
	getListOfMaxsIndexes(List, Indexes),
	isWithinBounds_(Indexes, A, B).	
isWithinBounds_([], _, _):- fail,!.
isWithinBounds_([Head|Tail], A, B):-
	Head > A, Head < B, !;
	isWithinBounds_(Tail, A, B),!.
