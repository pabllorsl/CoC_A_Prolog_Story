%
%% IMPLEMENTAÇÕES FRONT
%

% Mostrar Team
thisIsYourTeam(Champions, Team, Party, Enemy) :- writeln("This is your team :"), printList(1, Team), selectYourParty(Champions, Team, Party, Enemy).

%Escolher Ordem da Party
selectYourParty(Champions, Team, Party, Enemy) :-
    writeln(" Select your party :"), 
    read(First),
    read(Second),
    read(Third),
    FirstIndex is First - 1,
    SecondIndex is Second - 1,
    ThirdIndex is Third - 1,
    getElement(FirstIndex, Team, Champ1),
    getElement(SecondIndex, Team, Champ2),
    getElement(ThirdIndex, Team, Champ3),
    addChampion(Champ1, Party, Party1),
    addChampion(Champ2, Party1, Party2),
    addChampion(Champ3, Party2, Party3),
    writeln("This is your party :"),
    printList(1, Party3),
    yourEnemy(Champions, Team, Party3, Enemy).

%Mostrar Inimigo
yourEnemy(Champions, Team, Party, Enemy) :- 
    writeln("This is your enemy :"),
    printList(1, Enemy),
    % SÓ PRA TESTAR %
    writeln(Champions),writeln(Team),writeln(Party).

% Printar todos os elementos de uma lista, enumerados
printList(N ,[H]) :- write(N), write(" - "), writeln(H).
printList(N, [H|T]) :- write(N), write(" - "), writeln(H), NewN is N + 1, printList(NewN,T).

%
%% FATOS
%
champion("Science", "Spider-Man", 200, 33, 50, 31).
champion("Skill", "Black Panther", 220, 38, 57, 30).
champion("Skill", "Winter Soldier", 240, 43, 65, 29).
champion("Science", "Captain America", 260, 48, 72, 28).
champion("Tech", "Iron Man", 280, 53, 80, 27).
champion("Mutant", "Wolverine", 300, 58, 87, 26).
champion("Mutant", "Deadpool", 320, 63, 95, 25).
champion("Mystic", "Loki", 340, 68, 102, 24).
champion("Tech", "Ultron", 360, 73, 110, 23).
champion("Mystic", "Doctor_Strange", 380, 78, 117, 22).
champion("Cosmic", "Thanos", 400, 83, 125, 21).
champion("Cosmic", "Thor", 420, 88, 132, 20).

% Ocorrências de vantagem
advantage("Mutant","Skill").
advantage("Skill","Science").
advantage("Science","Mystic").
advantage("Mystic","Cosmic").
advantage("Cosmic","Tech").
advantage("Tech","Mutant").

% Condição de derrota
battleLost(0,0,0).

%
%% IMPLEMENTAÇÕES DE MANIPULAÇÃO DE LISTAS
%

% Adiciona um campeão em uma lista.
addChampion(X, L, [X|L]).
addChampion(T, [H], L):- addChampion(H, [T], L).
addChampion(N, [H|T], L):- addChampion(N, T, X), addChampion(H, X, L).

% Remove um campeão de uma lista.
removeChampion(Y, [Y], []).
removeChampion(X, [X|List1], List1).
removeChampion(X, [Y|List], [Y|List1]):- removeChampion(X, List, List1).

% Obtém o campeão em uma lista a partir de um índice.
getElement(0, [H|_], H):- !.
getElement(Ind, [_|T], C):- Z is Ind - 1, getElement(Z, T, C).

% Obtém o índice de um campeão em uma lista.
getIndex(E, [E|_], 0):- !.
getIndex(E, [_|T], Ind):- getIndex(E, T, X), Ind is X + 1.

% Obtém o tamanho de uma lista.
tamL([_], 1):- !.
tamL([_|L], Tamanho) :- tamL(L, X), Tamanho is X+1.

%
%% IMPLEMENTAÇÕES BACK
%

% Cálculo do dano do atacante, considerando a defesa do defensor e a relacao de vantagem entre classes
calDamage(Damage, Defense, Atk, Def, Result) :- 
    Adv is Damage / 4, 
    calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv),
    Result is DamageAdv - Defense.

calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv) :-
    advantage(Atk,Def) -> DamageAdv is Damage + Adv ; DamageAdv is Damage.

% Recebe a lista de campeões e verifica se ela está com todos os 12 (vitória).
checkFinalVictory(Party, Result):-
    tamL(Party, Lenght),
    Lenght =:= 12 -> Result = true ; Result = false.

% Recebe o HP do campeão inimigo e verifica se ele estiver morto.
checkPartialVictory(ChampionHP, Result):-
    ChampionHP=< 0 -> Result = true ; Result = false.

% Recebe os três HPS dos campeões da party e verifica se todos estão derrotados
checkBattleLost(ChampHP1,ChampHP2,ChampHP3,Result):-
    battleLost(ChampHP1,ChampHP2,ChampHP3) -> Result = true ; Result = false.