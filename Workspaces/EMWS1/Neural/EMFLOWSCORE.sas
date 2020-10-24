***********************************;
*** Begin Scoring Code for Neural;
***********************************;
DROP _DM_BAD _EPS _NOCL_ _MAX_ _MAXP_ _SUM_ _NTRIALS;
 _DM_BAD = 0;
 _NOCL_ = .;
 _MAX_ = .;
 _MAXP_ = .;
 _SUM_ = .;
 _NTRIALS = .;
 _EPS =                1E-10;
LENGTH _WARN_ $4
      F_Churned  $ 3
      I_Churned  $ 3
      U_Churned  $ 3
;
      label S_Age_Zscore = 'Standard: Age_Zscore' ;

      label S_CountrySpain = 'Standard: CountrySpain' ;

      label S_EstimatedSal_Zscore = 'Standard: EstimatedSal_Zscore' ;

      label S_GenderFemale = 'Standard: GenderFemale' ;

      label S_HasCreditCardNo = 'Standard: HasCreditCardNo' ;

      label S_IsActiveMemberNo = 'Standard: IsActiveMemberNo' ;

      label S_NumOfProducts = 'Standard: NumOfProducts' ;

      label H11 = 'Hidden: H1=1' ;

      label H12 = 'Hidden: H1=2' ;

      label H13 = 'Hidden: H1=3' ;

      label H14 = 'Hidden: H1=4' ;

      label H15 = 'Hidden: H1=5' ;

      label H16 = 'Hidden: H1=6' ;

      label H17 = 'Hidden: H1=7' ;

      label H18 = 'Hidden: H1=8' ;

      label I_Churned = 'Into: Churned' ;

      label F_Churned = 'From: Churned' ;

      label U_Churned = 'Unnormalized Into: Churned' ;

      label P_ChurnedYes = 'Predicted: Churned=Yes' ;

      label R_ChurnedYes = 'Residual: Churned=Yes' ;

      label P_ChurnedNo = 'Predicted: Churned=No' ;

      label R_ChurnedNo = 'Residual: Churned=No' ;

      label  _WARN_ = "Warnings";

*** *************************;
*** Checking missing input Interval
*** *************************;

IF NMISS(
   Age_Zscore ,
   CountrySpain ,
   EstimatedSal_Zscore ,
   GenderFemale ,
   HasCreditCardNo ,
   IsActiveMemberNo ,
   NumOfProducts   ) THEN DO;
   SUBSTR(_WARN_, 1, 1) = 'M';

   _DM_BAD = 1;
END;
*** *************************;
*** Writing the Node intvl ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   S_Age_Zscore  =    -0.00063789817181 +     1.00173859197331 * Age_Zscore ;
   S_CountrySpain  =    -0.57994201539318 +     2.30393200653986 *
        CountrySpain ;
   S_EstimatedSal_Zscore  =     -0.0034650897459 +     0.99846517787452 *
        EstimatedSal_Zscore ;
   S_GenderFemale  =    -0.91524475798131 +      2.0076456936485 *
        GenderFemale ;
   S_HasCreditCardNo  =    -0.63758078782364 +     2.20571811108914 *
        HasCreditCardNo ;
   S_IsActiveMemberNo  =     -0.9646770645575 +     2.00110082408981 *
        IsActiveMemberNo ;
   S_NumOfProducts  =    -2.63256254497297 +     1.72020929589579 *
        NumOfProducts ;
END;
ELSE DO;
   IF MISSING( Age_Zscore ) THEN S_Age_Zscore  = . ;
   ELSE S_Age_Zscore  =    -0.00063789817181 +     1.00173859197331 *
        Age_Zscore ;
   IF MISSING( CountrySpain ) THEN S_CountrySpain  = . ;
   ELSE S_CountrySpain  =    -0.57994201539318 +     2.30393200653986 *
        CountrySpain ;
   IF MISSING( EstimatedSal_Zscore ) THEN S_EstimatedSal_Zscore  = . ;
   ELSE S_EstimatedSal_Zscore
          =     -0.0034650897459 +     0.99846517787452 * EstimatedSal_Zscore
         ;
   IF MISSING( GenderFemale ) THEN S_GenderFemale  = . ;
   ELSE S_GenderFemale  =    -0.91524475798131 +      2.0076456936485 *
        GenderFemale ;
   IF MISSING( HasCreditCardNo ) THEN S_HasCreditCardNo  = . ;
   ELSE S_HasCreditCardNo  =    -0.63758078782364 +     2.20571811108914 *
        HasCreditCardNo ;
   IF MISSING( IsActiveMemberNo ) THEN S_IsActiveMemberNo  = . ;
   ELSE S_IsActiveMemberNo  =     -0.9646770645575 +     2.00110082408981 *
        IsActiveMemberNo ;
   IF MISSING( NumOfProducts ) THEN S_NumOfProducts  = . ;
   ELSE S_NumOfProducts  =    -2.63256254497297 +     1.72020929589579 *
        NumOfProducts ;
END;
*** *************************;
*** Writing the Node H1 ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   H11  =    -0.71664347354229 * S_Age_Zscore  +     0.02082585197224 *
        S_CountrySpain  +    -0.16408245331366 * S_EstimatedSal_Zscore
          +    -0.03085431918445 * S_GenderFemale  +     0.09978786102725 *
        S_HasCreditCardNo  +     0.42999994088264 * S_IsActiveMemberNo
          +    -2.54418130750709 * S_NumOfProducts ;
   H12  =    -0.30771718442849 * S_Age_Zscore  +     0.16897714290138 *
        S_CountrySpain  +    -0.11012870811229 * S_EstimatedSal_Zscore
          +     0.11689299599059 * S_GenderFemale  +     0.13057370727213 *
        S_HasCreditCardNo  +    -0.62266427263493 * S_IsActiveMemberNo
          +     1.01224671133994 * S_NumOfProducts ;
   H13  =    -1.28048790326506 * S_Age_Zscore  +     0.97388280256631 *
        S_CountrySpain  +     -0.8380818336472 * S_EstimatedSal_Zscore
          +     0.62525532564768 * S_GenderFemale  +    -0.01135632230573 *
        S_HasCreditCardNo  +     0.96730908991183 * S_IsActiveMemberNo
          +     -0.9562519665766 * S_NumOfProducts ;
   H14  =     1.09516600333059 * S_Age_Zscore  +    -0.45969961734479 *
        S_CountrySpain  +     0.83780739956718 * S_EstimatedSal_Zscore
          +     0.11632377022107 * S_GenderFemale  +     0.43730931130838 *
        S_HasCreditCardNo  +     -1.0055252405879 * S_IsActiveMemberNo
          +    -0.71687466686388 * S_NumOfProducts ;
   H15  =    -1.01837408165083 * S_Age_Zscore  +     0.07338947994978 *
        S_CountrySpain  +     0.12019990583006 * S_EstimatedSal_Zscore
          +     0.07624759104505 * S_GenderFemale  +     0.01771719658967 *
        S_HasCreditCardNo  +     0.12822782407198 * S_IsActiveMemberNo
          +    -0.08155273326944 * S_NumOfProducts ;
   H16  =    -0.07956717553368 * S_Age_Zscore  +    -0.07861879461781 *
        S_CountrySpain  +     -0.0651138120323 * S_EstimatedSal_Zscore
          +    -0.16446292078835 * S_GenderFemale  +      -0.124613333726 *
        S_HasCreditCardNo  +    -0.96966690687134 * S_IsActiveMemberNo
          +    -0.43431361497963 * S_NumOfProducts ;
   H17  =     0.88306049852399 * S_Age_Zscore  +     0.05397589553663 *
        S_CountrySpain  +     -0.2865299852198 * S_EstimatedSal_Zscore
          +    -0.72121322084594 * S_GenderFemale  +    -0.17491069706417 *
        S_HasCreditCardNo  +     2.06126541005056 * S_IsActiveMemberNo
          +     -0.5283578443334 * S_NumOfProducts ;
   H18  =    -1.32324793675974 * S_Age_Zscore  +    -0.71149672826928 *
        S_CountrySpain  +     0.90060440143191 * S_EstimatedSal_Zscore
          +     0.13880767734573 * S_GenderFemale  +      -0.796651590728 *
        S_HasCreditCardNo  +    -0.98040861338671 * S_IsActiveMemberNo
          +    -0.18556141755479 * S_NumOfProducts ;
   H11  =    -0.50273458897886 + H11 ;
   H12  =    -1.66240849092297 + H12 ;
   H13  =     -0.5253375938445 + H13 ;
   H14  =     0.92277572510213 + H14 ;
   H15  =     0.48472119485229 + H15 ;
   H16  =     0.81753210571317 + H16 ;
   H17  =     1.58551112819418 + H17 ;
   H18  =     1.08798825212916 + H18 ;
   H11  = TANH(H11 );
   H12  = TANH(H12 );
   H13  = TANH(H13 );
   H14  = TANH(H14 );
   H15  = TANH(H15 );
   H16  = TANH(H16 );
   H17  = TANH(H17 );
   H18  = TANH(H18 );
END;
ELSE DO;
   H11  = .;
   H12  = .;
   H13  = .;
   H14  = .;
   H15  = .;
   H16  = .;
   H17  = .;
   H18  = .;
END;
*** *************************;
*** Writing the Node Churned ;
*** *************************;

*** Generate dummy variables for Churned ;
drop ChurnedYes ChurnedNo ;
label F_Churned = 'From: Churned' ;
length F_Churned $ 3;
F_Churned = put( Churned , $3. );
%DMNORMIP( F_Churned )
if missing( Churned ) then do;
   ChurnedYes = .;
   ChurnedNo = .;
end;
else do;
   if F_Churned = 'NO'  then do;
      ChurnedYes = 0;
      ChurnedNo = 1;
   end;
   else if F_Churned = 'YES'  then do;
      ChurnedYes = 1;
      ChurnedNo = 0;
   end;
   else do;
      ChurnedYes = .;
      ChurnedNo = .;
   end;
end;
IF _DM_BAD EQ 0 THEN DO;
   P_ChurnedYes  =     2.53421924508816 * H11  +     2.07345424375637 * H12
          +    -0.48564432462057 * H13  +    -0.70675506598556 * H14
          +    -3.24974798800237 * H15  +    -3.19911530582397 * H16
          +    -1.09357606138052 * H17  +     0.71767835440297 * H18 ;
   P_ChurnedYes  =     2.45024576350668 + P_ChurnedYes ;
   P_ChurnedNo  = 0;
   _MAX_ = MAX (P_ChurnedYes , P_ChurnedNo );
   _SUM_ = 0.;
   P_ChurnedYes  = EXP(P_ChurnedYes  - _MAX_);
   _SUM_ = _SUM_ + P_ChurnedYes ;
   P_ChurnedNo  = EXP(P_ChurnedNo  - _MAX_);
   _SUM_ = _SUM_ + P_ChurnedNo ;
   P_ChurnedYes  = P_ChurnedYes  / _SUM_;
   P_ChurnedNo  = P_ChurnedNo  / _SUM_;
END;
ELSE DO;
   P_ChurnedYes  = .;
   P_ChurnedNo  = .;
END;
IF _DM_BAD EQ 1 THEN DO;
   P_ChurnedYes  =     0.20360393832435;
   P_ChurnedNo  =     0.79639606167564;
END;
*** *****************************;
*** Writing the Residuals  of the Node Churned ;
*** ******************************;
IF MISSING( ChurnedYes ) THEN R_ChurnedYes  = . ;
ELSE R_ChurnedYes  = ChurnedYes  - P_ChurnedYes ;
IF MISSING( ChurnedNo ) THEN R_ChurnedNo  = . ;
ELSE R_ChurnedNo  = ChurnedNo  - P_ChurnedNo ;
*** *************************;
*** Writing the I_Churned  AND U_Churned ;
*** *************************;
_MAXP_ = P_ChurnedYes ;
I_Churned  = "YES" ;
U_Churned  = "Yes" ;
IF( _MAXP_ LT P_ChurnedNo  ) THEN DO;
   _MAXP_ = P_ChurnedNo ;
   I_Churned  = "NO " ;
   U_Churned  = "No " ;
END;
********************************;
*** End Scoring Code for Neural;
********************************;
drop
H11
H12
H13
H14
H15
H16
H17
H18
;
drop S_:;
