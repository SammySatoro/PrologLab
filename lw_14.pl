makeEmptyList([]).

readS(Str,N,IsLast):-get0(Char),readS(Char,Str,[],N,0,IsLast). % чтение строки из файла
readS(-1,Str,Str,N,N,1):-!.
readS(10,Str,Str,N,N,0):-!.
readS(Char,Str,NowStr,N,I,IsLast):-I1 is I+1,append(NowStr,[Char],NowStr1),get0(Char1),readS(Char1,Str,NowStr1,N,I1,IsLast).

readOneS(Str,N):-get0(Char),readOneS(Char,Str,[],N,0). % чтение одной строки из файла
readOneS(10,Str,Str,N,N):-!.
readOneS(-1,Str,Str,N,N):-!.
readOneS(Char,Str,NowStr,N,I):-I1 is I+1,append(NowStr,[Char],NowStr1),get0(Char1),readOneS(Char1,Str,NowStr1,N,I1).

readListS(List):-readS(Str,_,IsLast),readListS([Str],List,IsLast). % чтение из файла списка строк
readListS(List,List,1):-!.
readListS(Cur_list,List,0):-
	readS(Str,_,IsLast),append(Cur_list,[Str],C_l),readListS(C_l,List,IsLast).
	
readS(Str,N):-readS(Str,N,0). % чтение строки длины N

writeS([]):-!. %вывод стринга
writeS([H|T]):-put(H),writeS(T).

writeListS([]):-!. %вывод списка стрингов
writeListS([H|T]):-writeS(H),nl,writeListS(T).

writeList([]):-!.
writeList([H]):-write(H).
writeList([H|T]):- write(H),write(' '),writeList(T).

appendList([],X,X).
appendList([X|T],Y,[X|T1]) :- appendList(T,Y,T1).

listLength([],0).
listLength([_|T],I):-listLength(T,I1),I is I1 + 1.

%1.1 Дана строка. Вывести ее три раза через запятую и показать количество символов в ней.
task11:-readS(Str,N,0),writeS(Str),write(", "),writeS(Str),write(", "),writeS(Str),write(" , "),write(N).

%1.2 Дана строка. Найти количество слов.
countOfWords([],Count):-Count is 1,!.
countOfWords([H|T],Count):-
	(
		H is 32,
		
		countOfWords(T,Count1),
		Count is Count1+1;

		countOfWords(T,Count)
	),!.

task12:-readS(Str,N,0),countOfWords(Str,Count),write(Count).
%1.3 Дана строка, определить самое частое слово
getListOfWordsFromStr(Str,List):-getListOfWordsFromStr(Str,List,[]).
getListOfWordsFromStr([],WordsList,NowWord):-append([NowWord], [],WordsList).
getListOfWordsFromStr([H|T],WordsList,NowWord):-
	(
		not(H is 32),
		
		append(NowWord,[H],NowWord1),
		getListOfWordsFromStr(T,WordsList,NowWord1);

		getListOfWordsFromStr(T,WordsList1,[]),
		append([NowWord],WordsList1,WordsList)
	),!.

mostRatedWordFromList(WordsList,Word):-mostRatedWordFromList(WordsList,Word,[],-1,WordsList).
mostRatedWordFromList([],Word,NowWord,Count,StartList):-append([],NowWord,Word),!.
mostRatedWordFromList([WordsListH|WordsListT],Word,NowWord,Count,StartList):-
	countOfThisWordInList(StartList,WordsListH,NowCount),
	(
		NowCount>Count,

		mostRatedWordFromList(WordsListT,Word,WordsListH,NowCount,StartList);

		mostRatedWordFromList(WordsListT,Word,NowWord,Count,StartList)
	),!.
countOfThisWordInList([],Word,NowCount):- NowCount is 0,!.
countOfThisWordInList([StartListH|StartListT],Word,NowCount):-
	StartListH = Word,

	countOfThisWordInList(StartListT,Word,NowCount1),
	NowCount is NowCount1+1,!;

	countOfThisWordInList(StartListT,Word,NowCount),!.

mostRatedWordFromStr(Str,Word):-
	getListOfWordsFromStr(Str,WordsList),
	mostRatedWordFromList(WordsList,Word).

task13:-readS(Str,N,0),mostRatedWordFromStr(Str,Word),writeS(Word).
%1.4 Дана строка. Вывести первые три символа и последний три символа, если длина строки больше 5, иначе вывести первый символ столько раз, какова длина строки.
writeFirstAndLastThree([Fchar|StrT]):- writeFirstAndLastThree([Fchar|StrT],3),!.
writeFirstAndLastThree([Fchar|StrT],N):-
	N>0,
	cutLastChar(StrT,NewStr,Lchar),
	write(Fchar),
	N1 is N-1,
	writeFirstAndLastThree(NewStr, N1),
	write(Lchar),!;
	1 is 1,!.

cutLastChar([Lchar],NewStr,Lchar):-makeEmptyList(NewStr),!.
cutLastChar([StrH|StrT],NewStr,Lchar):-
	cutLastChar(StrT,NewStr1,Lchar),
	append([StrH],NewStr1,NewStr),!.

writeNTimesFirst([StrH|StrT],N):-
	N>0,
	write(StrH),
	N1 is N-1,
	writeNTimesFirst([StrH|StrT],N1),!;
	1 is 1,!.

task14:-
	readS(Str,N,0),
	(
		N>5,

		writeFirstAndLastThree(Str),!;
		writeNTimesFirst(Str,N)
	),!.
%1.5 Дана строка. Показать номера символов, совпадающих с последним символом строки.
getNumberOfCharsThatLikeLast(Str,ListNumbers):-cutLastChar(Str,_,LastChar),getNumberOfCharsLikeThat(Str,ListNumbers,LastChar),!.
getNumberOfCharsLikeThat(Str,ListNumbers,LastChar):-getNumberOfCharsLikeThat(Str,ListNumbers,LastChar,0),!.
getNumberOfCharsLikeThat([],ListNumbers,LastChar,I):-makeEmptyList(ListNumbers),!.
getNumberOfCharsLikeThat([StrH|StrT],ListNumbers,LastChar,I):-
	I1 is I+1,
	(
	StrH = LastChar,

	getNumberOfCharsLikeThat(StrT,ListNumbers1,LastChar,I1),
	append([I1],ListNumbers1,ListNumbers),!;

	getNumberOfCharsLikeThat(StrT,ListNumbers,LastChar,I1),!	
	).
	
task21:-see('D:/Prolog/inputLW14/21.txt'),readListS(ListStr),getMaxLengthStr(ListStr,MaxLength),seen,
	tell('D:/Prolog/outputLW14/21.txt'),write(MaxLength),told.
	
%2.2 Дан файл. Определить, сколько в файле строк, не содержащих пробелы.
getCountOfStrWithoutSpace([],Count):- Count is 0,!.
getCountOfStrWithoutSpace([ListStrH|ListStrT],Count):-
	isThisCharInStr(ListStrH,32),

	getCountOfStrWithoutSpace(ListStrT,Count),!;

	getCountOfStrWithoutSpace(ListStrT,Count1),
	Count is Count1+1,!.

isThisCharInStr([],Char):-fail,!.
isThisCharInStr([StrH|StrT],Char):-!,
	(
		StrH = Char;

		isThisCharInStr(StrT,Char)
	),!.

task22:-see('D:/Prolog/inputLW14/22.txt'),readListS(ListStr),getCountOfStrWithoutSpace(ListStr,Count),seen,
	tell('D:/Prolog/outputLW14/22.txt'),write(Count),told,!.
%2.3 Дан файл, найти и вывести на экран только те строки, в которых букв А больше, чем в среднем на строку.
getCountOfCharsLikeThat(Str,Char,Count):-
	getNumberOfCharsLikeThat(Str,IndexList,Char),
	listLength(IndexList,Count),!.

getCountOfCharInListStr([],Char,CountOfA):-CountOfA is 0.
getCountOfCharInListStr([ListStrH|ListStrT],Char,CountOfA):-
	getCountOfCharsLikeThat(ListStrH,Char,Count),
	getCountOfCharInListStr(ListStrT,Char,CountOfA1),
	CountOfA is CountOfA1+Count,!.	

getListOfStrWhereCountOfCharMoreThenThis([],Char,ThisCount,NewList):-makeEmptyList(NewList),!.
getListOfStrWhereCountOfCharMoreThenThis([ListStrH|ListStrT],Char,ThisCount,NewList):-
	getCountOfCharsLikeThat(ListStrH,Char,CountOfA),
	(
		CountOfA>ThisCount,
		getListOfStrWhereCountOfCharMoreThenThis(ListStrT,Char,ThisCount,NewList1),
		append([ListStrH],NewList1,NewList);

		getListOfStrWhereCountOfCharMoreThenThis(ListStr,Char,ThisCount,NewList)
	),!.

getListOfStrWhereMoreAThenAvgOfA(ListStr,NewList):-
	getCountOfCharInListStr(ListStr,65,CountOfA),
	listLength(ListStr,Length),
	AvgOfA is CountOfA / Length,
	getListOfStrWhereCountOfCharMoreThenThis(ListStr,65,AvgOfA,NewList),!.

task23:-see('D:/Prolog/inputLW14/23.txt'),readListS(ListStr),getListOfStrWhereMoreAThenAvgOfA(ListStr,NewList),seen,
	tell('D:/Prolog/outputLW14/23.txt'),writeListS(NewList),told.
%2.4 Дан файл, вывести самое частое слово.
getMostRatedWordFromListStr(ListStr,Word):-
	getListOfWordsFromListStr(ListStr,WordsList),
	mostRatedWordFromList(WordsList,Word).

getListOfWordsFromListStr([],WordsList):-makeEmptyList(WordsList),!.
getListOfWordsFromListStr([ListStrH|ListStrT],WordsList):-
	getListOfWordsFromStr(ListStrH,WordsList1),
	getListOfWordsFromListStr(ListStrT,WordsList2),
	append(WordsList1,WordsList2,WordsList),!.	

task24:-see('D:/Prolog/inputLW14/24.txt'),readListS(ListStr),getMostRatedWordFromListStr(ListStr,Word),seen,
	tell('D:/Prolog/outputLW14/24.txt'),writeS(Word),told.
%2.5 Дан файл, вывести в отдельный файл строки, состоящие из слов, не повторяющихся в исходном файле.
getStrWithUniqueWordsFromListStr(ListStr,NewListStr):-
	getListOfWordsFromListStr(ListStr,WordsList),
	getUniqueWordsFromWordsList(WordsList,UniqueWordsList),
	getStrWithUniqueWords(ListStr,UniqueWordsList,NewListStr).

getUniqueWordsFromWordsList(WordsList,UniqueWordsList):-getUniqueWordsFromWordsList(WordsList,UniqueWordsList,WordsList),!.

getUniqueWordsFromWordsList([],UniqueWordsList,StartList):-makeEmptyList(UniqueWordsList),!.
getUniqueWordsFromWordsList([WordsListH|WordsListT],UniqueWordsList,StartList):-
	countOfThisWordInList(StartList,WordsListH,Count),
	(
		1 is Count,
		getUniqueWordsFromWordsList(WordsListT,UniqueWordsList1,StartList),
		append([WordsListH],UniqueWordsList1, UniqueWordsList);

		getUniqueWordsFromWordsList(WordsListT,UniqueWordsList,StartList)
	),!.

getStrWithUniqueWords([],UniqueWordsList,NewListStr):-makeEmptyList(NewListStr),!.
getStrWithUniqueWords([ListStrH|ListStrT],UniqueWordsList,NewListStr):-
	isThereUniqueWordsInStr(ListStrH,UniqueWordsList),
	getStrWithUniqueWords(ListStrT,UniqueWordsList,NewListStr1),
	append([ListStrH],NewListStr1,NewListStr),!;

	getStrWithUniqueWords(ListStrT,UniqueWordsList,NewListStr),!.

isThereUniqueWordsInStr(Str,UniqueWordsList):-
	getListOfWordsFromStr(Str,WordsList),
	isThereUniqueWordsInWordList(WordsList,UniqueWordsList).

isThereUniqueWordsInWordList([],UniqueWordsList):-!.
isThereUniqueWordsInWordList([WordsListH|WordsListT],UniqueWordsList):-
	isStrInStrList(WordsListH,UniqueWordsList),
	isThereUniqueWordsInWordList(WordsListT,UniqueWordsList),!.

isStrInStrList(Str,[]):-fail,!.
isStrInStrList(Str,[ListStrH|ListStrT]):- 
	Str = ListStrH,!;
	isStrInStrList(Str,ListStrT),!.
	

task25:-see('D:/Prolog/inputLW14/25.txt'),readListS(ListStr),getStrWithUniqueWordsFromListStr(ListStr,NewListStr),seen,
	tell('D:/Prolog/outputLW14/25.txt'),writeListS(NewListStr),told.

/*3-5 Дана строка. Необходимо перемешать все символы строки в случайном
порядке.*/

listLength([], 0):- !.
listLength([_|Tail], Length):- 
	listLength(Tail, NextLength), 
	Length is NextLength + 1, !. 

removeItemByIndex(0, [_|Tail], Tail):-!.
removeItemByIndex(Index, [Head|Tail1], [Head|Tail2]) :- 
	NextIndex is Index - 1,	
	removeItemByIndex(NextIndex,Tail1,Tail2),!.

getItemByIndex(0, [Head|_], Head):-!.
getItemByIndex(Index, [_|Tail], Item) :- 
	NextIndex is Index - 1,	
	getItemByIndex(NextIndex,Tail,Item),!.

shuffleList(List, Shuffled):-
	listLength(List, Length),
	shuffleList(List, Length, [], Shuffled),!.
shuffleList([], 0, Shuffled, Shuffled).
shuffleList(List, Length, Buffer, Shuffled):-
	NextLength is Length - 1,
	RandomIndex is random(Length),
	getItemByIndex(RandomIndex, List, Item),
	removeItemByIndex(RandomIndex, List, ListWithoutItem),
	shuffleList(ListWithoutItem, NextLength, [Item|Buffer], Shuffled).

shuffleString(String, Shuffled):-
	string_chars(String, Chars),
	shuffleList(Chars, ShuffledChars),
	string_chars(Shuffled, ShuffledChars).

%6 Результат записывать в файл.
task6:-see('D:/Prolog/inputLW14/6.txt'),readOneS(StrK,_),readOneS(Mnoj,_),K is StrK-48,seen,
	tell('D:/Prolog/outputLW14/6.txt'),
	write('6.1:'),nl, %6.1 Дано множество. Построить все размещения с повторениями по k элементов.
	not(razmesheniyaSPoovtoreniyamiPoK(Mnoj,K,[])),nl,!,
	write('6.2:'),nl, %6.2 Дано множество. Построить все перестановки.
	not(perestanovki(Mnoj,[])),nl,!,
	write('6.3:'),nl, %6.3 Дано множество. Построить все размещения по k элементов.
	not(razmesheniyaPoK(Mnoj,K,[])),nl,!,
	write('6.4:'),nl, %6.4 Дано множество. Построить все подмножества.
	allPodMnoj(Mnoj,[]),!,
	write('6.5'),nl, %6.5 Дано множество. Построить все сочетания по k элементов.
	sochetaniyaPoK(Mnoj,K,[]),!,
	write('6.6'),nl, %6.6 Дано множество. Построить все сочетания с повторениями.
	sochetaniyaSPovtoreniyamiPoK(Mnoj,K,[]),!,
	told.



razmesheniyaSPoovtoreniyamiPoK(_,0,Rasm):-writeS(Rasm),nl,!,fail.
razmesheniyaSPoovtoreniyamiPoK(Mnoj,K,Rasm):-
	inList(Mnoj,El),
	K1 is K-1,
	razmesheniyaSPoovtoreniyamiPoK(Mnoj,K1,[El|Rasm]).

perestanovki([],Per):-writeS(Per),nl,!,fail.
perestanovki(Mnoj,Per):-inListAndDelete(Mnoj,El,Mnoj1),perestanovki(Mnoj1,[El|Per]).

razmesheniyaPoK(_,0,Raz):-writeS(Raz),nl,!,fail.
razmesheniyaPoK(Mnoj,K,Raz):-inListAndDelete(Mnoj,El,Mnoj1),K1 is K-1,razmesheniyaPoK(Mnoj1,K1,[El|Raz]).

allPodMnoj(Mnoj,PodMnoj):-allPodMnoj(Mnoj,PodMnoj,1).
allPodMnoj([],PodMnoj,IsNeedToWrite):-
	(
		1 is IsNeedToWrite,
		writeS(PodMnoj),nl;
		IsNeedToWrite is 0
	),!.
allPodMnoj(Mnoj,PodMnoj,IsNeedToWrite):-
	(
		IsNeedToWrite is 1,
		writeS(PodMnoj),nl;
		IsNeedToWrite is 0
	),
	inListAndDelete(Mnoj,El,Mnoj1),
	append([El],PodMnoj,NewPodMnoj),
	allPodMnoj(Mnoj1,PodMnoj,0),
	allPodMnoj(Mnoj1,NewPodMnoj,1).

sochetaniyaPoK([],K,PodMnoj):-
	0 is K,
	writeS(PodMnoj),nl,!;
	!.
sochetaniyaPoK(Mnoj,0,PodMnoj):-
	writeS(PodMnoj),nl,!.
sochetaniyaPoK(Mnoj,K,PodMnoj):-
	inListAndDelete(Mnoj,El,Mnoj1),
	append([El],PodMnoj,NewPodMnoj),
	K1 is K-1,
	sochetaniyaPoK(Mnoj1,K,PodMnoj),
	sochetaniyaPoK(Mnoj1,K1,NewPodMnoj).

sochetaniyaSPovtoreniyamiPoK([],K,PodMnoj):-
	0 is K,
	writeS(PodMnoj),nl,!;
	!.
sochetaniyaSPovtoreniyamiPoK(Mnoj,0,PodMnoj):-
	writeS(PodMnoj),nl,!.
sochetaniyaSPovtoreniyamiPoK(Mnoj,K,PodMnoj):-
	cutLastChar(Mnoj,Mnoj1,El),
	append([El],PodMnoj,NewPodMnoj),
	K1 is K-1,
	sochetaniyaSPovtoreniyamiPoK(Mnoj1,K,PodMnoj),
	sochetaniyaSPovtoreniyamiPoK(Mnoj,K1,NewPodMnoj),!.

inList([],_):-fail.
inList([X|_],X).
inList([_|T],X):-inList(T,X).

inListAndDelete([El|T],El,T).
inListAndDelete([H|T],El,[H|Tail]):-inListAndDelete(T,El,Tail).

inListAndAllBeforeDelete([El|T],El,T).
inListAndAllBeforeDelete([H|T],El,Tail):-inListAndAllBeforeDelete(T,El,Tail).
%7 Дано множество {a,b,c,d,e,f}. Построить все слова длины 5, в которых ровно две буквы a. Вывод в файл.
getRazmesheniePoK(_,0,Final,Final):-!.
getRazmesheniePoK(Mnoj,K,Raz,Final):-inListAndDelete(Mnoj,El,Mnoj1),K1 is K-1,getRazmesheniePoK(Mnoj1,K1,[El|Raz],Final).

getSochetaniyaPoK([],K,PodMnoj,Final):-
	0 is K,
	append([],PodMnoj,Final),!.
getSochetaniyaPoK(Mnoj,0,Final,Final):-!.
getSochetaniyaPoK(Mnoj,K,PodMnoj,Final):-
	inListAndAllBeforeDelete(Mnoj,El,Mnoj1),
	append([El],PodMnoj,NewPodMnoj),
	K1 is K-1,
	getSochetaniyaPoK(Mnoj1,K1,NewPodMnoj,Final).

getRazmesheniyaSPovtoreniyamiPoK(_,0,Final,Final):-!.
getRazmesheniyaSPovtoreniyamiPoK(Mnoj,K,Rasm,Final):-
	inList(Mnoj,El),
	K1 is K-1,
	getRazmesheniyaSPovtoreniyamiPoK(Mnoj,K1,[El|Rasm],Final).

buildWord7(WhereA,AnotherChars,Word):-buildWord7(WhereA,AnotherChars,Word,0).
buildWord7([],[],Word,Index):-makeEmptyList(Word),!.
buildWord7(WhereA,[AnotherCharsH|AnotherCharsT],Word,Index):-
	Index1 is Index+1,
	(
		inListAndDelete(WhereA, Index,WhereA1),

		buildWord7(WhereA1,[AnotherCharsH|AnotherCharsT],Word1,Index1),
		append([97],Word1,Word);

		buildWord7(WhereA,AnotherCharsT,Word1,Index1),
		append([AnotherCharsH],Word1,Word)
	),!.
buildWord7(WhereA,AnotherChar,Word,Index):-
	Index1 is Index+1,
	(
		inListAndDelete(WhereA, Index,WhereA1),

		buildWord7(WhereA1,AnotherChar,Word1,Index1),
		append([97],Word1,Word);

		buildWord7(WhereA,[],Word1,Index1),
		append([AnotherChar],Word1,Word)
	),!.

task7:-append([],[97,98,99,100,101,102], Mnoj),
	tell('D:/Prolog/outputLW14/7.txt'),
	not((
		getRazmesheniyaSPovtoreniyamiPoK([98,99,100,101,102],3,[],AnotherChars), %выбираем последовательность из 3 букв
		getSochetaniyaPoK([0,1,2,3,4],2,[],WhereA), % выбираем 2 места под а
		buildWord7(WhereA,AnotherChars,Word),
		writeS(Word),nl,fail
	)),
	told.
%8 Дано множество {a,b,c,d,e,f}. Построить все слова длины 5, в которых ровно 2 буквы a, остальные буквы не повторяются. Вывод в файл.
task8:-append([],[97,98,99,100,101,102], Mnoj),
	tell('D:/Prolog/outputLW14/8.txt'),
	not((
		getRazmesheniePoK([98,99,100,101,102],3,[],AnotherChars), 
		getSochetaniyaPoK([0,1,2,3,4],2,[],WhereA),
		buildWord7(WhereA,AnotherChars,Word),
		writeS(Word),nl,fail
	)),
	told.
	
	
%9 Дано множество {a,b,c,d,e,f}. Построить все слова длины 5, в которых ровно одна буква повторяется 2 раза, остальные буквы не повторяются. Вывод в файл.
buildWord9(RepeatChars,WhereA,AnotherChars,Word):-buildWord9(RepeatChars,WhereA,AnotherChars,Word,0).
buildWord9(RepeatChars,[],[],Word,Index):-makeEmptyList(Word),!.
buildWord9(RepeatChars,WhereA,[AnotherCharsH|AnotherCharsT],Word,Index):-
	Index1 is Index+1,
	(
		inListAndDelete(WhereA, Index,WhereA1),

		buildWord9(RepeatChars,WhereA1,[AnotherCharsH|AnotherCharsT],Word1,Index1),
		append([97],Word1,Word);

		buildWord9(RepeatChars,WhereA,AnotherCharsT,Word1,Index1),
		append([AnotherCharsH],Word1,Word)
	),!.
buildWord9(RepeatChars,WhereA,AnotherChar,Word,Index):-
	Index1 is Index+1,
	(
		inListAndDelete(WhereA, Index,WhereA1),

		buildWord9(RepeatChars,WhereA1,AnotherChar,Word1,Index1),
		append([RepeatChars],Word1,Word);

		buildWord9(RepeatChars,WhereA,[],Word1,Index1),
		append([AnotherChar],Word1,Word)
	),!.

task9:-append([],[97,98,99,100,101,102], Mnoj),
	tell('D:/Prolog/outputLW14/9.txt'),
	not((
		getRazmesheniePoK(Mnoj,1,[],RepeatChars),
		RepeatChar is RepeatChars,
		inListAndDelete(Mnoj,RepeatChar,Mnoj1),
		getRazmesheniePoK(Mnoj1,3,[],AnotherChars), 
		getSochetaniyaPoK([0,1,2,3,4],2,[],WhereA),
		buildWord9(RepeatChar,WhereA,AnotherChars,Word),
		writeS(Word),nl,fail
	)),
	told.
%10 Дано множество {a,b,c,d,e,f}. Построить все слова длины 6, в которых ровно 2 буквы повторяются 2 раза, остальные буквы не повторяются. Вывод в файл.
getElemByIndex(L,I,El):-getElemByIndex(L,I,El,0).
getElemByIndex([H|_],K,H,K):-!.
getElemByIndex([_|Tail],I,El,Cou):- I =:= Cou,getElemByIndex(Tail,Cou,El,Cou);Cou1 is Cou + 1, getElemByIndex(Tail,I,El,Cou1).

buildWord10(RepeatChars,WhereA,WhereB,AnotherChars,Word):-buildWord10(RepeatChars,WhereA,WhereB,AnotherChars,Word,0).
buildWord10(RepeatChars,[],[],[],Word,Index):-makeEmptyList(Word),!.
buildWord10(RepeatChars,WhereA,WhereB,[AnotherCharsH|AnotherCharsT],Word,Index):-
	Index1 is Index+1,
	(
		inListAndDelete(WhereA, Index,WhereA1),

		buildWord10(RepeatChars,WhereA1,WhereB,[AnotherCharsH|AnotherCharsT],Word1,Index1),
		getElemByIndex(RepeatChars,0,Elem),
		append([Elem],Word1,Word);

		(
			inListAndDelete(WhereB, Index,WhereB1),
			
			buildWord10(RepeatChars,WhereA,WhereB1,[AnotherCharsH|AnotherCharsT],Word1,Index1),
			getElemByIndex(RepeatChars,1,Elem),
			append([Elem],Word1,Word);
			
			buildWord10(RepeatChars,WhereA,WhereB,AnotherCharsT,Word1,Index1),
			append([AnotherCharsH],Word1,Word)
		)
	),!.
buildWord10(RepeatChars,WhereA,WhereB,AnotherChar,Word,Index):-
	Index1 is Index+1,
	(
		inListAndDelete(WhereA, Index,WhereA1),

		buildWord10(RepeatChars,WhereA1,WhereB,AnotherChar,Word1,Index1),
		getElemByIndex(RepeatChars,0,Elem),
		append([Elem],Word1,Word);

		(
			inListAndDelete(WhereB, Index,WhereB1),
			
			buildWord10(RepeatChars,WhereA,WhereB1,AnotherChar,Word1,Index1),
			getElemByIndex(RepeatChars,1,Elem),
			append([Elem],Word1,Word);
			
			buildWord10(RepeatChars,WhereA,WhereB,[],Word1,Index1),
			append(AnotherChar,Word1,Word)
		)
	),!.

inListAndDeleteList(Mnoj,[],Mnoj).
inListAndDeleteList(Mnoj,[RepeatCharsH|RepeatCharsT],Final):-
	inListAndDelete(Mnoj,RepeatCharsH,Mnoj1),
	inListAndDeleteList(Mnoj1,RepeatCharsT,Final),!.

task10:-append([],[97,98,99,100,101,102], Mnoj),
	append([],[0,1,2,3,4,5], Indexs),
	tell('D:/Prolog/outputLW14/10.txt'),
	not((
		getRazmesheniePoK(Mnoj,2,[],RepeatChars),
		inListAndDeleteList(Mnoj,RepeatChars,Mnoj1),
		getRazmesheniePoK(Mnoj1,2,[],AnotherChars), 
		getSochetaniyaPoK(Indexs,2,[],WhereA),
		inListAndDeleteList(Indexs,WhereA,Indexs1),
		getSochetaniyaPoK(Indexs1,2,[],WhereB),
		buildWord10(RepeatChars,WhereA,WhereB,AnotherChars,Word),
		writeS(Word),nl,fail
	)),
	told.
