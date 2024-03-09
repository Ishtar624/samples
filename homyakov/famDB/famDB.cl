% Copyright

class famDB
    open core

properties
    selectedPersonId : unsigned.
    filename : string.
    defaultImage : string.

predicates
    getLabel : (unsigned) -> string.
    getLabelId : (unsigned) -> string.
    getGenderPersonList : (string Gender) -> string*.

predicates
    clearAll : ().
    load : (string Filename) determ.
    save : ().
    save : (string Filename).
    person_nd : (unsigned Id, string Name, string Name2, string Name3, string Gender, string Family)
        nondeterm (o,o,o,o,o,o) (i,o,o,o,o,o) (o,o,o,o,i,o) (i,o,o,o,i,o) (o,o,i,o,o,o) (o,i,i,o,o,o) (o,o,o,o,i,i) (o,i,o,o,o,o) (o,i,i,i,o,o)
        (o,o,o,o,o,i) (o,i,o,i,o,o).
    parent_nd : (unsigned IdParent, unsigned IdChild) nondeterm (o,o) (i,o) (o,i) (i,i).
    spouse_nd : (unsigned IdHusband, unsigned IdWife) nondeterm (o,o) (i,o) (o,i) (i,i).
    birth_nd : (unsigned Id, integer) nondeterm (o,o) (i,o) (o,i) (i,i).
    death_nd : (unsigned Id, integer) nondeterm (o,o) (i,o) (o,i) (i,i).
    picture_nd : (unsigned Id, string Filename) nondeterm (o,o) (i,o) (o,i) (i,i).
    biography_nd : (unsigned Id, string Filename) nondeterm (o,o) (i,o) (o,i) (i,i).
    getNewId : () -> unsigned.
    addPerson : (unsigned Id, string Name, string Name2, string Name3, string Gender, string Status, integer Birth, integer Death, unsigned Father,
        unsigned Mother, unsigned* SpouseIdList, string BiographyFilename, string* PictureList).
    deletePerson : (unsigned Id).
    editName : (unsigned Id, string Name).
    editName2 : (unsigned Id, string Name2).
    editName3 : (unsigned Id, string Name3).
    editGender : (unsigned Id, string Gender).
    editFamily : (unsigned Id, string Family).
    editFather : (unsigned Id, unsigned FatherId).
    editMother : (unsigned Id, unsigned MotherId).
    editBirth : (unsigned Id, integer Year).
    editDeath : (unsigned Id, integer Year).
    addSpouse : (unsigned Id, unsigned SpouseId).
    deleteFather : (unsigned Id, unsigned FatherId).
    deleteMother : (unsigned Id, unsigned MotherId).
    deleteSpouse : (unsigned Id, unsigned SpouseId).
    deleteBirth : (unsigned Id, integer BirthYear).
    deleteDeath : (unsigned Id, integer DeathYear).

end class famDB
