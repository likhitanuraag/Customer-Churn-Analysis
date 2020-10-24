if ROLE in('INPUT', 'REJECTED') then do;
if upcase(NAME) in(
'AGE_ZSCORE'
'COUNTRYSPAIN'
'GENDERFEMALE'
'HASCREDITCARDNO'
'ISACTIVEMEMBERNO'
'NUMOFPRODUCTS'
) then ROLE='INPUT';
else do;
ROLE='REJECTED';
COMMENT = "Reg: Rejected using backward selection";
end;
end;
