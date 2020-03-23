%

class appHead : appHead
    open core

constants
    isBackEnd_app : boolean = false [compileTimeSetting].
    isMonoApplicaion : boolean = false [compileTimeSetting].
    isHttpService : boolean = false [compileTimeSetting].
    isHttpClient :boolean = true [compileTimeSetting].

end class appHead