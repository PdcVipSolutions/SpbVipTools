% Copyright (c) Prolog Development Center SPB

interface entityRegistry {@Entity}
    open core

predicates % Entity registration
    register:(string EntityName,@Entity Entity) procedure (i,i).
    getEntityByName_nd:(string EntityName)->@Entity Entity nondeterm (i).
    getNameByEntity_nd:(@Entity Entity)->string EntityNameLow nondeterm (i).
    getNameAndEntity_nd:(string EntityName,@Entity Entity) nondeterm (o,o).
    unRegister:(string EntityName,@Entity Entity) procedure (i,i).
    unRegisterByName:(string EntityName) procedure (i).
    unRegisterByEntity:(@Entity Entity) procedure (i).
    unRegisterAll:() procedure ().

end interface entityRegistry