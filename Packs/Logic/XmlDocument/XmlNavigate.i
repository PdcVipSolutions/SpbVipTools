% Copyright (c) 2008-2015

interface xmlNavigate
    open core

domains
    step_D=
        root();
        current(xmlElement); % Start from given element.

        ancestor(string ElementName,predicate_dt{xmlElement}); 			% Возвращает множество предков.
        ancestor_or_self(string ElementName,predicate_dt{xmlElement});		% Возвращает множество предков и текущий элемент.
        attribute(string ElementName,predicate_dt{xmlElement});			%Возвращает множество атрибутов текущего элемента. Это обращение можно заменить на «@»
        child(string ElementName,predicate_dt{xmlElement});			%Возвращает множество потомков на один уровень ниже. Это название сокращается полностью, то есть его можно вовсе опускать.
        descendant(string ElementName,predicate_dt{xmlElement});		%Возвращает полное множество потомков (то есть, как ближайших потомков, так и всех их потомков).
        descendant_or_self(string ElementName,predicate_dt{xmlElement});	/*Возвращает полное множество потомков и текущий элемент. Выражение «/descendant-or-self::node()/» можно сокращать до «//». С помощью этой оси, например, можно вторым шагом организовать отбор элементов с любого узла, а не только с корневого: достаточно первым шагом взять всех потомков корневого. Например, путь «//span» отберёт все узлы span документа, независимо от их положения в иерархии, взглянув как на имя корневого, так и на имена всех его дочерних элементов, на всю глубину их вложенности.*/
        following(string ElementName,predicate_dt{xmlElement});			%Возвращает необработанное множество, ниже текущего элемента.
        following_sibling(string ElementName,predicate_dt{xmlElement});		%Возвращает множество элементов на том же уровне, следующих за текущим.
        last(predicate_dt{xmlElement});% Возвращает последний элемент текущего элемента
        parent(predicate_dt{xmlElement});			%Возвращает предка на один уровень назад. Это обращение можно заменить на «..»
        preceding(string ElementName,predicate_dt{xmlElement});		%Возвращает множество обработанных элементов исключая множество предков.
        preceding_sibling(string ElementName,predicate_dt{xmlElement});	%Возвращает множество элементов на том же уровне, предшествующих текущему.
        self(predicate_dt{xmlElement});			%Возвращает текущий элемент. Это обращение можно заменить на«.»
        xmlNamespace(string NameSpace,predicate_dt{xmlElement}).		%Возвращает множество, имеющее пространство имён (то есть присутствует атрибут xmlns).

properties
    counter_P:positive.

predicates
    getNode_nd:(step_D*)->xmlElement nondeterm.

predicates
    getNodeAndPath_nd:(step_D*)->tuple{xmlElement NodeObj,xmlElement* PathAsNodeList} nondeterm.
predicates
    getNodeAndPath_nd:(step_D*,xmlElement* Lin,xmlElement* [out] Lout)->xmlElement nondeterm.

predicates
    getNodeTree:()->spbTree::tree{string NodeName,xmlElement NodeObj}.

predicates
    position:()->positive CurrentPostion.

predicates
    attribute:(string AttributeName)->string AttributeValue determ.

predicates
    namespace_uri:(string NameSpace)->string NameSpaceUri determ.

end interface xmlNavigate
