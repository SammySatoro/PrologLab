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
