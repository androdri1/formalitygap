********************************************************************************
**** This do-file analyses hoe informality affects micro-enterprise survival in 
**** Colombia
**** It uses data from 2012 to 2016
**** v2: Growth indicators were discarded as they are related to too much noise
****     Annual sales per worker is the norm
**** Please do first:
*    ssc install moremata
*    ssc install qregpd
********************************************************************************
clear all
set more off
set matsize 800

* ssc install moremata
* ssc install qregpd // moremata is required!!

if "`c(username)'"== "paul.rod" {
	global dataFolder="/dataeco01/economia/usuarios/paul.rodriguez/informalitygap/archivosdta"	
	global outputs=   "/dataeco01/economia/usuarios/paul.rodriguez/informalitygap/resultadosregresiones"	
}
if "`c(username)'"== "paul.rodriguez"{
	global dataFolder="G:\.shortcut-targets-by-id\1Bd8bkvnOVmG2grWiaB5Ygn7k2Ac3MX30\Informalidad y Brechas Distribucion Ganancias Colombia\archivos .dta"
	global outputs="G:\.shortcut-targets-by-id\1Bd8bkvnOVmG2grWiaB5Ygn7k2Ac3MX30\Informalidad y Brechas Distribucion Ganancias Colombia\\resultados regresiones"
}

if "`c(username)'"== "luis.gutierrez"{
	global dataFolder="L:\Proyectos\a new project Microenterprises\Colombia\"
	global outputs="L:\Proyectos\a new project Microenterprises\Colombia\"
	
}

*cd "/Volumes/Seagate Backup Plus Drive/proyectos/a new project Microenterprises/Colombia/" /* apto -disco portatil*/
*cd "L:\Proyectos\a new project Microenterprises/colombia/"


////////////////////////////////////////////////////////////////////////////////	
// Load dataset
////////////////////////////////////////////////////////////////////////////////


glo baseCovars ="micro_e size2 propiedad_mujer dispositivos_TIC red nueva_m joven_m establecida_m madura_m i.ciiu i.year i.dpto"


***********  Using as measure of formality those related to legally established/extensive  ******
glo f2_0 = "formalExt_le" //"f0E"
glo f2_1 = "formalExt_st" //"f3EE"
***********"" //  Using as measure of intensive formality  ******
glo f3_0 = "formalInt_le" //"f0I"
glo f3_1 = "formalInt_st" //"f0IE"
 
glo outcome1 l_salariomedio 
glo outcome2 size
glo outcome3 prestamo 
glo outcome4 prest_Instfin

cd "$dataFolder"
use "informality_gap.dta", clear

est drop _all
////////////////////////////////////////////////////////////////////////////////
// OLS and FE Regressions
////////////////////////////////////////////////////////////////////////////////
cd "$dataFolder"
use "informality_gap.dta", clear

xtset id_firm year
gen formalExt_le = 1-f0E
gen formalExt_st = 1-f3EE

gen formalInt_le = 1-f0I   if formalExt_le==1
gen formalInt_st = 1-f0IE  if formalExt_st==1 

label var formalExt_le "Formal Extensive"
label var formalExt_st "Formal Extensive Strict"
label var formalInt_le "Formal Intensive"
label var formalInt_st "Formal Intensive Strict"


xtile Q=l_aventas_pw, n(3)
tab Q
tab Q, gen(Qd)

gen Q1=L.Qd1
gen Q2=L.Qd2
gen Q3=L.Qd3

label var Q1 "Low Productivity"
label var Q2 "Mid Productivity"
label var Q3 "High Productivity"

////////////////////////////////////////////////////////////////////////////////
// Regressions point estimate

if 1==0 {

	cap matrix drop CoefQ
	cap matrix drop CoefFE
	glo qregpdCovars ="propiedad_mujer dispositivos_TIC red nueva_m joven_m establecida_m madura_m ciiu_2 ciiu_3"

	forval k=1(1)4 { // 1. log wages, 2. size; 3. prestamo,  4.prest_Instfin
	forval j=0(1)1 { // 1. Definicion laxa (ninguna de las 3 formalidad) ; // 2. Definicion acida (no cumple con alguna de las 3)
	forval i=2(1)3 { // 2. Firm-legal/Extensive definition f2_0 ; 3. Intensive margin Ulysea f3_0

		* Ver1: d=1 Todas ..................................................	
		xtreg ${outcome`k'} $qregpdCovars i.year ${f`i'_`j'} ,  fe vce(robust)
		est store fe_1_`i'_`j'_`k'

	}
	}
	}

	disp in red "Extensive margin, lenient"
	esttab 	fe_1_2_0_1 ///
			fe_1_2_0_2 ///
			fe_1_2_0_3 ///
			fe_1_2_0_4 ///
			using "$outputs/tables/meca"  , se  ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(${f2_0}) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		replace booktabs fragment	

	disp in red "Extensive margin, strict"
	esttab 	fe_1_2_1_1 ///
			fe_1_2_1_2 ///
			fe_1_2_1_3 ///
			fe_1_2_1_4 ///
			using "$outputs/tables/meca" , se   ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(${f2_1}) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		append booktabs fragment			

	disp in red "Intensive margin, lenient"		
	esttab 	fe_1_3_0_1 ///
			fe_1_3_0_2 ///
			fe_1_3_0_3 ///
			fe_1_3_0_4 ///
			using "$outputs/tables/meca" , se   ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(${f3_0}) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		append booktabs fragment		
		
	disp in red "Intensive margin, strict"		
	esttab 	fe_1_3_1_1 ///
			fe_1_3_1_2 ///
			fe_1_3_1_3 ///
			fe_1_3_1_4 ///
			using "$outputs/tables/meca" , se  ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(${f3_1}) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		append booktabs fragment			
		
}


////////////////////////////////////////////////////////////////////////////////
// Regressions by tertiles of sales distribution

if 1==1 {

	cap matrix drop CoefQ
	cap matrix drop CoefFE
	glo qregpdCovars ="propiedad_mujer dispositivos_TIC red nueva_m joven_m establecida_m madura_m ciiu_2 ciiu_3"

	forval k=1(1)4 { // 1. log wages, 2. size; 3. prestamo,  4.prest_Instfin
	forval j=0(1)1 { // 1. Definicion laxa (ninguna de las 3 formalidad) ; // 2. Definicion acida (no cumple con alguna de las 3)
	forval i=2(1)3 { // 2. Firm-legal/Extensive definition f2_0 ; 3. Intensive margin Ulysea f3_0

		* Ver1: d=1 Todas ..................................................
		xtreg ${outcome`k'} $qregpdCovars i.year c.${f`i'_`j'}#c.Q1 c.${f`i'_`j'}#c.Q2 c.${f`i'_`j'}#c.Q3 ,  fe vce(robust)
		est store fe_1_`i'_`j'_`k'

	}
	}
	}

	disp in red "Extensive margin, lenient"
	esttab 	fe_1_2_0_1 ///
			fe_1_2_0_2 ///
			fe_1_2_0_3 ///
			fe_1_2_0_4 ///
			using "$outputs/tables/mecaQ"  , se  ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(c.${f2_0}#c.Q1 c.${f2_0}#c.Q2 c.${f2_0}#c.Q3) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		replace booktabs fragment	

	disp in red "Extensive margin, strict"
	esttab 	fe_1_2_1_1 ///
			fe_1_2_1_2 ///
			fe_1_2_1_3 ///
			fe_1_2_1_4 ///
			using "$outputs/tables/mecaQ" , se   ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(c.${f2_1}#c.Q1 c.${f2_1}#c.Q2 c.${f2_1}#c.Q3) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		append booktabs fragment			

	disp in red "Intensive margin, lenient"		
	esttab 	fe_1_3_0_1 ///
			fe_1_3_0_2 ///
			fe_1_3_0_3 ///
			fe_1_3_0_4 ///
			using "$outputs/tables/mecaQ" , se   ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(c.${f3_0}#c.Q1 c.${f3_0}#c.Q2 c.${f3_0}#c.Q3) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		append booktabs fragment		
		
	disp in red "Intensive margin, strict"		
	esttab 	fe_1_3_1_1 ///
			fe_1_3_1_2 ///
			fe_1_3_1_3 ///
			fe_1_3_1_4 ///
			using "$outputs/tables/mecaQ" , se  ///
		stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
		legend label collabels(none) keep(c.${f3_1}#c.Q1 c.${f3_1}#c.Q2 c.${f3_1}#c.Q3) star(* .1 ** .05 *** .01) nodepvars		/// // varlabels(_cons Constant For Informal) 
		append booktabs fragment			
		
}


