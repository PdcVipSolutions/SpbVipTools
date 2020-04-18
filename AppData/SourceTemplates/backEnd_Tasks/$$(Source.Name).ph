#requires @"$$(Source.Path)$$(Source.Name).pack"
% publicly used packages
#include @"..\common\AppBackEnd\backEnd\backEnd.ph"
#include @"..\common\AppBackEnd\be_Connector\be_Connector.ph"
#include @"pfc\core.ph"
#include @"Packs\Logic\exceptionHandlingSupport\exceptionHandlingSupport.ph"

% exported interfaces
#include @"$$(Source.Path)$$(Source.Name).i"
#include @"..\Common\dataExchangeIdentifiers.i"

% exported classes
#include @"$$(Source.Path)$$(Source.Name).cl"
