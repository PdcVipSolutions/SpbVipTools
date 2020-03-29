% Copyright

interface http_Client
    open core, eventManager

constants % http request types
    methodRequest_C="request".
    methodDo_C="justdo".
    methodChain_C="requestChain".
    methodNext_C="next".

properties
%    xmlHttp_P:serverXMLHTTP60.
    server_Url_P:string.
    methodRequest_P:string.
    methodChain_P:string.
    methodNext_P:string.
    methodDo_P:string.
    messageID_ParameterName_P:string.
    parameters_ParameterName_P:string.
    defaultTimeOut_P:unsigned.

    sleepInterval_P:integer.
    transactionID_P:string.
    maxNoOfCyclingRequests_P:integer.

predicates
    requestViaHttp:(notifyMethod_D,integer EventID,edf::edf_D EventParameters,string ExchangeDataFormat).
    requestViaHttp:(notifyMethod_D,integer EventID,edf::edf_D EventParameters,string ExchangeDataFormat,unsigned TimeOut).

end interface http_Client