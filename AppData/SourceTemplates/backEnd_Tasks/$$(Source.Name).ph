#requires @"$$(Source.Path)$$(Source.Name).pack"
% publicly used packages
#include @"febe\common\AppBackEnd\backEnd\backEnd.ph"
#include @"febe\common\AppBackEnd\be_Connector\be_Connector.ph"
#include @"pfc\core.ph"
#include @"Packs\Logic\exceptionHandlingSupport\exceptionHandlingSupport.ph"

% exported interfaces
#include @"$$(Source.Path)$$(Source.Name).i"
#include @"Febe\Common\dataExchangeIdentifiers.i"

% exported classes
#include @"$$(Source.Path)$$(Source.Name).cl"
