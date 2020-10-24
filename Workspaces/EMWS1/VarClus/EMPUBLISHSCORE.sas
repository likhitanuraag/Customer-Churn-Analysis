*** Begin Class Look-up, Standardization, Replacement ;
 
*** Generate dummy variables for Country ;
label CountryFrance = 'Country=France' ;
label CountryGermany = 'Country=Germany' ;
label CountrySpain = 'Country=Spain' ;
*** encoding is sparse, initialize to zero;
CountryFrance = 0;
CountryGermany = 0;
CountrySpain = 0;
if missing( Country ) then do;
   CountryFrance = .;
   CountryGermany = .;
   CountrySpain = .;
end;
else do;
   length _dm7 $ 7; drop _dm7 ;
   _dm7 = put( Country , $7. );
   %DMNORMIP( _dm7 )
   if _dm7 = 'FRANCE'  then do;
      CountryFrance = 1;
   end;
   else if _dm7 = 'SPAIN'  then do;
      CountrySpain = 1;
   end;
   else if _dm7 = 'GERMANY'  then do;
      CountryGermany = 1;
   end;
   else do;
      delete;
   end;
end;
 
*** Generate dummy variables for Gender ;
label GenderFemale = 'Gender=Female' ;
label GenderMale = 'Gender=Male' ;
if missing( Gender ) then do;
   GenderFemale = .;
   GenderMale = .;
end;
else do;
   length _dm6 $ 6; drop _dm6 ;
   _dm6 = put( Gender , $6. );
   %DMNORMIP( _dm6 )
   if _dm6 = 'MALE'  then do;
      GenderFemale = 0;
      GenderMale = 1;
   end;
   else if _dm6 = 'FEMALE'  then do;
      GenderFemale = 1;
      GenderMale = 0;
   end;
   else do;
      delete;
   end;
end;
 
*** Generate dummy variables for HasCreditCard ;
label HasCreditCardNo = 'HasCreditCard=No' ;
label HasCreditCardYes = 'HasCreditCard=Yes' ;
if missing( HasCreditCard ) then do;
   HasCreditCardNo = .;
   HasCreditCardYes = .;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   _dm3 = put( HasCreditCard , $3. );
   %DMNORMIP( _dm3 )
   if _dm3 = 'YES'  then do;
      HasCreditCardNo = 0;
      HasCreditCardYes = 1;
   end;
   else if _dm3 = 'NO'  then do;
      HasCreditCardNo = 1;
      HasCreditCardYes = 0;
   end;
   else do;
      delete;
   end;
end;
 
*** Generate dummy variables for IsActiveMember ;
label IsActiveMemberNo = 'IsActiveMember=No' ;
label IsActiveMemberYes = 'IsActiveMember=Yes' ;
if missing( IsActiveMember ) then do;
   IsActiveMemberNo = .;
   IsActiveMemberYes = .;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   _dm3 = put( IsActiveMember , $3. );
   %DMNORMIP( _dm3 )
   if _dm3 = 'YES'  then do;
      IsActiveMemberNo = 0;
      IsActiveMemberYes = 1;
   end;
   else if _dm3 = 'NO'  then do;
      IsActiveMemberNo = 1;
      IsActiveMemberYes = 0;
   end;
   else do;
      delete;
   end;
end;
 
*** End Class Look-up, Standardization, Replacement ;
 
 
/*-------------------------------------------------*/
/* Varclus Score Code Begins*/
/*-------------------------------------------------*/
 
Clus1 = 0 ; /*---Cluster Component 1------ */
Clus2 = 0 ; /*---Cluster Component 2------ */
Clus3 = 0 ; /*---Cluster Component 3------ */
Clus4 = 0 ; /*---Cluster Component 4------ */
Clus5 = 0 ; /*---Cluster Component 5------ */
Clus6 = 0 ; /*---Cluster Component 6------ */
Clus7 = 0 ; /*---Cluster Component 7------ */
Clus6 = Clus6+0.6962204496821 * (Age_Zscore - 0.00063679105199)/0.9982644254826;
Clus5 = Clus5+0.61961242489716 * (Balance_Zscore - 0.00447206673734)/1.00115500223567;
Clus7 = Clus7+0.7027957220957 * (Creditscore_Zscore - -0.00706061566265)/0.99485573848802;
Clus7 = Clus7+0.70279572209572 * (EstimatedSal_Zscore - 0.0034704162175)/1.00153718142553;
Clus5 = Clus5+-0.61961242489716 * (NumOfProducts - 1.5303733977336)/0.58132461113067;
Clus2 = Clus2+0.02855636022282 * (Tenure - 4.98903956901356)/2.88997914142329;
Clus6 = Clus6+-0.6962204496821 * (CountryFrance - 0.50120750510867)/0.50004499076973;
Clus4 = Clus4+0.61262181299668 * (CountryGermany - 0.24707412223667)/0.43135028143772;
Clus4 = Clus4+-0.61262181299668 * (CountrySpain - 0.25171837265465)/0.43404058677141;
Clus3 = Clus3+0.5 * (GenderFemale - 0.45587962102916)/0.49809585583933;
Clus3 = Clus3+-0.5 * (GenderMale - 0.54412037897083)/0.49809585583933;
Clus2 = Clus2+-0.49938735767893 * (HasCreditCardNo - 0.28905814601523)/0.45336708937218;
Clus2 = Clus2+0.49938735767893 * (HasCreditCardYes - 0.71094185398476)/0.45336708937218;
Clus1 = Clus1+0.5 * (IsActiveMemberNo - 0.48207319338658)/0.49972494537092;
Clus1 = Clus1+-0.5 * (IsActiveMemberYes - 0.51792680661341)/0.49972494537092;
