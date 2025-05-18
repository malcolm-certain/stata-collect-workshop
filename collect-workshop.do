//title: ECON 1430 Stata Collect Workshop
//purpose: teaching how to use collect to create/export tables
//author: Malcolm Certain
//date: 2025-04-22

version 18

global root "C:/Users/macer/OneDrive/Documents/Collect Workshop"

use "$root/workshop_data", clear

********************************************************************************
*********************************BALANCE TABLE**********************************
********************************************************************************

//note: this is not important for difference-in-differences
//since time invariant demographic differences will be eliminated
//but i am showing how to do it in case you don't have diff in diff data
//isolating a single pre-year for this

collect clear
preserve
keep if year == 2013
foreach var of varlist white-col_educ {
	quietly collect mu=(r(mu_2)-r(mu_1)): ttest `var', by(ever_exp) unequal
}
quietly collect style cell result[sd sd_1 sd_2], sformat("(%s)")
quietly collect composite define msd1 = mu_1 sd_1, delimiter( ) trim replace
quietly collect composite define msd2 = mu_2 sd_2, delimiter( ) trim replace
quietly collect composite define msd = mu sd, delimiter( ) trim replace
quietly collect layout (cmdset) (result[msd2 msd1 msd t p])
quietly collect label levels cmdset ///
	1 "% White Only" ///
	2 "% Black Only" ///
	3 "% Native Only" ///
	4 "% Asian Only" ///
	5 "% Mixed Race" ///
	6 "% Male" ///
	7 "% Hispanic" ///
	8 "% HS Degree" ///
	9 "% College Degree" ///
	, modify
quietly collect label levels result ///
	msd1 "Did Not Expand" ///
	msd2 "Expanded" ///
	msd "Difference" ///
	t "t" ///
	p "p" ///
	, modify
quietly collect style header result, title(hide) level(label)
quietly collect style column, dups(center) width(equal)
quietly collect style cell result, nformat(%20.4f) halign(center) valign(center)
quietly collect style cell cell_type[column-header]#cmdset, halign(left)
quietly collect style cell result[t], nformat(%20.2f)
quietly collect style cell cell_type[column-header]#result[t p], font(, italic)
quietly collect style cell border_block, border(right, pattern(nil))
quietly collect style tex, nobegintable centering
quietly collect export "$root/balance_table.tex", tableonly replace
collect preview
restore

********************************************************************************
*****************************REGRESSION TABLE***********************************
********************************************************************************
collect clear
quietly collect yfe="N" stfe="N": reg dins exp, vce(cluster stfips)
quietly collect yfe="N" stfe="N": reg dins exp white-col_educ, vce(cluster stfips)
quietly collect yfe="Y" stfe="Y": reg dins exp i.year i.stfips, vce(cluster stfips)
quietly collect yfe="Y" stfe="Y": reg dins exp i.year i.stfips white-col_educ, vce(cluster stfips)
quietly collect yfe="Y" stfe="Y": reg dins exp t_exp i.year i.stfips, vce(cluster stfips)
quietly collect yfe="Y" stfe="Y": reg dins exp t_exp i.year i.stfips white-col_educ, vce(cluster stfips)
quietly collect remap cmdset[1 2] = OLS
quietly collect remap cmdset[3 4] = DiD
quietly collect remap cmdset[5 6] = LDiD
quietly collect layout (colname[exp t_exp white black native asian mixed_race male female hispanic hs_educ col_educ]#result[_r_b _r_se] result[N yfe stfe]) (OLS DiD LDiD)
quietly collect label levels colname ///
	exp "Expanded Medicaid" ///
	t_exp "Years of Expansion" ///
	white "% White Only" ///
	black "% Black Only" ///
	native "% Native Only" ///
	asian "% Asian Only" ///
	mixed_race "% Mixed Race" ///
	male "% Male" ///
	hispanic "% Hispanic" ///
	hs_educ "% HS Degree" ///
	col_educ "% College Degree" ///
	, modify
quietly collect label levels result ///
	N "N" ///
	yfe "Year FE" ///
	stfe "State FE" ///
	, modify
quietly collect label levels OLS ///
	1 "Simple" ///
	2 "Controls" ///
	, modify
quietly collect label levels DiD ///
	3 "Simple" ///
	4 "Controls" ///
	, modify
quietly collect label levels LDiD ///
	5 "Simple" ///
	6 "Controls" ///
	, modify
quietly collect label dim OLS "OLS", modify
quietly collect label dim DiD "Diff-in-Diff", modify
quietly collect label dim LDiD "Linear Diff-in-Diff", modify
quietly collect style header OLS DiD LDiD, level(label) title(label)
quietly collect style cell OLS DiD LDiD, nformat(%20.4f) halign(center) valign(center)
quietly collect style cell cell_type[column-header]#colname, halign(left)
quietly collect style cell result[N], nformat(%20.0f) border(top)
quietly collect style cell result[_r_se], sformat("(%s)")
quietly collect style header result[_r_b _r_se], level(hide)
quietly collect style column, dups(center)
quietly collect style cell border_block, border(right, pattern(nil))
quietly collect style cell cell_type[column-header]#OLS cell_type[column-header]#DiD cell_type[column-header]#LDiD, border(bottom, pattern(single))
quietly collect stars _r_p 0.05 "*" 0.01 "**" 0.001 "***", attach(_r_b)
quietly collect style tex, nobegintable centering
quietly collect export "$root/reg_table.tex", tableonly replace
collect preview



















