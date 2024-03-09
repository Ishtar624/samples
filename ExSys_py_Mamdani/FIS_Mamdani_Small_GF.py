from MFFunctions_Mamdani import *

Chart=Rating=EpRating=0
CisL=CisM=CisHm=CisH=RisL=RisM=RisHm=RisH=RisHh=ERisLp=ERisMp=ERisHmp=ERisHp=0
EpRatingArray={x: 0 for x in np.linspace(30, 100, 40)}
       
       
def Fuzzification():
    global Chart, Memory
    global CisL, CisM, CisHm, CisH, RisL, RisM, RisHm, RisH, RisHh

    CisL = mfCisL(Chart)
    CisM = mfCisM(Chart)
    CisHm = mfCisHm(Chart)
    CisH = mfCisH(Chart)
    RisL = mfRisL(Rating)
    RisM = mfRisM(Rating)
    RisHm = mfRisHm(Rating)
    RisH = mfRisH(Rating)
    RisHh = mfRisHh(Rating)


def FuzzyInference():
    global CisL, CisM, CisHm, CisH, RisL, RisM, RisHm, RisH, RisHh, ERisLp, ERisMp, ERisHmp, ERisHp

    ERisHp = min(CisL, RisHh)
    ERisHmp = max(min(CisM, RisHm), min(CisM, RisH), min(CisHm, RisH))
    ERisMp = max(min(CisHm, RisM), min(CisHm, RisHm))
    ERisLp = max(min(CisH, RisL), min(CisH, RisM))
    

5
def Composition():
    global ERisLp, ERisMp, ERisHmp, ERisHp
    global EpRatingArray

    for x in np.linspace(30, 100, 40):
        EpRatingArray[x] = max(min(mfERisHp(x),  ERisHp), 
                    min(mfERisHmp(x),  ERisHmp), 
                    min(mfERisMp(x), ERisMp), 
                    min(mfERisLp(x),  ERisLp))



def Defuzzyfication():
    global EpRating
    global EpRatingArray

    X=list(EpRatingArray.keys())
    Y=list(EpRatingArray.values())

    EpRating = LastMax(X,Y)


def Run():
    Fuzzification()
    FuzzyInference()
    Composition()
    Defuzzyfication()


def Init():
    global Chart, Rating

    Chart = float(input('Chart = '))
    Rating = float(input('Rating = '))


def Terminate():
    global EpRating

    print(f'EpRating = {EpRating:.2f}')



def Main():
    Init()
    Run()
    Terminate()

if __name__=='__main__':
    Main()


