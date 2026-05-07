% len - length of a list.

len([], 0).
len([_ | T], N) :- len(T, X), N is X + 1.

% mem - if X is a member of a List.
 
not(mem(_,[])).
mem(X,[H|_]) :- X = H.
mem(X,[_|List]) :-  mem(X,List).