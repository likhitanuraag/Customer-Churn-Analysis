*------------------------------------------------------------*;
* Neural: Create decision matrix;
*------------------------------------------------------------*;
data WORK.Churned;
  length   Churned                          $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="YES"
           DECISION2="NO"
           ;
  format   COUNT 10.
           ;
Churned="YES"; COUNT=1096; DATAPRIOR=0.20360393832435; TRAINPRIOR=0.20360393832435; DECPRIOR=.; DECISION1=1; DECISION2=0;
output;
Churned="NO"; COUNT=4287; DATAPRIOR=0.79639606167564; TRAINPRIOR=0.79639606167564; DECPRIOR=.; DECISION1=0; DECISION2=1;
output;
;
run;
proc datasets lib=work nolist;
modify Churned(type=PROFIT label=Churned);
label DECISION1= 'YES';
label DECISION2= 'NO';
run;
quit;
data EM_Neural;
set EMWS1.VarClus_TRAIN(keep=
Age_Zscore Churned CountrySpain EstimatedSal_Zscore GenderFemale
HasCreditCardNo IsActiveMemberNo NumOfProducts );
run;
*------------------------------------------------------------* ;
* Neural: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    Churned(DESC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Neural: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    Age_Zscore CountrySpain EstimatedSal_Zscore GenderFemale HasCreditCardNo
   IsActiveMemberNo NumOfProducts
%mend DMDBVar;
*------------------------------------------------------------*;
* Neural: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_Neural
dmdbcat=WORK.Neural_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
Churned
;
run;
quit;
*------------------------------------------------------------* ;
* Neural: Interval Input Variables Macro ;
*------------------------------------------------------------* ;
%macro INTINPUTS;
    Age_Zscore CountrySpain EstimatedSal_Zscore GenderFemale HasCreditCardNo
   IsActiveMemberNo NumOfProducts
%mend INTINPUTS;
*------------------------------------------------------------* ;
* Neural: Binary Inputs Macro ;
*------------------------------------------------------------* ;
%macro BININPUTS;

%mend BININPUTS;
*------------------------------------------------------------* ;
* Neural: Nominal Inputs Macro ;
*------------------------------------------------------------* ;
%macro NOMINPUTS;

%mend NOMINPUTS;
*------------------------------------------------------------* ;
* Neural: Ordinal Inputs Macro ;
*------------------------------------------------------------* ;
%macro ORDINPUTS;

%mend ORDINPUTS;
*------------------------------------------------------------*;
* Neural Network Training;
;
*------------------------------------------------------------*;
proc neural data=EM_Neural dmdbcat=WORK.Neural_DMDB
validdata = EMWS1.VarClus_VALIDATE
random=12345
;
nloptions
;
performance alldetails noutilfile;
netopts
decay=0;
input %INTINPUTS / level=interval id=intvl
;
target Churned / level=NOMINAL id=Churned
bias
;
arch MLP
Hidden=8
;
Prelim 5 preiter=10
pretime=3600
Outest=EMWS1.Neural_PRELIM_OUTEST
;
save network=EMWS1.Neural_NETWORK.dm_neural;
train Maxiter=50
maxtime=14400
Outest=EMWS1.Neural_outest estiter=1
Outfit=EMWS1.Neural_OUTFIT
;
run;
quit;
proc sort data=EMWS1.Neural_OUTFIT(where=(_iter_ ne . and _NAME_="OVERALL")) out=fit_Neural;
by _VAVERR_;
run;
%GLOBAL ITER;
data _null_;
set fit_Neural(obs=1);
call symput('ITER',put(_ITER_, 6.));
run;
data EMWS1.Neural_INITIAL;
set EMWS1.Neural_outest(where=(_ITER_ eq &ITER and _OBJ_ ne .));
run;
*------------------------------------------------------------*;
* Neural Network Model Selection;
;
*------------------------------------------------------------*;
proc neural data=EM_Neural dmdbcat=WORK.Neural_DMDB
validdata = EMWS1.VarClus_VALIDATE
network = EMWS1.Neural_NETWORK.dm_neural
random=12345
;
nloptions noprint;
performance alldetails noutilfile;
initial inest=EMWS1.Neural_INITIAL;
train tech=NONE;
code file="C:\Users\20161277\Documents\CA Assignment 3\Workspaces\EMWS1\Neural\SCORECODE.sas"
group=Neural
;
;
code file="C:\Users\20161277\Documents\CA Assignment 3\Workspaces\EMWS1\Neural\RESIDUALSCORECODE.sas"
group=Neural
residual
;
;
score data=EMWS1.VarClus_TRAIN out=_NULL_
outfit=WORK.FIT1
role=TRAIN
outkey=EMWS1.Neural_OUTKEY;
score data=EMWS1.VarClus_VALIDATE out=_NULL_
outfit=WORK.FIT2
role=VALID
outkey=EMWS1.Neural_OUTKEY;
score data=EMWS1.VarClus_TEST out=_NULL_
outfit=WORK.FIT3
role=TEST
outkey=EMWS1.Neural_OUTKEY;
run;
quit;
data EMWS1.Neural_OUTFIT;
merge WORK.FIT1 WORK.FIT2 WORK.FIT3;
run;
data EMWS1.Neural_EMESTIMATE;
set EMWS1.Neural_outest;
if _type_ ^in('HESSIAN' 'GRAD');
run;
proc datasets lib=work nolist;
delete EM_Neural;
run;
quit;
