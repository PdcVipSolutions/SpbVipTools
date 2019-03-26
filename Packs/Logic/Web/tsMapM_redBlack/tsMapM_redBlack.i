% Copyright PDCSPB

interface tsMapM_redBlack{@Key, @Data}
    open core
predicates
    tsSet : (@Key Key, @Data Value).

predicates
    tsGet : (@Key Key) -> @Data Value.

predicates
    tsGet_nd : () -> tuple{@Key Key,@Data Value} nondeterm.

predicates
    tsRemoveKey : (@Key Key).

end interface tsMapM_redBlack