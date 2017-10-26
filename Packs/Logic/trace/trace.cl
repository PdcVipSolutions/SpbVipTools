% Copyright (c) PDCSPB

class trace : trace
    open core

constructors
    start:(...).

predicates
    set:(string Name,trace TraceObj).

predicates
    get:(string Name)->trace TraceObj.

predicates
    kill:(string Name).

end class trace