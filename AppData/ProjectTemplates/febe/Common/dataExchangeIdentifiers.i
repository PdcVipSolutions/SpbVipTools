% SPBrSolutions

interface dataExchangeIdentifiers
    open core

constants % to BE commands
    fe_TestRequest_1_C:integer=4001.
    fe_TestRequest_2_C=fe_testRequest_1_C+1. % 4002
    fe_TestRequest_3_C=fe_TestRequest_2_C+1. % 4003
    fe_TestRequest_4_C=fe_TestRequest_3_C+1. % 4004
    fe_TestRequest_5_C=fe_TestRequest_4_C+1. % 4005
    fe_TestRequest_6_C=fe_TestRequest_5_C+1. % 4006
    fe_TestRequest_7_C=fe_TestRequest_6_C+1. % 4007
    fe_TestRequest_8_C=fe_TestRequest_7_C+1. % 4008

constants % from BE Test responses
    be_TestResponse_1_C:integer=6001.
    be_TestResponse_2_C=be_TestResponse_1_C+1. % 6002
    be_TestResponse_3_C=be_TestResponse_2_C+1. % 6003
    be_TestResponse_4_C=be_TestResponse_3_C+1. % 6004
    be_TestResponse_5_C=be_TestResponse_4_C+1. % 6005
    be_TestResponse_6_C=be_TestResponse_5_C+1. % 6006
    be_TestResponse_7_C=be_TestResponse_6_C+1. % 6007
    be_TestResponse_8_C=be_TestResponse_7_C+1. % 6008

constants % BE Error Test responses
    be_TestError3_C=7001.

end interface dataExchangeIdentifiers