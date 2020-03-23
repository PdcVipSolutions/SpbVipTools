% Copyright (c) Prolog Development Center SPb

class edf
    open core,json

constants
    vipRpc_name : string = "vipRpc".
    id_name : string = "id".
    method_name : string = "method".
    params_name : string = "params".
    result_name : string = "result".
    error_name : string = "error".
    code_name : string = "code".
    message_name : string = "message".
    data_name : string = "data".
    % @short Attribute names used by the Vip RPC 1.0 protocol
    % @end

%domains
%    vipEdf_D=vipJson(string Version,real TransactionID,string Method,edf_D Parameters).
%    vipFree_D=vipFree(string Version,real TransactionID,string Method,string FreeTermAsString).
%    vpStyle_D=vpStyle(string Version,real TransactionID,string Method,edfTerm_D UnifyedVipStyle).
%
%domains
%    edfTerm_D=
%        none;
%        st(string);
%        ed(edf_D).

domains
    edf_D =
        n;
        av(string,edf_D);
        bl(boolean LogicBoolean);
        u(unsigned Value);
        u64(unsigned64 Value);
        i(integer Value);
        i64(integer64 Value);
        r(real Number);
        c(char Value);
        s(string Value);
        s8(string8 Value);
        b(binary Value);
        bNA(binaryNonAtomic Value);
        tg(gmtTimeValue Value);
        tl(localTimeValue Value);
        o(object VipObject);
        a(edf_D* Values);
        rf(edf_D Reference);
        err(integer ErrorCode,string ErrorText).

predicates
%    fromString : (string Source) -> edfTerm_D Value.
    % @short Restore a edfData from the #Source string.
    % @end

predicates
    toJson:(jsonObject, edf_D)->jsonValue Json.

%domains
%    json_context_D=
%        none;
%        array;
%        object.

predicates
    setValue:(jsonObject,string Name,edf_D Value).

predicates
    fromJson:(jsonValue)->edf_D EDF.

%predicates
%    fromSegmented_utf16 : (segmented::segmented_utf16 Source) -> edfTerm_D Value.
%    % @short Restore a edfData from the #Source string.
%    % @end

%predicates
%    writeTo : (outputStream Stream, edfTerm_D Value).
%    % @short Write #Value to #Stream in a compact textual format.
%    % @end

%predicates
%    asString : (edfTerm_D Value) -> string String.
%    % @short #String is #Value in a compact textual format.
%    % @end

%predicates
%    isEqual : (edfTerm_D V1, edfTerm_D V2) determ.
%    % @short Succeeds if V1 and V2 have same semantic value.
%    % @end

%predicates
%    compare_edf : comparator{edfTerm_D}.
%    % @short Compares two jsonValue's semantically.
%    % @end

predicates
    fromValue : (value Value) -> edf_D JsonValue.
    % @short Convert a #Value to a #edfData.
    % string8 are asumed to be utf8 encoded.
    % Times will be strings in ISO 8601 format.
    % binaries will be base64 encoded.
    % binaryNonAtomic, object, pointer and handle will raise an exception.
    % @end

predicates
    fromValueList:(value* ValueList)->edf_D.

predicates
    fromNamedValueList:(namedValue_list NamedValueList)->edf_D.

predicates
    toValue : (edf_D JsonValue) ->value Value.

predicates
    toValueList:(edf_D)->value* ValueList. % for arrays only, i.e. a(...)

predicates
    toNamedValueList:(edf_D)->namedValue_list NamedValueList. % for objects only, i.e. o(...)

/*
predicates
    presenter_VipDataValue : presenter::presenter{vipDataStr_D}.
    % @short Presenter for edfData's.
    % @end
*/
end class edf