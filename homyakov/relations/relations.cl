% Copyright

class relations
    open core

predicates
    male : (unsigned) nondeterm (o) (i).
    female : (unsigned) nondeterm (o) (i).
    father : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    mother : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    sister : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    brother : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    son : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    daughter : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    wife : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    husband : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    ancestor : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    descendant : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    cousin_f : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    cousin_m : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    grandson : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    granddaughter : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    aunt : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    uncle : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    grandmother : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    grandfather : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    nephew_f : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).
    nephew_m : (unsigned, unsigned) nondeterm (o,o) (i,o) (o,i) (i,i).

end class relations
