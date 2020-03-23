%

class fe_Command : fe_Command
    open core

constructors
    new : (window WS_Form,frontEnd FrontEnd).

predicates
    tryExtractCommandId:(command Command)->string CommandID determ.

predicates
    tryExtractCommandSuffix:(command Command,string Prefix)->string CommandSuffix determ.


end class fe_Command