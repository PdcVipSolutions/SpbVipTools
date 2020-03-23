#requires @"..\Common\AppFrontEnd\frontEnd\frontEnd.pack"

% publicly used packages
#include @"Packs\Logic\appFrameSupport\http_Client\http_Client.ph"
#include @"appHead\appHead.ph"

#include @"..\Common\AppFrontEnd\fe_Core\fe_CoreTasks\fe_CoreTasks.ph"

#include @"pfc\web\http\httpServerApi\requestQueue_rpc\requestQueue_rpc.ph"
#include @"Packs\Logic\appFrameSupport\eventManager\eventManager.ph"
#include @"pfc\core.ph"

% exported interfaces
#include @"..\Common\AppFrontEnd\frontEnd\frontEnd.i"

% exported classes
#include @"..\Common\AppFrontEnd\frontEnd\frontEnd.cl"
