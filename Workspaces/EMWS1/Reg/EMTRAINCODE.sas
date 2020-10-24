*------------------------------------------------------------*;
* Reg: Create decision matrix;
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
data EM_DMREG / view=EM_DMREG;
set EMWS1.VarClus_TRAIN(keep=
Age_Zscore Churned CountrySpain EstimatedSal_Zscore GenderFemale
HasCreditCardNo IsActiveMemberNo NumOfProducts );
run;
*------------------------------------------------------------* ;
* Reg: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    Churned(DESC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Reg: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    Age_Zscore CountrySpain EstimatedSal_Zscore GenderFemale HasCreditCardNo
   IsActiveMemberNo NumOfProducts
%mend DMDBVar;
*------------------------------------------------------------*;
* Reg: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_DMREG
dmdbcat=WORK.Reg_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
Churned
;
run;
quit;
*------------------------------------------------------------*;
* Reg: Run DMREG procedure;
*------------------------------------------------------------*;
proc dmreg data=EM_DMREG dmdbcat=WORK.Reg_DMDB
validata = EMWS1.VarClus_VALIDATE
outest = EMWS1.Reg_EMESTIMATE
outterms = EMWS1.Reg_OUTTERMS
outmap= EMWS1.Reg_MAPDS namelen=200
;
class
Churned
;
model Churned =
Age_Zscore
CountrySpain
EstimatedSal_Zscore
GenderFemale
HasCreditCardNo
IsActiveMemberNo
NumOfProducts
/level=nominal
coding=DEVIATION
nodesignprint
selection=BACKWARD choose=VERROR
Hierarchy=CLASS
Rule=NONE
;
;
score data=EMWS1.VarClus_TEST
out=_null_
outfit=EMWS1.Reg_FITTEST
role = TEST
;
code file="C:\Users\20161277\Documents\CA Assignment 3\Workspaces\EMWS1\Reg\EMPUBLISHSCORE.sas"
group=Reg
;
code file="C:\Users\20161277\Documents\CA Assignment 3\Workspaces\EMWS1\Reg\EMFLOWSCORE.sas"
group=Reg
residual
;
run;
quit;
