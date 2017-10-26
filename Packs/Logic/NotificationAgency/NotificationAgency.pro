/*******************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions\Packs

Author: Victor Yukhtenko
********************************************************/
implement notificationAgency
    open core

/*************
End of Exceptions
*************/
domains
    listener_D=
        nl_f(notificationListenerFiltered,value);
        nl_n(notificationListener).

facts - listeners_FB
    notificationListener_F : (listener_D).

clauses
    subscribe(Listener,Filter) :-
        assertZ(notificationListener_F(nl_f(Listener,Filter))).

    subscribe(Listener) :-
        assertZ(notificationListener_F(nl_n(Listener))).

clauses
    subscribeA(Listener,Filter) :-
        assertA(notificationListener_F(nl_f(Listener,Filter))).

    subscribeA(Listener) :-
        assertA(notificationListener_F(nl_n(Listener))).

clauses
    unSubscribe(Listener) :-
        retract(notificationListener_F(nl_n(Listener))),
        !.
    unSubscribe(_Listener) :-
        exception::raise_User
            (
            "An Attempt To Remove Unknown (not added) Listener"
            ).

    unSubscribeFiltered(Listener) :-
        retract(notificationListener_F(nl_f(Listener,_Filter))),
        !.
    unSubscribeFiltered(_Listener) :-
        exception::raise_User
            (
            "An Attempt To Remove Unknown (not added) Filtered Listener"
            ).

clauses
    unSubscribeAll():-
        retractFactDb(listeners_FB).

clauses
    notify(Request,EventCausedObject,EventID,Value):-
        notificationListener_F(EventListener),
            if EventListener=nl_F(ListenerFiltered,EventID) then
                try
                	ListenerFiltered(This, EventCausedObject, Value)
                catch Err1 do
                	exception::continue_User(Err1, string::format("Unexpected exception while invoking the Listener %s", toString(ListenerFiltered)))
                end try
            else
                EventListener=nl_n(ListenerNonFiltered),
                try
                	ListenerNonFiltered(Request, This, EventCausedObject, EventID, Value)
                catch Err2 do
                	exception::continue_User(Err2, string::format("Unexpected exception while invoking the Listener %s", toString(ListenerNonFiltered)))
                end try

            end if,
        fail.
    notify(_,_,_,_).

clauses
    notify(EventCausedObject,EventID,Value):-
        notify(uncheckedConvert(object,0),EventCausedObject,EventID,Value).

end implement notificationAgency
