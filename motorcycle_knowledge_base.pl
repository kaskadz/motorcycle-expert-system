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
  disqualifying(distance, near),
  optional(roads, paved),
  optional(roads, gravel),
  optional(weight, heavy),
  optional(seat, high),
  optional(luggage, big),
  optional(torque, high),
  optional(riding_position, horse),
  optional(top_speed, high),
  optional(fairing, some).

motorcycle(dualsport) :-
  optional(why, travel),
  optional(why, fun),
  optional(experience, small),
  optional(distance, mid),
  optional(roads, paved),
  optional(roads, gravel),
  optional(roads, off),
  optional(weight, high),
  optional(seat, mid),
  optional(luggage, small),
  optional(torque, mid),
  optional(riding_position, horse),
  optional(top_speed, mid),
  optional(fairing, some).

motorcycle(off_road) :-
  required(why, fun),
  optional(experience, no),
  optional(distance, near),
  optional(roads, gravel),
  optional(roads, off),
  optional(weight, light),
  optional(seat, high),
  optional(riding_position, horse),
  optional(top_speed, low),
  optional(fairing, no).

motorcycle(cruiser) :-
  optional(why, relax),
  optional(why, commute),
  optional(experience, mid),
  optional(distance, mid),
  disqualifying(distance, near),
  optional(roads, paved),
  disqualifying(roads, gravel),
  disqualifying(roads, off),
  optional(weight, mid),
  optional(seat, low),
  optional(luggage, small),
  optional(torque, high),
  optional(riding_position, relaxed),
  optional(top_speed, mid),
  optional(fairing, no).

motorcycle(touring) :-
  optional(why, travel),
  optional(experience, big),
  optional(distance, long),
  disqualifying(distance, near),
  optional(roads, paved),
  disqualifying(roads, gravel),
  disqualifying(roads, off),
  optional(weight, heavy),
  optional(seat, mid),
  optional(luggage, big),
  optional(torque, mid),
  optional(riding_position, relax),
  optional(top_speed, high),
  optional(fairing, full).

motorcycle(sport_touring) :-
  optional(why, travel),
  optional(experience, mid),
  optional(distance, long),
  disqualifying(distance, near),
  optional(roads, paved),
  disqualifying(roads, gravel),
  disqualifying(roads, off),
  optional(weight, heavy),
  optional(seat, mid),
  optional(luggage, big),
  optional(torque, big),
  optional(riding_position, half_sport),
  optional(top_speed, super_high),
  optional(fairing, full).

motorcycle(sport) :-
  optional(why, fun),
  optional(experience, mid),
  optional(distance, mid),
  optional(roads, paved),
  disqualifying(roads, gravel),
  disqualifying(roads, off),
  optional(weight, mid),
  optional(seat, high),
  optional(luggage, no),
  optional(torque, mid),
  optional(riding_position, sport),
  optional(top_speed, super_high),
  optional(fairing, full).

motorcycle(moped) :-
  optional(why, commute),
  optional(experience, no),
  optional(distance, near),
  optional(roads, paved),
  optional(roads, gravel),
  disqualifying(roads, off),
  optional(weight, light),
  optional(seat, low),
  optional(luggage, small),
  optional(torque, low),
  optional(riding_position, horse),
  optional(top_speed, low),
  optional(fairing, full),
  optional(fairing, some).

motorcycle(naked) :-
  optional(why, commute),
  optional(experience, small),
  optional(distance, mid),
  optional(roads, paved),
  disqualifying(roads, gravel),
  disqualifying(roads, off),
  optional(weight, mid),
  optional(seat, mid),
  optional(luggage, no),
  optional(torque, mid),
  optional(riding_position, horse),
  optional(riding_position, half_sport),
  optional(top_speed, high),
  optional(fairing, no).

motorcycle(funbike) :-
  required(why, fun),
  optional(experience, no),
  optional(distance, near),
  optional(roads, paved),
  disqualifying(roads, gravel),
  disqualifying(roads, off),
  optional(weight, light),
  optional(seat, low),
  optional(luggage, no),
  optional(torque, mid),
  optional(riding_position, horse),
  optional(top_speed, low),
  optional(fairing, no).

% symptom kinds
required(Type, Value) :-
  preference(Type, Value).

optional(Type, Value) :-
  \+ preference(Type, _); preference(Type, Value).

no_preference(Type) :-
  \+ preference(Type, _).

disqualifying(Type, Value) :-
  \+ preference(Type, Value).

% symptoms
preference(Type, Value) :-
  ans(Type, Value).

% experience: big, mid, small, no
preference(experience, mid) :- preference(experience, big).
preference(experience, small) :- preference(experience, mid).
preference(experience, no) :- preference(experience, small).

% distance: long, mid, near
preference(distance, long) :- preference(distance, mid).
preference(distance, mid) :- preference(distance, near).

% weight: heavy, mid, light
preference(weight, mid) :- preference(weight, heavy).
preference(weight, light) :- preference(weight, mid).

% seat_height: high, mid, low
preference(seat, mid) :- preference(seat, high).
preference(seat, low) :- preference(seat, mid).

% luggage: big, small, no
preference(luggage, big) :- preference(luggage, small).
preference(luggage, small) :- preference(luggage, no).

% torque: high, mid, low
preference(torque, high) :- preference(torque, mid).
preference(torque, mid) :- preference(torque, low).

% top_speeds: super_high, high, mid, low
preference(top_speed, super_high) :- preference(top_speed, high).
preference(top_speed, high) :- preference(top_speed, mid).
preference(top_speed, mid) :- preference(top_speed, low).

% roads: paved, grave, off, any

% riding_position: horse, sport, half_sport, relaxed
% why: travel, fun, commute, relax
% fairing: no, some, full

