%

class appHead : appHead
    open core

constants
    isBackEnd_app : boolean = true [compileTimeSetting].
    isMonoApplicaion : boolean = true [compileTimeSetting].
    isHttpService : boolean = false [compileTimeSetting].
    isHttpClient : boolean = false [compileTimeSetting].

end class appHead