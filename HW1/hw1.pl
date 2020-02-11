%file setup
:- dynamic(kb/1).
makeKB(File):- open(File,read,Str),
	readK(Str,K),
	reformat(K,KB),
	asserta(kb(KB)),
	close(Str).

readK(Stream,[]):- at_end_of_stream(Stream),!.
readK(Stream,[X|L]):- read(Stream,X),
	readK(Stream,L).

reformat([],[]).
reformat([end_of_file],[]) :- !.
reformat([:-(H,B)|L],[[H|BL]|R]) :- !,
	mkList(B,BL),
	reformat(L,R).
reformat([A|L],[[A]|R]) :- reformat(L,R).

mkList((X,T),[X|R]) :- !, mkList(T,R).
mkList(X,[X]).

initKB(File) :- retractall(kb(_)), makeKB(File).

% actual code part
astar(Node,Path,Cost) :- kb(KB), astar(Node,Path,Cost,KB).
astar(Node,Path,Cost,KB) :- search([[[Node|[]]|0]],Cost,Path,KB).

% base case
search([[[Node|Path]|Cost]|_],Cost,[Node|Path],_) :- goal(Node),!.
% recursive
search([[[Node|Path]|Cost]|QueueTail],TCost,TPath,KB) :-  findall(Child,arc(Node,Child,KB),Children), add2frontier(Children,QueueTail,Cost,Path,Node,New), search(New,TCost,TPath,KB).
% abstract layer of priority queue, which add children
add2frontier([],Queue,_,_,_,Queue).
add2frontier([HChild|RestOfChildren],QTail,CCost,CPath,Node,New) :- add2queue(HChild,QTail,CCost,CPath,Node,NewQueue), add2frontier(RestOfChildren,NewQueue,CCost,CPath,Node,New).
% priority queue inserter
add2queue([Node|Cost], [[[QueueHead|HeadPath]|HeadCost]|Queue], PathCost, PathHistory, OldNode, [[[Node|NewPath]|NewCost],[[QueueHead|HeadPath]|HeadCost]|Queue]) :- less-than([Node|Cost],[[QueueHead|_]|HeadCost]), NewCost is PathCost + Cost, append([OldNode],PathHistory,NewPath),!.
% move to next element
add2queue(HChild,[H|T], PathCost, PathHistory, OldNode, [H|NewQueue]) :- add2queue(HChild,T, PathCost, PathHistory, OldNode, NewQueue). 
% if queue empty just add
add2queue([Node|Cost],[],PathCost,PathHistory,OldNode,[[[Node|NewPath]|NewCost]]) :- NewCost is PathCost + Cost, append(OldNode,PathHistory,NewPath).
% comparer
less-than([_|Cost1],[[_|_]|Cost2]) :- Cost1 =< Cost2.

% arc returns child of H and the cost of the transition to it, then adds a child to the path T and returns as Node.
arc([H|T],[Node|Cost],KB) :- member([H|B],KB), append(B,T,Node), length(B,L), Cost is L+1.

goal([]).

