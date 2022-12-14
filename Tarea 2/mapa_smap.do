**************************************************
*** MAPA DE THEFTS EN LONDRES UTILIZANDO SPMAP ***
**************************************************

/* 

Do-file modificado a partir de la clase tutorial de "Herramientas computacionales para la Investigación" dictada por Amelia Gibbons en la Universidad de San Andrés (UdeSA)

Tutorial basado en "Econometría Espacial usando Stata. Guía Teórico-Aplicada"	 					 
Autor: Marcos Herrera (CONICET-IELDE, UNSa, Argentina)
e-mail: mherreragomez@gmail.com
  
*/

* Guardamos el path donde están los datos que necesitamos como DATA (global)

global DATA = "C:/Users/Pc__/Desktop/Herramientas computacionales/Clase 5/videos 2 y 3/data"
cd "$DATA"

******************************************
* INSTALACIÓN DE LOS PAQUETES NECESARIOS *
******************************************
ssc install spmap
ssc install shp2dta
*net install sg162, from(http://www.stata.com/stb/stb60)
*net install st0292, from(http://www.stata-journal.com/software/sj13-2)
net install spwmatrix, from(http://fmwww.bc.edu/RePEc/bocode/s)
*net install splagvar, from(http://fmwww.bc.edu/RePEc/bocode/s)
*ssc install xsmle.pkg
*ssc install xtcsd
*net install st0446.pkg


********************************
*   LECTURA Y MAPAS DE DATOS   *
********************************

* Leer la información shape en Stata

shp2dta using london_sport.shp, database(ls) coord(coord_ls) genc(c) genid(id) replace

/* El comando anterior genera dos nuevos archivos: datos_shp.dta y coord.dta
El primero contiene los atributos (variables) del shape. 
El segundo contiene la información sobre la formas geográficas. 
Se generan en el archivo de datos tres variables:
id: identifica a la región. 
c: genera el centroide por medio de las variables: x_c: longitud, y_c: latitud
*/

use ls, clear
describe

use coord_ls, clear
describe

/* Importamos y transformamos los datos de Excel a formato Stata */
import delimited "$DATA/mps-recordedcrime-borough.csv", clear 

* Nos quedamos unicamente con los thefts
keep if crimetype=="Theft & Handling"

* En Stata necesitamos que la variable tenga el mismo nombre en ambas bases para juntarlas
rename borough name /*cambiamos el nombre de la variable borough por name*/
* preserve /*sirve por si queremos volver atrás una vez que utilizamos collapse*/
collapse (sum) crimecount, by(name)
*restore
save "crime1.dta", replace

describe

/* Uniremos ambas bases: london_sport y crime. Su usa la función merge con la variable name que se encuentra en ambas bases */

use ls, clear
merge 1:1 name using crime1.dta
*merge 1:1 name using crime.dta, keep(3) nogen
*keep if _m==3
drop _m

* Cambiamos el nombre de crimecount por theft
rename crimecount theft

save london_thefts_shp.dta, replace

*************************************
* Representación por medio de mapas *
*************************************

use london_thefts_shp.dta, clear

* Generamos una variable intensiva: cant de crímenes (thefts) cada 10 mil habitantes

gen theft_pop=(theft/Pop_2001)*100000

* Mapa de cuantiles:

spmap theft_pop using coord_ls, id(id) clmethod(q) cln(6) title("Thefts in London") subtitle("per 100.000 inhabitants") legend(size(small) position(5) xoffset(17.05)) fcolor(Blues) plotregion(margin(b+20)) ndfcolor(gs8) ndlabel("No data") name(g1,replace)  


