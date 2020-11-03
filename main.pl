% Entry point
main :-
  greeting,
  reset_answer_records,
  find_motorcycle(MotorcycleType),
  describe(MotorcycleType), nl.


greeting :-
  write('Which motorcycle should I get?'), nl,
  write('Type the answer number flowed by the dot.'), nl, nl.


find_motorcycle(MotorcycleType) :-
  motorcycle(MotorcycleType), !.


% User answers are stored here
:- dynamic(answer_record/2).


% Clear stored user answer_record entries
reset_answer_records :-
  retract(answer_record(_, _)).
reset_answer_records.


% Rules for the knowledge base
motorcycle(adv) :-
  why(why_travel),
  experience(experience_mid).

motorcycle(cruiser) :-
  why(why_relax).

motorcycle(sport) :-
  why(why_for_fun).


% Questions for the knowledge base
question(why) :-
  write('Why do you want to ride a motorcycle?'), nl.

question(distance) :-
  write('What distances do you want to travel?'), nl.

question(roads) :-
  write('Which roads (if any) do you want to travel?'), nl.

question(track) :-
  write('Do you want to have fun at a track?'), nl.

question(experience) :-
  write('How experienced you are?'), nl.

question(position) :-
  write('Which riding position is your favourite?'), nl.

question(fastboi) :-
  write('Are you a fastboi?'), nl.


% Answers for the knowledge base

% why
answer(why_commute) :-
  write('I want to commute fast in traffic.').

answer(why_for_fun) :-
  write('I want to have fun.').

answer(why_travel) :-
  write('I want to travel.').

answer(why_relax) :-
  write('I want to relax while riding.').

% distance
answer(distance_near) :-
  write('I want to travel within close range i.e. within settlement or 20 km distance.').

answer(distance_mid) :-
  write('I want to travel within medium range i.e. 20-100 km.').

answer(distance_long) :-
  write('I want to travel within long range i.e. 100+ km').

% roads
answer(roads_paved) :-
  write('Paved roads (tarmac, concrete, bricks)').

answer(roads_gravel) :-
  write('Gravel roads').

answer(roads_no) :-
  write('Roads? What is a road?!').

% track
answer(track_yes) :-
  write('Yes').

answer(track_no) :-
  write('Sometimes').

answer(track_sometimes) :-
  write('No').

% experience
answer(experience_no) :-
  write('No experience').

answer(experience_small) :-
  write('I have 1-2 years of experience').

answer(experience_mid) :-
  write('I have 3-5 years of experience').

answer(experience_big) :-
  write('I have 5+ years of experience').

% position
answer(position_relaxed) :-
  write('Relaxed').

answer(position_straight) :-
  write('Straight').

answer(position_half_sport) :-
  write('Half-sport').

answer(experience_big) :-
  write('Sport').

% fast-boi
answer(fastb_yes) :-
  write('Sure').

answer(fastb_no) :-
  write('Not at all').


% Motorcycle descriptions for the knowledge base
describe(adv) :-
  write('ADV-bike'), nl,
  write('Adventure motorcycle is a good choice for long, distant travels both on paved and gravel roads, it is also off-road capable to some extent.'), nl,
  write('These motorcycles are big and heavy, which makes them not so easy to handle, thus inappropriate for beginners.').

describe(cruiser) :-
  write('Cruiser').

describe(sport) :-
  write('Sport').

describe(touring) :-
  write('Touring').

describe(sport-touring) :-
  write('Sport-touring').

describe(dualsport) :-
  write('Dual-sport').

describe(cross) :-
  write('Cross').

describe(moped) :-
  write('Moped').

describe(naked) :-
  write('Naked').

describe(funbike) :-
  write('Funbike').


% Assign an answer to questions from the knowledge base
why(Answer) :-
  answer_record(why, Answer).
why(Answer) :-
  \+ answer_record(why, _),
  ask(why, Answer, [why_commute, why_for_fun, why_relax, why_travel]).

experience(Answer) :-
  answer_record(experience, Answer).
experience(Answer) :-
  \+ answer_record(experience, _),
  ask(experience, Answer, [experience_no, experience_small, experience_mid, experience_big]).


% Output formatted list of answers
answers([], _).
answers([First|Rest], Index) :-
  write(Index), write(' '), answer(First), nl,
  NextIndex is Index + 1,
  answers(Rest, NextIndex).


% Parse an Index and return a Response
parse(0, [First|_], First).
parse(Index, [First|Rest], Response) :-
  Index > 0,
  NextIndex is Index - 1,
  parse(NextIndex, Rest, Response).


% Ask the Question & save the Answer
ask(Question, Answer, Choices) :-
  question(Question),
  answers(Choices, 0),
  read(Index),
  parse(Index, Choices, Response),
  asserta(answer_record(Question, Response)),
  Response = Answer.