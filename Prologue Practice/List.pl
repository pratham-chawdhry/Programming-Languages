% append two lists
myappend([], L, L).
myappend([H|T], L2, [H|R]) :-
    myappend(T, L2, R).

% reverse list
myreverse([], []).
myreverse([H|T], R) :-
    myreverse(T, RT),
    myappend(RT, [H], R).

% check palindrome
is_palindrome(L) :-
    myreverse(L, L).

% even length list
even_len([]).
even_len([_,_|T]) :-
    even_len(T).

% membership check
mymember(X, [X|_]).
mymember(X, [_|T]) :-
    mymember(X, T).

% remove duplicates (keep last occurrence)
remove_duplicate([], []).
remove_duplicate([H|T], R) :-
    mymember(H, T),
    remove_duplicate(T, R).
remove_duplicate([H|T], [H|R]) :-
    \+ mymember(H, T),
    remove_duplicate(T, R).