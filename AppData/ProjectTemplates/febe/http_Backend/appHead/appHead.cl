%

class appHead: appHead
    open core

constants
    isHttpService : boolean = true [compileTimeSetting].
    isBackEnd_app : boolean = true [compileTimeSetting].
    isMonoApplicaion : boolean = false [compileTimeSetting].

constructors
    new:().

end class appHead