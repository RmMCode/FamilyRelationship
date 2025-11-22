/* ---------------- FACTS ---------------- */
/* Spouse relationships */
spouse(i, widow).
spouse(dad, redhair).

/* Gender facts */
male(i).
male(dad).
male(onrun).
male(baby).

female(widow).
female(redhair).

/* Child relationships (minimized set) */
child(redhair, widow). % biological daughter of widow
child(i, dad).         % i is biological son of dad
child(onrun, dad).     % onrun is biological son of dad
child(baby, i).        % baby is biological son of i

/* ---------------- BASIC RULES ---------------- */
/* PARENT = biological OR step-parent */
/* Biological parent */
parent(P, C) :- child(C, P).

/* Treat stepparent as parent */
parent(P, C) :- step_parent(P, C).

/* Step-parent (married to biological parent only — no recursion) */
step_parent(S, C) :-
    married(S, P),
    child(C, P),
    S \= P.

/* Mother Father */
mother(M, C) :- parent(M, C), female(M).
father(F, C) :- parent(F, C), male(F).

/* Spouse symmetry */
married(X, Y) :- spouse(X, Y).
married(X, Y) :- spouse(Y, X).

/* In-law rules */
parent_in_law(InLaw, X) :-
    married(X, Spouse),
    parent(InLaw, Spouse).

son_in_law(SonInLaw, Parent) :-
    married(SonInLaw, Child),
    parent(Parent, Child),
    male(SonInLaw).

daughter_in_law(DIL, Parent) :-
    married(DIL, Child),
    parent(Parent, Child),
    female(DIL).

/* ---------------- GRANDPARENT RELATIONSHIPS ---------------- */
grandparent(GP, GC) :-
    parent(GP, P),
    parent(P, GC).

grandmother(GM, GC) :-
    grandparent(GM, GC),
    female(GM).

grandfather(GF, GC) :-
    grandparent(GF, GC),
    male(GF).

grandchild(C, GP) :- grandparent(GP, C).

/* ---------------- SIBLINGS ---------------- */
sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \= Y.

brother(B, X) :- sibling(B, X), male(B).
sister(S, X) :- sibling(S, X), female(S).

/* Sibling-in-law */
sibling_in_law(X, Y) :-
    married(X, S),
    sibling(S, Y).

sibling_in_law(X, Y) :-
    married(Y, S),
    sibling(X, S).

/* SON/DAUGTHER */
daughter(D, P) :-
    parent(P, D),
    female(D).

son(S, P) :-
    parent(P, S),
    male(S).

/* ---------------- UNCLE/AUNT ---------------- */
uncle(U, X) :-
    brother(U, P),
    parent(P, X).

uncle(U, X) :-                % uncle by marriage
    sibling_in_law(U, P),
    parent(P, X).

aunt(A, X) :-
    sister(A, P),
    parent(P, X).

aunt(A, X) :-
    sibling_in_law(A, P),
    parent(P, X).

/* ---------------- RUN TEST CASES (as shown in PDF) ---------------- */
runIt :-
    write('Is redhair the daughter of i?: '),
    ( daughter(redhair, i) -> write('Yes') ; write('No') ), nl,

    write('Is redhair the mother of i?: '),
    ( mother(redhair, i) -> write('Yes') ; write('No') ), nl,

    write('Is dad the son in law of i?: '),
    ( son_in_law(dad, i) -> write('Yes') ; write('No') ), nl,

    write('Is baby the brother of dad?: '),
    ( brother(baby, dad) -> write('Yes') ; write('No') ), nl,

    write('Is baby the uncle of i?: '),
    ( uncle(baby, i) -> write('Yes') ; write('No') ), nl,

    write('Is baby the brother of redhair?: '),
    ( brother(baby, redhair) -> write('Yes') ; write('No') ), nl,

    write('Is onrun the grandchild of i?: '),
    ( grandchild(onrun, i) -> write('Yes') ; write('No') ), nl,

    write('Is widow the mother of redhair?: '),
    ( mother(widow, redhair) -> write('Yes') ; write('No') ), nl,

    write('Is widow the grandmother of i?: '),
    ( grandmother(widow, i) -> write('Yes') ; write('No') ), nl,

    write('Is i the grandchild of widow?: '),
    ( grandchild(i, widow) -> write('Yes') ; write('No') ), nl,

    write('Is i the grandfather of i?: '),
    ( grandfather(i, i) -> write('Yes') ; write('No') ), nl.