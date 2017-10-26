% Copyright

interface trace
    open core

predicates
    trace:(...).
    w:(...).

predicates
    tracef:(string Format [formatstring],...).
    wf:(string Format [formatstring],...).


end interface trace