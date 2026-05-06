shirt(s1).
shirt(s2).

pants(p1).
pants(p2).

person(skc).
person(ss).

colour(s1, red).
colour(p1, green).
colour(s2, blue).
colour(p2, violet).

wears(skc, s1).
wears(ss, s2).
wears(skc, p1).
wears(ss, p2).

complement(red, green).
complement(blue, orange).
complement(orange, blue).
complement(green, red).

wears_shirt(Person, Shirt):-
    wears(Person, Shirt),
    shirt(Shirt).

wears_pants(Person, Pants):-
    wears(Person, Pants),
    pants(Pants).

well_dressed(Person):-
    wears_shirt(Person, Shirt),
    wears_pants(Person, Pants),
    colour(Shirt, C1),
    colour(Pants, C2),
    complement(C1, C2).