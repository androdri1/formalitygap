********************************************************************************
**** This do-file analyses hoe informality affects micro-enterprise survival in 
**** Colombia
**** It uses data from 2012 to 2016
**** v2: Growth indicators were discarded as they are related to too much noise
****     Annual sales per worker is the norm
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

cd "$dataFolder"
cd "$dataFolder"

use "informality_gap.dta", clear
////////////////////////////////////////////////////////////////////////////////
********** Exercises replicating Nordman WD2016 but for microenterprises *******	
**************** TOMA TODA LA MUESTRA DE EMPRESAS ******************************
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
 
glo outcome1="l_aventas"


// 1. Todos, 2. Todos balanceado, 3-4. Género del dueño, 5-7. Edad de la empresa, 8-10. Sector, 11-12. Crecimiento sostenido o no, 13-14 Motivo
glo conda1 =" 1==1 " // All firms
glo conda2 =" L.l_aventas!=. & L2.l_aventas!=. & L3.l_aventas!=. " // At least 3 measurements
glo conda3 =" mujeres_propietaria>0 "  // At least one female owner
glo conda4 =" mujeres_propietaria==0 " // All male owner
glo conda5 =" nueva_m==1 | joven_m==1 "       // 1-3 years old
glo conda6 =" establecida_m==1 " // 3-5 years old
glo conda7 =" madura_m==1 | vieja_m==1 "      // 5+ years old
glo conda8 =" ciiu==1 "      // Industry
glo conda9 =" ciiu==2 "      // Commerce
glo conda10=" ciiu==3 "      // Services
glo conda11=" aparBase<5 " // 4 or less
glo conda12=" aparBase==5 " // Fully balanced
glo conda13=" Nmotivo_emprend==0 " // Opportunity
glo conda14=" Nmotivo_emprend==1 " // Necessity
glo conda15=" (dpto==5 | dpto==11 | dpto==76 | dpto==8) " // Big city (Bogota, Medellin, Cali, Barranquilla)
glo conda16=" !(dpto==5 | dpto==11 | dpto==76 | dpto==8) " // Other cities

	glo qregpdCovars ="mujeres_propietaria dispositivos_TIC red " // nueva_m joven_m establecida_m madura_m ciiu_2 ciiu_3
	glo qregpdCovars_1 $qregpdCovars
	glo qregpdCovars_2 $qregpdCovars
	glo qregpdCovars_3 ="                  dispositivos_TIC red"
	glo qregpdCovars_4 ="                  dispositivos_TIC red"
	glo qregpdCovars_5 $qregpdCovars
	glo qregpdCovars_6 $qregpdCovars
	glo qregpdCovars_7 $qregpdCovars
	glo qregpdCovars_8 $qregpdCovars
	glo qregpdCovars_9 $qregpdCovars
	glo qregpdCovars_10 $qregpdCovars
	glo qregpdCovars_11 $qregpdCovars
	glo qregpdCovars_12 $qregpdCovars
	glo qregpdCovars_13 $qregpdCovars
	glo qregpdCovars_14 $qregpdCovars

////////////////////////////////////////////////////////////////////////////////
// Quintile Regressions
////////////////////////////////////////////////////////////////////////////////

if 1==1 { // Takes apx 1/2 days
	cap matrix drop CoefQ
	cap matrix drop CoefFE

	loc k=1 // 1. Annual sales
	loc j=1 // 1. Definicion laxa (ninguna de las 3 formalidad)

	forval i=2(1)4 { // 1. Labour definition f1_0 ; 2. Firm-legal/Extensive definition f2_0 ; 3. Intensive margin Ulysea f3_0 ; 4. Intensive margin without Extensive margin informal
	// No funciona la 4!!! Below
		foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 {	// 1-2. Todos, 3-4. Género del dueño, 5-7. Edad de la empresa, 8-10. Sector, 11-12 panel balanceado, 13-14 motivacion

		
			disp "xtreg ${outcome`k'} micro_e size ${qregpdCovars_`m'} i.year ${f`i'_`j'_`m'} if  ${conda`m'} ,  fe vce(robust)"
		
			* Ver1: Basic controls, lowest category of informality .....
			xtreg ${outcome`k'} micro_e size ${qregpdCovars_`m'} i.year ${f`i'_`j'} if  ${conda`m'} ,  fe vce(robust)
			mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j',`m',1, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]
			
			* Ver2: Cuenta propia ..................................................
			xtreg ${outcome`k'} ${qregpdCovars_`m'} i.year ${f`i'_`j'} if L.cuenta_propia==1 & ${conda`m'} ,  fe vce(robust)
			mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j',`m' ,2, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]

			* Ver3: Micro empresa .................................................
			*xtreg ${outcome`k'} size ${qregpdCovars_`m'} i.year ${f`i'_`j'} if L.micro_e==1 & ${conda`m'} ,  fe vce(robust)
			*mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j',`m' ,3, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]	
			
			* Ver4: Microe-empresa per worker ..........................................
			xtreg ${outcome`k'}_pw size ${qregpdCovars_`m'} i.year ${f`i'_`j'} if L.micro_e==1 & ${conda`m'}  ,  fe vce(robust)
			mat CoefFE = nullmat(CoefFE) \ [`k',`i',`j',`m' ,4, _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]	

			forval q=0.05(0.025)0.975 {
				loc nq = round(`q'*1000)
				disp in red "Corriendo definición `i', quintile `q' / `nq'"
				
				disp "qregpd ${outcome`k'} micro_e size  ${qregpdCovars_`m'} ${f`i'_`j'} if ${conda`m'} , quantile (`q') id(id_firm) fix(year) "
				
				****************  d. Fixed Effect Panel data with the lowest= 1 category  of labor formality *************
				* Ver1: Basic controls, lowest category of informality .....
				qregpd ${outcome`k'} micro_e size  ${qregpdCovars_`m'} ${f`i'_`j'} if ${conda`m'} , quantile (`q') id(id_firm) fix(year) 
				mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j',`m', 1, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]
				est store r`nq'_1
				
				* Ver2: Cuenta propia ..................................................
				cap qregpd ${outcome`k'} ${qregpdCovars_`m'} ${f`i'_`j'}  if L.cuenta_propia==1 & ${conda`m'}, quantile (`q') id(id_firm) fix(year) 
				if _rc==0 mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j',`m', 2, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]		
				est store r`nq'_2
				
				* Ver3: Microe-empresa .................................................
				*cap qregpd ${outcome`k'} size ${qregpdCovars_`m'} ${f`i'_`j'}  if L.micro_e==1 & ${conda`m'}, quantile (`q') id(id_firm) fix(year) 
				*if _rc==0 mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j',`m', 3, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]		
				*est store r`nq'_3
				
				* Ver4: Micro empresa per worker .......................................
				cap qregpd ${outcome`k'}_pw size ${qregpdCovars_`m'} ${f`i'_`j'}  if L.micro_e==1 & ${conda`m'}, quantile (`q') id(id_firm) fix(year) 
				if _rc==0 mat CoefQ = nullmat(CoefQ) \ [`k',`i',`j',`m', 4, `q' , _b[${f`i'_`j'}] , _se[${f`i'_`j'}] ]		
				est store r`nq'_4	
				
			}

			esttab r50_1 r100_1 r250_1 r500_1 r750_1 r950_1 using "$outputs\tables\qregpd_All_Def_i`i'_j`j'_m`m'_k`k'" , se star(* .1 ** .05 *** .01)  stats(N r2) replace

			esttab r50_2 r100_2 r250_2 r500_2 r750_2 r950_2 using "$outputs\tables\qregpd_CP_Def_i`i'_j`j'_m`m'_k`k'" , se star(* .1 ** .05 *** .01)  stats(N r2) replace			
			
			*esttab r50_3 r100_3 r250_3 r500_3 r750_3 r950_3 using "$outputs\tables\qregpd_Mi_Def_i`i'_j`j'_m`m'_k`k'" , se star(* .1 ** .05 *** .01) stats(N r2) replace
			
			esttab r50_4 r100_4 r250_4 r500_4 r750_4 r950_4 using "$outputs\tables\qregpd_MipW_Def_i`i'_j`j'_m`m'_k`k'" , se star(* .1 ** .05 *** .01) stats(N r2) replace
						
		}
	}


	mat list CoefQ
	mat colnames CoefQ  = outcome  inforDef  acid  conda  ver  quintile beta  se
	mat colnames CoefFE = outcomeF inforDefF acidF condaF verF          betaF seF

	svmat CoefQ , names(col)
	svmat CoefFE , names(col)

	gen lb = beta - 1.96* se
	gen ub = beta + 1.96* se
	gen betaFe=.
	gen lbFe=.
	gen ubFe=.

	save resultadosGAP_v2_heterog , replace
}


////////////////////////////////////////////////////////////////////////////////
// Gráficas
////////////////////////////////////////////////////////////////////////////////

use resultadosGAP_v2_heterog, clear

* .................
glo title_d2_v1 = "Firm-legal definition of informality"
glo options_d2_v1_k1=" ylabel(-.2(0.1).8)"

glo title_d3_v1 = "Intensive margin definition of informality"
glo options_d3_v1_k1=" ylabel(-.2(0.1).8)"
* .................
glo title_d2_v2 = "(Cuenta Propia) Firm-legal definition of informality"
glo options_d2_v2_k1=" ylabel(-.2(0.1).8)"

glo title_d3_v2 = "(Cuenta Propia) Intensive margin definition of informality"
glo options_d3_v2_k1=" ylabel(-.2(0.1).8)"
* .................
glo title_d2_v4 = "(Microemp per worker) Firm-legal definition of informality"
glo options_d2_v4_k1=" ylabel(-.2(0.1).8)"

glo title_d3_v4 = "(Microemp per worker) Intensive margin definition of informality"
glo options_d3_v4_k1=" ylabel(-.2(0.1).8)"

/*
replace beta=. if (beta<-.4 | beta>.1) & inforDef==2 & outcome==1
replace lb=.   if (beta<-.4 | beta>.1) & inforDef==2 & outcome==1
replace ub=.   if (beta<-.4 | beta>.1) & inforDef==2 & outcome==1

replace lb=.   if (lb<-.4 | lb>.1) & inforDef==2 & outcome==1
replace ub=.   if (lb<-.4 | lb>.1) & inforDef==2 & outcome==1

replace lb=.   if (ub<-.4 | ub>.1) & inforDef==2 & outcome==1
replace ub=.   if (ub<-.4 | ub>.1) & inforDef==2 & outcome==1

replace beta=. if (beta<-.1 | beta>.4) & inforDef==3 & outcome==1
replace lb=.   if (beta<-.1 | beta>.4) & inforDef==3 & outcome==1
replace ub=.   if (beta<-.1 | beta>.4) & inforDef==3 & outcome==1
*/
gen dropear=0
replace dropear=1 if se==0
replace dropear=1 if abs(lb-ub)>0.4 // Too wide
replace dropear=1 if beta>0.1

replace beta=. if dropear==1
replace lb=.   if dropear==1
replace ub=.   if dropear==1

// We are presenting results as a premium, rather than a 'gap'
foreach varo in beta ub lb betaF betaFe lbFe ubFe  {
	replace `varo'=-`varo'
}

// 1-2. Todos, 3-4. ............................................................
	loc k=1 // 1. Annual sales
	forval i=2(1)3 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin
		foreach v in 1 2 4 { // Version of the regression: 1. All firms, 2. Self-employed 4. Microfirms per worker
		
			twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==1 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==1 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==2 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==2 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "All" 4 "At least 3 measuments" ) cols(1) ) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het1.png", as(png) replace
			
			twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==1 & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==1 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==2 & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==2 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "All" 4 "At least 3 measuments" ) cols(2) position(6) size(medlarge)  ) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					 ${options_d`i'_v`v'_k`k'}			
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het1.pdf", as(pdf) replace			
		}
	}	


// 3-4. Género del dueño ......................................................
	loc k=1 // 1. Annual sales
	forval i=2(1)3 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin
		foreach v in 1 2 4 { // Version of the regression

			twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==3 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==3 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==4 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==4 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "At least 50% female" 4 "Mostly males" ) cols(1)) scheme(plotplain) ///
					  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het2.png", as(png) replace
			if `v'!=2 {
				twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==3 & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
						(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==3 & outcome==`k' , mcolor(black) msymbol(circle)) ///
						(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==4 & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
						(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==4 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
						, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
						yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
						ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
						legend(order(1 "QReg 95% CI" 2 "At least 50% female" 4 "Mostly males" )  cols(2) position(6) size(medlarge)   ) scheme(plotplain) ///
						 ${options_d`i'_v`v'_k`k'}			
			}
			else {
				twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==3 & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
						(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==3 & outcome==`k' , mcolor(black) msymbol(circle)) ///
						(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==4 & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
						(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==4 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
						, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
						yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
						legend(order(1 "QReg 95% CI" 2 "Female" 4 "Male" )  cols(2) position(6)  ) scheme(plotplain) ///
						ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
						 ${options_d`i'_v`v'_k`k'}							
			}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het2.pdf", as(pdf) replace					
		}
	}	
	
	


// 5-7. Edad de la empresa ......................................................
	loc k=1 // 1. Annual sales
	forval i=2(1)3 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin
		foreach v in 1 2 4 { // Version of the regression

			twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==5 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==5 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==6 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==6 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==7 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==7 & outcome==`k' , ) ///					
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Less than 3 years old" 4 "3-5 years old" 6 "5 years old and above" ) cols(1)) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het3.png", as(png) replace
			twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==5 & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==5 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==6 & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==6 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==7 & outcome==`k' , lcolor(dkgreen%30) lpattern(shortdash_dot) mcolor(dkgreen%30) msize(vsmall) msymbol(diamond)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==7 & outcome==`k' , mcolor(dkgreen) msymbol(diamond) ) ///						
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					legend(order(1 "QReg 95% CI" 2 "Less than 3 years old" 4 "3-5 years old" 6 "5 years old and above" )  cols(2) position(6) size(medlarge)  ) scheme(plotplain) ///
					  ${options_d`i'_v`v'_k`k'}			
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het3.pdf", as(pdf) replace					
		}
	}	
	
	
// 8-10. Sector ......................................................
	loc k=1 // 1. Annual sales
	forval i=2(1)3 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin
		foreach v in 1 2 4 { // Version of the regression

			twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==8  & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==8  & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==9  & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==9  & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==10 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==10 & outcome==`k' , ) ///						
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Industry" 4 "Commerce" 6 "Services" ) cols(1)) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het4.png", as(png) replace
			twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==8  & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==8  & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==9  & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==9  & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==10 & outcome==`k' , lcolor(dkgreen%30) lpattern(shortdash_dot) mcolor(dkgreen%30) msize(vsmall) msymbol(diamond)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==10 & outcome==`k' , mcolor(dkgreen) msymbol(diamond) ) ///						
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Industry" 4 "Commerce" 6 "Services" )  cols(2) position(6) size(medlarge)  ) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					 ${options_d`i'_v`v'_k`k'}			
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het4.pdf", as(pdf) replace					
		}
	}	
	

//  11-12 time in the panel ......................................................
	loc k=1 // 1. Annual sales
	forval i=2(1)3 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin
		foreach v in 1 2 4 { // Version of the regression

			twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==11 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==11 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==12 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==12 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Stable" 4 "Growers" )) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het5.png", as(png) replace
			
			twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==11 & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==11 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==12 & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==12 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Stable" 4 "Growers" )  cols(2) position(6) size(medlarge)  ) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  ${options_d`i'_v`v'_k`k'}			
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het5.pdf", as(pdf) replace					
		}
	}	
	

//  13-14 motivacion ......................................................
	loc k=1 // 1. Annual sales
	forval i=2(1)3 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin
		foreach v in 1 2 4 { // Version of the regression

			twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==13 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==13 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==14 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==14 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Opportunity" 4 "Necessity" ) cols(1)) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het6.png", as(png) replace
			
			twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==13 & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==13 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==14 & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==14 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Opportunity" 4 "Necessity" )  cols(2) position(6) size(medlarge)  ) scheme(plotplain)	 ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  ${options_d`i'_v`v'_k`k'}	
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het6.pdf", as(pdf) replace					
		}
	}	
	
//  15-16 Ciudad grande vs otras ......................................................
	loc k=1 // 1. Annual sales
	forval i=2(1)3 { // 1. Labour definition ; 2. Firm-legal definition; 3. Intensive margin
		foreach v in 1 2 4 { // Version of the regression

			twoway 	(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==15 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==15 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rarea lb ub quintile     if inforDef==`i'& ver==`v' & conda==16 & outcome==`k' , fcolor(gs11%30) lcolor(gs11%30)) ///
					(connected beta quintile  if inforDef==`i'& ver==`v' & conda==16 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Large cities" 4 "Other cities" ) cols(1)) scheme(plotplain) ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  title("${title_d`i'_v`v'}") ${options_d`i'_v`v'_k`k'}
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het7.png", as(png) replace
			
			twoway 	(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==15 & outcome==`k' , lcolor(black%30) mcolor(black%30) msize(vsmall) msymbol(circle)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==15 & outcome==`k' , mcolor(black) msymbol(circle)) ///
					(rcapsym lb ub quintile  if inforDef==`i'& ver==`v' & conda==16 & outcome==`k' , lcolor(maroon%30) lpattern(dash_dot) mcolor(maroon%30) msize(vsmall) msymbol(Th)) ///
					(scatter beta  quintile  if inforDef==`i'& ver==`v' & conda==16 & outcome==`k' , mcolor(maroon) msymbol(Th) lpattern(dash_dot)) ///
					, ytitle("Difference on `: var label ${outcome`k'}' per " "worker: formal relative to informal") ///
					yline(0, lpattern(solid))  xtitle( "`: var label ${outcome`k'}' per worker quantiles") ///
					legend(order(1 "QReg 95% CI" 2 "Large cities" 4 "Other cities" )  cols(2) position(6) size(medlarge)  ) scheme(plotplain)	 ///
					ytitle(, size(medlarge)) ylabel(, labsize(medlarge)) xtitle(, size(medlarge)) xlabel(, ) ///
					  ${options_d`i'_v`v'_k`k'}	
			graph export "$outputs\figures\qreg_${outcome`k'}_d`i'_v`v'_het7.pdf", as(pdf) replace					
		}
	}	
		
	

