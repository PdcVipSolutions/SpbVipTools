% Copyright

implement exceptionHandlingSupport
    open core

clauses
    getExceptionInfo(TraceID)=tuple(ShortInfo,Output:getString()):-
        Output=outputStream_string::new(),
        exceptionDump::dump(Output,TraceID),
        ShortInfo=getShortInfo(TraceID).

predicates
    getShortInfo:(exception::traceId TraceID)->string ShortInfo.
clauses
    getShortInfo(TraceID)=string::format("The Initial Reason is:\n%\n%",UserMassage,TechnicalMessage):-
            ErrDescriptorList = [ ErrDescriptor || ErrDescriptor = exception::getDescriptor_nd(TraceID) ],
            ErrDescriptorListReversed=list::reverse(ErrDescriptorList),
            LastErrDescriptor=list::getMember_nd(ErrDescriptorListReversed),
                getUserMessage(LastErrDescriptor,UserMassage),
                TechnicalMessage=getInitialTechnicalReason(ErrDescriptorListReversed,UserMassage),
            !.
    getShortInfo(_TraceID)="".

predicates
    getUserMessage:(exception::descriptor ErrDescriptor,string TheLatestExceptionDescriptor) determ (i,o).
clauses
    getUserMessage(ErrDescriptor,UserMassage):-
        ErrDescriptor=exception::descriptor
                (
                _ProgramPoint,
                _Exception,
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ThreadId
                ),
        try
        	UserMassage = namedValue::getNamed_string(ExtraInfo, exception::userMessage_parameter)
        catch _Err do
        	fail
        end try.

predicates
    getInitialTechnicalReason:(exception::descriptor* ErrDescriptorListReversed,string UserMassage)->string TechnicalMessage.
clauses
    getInitialTechnicalReason(ErrDescriptorListReversed,UserMassage)=TechnicalMessage:-
        ErrDescriptor=list::getMember_nd(ErrDescriptorListReversed),
            ErrDescriptor=exception::descriptor
                (
                _ProgramPoint,
                _Exception,
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ThreadId
                ),
        try
        	TechnicalMessage = namedValue::getNamed_string(ExtraInfo, "Error description")
        catch _Err do
        	fail
        end try,
        not(UserMassage=TechnicalMessage),
        !.
    getInitialTechnicalReason(_ErrDescriptorListReversed,_UserMassage)="".

end implement exceptionHandlingSupport
