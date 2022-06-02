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
