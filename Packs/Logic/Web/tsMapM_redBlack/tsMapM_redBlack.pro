% Copyright PDCSPB

implement tsMapM_redBlack{@Key, @Data}

facts
    queues : mapM{@Key, @Data} := mapM_redBlack::new() [immediate].
    cs : criticalSection := criticalSection::new() [immediate].

clauses
    tsSet(Key, Data) :-
        cs:synchronize ({ :-
            queues:set(Key, Data)
         }).

clauses
    tsGet(Key) =
        cs:synchronize ({ =
            queues:get(Key)
         }).

clauses
    tsRemoveKey(Key) :-
        cs:synchronize ({ :-
            queues:removeKey(Key)
         }).

end implement tsMapM_redBlack