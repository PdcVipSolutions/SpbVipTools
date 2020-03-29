% Copyright (c) 2006

implement pzlLog

    open core, pfc\log

clauses
    writeString(Level, String):-log::writeString(Level, String).
    write(Level, ...):-log::write(Level, ...).
    writef(Level, Format, ...):-log::writef(Level, Format, ...).
    writeToODBCAppender(Level, KeyValue):-log::writeToODBCAppender(Level, KeyValue).
    % @short Log message using given log level.
    % @end

clauses
    writeException(Level, TraceId, ...):-log::writeException(Level, TraceId, ...).
    writeExceptionF(Level, TraceId,Format, ...):-log::writeExceptionF(Level, TraceId,Format, ...).
    writeException(Level, TraceId, ...)=log::writeException(Level, TraceId, ...).
    writeExceptionF(Level, TraceId, Format, ...)=log::writeExceptionF(Level, TraceId, Format, ...).

end implement pzlLog