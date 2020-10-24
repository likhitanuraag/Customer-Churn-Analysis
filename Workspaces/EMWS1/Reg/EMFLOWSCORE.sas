*************************************;
*** begin scoring code for regression;
*************************************;

length _WARN_ $4;
label _WARN_ = 'Warnings' ;

length I_Churned $ 3;
label I_Churned = 'Into: Churned' ;
*** Target Values;
array REGDRF [2] $3 _temporary_ ('YES' 'NO' );
label U_Churned = 'Unnormalized Into: Churned' ;
format U_Churned $3.;
length U_Churned $ 3;
*** Unnormalized target values;
array REGDRU[2] $ 3 _temporary_ ('Yes'  'No ' );

*** Generate dummy variables for Churned ;
drop _Y ;
label F_Churned = 'From: Churned' ;
length F_Churned $ 3;
F_Churned = put( Churned , $3. );
%DMNORMIP( F_Churned )
if missing( Churned ) then do;
   _Y = .;
end;
else do;
   if F_Churned = 'NO'  then do;
      _Y = 1;
   end;
   else if F_Churned = 'YES'  then do;
      _Y = 0;
   end;
   else do;
      _Y = .;
   end;
end;

drop _DM_BAD;
_DM_BAD=0;

*** Check Age_Zscore for missing values ;
if missing( Age_Zscore ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check CountrySpain for missing values ;
if missing( CountrySpain ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check GenderFemale for missing values ;
if missing( GenderFemale ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check HasCreditCardNo for missing values ;
if missing( HasCreditCardNo ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check IsActiveMemberNo for missing values ;
if missing( IsActiveMemberNo ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check NumOfProducts for missing values ;
if missing( NumOfProducts ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
*** If missing inputs, use averages;
if _DM_BAD > 0 then do;
   _P0 = 0.2036039383;
   _P1 = 0.7963960617;
   goto REGDR1;
end;

*** Compute Linear Predictor;
drop _TEMP;
drop _LP0 ;
_LP0 = 0;

***  Effect: Age_Zscore ;
_TEMP = Age_Zscore ;
_LP0 = _LP0 + (    0.74608369582511 * _TEMP);

***  Effect: CountrySpain ;
_TEMP = CountrySpain ;
_LP0 = _LP0 + (   -0.36655340411469 * _TEMP);

***  Effect: GenderFemale ;
_TEMP = GenderFemale ;
_LP0 = _LP0 + (    0.56235596441551 * _TEMP);

***  Effect: HasCreditCardNo ;
_TEMP = HasCreditCardNo ;
_LP0 = _LP0 + (    0.03214192975153 * _TEMP);

***  Effect: IsActiveMemberNo ;
_TEMP = IsActiveMemberNo ;
_LP0 = _LP0 + (    1.06702140809826 * _TEMP);

***  Effect: NumOfProducts ;
_TEMP = NumOfProducts ;
_LP0 = _LP0 + (   -0.15150717576933 * _TEMP);

*** Naive Posterior Probabilities;
drop _MAXP _IY _P0 _P1;
drop _LPMAX;
_LPMAX= 0;
_LP0 =    -2.05891115802926 + _LP0;
if _LPMAX < _LP0 then _LPMAX = _LP0;
_LP0 = exp(_LP0 - _LPMAX);
_LPMAX = exp(-_LPMAX);
_P1 = 1 / (_LPMAX + _LP0);
_P0 = _LP0 * _P1;
_P1 = _LPMAX * _P1;

REGDR1:

*** Residuals;
if (_Y = .) then do;
   R_ChurnedYes = .;
   R_ChurnedNo = .;
end;
else do;
    label R_ChurnedYes = 'Residual: Churned=Yes' ;
    label R_ChurnedNo = 'Residual: Churned=No' ;
   R_ChurnedYes = - _P0;
   R_ChurnedNo = - _P1;
   select( _Y );
      when (0)  R_ChurnedYes = R_ChurnedYes + 1;
      when (1)  R_ChurnedNo = R_ChurnedNo + 1;
   end;
end;

*** Posterior Probabilities and Predicted Level;
label P_ChurnedYes = 'Predicted: Churned=Yes' ;
label P_ChurnedNo = 'Predicted: Churned=No' ;
P_ChurnedYes = _P0;
_MAXP = _P0;
_IY = 1;
P_ChurnedNo = _P1;
if (_P1 >  _MAXP + 1E-8) then do;
   _MAXP = _P1;
   _IY = 2;
end;
I_Churned = REGDRF[_IY];
U_Churned = REGDRU[_IY];

*************************************;
***** end scoring code for regression;
*************************************;
