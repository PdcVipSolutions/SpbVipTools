%

class frontEnd : frontEnd
    open core

constants
    isUseDictionary_C:boolean=false.

constructors
    new:(eventManager EventManager,appHead Service).

constructors
    new:(eventManager EventManager,appHead Service,http_Client HttpClient).

end class frontEnd