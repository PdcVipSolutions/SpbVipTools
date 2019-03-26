% Copyright (c) Prolog Development Center SPb

interface trace
    open core

predicates
    trace:(...).
    w:(...).
% @short trace(...) and w(...) are synonyms of the operations to write to stdio.
% @detail
% trace(...) and w(...) write the number and text to stdio. .
% Each trace(...) and w(...) increment the counter, which is the printed number.
% @exception
% @example
% T=trace::start("trace class invocation"),
%
% ...
% T:w("one"),
% T:w("two"),
% T:w("three"),
% ...
% outputs
%  1:start:trace class invocation
%  2:one
%  3:two
%  4:three
% @end


predicates
    tracef:(string Format [formatstring],...).
    wf:(string Format [formatstring],...).
% @short tracef(...) and wf(...) are synonyms of the formatted operations to write to stdio.
% @detail
% tracef(...) and wf(...) write the number and formatted text to stdio. .
% @exception
% @example
% T=trace::start("trace class invocation"),
%
% ...
% T:wf("one [%]",predicate_name()),
% T:wf("two [%]",toString(123)),
% T:wf("three [%]","end"),
% ...
% outputs
%  1:start:trace class invocation
%  2:one [init]
%  3:two [123]
%  4:three [end]
% @end


end interface trace