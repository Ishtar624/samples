from BasicFuzzyFunctions import *



def mfTisC(x):
    return SmZ(x, 5, 8)

def mfTisNC(x):
    return SmTrap(x, 7, 9, 10, 13)

def mfTisA(x):
    return SmTrap(x, 15, 17, 20, 23)

def mfTisFA(x):
    return SmTrap(x, 16, 20, 22, 25)

def mfTisVFA(x):
    return SmS(x, 25, 30)



