/*****************************************************************************

                        Copyright (c) PDC-spb

******************************************************************************/

implement objectRegistrySupport
    open core

    constants
        className = "vpc/ComponentManager/objectRegistrySupport".
        version = "".

    clauses
        classInfo(className, version).
    clauses
        registerObject(_UserFriendlyName):-!.

    clauses
        tryGetObject(_UserFriendlyName)=ReferenceToObject:-!.
 
    clauses
        tryGetObjectUserFriendlyName(ReferenceToObject)=UserFriendlyName:-
            objectReg(UserFriendlyName,ReferenceToObject),
            !.
    
    clauses
        unRegisterByName(UserFriendlyName):-
            retract(objectReg(UserFriendlyName,_ReferenceToObject)),
            !.
        unRegisterByName(_UserFriendlyName).
    
    clauses
        unRegisterByReference(ReferenceToObject):-
            retract(objectReg(_UserFriendlyName,ReferenceToObject)),
            !.
        unRegisterByReference(_ReferenceToObject).
            
    clauses
        unregisterAll():-
            retractAll(_,objectRegistry_FB).
        
end implement objectRegistrySupport
