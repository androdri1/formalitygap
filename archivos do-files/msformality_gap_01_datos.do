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

if "`c(username)'"== "paul.rodriguez"{
	global dataFolder="G:\.shortcut-targets-by-id\1Bd8bkvnOVmG2grWiaB5Ygn7k2Ac3MX30\Informalidad y Brechas Distribucion Ganancias Colombia\archivos .dta\"
	global outputs="G:\.shortcut-targets-by-id\1Bd8bkvnOVmG2grWiaB5Ygn7k2Ac3MX30\Informalidad y Brechas Distribucion Ganancias Colombia\resultados regresiones\"
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
use micro_1216.dta, clear
*log using survival_informality, replace

foreach y of varlist motivo_emprend motivo_exclusion {
	by id_firm (year), sort: replace `y'=`y'[_n-1] if `y' >= . 	
}

xtset id_firm year
	
keep id_firm dpto computadores tabletas tel_inteligente emplinternet mujeres_propietaria mujeres_perm po_permanente po_temporal ///
	size ciiu year rut c_comercio Rc_comercio formal nueva_m joven_m establecida_m /// 
	vieja_m surperviviente d_PC d_Tablet d_TelI /// 
	madura_m size2 porc_asalariados2 porc_salud2 porc_prestaciones2 porc_parafiscales2 hombres_propietario ///
	dispositivos_TIC internet web red usoTIC_avanz cuenta_propia micro_e p_mujeresTemp porc_asalariados porc_salud porc_prestaciones /// 
	porc_parafiscales porc_emplinternet ventas_a ventas_m va_m va_a panel salario salario_prom salarios red_social prestamo prestamo_obtuvo ///
	prest_Instfin prest_proveedor prest_CC  prest_usureros formalidad formalidad1     /// 
	contabilidad  motivo_emprend motivo_exclusion

************** To make a balanced panel ********************
*egen wanted = total(inrange(year, 2012, 2016)), by(id_firm)
*keep if wanted==5
************************************************************


// We use this variable to split firms according to their size; as size changes
// over time, we define them according to their size at the first appearence
bys id_firm: gen ene=_n
gen microInix= micro_e==1 if ene==1
bys id_firm: egen microIni=max(microInix)
gen cuenta_propiaIni = 1-microIni

label var microIni         "Two or more workers at the start of the panel"
label var cuenta_propiaIni "One worker at the start of the panel"

////////////////////////////////////////////////////////////////////////////////	
// Creating new variables 
////////////////////////////////////////////////////////////////////////////////
if 1==1 {

	g paga_salario=0
	replace paga_salario=1 if porc_asalariados==1
	label var paga_salario "dummy=1 si la empresa pago salarios a todos sus trabajadores"

	g paga_salud=0
	replace paga_salud=1 if porc_salud==1
	label var paga_salud "dummy=1 si la empresa pago por salud a todos sus trabajadores"

	g paga_prestaciones=0
	replace paga_prestaciones=1 if porc_prestaciones==1
	label var paga_prestaciones "dummy=1 si la empresa pago prestaciones a todos sus trabajadores"

	g paga_parafiscales=0
	replace paga_parafiscales=1 if porc_parafiscales==1
	label var paga_parafiscales "dummy=1 si la empresa pago salarios a todos sus trabajadores"

	g formalidad2=0
	replace formalidad2= paga_salario+paga_salud+paga_prestaciones+paga_parafiscales
	label var formalidad2 "variable ordenada de formalidad de 0 a 4"

	g formalidad3=0
	replace formalidad3= paga_salud+paga_prestaciones+paga_parafiscales
	label var formalidad3 "variable ordenada de formalidad de 0 a 3"

	
	
	g formalidad4=0
	replace formalidad4= rut+Rc_comercio+contabilidad
	label var formalidad4 "variable ordenada de formalidad LEGAL de 0 a 3"	
	
	
	***********************************************************************************************
	********************************* Using labor formality as reference **************************
	***********************************************************************************************
	* Salarios, prestaciones, y seguridad social
	
	g f0L=0
	replace f0L=1 if formalidad2==0
	label var f0L "dummy= 1 if firm has none of 4 requirements in labor matters"

	g f1L=0
	replace f1L=1 if formalidad2==1
	label var f1L "dummy= 1 if firm has 1 out of 4 requirements in labor matters"

	g f2L=0
	replace f2L=1 if formalidad2==2
	label var f2L "dummy= 1 if firm has 2 of 4 requirements in labor matters"

	g f3L=0
	replace f3L=1 if formalidad2==3
	label var f3L "dummy= 1 if firm has 3 out of 4 requirements in labor matters"

	g f4L=0
	replace f4L=1 if formalidad2==4
	label var f4L "dummy= 1 if firm has 4 out of 4 requirements in labor matters"

	
	g f0LE=1
	replace f0LE=0 if formalidad2==4
	label var f0LE "dummy= 1 if firm has less than 4 out of 4 requirements in labor matters"
	
	
	
	***********************************************************************************************
	********************************* Using labor formality 3 as reference **************************  <<<<
	***********************************************************************************************
	************* construye variable de formalidad laboral. No se toma ninguna variable como ancla*/
	* Salarios, prestaciones, y seguridad social

	g f0L2=0
	replace f0L2=1 if formalidad3==0
	label var f0L2 "LABORAL dummy= 1 if firm has none of 3 requirements in being legally established"

		g f1L2=0
		replace f1L2=1 if formalidad3==1
		label var f1L2 "LABORAL dummy= 1 if firm has one of 3 requirements in being legally established"

		g f2L2=0
		replace f2L2=1 if formalidad3==2
		label var f2L2 "LABORAL dummy= 1 if firm has two of 3 requirements in being legally established"

		g f3L2=0
		replace f3L2=1 if formalidad3==3
		label var f3L2 "LABORAL dummy= 1 if firm has 3 out of 3 requirements in being legally established"

		
	g f0L2E=1
	replace f0L2E=0 if formalidad3==3
	label var f0L2E "LABORAL dummy= 1 if firm has lees than 3 of 3 requirements in being legally established"
	
	

	***********************************************************************************************
	********************************* Using formality1 as reference **************************
	***********************************************************************************************

	************* construye variable de formalidad legal. Para ello, ancla como basico el contar con **
	*** el registro RENOVADO de camara de comercio. En segundo termino, el RUT y en ultimo llevar ***
	********************************************* libro de contabilidad ******************************

	g f0E=0
	replace f0E=1 if formalidad4==0
	label var f0E "EMPRESA dummy= 1 if firm has none of 3 requirements in being legally established"


		g f1E=0
		replace f1E=1 if formalidad4==1
		label var f1E "EMPRESA dummy= 1 if firm has one of 3 requirements in being legally established"

								
		g f2E=0
		replace f2E=1 if formalidad4==2
		label var f2E "EMPRESA dummy= 1 if firm has two of 3 requirements in being legally established"

											 

		g f3E=0
		replace f3E=1 if formalidad4==3
		label var f3E "EMPRESA dummy= 1 if firm has 3 out of 3 requirements in being legally established"
	
	
	g f3EE=1
	replace f3EE=0 if formalidad4==3
	label var f3EE "EMPRESA dummy= 1 if firm has less than 3 of 3 requirements in being legally established"
	
	
	***********************************************************************************************
	********************************* Intensive informality as Ulysea **************************
	***********************************************************************************************	
	g f0I=1
	replace f0I = f0L2 if f0E==0
	label var f0I "INTENSIVE. As labour but only for formal. None of 3 requirements firms"

	g f0IE=1
	replace f0IE = f0L2E if f3EE==0
	label var f0IE "INTENSIVE. As labour but only for formal. Less than 3 requirements firms"	

	
	* version without the extensive informal
	g f0InoE=1 if f0E==0
	replace f0InoE = f0L2 if f0E==0
	label var f0InoE "INTENSIVE restricted. As labour but only for formal. None of 3 requirements firms"

	g f0IEnoE=1 if f0E==0
	replace f0IEnoE = f0L2E if f3EE==0
	label var f0IEnoE "INTENSIVE restricted. As labour but only for formal. Less than 3 requirements firms"	

		
	
	***********************************************************************************************
	***************************** Constructing a different formality Index ************************
	***********************************************************************************************


	g paga_salario1=0
	replace paga_salario1=1 if porc_asalariados2==1
	label var paga_salario1 "dummy=1 si la empresa pago salarios a todos sus trabajadores"

	g paga_salud1=0
	replace paga_salud1=1 if porc_salud2==1
	label var paga_salud1 "dummy=1 si la empresa pago por salud a todos sus trabajadores"

	g paga_prestaciones1=0
	replace paga_prestaciones1=1 if porc_prestaciones2==1
	label var paga_prestaciones1 "dummy=1 si la empresa pago prestaciones a todos sus trabajadores"

	g paga_parafiscales1=0
	replace paga_parafiscales1=1 if porc_parafiscales2==1
	label var paga_parafiscales1 "dummy=1 si la empresa pago salarios a todos sus trabajadores"


	************************************************************************************************

	g porcpropietario_genero =0
	replace porcpropietario_genero=mujeres_propietaria/(mujeres_propietaria+hombres_propietario)
	label var porcpropietario_genero "porcentaje de propiedad mujeres en la empresa"

	g propiedad_mujer= 0
	replace propiedad_mujer= 1 if porcpropietario_genero >= 0.5
	label var propiedad_mujer "dummy=1 si mujeres son propietarias de al menos la mitad"

	g l_aventas= ln(ventas_a)
	label var l_aventas "log of annual sales"

	g l_mventas= ln(ventas_m)
	label var l_mventas "log of monthly sales"

	g l_salariomedio= ln(salario_prom)
	label var l_salariomedio "log average wage"
	
	gen salesGrowth = (ventas_a-L.ventas_a)/L.ventas_a
	label var salesGrowth "annual growth sales"
	
	************************************************************************************************	
	
	gen l_mventas_pw    = ln(ventas_m/size)
	label var l_mventas_pw "log monthly sales per worker"
	
	gen l_aventas_pw    = ln(ventas_a/size)
	label var l_aventas_pw "log annual sales per worker"
	
	gen salesGrowth_pw= salesGrowth/size
	label var salesGrowth_pw "annual growth sales per worker"	
	
	************************************************************************************************	
	
	tab dpto, gen(dpto_)
	
	tab ciiu, gen(ciiu_)
	
	tab year, gen(year_)	
	

	***********************************************************************************************************
	*** creando variables interactuadas de los niveles de formalidad laboral y legal con la variable dummy de***
	******************************** motivo_emprendedor ********************************************************

	g MExf1L2= motivo_emprend*f1L2
	g MExf2L2= motivo_emprend*f2L2

	g MExf1E= motivo_emprend*f1E
	g MExf2E= motivo_emprend*f2E	
	
	
	gen Nmotivo_emprend=1-motivo_emprend	
	
	
	
	label var propiedad_mujer     "Female ownership"
	label var dispositivos_TIC    "ICT devices"
	label var red                 "ICT web presence"  
	label var nueva_m             "Age: Less than 1 year"
	label var joven_m             "Age: +1- 3 years"
	label var establecida_m       "Age: +3-5 years"   
	label var madura_m            "Age: +5-10 years"  
	label var vieja_m             "Age: +10 years"
	label var ciiu_1              "Sector: Manufacture"
	label var ciiu_2              "Sector: Commerce"
	label var ciiu_3	          "Sector: Services" 
	
	****************************************************************************
	bys id_firm: gen aparBase=_N
	label var aparBase "Times observed"
	
}	
////////////////////////////////////////////////////////////////////////////////	
// Distribtion Graphs by year (Tansel EE2019)
////////////////////////////////////////////////////////////////////////////////
if 1==0 {	
	preserve
	keep if year==2012
	 kdensity l_mventas, nograph generate(x fx)

	kdensity l_mventas if formalidad2==0, nograph generate(fx0) at(x)

	kdensity l_mventas if formalidad2==1, nograph generate(fx1) at(x)
	kdensity l_mventas if formalidad2==2, nograph generate(fx2) at(x)
	kdensity l_mventas if formalidad2==3, nograph generate(fx3) at(x)
	kdensity l_mventas if formalidad2==4, nograph generate(fx4) at(x)
	

	label var fx0 "formal=0"
	label var fx1 "formal=1"
	label var fx2 "formal=2"
	label var fx3 "formal=3"
	label var fx4 "formal=4"
	line fx0 fx1 fx2 fx3 fx4 x, sort ytitle(Density)

	restore
	
	preserve
	keep if year==2014
	 kdensity l_mventas, nograph generate(x fx)

	kdensity l_mventas if formalidad2==0, nograph generate(fx0) at(x)

	kdensity l_mventas if formalidad2==1, nograph generate(fx1) at(x)
	kdensity l_mventas if formalidad2==2, nograph generate(fx2) at(x)
	kdensity l_mventas if formalidad2==3, nograph generate(fx3) at(x)
	kdensity l_mventas if formalidad2==4, nograph generate(fx4) at(x)
	
	label var fx0 "formal=0"
	label var fx1 "formal=1"
	label var fx2 "formal=2"
	label var fx3 "formal=3"
	label var fx4 "formal=4"
	line fx0 fx1 fx2 fx3 fx4 x, sort ytitle(Density)

	restore
	
	preserve
	keep if year==2016
	 kdensity l_mventas, nograph generate(x fx)

	kdensity l_mventas if formalidad2==0, nograph generate(fx0) at(x)

	kdensity l_mventas if formalidad2==1, nograph generate(fx1) at(x) 
	kdensity l_mventas if formalidad2==2, nograph generate(fx2) at(x) 
	kdensity l_mventas if formalidad2==3, nograph generate(fx3) at(x)
	kdensity l_mventas if formalidad2==4, nograph generate(fx4) at(x)  
	
	label var fx0 "formal=0"
	label var fx1 "formal=1"
	label var fx2 "formal=2"
	label var fx3 "formal=3"
	label var fx4 "formal=4" 
	line fx0 fx1 fx2 fx3 fx4 x, sort ytitle(Density)

	restore
	
	
	**************************************************************************************
	**************************************************************************************
	/* Another option is 
		twoway kdensity bmi if rural, xtitle("BMI (kg/m2)") ytitle(Density) ///
	title(Body mass index in 338 semi-rural and 290 urban women in Ghana, size(medium) span) ///
	subtitle(Kernel density plots, size(medium small) span) ///
	color(blue*.5) lcolor(blue)  lwidth(medthick)  || ///
	kdensity bmi if !rural ,    ///
	color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
	legend(order(1 "semi-rural women" 2 "rural women") col(1) pos(1) ring(0))  */
	**************************************************************************************
}

////////////////////////////////////////////////////////////////////////////////	
// Formato del panel, matrices de tansición
////////////////////////////////////////////////////////////////////////////////
if 1==0 {
	xtset id_firm year
	xtdescribe

	/* 

	 id_firm:  300001, 300002, ..., 353399                       n =      52159
		year:  2012, 2013, ..., 2016                             T =          5
			   Delta(year) = 1 unit
			   Span(year)  = 5 periods
			   (id_firm*year uniquely identifies each observation)

	Distribution of T_i:   min      5%     25%       50%       75%     95%     max
							 1       1       2         4         5       5       5

		 Freq.  Percent    Cum. |  Pattern
	 ---------------------------+---------
		23201     44.48   44.48 |  11111
		 5185      9.94   54.42 |  1....
		 4660      8.93   63.36 |  11...
		 3663      7.02   70.38 |  1111.
		 3655      7.01   77.39 |  ..111
		 2600      4.98   82.37 |  .1111
		 1695      3.25   85.62 |  ...11
		 1422      2.73   88.35 |  111..
		 1079      2.07   90.42 |  ..11.
		 4999      9.58  100.00 | (other patterns)
	 ---------------------------+---------
		52159    100.00         |  XXXXX
	*/

					/*
		egen m=median(l_aventas), by(year)
	gen above=l_aventas>m if l_aventas<.
	gen nextyr=f.above

	quietly { 

	forval j = 1/4 { 
		gen f`j' = . 
	} 

	local i = 1 

	forval y = 2012/2016 { 
		count if above < . & nextyr < . & year == `y'
		if r(N) > 0 { 
			tab above nextyr if year == `y', row matcell(work) 
			replace f1 = work[1,1] in `i' 
			replace f2 = work[1,2] in `i' 
			replace f3 = work[2,1] in `i' 
			replace f4 = work[2,2] in `i'
		}     
		local ++i 
	} 

	gen p11 = f1 / (f1 + f2) 
	gen p12 = f2 / (f1 + f2) 
	gen p21 = f3 / (f3 + f4) 
	gen p22 = f4 / (f3 + f4) 

	} 

	gen myyear = 2011 + _n 
	format p* %04.0f 
	list myyear f* p* if f1 < . , sep(0)          */

	egen m=median(l_mventas), by(year)
	gen above=l_mventas>m if l_mventas<.
	gen nextyr=f.above
	tab above nextyr, nofreq row
	tab above nextyr if year>=2012 & year<=2013, nofreq row
	tab above nextyr if year>=2013 & year<=2014, nofreq row
	tab above nextyr if year>=2014 & year<=2015, nofreq row
	tab above nextyr if year>=2015 & year<=2016, nofreq row

	xtdes, patterns(20)
	
	****************************************************************************
	* Sofia: lineas 444 - 475 las que hay que "pasar al overleaf"
	* https://www.overleaf.com/7442666156zwqncrbmcknk
	** Comparación medidas de informalidad: usamos la laboral para luego explicar
	* la construccion del intensive margin como derivacion de esta
	

	tab f0I  f0E   if cuenta_propia==1 , cell  // Definicion primaria
	tab f0IE f3EE if cuenta_propia==1 , cell // Definicion acida	

	tab f0I  f0E    if cuenta_propia==0, cell     // Definicion primaria
	tab f0IE f3EE  if cuenta_propia==0, cell  // Definicion acida
		
	count if f0L2==0 & f0E==1 // 546 firmas formales intensivo pero no extensivo
	count if f0L2==0 & f0E==1 & cuenta_propia==1  // 479/ 74,512 =0.6% firmas formales intensivo pero no extensivo
	count if f0L2==0 & f0E==1 & cuenta_propia==0  // 67/ 112,040 =0.05% firmas formales intensivo pero no extensivo
		
	* Matriz de transición
	gen Lf0E =L.f0E
	gen Lf0I =L.f0I
	gen Lf0IE=L.f0IE
	gen Lf3EE=L.f3EE
	
	tab Lf0E f0E if cuenta_propia==1 , row
	tab Lf0E f0E  if cuenta_propia==0 , row
	
	tab Lf0I f0I  if cuenta_propia==1 , row
	tab Lf0I f0I  if cuenta_propia==0 , row	
	
		
	
	******************************************************************************
	**** Construyendo las matrices de transición *********************************

	xttrans formalidad1 if year<=2012
	xttrans formalidad1 if year<=2013
	xttrans formalidad1 if year<=2014
	xttrans formalidad1 if year<=2015
	xttrans formalidad1 if year<=2016


	gen formalidad1_lag=l.formalidad1
	gen formalidad1_for=f.formalidad1

	preserve 
	keep if year==2012 | year==2013

	tab formalidad1_lag formalidad1
	restore

	preserve 
	keep if year==2013 | year==2014
	tab formalidad1_lag formalidad1
	restore

	preserve 
	keep if year==2014 | year==2015
	tab formalidad1_lag formalidad1
	restore

	preserve 
	keep if year==2015 | year==2016
	tab formalidad1_lag formalidad1
	restore
	*******************************************************************************
	*******************************************************************************
	gen ventas_a_lag=l.ventas_a
	gen ventas_a_for=f.ventas_a

	preserve 
	keep if year==2012 | year==2013

	restore

	preserve 
	keep if year==2013 | year==2014
	tab formalidad1_lag formalidad1
	restore

	preserve 
	keep if year==2014 | year==2015
	tab formalidad1_lag formalidad1
	restore

	preserve 
	keep if year==2015 | year==2016
	tab formalidad1_lag formalidad1
	restore

}		
			
////////////////////////////////////////////////////////////////////////////////
********** Exercises replicating Nordman WD2016 but for microenterprises *******	
**************** TOMA TODA LA MUESTRA DE EMPRESAS ******************************
////////////////////////////////////////////////////////////////////////////////		


save "informality_gap.dta", replace

