* Encoding: UTF-8.

***TABLE 1

*Age

CROSSTABS
  /TABLES=Age_rec4 BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

EXAMINE VARIABLES=ageyearscurrent BY variant_rec
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

*Nonparametric Tests: Independent Samples. 
NPTESTS 
  /INDEPENDENT TEST (ageyearscurrent) GROUP (variant_rec) MANN_WHITNEY 
  /MISSING SCOPE=ANALYSIS USERMISSING=EXCLUDE
  /CRITERIA ALPHA=0.05  CILEVEL=95.

*Sex

CROSSTABS
  /TABLES=gender_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*Nationality

CROSSTABS
  /TABLES=Nat_rec3 BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*BMI
    
CROSSTABS
  /TABLES=BMI_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

EXAMINE VARIABLES=BMI BY variant_rec
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

*Nonparametric Tests: Independent Samples. 
NPTESTS 
  /INDEPENDENT TEST (BMI) GROUP (variant_rec) MANN_WHITNEY 
  /MISSING SCOPE=ANALYSIS USERMISSING=EXCLUDE
  /CRITERIA ALPHA=0.05  CILEVEL=95.

*Comorbidities 
    
CROSSTABS
  /TABLES=Asthma_rec Cancer_rec CKD_rec CLivD_rec CLungD_rec CAD_rec Diabetes_rec HTN_rec Stroke_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=comorb_sum_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.


***TABLE 2
    
*Outcomes 

CROSSTABS
  /TABLES=Hospitalized_rec ICUadmission_rec SupplementalO2_rec HiflowO2_rec MechVent_rec Died_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*Outcome disease status: none, mild/moderate, severe/critical
    
CROSSTABS
  /TABLES=Outcome_status BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*Outcome disease status: none, mild/moderate, severe/critical
    
CROSSTABS
  /TABLES=Outcome_status_dich BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.


***TABLE 3
    
*******
    *******Outcomes by variant by vaccine
*******

*Outcomes stratified by vaccination status
    
CROSSTABS
  /TABLES=Hospitalized_rec ICUadmission_rec SupplementalO2_rec HiflowO2_rec MechVent_rec Died_rec 
    BY variant_rec BY Vaccine_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*Outcome disease status: none, mild/moderate, severe/critical  stratified by vaccination status
    
CROSSTABS
  /TABLES=Outcome_status BY variant_rec BY Vaccine_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*Outcome disease status: none, mild/moderate, severe/critical  stratified by vaccination status
    
CROSSTABS
  /TABLES=Outcome_status_dich BY variant_rec BY Vaccine_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.


*******
    *******Outcomes by vaccine by variant
*******
  
*Outcomes stratified by vaccination status

CROSSTABS
  /TABLES=Hospitalized_rec ICUadmission_rec SupplementalO2_rec HiflowO2_rec MechVent_rec Died_rec 
    BY Vaccine_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*Outcome disease status: none, mild/moderate, severe/critical  stratified by vaccination status
    
CROSSTABS
  /TABLES=Outcome_status BY Vaccine_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

*Outcome disease status: none, mild/moderate, severe/critical  stratified by vaccination status
    
CROSSTABS
  /TABLES=Outcome_status_dich BY Vaccine_rec BY variant_rec
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.

******************************
    ****************************** REGRESSIONS
******************************

RECODE Comorb_sum (0=0) (1 thru 2=1) (ELSE=2) INTO comorb_sum_rec2.
EXECUTE.

Freq comorb_sum_rec2
    
***Multivariable logistic regression Mild/moderate vs. no outcome
    
USE ALL.
COMPUTE filter_$=(Outcome_status<2).
VARIABLE LABELS filter_$ 'Outcome_status<2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

LOGISTIC REGRESSION VARIABLES Outcome_status
  /METHOD=ENTER variant_rec Vaccine_rec Age_rec4 gender_rec Nat_rec3 BMI_rec comorb_sum_rec2 
  /CONTRAST (variant_rec)=Indicator(1)
  /CONTRAST (Vaccine_rec)=Indicator
  /CONTRAST (Age_rec4)=Indicator(1)
  /CONTRAST (gender_rec)=Indicator(1)
  /CONTRAST (BMI_rec)=Indicator(2)
  /CONTRAST (Nat_rec3)=Indicator
  /CONTRAST (comorb_sum_rec2)=Indicator(1)
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

***Multivariable logistic regression Severe/critical vs. no outcome
    
USE ALL.
COMPUTE filter_$=(Outcome_status=0 | Outcome_status=2).
VARIABLE LABELS filter_$ 'Outcome_status=0 | Outcome_status=2(FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

LOGISTIC REGRESSION VARIABLES Outcome_status
  /METHOD=ENTER variant_rec Vaccine_rec Age_rec4 gender_rec Nat_rec3 BMI_rec comorb_sum_rec2 
  /CONTRAST (variant_rec)=Indicator(1)
  /CONTRAST (Vaccine_rec)=Indicator
  /CONTRAST (Age_rec4)=Indicator(1)
  /CONTRAST (gender_rec)=Indicator(1)
  /CONTRAST (BMI_rec)=Indicator(2)
  /CONTRAST (Nat_rec3)=Indicator
  /CONTRAST (comorb_sum_rec2)=Indicator(1)
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

***Multivariable logistic regression any outcome vs. no outcome
    
USE ALL.

LOGISTIC REGRESSION VARIABLES Outcome_status_dich
  /METHOD=ENTER variant_rec Vaccine_rec Age_rec4 gender_rec Nat_rec3 BMI_rec comorb_sum_rec2 
  /CONTRAST (variant_rec)=Indicator(1)
  /CONTRAST (Vaccine_rec)=Indicator
  /CONTRAST (Age_rec4)=Indicator(1)
  /CONTRAST (gender_rec)=Indicator(1)
  /CONTRAST (BMI_rec)=Indicator(2)
  /CONTRAST (Nat_rec3)=Indicator
  /CONTRAST (comorb_sum_rec2)=Indicator(1)
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

***Multivariable logistic regression severe/critical vs. no outcome and mild/moderate
    
RECODE Outcome_status (0=0) (1=0) (2=1) INTO severe_outcome.
EXECUTE.

Freq severe_outcome

USE ALL.

LOGISTIC REGRESSION VARIABLES severe_outcome
  /METHOD=ENTER variant_rec Vaccine_rec Age_rec4 gender_rec Nat_rec3 BMI_rec comorb_sum_rec2 
  /CONTRAST (variant_rec)=Indicator(1)
  /CONTRAST (Vaccine_rec)=Indicator
  /CONTRAST (Age_rec4)=Indicator(1)
  /CONTRAST (gender_rec)=Indicator(1)
  /CONTRAST (BMI_rec)=Indicator(2)
  /CONTRAST (Nat_rec3)=Indicator
  /CONTRAST (comorb_sum_rec2)=Indicator(1)
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

