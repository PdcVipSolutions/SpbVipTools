/*****************************************************************************

Copyright (c) Victor Yukhtenko

******************************************************************************/

interface pzlRegistry
    open core

predicates % Object registration
    register:(string ObjectName,object Object) procedure.
    registerMulti:(string ObjectName,object Object) procedure.
    getObjectByName_nd:(string ObjectName)->object Object nondeterm.
    getNamebyObject_nd:(object Object)->string ObjectNameLow nondeterm.
    getNameAndObject_nd:(string ObjectName,object Object) nondeterm (o,o).
    unRegister:(string ObjectName,object Object) procedure.
    unRegisterByName:(string ObjectName) procedure.
    unRegisterAllByNamePrefix:(string ObjectNamePrefix) procedure.
    unRegisterByObject:(object Object) procedure.
    unRegisterAll:() procedure.

end interface pzlRegistry