/*******************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions\Packs

Author: Victor Yukhtenko
********************************************************/
interface notificationAgency
    open core

domains
    notificationListener = (object Request,notificationAgency NotificationOffice,object EventCausedObject, value EventID, value Value).

domains
    notificationListenerFiltered = (notificationAgency NotificationOffice,object EventCausedObject, value Value).

predicates
    subscribe:(notificationListener NotificationListener).

predicates
    subscribe:(notificationListenerFiltered NotificationListener,value Filter).

predicates
    subscribeA:(notificationListener NotificationListener).

predicates
    subscribeA:(notificationListenerFiltered NotificationListener,value Filter).

predicates
    unSubscribe:(notificationListener NotificationListener).

predicates
    unSubscribeFiltered:(notificationListenerFiltered NotificationListener).

predicates
    unSubscribeAll:().

predicates
    notify:(object Request,object EventCausedObject,value EventID,value Value).

predicates
    notify:(object EventCausedObject,value EventID,value Value).

end interface notificationAgency