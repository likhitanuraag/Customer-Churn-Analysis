*------------------------------------------------------------*;
* Clus: Training;
*------------------------------------------------------------*;
*------------------------------------------------------------* ;
* Clus: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    Country(ASC) Gender(ASC) HasCreditCard(ASC) IsActiveMember(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Clus: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    Age Balance CreditScore EstimatedSalary NumOfProducts Tenure
%mend DMDBVar;
*------------------------------------------------------------*;
* Clus: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=EMWS1.Filter_TRAIN
dmdbcat=WORK.Clus_DMDB
maxlevel = 513
out=WORK.Clus_DMDB
;
class %DMDBClass;
var %DMDBVar;
run;
quit;
*------------------------------------------------------------* ;
* Clus: Interval Inputs Macro ;
*------------------------------------------------------------* ;
%macro DMVQINTERVAL;
    Age Balance CreditScore EstimatedSalary NumOfProducts Tenure
%mend DMVQINTERVAL;
*------------------------------------------------------------* ;
* Clus: Nominal Inputs Macro ;
*------------------------------------------------------------* ;
%macro DMVQNOMINAL;
    Country Gender HasCreditCard IsActiveMember
%mend DMVQNOMINAL;
*------------------------------------------------------------*;
* Clus: Run DMVQ procedure;
*------------------------------------------------------------*;
title;
options nodate;
proc dmvq data=WORK.Clus_DMDB dmdbcat=WORK.Clus_DMDB std=STD nominal=GLM ordinal=RANK
;
input %DMVQINTERVAL / level=interval;
input %DMVQNOMINAL / level=nominal;
VQ maxc = 5 clusname=_SEGMENT_ CLUSLABEL="Segment Id" DISTLABEL="Distance";
MAKE outvar=EMWS1.Clus_OUTVAR;
INITIAL radius=0
;
TRAIN tech=FORGY
;
SAVE outstat=EMWS1.Clus_OUTSTAT outmean=EMWS1.Clus_OUTMEAN;
code file="C:\Users\20161277\Documents\CA Assignment 3\Workspaces\EMWS1\Clus\DMVQSCORECODE.sas"
group=Clus
;
run;
quit;
*------------------------------------------------------------* ;
* Clus: DMVQ Variables;
*------------------------------------------------------------* ;
%macro dmvqvars;
    Age Balance CreditScore EstimatedSalary NumOfProducts Tenure CountryFrance
   CountryGermany CountrySpain GenderFemale GenderMale HasCreditCardNo
   HasCreditCardYes IsActiveMemberNo IsActiveMemberYes
%mend ;
