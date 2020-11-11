% User answers are stored here
:- dynamic(ans/2).

% Clear stored user ans entries
reset_ans :-
  retractall(ans(_, _)).

% Rules for the knowledge base
motorcycle(adv) :-
  (\+ why(_); why(travel)),
  (\+ experience(_); experience(big)),
  (\+ distance(_); distance(long)).

motorcycle(cruiser) :-
  why(relax),
  experience(mid),
  distance(long).

motorcycle(sport) :-
  why(fun),
  experience(mid),
  distance(mid).

motorcycle(moped) :-
  why(commute),
  experience(no),
  distance(near).

motorcycle(naked) :-
  why(commute),
  experience(small),
  distance(mid).

% symptoms
% why
why(Answer) :-
  ans(why, Answer).

% experience
experience(mid) :- experience(big).
experience(small) :- experience(mid).
experience(no) :- experience(small).

experience(Answer) :-
  ans(experience, Answer).

% distance
distance(near) :- distance(mid).
distance(mid) :- distance(long).

distance(Answer) :-
  ans(distance, Answer).

% roads
roads(paved) :- roads(gravel).
roads(gravel) :- roads(no).

roads(Answer) :-
  ans(roads, Answer).

% track
track(Answer) :-
  ans(track, Answer).