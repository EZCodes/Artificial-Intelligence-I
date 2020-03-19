%:- set_prolog_stack(local,  limit(10 000 000 000)). %need big stack here
:- dynamic qn/5.
%Knowledge Base
% p(+state,+action,+resultState, ?probability)
p(fit, exercise, dead, 0.1).
p(unfit, exercise, dead, 0.1).
p(dead, exercise, dead, 1).
p(dead,exercise, fit, 0).
p(dead,exercise, unfit, 0).
p(fit, exercise, fit, P) :- P is 0.99*0.9.
p(fit, exercise, unfit, P) :- P is 0.01*0.9.
p(unfit, exercise, fit, P) :- P is 0.2* 0.9.
p(unfit, exercise, unfit, P) :- P is 0.8*0.9.

p(fit, relax, dead, 0.01).
p(unfit, relax, dead, 0.01).
p(dead, relax, dead, 1).
p(dead,relax, fit, 0).
p(dead,relax, unfit, 0).
p(fit, relax, fit, P) :- P is 0.7*0.99.
p(fit, relax, unfit, P) :- P is 0.3*0.99.
p(unfit, relax, fit, P) :- P is 0* 0.99.
p(unfit, relax, unfit, P) :- P is 1*0.99.
 
% r(+state, +action, +endState, ?reward)
r(fit, exercise, dead, 0).
r(unfit, exercise, dead, 0).
r(dead, exercise, dead, 0).
r(dead, exercise, fit, 0).
r(dead, exercise, unfit, 0).
r(fit, exercise, fit, 8).
r(fit, exercise, unfit, 8). 
r(unfit, exercise, fit, 0).
r(unfit, exercise, unfit, 0).

r(fit, relax, dead, 0).
r(unfit, relax, dead, 0).
r(dead, relax, dead, 0).
r(dead, relax, fit, 0).
r(dead, relax, unfit, 0).
r(fit, relax, fit, 10).
r(fit, relax, unfit, 10).
r(unfit, relax, fit, 5).
r(unfit, relax, unfit, 5).

%Computations

q(State, Action, NewN, DiscValue, TotalSum) :- NewN > 0,!,N is NewN-1, q(State,Action, 0, DiscValue, Result0), p(State, Action, fit, P1), v(fit, N, DiscValue, Result1), p(State, Action, unfit, P2), v(unfit, N, DiscValue, Result2), p(State,Action,dead,P3), v(dead,N,DiscValue,Result5), Result6 is Result5*P3, Result3 is P1*Result1, Result4 is Result2*P2, TotalSum is Result0+(DiscValue*(Result3+Result4+Result6)). 
%, write_term(TotalSum,[nl(true)])
q(State, Action, 0, _, Result) :- p(State,Action,fit,P1),r(State,Action,fit,R1), p(State,Action,unfit,P2),r(State,Action,unfit,R2), p(State,Action,dead,P3), r(State,Action,dead,R3),Result is (P1*R1)+(P2*R2)+(P3*R3).
%memoisation to save time
v(State,N,DiscValue,Result) :-((qn(State, exercise, N, DiscValue, R1), qn(State, relax, N, DiscValue, R2),!); (q(State, exercise, N, DiscValue, R1), q(State, relax, N, DiscValue, R2), assert(qn(State, exercise, N, DiscValue, R1)), assert(qn(State, relax, N, DiscValue, R2)), !)), max(R1,R2,Result). 

max(X,Y,R) :- X >= Y, R is X.
max(X,Y,R) :- X < Y, R is Y.

show(N, State, DiscValue) :- forall((between(0,N,X), q(State, exercise, X, DiscValue, Result1), q(State,relax,X,DiscValue,Result2)), (write('n= '),write(X), write(' exercise: '), write(Result1), write(' relax: '), write_term(Result2,[nl(true)]))).










