

length _FILTERFMT1  $200;
drop _FILTERFMT1 ;
_FILTERFMT1= put(Churned,$3.);
if
_FILTERFMT1 not in ( 'Yes')
;