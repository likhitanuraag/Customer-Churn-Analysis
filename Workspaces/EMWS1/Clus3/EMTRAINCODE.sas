*------------------------------------------------------------*;
* Clus3: Training;
*------------------------------------------------------------*;
*------------------------------------------------------------* ;
* Clus3: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    Country(ASC) Gender(ASC) HasCreditCard(ASC) IsActiveMember(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Clus3: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    Age Balance CreditScore EstimatedSalary NumOfProducts Tenure
%mend DMDBVar;
*------------------------------------------------------------*;
* Clus3: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=EMWS1.Filter3_TRAIN
dmdbcat=WORK.Clus3_DMDB
maxlevel = 513
out=WORK.Clus3_DMDB
;
class %DMDBClass;
var %DMDBVar;
run;
quit;
*------------------------------------------------------------* ;
* Clus3: Interval Inputs Macro ;
*------------------------------------------------------------* ;
%macro DMVQINTERVAL;
    Age Balance CreditScore EstimatedSalary NumOfProducts Tenure
%mend DMVQINTERVAL;
*------------------------------------------------------------* ;
* Clus3: Nominal Inputs Macro ;
*------------------------------------------------------------* ;
%macro DMVQNOMINAL;
    Country Gender HasCreditCard IsActiveMember
%mend DMVQNOMINAL;
*------------------------------------------------------------*;
* Clus3: Run DMVQ procedure;
*------------------------------------------------------------*;
title;
options nodate;
proc dmvq data=WORK.Clus3_DMDB dmdbcat=WORK.Clus3_DMDB std=STD nominal=GLM ordinal=RANK
;
input %DMVQINTERVAL / level=interval;
input %DMVQNOMINAL / level=nominal;
VQ maxc = 5 clusname=_SEGMENT_ CLUSLABEL="Segment Id" DISTLABEL="Distance";
MAKE outvar=EMWS1.Clus3_OUTVAR;
INITIAL radius=0
;
TRAIN tech=FORGY
;
SAVE outstat=EMWS1.Clus3_OUTSTAT outmean=EMWS1.Clus3_OUTMEAN;
code file="C:\Users\20161277\Documents\CA Assignment 3\Workspaces\EMWS1\Clus3\DMVQSCORECODE.sas"
group=Clus3
;
run;
quit;
*------------------------------------------------------------* ;
* Clus3: DMVQ Variables;
*------------------------------------------------------------* ;
%macro dmvqvars;
    Age Balance CreditScore EstimatedSalary NumOfProducts Tenure CountryFrance
   CountryGermany CountrySpain GenderFemale GenderMale HasCreditCardNo
   HasCreditCardYes IsActiveMemberNo IsActiveMemberYes
%mend ;
