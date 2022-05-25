writeList([]):- writeln(''), !.
writeList([Head|Tail]):- write(Head), write(' '), writeList(Tail). 

/* 11
Дан целочисленный массив. Найти среднее арифметическое моду-
лей его элементов.
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
    
/*12
Для введенного списка положительных чисел построить список всех по-
ложительных простых делителей элементов списка без повторений.
*/

divCount(N, Count):- divCount(N, 0, Count).
divCount(N, N, 0):-!.
divCount(N, Div, Count):-
	NextDiv is Div + 1,
	0 is N mod NextDiv, 	 
	divCount(N, NextDiv, NextCount),
	Count is NextCount + 1,!;	
	NextDiv is Div + 1,
	0 =\= N mod NextDiv,	 
	divCount(N, NextDiv, NextCount),
	Count is NextCount,!.

isPrime(N):- divCount(N, Count), Count is 2,!.

member([H|_], H).
member([_|T], H):- member(T, H),!. 

listOfPrimeDivs(N, Divs):- listOfPrimeDivs(N, 1, [], Divs),!.
listOfPrimeDivs(N, N1, Divs, Divs):- N1 is N + 1,!.
listOfPrimeDivs(N, Div, Buffer, Divs):-	
	NextDiv is Div + 1,
	0 is N mod Div, isPrime(Div),	
	listOfPrimeDivs(N, NextDiv, [Div|Buffer], Divs),!;
	NextDiv is Div + 1,
	listOfPrimeDivs(N, NextDiv, Buffer, Divs),!.

listOfAllPrimeDivs(List, Divs):- listOfAllPrimeDivs(List, [], Divs),!.
listOfAllPrimeDivs([], Divs, Divs):-!.
listOfAllPrimeDivs([Head|Tail], Buffer, Divs):-
	listOfPrimeDivs(Head, Primes),
	append(Buffer, Primes, NextBuffer),
	listOfAllPrimeDivs(Tail, NextBuffer, Divs).

listOfDistinctPrimes(List, Distincts):- 
	listOfAllPrimeDivs(List, PrimeDivs),
	write(PrimeDivs), nl,
	listOfDistinctPrimes(PrimeDivs, [], Distincts),!.
	
listOfDistinctPrimes([], Distincts, Distincts):- write("check"   | Distincts), nl,!.
listOfDistinctPrimes([Head|Tail], Buffer, Distincts):-
	member(Buffer, Head),
	listOfDistinctPrimes(Tail, Buffer, Distincts);
	appendList(Buffer, [Head], NextBuffer),	
	listOfDistinctPrimes(Tail, NextBuffer, Distincts).

/* 13
Для введенного списка построить новый с элементами, большими, чем
среднее арифметическое списка, но меньшими, чем его максимальное значе-
ние.
*/

buildList(List, NewList):- 
	max(List, Max),
	averageOfAbs(List, Average),
	buildList(List, [], Max, Average, NewList),!.

buildList([], NewList, _, _, NewList).
buildList([Head|Tail], Buffer, Max, Average, NewList):-
	Head < Max, Head > Average,
	appendList(Buffer, [Head], NextBuffer),
	buildList(Tail, NextBuffer, Max, Average, NewList);
	buildList(Tail, Buffer, Max, Average, NewList).

/* 14 
Беседует трое друзей: Белокуров, Рыжов, Чернов. Брюнет
сказал Белокурову: “Любопытно, что один из нас блондин, другой брюнет,
третий - рыжий, но ни у кого цвет волос не соответствует фамилии”. Какой
цвет волос у каждого из друзей?
*/

task14:- 
	HairColors=[_,_,_],
	member(HairColors,[belokurov,_]),
	member(HairColors,[chernov,_]),
	member(HairColors,[rizhov,_]),
	member(HairColors,[_,ginger]),
	member(HairColors,[_,blond]),
	member(HairColors,[_,brunette]),
	\+(member(HairColors,[belokurov,blond])),
	\+(member(HairColors,[chernov,brunette])),
	\+(member(HairColors,[rizhov,ginger])),
	write(HairColors),!.
	
/* 15
Три подруги вышли в белом, зеленом и синем платьях и туфлях. 
Известно, что только у Ани цвета платья и туфлей совпадали. Ни туфли,ни платье Вали не были белыми. 
Наташа была в зеленых туфлях. Определить цвета платья и туфель на каждой из подруг.
*/

task15:- 
	Women=[_,_,_],
	member(Women,[ann,X,X]),
	member(Women,[valya,_,_]),
	member(Women,[natasha,_,_]),
	member(Women,[_,white,_]),
	member(Women,[_,green,_]),
	member(Women,[_,blue,_]),
	member(Women,[_,_,white]),
	member(Women,[_,_,green]),
	member(Women,[_,_,blue]),
	\+member(Women,[valya,white,_]),
	\+member(Women,[valya,_,white]),
	\+member(Women,[natasha,Y,Y]),
	write(Women),!.
	
/* 16
На заводе работали три друга: слесарь, токарь и сварщик. Их фамилии Борисов, Иванов и Семенов. У слесаря нет ни братьев, ни сестер. 
Он самый младший из друзей. Семенов, женатый на сестре Борисова, старше токаря. Назвать фамилии слесаря, токаря и сварщика.
*/

task16:- 
	Workers = [_,_,_],
	/*member(Workers,[slesar,borisov,brothers_count,age,is_relative])*/
	member(Workers,[slesar,_,0,0,_]),
	member(Workers,[tokar,_,_,1,_]),
	member(Workers,[svarshick,_,_,_,_]),
	member(Workers,[_,semenov,_,2,borisov]),
	member(Workers,[_,ivanov,_,_,_]),
	member(Workers,[_,borisov,1,_,_]),
	member(Workers,[slesar,Who1,_,_,_]),
	member(Workers,[tokar,Who2,_,_,_]),
	member(Workers,[svarshick,Who3,_,_,_]),
	write('slesar - '),write(Who1),nl,
	write('tokar - '),write(Who2),nl,
	write('svarshick - '),write(Who3),!.


/* 17
В бутылке, стакане, кувшине и банке находятся молоко, лимонад, квас и вода. Известно, что вода и молоко не в бутылке, 
сосуд с лимонадом находится между кувшином и сосудом с квасом, в банке - не лимонад и не вода. 
Стакан находится около банки и сосуда с молоком. Как распределены эти жидкости по сосудам.
*/

right(_,_,[_]):-fail.
right(Item,RightItem,[Item|[RightItem|_]]).
right(Item,RightItem,[_|Tail]):-right(Item,RightItem,Tail).

left(_,_,[_]):-fail.
left(Item,LeftItem,[LeftItem|[Item|_]]).
left(Item,LeftItem,[_|Tail]):-left(Item,LeftItem,Tail).

isNextTo(A,B,List):-right(A,B,List).
isNextTo(A,B,List):-left(A,B,List).

task17:- 
    Liquid=[_,_,_,_],
    member(Liquid,[bottle,_]),
    member(Liquid,[glass,_]),
    member(Liquid,[pitcher,_]),
    member(Liquid,[jar,_]),
    member(Liquid,[_,milk]),
    member(Liquid,[_,lemonade]),
    member(Liquid,[_,kvas]),
    member(Liquid,[_,water]),
    \+(member(Liquid,[bottle,milk])),
    \+(member(Liquid,[bottle,water])),
    \+(member(Liquid,[jar,lemonade])),
    \+(member(Liquid,[jar,water])),
    right([pitcher,_],[_,lemonade],Liquid),
    right([_,lemonade],[_,kvas],Liquid),
    isNextTo([glass,_],[jar,_],Liquid),
    isNextTo([glass,_],[_,milk],Liquid),
    write(Liquid),!.

/* 18
Воронов, Павлов, Левицкий и Сахаров – четыре талантли-
вых молодых человека. Один из них танцор, другой художник, третий-певец,
а четвертый-писатель. О них известно следующее: Воронов и Левицкий си-
дели в зале консерватории в тот вечер, когда певец дебютировал в сольном
концерте. Павлов и писатель вместе позировали художнику. Писатель написал
биографическую повесть о Сахарове и собирается написать о Воронове. Воро-
нов никогда не слышал о Левицком. Кто чем занимается?*/

task18:- 
	Men=[_,_,_,_],
	member(Men,[pavlov,_]),
	member(Men,[levicki,_]),
	member(Men,[saharov,_]),
	member(Men,[voronov,_]),
	member(Men,[_,dancer]),
	member(Men,[_,artist]),
	member(Men,[_,singer]),
	member(Men,[_,writer]),
	\+(member(Men,[saharov,writer])),
	\+(member(Men,[voronov,writer])),
	\+(member(Men,[voronov,singer])),
	\+(member(Men,[levicki,singer])),
	\+(member(Men,[pavlov,writer])),
	\+(member(Men,[pavlov,artist])),
	\+(member(Men,[voronov,artist])),
	write(Men),!.
