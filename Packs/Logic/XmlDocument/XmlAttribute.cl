% Copyright (c) 2006

class xmlAttributes : xmlAttributes
    open core

predicates
    splitAttributeName:(string ElementNameIntegrated)->tuple{string NameSpace,string AttributeName}.


predicates
    tryConfirmNameSpace:(xmlAttributes XmlElement,string NameSpace)->string NameSpaceUri determ.

end class xmlAttributes