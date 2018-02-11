function pwr = getpwr(v,i,tm,T_mach)
stepSize = tm(2) - tm(1);
cyc2 = round(2*T_mach / stepSize);  % Number of points for 2 cycles
Npts = length(tm);
ind1 = Npts - 2*cyc2;
pwr_trans = i.*v;
pwr = abs(mean(pwr_trans(ind1:Npts)));


