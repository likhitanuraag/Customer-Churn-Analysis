*------------------------------------------------------------*;
* Formula Code;
*------------------------------------------------------------*;

if NAME="Age_Zscore" then do;
ROLE ="INPUT";
REPORT ="N";
LEVEL ="INTERVAL";
end;
if NAME="Age" then delete;

if NAME="Balance_Zscore" then do;
ROLE ="INPUT";
REPORT ="N";
LEVEL ="INTERVAL";
end;
if NAME="Balance" then delete;

if NAME="Creditscore_Zscore" then do;
ROLE ="INPUT";
REPORT ="N";
LEVEL ="INTERVAL";
end;
if NAME="CreditScore" then delete;

if NAME="EstimatedSal_Zscore" then do;
ROLE ="INPUT";
REPORT ="N";
LEVEL ="INTERVAL";
end;
if NAME="EstimatedSalary" then delete;
