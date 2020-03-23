%

interface cancelableInterval
    open core

properties
    interval_P:integer. %milisecinds
    actor_P:predicate.

predicates
    run:().  % starts the interval. Actor is called when interval ends.
    stop:(). % ends the interval. Actor is not called.

end interface cancelableInterval
