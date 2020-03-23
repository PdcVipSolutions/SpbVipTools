% Copyright (c) Prolog Development Center SPb
% @short The tool to make traditional trace procedure easy to perform
% @detail
% The Trace pack is the tool to make traditional trace procedure easy to perform.
% In any .pro file you may initialize trace object and then you may use it in any place of your project.
% It is possible to create as much trace objects as it it needed.
% Each trace object has it's own counter, so in simple cases you do not need to enumerate trace points.
% Each trace object sends messages to stdio
% @end

class trace : trace
    open core

constructors
    start:(...).
% @short The start constructor creates the trace object.
% @detail
% While created it send to the output stream "1:start" and then any text written as the parameter.
% The Constructor returnes the Trace object, which may be accessed via trace.i interface
% @exception
% @example T=trace::start("trace class invocation")
% The output stream will get the line "1:start:trace class invocation"
% @end

predicates
    set:(string Name,trace TraceObj).
% @short Stores the named object in the internal database.
% @detail
% Later in the any place of the project the stored object maybe activated.
% No messages to output stream sent
% @exception
% @example
% T=trace::start("trace class invocation"),
% trace::set("invoke",T),
% where "invoke" is the name of the trace object
% @end

predicates
    get:(string Name)->trace TraceObj.
% @short Retreaves the stored  trace object by name.
% @detail
% If object was not stored in the internal database, then it will be created and stored
% with the given name and the message
% "TRACE: nothing to get (Name), created now"
% @exception
% @example
% T=trace::start("trace class invocation"),
% trace::set("invoke",T),
% ...
% T=trace::get("invoke"),
% ...
% where "invoke" is the name of the trace object
% @end

predicates
    kill:(string Name).
% @short Removes the trace Object with the given Name from the trace memory.
% @detail Removes the trace Object with the given Name from the trace memory.
% If object was not stored in the internal database, then the message will be sent to stdio
% "TRACE: nothing to kill (Name)"
% @exception
% @example
% T=trace::start("trace class invocation"),
% trace::set("invoke",T),
% ...
% trace::kill("invoke"),
% ...
% where "invoke" is the name of the trace object
% @end

predicates
    strForLog:(string StringIn,charCount Len)->string StringOut.

end class trace