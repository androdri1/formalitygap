********************************************************************************
**** This do-file generates descriptivetables of the formality premium paper
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

glo baseCovars ="micro_e size2 propiedad_mujer dispositivos_TIC red nueva_m joven_m establecida_m madura_m i.ciiu i.year i.dpto"
glo outcome1="l_aventas" // Ojo, pero en realidad en las regresiones lo usamos es per worker

cd "$dataFolder"
use "informality_gap.dta", clear
cd "$outputs/tables"

xtset id_firm year
gen formalExt_le = 1-f0E
gen formalExt_st = 1-f3EE

gen formalInt_le = 1-f0I  if formalExt_le==1
gen formalInt_st = 1-f0IE if formalExt_st==1

label var formalExt_le "Formal Extensive"
label var formalExt_st "Formal Extensive Strict"
label var formalInt_le "Formal Intensive"
label var formalInt_st "Formal Intensive Strict"



// Firm-level factors of formality
label var rut  "$\quad$ Tax registry"
label var Rc_comercio  "$\quad$ Business registry"
label var contabilidad  "$\quad$ Keeps accounting records"
// Labor factors of formality
label var paga_salario "$\quad$ Pays wages"
label var paga_salud  "$\quad$ Contributes to social insurance"
label var paga_prestaciones  "$\quad$ Mandatory fringe benefits and payments"
label var paga_parafiscales "$\quad$ Pays firm-specific wage taxes"
label var propiedad_mujer  "Female ownership"
label var motivo_emprend "Firm based on a perceived opportunity"
// Information and comm. technologies (ICT)
label var dispositivos_TIC  "$\quad$ Ownership of devices"
label var red  "$\quad$ Web presence"
// Age of the firm in years
label var nueva_m  "$\quad$ Less than 1"
label var joven_m  "$\quad$ More than 1, less than 3"
label var establecida_m  "$\quad$ More than 3, less than 5"
label var madura_m  "$\quad$ More than 5, less than 10"
label var vieja_m "$\quad$ More than 10"
// Economic sector                       "
label var ciiu_1  "$\quad$ Manufacture"
label var ciiu_2  "$\quad$ Commerce"
label var ciiu_3 "$\quad$ Services"

recode size (1=1) (2=2) (3/5=3) (6/9=4), gen(sizeC)
tab sizeC, gen(sizeC_)

label var sizeC_1 "$\quad$ Self-employed"
label var sizeC_2 "$\quad$ 2 workers"
label var sizeC_3 "$\quad$ 3 to 5 workers"
label var sizeC_4 "$\quad$ 6 to 9 workers"

replace salario_prom=. if salario_prom==0
label var salario_prom "Average monthly wage"

gen     wage_rel = salario_prom/ 535600 if year==2011
replace wage_rel = salario_prom/ 566700 if year==2012
replace wage_rel = salario_prom/ 589500 if year==2013
replace wage_rel = salario_prom/ 616000 if year==2014
replace wage_rel = salario_prom/ 644350 if year==2015
replace wage_rel = salario_prom/ 689455 if year==2016
label var wage_rel "Average monthly wage (relative to the minimum wage)"
	
gen     sales_rel = ventas_a/ (size*535600) if year==2011
replace sales_rel = ventas_a/ (size*566700) if year==2012
replace sales_rel = ventas_a/ (size*589500) if year==2013
replace sales_rel = ventas_a/ (size*616000) if year==2014
replace sales_rel = ventas_a/ (size*644350) if year==2015
replace sales_rel = ventas_a/ (size*689455) if year==2016
label var sales_rel "Average annual sales per worker (relative to the minimum wage)"	


label var prestamo        "Requested loans"
label var prest_Instfin   "Requested formal loans"
label var prestamo_obtuvo "Obtained loans"

* ........................................
* Formality ladder; the new main definition (lenient)
gen     formCat = 1 if formalExt_le==0
replace formCat = 2 if formalExt_le==1 & formalInt_le==0
replace formCat = 3 if formalExt_le==1 & formalInt_le==1

label def formCat 1 "Informal" 2 "Extensive formal" 3 "Intensive formal"
label val formCat formCat

tab formCat, gen(formCatC_)
label var formCatC_1 "Formality ladder 1: informal"
label var formCatC_2 "Formality ladder 2: extensive formal only"
label var formCatC_3 "Formality ladder 3: intensive formal"

gen LformCat=L.formCat

* ........................................
* Formality ladder; the new main definition
gen     formCatStrict = 1 if formalExt_st==0
replace formCatStrict = 2 if formalExt_st==1 & formalInt_st==0
replace formCatStrict = 3 if formalExt_st==1 & formalInt_st==1

label val formCatStrict formCat

tab formCatStrict, gen(formCatStrictC_)
label var formCatStrictC_1 "Formality ladder strict 1: informal"
label var formCatStrictC_2 "Formality ladder strict 2: extensive formal only"
label var formCatStrictC_3 "Formality ladder strict 3: intensive formal"

gen LformCatStrict=L.formCatStrict



////////////////////////////////////////////////////////////////////////////////
// Descriptive Table
////////////////////////////////////////////////////////////////////////////////
if 1==1 {

	cap texdoc close
	texdoc init descriptive.tex , replace force

	foreach varo in formCatC_1 formCatC_2 formCatC_3 ///
					rut Rc_comercio contabilidad ///
					paga_salud paga_prestaciones paga_parafiscales ///
					ciiu_1 ciiu_2 ciiu_3 ///					
					nueva_m joven_m establecida_m madura_m vieja_m ///									
					sizeC_2 sizeC_3 sizeC_4 ///
					propiedad_mujer motivo_emprend ///					
					prestamo prest_Instfin prestamo_obtuvo ///
					dispositivos_TIC red ///					
					wage_rel sales_rel ///
					{
				
		loc title : var lab `varo'
				
		
		// Para los cuenta propia, formal vs no normal
		qui sum `varo' if cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "		
		qui sum `varo' if formCat==1 & cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		qui sum `varo' if formCat==2 & cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 2.formCat if (formCat==1 | formCat==2) & cuenta_propia==1
		disp "`varo' ${f`i'_`j'} " abs(_b[2.formCat]/_se[2.formCat])
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.69 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.96 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=2.01 loc title = "`title'*"
		qui sum `varo' if formCat==3 & cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 3.formCat if (formCat==2 | formCat==3) & cuenta_propia==1
		disp "`varo' 3.formCat " abs(_b[3.formCat]/_se[3.formCat])
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.69 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.96 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=2.01 loc title = "`title'*"
				
		
		// Para los micro, formal vs no normal
		qui sum `varo' if micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "			
		qui sum `varo' if formCat==1 & micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		qui sum `varo' if formCat==2 & micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 2.formCat if (formCat==1 | formCat==2) & micro_e==1
		disp "`varo' 2.formCat " abs(_b[2.formCat]/_se[2.formCat])
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.69 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.96 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=2.01 loc title = "`title'*"
		qui sum `varo' if formCat==3 & micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 3.formCat if (formCat==2 | formCat==3) & micro_e==1
		disp "`varo' 3.formCat " abs(_b[3.formCat]/_se[3.formCat])
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.69 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.96 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=2.01 loc title = "`title'*"

		disp "`title' \\"
		tex `title' \\
		
	}

	texdoc close

}


////////////////////////////////////////////////////////////////////////////////
// Descriptive Table - Anex
////////////////////////////////////////////////////////////////////////////////
if 1==1 {
	
	cap texdoc close
	texdoc init descriptiveAppendix.tex , replace force


	foreach varo in formCatStrictC_1 formCatStrictC_2 formCatStrictC_3 ///
					rut Rc_comercio contabilidad ///
					paga_salud paga_prestaciones paga_parafiscales ///
					ciiu_1 ciiu_2 ciiu_3 ///					
					nueva_m joven_m establecida_m madura_m vieja_m ///									
					sizeC_2 sizeC_3 sizeC_4 ///
					propiedad_mujer motivo_emprend ///					
					prestamo prest_Instfin prestamo_obtuvo ///
					dispositivos_TIC red ///					
					wage_rel sales_rel ///
					{
				
		loc title : var lab `varo'
				
		
		// Para los cuenta propia, formal vs no normal
		qui sum `varo' if cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "		
		qui sum `varo' if formCatStrict==1 & cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		qui sum `varo' if formCatStrict==2 & cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 2.formCatStrict if (formCatStrict==1 | formCatStrict==2) & cuenta_propia==1
		disp "`varo' ${f`i'_`j'} " abs(_b[2.formCatStrict]/_se[2.formCatStrict])
		if _b[2.formCatStrict]!=0 & abs(_b[2.formCatStrict]/_se[2.formCatStrict])>=1.69 loc title = "`title'*"
		if _b[2.formCatStrict]!=0 & abs(_b[2.formCatStrict]/_se[2.formCatStrict])>=1.96 loc title = "`title'*"
		if _b[2.formCatStrict]!=0 & abs(_b[2.formCatStrict]/_se[2.formCatStrict])>=2.01 loc title = "`title'*"
		qui sum `varo' if formCatStrict==3 & cuenta_propia==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 3.formCatStrict if (formCatStrict==2 | formCatStrict==3) & cuenta_propia==1
		disp "`varo' 3.formCatStrict " abs(_b[3.formCatStrict]/_se[3.formCatStrict])
		if _b[3.formCatStrict]!=0 & abs(_b[3.formCatStrict]/_se[3.formCatStrict])>=1.69 loc title = "`title'*"
		if _b[3.formCatStrict]!=0 & abs(_b[3.formCatStrict]/_se[3.formCatStrict])>=1.96 loc title = "`title'*"
		if _b[3.formCatStrict]!=0 & abs(_b[3.formCatStrict]/_se[3.formCatStrict])>=2.01 loc title = "`title'*"
				
		
		// Para los micro, formal vs no normal
		qui sum `varo' if micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "			
		qui sum `varo' if formCatStrict==1 & micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		qui sum `varo' if formCatStrict==2 & micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 2.formCatStrict if (formCatStrict==1 | formCatStrict==2) & micro_e==1
		disp "`varo' 2.formCatStrict " abs(_b[2.formCatStrict]/_se[2.formCatStrict])
		if _b[2.formCatStrict]!=0 & abs(_b[2.formCatStrict]/_se[2.formCatStrict])>=1.69 loc title = "`title'*"
		if _b[2.formCatStrict]!=0 & abs(_b[2.formCatStrict]/_se[2.formCatStrict])>=1.96 loc title = "`title'*"
		if _b[2.formCatStrict]!=0 & abs(_b[2.formCatStrict]/_se[2.formCatStrict])>=2.01 loc title = "`title'*"
		qui sum `varo' if formCatStrict==3 & micro_e==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 3.formCatStrict if (formCatStrict==2 | formCatStrict==3) & micro_e==1
		disp "`varo' 3.formCatStrict " abs(_b[3.formCatStrict]/_se[3.formCatStrict])
		if _b[3.formCatStrict]!=0 & abs(_b[3.formCatStrict]/_se[3.formCatStrict])>=1.69 loc title = "`title'*"
		if _b[3.formCatStrict]!=0 & abs(_b[3.formCatStrict]/_se[3.formCatStrict])>=1.96 loc title = "`title'*"
		if _b[3.formCatStrict]!=0 & abs(_b[3.formCatStrict]/_se[3.formCatStrict])>=2.01 loc title = "`title'*"

		disp "`title' \\"
		tex `title' \\
		
	}

	texdoc close	

}



////////////////////////////////////////////////////////////////////////////////
// Descriptive Table by sectors - Anex
////////////////////////////////////////////////////////////////////////////////
if 1==1 {

	cap texdoc close
	texdoc init descriptiveSectors.tex , replace force

	foreach varo in formCatC_1 formCatC_2 formCatC_3 ///
					rut Rc_comercio contabilidad ///
					paga_salud paga_prestaciones paga_parafiscales ///
					ciiu_1 ciiu_2 ciiu_3 ///					
					nueva_m joven_m establecida_m madura_m vieja_m ///									
					sizeC_2 sizeC_3 sizeC_4 ///
					propiedad_mujer motivo_emprend ///					
					prestamo prest_Instfin prestamo_obtuvo ///
					dispositivos_TIC red ///					
					wage_rel sales_rel ///
					{
				
		loc title : var lab `varo'
				
		
		// Para los ciiu_1, formal vs no normal
		qui sum `varo' if ciiu_1==1
		loc title = "`title' & `: disp %4.3f r(mean)' "		
		qui sum `varo' if formCat==1 & ciiu_1==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		qui sum `varo' if formCat==2 & ciiu_1==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 2.formCat if (formCat==1 | formCat==2) & ciiu_1==1
		disp "`varo' ${f`i'_`j'} " abs(_b[2.formCat]/_se[2.formCat])
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.69 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.96 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=2.01 loc title = "`title'*"
		qui sum `varo' if formCat==3 & ciiu_1==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 3.formCat if (formCat==2 | formCat==3) & ciiu_1==1
		disp "`varo' 3.formCat " abs(_b[3.formCat]/_se[3.formCat])
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.69 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.96 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=2.01 loc title = "`title'*"
				
		
		// Para los ciiu_2, formal vs no normal
		qui sum `varo' if ciiu_2==1
		loc title = "`title' & `: disp %4.3f r(mean)' "			
		qui sum `varo' if formCat==1 & ciiu_2==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		qui sum `varo' if formCat==2 & ciiu_2==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 2.formCat if (formCat==1 | formCat==2) & ciiu_2==1
		disp "`varo' 2.formCat " abs(_b[2.formCat]/_se[2.formCat])
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.69 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.96 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=2.01 loc title = "`title'*"
		qui sum `varo' if formCat==3 & ciiu_2==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 3.formCat if (formCat==2 | formCat==3) & ciiu_2==1
		disp "`varo' 3.formCat " abs(_b[3.formCat]/_se[3.formCat])
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.69 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.96 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=2.01 loc title = "`title'*"
		
		// Para los ciiu_3, formal vs no normal
		qui sum `varo' if ciiu_3==1
		loc title = "`title' & `: disp %4.3f r(mean)' "			
		qui sum `varo' if formCat==1 & ciiu_3==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		qui sum `varo' if formCat==2 & ciiu_3==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 2.formCat if (formCat==1 | formCat==2) & ciiu_3==1
		disp "`varo' 2.formCat " abs(_b[2.formCat]/_se[2.formCat])
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.69 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=1.96 loc title = "`title'*"
		if _b[2.formCat]!=0 & abs(_b[2.formCat]/_se[2.formCat])>=2.01 loc title = "`title'*"
		qui sum `varo' if formCat==3 & ciiu_3==1
		loc title = "`title' & `: disp %4.3f r(mean)' "
		reg `varo' 3.formCat if (formCat==2 | formCat==3) & ciiu_3==1
		disp "`varo' 3.formCat " abs(_b[3.formCat]/_se[3.formCat])
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.69 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=1.96 loc title = "`title'*"
		if _b[3.formCat]!=0 & abs(_b[3.formCat]/_se[3.formCat])>=2.01 loc title = "`title'*"

		
		
		disp "`title' \\"
		tex `title' \\
		
	}

	texdoc close

}



////////////////////////////////////////////////////////////////////////////////
// Transition matrices
////////////////////////////////////////////////////////////////////////////////

*recode size (1=1) (2=2) (3 4 5 =3) (6 7 8 9=4), gen(sizeC)
*tab sizeC, gen(sizeC_)

foreach varo in formalExt_le formalExt_st formalInt_le formalInt_st sizeC micro_e {
	cap drop L`varo'
	gen L`varo'= L.`varo'
}

// Table 2 .................
tab LformCat formCat, row

// Table A2
tab LformCatStrict formCatStrict, row

// Table 4
tab LsizeC sizeC, row

* ........................................
* Heterogeneity discussion on motivo emprendedor

 tab f0E motivo_emprend
tab LformalExt_le formalExt_le if motivo_emprend==0, row // Necesidad
tab LformalExt_le formalExt_le if motivo_emprend==1, row // Oportunidad


* ........................................
* What is associated to formality transitions

glo determinants  ciiu_2 ciiu_3 ///	// ciiu_1		
				  joven_m establecida_m madura_m vieja_m /// // nueva_m
				  sizeC_2 sizeC_3 sizeC_4 /// // sizeC_1
				 propiedad_mujer motivo_emprend ///					
				 dispositivos_TIC red ///
				 prestamo

est drop _all
reg F.formalExt_le l_aventas $determinants if formalExt_le ==0 , r
	est store r1
	outreg2 using "$outputs/tables/formalityDeterminants.xls", excel replace label
reg F.formalExt_st l_aventas $determinants if formalExt_st ==0 , r
	est store r2
	outreg2 using "$outputs/tables/formalityDeterminants.xls", excel append label
reg F.formalInt_le l_aventas $determinants if formCat ==2 , r
	est store r3
	outreg2 using "$outputs/tables/formalityDeterminants.xls", excel append label
reg F.formalInt_st l_aventas $determinants if formCatStrict ==2 , r
	est store r4
	outreg2 using "$outputs/tables/formalityDeterminants.xls", excel append label
	
esttab r1 r2 r3 r4 , star(* .1 ** .05 *** .01) label se
esttab r1 r2 r3 r4  using "$outputs/tables/formalityDeterminants" , se         		///
	stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
	legend label collabels(none) varlabels(_cons Constant ) star(* .1 ** .05 *** .01)	///
	replace	 booktabs fragment

* ********************	
glo determinants  ciiu_2 ciiu_3 ///	// ciiu_1		
				  joven_m establecida_m madura_m vieja_m /// // nueva_m
				  sizeC_2 sizeC_3 sizeC_4 /// // sizeC_1
				 propiedad_mujer motivo_emprend ///					
				 dispositivos_TIC red	
	
gen jump= F.sizeC>sizeC if sizeC!=. & F.sizeC!=.
label var jump "Growth in number of employees"

est drop _all
reg F.micro_e l_aventas $determinants if micro_e ==0 , r
	est store r1
	outreg2 using "$outputs/tables/sizeDeterminants.xls", excel replace label
reg F.micro_e l_aventas $determinants if micro_e ==1 , r
	est store r2
	outreg2 using "$outputs/tables/sizeDeterminants.xls", excel append label	
reg jump      l_aventas $determinants , r
	est store r3
	outreg2 using "$outputs/tables/sizeDeterminants.xls", excel append label
esttab r1 r2 r3 , star(* .1 ** .05 *** .01) label se
esttab r1 r2 r3 using "$outputs/tables/sizeDeterminants" , se         		///
	stats(N N_g g_min g_max, fmt(%10.0f %10.0f ) labels(Observations Groups "Min Obs per group" "Max Obs per group"))      ///
	legend label collabels(none) varlabels(_cons Constant ) star(* .1 ** .05 *** .01)	///
	replace	 booktabs fragment
	
	
////////////////////////////////////////////////////////////////////////////////
// Productivity distributions
////////////////////////////////////////////////////////////////////////////////
if 1==1 {
cd "$dataFolder"
use "informality_gap.dta", clear

xtset id_firm year
gen formalExt_le = 1-f0E
gen formalExt_st = 1-f3EE

gen formalInt_le = 1-f0I
gen formalInt_st = 1-f0IE 

label var formalExt_le "Formal Extensive Lenient"
label var formalExt_st "Formal Extensive Strict"
label var formalInt_le "Formal Intensive Lenient"
label var formalInt_st "Formal Intensive Strict"
* ........................................
* Formality ladder; the new main definition (lenient)
gen     formCat = 1 if formalExt_le==0
replace formCat = 2 if formalExt_le==1 & formalInt_le==0
replace formCat = 3 if formalExt_le==1 & formalInt_le==1

label def formCat 1 "Informal" 2 "Extensive formal" 3 "Intensive formal"
label val formCat formCat

tab formCat, gen(formCatC_)
label var formCatC_1 "Formality ladder 1: informal"
label var formCatC_2 "Formality ladder 2: extensive formal only"
label var formCatC_3 "Formality ladder 3: intensive formal"

gen LformCat=L.formCat

* ........................................
* Formality ladder; the new main definition
gen     formCatStrict = 1 if formalExt_st==0
replace formCatStrict = 2 if formalExt_st==1 & formalInt_st==0
replace formCatStrict = 3 if formalExt_st==1 & formalInt_st==1

label val formCatStrict formCat

tab formCatStrict, gen(formCatStrictC_)
label var formCatStrictC_1 "Formality ladder strict 1: informal"
label var formCatStrictC_2 "Formality ladder strict 2: extensive formal only"
label var formCatStrictC_3 "Formality ladder strict 3: intensive formal"

gen LformCatStrict=L.formCatStrict


glo op = "lwidth(thick)"
glo opreg = "xscale(range(10 25) noextend) yscale(range(0 .5) noextend) scheme(plotplainblind) ytitle(Density) xtitle(log Annual sales per worker)"

// Formality ladder lenient
tw 	(kdensity l_aventas_pw if formCat==1 , $op ) ///
	(kdensity l_aventas_pw if formCat==2 , $op )  ///
	(kdensity l_aventas_pw if formCat==3 , $op )  ///
	if cuenta_propia==1 , $opreg  ///
	name(a1, replace)  title("(a) Self-employed") ytitle(Density) xtitle(log Annual sales per worker) ///
	legend( order( 1 "Informal" 2 "Formal extensive only" 3 "Formal intensive" ) cols(2) ) 
tw 	(kdensity l_aventas_pw if formCat==1 , $op ) ///
	(kdensity l_aventas_pw if formCat==2 , $op )  ///
	(kdensity l_aventas_pw if formCat==3 , $op )  ///
	if micro_e==1       , $opreg ///
	name(a2, replace)  title("(b) Microfirm")  ///
	legend( order( 1 "Informal" 2 "Formal extensive only" 3 "Formal intensive" ) cols(2) ) 
grc1leg a1 a2 , scheme(plotplainblind) xsize(8) ysize(2) scale(1.5)
graph export "$outputs\figures\kden_l_aventas_formality_ladder.pdf", as(pdf) replace


// Formality ladder sctrict
tw 	(kdensity l_aventas_pw if formCatStrict==1 , $op ) ///
	(kdensity l_aventas_pw if formCatStrict==2 , $op )  ///
	(kdensity l_aventas_pw if formCatStrict==3 , $op )  ///
	if cuenta_propia==1 , $opreg  ///
	name(a1, replace)  title("(a) Self-employed") ytitle(Density) xtitle(log Annual sales per worker) ///
	legend( order( 1 "Informal" 2 "Formal extensive only" 3 "Formal intensive" ) cols(2) ) 
tw 	(kdensity l_aventas_pw if formCatStrict==1 , $op ) ///
	(kdensity l_aventas_pw if formCatStrict==2 , $op )  ///
	(kdensity l_aventas_pw if formCatStrict==3 , $op )  ///
	if micro_e==1       , $opreg ///
	name(a2, replace)  title("(b) Microfirm")  ///
	legend( order( 1 "Informal" 2 "Formal extensive only" 3 "Formal intensive" ) cols(2) ) 
grc1leg a1 a2 , scheme(plotplainblind) xsize(8) ysize(2) scale(1.5)
graph export "$outputs\figures\kden_l_aventas_formality_ladderStrict.pdf", as(pdf) replace


}

////////////////////////////////////////////////////////////////////////////////
// Firm profiles
////////////////////////////////////////////////////////////////////////////////
if 1==1 {


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// New variables

gen edad = 1 if nueva_m==1
replace edad = 2 if joven_m==1
replace edad = 3 if establecida_m==1
replace edad = 4 if madura_m ==1
replace edad = 5 if vieja_m ==1
label define edad 1 "<1" 2 "1-3" 3 "3-5" 4 "5-10" 5 "10+"
label val edad edad


gen     sizeR= size/size if year==2012
replace sizeR= size/L.size if year==2013
replace sizeR= size/L2.size if year==2014
replace sizeR= size/L3.size if year==2015
replace sizeR= size/L4.size if year==2016

cap drop nueva_m2012
gen nueva_m2012x= nueva_m ==1 | joven_m==1 if year==2012
bys id_firm : egen nueva_m2012 = max(nueva_m2012x)
drop nueva_m2012x

cap drop vieja_m2012
gen vieja_mx= vieja_m if year==2012
bys id_firm : egen vieja_m2012 = max(vieja_mx)
drop vieja_mx

foreach varo in f0E f0I {
	cap drop `varo'2012
	gen `varo'x= `varo' if year==2012
	bys id_firm : egen `varo'2012 = max(`varo'x)
	drop `varo'x
}



preserve
collapse (mean) sizeR , by(year f0E)
tw (connected  sizeR  year if f0E==0) (connected  sizeR  year if f0E==1) ,  ///
	legend(order(1 "Formal (Extensive-Lenient)" 2 "Informal" ) position(6) cols(2) ) ///
	ytitle("Relative mean firm size") xtitle(Age firm in years) scheme(plotplainblind)  ///
	ylabel(1 1.05 1.1 1.15) 
graph export "$outputs\figures\sizeR_edad_inform.pdf", as(pdf) replace		
restore


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Figure 3B. Age-size profile V2  (Figure 5A)

preserve // Firma informal en 2012, extensivo; luego dependiendo de su status; jovenes
collapse (mean) sizeR (semean) se= sizeR if nueva_m2012==1 & f0E2012==1, by(year f0E)
gen lb= sizeR - 1.96*se
gen ub= sizeR + 1.96*se

tw 	(connected  sizeR  year if f0E==0) (connected  sizeR  year if f0E==1) ///
	(rcap lb ub year if f0E==0) (rcap lb ub year if f0E==1) ///
	, legend(order(1 "Formal Extensive" 2 "Informal" ) position(6) cols(2) ) ///
	ytitle("Relative mean firm size") xtitle("Year") scheme(plotplainblind)  ///
	ylabel(1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4) title("(a) Firms aged less than" "3 years by 2012")  ///
	name(a1, replace)

restore 
 
 
preserve // Firma informal en 2012, extensivo; luego dependiendo de su status; maduras
collapse (mean) sizeR (semean) se= sizeR if vieja_m2012==1 & f0E2012==1, by(year f0E)
gen lb= sizeR - 1.96*se
gen ub= sizeR + 1.96*se

tw 	(connected  sizeR  year if f0E==0) (connected  sizeR  year if f0E==1) ///
	(rcap lb ub year if f0E==0) (rcap lb ub year if f0E==1) ///
	, legend(order(1 "Formal Extensive" 2 "Informal" ) position(6) cols(2) ) ///
	ytitle("Relative mean firm size") xtitle("Year") scheme(plotplainblind)  ///
	ylabel(1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4) title("(b) Firms older than" "10 years by 2012")  ///
	name(a2, replace)

restore  

grc1leg a1 a2 , scheme(plotplainblind) xsize(4) ysize(2) scale(1.5)

graph export "$outputs\figures\sizeRAgeV2_edad_inform.pdf", as(pdf) replace	


* ................................................
 

preserve // Firma informal en 2012, intensivo; luego dependiendo de su status; jovenes
collapse (mean) sizeR (semean) se= sizeR if nueva_m2012==1 & f0I2012==1, by(year formalInt_le)
gen lb= sizeR - 1.96*se
gen ub= sizeR + 1.96*se

tw 	(connected  sizeR  year if formalInt_le==1) ///
	(connected  sizeR  year if formalInt_le==0) ///
	(rcap lb ub year if formalInt_le==1) ///
	(rcap lb ub year if formalInt_le==0) ///
	, legend(order(1 "Formal Intensive" 2 "Formal Extensive" ) position(6) cols(2) ) ///
	ytitle("Relative mean firm size") xtitle("Year") scheme(plotplainblind)  ///
	ylabel(.85 .9 .95 1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4) title("(a) Firms aged less than" "3 years by 2012")  ///
	name(a1, replace)

restore 
 
 
preserve // Firma informal en 2012, intensivo; luego dependiendo de su status; maduras
collapse (mean) sizeR (semean) se= sizeR if vieja_m2012==1 & f0I2012==1, by(year formalInt_le)
gen lb= sizeR - 1.96*se
gen ub= sizeR + 1.96*se

tw 	(connected  sizeR  year if formalInt_le==1) ///
	(connected  sizeR  year if formalInt_le==0) ///
	(rcap lb ub year if formalInt_le==1) ///
	(rcap lb ub year if formalInt_le==0) ///
	, legend(order(1 "Formal Intensive" 2 "Formal extensive" ) position(6) cols(2) ) ///
	ytitle("Relative mean firm size") xtitle("Year") scheme(plotplainblind)  ///
	ylabel(.85 .9 .95 1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4) title("(b) Firms older than" "10 years by 2012")  ///
	name(a2, replace)

restore  

grc1leg a1 a2 , scheme(plotplainblind) xsize(4) ysize(2) scale(1.5)

graph export "$outputs\figures\sizeRAgeV2_edad_informInt.pdf", as(pdf) replace	


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Figure A1. Formality status profile by informality status at 2012

preserve
gen form=1-f0E
collapse (mean) form if nueva_m2012==1, by(year f0E2012)
tw (connected  form  year if f0E2012==0) (connected  form  year if f0E2012==1) ,  ///
	legend(order(1 "Formal by 2012" 2 "Informal by 2012" ) position(6) cols(2) ) ///
	ytitle("Proportion formal") xtitle(Age firm in years) scheme(plotplainblind)  ///
	ylabel(0 0.5 1) title("(a) Firms aged less than" "3 years by 2012")  ///
	name(a1, replace)
restore

preserve
gen form=1-f0E
collapse (mean) form if vieja_m2012==1, by(year f0E2012)
tw (connected  form  year if f0E2012==0) (connected  form  year if f0E2012==1) ,  ///
	legend(order(1 "Formal by 2012" 2 "Informal by 2012" ) position(6) cols(2) ) ///
	ytitle("Proportion formal") xtitle(Age firm in years) scheme(plotplainblind) ///
	ylabel(0 0.5 1) title("(b) Firms older than" "10 years by 2012")  ///
	name(a2, replace)
restore

grc1leg a1 a2 , scheme(plotplainblind) xsize(4) ysize(2) scale(1.5)

graph export "$outputs\figures\formalityprofile_edad_inform.pdf", as(pdf) replace	


* ................................................
 
preserve
gen form=1-f0I
collapse (mean) form if nueva_m2012==1, by(year f0I2012)
tw (connected  form  year if f0I2012==0) (connected  form  year if f0I2012==1) ,  ///
	legend(order(1 "Formal by 2012" 2 "Informal by 2012" ) position(6) cols(2) ) ///
	ytitle("Proportion formal") xtitle(Age firm in years) scheme(plotplainblind)  ///
	ylabel(0 0.5 1) title("(a) Firms aged less than" "3 years by 2012")  ///
	name(a1, replace)
restore

preserve
gen form=1-f0I
collapse (mean) form if vieja_m2012==1, by(year f0I2012)
tw (connected  form  year if f0I2012==0) (connected  form  year if f0I2012==1) ,  ///
	legend(order(1 "Formal by 2012" 2 "Informal by 2012" ) position(6) cols(2) ) ///
	ytitle("Proportion formal") xtitle(Age firm in years) scheme(plotplainblind) ///
	ylabel(0 0.5 1) title("(b) Firms older than" "10 years by 2012")  ///
	name(a2, replace)
restore

grc1leg a1 a2 , scheme(plotplainblind) xsize(4) ysize(2) scale(1.5)

graph export "$outputs\figures\formalityprofile_informInt.pdf", as(pdf) replace	


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Figure A2. Self-employed status profile by informality status at 2012

preserve
gen form=1-f0E
collapse (mean) cuenta_propia if cuenta_propiaIni==1, by(year f0E2012)
tw (connected  cuenta_propia  year if f0E2012==0) (connected  cuenta_propia  year if f0E2012==1) ,  ///
	legend(order(1 "Formal by 2012" 2 "Informal by 2012" ) position(6) cols(2) ) ///
	ytitle("Proportion Self-employed") xtitle(Age firm in years) scheme(plotplainblind)  ///
	ylabel(0 0.5 1) title("(a) Self-employed by 2012")  ///
	name(a1, replace)
restore

preserve
gen form=1-f0E
collapse (mean) cuenta_propia if microIni==1, by(year f0E2012)
tw (connected  cuenta_propia  year if f0E2012==0) (connected  cuenta_propia  year if f0E2012==1) ,  ///
	legend(order(1 "Formal by 2012" 2 "Informal by 2012" ) position(6) cols(2) ) ///
	ytitle("Proportion Self-employed") xtitle(Age firm in years) scheme(plotplainblind) ///
	ylabel(0 0.5 1) title("(b) Microfirms by 2012")  ///
	name(a2, replace)
restore

grc1leg a1 a2 , scheme(plotplainblind) xsize(4) ysize(2) scale(1.5)

graph export "$outputs\figures\microfprofile_edad_inform.pdf", as(pdf) replace	







