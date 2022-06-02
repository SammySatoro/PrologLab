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
