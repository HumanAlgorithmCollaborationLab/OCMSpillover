////////////////////////////////////////////////////////////////////////////////
//// TABLE 2 ////////////////
/////////////////////////////////////////////////////////////////////////////////
use "G:\Active_Projects\EHSR_OCM_Upenn\Analysis\Stata\temp files\psmatched_analysis_fullsample_4_12.dta", clear

cd "G:\Active_Projects\EHSR_OCM_Upenn\Analysis\Stata\output"


*exlcude 6 month period of intermittance between pre and post period 
drop if  baseline_period==0 & post_period==0


//drop h1 2014
gen halfyear=hofd(indexdate)
drop if halfyear==108

*generate year 
gen yr=year(indexdate)


local suffix: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")

log using "F:\Active_Projects\EHSR_OCM_Upenn\Analysis\Stata\output\summary statistics cost Full Sample Table 2 `suffix'.log" ,replace

//Summary Statistics 
sum post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost 

//Note chemotheraphy and non-chemotherapy drug costs not separately in file !!!!!!

//Treatment Group
 outreg2 using summarystats_table2basefull if baseline_period==1 & ocm_practice==1, word sum(log) replace keep(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )  sortvar(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )

 sum post_6mon_allowed if high_risk==1 & baseline_period==1 &  ocm_practice==1
 sum post_6mon_allowed if high_risk==0 & baseline_period==1 &  ocm_practice==1

*intervention period

outreg2 using summarystats_table2intfull if post_period==1 & ocm_practice==1, word sum(log) replace keep(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )  sortvar(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )

 sum post_6mon_allowed if high_risk==1 & post_period==1 &  ocm_practice==1
 sum post_6mon_allowed if high_risk==0 & post_period==1 &  ocm_practice==1

//Comparison Group
 outreg2 using summarystats_table2basefull if baseline_period==1 & ocm_practice==0, word sum(log) append keep(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )  sortvar(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )

 sum post_6mon_allowed if high_risk==1 & baseline_period==1 & ocm_practice==0
 sum post_6mon_allowed if high_risk==0 & baseline_period==1 & ocm_practice==0

*intervention period
 outreg2 using summarystats_table2intfull if post_period==1 & ocm_practice==0, word sum(log) append keep(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )  sortvar(post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost )


 sum post_6mon_allowed if high_risk==1 & post_period==1 & ocm_practice==0
 sum post_6mon_allowed if high_risk==0 & post_period==1 & ocm_practice==0


//Difference in Differences Estimate with year and practice fFE


*include similar control set as in Keating et al. 
*Practice-level covariates include measures of practice size, provider specialty mix, hospital ownership and health system affiliation, and academic medical center affiliation
*market level county level market population, market demographic factors, market healthcare provider supply, and market-level exposure to Medicare Advantage
global controls_demo breast_cancer_flag lung_cancer_flag colorectal_cancer_flag prostate_cancer_flag pancreatic_cancer_flag other_cancer_flag age medianfamilyincome medianfamilyincome_miss ratiowhite ratioasian ratioblack ratiowhitehisp ratioblackhisp female dci_score ma_flg

*exclude non-time varying controls
global controls_practice_market  npi_anthem_volume npi_radiation npi_medical i.attributedtin_2

global cost post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_radiation_cost post_6mon_out_imaging_cost  post_6mon_out_em_noncan_cost post_6mon_out_em_can_cost

sum $controls_demo $controls_practice_market
sum $cost

*identify treatment and post periods
gen interaction=post_period*ocm_practice

local suffix: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")

local dd_resultstable2 "dd_resultstable2_FULL_`suffix'" 

*high and low risk
regress post_6mon_allowed i.post_period  interaction  $controls_demo $controls_practice_market i.yr if high_risk==1, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel replace

regress post_6mon_allowed i.post_period  interaction  $controls_demo $controls_practice_market i.yr if high_risk==0, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel append


foreach x in  $cost {
eststo `x': regress `x' i.post_period interaction  $controls_demo $controls_practice_market i.yr, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel append
}


*interaction of high vs low and MA vs Commercial
gen interaction_high=post_period*ocm_practice*high_risk
gen interaction_MA=post_period*ocm_practice*ma_flg

local dd_resultstable2 "dd_resultstable2_interaction_`suffix'" 

foreach x in  $cost {
eststo `x': regress `x' i.post_period interaction interaction_high interaction_MA  $controls_demo $controls_practice_market i.yr, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel append
}


log using "G:\Active_Projects\EHSR_OCM_Upenn\Analysis\Stata\output\summary stat cost Full MA vs CO Table 2 `suffix'.log" ,replace

 sum post_6mon_allowed if ma_flg==1 & baseline_period==1 &  ocm_practice==1
 sum post_6mon_allowed if ma_flg==0 & baseline_period==1 &  ocm_practice==1
 
 sum post_6mon_allowed if ma_flg==1 & post_period==1 &  ocm_practice==1
 sum post_6mon_allowed if ma_flg==0 & post_period==1 &  ocm_practice==1

  sum post_6mon_allowed if ma_flg==1 & baseline_period==1 & ocm_practice==0
 sum post_6mon_allowed if ma_flg==0 & baseline_period==1 & ocm_practice==0
 sum post_6mon_allowed if ma_flg==1 & post_period==1 & ocm_practice==0
 sum post_6mon_allowed if ma_flg==0 & post_period==1 & ocm_practice==0

 
local dd_resultstable2 "dd_resultstable2_FULL_MA_CO_`suffix'" 
*MA vs commercial 
regress post_6mon_allowed i.post_period  interaction  $controls_demo $controls_practice_market i.yr if ma_flg==1, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel replace

regress post_6mon_allowed i.post_period  interaction  $controls_demo $controls_practice_market i.yr if ma_flg==0, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel append

 log close 

*********************************
//Forest Plot - Figure 2
********************************
rename post_6mon_out_radiation_cost post_6mon_out_rad_cost
rename post_6mon_out_imaging_cost post_6mon_out_ima_cost
rename post_6mon_out_em_noncan_cost post_6mon_emnoncan_cost
rename post_6mon_out_em_can_cost post_6mon_emcan_cost

global cost post_6mon_allowed post_6mon_oop post_6mon_er_cost post_6mon_inp_cost post_6mon_out_cost post_6mon_allowed_rx post_6mon_chemocpt_allowed post_6mon_out_lab_cost  post_6mon_out_rad_cost post_6mon_out_ima_cost  

foreach x in  $cost {
eststo `x': regress `x' i.post_period interaction  $controls_demo $controls_practice_market i.yr, cluster(attributedtin_2)
}

coefplot (post_6mon_allowed, label(Allowed Cost))  (post_6mon_oop, label(OOP Cost)) (post_6mon_inp_cost, label(Inp Cost)) (post_6mon_out_cost, label(Out Cost)) (post_6mon_allowed_rx, label(Rx Cost)) (post_6mon_chemocpt_allowed, label(Chemo Cost)) (post_6mon_out_lab_cost, label(Lab Cost)) (post_6mon_out_rad_cost, label(Radiation Cost)) (post_6mon_out_ima_cost, label(Imaging Cost)) (post_6mon_emcan_cost, label(E&M Cancer Cost)) (post_6mon_emnoncan_cost, label(E&M non-Cancer Cost)) , drop(_cons) xline(0) keep(interaction)

graph save forestplot_full,replace 



/*with state FE
encode practice_state,gen(practice_state_nostring)
local dd_resultstable2 "dd_resultstable2_state_FE" 

global controls_practice_market episode_vol npi_anthem_volume npi_radiation npi_medical sys_aff_aha2 academic_aff_pos2 penetration i.practice_state_nostring

*high and low risk
regress post_6mon_allowed i.post_period i.ocm_practice interaction  $controls_demo $controls_practice_market i.yr if high_risk==1, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel replace

regress post_6mon_allowed i.post_period i.ocm_practice interaction  $controls_demo $controls_practice_market i.yr if high_risk==0, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel append


foreach x in  $cost {
regress `x' i.post_period i.ocm_practice interaction  $controls_demo $controls_practice_market, cluster(attributedtin_2)
outreg2 using `dd_resultstable2', excel append
}
*/
log close 


/*
global pre chemo_start_episode immun_start_episode post_6mon_er_chemo_cnt post_6mon_inp_chemo_cnt post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_lab_cost post_6mon_out_radiation_util post_6mon_out_imaging_util post_6mon_out_lab_util

foreach x in  $pre {
regress `x' i.post_period i.ocm_practice interaction  $controls_demo $controls_practice_market
outreg2 using dd_resultstable2, excel append
}
*/
////////////////////////////////////////////////////////////////////////////////
//// TABLE  3 ////////////////
/////////////////////////////////////////////////////////////////////////////////
local suffix: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")

log using "F:\Active_Projects\EHSR_OCM_Upenn\Analysis\Stata\output\summary statistics and regression util  Full Sample Table 3 `suffix'.log" ,replace

//Utilization Summary Statistics 
*create extensive margin 
foreach x in  post_6mon_inp_cnt post_6mon_er_cnt {
    gen `x'ext=1 if  `x'>0 & `x'<.
	replace `x'ext=0 if `x'==0
}

sum post_6mon_inp_cntext post_6mon_inp_cnt post_6mon_er_cntext post_6mon_er_cnt

*chemo_start_episode immun_start_episode post_6mon_er_chemo_cnt post_6mon_inp_chemo_cnt post_6mon_out_em_can_cost post_6mon_out_em_noncan_cost post_6mon_out_radiation_cost post_6mon_out_imaging_cost post_6mon_out_lab_cost post_6mon_out_radiation_util post_6mon_out_imaging_util post_6mon_out_lab_util

//Treatment group
*baseline peirod
 outreg2 using summarystats_table3basetreatfull if baseline_period==1 &ocm_practice==1, word sum(log) replace keep(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)  sortvar(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util  post_6mon_out_lab_util  post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)


*intervention period 
 outreg2 using summarystats_table3inttreatfull if post_period==1 & ocm_practice==1, word sum(log) replace keep(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)  sortvar(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util  post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)

//Comparison Group
*baseline peirod
 outreg2 using summarystats_table3basecontrolful if baseline_period==1 &ocm_practice==0, word sum(log) replace keep(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)  sortvar(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util  post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)

*intervention period 
 outreg2 using summarystats_table3intcontrolfull if post_period==1 & ocm_practice==0, word sum(log) replace keep(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)  sortvar(post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt post_6mon_out_imaging_util  post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag)


//Difference in Differences Estimate 
//Utilization  Regressions 
*keating 
*Practice-level covariates include measures of practice size, provider specialty mix, hospital ownership and health system affiliation, and academic medical center affiliation
*market level county level market population, market demographic factors, market healthcare provider supply, and market-level exposure to Medicare Advantage
*include similar control set as in Keating et al.
global controls_demo breast_cancer_flag lung_cancer_flag colorectal_cancer_flag prostate_cancer_flag pancreatic_cancer_flag other_cancer_flag age medianfamilyincome medianfamilyincome_miss ratiowhite ratioasian ratioblack ratiowhitehisp ratioblackhisp female dci_score ma_flg

global controls_practice_market  npi_anthem_volume npi_radiation npi_medical i.attributedtin_2

global util  post_6mon_inp_cntext  post_6mon_er_cntext post_6mon_inp_cnt post_6mon_inp_chemo_cnt post_6mon_er_cnt   post_6mon_er_chemo_cnt  post_6mon_out_imaging_util post_6mon_out_lab_util post_6mon_out_radiation_util timely_chemo_br_colon_flag  end_hosp_flag end_chemo_flag end_hospice_flag

sum $controls_demo $controls_practice_market
sum $util

*identify treatment and post periods
*gen interaction=post_period*ocm_practice

*local dd_resultstable3 "dd_resultstable3_FE_`suffix'"
 
local dd_resultstable3predicted "dd_table3_FULL_`suffix'" 

foreach x in  $util {
regress `x' i.post_period interaction  $controls_demo $controls_practice_market i.yr,cluster(attributedtin_2)
**for comment on prediction
predict yhat`x'
local predp=yhat`x'
outreg2 using `dd_resultstable3predicted', excel append addstat(Predicted Outcome., `predp')
drop yhat`x' 

sum $util  if ocm_practice==1
sum $util  if ocm_practice==0
}





/*with State FE
global controls_practice_market episode_vol npi_anthem_volume npi_radiation npi_medical sys_aff_aha2 academic_aff_pos2 penetration i.practice_state_nostring
local dd_resultstable3 "dd_resultstable3_state_FE" 

foreach x in  $util {
regress `x' i.post_period i.ocm_practice interaction  $controls_demo $controls_practice_market ,cluster(attributedtin_2)
outreg2 using `dd_resultstable3', excel append
}


*with year fixed effects and drop H1 2014 
local dd_resultstable3 "dd_resultstable3_robust" 
drop if halfyear==108

foreach x in  $util {
regress `x' i.post_period i.ocm_practice interaction  $controls_demo $controls_practice_market i.yr,cluster(attributedtin_2)
outreg2 using `dd_resultstable3', excel append
}

foreach x in  $util {
regress `x' i.post_period i.attributedtin_2 interaction  $controls_demo $controls_practice_market i.yr,cluster(attributedtin_2)
outreg2 using `dd_resultstable3', excel append
}

*/

log close 