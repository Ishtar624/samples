% Copyright

class treeForm : treeForm
    open core

predicates
    display : (window Parent) -> treeForm Form.

constructors
    new : (window Parent).

properties
    currentId : positive.

properties
    db : optional{dbBoardGames}.

end class treeForm
