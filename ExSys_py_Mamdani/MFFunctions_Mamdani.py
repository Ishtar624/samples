from BasicFuzzyFunctions import *

#чарт
def mfCisL(x):
    return SmZ(x, 1, 40)

def mfCisM(x):
    return SmTrap(x, 10, 40, 50, 90)

def mfCisHm(x):
    return SmTrap(x, 50, 90, 100, 140)

def mfCisH(x):
    return SmS(x, 140, 170)


#просмотры
def mfRisL(x):
    return SmZ(x, 3.2, 4)

def mfRisM(x):
    return SmTrap(x, 3, 3.2, 4, 4.9)

def mfRisHm(x):
    return SmTrap(x, 3.2, 4, 4.9, 5.6)

def mfRisH(x):
    return SmTrap(x, 4, 4.9, 5.6, 10)

def mfRisHh(x):
    return SmS(x, 10, 17)


#рейтинг
def mfERisLp(x):
    return SmZ(x, 33, 44)

def mfERisMp(x):
    return SmTrap(x, 30, 43, 45, 55)

def mfERisHmp(x):
    return SmTrap(x, 37, 45, 50, 65)

def mfERisHp(x):
    return SmS(x, 65, 100)


# , highermiddleER
# [
#     {
#         "VarName":"Chart",
#         "LTName":"HighCh",
#         "Neg":true
#     },
#     {
#         "VarName":"Rating",
#         "LTName":"Low",
#         "Neg":true
#     }
# ]

# , MiddleER
# [
#     {
#         "VarName":"Chart",
#         "LTName":"LowCh",
#         "Neg":true
#     },
#     {
#         "VarName":"Rating",
#         "LTName":"High",
#         "Neg":true
#     }
# ]

# , LowER
# [
#     {
#         "VarName":"Rating",
#         "LTName":"High",
#         "Neg":true
#     },
#     {
#         "VarName":"Chart",
#         "LTName":"MiddleCh",
#         "Neg":true
#     }
# ]