
cd "E:/data/1995_2011_city/city_convergence"
use datathresh.dta,clear

gen ly90=ln(gdp90)
gen lsk=ln(invgdp)
gen lsn=ln(gnAv/100+0.05)
gen lh=ln(midStuPop)
gen lpop=ln(pop)

bys regions: sum y gdp_per

// 变量的描述性统计
estpost sum gdp_per gr_gdp gdp9 gnAv primstu90 highstu90 noAgri90 middstu90 midStuPop invgdp fdigdpAv
esttab using sum2.rtf, cells("mean(fmt(2)) sd(fmt(2)) min(fmt(1)) max(fmt(0))") nomtitle nonumber replace


local rhs1 ly90 lsk lsn lh
local rhs ly90 lsk lsn lh fdi
local rhs2 ly90 lsk lsn lh fdi deficit
local rhs3 ly90 lsk lsn lh fdi isC deficit area
local rhs4 ly90 lsk lsn lh fdi isC deficit
local rhsiv ly90 lsk lsn lh (fdi= road_av lpop total_power n_phone)
local rhsiv2 ly90 lsk lsn lh deficit (fdi= road_av lpop total_power n_phone)
local rhsiv3 ly90 lsk lsn lh deficit area (fdi= road_av lpop total_power n_phone)
local rhsiv4 ly90 lsk lsn lh deficit area isC (fdi= road_av lpop total_power n_phone)
reg y ly90 lsk lsn lh
est store allnofdi
reg y `rhs'
estimates store all_fdi

reg y `rhs' if is==0
estimates store no_capital

reg y `rhs' if is==1
estimates store capital

reg y `rhs' if region==1
estimates store East

reg y `rhs' if region==2
estimates store Central

reg y `rhs' if region==3
estimates store West

outreg2 [allnofdi all_fdi no_capital capital East Central West] using est1.doc, word replace title("表 回归结果比较")

reg y ly90 lsk lsn lh
est store m1

reg y `rhs2'
estimates store m2

reg y `rhs4'
estimates store m3

reg y `rhs3' if region==1
estimates store East

reg y `rhs3' if region==2
estimates store Central

reg y `rhs3' if region==3
estimates store West

outreg2 [m1 m2 m3 East Central West] using est2.doc, word replace title("表 回归结果比较")




// fdi is endogenous variable on log(pop), road_av,n_phone,electr
ivreg y `rhsiv'
estimates store m1
ivendog

ivreg y `rhsiv2'
estimates store m2

ivreg y `rhsiv3'
estimates store m3

ivreg y `rhsiv4' if region==1
estimates store east

ivreg y `rhsiv4' if region==2
estimates store central

ivreg y `rhsiv4' if region==3
estimates store west

//estout m1 m2 m3 m4 m5 m6, cells(b(star fmt(3)) se(par fmt(2))) ///
 //  legend label varlabels(_cons Constant)
 outreg2 [m1 m2 m3 east central west] using est.doc,word replace title("工具变量回归")

