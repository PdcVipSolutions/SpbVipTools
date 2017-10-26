/************************************************************************

                        Copyright ©

************************************************************************/

interface splitForm {@CellID}

predicates
    layoutControl_nd:(@CellID AreaName,string ControlClass, integer Size) nondeterm (o,o,o).

predicates
    createControl:(splitContainerControl,string ControlClass)->control determ.

end interface splitForm