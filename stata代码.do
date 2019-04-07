drop in 1
 rename var1 time
. rename var2 shen
. rename var3 shi
rename var4 xian
. rename var5 area
. rename var6 xiang
. rename var7 zheng
. rename var8 hu
. rename var9 GDP
. rename var10 first 
. rename var11 secend
. rename var12 shouru
. rename var13 shuishou
. rename var14 output
. rename var15 chuxu
. rename var16 xindai
. rename var17 gongyeshu
. rename var18 gongyeGDP
rename var19 zctz
rename var20 treated
rename var34 id
. rename var41 east
. rename var42 middle
. rename var43 west

destring east ,replace
replace east =0 if east ==.
destring middle ,replace
replace middle =0 if middle ==.
destring west ,replace
replace west =0 if west ==.

destring time shen shi xian area xiang zheng hu GDP first secend shouru shuishou output chuxu xindai gongyeshu gongyeGDP zctz,replace
gen t=(time>=2015)
gen t1=(time>=2016)
gen t2=(time>=2017)
gen did=t*treated
gen did1=t1*treated
gen did2=t2*treated
drop ln_zctz ln_xindai ln_GDP ln_first ln_secend ln_shouru ln_shuishou ln_output ln_chuxu ln_gongyeGDP
gen ln_zctz=ln(zctz)
gen ln_xindai=ln(xindai)
gen ln_GDP=ln(GDP)
gen ln_first=ln(first)
gen ln_secend=ln(secend)
gen ln_shouru=ln(shouru)
gen ln_shuishou=ln(shuishou)
gen ln_output=ln(output)
gen ln_chuxu=ln(chuxu)
gen ln_gongyeGDP=ln(gongyeGDP)
gen region_east=treated*east
gen region_middle=treated*middle
gen region_west=treated*west
gen t2014=0 if time<2014
replace t2014=1 if t2014==. 
gen t2013=0 if time<2013
replace t2013=1 if t2013==. 
gen treat_t2013=treated*t2013
gen treat_t2014=treated*t2014
gen lzctz=ln_zctz[_n-1]
gen lxindai=ln_xindai[_n-1]
gen loutput=ln_output[_n-1]

xtset id time
xtdes
sum ln_zctz ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu 
reg ln_zctz did treated t ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu ,vce(cluster id) 
xtreg ln_zctz did treated t,fe
estimates store FE
xtreg ln_zctz did treated t,re
estimates store RE
hausman FE RE,constant sigmamore

xtreg ln_zctz did treated t ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu,fe
estimates store FE
xtreg ln_zctz did treated t ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu ,re
estimates store RE
hausman FE RE,constant sigmamore
reg ln_zctz did treated t ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu ,vce(cluster id)
reg ln_zctz did treated t ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu i.time,vce(cluster id)
reg ln_zctz treat_t2013 treat_t2014 ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu i.time,vce(cluster id)
ivreg2 ln_zctz lzctz ln_GDP ln_first ln_secend ln_output ln_xindai ln_shouru ln_chuxu 

xtreg ln_xindai did treated t ln_GDP ln_first ln_secend   ln_chuxu,fe
estimates store FE
xtreg ln_xindai did treated t ln_GDP ln_first ln_secend ln_chuxu,re
estimates store RE
hausman FE RE,constant sigmamore
reg ln_xindai did treated t ln_GDP ln_first ln_secend ln_chuxu,vce(cluster id)
reg ln_xindai did treated t ln_GDP ln_first ln_secend ln_chuxu i.time,vce(cluster id)
reg ln_xindai  treat_t2013 treat_t2014 ln_GDP ln_first ln_secend ln_chuxu i.time,vce(cluster id)

xtreg ln_output did treated t ln_GDP ln_first ln_secend   ln_shouru,fe
estimates store FE
xtreg ln_output did treated t ln_GDP ln_first ln_secend ln_shouru,re
estimates store RE
hausman FE RE,constant sigmamore
reg ln_output did treated t ln_GDP ln_first ln_secend ln_shouru,vce(cluster id)
reg ln_output did treated t ln_GDP ln_first ln_secend ln_shouru i.time,vce(cluster id)