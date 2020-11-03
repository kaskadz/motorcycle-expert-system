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
  why(ans1).

motorcycle(cruiser) :-
  why(ans2).

motorcycle(sport) :-
  why(ans3).


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
answer(ans1) :-
  write('1').

answer(ans2) :-
  write('2').

answer(ans3) :-
  write('3').

answer(ans4) :-
  write('4').

answer(ans5) :-
  write('5').

answer(ans6) :-
  write('6').

answer(ans7) :-
  write('7').

answer(ans8) :-
  write('8').


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
  ask(why, Answer, [ans1, ans2, ans3]).


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