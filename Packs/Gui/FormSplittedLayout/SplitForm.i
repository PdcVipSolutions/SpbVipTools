/****************************************
Copyright © Prolog Development Center SPb
Author: Victor Yukhtenko
****************************************/

interface splitForm {@CellID}

predicates
    layoutControl_nd:(@CellID AreaName,string ControlClass, integer Size) nondeterm (o,o,o).

predicates
    createControl:(splitContainerControl,string ControlClass)->control determ.

end interface splitForm