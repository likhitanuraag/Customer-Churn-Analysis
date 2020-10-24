if upcase(NAME) = "COUNTRYSPAIN" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "ESTIMATEDSAL_ZSCORE" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "HASCREDITCARDNO" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "Q_CHURNEDNO" then do;
ROLE = "ASSESS";
end;
else 
if upcase(NAME) = "Q_CHURNEDYES" then do;
ROLE = "ASSESS";
end;
else 
if upcase(NAME) = "_NODE_" then do;
ROLE = "SEGMENT";
LEVEL = "NOMINAL";
end;
