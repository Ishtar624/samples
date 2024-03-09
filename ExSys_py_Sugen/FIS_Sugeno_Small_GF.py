from MFFunctions_Sugeno import *

Time=Area=Price=0
TisVFA=TisFA=TisA=TisNC=TisC=VFAP=FAP=AP=NCP=CP=wVFAP=wFAP=wAP=wNCP=wCP=0  
       
def Fuzzification():
    global Time
    global TisVFA, TisFA, TisA, TisNC, TisC

    TisVFA = mfTisVFA(Time)
    TisFA = mfTisFA(Time)
    TisA = mfTisA(Time)
    TisNC = mfTisNC(Time)
    TisC = mfTisC(Time)


def FuzzyInference():
    global Area
    global TisVFA, TisFA, TisA, TisNC, TisC, VFAP, FAP, AP, NCP, CP, wVFAP, wFAP, wAP, wNCP, wCP

    VFAP = Area * 0.5
    FAP = Area * 0.75
    AP = Area * 1.0
    NCP = Area * 1.25
    CP = Area * 1.5

    wVFAP = TisVFA
    wFAP = TisFA
    wAP = TisA
    wNCP = TisNC
    wCP = TisC
    
def Defuzzyfication():
    global Price
    global VFAP, FAP, AP, NCP, CP, wVFAP, wFAP, wAP, wNCP, wCP

    Price = (VFAP*wVFAP + FAP*wFAP + AP*wAP + NCP*wNCP + CP*wCP) / (wVFAP + wFAP + wFAP + wNCP + wCP)


def Run():
    Fuzzification()
    FuzzyInference()
    Defuzzyfication()


def Init():
    global Time, Area

    Time = float(input('Time (5 - 30) = '))
    Area = float(input('Area = '))


def Terminate():
    global Price

    print(f'Price = {Price:.2f}')



def Main():
    Init()
    Run()
    Terminate()

if __name__=='__main__':
    Main()


