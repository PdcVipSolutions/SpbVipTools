% Copyright (c) Victor Yukhtenko

interface timerTick
    open core

properties
    tickName_P:string.
    tickInterval_P:integer. %100 nanoseconds
    tickOnce_P:boolean. % if true, then runs once, no stop needed.
    isRunning_P:boolean.
    tickActor_P:predicate.
    waitableTimer_P:waitableTimer.

predicates
    run:().  % starts the ticking process.
    stop:(). % stops the ticking process.

end interface timerTick