import json as j
import BasicFuzzyFunctions as bf


def read_fis(jf):
    return j.load(open(jf))

def var_prompt(d,x):
    return f'{x} ({d[x]["LeftB"]} - {d[x]["RightB"]}) = '

def read_inputs(fis):
    for x in fis['Inputs']:
        fis['Inputs'][x]['Value']=float(input(var_prompt(fis['Inputs'],x)))



def calc_mf(mf, x):
    if mf['MFType']=='Z':
        a=mf['Parameters']['a']
        b=mf['Parameters']['b']
        return bf.Z(x,a,b)
    elif mf['MFType']=='Trap':
        a=mf['Parameters']['a']
        b=mf['Parameters']['b']
        c=mf['Parameters']['c']
        d=mf['Parameters']['d']
        return bf.Trap(x,a,b,c,d)
    elif mf['MFType']=='S':
        a=mf['Parameters']['a']
        b=mf['Parameters']['b']
        return bf.S(x,a,b)
    elif mf['MFType']=='SmZ':
        a=mf['Parameters']['a']
        b=mf['Parameters']['b']
        return bf.SmZ(x,a,b)
    elif mf['MFType']=='SmTrap':
        a=mf['Parameters']['a']
        b=mf['Parameters']['b']
        c=mf['Parameters']['c']
        d=mf['Parameters']['d']
        return bf.SmTrap(x,a,b,c,d)
    elif mf['MFType']=='SmS':
        a=mf['Parameters']['a']
        b=mf['Parameters']['b']
        return bf.SmS(x,a,b)

def calc_lit(fis,VN,LTN,N):
    v=fis['Inputs'][VN]['LTerms'][LTN]['MFValue']
    return 1-v if N else v

def calc_con(fis, C):
    return min([calc_lit(fis,l['VarName'],l['LTName'],l['Neg']) for l in C])

def calc_dis(fis, D):
    return max([calc_con(fis,C) for C in D])

def calc_poly(fis, P):
    return sum([P['Coefficients'][X]*fis['Inputs'][X]['Value'] for X in fis['Inputs']])+P['Bias']



def fuzzyfication(fis):
    for X in fis['Inputs']:
        x=fis['Inputs'][X]
        for T in x['LTerms']:
            t=x['LTerms'][T]
            t['MFValue']=calc_mf(t['MFunction'],x['Value'])
            
def fuzzyinference(fis):
    for Y in fis['Outputs']:
        P=fis['Outputs'][Y]['Productions']
        for i in range(len(P)):
            P[i]['Disjunct']['Value']=calc_dis(fis,P[i]['Disjunct']['Conjuncts'])                        
            P[i]['Polynomial']['Value']=calc_poly(fis,P[i]['Polynomial'])

def defuzzyfication(fis):
    for Y in fis['Outputs']:
        y = fis['Outputs'][Y]
        P=y['Productions']
        N=sum([p['Disjunct']['Value']*p['Polynomial']['Value'] for p in P])
        D=sum([p['Disjunct']['Value'] for p in P])
        y['Value'] = N/D

def Run():    
    fis = read_fis('sample_Sugeno.json')
    read_inputs(fis)
    fuzzyfication(fis)
    fuzzyinference(fis)
    defuzzyfication(fis)
    print()
    for Y in fis['Outputs']:
        y=fis['Outputs'][Y]
        print(Y,':',f"{y['Value']:.2f}")   
        

if __name__=='__main__':
    Run()
