/* Exo 1 */

% Explication :
% TODO

([
    (proc {P X Y} ... end, {Browse->browse, P->p, Z->z}),
    (local B A in ... end, {Browse->browse, P->p})
 ],{
    browse=(proc {$ X} ... end, {...}),
    p, z=1
 })
=> % TODO on rajoute toute la proc sans rien evaluer? C'est bien ça le concept de lazy evaluation ?
([
    (local B A in ... end, {Browse->browse, P->p})
 ],{
    browse=(proc {$ X} ... end, {...}),
    p=(proc {P X Y} Y=X+Z end, {Browse->browse, P->p, Z->z}),
    z=1,
 })
=>
([
    (A=10
     {P A B}
     {Browse B}, {Browse->browse, P->p, A->a, B->b})
 ],{
    browse=(proc {$ X} ... end, {...}),
    p=(proc {P X Y} Y=X+Z end, {Browse->browse, P->p, Z->z}),
    z=1, a, b
 })
=>
([
    ({P A B}
     {Browse B}, {Browse->browse, P->p, A->a, B->b})
 ],{
    browse=(proc {$ X} ... end, {...}),
    p=(proc {P X Y} Y=X+Z end, {Browse->browse, P->p, Z->z}),
    z=1, a=10, b
 })
=> % TODO est-ce que l'on rajoute la proc à la stack ?
([
    (B=A+Z end, {Browse->browse, P->p, Z->z, B->b, A->a}),
    ({Browse B}, {Browse->browse, P->p, A->a, B->b})
 ],{
    browse=(proc {$ X} ... end, {...}),
    p=(proc {P X Y} Y=X+Z end, {Browse->browse, P->p, Z->z}),
    z=1, a=10, b
 })
=>
([
    ({Browse B}, {Browse->browse, P->p, A->a, B->b})
 ],{
    browse=(proc {$ X} ... end, {...}),
    p=(proc {P X Y} Y=X+Z end, {Browse->browse, P->p, Z->z}),
    z=1, a=10, b=11
 })
=>
([],{
    browse=(proc {$ X} ... end, {...}),
    p=(proc {P X Y} Y=X+Z end, {Browse->browse, P->p, Z->z}),
    z=1, a=10, b=11
 })
% End of program


/* Exo 2 */

local MakeMulFilter IsPrime Filter L1 MulFilter3 MulFilter2 in
    fun {MakeMulFilter N}
        fun {$ I} (I mod N)==0 end
    end
    fun {Filter L F}
        case L
        of nil then nil
        [] H|T then
            if {F H} then H|{Filter T F}
            else {Filter T F}
            end
        end
    end
    fun {IsPrime N}
        fun {IsDivisible I}
            if I*I > N then true
            elseif (N mod I)==0 then false
            else {IsDivisible I+1}
            end
        end
    in
        if N < 2 then false
        else {IsDivisible 2}
        end
    end
    L1=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]
    MulFilter2={MakeMulFilter 2} % Nombres pairs
    MulFilter3={MakeMulFilter 3} % Multiples de 3
    {Browse {Filter L1 MulFilter2}} % Liste contenant uniquement les nombres pairs
    {Browse {Filter L1 MulFilter3}} % Liste contenant uniquement les multiples de 3
    {Browse {Filter L1 IsPrime}}
end

% http://mozart2.org/mozart-v1/doc-1.4.0/base/list.html
{Browse {List.filter [1 2 3 4 5 6 7 8] fun {$ I} I=<4 end}}
{Browse {List.map [1 2 3 4 5 6 7 8] Number.'~'}}
{Browse {List.foldR [1 2 3 4] fun {$ X Acc} {Browse X#Acc} X*Acc end 1}} % commence par le dernier élement
{Browse {List.foldL [1 2 3 4] fun {$ Acc X} {Browse X#Acc} Acc*X end 1}} % commence par le premier élement


/* Exo 3 */

local
    fun {FoldL L F Acc} % tail-recursive
        case L
        of nil then Acc
        [] H|T then {FoldL T F {F Acc H}}
        end
    end
in
    {Browse {FoldL [1 2 3 4] Number.'*' 1}}
    {Browse {FoldL [1 2 3 4] Number.'-' 0}}
end

local
    fun {FoldR L F Acc} % not tail-recursive
        case L
        of nil then Acc
        [] H|T then {F H {FoldR T F Acc}}
        end
    end
in
    {Browse {FoldR [1 2 3 4] Number.'*' 1}}
    {Browse {FoldR [1 2 3 4] Number.'-' 0}}
end


/* Exo 4 */

local
    fun {Applique Xs F} % C'est la fonction List.map
        case Xs
        of nil then nil
        [] H|T then {F H}|{Applique T F}
        end
    end
    fun {MakePow E}
        fun {$ N}
            {Number.pow N E}
        end
    end
in
    {Browse {Applique [1 2 3 4 5] {MakePow 3}}}
end


/* Exo 5 */

local
    fun {Convertir T O V} T*V + O end
    fun {MakeConverter T O} fun {$ V} {Convertir T O V} end end
    PiedToMeter={MakeConverter 0.3048 0.}
    FahrenheitToCelcius={MakeConverter 0.56 ~17.78}
in
    {Browse {PiedToMeter 1000.}}
    {Browse {FahrenheitToCelcius 100.}}
end

/* Exo 6 */

local
    fun {PipeLine N}
        P1 P2 P3 in
        P1 = {GenerateList N}
        P2 = {MyFilter P1 fun {$ X} X mod 2 \= 0 end}
        P3 = {MyMap P2 fun {$ X} X * X end}
        {MyFoldL P3 fun {$ Acc X} X + Acc end 0}
    end
    fun {GenerateList N}
        if N == 0 then nil
        else N|{GenerateList N-1}
        end
    end
    fun {MyFilter L F}
        case L
        of nil then nil
        [] H|T then
            if {F H} then H|{MyFilter T F}
            else {MyFilter T F}
            end
        end
    end
    fun {MyMap L F}
        case L
        of nil then nil
        [] H|T then {F H}|{MyMap T F}
        end
    end
    fun {MyFoldL L F Acc}
        case L
        of nil then Acc
        [] H|T then {MyFoldL T F {F Acc H}}
        end
    end
in
    {Browse {PipeLine 5}}
end


/* Exo 7 */

local Y LB in
    Y=10
    LB=proc {$ X ?Z} %
        local Cond in %
            Cond=(X>=Y) %
            if Cond then Z=X %
            else Z=Y end
        end
    end
    local Y Z in %
        Y=15 %
        {LB 5 Z}
        {Browse Z}
    end
end

% TODO, when do I split a semantic instruction into multiple ?

([
    (Y=10
     LB=proc {$ X ?Z} %
        local Cond in %
            Cond=(X>=Y) %
            if Cond then Z=X %
            else Z=Y end
        end
    end
    local Y Z in %
        Y=15 %
        {LB 5 Z}
        {Browse Z}
    end
    ,{Browse->browse, Y->y1, LB->lb})
 ],{
    browse=(proc {$ X} ... end, {...}),
    y1, lb
 })
=>
([
    (LB=proc {$ X ?Z} %
        local Cond in %
            Cond=(X>=Y) %
            if Cond then Z=X %
            else Z=Y end
        end
    end
    local Y Z in %
        Y=15 %
        {LB 5 Z}
        {Browse Z}
    end
    ,{Browse->browse, Y->y1, LB->lb})
 ],{
    browse=(proc {$ X} ... end, {...}),
    y1=10, lb
 })
=>
([
    (
    local Y Z in %
        Y=15 %
        {LB 5 Z}
        {Browse Z}
    end
    ,{Browse->browse, Y->y1, LB->lb})
 ],{
    browse=(proc {$ X} ... end, {...}),
    y1=10,
    lb=(proc {$ X ?Z} %
        local Cond in %
            Cond=(X>=Y) %
            if Cond then Z=X %
            else Z=Y end
        end
    end, {Browse->browse, Y->y1, LB->lb})
 })
=>
([
    (
    Y=15 %
    {LB 5 Z}
    {Browse Z}
    ,{Browse->browse, Y->y2, LB->lb, Z->z})
 ],{
    browse=(proc {$ X} ... end, {...}),
    y1=10,
    lb=(proc {$ X ?Z} %
        local Cond in %
            Cond=(X>=Y) %
            if Cond then Z=X %
            else Z=Y end
        end
    end, {Browse->browse, Y->y1, LB->lb}),
    y2,
    z
 })
=>
([
    (
    {LB 5 Z}
    {Browse Z}
    ,{Browse->browse, Y->y2, LB->lb, Z->z})
 ],{
    browse=(proc {$ X} ... end, {...}),
    y1=10,
    lb=(proc {$ X ?Z} %
        local Cond in %
            Cond=(X>=Y) %
            if Cond then Z=X %
            else Z=Y end
        end
    end, {Browse->browse, Y->y1, LB->lb}),
    y2=15,
    z
 })
=>
% TODO fix the instruction split and continue
