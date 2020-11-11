% User answers are stored here
:- dynamic(ans/2).

% Clear stored user answer_record entries
reset_ans :-
  retract(ans(_)).
reset_ans.

% motorcycle
motorcycle(adv).
motorcycle(cruiser).
motorcycle(sport).
motorcycle(naked).
motorcycle(moped).
motorcycle(touring).
motorcycle(sport_touring).
motorcycle(dualsport).
motorcycle(cross).
motorcycle(funbike).

% why
premise(adv, why_travel).
premise(cruiser, why_relax).
premise(sport, why_for_fun).
premise(naked, why_for_fun).
premise(naked, why_commute).
premise(moped, why_commute).

% distance
premise(X, distance_near) :- premise(X, distance_mid).
premise(X, distance_mid) :- premise(X, distance_long).

premise(adv, distance_long).
premise(cruiser, distance_long).
premise(sport, distance_mid).
premise(naked, distance_near).
premise(moped, distance_near).

% experience
premise(X, experience_mid) :- premise(X, experience_big).
premise(X, experience_small) :- premise(X, experience_mid).
premise(X, experience_no) :- premise(X, experience_small).

premise(adv, experience_big).
premise(cruiser, experience_mid).
premise(sport, experience_mid).
premise(naked, experience_small).
premise(moped, experience_no).

% roads

% track

% position


% deduction
% deduce(Answer) :-
%   (\+ ans(why, _); (ans(why, X), why(Answer, X))),
%   (\+ ans(experience, _); (ans(experience, Y), experience(Answer, Y))),
%   (\+ ans(distance, _); (ans(distance, Z), distance(Answer, Z))).

% why(Answer) :-
%   answer_record(why, Answer).
% why(Answer) :-
%   \+ answer_record(why, _),
%   ask(why, Answer, [why_commute, why_for_fun, why_relax, why_travel]).
% asserta(answer_record(Question, Response)),

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
  write('No').

answer(track_sometimes) :-
  write('Sometimes').

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
  write('Cruiser'), nl,
  write('Large, heave motorcycles, more popular under the name Harley-Davidson. At low to moderate speeds, cruisers are more comfortable than other styles.'), nl,
  write('Being designed primarily for visual effect, choppers will not usually be the most efficient riding machines.').

describe(sport) :-
  write('Sport'), nl,
  write('Sport bikes emphasize top speed, acceleration, braking, handling and grip on paved roads, typically at the expense of comfort and fuel economy.'), nl,
  write('Really fast but extremaly dangerous, not appropriate for beginners.').

describe(touring) :-
  write('Touring'), nl,
  write('Long distance motorcycle, typically with a large engine and a lot of storage. Pretty comfortable and doesnt require a lot of skill.'), nl,
  write('.').

describe(sport-touring) :-
  write('Sport-touring'), nl,
  write('Sport touring motorcycles combine attributes of sport bikes and touring motorcycles. The rider posture is less extreme than a sport bike, giving greater long-distance comfort.'), nl,
  write('The distinction between touring and sport touring is not always clear as some manufacturers will list the same bike in either category in different markets.').

describe(dualsport) :-
  write('Dual-sport'), nl,
  write('Typically based on a dirt bike chassis, they have added lights, mirrors, signals, and instruments that allow them to be licensed for public roads.'), nl,
  write('The seat height is generally a little taller to navigate the backroads and off beaten paths you can find on the backroads.').

describe(cross) :-
  write('Cross'), nl,
  write('Such bikes are raced on short, closed off-road tracks with a variety of obstacles. The motorcycles have a small fuel tank for lightness and compactness.'), nl,
  write('Deffinitely not for beginners, only for people with specific needs, who knows what they are doing.').

describe(moped) :-
  write('Moped'), nl,
  write('The Moped has a lighter frame based on a bicycle style and a smaller engine (50cc or less) or even an electric motor in place of the engine.'), nl,
  write('Pretty vintage but really good for short distances and for beginners.').

describe(naked) :-
  write('Naked'), nl,
  write('General-purpose street motorcycles. They are recognized primarily by their upright riding position, partway between the reclining rider posture of the cruisers and the forward leaning sport bikes.'), nl,
  write('Because of their flexibility, lower costs, and moderate engine output, standards are particularly suited to motorcycle beginners.').

describe(funbike) :-
  write('Funbike'), nl,
  write('Small bikes (in size, weight and displacement) that may serve as short distance travel means, but generally they main purpose is to have fun on them.').
