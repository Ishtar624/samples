% Copyright

interface dbBoardGames
    open core

predicates
    rule_nd : (positive, string, string, positive*) nondeterm (o,o,o,o) (i,o,o,o) (o,i,o,o) (o,o,i,o).
    attr_nd : (positive, string, string) nondeterm (o,o,o) (i,o,o) (o,o,i).
    topic_nd : (string) nondeterm (o) (i).
    pict_nd : (positive, string) nondeterm (o,o) (i,o) (o,i) (i,i).
    parent_nd : (positive, positive) nondeterm (o,o) (i,o) (o,i) (i,i).
    load : ().
    getNewAttrId : () -> positive.
    getNewRuleId : () -> positive.
    addAttr : (positive, string, string).
    replaceAttr : (positive, string, string).
    deleteAttr : (positive).
    deleteRule : (string).
    addRule : (string, positive*, string).
    save : ().
    save : (string).

end interface dbBoardGames
