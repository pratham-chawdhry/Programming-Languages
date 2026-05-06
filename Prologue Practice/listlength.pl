% -------- LENGTH --------
len([],0).
len([_|T],N) :- len(T,P), N is P+1.


% -------- MEMBER --------
member(L,X) :- [H|T] = L, (X = H ; member(T,X)).


% -------- NOT --------
not(X) :- X, !, fail.
not(_).


% -------- REVERSE --------
rev_helper([],I,I).
rev_helper([H|T],I,R) :- P = [H|I], rev_helper(T,P,R).

reverse_list(L,R) :- rev_helper(L,[],R).


% -------- APPEND (your version fixed) --------
append_h([],L,L).
append_h([H|T],L2,LA) :-
    append_h(T,[H|L2],LA).

append_list(L1,L2,LA) :-
    reverse_list(L1,R),
    append_h(R,L2,LA).


% -------- PALINDROME --------
is_palindrome(L) :-
    reverse_list(L,R),
    L = R.


% -------- EVEN LENGTH --------
even_len([]).
even_len([_,_|T]) :-
    even_len(T).


% -------- REMOVE DUPLICATES (keep first occurrence) --------
remove_duplicate([], []).
remove_duplicate([H|T], [H|R]) :-
    not(member(R,H)),
    remove_duplicate(T, R).
remove_duplicate([H|T], R) :-
    member(R,H),
    remove_duplicate(T, R).