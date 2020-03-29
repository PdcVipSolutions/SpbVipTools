% Copyright (c) 2006

interface pzlLog
    open core, pfc\log

predicates
    writeString : (log::level Level, string String).
    write : (log::level Level, ...).
    writef : (log::level Level, string Format [formatString], ...).
    writeToODBCAppender : (log::level Level, tuple{string Key, string Value}*).
    % @short Log message using given log level.
    % @end

%predicates
    writeException : (log::level Level, exception::traceId TraceId, ...).
    writeExceptionF : (log::level Level, exception::traceId TraceId, string Format [formatString], ...).
    writeException : (log::level Level, exception::traceId TraceId, ...) -> string Message.
    writeExceptionF : (log::level Level, exception::traceId TraceId, string Format [formatString], ...) -> string Message.
    % @short Log message using given log level after catch statement.
    % @end

end interface pzlLog