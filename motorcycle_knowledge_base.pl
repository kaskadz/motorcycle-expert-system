% User answers are stored here
:- dynamic(ans/2).

save(Type, Value) :-
  asserta(ans(Type, Value)).

% Clear stored user ans entries
reset :-
  retractall(ans(_, _)).

% Rules for the knowledge base
motorcycle(adv) :-
  optional(why, travel),
  optional(experience, big),
  optional(distance, long),
  disqualifying(distance, near).

motorcycle(cruiser) :-
  optional(why, relax),
  optional(experience, mid),
  optional(distance, long).

motorcycle(sport) :-
  optional(why, fun),
  optional(experience, mid),
  optional(distance, mid).

motorcycle(moped) :-
  optional(why, commute),
  optional(experience, no),
  optional(distance, near).

motorcycle(naked) :-
  optional(why, commute),
  optional(experience, small),
  optional(distance, mid).

% symptom kinds
required(Type, Value) :-
  premise(Type, Value).

optional(Type, Value) :-
  \+ premise(Type, _); premise(Type, Value).

no_preference(Type) :-
  \+ premise(Type, _).

disqualifying(Type, Value) :-
  \+ premise(Type, Value).

% symptoms
premise(Type, Value) :-
  ans(Type, Value).

% experience
premise(experience, mid) :- premise(experience, big).
premise(experience, small) :- premise(experience, mid).
premise(experience, no) :- premise(experience, small).

% distance
premise(distance, long) :- premise(distance, mid).
premise(distance, mid) :- premise(distance, near).

% roads
% premise(roads, paved) :- premise(roads, gravel).
% premise(roads, gravel) :- premise(roads, no).

describe(why, travel) :-
  writeln("I want to travel.").