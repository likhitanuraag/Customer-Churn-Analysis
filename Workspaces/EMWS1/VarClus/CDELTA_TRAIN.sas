if upcase(strip(ROLE)) ='INPUT' and upcase(strip(LEVEL)) ^='INTERVAL' then ROLE ='REJECTED' ;
if upcase(strip(ROLE))='INPUT' and upcase(strip(LEVEL))='INTERVAL' then do;
if upcase(strip(NAME)) in (
"ISACTIVEMEMBERNO"
"HASCREDITCARDNO"
"GENDERFEMALE"
"COUNTRYSPAIN"
"NUMOFPRODUCTS"
"AGE_ZSCORE"
"ESTIMATEDSAL_ZSCORE"
) then ROLE="INPUT";
else ROLE="REJECTED";
end;
if upcase(strip(ROLE)) = "REJECTED" then delete ;
