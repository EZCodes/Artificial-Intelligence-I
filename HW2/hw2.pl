% p(+state,+action,+resultState, ?probability)
p(fit, exercise, dead, 0.1).
p(unfit, exercise, dead, 0.1).
p(dead, exercise, dead, 1).
p(fit, exercise, fit, P) :- P is 0.99*0.9.
p(fit, exercise, unfit, P) :- P is 0.01*0.9.
p(unfit, exercise, fit, P) :- P is 0.2* 0.9.
p(unfit, exercise, unfit, P) :- P is 0.8*0.9.

p(fit, relax, dead, 0.01).
p(unfit, relax, dead, 0.01).
p(dead, relax, dead, 1).
p(fit, relax, fit, P) :- P is 0.7*0.99.
p(fit, relax, unfit, P) :- P is 0.3*0.99.
p(unfit, relax, fit, P) :- P is 0* 0.99.
p(unfit, relax, unfit, P) :- P is 1*0.99.
 
% r(+state, +action, +endState, ?reward)
r(fit, exercise, dead, 0).
r(unfit, exercise, dead, 0).
r(dead, exercise, dead, 0).
r(fit, exercise, fit, 8).
r(fit, exercise, unfit, 8). 
r(unfit, exercise, fit, 0).
r(unfit, exercise, unfit, 0).

r(fit, relax, dead, 0).
r(unfit, relax, dead, 0).
r(dead, relax, dead, 0).
r(fit, relax, fit, 10).
r(fit, relax, unfit, 10).
r(unfit, relax, fit, 5).
r(unfit, relax, unfit, 5).

%computations

% q0(+State,+Action,?Result)
q0(State, Action, Result) :- p(State,Action,fit,P1),r(State,Action,fit,R1), p(State,Action,unfit,P2),r(State,Action,unfit,R2), p(State,Action,dead,P3), r(State,Action,dead,R3),Result is (P1*R1)+(P2*R2)+(P3*R3).





