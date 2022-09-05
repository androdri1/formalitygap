clear
clear matrix
set mem 500m
set matsize 5500
set more off
******************************************************************************************
*IADB-DIRSI Project 
******************************************************************************************
 
cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC5_FEDESARROLLO\JUAN MIGUEL GALLEGO U_ROSARIO\ENTRA\MICROESTABLECIMIENTOS\MICRO 2012"
*******************************************************************************************
* ********************************** micro 2012 *******************************************
*******************************************************************************************
************
 
clear
use MICRO2012.dta 
gen year=2012 
scalar ipc12=100/111.82  
rename  identificador_new id_firm
rename anio year
destring cdgo_dprtmnto, replace
destring cdgo_mncpio, replace
destring id_firm, replace
rename  cdgo_dprtmnto dpto
rename cdgo_mncpio muncp
recode p998 (1 = 1) (2 = 0), gen(gender_d)
label var gender_d "dummy=1 si la mayor’a de las decisiones las tomo un hombre"

*********************************************Elementos de Formalizaci—n de la empresa*************************

recode p1633 (1 = 1) (2 = 0), gen(rut)
label var rut "dummy=1 si la empresa tiene Registro ònico Tributario"
recode p660 (1 = 1) (2 = 0), gen(c_comercio)
label var c_comercio "dummy=1 si la empresa tiene Registro de C‡mara de Comercio"
recode p661 (1 = 1) (2 = 0), gen(Rc_comercio)
label var Rc_comercio "dummy=1 si la empresa renov— u obtuvo Registro de C‡mara de Comercio en 2012"
gen ley1460=0
replace ley1460=1 if p1008==1
lable var ley1460 "dummy=1 si la empresa uso la Ley de formalizaci—n y generaci—n de empleo para constituirse"

****************************************************************
gen formal= 0
replace formal=1 if rut==1 | c_comercio==1 | Rc_comercio==1
label var formal "dummy=1 si la empresa es formal robusto"

gen formal1= 0
replace formal1=1 if rut==1 |  Rc_comercio==1
label var formal1 "dummy=1 si la empresa es formal 2"
****************************************************************

rename p604 t_sociedad
label var t_sociedad "Variable categ—rica sobre la organizaci—n jur’dica de la empresa"
/*1: Sociedad comercial (Ltda,en comandita, acciones, SAS)
2: Cooperativa
3: Sociedad de hecho
4: Persona natural
5. No ha sido registrado como organización jurídica 
*/

gen emprendedor=0
replace emprendedor=1 if p990==2
label var emprendedor "dummy=1 si se identific— una oportunidad de negocio en el mercado"

gen contabilidad=0
replace contabilidad=1 if p640==0 | p640==1 | p640==2
label var contabilidad "dummy=1 si la empresas lleva libro de registro, balance-pyg u otro tipo contable "

gen e_creacion=0
replace e_creacion=1 if p988==1 | p988==2 | p988==3
label var e_creacion "dummy=1 si la empresa la creo el empresario solo o con otros familiares o personas"

rename p639 age
label var age "edad de la empresa registrada en 5 opciones"

/*
1: Menos de un año
2: De 1 a menos de 3 años
3: De 3 a menos de 5 años
4: De 5 a menos de 10 años
5. 10 años y más
*/
***********************principal fuente de financiaci—n para la creaci—n o constituci—n de este establecimiento********************
gen  ahorro_finan=0
replace ahorro_finan=1 if p992== 1
label var ahorro_finan "dummy=1 si la empresa se creo mediante ahorros personales"
gen  prestFam_finan=0
replace prestFam_finan=1 if p992== 2
label var prestFam_finan "dummy=1 si la empresa se creo mediante prestamos familiares"
gen  prestBan_finan=0
replace prestBan_finan=1 if p992== 3
label var prestBan_finan "dummy=1 si la empresa se creo mediante prestamos bancarios"
gen  prestPrest_finan=0
replace prestPrest_finan=1 if p992== 4
label var prestPrest_finan "dummy=1 si la empresa se creo mediante prestamos de prestamistas"
gen  semilla_finan=0
replace semilla_finan=1 if p992== 5
label var semilla_finan "dummy=1 si la empresa se creo mediante capital semilla"
************************************** variables TIC*******************************************

rename p975 computadores
label var computadores "nœmero de computadores que la empresa ten’a"

gen d_PC=0
replace d_PC=1 if computadores>1
label var d_PC "dummy=1 si la empresa ten’a al menos un computador"

rename p977 tabletas
label var tabletas "nœmero de tabletas que la empresa ten’a"

gen d_Tablet=0
replace d_Tablet=1 if tabletas>1
label var d_Tablet "dummy=1 si la empresa ten’a al menos una tableta"

rename p978 tel_inteligente
label var tel_inteligente "nœmero de telŽfonos inteligentes que la empresa ten’a"

gen d_TelI=0
replace d_TelI=1 if tel_inteligente>1
label var d_TelI "dummy=1 si la empresa ten’a al menos un telŽfono inteligente"

****************************************************************************
gen ict_gadgets=0
replace ict_gadgets=1 if if d_PC==1 | d_Tablet==1 | d_TelI==1
label var ict_gadgets "dummy=1 si la empresa ten’a al menos computador, tableta o telŽfono inteligente"
****************************************************************************

gen No_PC_altocosto=0
replace No_PC_altocosto=1 if p994==1
label var No_PC_altocosto "dummy=1 si la raz—n de no tener PC es alto costo"
gen No_PC_nonecesita=0
replace No_PC_nonecesita=1 if p994==2
label var No_PC_nonecesita "dummy=1 si la raz—n de no tener PC es que no se necesita"
gen No_PC_nosabeusarlo=0
replace No_PC_nosabeusarlo=1 if p994==3
label var No_PC_nosabeusarlo "dummy=1 si la raz—n de no tener PC es que no sabe usarlo"
/*
1. Es muy costoso 
2. No se necesita 
3. No sabe  usarlo 
*/
recode p2524 (1 = 1) (2 = 0), gen(internet)
label var internet "dummy=1 si la empresa tuvo internet en 2012"

gen NoInternet_altocosto=0
replace NoInternet_altocosto=1 if p996==1
label var NoInternet_altocosto "dummy=1 si la raz—n de no tener internet es alto costo"
gen NoInternet_nonecesita=0
replace NoInternet_nonecesita=1 if p996==2
label var NoInternet_nonecesita "dummy=1 si la raz—n de no tener internet es que no se necesita"
gen NoInternet_nosabeusarlo=0
replace NoInternet_nosabeusarlo=1 if p996==3
label var NoInternet_nosabeusarlo "dummy=1 si la raz—n de no tener internet es que no sabe usarlo"
gen NoInternet_nodispositivo=0
replace NoInternet_nodispositivo=1 if p996==4
label var NoInternet_nodispositivo "dummy=1 si la raz—n de no tener internet es que no tiene dispositivo"

/*
1. Es muy costoso 
2. No se necesita 
3. No sabe  usarlo 
4. No tiene dispositivo para conectarse
5. Tiene acceso suficiente desde otros lugares sin costo
*/

rename p980 emplinternet
label var emplinternet " empleados que usan internet en trabajo"

recode p2532 (1 = 1) (2 = 0), gen(web)
label var web "dummy=1 si la empresa tuvo portal en 2012"

rename p2529 bandaancha
label var bandaancha "ancho de banda de la internet"

****************************************************************************
gen red=0
replace red=1 if web==1 | internet==1 
label var red "dummy=1 si la empresa tiene TIC en redes"
****************************************************************************

/* 
Banda ancha
1: Menos de 2 MB
2: Entre 2 y menos de 4 MB
3: 4 MB o más
4: Móvil 2G
5: Móvil 3G
6: Móvil 4G
*/



recode p1006_1 (1 = 1) (2 = 0), gen(u_busquedaG)
label var u_busquedaG "dummy=1 si la empresa uso internet para bœsqueda informaci—n"

recode p1006_2 (1 = 1) (2 = 0), gen(u_banca)
label var u_banca "dummy=1 si la empresa uso internet para banca electr—nica"

recode p1006_3 (1 = 1) (2 = 0), gen(u_gob)
label var u_gob "dummy=1 si la empresa uso internet para transacciones con gob"

recode p1006_4 (1 = 1) (2 = 0), gen(u_servicioc)
label var u_servicioc "dummy=1 si la empresa uso internet para servicios al cliente"

recode p1006_5 (1 = 1) (2 = 0), gen(u_distr)
label var u_distr "dummy=1 si la empresa uso internet para distribuir productos"

recode p1006_6 (1 = 1) (2 = 0), gen(u_hpagos)
label var u_hpagos "dummy=1 si la empresa uso internet para hacer pagos proveedores"

recode p1006_7 (1 = 1) (2 = 0), gen(u_rpagos)
label var u_rpagos "dummy=1 si la empresa uso internet para recibir pagos de clientes"

recode p1006_8 (1 = 1) (2 = 0), gen(u_apps)
label var u_apps "dummy=1 si la empresa uso internet para aplicaciones"
**************************************************************************************
gen usoTIC_avanz= 0
replace usoTIC_avanz =1 if u_banca==1 | u_gob==1 | u_servicioc==1 | u_distr==1 | u_hpagos==1 | u_rpagos==1
label var usoTIC_avanz "dummy=1 si la empresa uso la Internet en aplicaciones avanzadas"
**************************************************************************************

******************************************Tama–o, sueldos, ventas y costos*******************************

destring actvdad_ciiu, replace
rename actvdad_ciiu ciiu
label var ciiu "CIIU Rev. 3 A.C. (2 d’gitos)"
rename p750 size
label var size "total personal ocupado"
rename p748 po_permanente
label var po_permanente "total personal ocupado permanente o contrato indefinido"
rename p749 po_temporal
label var po_temporal "total personal ocupado temporal"

rename p749 po_temporal
label var po_temporal "total personal ocupado temporal"

rename p724 mujeres_perm
label var mujeres_perm "Mujeres con contrato a tŽrmino indefinido"
gen p_mujeresPerm= (mujeres_perm/size)

rename p726 mujeres_temp
label var mujeres_temp "Mujeres con contrato a tŽrmino temporal"
gen p_mujeresTemp= (mujeres_temp/size)

rename p1000_1 salarios
label var salarios "total sueldos y salarios"

********************************************
gen r_salario= salarios*ipc12
label var r_salario "salarios y sueldos reales"

gen prom_salario= r_salarios/size
label var prom_salario "salario promedio" 
********************************************
rename p1000_4 parafiscales
label var parafiscales "total parafiscales"

rename p1015_7 gtelefonia
label var gtelefonia "total gastos en telefon’a"

gen r_gtelefonia= gtelefonia*ipc12
label var r_gtelefonia "Gastos reales en telefon’a"

rename p1015_15 gpublicidad
label var gpublicidad "total gastos en publicidad"

rename p1014 costos
label var costos "total costos"

rename p1023 costos_gastos
label var costos_gastos "total costos-gastos"

********************************************
gen rcostos_gastos= costos_gastos*ipc12
label var rcostos_gastos "costos-gastos reales"

gen r_costos= costos*ipc12
label var r_costos "costos reales"
********************************************

rename p1010 ventas_a
label var ventas_a "ventas totales en los œltimos 12 meses"

rename p958 ventas_m
label var ventas_m "ventas totales en el œltimo mes"

**************************************************************************************
	
	g r_ventasa=ventas_a*ipc12
	label var r_ventasa "ventas reales anual"

	g va_a= r_ventasa/size
	label var va_a "productividad laboral promedio anual"
	
	g r_ventasm=ventas_a*ipc12
	label var r_ventasm "ventas reales mes"

	g va_m= r_ventasm/size
	label var va_m "productividad laboral promedio mes"
**************************************************************************************

keep id_firm year muncp dpto gender_d rut c_comercio Rc_comercio formal formal1 t_sociedad emprendedor contabilidad age parafiscales ley1460 ///
 computadores d_PC tabletas d_Tablet tel_inteligente d_TelI ict_gadgets porc_emplinternet web bandaancha red usoTIC_avanz ///
ciiu size salarios r_salario prom_salario gtelefonia gpublicidad costos r_costos costos_gastos rcostos_gastos ventas_a r_ventasa va_a ///
r_ventasm va_m


sort id_firm
save MICRO_12.dta, replace


 
cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC5_FEDESARROLLO\JUAN MIGUEL GALLEGO U_ROSARIO\ENTRA\MICROESTABLECIMIENTOS\MICRO_2013"
*******************************************************************************************
* *************************************** micro 2013*************************************
*******************************************************************************************

 
clear
use MICRO2013.dta 
gen year=2013 
scalar ipc13=100/113.98
rename  identificador_new id_firm
rename anio year
destring cdgo_dprtmnto, replace
destring cdgo_mncpio, replace
destring id_firm, replace
rename  cdgo_dprtmnto dpto
rename cdgo_mncpio muncp

	recode p1633 (1 = 1) (2 = 0), gen(rut)
	label var rut "dummy=1 si la empresa tiene Registro ònico Tributario"
	recode p1055 (1 = 1) (2 = 0), gen(c_comercio)
	label var c_comercio "dummy=1 si la empresa tiene Registro de C‡mara de Comercio"
	recode p661 (1 = 1) (2 = 0), gen(Rc_comercio)
	label var Rc_comercio "dummy=1 si la empresa renov— u obtuvo Registro de C‡mara de Comercio en 2013"

****************************************************************
	gen formal= 0
	replace formal=1 if rut==1 | c_comercio==1 | Rc_comercio==1
	label var formal "dummy=1 si la empresa es formal robusto"

	gen formal1= 0
	replace formal1=1 if rut==1 |  Rc_comercio==1
	label var formal1 "dummy=1 si la empresa es formal 2"
****************************************************************

	gen Impuesto_R=0
	replace Impuesto_R=1 if p1052_1=1 | p1052_1=3 
	label var Impuesto_R "dummy=1 si la empresa respondi— por el impuesto a la renta"

	gen Impuesto_IVA=0
	replace Impuesto_IVA=1 if p1052_2=1 | p1052_2=3 
	label var Impuesto_IVA "dummy=1 si la empresa respondi— por el impuesto al IVA"

	gen Impuesto_IC=0
	replace Impuesto_IC=1 if p1052_3=1 | p1052_3=3 
	label var Impuesto_IC "dummy=1 si la empresa respondi— por el impuesto de Ind. y Com."

****************************************************************
	gen formal2= 0
	replace formal2=1 if Impuesto_R==1 & Impuesto_IVA==1 & Impuesto_IC==1
	label var formal2 "dummy=1 si la empresa es formal robusto"

****************************************************************

	gen contabilidad=0
	replace contabilidad=1 if p640==0 | p640==1 | p640==2
	label var contabilidad "dummy=1 si la empresas lleva libro de registro, balance-pyg u otro tipo contable "

	recode p1054_3 (1 = 1) (2 = 0), gen(mipyme_law)
	label var mipyme_law "dummy=1 si la empresa programas de formalizaci—n para su actividad econ—mica: Ley MIPYME (Ley 905/2004)"
	*1 yes, 2 no
	/*Ley   MIPYME (Ley 905/2004)*/

	rename p639 age
	label var age "edad de la empresa registrada en 5 opciones"

/*
1: Menos de un año
2: De 1 a menos de 3 años
3: De 3 a menos de 5 años
4: De 5 a menos de 10 años
5. 10 años y m‡s
*/

************************************** variables TIC*******************************************

	gen computadores = p1087+p1088
	label var computadores "nœmero de computadores que la empresa ten’a"

	gen d_PC=0
	replace d_PC=1 if computadores>1
	label var d_PC "dummy=1 si la empresa ten’a al menos un computador"

	rename p977 tabletas
	label var tabletas "nœmero de tabletas que la empresa ten’a"

	gen d_Tablet=0
	replace d_Tablet=1 if tabletas>1
	label var d_Tablet "dummy=1 si la empresa ten’a al menos una tableta"

	rename p978 tel_inteligente
	label var tel_inteligente "nœmero de telŽfonos inteligentes que la empresa ten’a"

	gen d_TelI=0
	replace d_TelI=1 if tel_inteligente>1
	label var d_TelI "dummy=1 si la empresa ten’a al menos un telŽfono inteligente"

****************************************************************************
	gen ict_gadgets=0
	replace ict_gadgets=1 if if d_PC==1 | d_Tablet==1 | d_TelI==1
	label var ict_gadgets "dummy=1 si la empresa ten’a al menos computador, tableta o telŽfono inteligente"
****************************************************************************

	gen No_PC_altocosto=0
	replace No_PC_altocosto=1 if p994==1
	label var No_PC_altocosto "dummy=1 si la raz—n de no tener PC es alto costo"
	gen No_PC_nonecesita=0
	replace No_PC_nonecesita=1 if p994==2
	label var No_PC_nonecesita "dummy=1 si la raz—n de no tener PC es que no se necesita"
	gen No_PC_nosabeusarlo=0
	replace No_PC_nosabeusarlo=1 if p994==3
	label var No_PC_nosabeusarlo "dummy=1 si la raz—n de no tener PC es que no sabe usarlo"
/*
1. Es muy costoso 
2. No se necesita 
3. No sabe  usarlo 
*/


	recode p2524 (1 = 1) (2 = 0), gen(internet)
	label var internet "dummy=1 si ÀEste establecimiento tiene acceso o utiliza el servicio de Internet?"

	recode p1093 (1 = 1) (2 = 0), gen(internet_e)
	label var internet_e "dummy=1 si ÀUtiliza Internet con conexi—n dentro del establecimiento?"

*****razones para no tener internet*****
	gen NoInternet_altocosto=0
	replace NoInternet_altocosto=1 if p1095==1
	label var NoInternet_altocosto "dummy=1 si la raz—n de no tener internet es alto costo"
	gen NoInternet_nonecesita=0
	replace NoInternet_nonecesita=1 if p1095==2
	label var NoInternet_nonecesita "dummy=1 si la raz—n de no tener internet es que no se necesita"
	gen NoInternet_nosabeusarlo=0
	replace NoInternet_nosabeusarlo=1 if p1095==3
	label var NoInternet_nosabeusarlo "dummy=1 si la raz—n de no tener internet es que no sabe usarlo"
	gen NoInternet_nodispositivo=0
	replace NoInternet_nodispositivo=1 if p1095==4
	label var NoInternet_nodispositivo "dummy=1 si la raz—n de no tener internet es que no tiene dispositivo"

/*
1. Es muy costoso 
2. No se necesita 
3. No sabe  usarlo 
4. No tiene dispositivo para conectarse
5. Tiene acceso suficiente desde otros lugares sin costo
*/

	rename p980 porc_emplinternet
	label var porc_emplinternet "porcentaje de empleados que usan internet en trabajo"
	**revisar si es porcentaje**
	recode p2532 (1 = 1) (2 = 0), gen(web)
	label var web "dummy=1 si la empresa tuvo portal en 2013"

****************************************************************************
	gen red=0
	replace red=1 if web==1 | internet==1 
	label var red "dummy=1 si la empresa tiene TIC en redes"
****************************************************************************

	gen bandaancha=0
	label var bandaancha "ancho de banda de la internet"
	replace bandaancha=1 if p2529==0 | p2529==1 
	replace bandaancha=2 if p2529==2 
	replace bandaancha=3 if p2529==3
	replace bandaancha=4 if p2529==4
	replace bandaancha=5 if p2529==5
	replace bandaancha=6 if p2529==6

/*
0. Entre o y 256 KB (banda angosta)
1. Entre 256 KB y 2MB (banda ancha)
2. Entre 2 y menos de 4 MB  (banda ancha)
3. 4 MB o más  (banda ancha)
4. Móvil 2G  (banda ancha)
5. Móvil 3G  (banda ancha)
6. Móvil 4G  (banda ancha)
*/

	recode p1006_1 (1 = 1) (2 = 0), gen(u_busquedaG)
	label var u_busquedaG "dummy=1 si la empresa uso internet para bœsqueda informaci—n"

	recode p1006_2 (1 = 1) (2 = 0), gen(u_banca)
	label var u_banca "dummy=1 si la empresa uso internet para banca electr—nica"

	recode p1006_3 (1 = 1) (2 = 0), gen(u_gob)
	label var u_gob "dummy=1 si la empresa uso internet para transacciones con gob"

	recode p1006_4 (1 = 1) (2 = 0), gen(u_servicioc)
	label var u_servicioc "dummy=1 si la empresa uso internet para servicios al cliente"

	recode p1006_5 (1 = 1) (2 = 0), gen(u_distr)
	label var u_distr "dummy=1 si la empresa uso internet para distribuir productos"

	recode p1006_6 (1 = 1) (2 = 0), gen(u_hpagos)
	label var u_hpagos "dummy=1 si la empresa uso internet para hacer pagos proveedores"

	recode p1006_7 (1 = 1) (2 = 0), gen(u_rpagos)
	label var u_rpagos "dummy=1 si la empresa uso internet para recibir pagos de clientes"

	recode p1006_8 (1 = 1) (2 = 0), gen(u_apps)
	label var u_apps "dummy=1 si la empresa uso internet para aplicaciones"

	recode p1006_9 (1 = 1) (2 = 0), gen(u_correos)
	label var u_correos "dummy=1 si la empresa uso internet para enviar y recibir correos"

	recode p1006_10 (1 = 1) (2 = 0), gen(u_busquedaE)
	label var u_busquedaE "dummy=1 si la empresa uso internet para bœsqueda informaci—n de empresas"

**************************************************************************************
	gen usoTIC_avanz= 0
	replace usoTIC_avanz =1 if u_banca==1 | u_gob==1 | u_servicioc==2 | u_distr==1 | u_hpagos==1 | u_rpagos==2
	label var usoTIC_avanz "dummy=1 si la empresa uso la Internet en aplicaciones avanzadas"
**************************************************************************************

******************************************Tama–o, sueldos, ventas y costos*******************************

	rename p1010 ventas_a
	label var ventas_a "ventas totales en los œltimos 12 meses"

	rename p958 ventas_m
	label var ventas_m "ventas totales en el œltimo mes"

	destring actvdad_ciiu, replace
	rename actvdad_ciiu ciiu
	label var ciiu "CIIU Rev. 3 A.C. (2 d’gitos)"

	rename p750 size
	label var size "total personal ocupado en los œltimos 12 meses"

	rename p748 po_permanente
	label var po_permanente "total personal ocupado permanente o contrato indefinido"

	rename p749 po_temporal
	label var po_temporal "total personal ocupado temporal"

	rename p724 mujeres_perm
	label var mujeres_perm "Mujeres con contrato a tŽrmino indefinido"
	gen p_mujeresPerm= (mujeres_perm/size)

	rename p726 mujeres_temp
	label var mujeres_temp "Mujeres con contrato a tŽrmino temporal"
	gen p_mujeresTemp= (mujeres_temp/size)

	rename p1107 salarios
	label var salarios "total sueldos y salarios pagados en el mes anterior"

	rename p722 mujeres_socios
	label var mujeres_socios "Mujeres socios, propietarios y familiares sin remuneraci—n"
	gen p_mujeressocios= (mujeres_socios/size)

********************************************
	gen r_salario= salarios*ipc13
	label var r_salario "salarios y sueldos reales"

	gen salario_prom= r_salarios/size
	label var salario_prom "salario promedio" 
	
********************************************
**************************************************************************************
		
	g r_ventasa=ventas_a*ipc13
	label var r_ventasa "ventas reales anual"

	g va_a= r_ventasa/size
	label var va_a "productividad laboral promedio anual"
	
	g r_ventasm=ventas_a*ipc13
	label var r_ventasm "ventas reales mes"

	g va_m= r_ventasm/size
	label var va_m "productividad laboral promedio mes"
	
	**************************************************************************************
	
	recode p1066 (1 = 1) (2 = 0), gen(busco_empleo)
	replace busco_empleo=1 if p1066==.
	label var busco_empleo "dummy=1 si la empresa enfrento busco contratar empleados"
		
	g panel =panel_var
	label var panel "dummy=1 si la empresa aparece en 2012 y 2013"
	

keep id_firm year muncp dpto gender_d rut c_comercio Rc_comercio Impuesto_R Impuesto_IVA Impuesto_IC contabilidad mipyme_law age ///
computadores d_PC tabletas d_Tablet tel_inteligente d_TelI No_PC_altocosto No_PC_nonecesita No_PC_nosabeusarlo internet internet_e ///
NoInternet_altocosto NoInternet_nonecesita NoInternet_nosabeusarlo NoInternet_nodispositivo porc_emplinternet web  bandaancha u_busquedaG u_banca ///
 u_gob u_servicioc u_distr u_hpagos u_rpagos u_apps u_correos u_busquedaE e_creacion mujeres_perm mujeres_temp ///
ciiu size mujeres_socios p_mujeressocios salarios  ventas_a ventas_m p_mujeresPerm p_mujeresTemp r_salario salario_prom r_ventasa va_a ///
r_ventasm va_m busco_empleo panel

	sort id_firm
	save MICRO_13.dta, replace

clear
clear matrix
set mem 500m
set matsize 5500
set more off

cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC5_FEDESARROLLO\JUAN MIGUEL GALLEGO U_ROSARIO\ENTRA\MICROESTABLECIMIENTOS\MICRO_2014"
*******************************************************************************************
* *************************************** micro 2014*************************************
*******************************************************************************************

 
clear
use MICRO2014.dta 
	g year=2014

	scalar ipc11=100/109.16
	scalar ipc12=100/111.82  
	scalar ipc13=100/113.98
	scalar ipc14=100/118.15

	rename  identificador_new id_firm
	rename anio year
	destring cdgo_dprtmnto, replace
	destring cdgo_mncpio, replace
	destring id_firm, replace
	rename  cdgo_dprtmnto dpto
	rename cdgo_mncpio muncp

	recode p1633 (1 = 1) (2 = 0), gen(rut)
	label var rut "dummy=1 si la empresa tiene Registro ònico Tributario"
	recode p1055 (1 = 1) (2 = 0), gen(c_comercio)
	label var c_comercio "dummy=1 si la empresa tiene Registro de C‡mara de Comercio"
	recode p661 (1 = 1) (2 = 0), gen(Rc_comercio)
	label var Rc_comercio "dummy=1 si la empresa renov— u obtuvo Registro de C‡mara de Comercio en 2014"

****************************************************************
	g formal= 0
	replace formal=1 if rut==1 | c_comercio==1 | Rc_comercio==1
	label var formal "dummy=1 si la empresa es formal robusto"

	g formal1= 0
	replace formal1=1 if rut==1 |  Rc_comercio==1
	label var formal1 "dummy=1 si la empresa es formal 2"
****************************************************************
****************************************************************

	g contabilidad=0
	replace contabilidad=1 if p640==0 | p640==1 | p640==2
	label var contabilidad "dummy=1 si la empresas lleva libro de registro, balance-pyg u otro tipo contable "

		/*recode p1054_3 (1 = 1) (2 = 0), gen(mipyme_law)
		label var mipyme_law "dummy=1 si la empresa programas de formalizaci—n para su actividad econ—mica: Ley MIPYME (Ley 905/2004)"
		*1 yes, 2 no
		/*Ley   MIPYME (Ley 905/2004)*/
		*/
		
	rename p639 age
	label var age "edad de la empresa registrada en 5 opciones"

		/*
		1: Menos de un año
		2: De 1 a menos de 3 años
		3: De 3 a menos de 5 años
		4: De 5 a menos de 10 años
		5. 10 años y m‡s
		*/

************************************** variables TIC*******************************************

	g computadores = p1087+p1088
	label var computadores "nœmero de computadores que la empresa ten’a"

	g d_PC=0
	replace d_PC=1 if computadores>1
	label var d_PC "dummy=1 si la empresa ten’a al menos un computador"

	rename p977 tabletas
	label var tabletas "nœmero de tabletas que la empresa ten’a"

	g d_Tablet=0
	replace d_Tablet=1 if tabletas>1
	label var d_Tablet "dummy=1 si la empresa ten’a al menos una tableta"

	rename p978 tel_inteligente
	label var tel_inteligente "nœmero de telŽfonos inteligentes que la empresa ten’a"

	g d_TelI=0
	replace d_TelI=1 if tel_inteligente>1
	label var d_TelI "dummy=1 si la empresa ten’a al menos un telŽfono inteligente"

****************************************************************************
	g ict_gadgets=0
	replace ict_gadgets=1 if if d_PC==1 | d_Tablet==1 | d_TelI==1
	label var ict_gadgets "dummy=1 si la empresa ten’a al menos computador, tableta o telŽfono inteligente"
****************************************************************************

	g No_PC_altocosto=0
	replace No_PC_altocosto=1 if p994==1
	label var No_PC_altocosto "dummy=1 si la raz—n de no tener PC es alto costo"
	g No_PC_nonecesita=0
	replace No_PC_nonecesita=1 if p994==2
	label var No_PC_nonecesita "dummy=1 si la raz—n de no tener PC es que no se necesita"
	g No_PC_nosabeusarlo=0
	replace No_PC_nosabeusarlo=1 if p994==3
	label var No_PC_nosabeusarlo "dummy=1 si la raz—n de no tener PC es que no sabe usarlo"

		/*
		1. Es muy costoso 
		2. No se necesita 
		3. No sabe  usarlo 
		*/


	recode p2524 (1 = 1) (2 = 0), gen(internet)
	label var internet "dummy=1 si ÀEste establecimiento tiene acceso o utiliza el servicio de Internet?"

	recode p1093 (1 = 1) (2 = 0), gen(internet_e)
	label var internet_e "dummy=1 si ÀUtiliza Internet con conexi—n dentro del establecimiento?"

*****razones para no tener internet*****
	g NoInternet_altocosto=0
	replace NoInternet_altocosto=1 if p1095==1
	label var NoInternet_altocosto "dummy=1 si la raz—n de no tener internet es alto costo"
	g NoInternet_nonecesita=0
	replace NoInternet_nonecesita=1 if p1095==2
	label var NoInternet_nonecesita "dummy=1 si la raz—n de no tener internet es que no se necesita"
	g NoInternet_nosabeusarlo=0
	replace NoInternet_nosabeusarlo=1 if p1095==3
	label var NoInternet_nosabeusarlo "dummy=1 si la raz—n de no tener internet es que no sabe usarlo"
	g NoInternet_nodispositivo=0
	replace NoInternet_nodispositivo=1 if p1095==4
	label var NoInternet_nodispositivo "dummy=1 si la raz—n de no tener internet es que no tiene dispositivo"

		/*
		1. Es muy costoso 
		2. No se necesita 
		3. No sabe  usarlo 
		4. No tiene dispositivo para conectarse
		5. Tiene acceso suficiente desde otros lugares sin costo
		*/

	rename p980 porc_emplinternet
	label var porc_emplinternet "porcentaje de empleados que usan internet en trabajo"
	**revisar si es porcentaje**
	recode p2532 (1 = 1) (2 = 0), gen(web)
	label var web "dummy=1 si la empresa tuvo portal en 2013"

****************************************************************************
	g red=0
	replace red=1 if web==1 | internet==1 
	label var red "dummy=1 si la empresa tiene TIC en redes tecnologicas"
	
****************************************************************************

	g bandaancha=0
	label var bandaancha "ancho de banda de la internet"
	replace bandaancha=1 if p2529==0 | p2529==1 
	replace bandaancha=2 if p2529==2 
	replace bandaancha=3 if p2529==3
	replace bandaancha=4 if p2529==4
	replace bandaancha=5 if p2529==5
	replace bandaancha=6 if p2529==6

		/*
		0. Entre o y 256 KB (banda angosta)
		1. Entre 256 KB y 2MB (banda ancha)
		2. Entre 2 y menos de 4 MB  (banda ancha)
		3. 4 MB o más  (banda ancha)
		4. Móvil 2G  (banda ancha)
		5. Móvil 3G  (banda ancha)
		6. Móvil 4G  (banda ancha)
		*/

	recode p1006_1 (1 = 1) (2 = 0), gen(u_busquedaG)
	replace u_busquedaG=0 if p1006_1==.
	label var u_busquedaG "dummy=1 si la empresa uso internet para bœsqueda informaci—n"

	recode p1006_2 (1 = 1) (2 = 0), gen(u_banca)
	replace u_banca=0 if p1006_2==.
	label var u_banca "dummy=1 si la empresa uso internet para banca electr—nica"

	recode p1006_3 (1 = 1) (2 = 0), gen(u_gob)
	replace u_gob=0 if p1006_3==.
	label var u_gob "dummy=1 si la empresa uso internet para transacciones con gob"

	recode p1006_4 (1 = 1) (2 = 0), gen(u_servicioc)
	replace u_servicioc=0 if p1006_4==.
	label var u_servicioc "dummy=1 si la empresa uso internet para servicios al cliente"

	recode p1006_5 (1 = 1) (2 = 0), gen(u_distr)
	replace u_distr=0 if p1006_5==.
	label var u_distr "dummy=1 si la empresa uso internet para distribuir productos"

	recode p1006_6 (1 = 1) (2 = 0), gen(u_hpagos)
	replace u_hpagos=0 if p1006_6==.
	label var u_hpagos "dummy=1 si la empresa uso internet para hacer pagos (compras) proveedores"

	recode p1006_7 (1 = 1) (2 = 0), gen(u_rpagos)
	replace u_rpagos=0 if p1006_7==.
	label var u_rpagos "dummy=1 si la empresa uso internet para recibir pagos (vender) de clientes"

	recode p1006_8 (1 = 1) (2 = 0), gen(u_apps)
	replace u_apps=0 if p1006_8==.
	label var u_apps "dummy=1 si la empresa uso internet para aplicaciones"

	recode p1006_9 (1 = 1) (2 = 0), gen(u_correos)
	replace u_correos=0 if p1006_9==.
	label var u_correos "dummy=1 si la empresa uso internet para enviar y recibir correos"

	recode p1006_10 (1 = 1) (2 = 0), gen(u_busquedaE)
	replace u_busquedaE=0 if p1006_10==.
	label var u_busquedaE "dummy=1 si la empresa uso internet para bœsqueda informaci—n de empresas"
	
	
	recode p1006_12 (1 = 1) (2 = 0), gen(u_capacitacion)
	replace u_capacitacion=0 if p1006_12==.
	label var u_capacitacion "dummy=1 si la empresa uso internet para capacitar personal"
	

**************************************************************************************
	g usoTIC_avanz= 0
	replace usoTIC_avanz =1 if u_banca==1 | u_gob==1 | u_servicioc==1 | u_distr==1 | u_hpagos==1 | u_rpagos==1
	label var usoTIC_avanz "dummy=1 si la empresa uso la Internet en usos avanzadas"
**************************************************************************************

******************************************Tama–o, sueldos, ventas y costos*******************************
	
	rename p1010 ventas_a
	label var ventas_a "ventas totales en los œltimos 12 meses"

	rename p958 ventas_m
	label var ventas_m "ventas totales en el œltimo mes"

	destring actvdad_ciiu, replace
	rename actvdad_ciiu ciiu
	label var ciiu "CIIU Rev. 3 A.C. (2 d’gitos)"
	
	destring actvdad_ciiu_4, replace
	rename actvdad_ciiu_4 ciiu4
	label var ciiu4 "CIIU Rev. 3 A.C. (4 d’gitos)"
	
	rename p750 size
	label var size "total personal ocupado en los œltimos 12 meses"

	rename p748 po_permanente
	label var po_permanente "total personal ocupado permanente o contrato indefinido"
	
	rename p749 po_temporal
	label var po_temporal "total personal ocupado temporal"

	rename p724 mujeres_perm
	label var mujeres_perm "Mujeres con contrato a tŽrmino indefinido"
	gen p_mujeresPerm= (mujeres_perm/size)

	rename p726 mujeres_temp
	label var mujeres_temp "Mujeres con contrato a tŽrmino temporal"
	gen p_mujeresTemp= (mujeres_temp/size)

	rename p1107 salarios
	label var salarios "total sueldos y salarios pagados en el mes anterior"

	rename p722 mujeres_socios
	label var mujeres_socios "Mujeres socios, propietarios y familiares sin remuneraci—n"
	gen p_mujeressocios= (mujeres_socios/size)

	rename p1558 po_contratoescrito
	label var po_contratoescrito "total personal ocupado con contrato escrito"
	
	
	********************************************
	g r_salario= salarios*ipc14
	label var r_salario "salarios y sueldos reales"

	g salario_prom= r_salarios/size
	label var salario_prom "salario promedio" 
	********************************************
	**************************************************************************************
	g r_ventasa=ventas_a*ipc14
	label var r_ventasa "ventas reales anual"

	g va_a= r_ventasa/size
	label var va_a "productividad laboral promedio anual"
	
	g r_ventasm=ventas_a*ipc14
	label var r_ventasm "ventas reales mes"

	g va_m= r_ventasm/size
	label var va_m "productividad laboral promedio mes"
	**************************************************************************************

	**********************************RELACIONES COMERCIALES Y FINANCIERAS****************

	g pago_proveedores_fact=p1561_1
	label var pago_proveedores_fact "dummy=1 si realiza pago usando factura"

	g compra_proveedores_banco=0
	replace compra_proveedores_banco=1 if p1561_1==1 | p1561_2==1
	label var compra_proveedores_banco "dummy=1 si el soporte de compra a proveedores es bancaria"
	
	g porct_venta_familias=p1563_1
	replace porct_venta_familias=0 if p1563_1==.
	label var porct_venta_familias "porcentaje de ventas a familias o personas"
	
	recode p1564 (1 = 1) (2 = 0), gen(seguro)
	replace seguro=0 if p1564==.
	label var seguro "dummy=1 si la empresa tiene o ha tenido seguro del negocio"
	
	*******inclusion financiera****
	
	recode p1565 (1 = 1) (2 = 0), gen(prestamo)
	replace prestamo=0 if p1565==.
	label var prestamo "dummy=1 si la empresa ha solicitado prestamos"
	
		
	recode p1568 (1 = 1) (2 = 0), gen(prestamo_obtuvo)
	replace prestamo_obtuvo=0 if p1568==.
	label var prestamo_obtuvo "dummy=1 si la empresa obtuvo el prestamo"
	
	g prest_Instfin=0
	replace prest_Instfin=1 if p1569==1
	label var prest_Instfin "dummy=1 si la empresa solicito a entidad financiera"
	
	g prest_proveedor=0
	replace prest_proveedor=1 if p1569==2
	label var prest_proveedor "dummy=1 si la empresa solicito a proveedores"
	
	g prest_CC=0
	replace prest_CC=1 if p1569==3
	label var prest_CC "dummy=1 si la empresa solicito a Caja de compensacion"
	
	g prest_GS=0
	replace prest_GS=1 if p1569==4
	label var prest_GS "dummy=1 si la empresa solicito a grandes superficies"
	
	g prest_usureros=0
	replace prest_usureros=1 if p1569==5
	label var prest_usureros "dummy=1 si la empresa solicito a usureros"
	
	**********
	
	g credito_micro=0
	replace credito_micro=1 if p1571==1
	label var credito_micro "dummy=1 si la empresa obtuvo microcredito"
	
	
	g credito_consumo=0
	replace credito_consumo=1 if p1571==2
	label var credito_consumo "dummy=1 si la empresa obtuvo credito de consumo"
	
	
	g credito_vivienda=0
	replace credito_vivienda=1 if p1571==3
	label var credito_vivienda "dummy=1 si la empresa obtuvo credito de vivienda"
	
	recode p1586 (1 = 1) (2 = 0), gen(tinteres_conoce)
	replace tinteres_conoce=1 if p1586==.
	label var tinteres_conoce "dummy=1 si la empresa conocio la tasa de interes"
	
	g ahorro_financ=0
	replace ahorro_financ=1 if p1587==1
	label var ahorro_financ "dummy=1 si la empresa ahorro en entidad financiera"
	
	g ahorro_coop=0
	replace ahorro_coop=1 if p1587==2
	label var ahorro_coop "dummy=1 si la empresa ahorro en entidad cooperativa"
	
	g ahorro_grupo=0
	replace ahorro_grupo=1 if p1587==3
	label var ahorro_grupo "dummy=1 si la empresa ahorro en grupo de ahorro"
	
	g ahorro_seguro=0
	replace ahorro_seguro=1 if p1587==4
	label var ahorro_seguro "dummy=1 si la empresa ahorro en entidad de seguros"
	
	g ahorro_familia=0
	replace ahorro_familia=1 if p1587==5
	label var ahorro_familia "dummy=1 si la empresa ahorros familiares"
	
	*********
	
	recode p1573 (1 = 1) (2 = 0), gen(probl_fin)
	replace probl_fin=1 if p1573==.
	label var probl_fin "dummy=1 si la empresa tuvo problemas financieros"
	
		
	recode p1574_1 (1 = 1) (2 = 0), gen(falta_capital)
	replace falta_capital=1 if p1574_1==.
	label var falta_capital "dummy=1 si la empresa tuvo falta de capital"
				
	recode p1574_2 (1 = 1) (2 = 0), gen(falta_credito)
	replace falta_credito=1 if p1574_2==.
	label var falta_credito "dummy=1 si la empresa tuvo falta de credito"
	
	recode p1574_3 (1 = 1) (2 = 0), gen(altos_intereses)
	replace altos_intereses=1 if p1574_3==.
	label var altos_intereses "dummy=1 si la empresa enfrento altas tasa de interes"
	
	**********
	
	
	recode p1576_2 (1 = 1) (2 = 0), gen(altos_servpublicos)
	replace altos_servpublicos=1 if p1576_2==.
	label var altos_servpublicos "dummy=1 si la empresa enfrento servicios publicos caros"
	
	
	recode p1576_3 (1 = 1) (2 = 0), gen(cobertura_servpublicos)
	replace cobertura_servpublicos=1 if p1576_3==.
	label var cobertura_servpublicos "dummy=1 si la empresa enfrento cobertura servicios publicos"
	

	recode p1578_3 (1 = 1) (2 = 0), gen(capacitacion)
	replace capacitacion=1 if p1576_3==.
	label var capacitacion "dummy=1 si la empresa enfrento problemas de capacitacion"
	
	
	recode p1581_1 (1 = 1) (2 = 0), gen(baja_demanda)
	replace baja_demanda=1 if p1581_1==.
	label var baja_demanda "dummy=1 si la empresa enfrento problemas de clientes"
	
	
	recode p1581_3 (1 = 1) (2 = 0), gen(competencia)
	replace competencia=1 if p1581_3==.
	label var competencia "dummy=1 si la empresa enfrento mucha competencia"
	
	********
	
	recode p1066 (1 = 1) (2 = 0), gen(busco_empleo)
	replace busco_empleo=1 if p1066==.
	label var busco_empleo "dummy=1 si la empresa enfrento busco contratar empleados"
		
	
	g panel =panel_2013_2014
	label var panel "dummy=1 si la empresa aparece en 2013 y 2014"
	
		
	
keep id_firm year muncp dpto gender_d rut c_comercio Rc_comercio Impuesto_R Impuesto_IVA Impuesto_IC contabilidad age ///
computadores d_PC tabletas d_Tablet tel_inteligente d_TelI No_PC_altocosto No_PC_nonecesita No_PC_nosabeusarlo internet internet_e ///
NoInternet_altocosto NoInternet_nonecesita NoInternet_nosabeusarlo NoInternet_nodispositivo porc_emplinternet web red_social bandaancha ///
u_busquedaG u_banca u_gob u_servicioc u_distr u_hpagos u_rpagos u_apps u_correos u_busquedaE u_capacitacion e_creacion mujeres_perm mujeres_temp ///
ciiu ciiu4 size mujeres_socios p_mujeressocios salarios  ventas_a ventas_m p_mujeresPerm p_mujeresTemp po_contratoescrito r_salario ///
salario_prom r_ventasa va_a r_ventasm va_m pago_proveedores_fact compra_proveedores_banco porct_venta_familias seguro prestamo  prestamo_obtuvo ///
prest_Instfin  prest_proveedor prest_CC prest_GS prest_usureros credito_micro credito_consumo credito_vivienda tinteres_conoce ///
ahorro_financ ahorro_coop ahorro_grupo ahorro_seguro ahorro_familia probl_fin falta_capital falta_credito altos_intereses ///
altos_servpublicos cobertura_servpublicos capacitacion baja_demanda competencia busco_empleo panel 


	sort id_firm
	save MICRO_14.dta, replace


************************

 
cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC5_FEDESARROLLO\JUAN MIGUEL GALLEGO U_ROSARIO\ENTRA\MICROESTABLECIMIENTOS\MICRO_2015"
*******************************************************************************************
* *************************************** micro 2015*************************************
*******************************************************************************************

 
clear
use MICRO2015.dta 
	g year=2015

	scalar ipc11=100/109.16
	scalar ipc12=100/111.82  
	scalar ipc13=100/113.98
	scalar ipc14=100/118.15
	scalar ipc15=100/126.15
	scalar ipc16=100/133.40

	
	rename  identificador_new id_firm
	rename anio year
	destring cdgo_dprtmnto, replace
	destring cdgo_mncpio, replace
	destring id_firm, replace
	rename  cdgo_dprtmnto dpto
	rename cdgo_mncpio muncp

	recode p1633 (1 = 1) (2 = 0), gen(rut)
	label var rut "dummy=1 si la empresa tiene Registro ònico Tributario"
	recode p1055 (1 = 1) (2 = 0), gen(c_comercio)
	label var c_comercio "dummy=1 si la empresa tiene Registro de C‡mara de Comercio"
	recode p661 (1 = 1) (2 = 0), gen(Rc_comercio)
	label var Rc_comercio "dummy=1 si la empresa renov— u obtuvo Registro de C‡mara de Comercio en anio"

****************************************************************
	g formal= 0
	replace formal=1 if rut==1 | c_comercio==1 | Rc_comercio==1
	label var formal "dummy=1 si la empresa es formal robusto"

	g formal1= 0
	replace formal1=1 if rut==1 |  Rc_comercio==1
	label var formal1 "dummy=1 si la empresa es formal 2"
****************************************************************
/*
	g Impuesto_R=0
	replace Impuesto_R=1 if p1052_1=1 | p1052_1=3 
	label var Impuesto_R "dummy=1 si la empresa respondi— por el impuesto a la renta"

	g Impuesto_IVA=0
	replace Impuesto_IVA=1 if p1052_2=1 | p1052_2=3 
	label var Impuesto_IVA "dummy=1 si la empresa respondi— por el impuesto al IVA"

	g Impuesto_IC=0
	replace Impuesto_IC=1 if p1052_3=1 | p1052_3=3 
	label var Impuesto_IC "dummy=1 si la empresa respondi— por el impuesto de Ind. y Com."

****************************************************************
	g formal2= 0
	replace formal2=1 if Impuesto_R==1 & Impuesto_IVA==1 & Impuesto_IC==1
	label var formal2 "dummy=1 si la empresa es formal robusto"

****************************************************************
*/
	g contabilidad=0
	replace contabilidad=1 if p640==0 | p640==1 | p640==2
	label var contabilidad "dummy=1 si la empresas lleva libro de registro, balance-pyg u otro tipo contable "

		/*recode p1054_3 (1 = 1) (2 = 0), gen(mipyme_law)
		label var mipyme_law "dummy=1 si la empresa programas de formalizaci—n para su actividad econ—mica: Ley MIPYME (Ley 905/2004)"
		*1 yes, 2 no
		/*Ley   MIPYME (Ley 905/2004)*/
		*/
		
	rename p639 age
	label var age "edad de la empresa registrada en 5 opciones"

		/*
		1: Menos de un año
		2: De 1 a menos de 3 años
		3: De 3 a menos de 5 años
		4: De 5 a menos de 10 años
		5. 10 años y m‡s
		*/

************************************** variables TIC*******************************************

	g computadores = p1087+p1088
	label var computadores "nœmero de computadores que la empresa ten’a"

	g d_PC=0
	replace d_PC=1 if computadores>1
	label var d_PC "dummy=1 si la empresa ten’a al menos un computador"

	rename p977 tabletas
	label var tabletas "nœmero de tabletas que la empresa ten’a"

	g d_Tablet=0
	replace d_Tablet=1 if tabletas>1
	label var d_Tablet "dummy=1 si la empresa ten’a al menos una tableta"

	rename p978 tel_inteligente
	label var tel_inteligente "nœmero de telŽfonos inteligentes que la empresa ten’a"

	g d_TelI=0
	replace d_TelI=1 if tel_inteligente>1
	label var d_TelI "dummy=1 si la empresa ten’a al menos un telŽfono inteligente"

****************************************************************************
	g ict_gadgets=0
	replace ict_gadgets=1 if if d_PC==1 | d_Tablet==1 | d_TelI==1
	label var ict_gadgets "dummy=1 si la empresa ten’a al menos computador, tableta o telŽfono inteligente"
****************************************************************************

	g No_PC_altocosto=0
	replace No_PC_altocosto=1 if p994==1
	label var No_PC_altocosto "dummy=1 si la raz—n de no tener PC es alto costo"
	g No_PC_nonecesita=0
	replace No_PC_nonecesita=1 if p994==2
	label var No_PC_nonecesita "dummy=1 si la raz—n de no tener PC es que no se necesita"
	g No_PC_nosabeusarlo=0
	replace No_PC_nosabeusarlo=1 if p994==3
	label var No_PC_nosabeusarlo "dummy=1 si la raz—n de no tener PC es que no sabe usarlo"

		/*
		1. Es muy costoso 
		2. No se necesita 
		3. No sabe  usarlo 
		*/


	recode p2524 (1 = 1) (2 = 0), gen(internet)
	label var internet "dummy=1 si ÀEste establecimiento tiene acceso o utiliza el servicio de Internet?"

	recode p1093 (1 = 1) (2 = 0), gen(internet_e)
	label var internet_e "dummy=1 si ÀUtiliza Internet con conexi—n dentro del establecimiento?"

*****razones para no tener internet*****
	g NoInternet_altocosto=0
	replace NoInternet_altocosto=1 if p1095==1
	label var NoInternet_altocosto "dummy=1 si la raz—n de no tener internet es alto costo"
	g NoInternet_nonecesita=0
	replace NoInternet_nonecesita=1 if p1095==2
	label var NoInternet_nonecesita "dummy=1 si la raz—n de no tener internet es que no se necesita"
	g NoInternet_nosabeusarlo=0
	replace NoInternet_nosabeusarlo=1 if p1095==3
	label var NoInternet_nosabeusarlo "dummy=1 si la raz—n de no tener internet es que no sabe usarlo"
	g NoInternet_nodispositivo=0
	replace NoInternet_nodispositivo=1 if p1095==4
	label var NoInternet_nodispositivo "dummy=1 si la raz—n de no tener internet es que no tiene dispositivo"

		/*
		1. Es muy costoso 
		2. No se necesita 
		3. No sabe  usarlo 
		4. No tiene dispositivo para conectarse
		5. Tiene acceso suficiente desde otros lugares sin costo
		*/

	rename p980 porc_emplinternet
	label var porc_emplinternet "porcentaje de empleados que usan internet en trabajo"
	**revisar si es porcentaje**
	
	recode p2532 (1 = 1) (2 = 0), gen(web)
	label var web "dummy=1 si la empresa tuvo portal en 2013"

****************************************************************************
	g red=0
	replace red=1 if web==1 | internet==1 
	label var red "dummy=1 si la empresa tiene TIC en redes tecnologicas"
	
	recode p1559 (1 = 1) (2 = 0), gen(red_social)
	label var red_social "dummy=1 si la empresa tuvo presencia en redes sociales"
	
****************************************************************************

	g bandaancha=0
	label var bandaancha "ancho de banda de la internet"
	replace bandaancha=1 if p2529==0 | p2529==1 
	replace bandaancha=2 if p2529==2 
	replace bandaancha=3 if p2529==3
	replace bandaancha=4 if p2529==4
	replace bandaancha=5 if p2529==5
	replace bandaancha=6 if p2529==6

		/*
		0. Entre o y 256 KB (banda angosta)
		1. Entre 256 KB y 2MB (banda ancha)
		2. Entre 2 y menos de 4 MB  (banda ancha)
		3. 4 MB o más  (banda ancha)
		4. Móvil 2G  (banda ancha)
		5. Móvil 3G  (banda ancha)
		6. Móvil 4G  (banda ancha)
		*/

	recode p1006_1 (1 = 1) (2 = 0), gen(u_busquedaG)
	replace u_busquedaG=0 if p1006_1==.
	label var u_busquedaG "dummy=1 si la empresa uso internet para bœsqueda informaci—n"

	recode p1006_2 (1 = 1) (2 = 0), gen(u_banca)
	replace u_banca=0 if p1006_2==.
	label var u_banca "dummy=1 si la empresa uso internet para banca electr—nica"

	recode p1006_3 (1 = 1) (2 = 0), gen(u_gob)
	replace u_gob=0 if p1006_3==.
	label var u_gob "dummy=1 si la empresa uso internet para transacciones con gob"

	recode p1006_4 (1 = 1) (2 = 0), gen(u_servicioc)
	replace u_servicioc=0 if p1006_4==.
	label var u_servicioc "dummy=1 si la empresa uso internet para servicios al cliente"

	recode p1006_5 (1 = 1) (2 = 0), gen(u_distr)
	replace u_distr=0 if p1006_5==.
	label var u_distr "dummy=1 si la empresa uso internet para distribuir productos"

	recode p1006_6 (1 = 1) (2 = 0), gen(u_hpagos)
	replace u_hpagos=0 if p1006_6==.
	label var u_hpagos "dummy=1 si la empresa uso internet para hacer pagos (compras) proveedores"

	recode p1006_7 (1 = 1) (2 = 0), gen(u_rpagos)
	replace u_rpagos=0 if p1006_7==.
	label var u_rpagos "dummy=1 si la empresa uso internet para recibir pagos (vender) de clientes"

	recode p1006_8 (1 = 1) (2 = 0), gen(u_apps)
	replace u_apps=0 if p1006_8==.
	label var u_apps "dummy=1 si la empresa uso internet para aplicaciones"

	recode p1006_9 (1 = 1) (2 = 0), gen(u_correos)
	replace u_correos=0 if p1006_9==.
	label var u_correos "dummy=1 si la empresa uso internet para enviar y recibir correos"

	recode p1006_10 (1 = 1) (2 = 0), gen(u_busquedaE)
	replace u_busquedaE=0 if p1006_10==.
	label var u_busquedaE "dummy=1 si la empresa uso internet para bœsqueda informaci—n de empresas"
	
	recode p1006_12 (1 = 1) (2 = 0), gen(u_capacitacion)
	replace u_capacitacion=0 if p1006_12==.
	label var u_capacitacion "dummy=1 si la empresa uso internet para capacitar personal"

**************************************************************************************
	g usoTIC_avanz= 0
	replace usoTIC_avanz =1 if u_banca==1 | u_gob==1 | u_servicioc==1 | u_distr==1 | u_hpagos==1 | u_rpagos==1 | u_capacitacion==1
	label var usoTIC_avanz "dummy=1 si la empresa uso la Internet en usos avanzadas"
**************************************************************************************

******************************************Tama–o, sueldos, ventas y costos*******************************


	rename p1010 ventas_a
	label var ventas_a "ventas totales en los œltimos 12 meses"

	rename p958 ventas_m
	label var ventas_m "ventas totales en el œltimo mes"

	destring actvdad_ciiu, replace
	rename actvdad_ciiu ciiu
	label var ciiu "CIIU Rev. 3 A.C. (2 d’gitos)"
	
	destring actvdad_ciiu_4, replace
	rename actvdad_ciiu_4 ciiu4
	label var ciiu4 "CIIU Rev. 3 A.C. (4 d’gitos)"
	
	rename p750 size
	label var size "total personal ocupado en los œltimos 12 meses"

	rename p748 po_permanente
	label var po_permanente "total personal ocupado permanente o contrato indefinido"
	
	rename p748i po_temporal
	label var po_temporal "total personal ocupado temporal"

	rename p724 mujeres_perm
	label var mujeres_perm "Mujeres con contrato a tŽrmino indefinido"
	gen p_mujeresPerm= (mujeres_perm/size)

	rename p748g mujeres_temp
	label var mujeres_temp "Mujeres con contrato a tŽrmino temporal"
	gen p_mujeresTemp= (mujeres_temp/size)

	rename p1107 salarios
	label var salarios "total sueldos y salarios pagados en el mes anterior"

	rename p722 mujeres_socios
	label var mujeres_socios "Mujeres socios, propietarios y familiares sin remuneraci—n"
	gen p_mujeressocios= (mujeres_socios/size)

	rename p1558 po_contratoescrito
	label var po_contratoescrito "total personal ocupado con contrato escrito"
	
	
	********************************************
	g r_salario= salarios*ipc15
	label var r_salario "salarios y sueldos reales"

	g salario_prom= r_salarios/size
	label var salario_prom "salario promedio" 
	********************************************
	**************************************************************************************
	
	g r_ventasa=ventas_a*ipc15
	label var r_ventasa "ventas reales anual"

	g va_a= r_ventasa/size
	label var va_a "productividad laboral promedio anual"
	
	g r_ventasm=ventas_a*ipc15
	label var r_ventasm "ventas reales mes"

	g va_m= r_ventasm/size
	label var va_m "productividad laboral promedio mes"
	**************************************************************************************

	**********************************RELACIONES COMERCIALES Y FINANCIERAS****************

	g acepta_efectivo=p1764
	replace acepta_efectivo=0 if p1764==1
	label var acepta_efectivo "dummy=1 si la empresa acepta efectivo como pago"
	
	g acepta_cheque=p1764
	replace acepta_cheque=0 if p1764==2
	label var acepta_cheque "dummy=1 si la empresa acepta cheque como pago"
	
	g acepta_girob=p1764
	replace acepta_girob=0 if p1764==3
	label var acepta_girob "dummy=1 si la empresa acepta giro bancario como pago"
	
	g acepta_tc=p1764
	replace acepta_tc=0 if p1764==5
	label var acepta_tc "dummy=1 si la empresa acepta tarjeta de credito como pago"
	
		
	g acepta_pi=p1764
	replace acepta_pi=0 if p1764==6
	label var acepta_pi "dummy=1 si la empresa acepta pagos por internet"
	
	**************
	
	*******inclusion financiera****
	
	recode p1756 (1 = 1) (2 = 0), gen(prestamo)
	replace prestamo=0 if p1756==.
	label var prestamo "dummy=1 si la empresa ha solicitado prestamos"
	
		
	recode p1568 (1 = 1) (2 = 0), gen(prestamo_obtuvo)
	replace prestamo_obtuvo=0 if p1568==.
	label var prestamo_obtuvo "dummy=1 si la empresa obtuvo el prestamo"
	
	g prest_Instfin=0
	replace prest_Instfin=1 if p1569==1
	label var prest_Instfin "dummy=1 si la empresa solicito a entidad financiera"
	
	g prest_proveedor=0
	replace prest_proveedor=1 if p1569==2
	label var prest_proveedor "dummy=1 si la empresa solicito a proveedores"
	
	g prest_CC=0
	replace prest_CC=1 if p1569==3
	label var prest_CC "dummy=1 si la empresa solicito a Caja de compensacion, GS "

	
	g prest_usureros=0
	replace prest_usureros=1 if p1569==4 | p1569==5
	label var prest_usureros "dummy=1 si la empresa solicito a usureros"
	
	*******////****
	
		
	g ahorros=0
	replace ahorros=1 if p3014==1
	label var ahorros "dummy=1 si la empresa ahorro"
	
	g ahorro_financ=0
	replace ahorro_financ=1 if p1771==1
	label var ahorro_financ "dummy=1 si la empresa ahorro en entidad financiera"
	
	g ahorro_coop=0
	replace ahorro_coop=1 if p1771==2
	label var ahorro_coop "dummy=1 si la empresa ahorro en entidad cooperativa"
	
	g ahorro_grupo=0
	replace ahorro_grupo=1 if p1771==3
	label var ahorro_grupo "dummy=1 si la empresa ahorro en grupo de ahorro"
	
	g ahorro_cc=0
	replace ahorro_cc=1 if p1771==4
	label var ahorro_cc "dummy=1 si la empresa ahorro en caja de compensacion"
	
	g ahorro_familia=0
	replace ahorro_familia=1 if p1771==5
	label var ahorro_familia "dummy=1 si la empresa ahorros familiares"
	
	
	********/
	
	recode p1066 (1 = 1) (2 = 0), gen(busco_empleo)
	replace busco_empleo=1 if p1066==.
	label var busco_empleo "dummy=1 si la empresa enfrento busco contratar empleados"
	
	
	g panel =panel_2014_2015
	label var panel "dummy=1 si la empresa aparece en 2014 y 2015"
	
		
	
keep id_firm year muncp dpto gender_d rut c_comercio Rc_comercio formal formal1 contabilidad  age ///
computadores d_PC tabletas d_Tablet tel_inteligente d_TelI ict_gadgets No_PC_altocosto No_PC_nonecesita No_PC_nosabeusarlo ///
internet internet_e NoInternet_altocosto NoInternet_nonecesita NoInternet_nosabeusarlo NoInternet_nodispositivo ///
porc_emplinternet web  red_social bandaancha u_busquedaG u_banca u_gob u_servicioc u_distr u_hpagos u_rpagos u_apps u_correos u_busquedaE ///
u_capacitacion usoTIC_avanz ventas_m ciiu ciiu4 size po_permanente po_temporal mujeres_temp mujeres_perm salarios ///
mujeres_socios p_mujeressocios po_contratoescrito r_salario salario_prom r_ventasa va_a r_ventasm va_m acepta_efectivo acepta_cheque ///
acepta_girob acepta_tc acepta_pint prestamo  prestamo_obtuvo prest_Instfin  prest_proveedor prest_CC prest_GS prest_usureros ///
ahorros ahorro_financ ahorro_coop ahorro_grupo ahorro_cc ahorro_familia busco_empleo panel 
			
	sort id_firm
	save MICRO_15.dta, replace


*********


cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC5_FEDESARROLLO\JUAN MIGUEL GALLEGO U_ROSARIO\ENTRA\MICROESTABLECIMIENTOS\MICRO_2016"
*******************************************************************************************
* *************************************** micro 2016*************************************
*******************************************************************************************

 
clear
use MICRO2016.dta 
	g year=2016

	scalar ipc11=100/109.16
	scalar ipc12=100/111.82  
	scalar ipc13=100/113.98
	scalar ipc14=100/118.15
	scalar ipc15=100/126.15
	scalar ipc16=100/133.40

	
	rename  identificador_new id_firm
	rename anio year
	destring cdgo_dprtmnto, replace
	destring cdgo_mncpio, replace
	destring id_firm, replace
	rename  cdgo_dprtmnto dpto
	rename cdgo_mncpio muncp

	recode p1633 (1 = 1) (2 = 0), gen(rut)
	label var rut "dummy=1 si la empresa tiene Registro ònico Tributario"
	recode p1055 (1 = 1) (2 = 0), gen(c_comercio)
	label var c_comercio "dummy=1 si la empresa tiene Registro de C‡mara de Comercio"
	recode p661 (1 = 1) (2 = 0), gen(Rc_comercio)
	label var Rc_comercio "dummy=1 si la empresa renov— u obtuvo Registro de C‡mara de Comercio en anio"

****************************************************************
	g formal= 0
	replace formal=1 if rut==1 | c_comercio==1 | Rc_comercio==1
	label var formal "dummy=1 si la empresa es formal robusto"

	g formal1= 0
	replace formal1=1 if rut==1 |  Rc_comercio==1
	label var formal1 "dummy=1 si la empresa es formal 2"
***************************************************************
****************************************************************
*/
	g contabilidad=0
	replace contabilidad=1 if p640==0 | p640==1 | p640==2
	label var contabilidad "dummy=1 si la empresas lleva libro de registro, balance-pyg u otro tipo contable "
		
	rename p639 age
	label var age "edad de la empresa registrada en 5 opciones"

		/*
		1: Menos de un año
		2: De 1 a menos de 3 años
		3: De 3 a menos de 5 años
		4: De 5 a menos de 10 años
		5. 10 años y m‡s
		*/

************************************** variables TIC*******************************************

	g computadores = p1087+p1088
	label var computadores "nœmero de computadores que la empresa ten’a"

	g d_PC=0
	replace d_PC=1 if computadores>1
	label var d_PC "dummy=1 si la empresa ten’a al menos un computador"

	rename p977 tabletas
	label var tabletas "nœmero de tabletas que la empresa ten’a"

	g d_Tablet=0
	replace d_Tablet=1 if tabletas>1
	label var d_Tablet "dummy=1 si la empresa ten’a al menos una tableta"

	rename p978 tel_inteligente
	label var tel_inteligente "nœmero de telŽfonos inteligentes que la empresa ten’a"

	g d_TelI=0
	replace d_TelI=1 if tel_inteligente>1
	label var d_TelI "dummy=1 si la empresa ten’a al menos un telŽfono inteligente"

****************************************************************************
	g ict_gadgets=0
	replace ict_gadgets=1 if if d_PC==1 | d_Tablet==1 | d_TelI==1
	label var ict_gadgets "dummy=1 si la empresa ten’a al menos computador, tableta o telŽfono inteligente"
****************************************************************************

	g No_PC_altocosto=0
	replace No_PC_altocosto=1 if p994==1
	label var No_PC_altocosto "dummy=1 si la raz—n de no tener PC es alto costo"
	g No_PC_nonecesita=0
	replace No_PC_nonecesita=1 if p994==2
	label var No_PC_nonecesita "dummy=1 si la raz—n de no tener PC es que no se necesita"
	g No_PC_nosabeusarlo=0
	replace No_PC_nosabeusarlo=1 if p994==3
	label var No_PC_nosabeusarlo "dummy=1 si la raz—n de no tener PC es que no sabe usarlo"

		/*
		1. Es muy costoso 
		2. No se necesita 
		3. No sabe  usarlo 
		*/


	recode p2524 (1 = 1) (2 = 0), gen(internet)
	label var internet "dummy=1 si ÀEste establecimiento tiene acceso o utiliza el servicio de Internet?"

	recode p1093 (1 = 1) (2 = 0), gen(internet_e)
	label var internet_e "dummy=1 si ÀUtiliza Internet con conexi—n dentro del establecimiento?"

*****razones para no tener internet*****
	g NoInternet_altocosto=0
	replace NoInternet_altocosto=1 if p1095==1
	label var NoInternet_altocosto "dummy=1 si la raz—n de no tener internet es alto costo"
	g NoInternet_nonecesita=0
	replace NoInternet_nonecesita=1 if p1095==2
	label var NoInternet_nonecesita "dummy=1 si la raz—n de no tener internet es que no se necesita"
	g NoInternet_nosabeusarlo=0
	replace NoInternet_nosabeusarlo=1 if p1095==3
	label var NoInternet_nosabeusarlo "dummy=1 si la raz—n de no tener internet es que no sabe usarlo"
	g NoInternet_nodispositivo=0
	replace NoInternet_nodispositivo=1 if p1095==4
	label var NoInternet_nodispositivo "dummy=1 si la raz—n de no tener internet es que no tiene dispositivo"

		/*
		1. Es muy costoso 
		2. No se necesita 
		3. No sabe  usarlo 
		4. No tiene dispositivo para conectarse
		5. Tiene acceso suficiente desde otros lugares sin costo
		*/

	rename p980 porc_emplinternet
	label var porc_emplinternet "porcentaje de empleados que usan internet en trabajo"
	**revisar si es porcentaje**
	
	recode p2532 (1 = 1) (2 = 0), gen(web)
	label var web "dummy=1 si la empresa tuvo portal"

	recode p1559 (1 = 1) (2 = 0), gen(red_social)
	label var red_social "dummy=1 si la empresa tuvo presencia en redes sociales"
	
****************************************************************************
	g red=0
	replace red=1 if web==1 | internet==1 
	label var red "dummy=1 si la empresa tiene TIC en redes tecnologicas"
****************************************************************************

	g bandaancha=0
	label var bandaancha "ancho de banda de la internet"
	replace bandaancha=1 if p2529==0 | p2529==1 
	replace bandaancha=2 if p2529==2 
	replace bandaancha=3 if p2529==3
	replace bandaancha=4 if p2529==4
	replace bandaancha=5 if p2529==5
	replace bandaancha=6 if p2529==6

		/*
		0. Entre o y 256 KB (banda angosta)
		1. Entre 256 KB y 2MB (banda ancha)
		2. Entre 2 y menos de 4 MB  (banda ancha)
		3. 4 MB o más  (banda ancha)
		4. Móvil 2G  (banda ancha)
		5. Móvil 3G  (banda ancha)
		6. Móvil 4G  (banda ancha)
		*/

	recode p1006_1 (1 = 1) (2 = 0), gen(u_busquedaG)
	replace u_busquedaG=0 if p1006_1==.
	label var u_busquedaG "dummy=1 si la empresa uso internet para bœsqueda informaci—n"

	recode p1006_2 (1 = 1) (2 = 0), gen(u_banca)
	replace u_banca=0 if p1006_2==.
	label var u_banca "dummy=1 si la empresa uso internet para banca electr—nica"

	recode p1006_3 (1 = 1) (2 = 0), gen(u_gob)
	replace u_gob=0 if p1006_3==.
	label var u_gob "dummy=1 si la empresa uso internet para transacciones con gob"

	recode p1006_4 (1 = 1) (2 = 0), gen(u_servicioc)
	replace u_servicioc=0 if p1006_4==.
	label var u_servicioc "dummy=1 si la empresa uso internet para servicios al cliente"

	recode p1006_5 (1 = 1) (2 = 0), gen(u_distr)
	replace u_distr=0 if p1006_5==.
	label var u_distr "dummy=1 si la empresa uso internet para distribuir productos"

	recode p1006_6 (1 = 1) (2 = 0), gen(u_hpagos)
	replace u_hpagos=0 if p1006_6==.
	label var u_hpagos "dummy=1 si la empresa uso internet para hacer pagos (compras) proveedores"

	recode p1006_7 (1 = 1) (2 = 0), gen(u_rpagos)
	replace u_rpagos=0 if p1006_7==.
	label var u_rpagos "dummy=1 si la empresa uso internet para recibir pagos (vender) de clientes"

	recode p1006_8 (1 = 1) (2 = 0), gen(u_apps)
	replace u_apps=0 if p1006_8==.
	label var u_apps "dummy=1 si la empresa uso internet para aplicaciones"

	recode p1006_9 (1 = 1) (2 = 0), gen(u_correos)
	replace u_correos=0 if p1006_9==.
	label var u_correos "dummy=1 si la empresa uso internet para enviar y recibir correos"

	recode p1006_10 (1 = 1) (2 = 0), gen(u_busquedaE)
	replace u_busquedaE=0 if p1006_10==.
	label var u_busquedaE "dummy=1 si la empresa uso internet para bœsqueda informaci—n de empresas"
	
	recode p1006_12 (1 = 1) (2 = 0), gen(u_capacitacion)
	replace u_capacitacion=0 if p1006_12==.
	label var u_capacitacion "dummy=1 si la empresa uso internet para capacitar personal"

**************************************************************************************
	g usoTIC_avanz= 0
	replace usoTIC_avanz =1 if u_banca==1 | u_gob==1 | u_servicioc==1 | u_distr==1 | u_hpagos==1 | u_rpagos==1 | u_capacitacion==1
	label var usoTIC_avanz "dummy=1 si la empresa uso la Internet en usos avanzadas"
**************************************************************************************

******************************************Tama–o, sueldos, ventas y costos*******************************

	rename p1010 ventas_a
	label var ventas_a "ventas totales en los œltimos 12 meses"

	rename p958 ventas_m
	label var ventas_m "ventas totales en el œltimo mes"

	destring actvdad_ciiu, replace
	rename actvdad_ciiu ciiu
	label var ciiu "CIIU Rev. 3 A.C. (2 d’gitos)"
	
	destring actvdad_ciiu_4, replace
	rename actvdad_ciiu_4 ciiu4
	label var ciiu4 "CIIU Rev. 3 A.C. (4 d’gitos)"
	
	rename p750 size
	label var size "total personal ocupado en los œltimos 12 meses"

	rename p748 po_permanente
	label var po_permanente "total personal ocupado permanente o contrato indefinido"
	
	g po_temporal=p726+p727
	label var po_temporal "total personal ocupado temporal"

	rename p724 mujeres_perm
	label var mujeres_perm "Mujeres con contrato a tŽrmino indefinido"
	
	gen p_mujeresPerm= (mujeres_perm/size)

	rename p726 mujeres_temp
	label var mujeres_temp "Mujeres con contrato a tŽrmino temporal"
	
	gen p_mujeresTemp= (mujeres_temp/size)

	rename p1107 salarios
	label var salarios "total sueldos y salarios pagados en el mes anterior"

	rename p722 mujeres_socios
	label var mujeres_socios "Mujeres socios, propietarios y familiares sin remuneraci—n"
	gen p_mujeressocios= (mujeres_socios/size)
	
	
	********************************************
	g r_salario= salarios*ipc16
	label var r_salario "salarios y sueldos reales"

	g salario_prom= r_salarios/size
	label var salario_prom "salario promedio" 
	********************************************
	**************************************************************************************
	
	g r_ventasa=ventas_a*ipc16
	label var r_ventasa "ventas reales anual"

	g va_a= r_ventasa/size
	label var va_a "productividad laboral promedio anual"
	
	g r_ventasm=ventas_a*ipc16
	label var r_ventasm "ventas reales mes"

	g va_m= r_ventasm/size
	label var va_m "productividad laboral promedio mes"
	**************************************************************************************

	**********************************RELACIONES COMERCIALES Y FINANCIERAS****************

	g acepta_efectivo=p1764
	replace acepta_efectivo=0 if p1764==1
	label var acepta_efectivo "dummy=1 si la empresa acepta efectivo como pago"
	
	g acepta_cheque=p1764
	replace acepta_cheque=0 if p1764==2
	label var acepta_cheque "dummy=1 si la empresa acepta cheque como pago"
	
	g acepta_girob=p1764
	replace acepta_girob=0 if p1764==3
	label var acepta_girob "dummy=1 si la empresa acepta giro bancario como pago"
	
	g acepta_tc=p1764
	replace acepta_tc=0 if p1764==5
	label var acepta_tc "dummy=1 si la empresa acepta tarjeta de credito como pago"
	
		
	g acepta_pi=p1764
	replace acepta_pi=0 if p1764==6
	label var acepta_pi "dummy=1 si la empresa acepta pagos por internet"
	
	**************
	
	*******inclusion financiera****
	
	recode p1765 (1 = 1) (2 = 0), gen(prestamo)
	replace prestamo=0 if p1765==.
	label var prestamo "dummy=1 si la empresa ha solicitado prestamos"
	
		
	recode p1568 (1 = 1) (2 = 0), gen(prestamo_obtuvo)
	replace prestamo_obtuvo=0 if p1568==.
	label var prestamo_obtuvo "dummy=1 si la empresa obtuvo el prestamo"
	
	g prest_Instfin=0
	replace prest_Instfin=1 if p1569==1
	label var prest_Instfin "dummy=1 si la empresa solicito a entidad financiera"
	
	g prest_proveedor=0
	replace prest_proveedor=1 if p1569==2
	label var prest_proveedor "dummy=1 si la empresa solicito a proveedores"
	
	g prest_CC=0
	replace prest_CC=1 if p1569==3
	label var prest_CC "dummy=1 si la empresa solicito a Caja de compensacion, GS "

	
	g prest_usureros=0
	replace prest_usureros=1 if p1569==4 | p1569==5
	label var prest_usureros "dummy=1 si la empresa solicito a usureros"
	
	g prest_amigos=0
	replace prest_amigos=1 if p1569==6 
	label var prest_amigos "dummy=1 si la empresa solicito a amigos"
	
	g prest_microcrediticias=0
	replace prest_microcrediticias=1 if p1569==7 
	label var prest_microcrediticias "dummy=1 si la empresa solicito a amigos"
	
	*******////****
	
	g ahorros=0
	replace ahorros=1 if p3014==1
	label var ahorros "dummy=1 si la empresa ahorro"
	
	g ahorro_financ=0
	replace ahorro_financ=1 if p1771==1
	label var ahorro_financ "dummy=1 si la empresa ahorro en entidad financiera"
	
	g ahorro_coop=0
	replace ahorro_coop=1 if p1771==2
	label var ahorro_coop "dummy=1 si la empresa ahorro en entidad cooperativa"
	
	g ahorro_grupo=0
	replace ahorro_grupo=1 if p1771==3
	label var ahorro_grupo "dummy=1 si la empresa ahorro en grupo de ahorro"
	
	g ahorro_familia=0
	replace ahorro_familia=1 if p1771==4
	label var ahorro_familia "dummy=1 si la empresa ahorros familiares"
	
	
	********/

	
	g panel =panel_2015_2016
	label var panel "dummy=1 si la empresa aparece en 2015 y 2016"
	
		
	
keep id_firm year muncp dpto gender_d rut c_comercio Rc_comercio formal formal1 contabilidad  age ///
computadores d_PC tabletas d_Tablet tel_inteligente d_TelI ict_gadgets No_PC_altocosto No_PC_nonecesita No_PC_nosabeusarlo ///
internet internet_e NoInternet_altocosto NoInternet_nonecesita NoInternet_nosabeusarlo NoInternet_nodispositivo ///
porc_emplinternet web red_social bandaancha u_busquedaG u_banca u_gob u_servicioc u_distr u_hpagos u_rpagos u_apps u_correos u_busquedaE ///
u_capacitacion usoTIC_avanz ventas_m ciiu ciiu4 size po_permanente po_temporal mujeres_temp mujeres_perm salarios ///
mujeres_socios p_mujeressocios po_contratoescrito r_salario salario_prom r_ventasa va_a r_ventasm va_m acepta_efectivo acepta_cheque ///
acepta_girob acepta_tc acepta_pint prestamo  prestamo_obtuvo prest_Instfin  prest_proveedor prest_CC prest_GS prest_usureros ///
ahorros ahorro_financ ahorro_coop ahorro_grupo ahorro_cc ahorro_familia panel 
			

	sort id_firm
	save MICRO_16.dta, replace






