//title: ECON 1430 Stata Collect Workshop Cleaning
//purpose: cleaning and merging data between ACS and Medicaid
//author: Malcolm Certain
//date: 2025-04-22

version 18

global root "C:/Users/macer/OneDrive/Documents/Collect Workshop"

use "$root/acs_data", clear

drop if year >= 2020

//race variables
gen white = (race == 1)
gen black = (race == 2)
gen native = (race == 3)
gen asian = (race == 4 | race == 5 | race == 6)
gen mixed_race = (race == 8 | race == 9)

//gender variable
gen male = (sex == 1)

//hispanic variable
gen hispanic = (hispan != 0)

//education variables
gen hs_educ = (educ >= 6)
gen col_educ = (educ >= 10)

collapse (mean) white black native asian mixed_race male hispanic hs_educ col_educ [iweight = perwt], by(year statefip region)

rename statefip stfips

save "$root/acs_data_collapse", replace

use "$root/ehec_data", clear

merge 1:1 year stfips using "$root/acs_data_collapse", keep(3) nogen

gen ever_exp = (yexp2 != .)
gen exp = (yexp2 <= year)
gen t_exp = year - yexp2 + 1
replace t_exp = 0 if t_exp == .
gen n_exp = (exp == 0)

save "$root/workshop_data", replace