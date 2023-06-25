* OSA Anti-obesity medication Meta-analysis

//last updated June 25 2023
//Author: Brian Locke
//cd "***" // change to your folder

clear
import excel "Data Extraction Table.xlsx", sheet("Sheet1") firstrow case(lower)
program define datetime 
end
keep if !missing(stauthor) // drop lines that don't correspond to studies


capture mkdir "Results and Figures"
capture mkdir "Results and Figures/$S_DATE/" //make new folder for figure output if needed
capture mkdir "Results and Figures/$S_DATE/Logs/" //new folder for stata logs
local a1=substr(c(current_time),1,2)
local a2=substr(c(current_time),4,2)
local a3=substr(c(current_time),7,2)
local b = "OSA Wt Loss SRMA.do" // do file name
copy "`b'" "Results and Figures/$S_DATE/Logs/(`a1'_`a2'_`a3')`b'"

//convert to number types
destring interventionn intbaselineweightmeanormed intbaselineweightsd intfinalweightmeanormedian intfinalweightsd intmeanweightchange intmeanweightchangesd intmeanweightdifference intmeanweightdifferencesd intbaselineahimean intbaselineahisd intfinalahimean intfinalahisd intmeanahichange intmeanahichangesd intmeandifferenceahi intmeandifferenceahisd controln controlbaselineweightmeanor controlbaselineweightsd controlfinalweightmeanorme controlfinalweightsd controlmeanweightchange controlmeanweightchangesd controlmeanweightdifference controlweightdifferencesd controlbaselineahimeanorme controlbaselineahisd controlfinalahimeanormedia controlfinalahisd controlmeanahichange controlmeanahichangesd controlmeanahidifference controlmeanahidifferencesd followupdurationmonths controlessbaseline controlessbaselinesd controlessfinal controlessfinalsd controlessdiff controlessdiffsd controlesschange controlesschangesd intbaselineess intbaselineesssd intfinaless intfinalesssd intessdiff intessdiffsd intesschange intesschangesd, replace

tostring year, gen(year_str)
gen int_wt_loss_effect = controlmeanweightchange - intmeanweightchange
gen study_label = stauthor + " (" + year_str + "), " + interventiontype

recode int_wt_loss_effect min/5=0 5/10=1 10/15=2 15/max=3, gen(wt_loss_cat)
label variable wt_loss_cat "Amount of Weight Loss"
label define wt_loss_cat_label 0 "<5% Avg Weight Loss" 1 "5-10% Avg Weight Loss" 2 "10-15% Avg Weight Loss" 3 "15% or More Avg Weight Loss"
label values wt_loss_cat wt_loss_cat_label

encode studycategory, gen(surg_vs_med) // make into numeric variables. 
label define rob_label 0 "Low Risk" 1 "Some Concerns" 2 "High Risk"
destring rob, replace 
label values rob rob_label
label variable rob "Overall Risk of Bias"

//10% threshold var 
recode int_wt_loss_effect min/10=0 10/max=1, gen(ten_perc_wt)
label define ten_perc_wt_label 0 "<10% Avg Weight Loss" 1 "10% or More Avg Weight Loss"
label values ten_perc_wt ten_perc_wt_label
list wt_loss_cat ten_perc_wt

label variable studycategory "Type of Intervention"
label variable studysubcategory "Class of Intervention"
label variable interventiontype "Intervention"
label variable int_wt_loss_effect "Intervention Weight Loss Estimate (%BMI change)"
label variable study_label "Study"

replace studysubcategory = studycategory + ": " + studysubcategory
replace interventiontype = studycategory + ": " + interventiontype
replace studysubcategory = "Medication: Other" if studysubcategory == "Medication: Medication: Other"

save osa_antiobesity_srma, replace
* End of data processing


* --------

* Data analysis
use osa_antiobesity_srma, clear
set scheme cleanplots 
capture mkdir "Results and Figures/$S_DATE/" //make new folder for figure output if needed

// ----absolute effect, AHI change: PRIMARY ANALYSIS ----

meta esize interventionn intmeandifferenceahi intmeandifferenceahisd controln controlmeanahidifference controlmeanahidifferencesd, eslabel(MD) random(reml) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)

//Figure 3: RCTs Reporting AHI Difference and Percent Weight Loss
//subgrouping by intervention type and category. Requires manual editing of the labels - not sure why.
meta forestplot, random(reml) nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) subgroup ( studycategory studysubcategory ) title("") note("") xtitle("Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Figure 3- AHI Diff by Type and Intervention.png", as(png) name("Graph") replace

//subgrouping by intervention: only used for text used for text and supplement figure S6.
//AHI Difference, Random-Effects Meta-analysis
//Figure Supplement
meta forestplot, random(reml) nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup ( interventiontype ) title("") note("")
graph export "Results and Figures/$S_DATE/FigureS6 - AHI Diff by Intervention.png", as(png) name("Graph") replace

//Following two figures are used only for outputs discussed in the text
//grouping by intervention class:  
//RCTs Reporting AHI Difference and Percent Weight Loss subtitle("Random-Effects Meta-analysis") 
meta forestplot, random(reml) nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup ( studysubcategory ) title("") note("") xtitle("Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/AHI Diff by Intervention Class.png", as(png) name("Graph") replace

// and by intervention type 
meta forestplot, random(reml) nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup ( studycategory ) title("") note("") xtitle("Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/AHI Diff by Intervention Type.png", as(png) name("Graph") replace

//Figure 2; main text
//RCTs Reporting AHI Difference and Percent Weight Loss, separated by 10% threshold; Random-Effects Meta-analysis
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3)) columnopts(_data, format(%4.1f)) subgroup ( ten_perc_wt ) title("") note("") xtitle("Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Figure 2 AHI Diff by 10 Perc Wt Loss.png", as(png) name("Graph") replace

gen ahi_diff_es = _meta_es * -1 // for plots and scatters
gen ahi_diff_effect = _meta_es //for the Lowess 


//MAIN META-REGRESSION
meta regress int_wt_loss_effect, random(reml) se(kh)
estimates store baseline_model
estat summarize, equation
estat ic //this doesn't have info needed to calculate AIC and BIC -> no log likelihood. why?

//Some of the testing for linear regression assumptions
predict r, resid
//normality
kdensity r, normal
pnorm r
qnorm r
//linearity 
scatter r int_wt_loss_effect //- visual inspection .. hard to tell


/* Supplement Estimates of Effectiveness of Various Interventions */ 
//Vertical sleeve gastrectomy
adjust int_wt_loss_effect=25, ci level(95) // from NEJM review

//Tirzepitide weight loss SURMOUNT trial 
adjust int_wt_loss_effect=20.9, ci level(95) //confidence interval - - 20.9% weight loss Tirzepitde 15mg
//adjust int_wt_loss_effect=20.9, stdf ci level(95) //prediction interval - Invalid? :( - Not sure I understand why. 

//Semaglutide weight loss -
adjust int_wt_loss_effect=10.8, ci level(95) //from AGA guideline
adjust int_wt_loss_effect=12.1, ci level(95) //from Semaglutide Treatment Effect in People With Obesity (STEP) trial: 12% weight loss

//Naltrexone-Bupriopion
adjust int_wt_loss_effect=3.0, ci level(95) //from AGA guideline

//Orlistat & Galesis-100
adjust int_wt_loss_effect=2.0, ci level(95) //from AGA guideline


//FIGURE 4: title("Meta-regression of RCTs of Anti-Obesity Interventions") 
estat bubbleplot, reweighted ytitle("AHI change (events/hr)") xtitle("Percent weight change(%)") title("") note("") mlabel(study_label) mlabsize(vsmall) mlabposition(6) mlabangle(25) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_tableau) legend(order(1 "95% CI" 3 "Meta-regression line") rows(3) pos(6) ring(0)) 
graph export "Results and Figures/$S_DATE/Figure 4- Wt Loss v AHI Diff Meta Regress.png", as(png) name("Graph") replace

//Medical vs Surgical Regression lines: 
//meta regress int_wt_loss_effect if studycategory == "Medication", random(reml) // ahi = -1.916225 - 1.017 (int_wt_loss_effect)
//meta regress int_wt_loss_effect if studycategory == "Surgery", random(reml) // ahi = -6.74113 - 0.347 (int_wt_loss_effect)
estat bubbleplot, reweighted addplot(function y = -1.916225 - (1.017 * x), range(1.29 6.1) lpattern(dash_dot) || function y = -6.74113 - (0.347 * x), range(5.33 33.47) lpattern(dash)) ytitle("AHI change (events/hr)") xtitle("Percent weight change(%)") title("") note("P = 0.655 for difference between medication and surgical slopes (test of interaction)") mlabel(study_label) mlabsize(vsmall) mlabposition(6) mlabangle(25) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_tableau) legend(order(1 "95% CI Overall" 3 "Overall meta-regression line" 4 "Medication regression line" 5 "Surgical Regression Line") rows(3) pos(6) ring(0)) 
graph export "Results and Figures/$S_DATE/Figure S5- Wt Loss v AHI Diff Meta Regress by type.png", as(png) name("Graph") replace

//Interaction?
meta regress surg_vs_med##c.int_wt_loss_effect, random(reml) //no interaction between surg vs med. p=0.655, 95CI for diff between slope for surg (as compared to med): [-2.063104    3.282596] 



// SENSTIVITY ANALYSES:

predict leverage, leverage //Furlan has 80%. 

//does adding follow-up duration add accuracy? No 
meta regress int_wt_loss_effect followupdurationmonths


//SENSITIVITY ANALYSIS 1: Relative AHI change meta-analysis
//relative effect, weight loss 
use osa_antiobesity_srma, clear //restore
meta esize interventionn intmeanahichange intmeanahichangesd controln controlmeanahichange controlmeanahichangesd, eslabel(MD) random(reml) studylabel (study_label) esize(mdiff)
meta summarize, predinterval(95)

//Figure S6-1: RCTs Reporting AHI Difference and Percent Weight Loss
//subgrouping by intervention type and category. Requires manual editing of the labels - not sure why.
meta forestplot, random(reml) nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) subgroup ( studycategory studysubcategory ) title("") note("") xtitle("Control-Subtracted Change in AHI (%)")
graph export "Results and Figures/$S_DATE/Figure S6-1- AHI Diff by Type and Intervention.png", as(png) name("Graph") replace

//Figure S6-2:
//RCTs Reporting AHI Difference and Percent Weight Loss, separated by 10% threshold; Random-Effects Meta-analysis
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( ten_perc_wt ) title("") note("") xtitle("Control-Subtracted Change in AHI (%)")
graph export "Results and Figures/$S_DATE/Figure S6-2 AHI Diff by 10 Perc Wt Loss.png", as(png) name("Graph") replace

gen ahi_diff_es = _meta_es * -1 // for plots and scatters

//SENSITIVITY META-REGRESSION: Figure S6-3 
meta regress int_wt_loss_effect, random(reml) 
estat summarize, equation
estat bubbleplot, reweighted ytitle("Control-Subtracted Change in AHI (%)") xtitle("Percent weight change(%)") title("") note("") mlabel(study_label) mlabsize(vsmall) mlabposition(12) mlabangle(0) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_tableau) legend(order(1 "95% CI" 3 "Meta-regression line") rows(3) pos(6) ring(0)) 
graph export "Results and Figures/$S_DATE/Figure S6-3- Wt Loss v AHI Diff Meta Regress.png", as(png) name("Graph") replace

/* Supplement Estimates of Effectiveness of Various Interventions */ 
//Vertical sleeve gastrectomy
adjust int_wt_loss_effect=25, ci level(95) // from NEJM review

//Tirzepitide weight loss SURMOUNT trial 
adjust int_wt_loss_effect=20.9, ci level(95) //confidence interval - - 20.9% weight loss Tirzepitde 15mg
//adjust int_wt_loss_effect=20.9, stdf ci level(95) //prediction interval - Invalid? :( - Not sure I understand why. 

//Semaglutide weight loss -
adjust int_wt_loss_effect=10.8, ci level(95) //from AGA guideline
adjust int_wt_loss_effect=12.1, ci level(95) //from Semaglutide Treatment Effect in People With Obesity (STEP) trial: 12% weight loss

//Naltrexone-Bupriopion
adjust int_wt_loss_effect=3.0, ci level(95) //from AGA guideline

//Orlistat & Galesis-100
adjust int_wt_loss_effect=2.0, ci level(95) //from AGA guideline


//SECONDARY ANALYSIS - SLEEPINESS
//Difference   
//use osa_antiobesity_srma, clear //restore
meta esize interventionn intessdiff intessdiffsd  controln controlessdiff controlessdiffsd, eslabel(MD) random(reml) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)
gen ess_diff_es = _meta_es * -1

//subgrouping by intervention class
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup ( studycategory ) title("") note("") scheme(white_w3d) xtitle("Difference in Epworth Sleepiness Score Change Between Groups")
graph export "Results and Figures/$S_DATE/Supplement Figure - ESS Diff by Intervention Type.png", as(png) name("Graph") replace

//10% threshold: RCTs Reporting ESS Difference and Percent Weight Loss
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( ten_perc_wt ) title("") note("") scheme(white_w3d) note("") xtitle("Difference in Epworth Sleepiness Score Change Between Groups")
graph export "Results and Figures/$S_DATE/Supplement Figure - ESS Diff by 10 Perc Wt Loss.png", as(png) name("Graph") replace

//ESS META-REGRESSION
meta regress int_wt_loss_effect, random(reml)
estimates store baseline_model
estat bubbleplot, reweighted ytitle("Control-Subtracted Change in Epworth Sleepiness Score") xtitle(" Percent weight change(%)") title("") note("") mlabel(study_label) mlabsize(vsmall) mlabposition(3) mlabangle(25) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_w3d) legend(order(1 "95% CI" 3 "Fitted line") rows(2) pos(6) ring(0))
graph export "Results and Figures/$S_DATE/Supplement - Wt Loss v ESS Diff Meta Regress.png", as(png) name("Graph") replace


//-----------------------------------
// Further Sensitivity Analyses below
//-----------------------------------

// ----- Sensitivity analysis excluding Furlan ------ 
use osa_antiobesity_srma, clear //restore
drop if doi == "10.1038/s41366-021-00752-2" //drop furlan

meta esize interventionn intmeandifferenceahi intmeandifferenceahisd controln controlmeanahidifference controlmeanahidifferencesd, eslabel(MD) random(reml) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)

//10% threshold
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( ten_perc_wt ) title("") scheme(white_w3d) note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl Furlan - AHI Diff by 10 Perc Wt Loss.png", as(png) name("Graph") replace

//By Interventio type, RCTs Reporting AHI Absolute Change and Percent Weight Loss; Excluding Furlan et al. 
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup (studycategory) title("") note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl Furlan - AHI Diff by Surg v Med.png", as(png) name("Graph") replace

//Sensitivity META-REGRESSION: RCTs of Anti-Obesity Interventions; Excluding Furlan et al.
meta regress int_wt_loss_effect
estimates store baseline_model
estat summarize

estat bubbleplot, reweighted ytitle("Control-Subtracted AHI change (events/hr)") xtitle(" Percent weight change(%)") title("") note("") mlabel(study_label) mlabsize(vsmall) mlabposition(3) mlabangle(25) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_w3d) legend(order(1 "95% CI" 3 "Meta-regression line") rows(2) pos(6) ring(0))
graph export "Results and Figures/$S_DATE/Supplement - Excl Furlan - Wt Loss v AHI Diff Meta Regress.png", as(png) name("Graph") replace


// ----- Sensitivity analysis excluding Carbonic Anhydrase Inhibs ------ 
use osa_antiobesity_srma, clear //restore
drop if doi == "0.1183/09031936.00158413" //drop eskandri
drop if doi == "10.5665/sleep.2204" //drop winslow

meta esize interventionn intmeandifferenceahi intmeandifferenceahisd controln controlmeanahidifference controlmeanahidifferencesd, eslabel(MD) random(reml) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)

//10% threshold
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( ten_perc_wt ) title("") scheme(white_w3d) note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl CAI - AHI Diff by 10 Perc Wt Loss.png", as(png) name("Graph") replace

//By Intervention type, RCTs Reporting AHI Absolute Change and Percent Weight Loss; Excluding CAIs 
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup (studycategory) title("") note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl CAI - AHI Diff by Surg v Med.png", as(png) name("Graph") replace

//Sensitivity META-REGRESSION: RCTs of Anti-Obesity Interventions; Excluding CAIs
meta regress int_wt_loss_effect
estimates store baseline_model
estat summarize

estat bubbleplot, reweighted ytitle("Control-Subtracted AHI change (events/hr)") xtitle(" Percent weight change(%)") title("") note("") mlabel(study_label) mlabsize(vsmall) mlabposition(3) mlabangle(25) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_w3d) legend(order(1 "95% CI" 3 "Meta-regression line") rows(2) pos(6) ring(0))
graph export "Results and Figures/$S_DATE/Supplement - Excl CAI - Wt Loss v AHI Diff Meta Regress.png", as(png) name("Graph") replace

// ----- Sensitivity analysis excluding CPAP control / bakker ------ 
use osa_antiobesity_srma, clear //restore
drop if doi == "10.1164/rccm.201708-1637LE" //drop bakker

meta esize interventionn intmeandifferenceahi intmeandifferenceahisd controln controlmeanahidifference controlmeanahidifferencesd, eslabel(MD) random(reml) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)

//10% threshold
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( ten_perc_wt ) title("") scheme(white_w3d) note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl Bakker - AHI Diff by 10 Perc Wt Loss.png", as(png) name("Graph") replace

//By Intervention type, RCTs Reporting AHI Absolute Change and Percent Weight Loss; Excluding Bakker
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup (studycategory) title("") note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl Bakker - AHI Diff by Surg v Med.png", as(png) name("Graph") replace

//Sensitivity META-REGRESSION: RCTs of Anti-Obesity Interventions; Excluding Bakker
meta regress int_wt_loss_effect
estimates store baseline_model
estat summarize

estat bubbleplot, reweighted ytitle("Control-Subtracted AHI change (events/hr)") xtitle(" Percent weight change(%)") title("") note("") mlabel(study_label) mlabsize(vsmall) mlabposition(3) mlabangle(25) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_w3d) legend(order(1 "95% CI" 3 "Meta-regression line") rows(2) pos(6) ring(0))
graph export "Results and Figures/$S_DATE/Supplement - Excl Bakker - Wt Loss v AHI Diff Meta Regress.png", as(png) name("Graph") replace

// ----- Sensitivity analysis evaluating RoB and excluding High Risk ------ 
use osa_antiobesity_srma, clear //restore


//AHI difference by ROB
meta esize interventionn intmeandifferenceahi intmeandifferenceahisd controln controlmeanahidifference controlmeanahidifferencesd, eslabel(MD) random(reml) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)
//10% threshold
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( rob ) title("") scheme(white_w3d) note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - AHI Diff by RoB.png", as(png) name("Graph") replace


//Percent weight loss by ROB 
meta esize interventionn intmeanweightchange intmeanweightdifferencesd controln controlmeanweightchange controlmeanweightchangesd, eslabel(MD) random(dl) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)

//Percent weight loss by RoB
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( rob ) title("") scheme(white_w3d) note("") xtitle("Control Subtracted Percent Weight Loss")
graph export "Results and Figures/$S_DATE/Supplement - Weight Loss by RoB.png", as(png) name("Graph") replace

drop if rob == 2 //drop high risk

meta esize interventionn intmeandifferenceahi intmeandifferenceahisd controln controlmeanahidifference controlmeanahidifferencesd, eslabel(MD) random(reml) studylabel (study_label) esize( mdiff )
meta summarize, predinterval(95)

//10% threshold
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) columnopts(_data, format(%4.1f)) subgroup ( ten_perc_wt ) title("") scheme(white_w3d) note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl High Risk - AHI Diff by 10 Perc Wt Loss.png", as(png) name("Graph") replace

//By Intervention type, RCTs Reporting AHI Absolute Change and Percent Weight Loss; Excluding High Risk
meta forestplot, random(reml) nooverall noohetstats noohomtest noosigtest nullrefline(lcolor(gs3) favorsright("Favors control") favorsleft("Favors Intervention")) esrefline(lcolor(gs3) lpattern(dash_dot)) columnopts(_data, format(%4.1f)) subgroup (studycategory) title("") note("") xtitle("Control Subtracted Change in AHI (events/hr)")
graph export "Results and Figures/$S_DATE/Supplement - Excl High Risk - AHI Diff by Surg v Med.png", as(png) name("Graph") replace


//Sensitivity META-REGRESSION: RCTs of Anti-Obesity Interventions; Excluding High Risk
meta regress int_wt_loss_effect
estimates store baseline_model
estat summarize

estat bubbleplot, reweighted ytitle("Control-Subtracted AHI change (events/hr)") xtitle(" Percent weight change(%)") title("") note("") mlabel(study_label) mlabsize(vsmall) mlabposition(3) mlabangle(25) xline(0, lcolor(gs10)) yline(0, lcolor(gs10)) scheme(white_w3d) legend(order(1 "95% CI" 3 "Meta-regression line") rows(2) pos(6) ring(0))
graph export "Results and Figures/$S_DATE/Supplement - Excl High Risk - Wt Loss v AHI Diff Meta Regress.png", as(png) name("Graph") replace

