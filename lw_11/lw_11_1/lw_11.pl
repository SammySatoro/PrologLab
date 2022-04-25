man(evpaty).
man(elisey).
man(eren).
man(ermolay).
man(eger).
man(evgeny).
man(ervin).
man(ethan).

woman(eve).
woman(elana).
woman(evgenia).
woman(elena).
woman(etna).
woman(erlina).
woman(enna).
woman(etlin).

parent(evpaty,elena).
parent(evpaty,etna).

parent(eve,elena).
parent(eve,etna).

parent(elisey,erlina).
parent(elisey,ermolay).

parent(elana,erlina).
parent(elana,ermolay).

parent(eren,enna).
parent(eren,eger).

parent(evgenia,enna).
parent(evgenia,eger).

parent(ermolay,evgeny).
parent(ermolay,ervin).

parent(elena,evgeny).
parent(elena,ervin).

parent(ermolay,ethan).
parent(ermolay,etlin).

parent(enna,ethan).
parent(enna,etlin).

men:-man(X),write(X),nl,fail.
women:-woman(X),write(X),nl,fail.

%lw_11_11
son(X,Y):- man(X), parent(Y,X).
son(X):- parent(X,Y), man(Y), write(Y), nl, fail.
%lw_11_12
husband(X,Y):- man(X), parent(X,Z), parent(Y,Z).
husband(X):- husband(Y,X), man(Y), woman(X), write(Y), nl, !.
%lw_11_13
grandson(X,Y):- man(X), parent(Y,Z), parent(Z,X).
grandsons(X):- grandson(Y,X), write(Y), nl, fail.
%lw_11_14
grandpa_and_da(X,Y):- 
	man(X), woman(Y), parent(X,Z), parent(Z,Y) | 
	man(Y), woman(X), parent(Y,Z), parent(Z,X).
%lw_11_15
maxUp(X, X):- X < 10, !.
maxUp(X, Max):-
   X1 is X div 10,
   X2 is X mod 10,
   maxUp(X1, Max1),
   (X2 < Max1,  Max is Max1; Max is X2).
%lw_11_16   
maxDown(X, Max):- maxDown(X, 0, Max).
maxDown(0, Max, Max):- !.
maxDown(X, C, Max):-
	X1 is X div 10,
	D1 is X mod 10,
	D1 > C, 
	!,	
	maxDown(X1, D1, Max);
	X2 is X div 10,
	maxDown(X2, C, Max).

