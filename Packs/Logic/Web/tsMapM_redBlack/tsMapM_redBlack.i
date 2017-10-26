% Copyright PDCSPB

interface tsMapM_redBlack{@Key, @Data}

predicates
    tsSet : (@Key Key, @Data Key).

predicates
    tsGet : (@Key Key) -> @Data Value.

predicates
    tsRemoveKey : (@Key Key).

end interface tsMapM_redBlack