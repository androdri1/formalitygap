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
	global outputs="G:\.shortcut-targets-by-id\1Bd8bkvnOVmG2grWiaB5Ygn7k2Ac3MX30\Informalidad y Brechas Distribucion Ganancias Colombia\resultados regresiones"
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


***********  Using as measure of formality those related to labor market ****** (no longer in use)
*glo f1_0 = "f0L2"
*glo f1_1 = "f0L2E"
***********  Using as measure of formality those related to legally established/extensive  ******
glo f2_0 = "f0E"
glo f2_1 = "f3EE"
***********  Using as measure of intensive formality  ******
glo f3_0 = "f0I"
glo f3_1 = "f0IE"

***********  Using as measure of intensive formality, conditional on being extensive formal  ******
glo f4_0 = "f0InoE"
glo f4_1 = "f0IEnoE"
 
glo outcome1="l_aventas" // Ojo, pero en realidad en las regresiones lo usamos es per worker

cd "$dataFolder"
use "informality_gap.dta", clear


////////////////////////////////////////////////////////////////////////////////
// Quintile Regressions
// Results are saved in three forms:
// i. In a matrix that becomes a Stata file, so we can do plots with them
// ii. With outreg2, to have the full tables as supplemental material
// iii. With estout, for basic tables in the appendix
////////////////////////////////////////////////////////////////////////////////
if 1==1 { // Takes apx 1/2 days

	cap matrix drop CoefQ
	cap matrix drop CoefFE
	glo qregpdCovars ="propiedad_mujer dispositivos_TIC red nueva_m joven_m establecida_m madura_m ciiu_2 ciiu_3"

	loc k=1 // 1. Annual sales
	forval j=0(1)1 { // 1. Definicion laxa (ninguna de las 3 formalidad) ; // 2. Definicion acida (no cumple con alguna de las 3)
		est clear
		forval i=4(1)4 { // forval i=2(1)4 { // 1. Labour definition f1_0 ; 2. Firm-legal/Extensive definition f2_0 ; 3. Intensive margin Ulysea f3_0 ; 4. Intensive margin without Extensive margin informal
			
		
			* Ver1: Basic controls, lowest category of informality .....
			xtreg ${outcome`k'} micro_e  $qregpdCovars i.year ${f`i'_`j'}   ,  fe vce(robust)
			mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j',1, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]
			est store fe_1
			outreg2 using "$outputs/tables/qregpd_All_Def`i'_`j'_`k'.xls", excel replace ctitle(FEOLS)
			
			* Ver2: Cuenta propia ..................................................
			xtreg ${outcome`k'} $qregpdCovars i.year ${f`i'_`j'} if L.cuenta_propia==1  ,  fe vce(robust)
			mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j' ,2, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]
			est store fe_2
			outreg2 using "$outputs/tables/qregpd_CP_Def`i'_`j'_`k'.xls", excel replace ctitle(FEOLS)
			
			* Ver3: Micro empresa .................................................
			*xtreg ${outcome`k'} size $qregpdCovars i.year ${f`i'_`j'} if L.micro_e==1  ,  fe vce(robust)
			*mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j' ,3, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]	
			
			* Ver4: Microe-empresa per worker ..........................................
			xtreg ${outcome`k'}_pw size $qregpdCovars i.year ${f`i'_`j'} if L.micro_e==1  ,  fe vce(robust)
			est store fe_4
			mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j' ,4, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]	
			outreg2 using "$outputs/tables/qregpd_MipW_Def`i'_`j'_`k'.xls", excel replace ctitle(FEOLS)

			forval q=0.05(0.025)0.975 {
				loc nq = round(`q'*1000)
				disp in red "Corriendo definiciÃ³n `i', quintile `q' / `nq'"
				
				****************  d. Fixed Effect Panel data with the lowest= 1 category  of labor formality *************
				* Ver1: Basic controls, lowest category of informality .....
				qregpd ${outcome`k'} micro_e   $qregpdCovars ${f`i'_`j'}  , quantile (`q') id(id_firm) fix(year) 
				mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j', 1, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]
				est store r`nq'_1
				outreg2 using "$outputs/tables/qregpd_All_Def`i'_`j'_`k'.xls", excel append ctitle(`q')
				
				* Ver2: Cuenta propia ..................................................
				cap qregpd ${outcome`k'} $qregpdCovars ${f`i'_`j'}  if L.cuenta_propia==1 , quantile (`q') id(id_firm) fix(year) 
				if _rc==0 mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j', 2, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]		
				est store r`nq'_2
				outreg2 using "$outputs/tables/qregpd_CP_Def`i'_`j'_`k'.xls", excel append ctitle(`q')
				
				* Ver3: Microe-empresa .................................................
				*cap qregpd ${outcome`k'} size $qregpdCovars ${f`i'_`j'}  if L.micro_e==1 , quantile (`q') id(id_firm) fix(year) 
				*if _rc==0 mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j', 3, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]		
				*est store r`nq'_3
				
				* Ver4: Micro empresa per worker .......................................
				cap qregpd ${outcome`k'}_pw  $qregpdCovars ${f`i'_`j'}  if L.micro_e==1 , quantile (`q') id(id_firm) fix(year) 
				if _rc==0 mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j', 4, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]		
				est store r`nq'_4	
				outreg2 using "$outputs/tables/qregpd_MipW_Def`i'_`j'_`k'.xls", excel append ctitle(`q')
				
			}

			esttab fe_1 r50_1 r100_1 r250_1 r500_1 r750_1 r950_1 using "$outputs/tables/qregpd_All_Def`i'_`j'_`k'" , se         		///
				stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
				legend label collabels(none) varlabels(_cons Constant ${f`i'_`j'} Informal) star(* .1 ** .05 *** .01) nodepvars	///
				replace	 booktabs fragment
				
			esttab fe_2 r50_2 r100_2 r250_2 r500_2 r750_2 r950_2 using "$outputs/tables/qregpd_CP_Def`i'_`j'_`k'" , se         		///
				stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
				legend label collabels(none) varlabels(_cons Constant ${f`i'_`j'} Informal) star(* .1 ** .05 *** .01) nodepvars		///
				replace booktabs fragment	
				
			esttab fe_4 r50_4 r100_4 r250_4 r500_4 r750_4 r950_4 using "$outputs/tables/qregpd_MipW_Def`i'_`j'_`k'" , se         		///
				stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
				legend label collabels(none) varlabels(_cons Constant ${f`i'_`j'} Informal) star(* .1 ** .05 *** .01) nodepvars		///
				replace booktabs fragment
						
		}
	}
	

	mat list CoefQ
	mat colnames CoefQ  = outcome  inforDef  acid  ver  quintile beta  se
	mat colnames CoefFE = outcomeF inforDefF acidF verF          betaF seF

	svmat CoefQ , names(col)
	svmat CoefFE , names(col)

	gen lb = beta - 1.96* se
	gen ub = beta + 1.96* se
	gen betaFe=.
	gen lbFe=.
	gen ubFe=.

	save resultadosGAP_v2 , replace
	
	
}


////////////////////////////////////////////////////////////////////////////////
// GrÃ¡ficas
////////////////////////////////////////////////////////////////////////////////
cd "$dataFolder"
use resultadosGAP_v2, clear

* .................
glo title_d2_v1 = "Firm-legal definition of informality"
glo options_d2_v1_k1=" ylabel(-.2(0.05).4)"

glo title_d3_v1 = "Intensive margin definition of informality"
glo options_d3_v1_k1=" ylabel(-.2(0.05).4)"

glo title_d4_v1 = "Intensive margin (res) definition of informality"
glo options_d4_v1_k1=" ylabel(-.2(0.05).4)"
* .................
glo title_d2_v2 = "(Cuenta Propia) Firm-legal definition of informality"
glo options_d2_v2_k1=" ylabel(-.2(0.05).4)"

glo title_d3_v2 = "(Cuenta Propia) Intensive margin definition of informality"
glo options_d3_v2_k1=" ylabel(-.2(0.05).4)"

glo title_d4_v2 = "(Cuenta Propia) Intensive margin (res) definition of informality"
glo options_d4_v2_k1=" ylabel(-.2(0.05).4)"
* .................
glo title_d2_v4 = "(Microemp per worker) Firm-legal definition of informality"
glo options_d2_v4_k1=" ylabel(-.2(0.05).4)"

glo title_d3_v4 = "(Microemp per worker) Intensive margin definition of informality"
glo options_d3_v4_k1=" ylabel(-.2(0.05).4)"

glo title_d4_v4 = "(Microemp per worker) Intensive margin (res) definition of informality"
glo options_d4_v4_k1=" ylabel(-.2(0.05).4)"


gen dropear=0
replace dropear=1 if se==0
replace dropear=1 if beta>0.1

replace beta=. if dropear==1
replace lb=.   if dropear==1
replace ub=.   if dropear==1

// We are presenting results as a premium, rather than a 'gap'
foreach varo in beta ub lb betaF betaFe lbFe ubFe  {
	replace `varo'=-`varo'
}



loc k=1 // 1. Annual sales
forval i=2(1)4 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin; 4. Intensive restricted
	foreach v in 1 2 4 { // Version of the regression: 1. All firms, 2. Self-employed 4. Microfirms per worker
	
		sum betaF if inforDefF==`i' & verF==`v' & acidF==0 & outcomeF==`k'
		local betaFE=r(mean)
		sum seF   if inforDefF==`i' & verF==`v' & acidF==0 & outcomeF==`k'
		local seF=r(mean)

		replace betaFe = `betaFE'            if inforDef==`i' & ver==`v' & acid==0 & outcome==`k'
		replace lbFe   = `betaFE'-1.96*`seF' if inforDef==`i' & ver==`v' & acid==0 & outcome==`k'
		replace ubFe   = `betaFE'+1.96*`seF' if inforDef==`i' & ver==`v' & acid==0 & outcome==`k'
		if outcome==2 { // TodavÃ­a no entiendo por quÃ© no funcionan bien estas regresiones de efectos fijos con este outcome
			replace betaFe =.
			replace lbFe   =.
			replace ubFe   =.
		}

		// El png para visualizacion rapida
		twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
				(connected beta quintile  if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , mcolor(black) msymbol(circle)) ///
				(rline lbFe ubFe quintile if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , lcolor(green) lpattern(dash)) ///
				(line betaFe quintile     if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , lcolor(green) lpattern(solid)) ///
				(rarea lb ub quintile     if inforDef==`i'& ver==`v' & acid==1 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
				(connected beta quintile  if inforDef==`i'& ver==`v' & acid==1 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
				, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
				yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
				legend(order(1 "QReg 95% CI" 2 "QReg estimate" 3 "FE 95% CI" 4 "FE estimate" 6 "Strict definition" ) size(medlarge)) scheme(plotplain) ///
				ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, labsize(medlarge)) ///
				  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
		graph export "$outputs/figures/qreg_${outcome`k'}_d`i'_v`v'.png", as(png) replace
		
		if `v'!=2 | `i'!=3 {  // Sin version acida para los cuenta propia bajo intensive margin
			twoway ///
				/// // (rarea lb ub quintile     if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
				(rcapsym lb ub quintile if inforDef==`i'& ver==`v' & acid==0 & outcome==`k', lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
				(scatter beta quintile  if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , mcolor(black) msymbol(circle)) ///
				(rline lbFe ubFe quintile if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , lcolor(green) lpattern(dash)) ///
				(line betaFe quintile     if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , lcolor(green) lpattern(solid)) ///
				/// // (rarea lb ub quintile     if inforDef==`i'& ver==`v' & acid==1 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
				(rcapsym lb ub quintile if inforDef==`i'& ver==`v' & acid==1 & outcome==`k', lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
				(scatter beta quintile  if inforDef==`i'& ver==`v' & acid==1 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
				, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
				yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") scheme(plotplain) ///
				legend(order(1 "QReg 95% CI" 2 "QReg estimate" 3 "FE 95% CI" 4 "FE estimate" 6 "Strict definition" ) cols(3) position(6) size(medlarge) )  ///		
				ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, labsize(medlarge)) ///
				  ${options_d`i'_v`v'_k`k'}
		}
		else { // Sin version acida para los cuenta propia bajo intensive margin
			twoway ///
				/// // (rarea lb ub quintile     if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
				(rcapsym lb ub quintile if inforDef==`i'& ver==`v' & acid==0 & outcome==`k', lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
				(scatter beta quintile  if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , mcolor(black) msymbol(circle)) ///
				(rline lbFe ubFe quintile if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , lcolor(green) lpattern(dash)) ///
				(line betaFe quintile     if inforDef==`i'& ver==`v' & acid==0 & outcome==`k' , lcolor(green) lpattern(solid)) ///
				, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
				yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") scheme(plotplain) ///
				legend(order(1 "QReg 95% CI" 2 "QReg estimate" 3 "FE 95% CI" 4 "FE estimate" ) cols(3) position(6) size(medlarge) )  ///		
				ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
				  ${options_d`i'_v`v'_k`k'}		    			
		}
				  
		graph export "$outputs/figures/qreg_${outcome`k'}_d`i'_v`v'.pdf", as(pdf) replace					
	}
}	


