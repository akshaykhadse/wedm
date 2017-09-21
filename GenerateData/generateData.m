%% Circuit Elements' Estimation Dataset Generation
% Author: Akshay Khadse
% Date: 2017/09/15

%% Matlab Initialization
clc
clear all

%% Time Parameters

samplingTime = 0.2e-6;
totalTime = 25e-6;
tStartMean = 5e-6;
tStartSD = 1e-6;
tStopMean = 20e-6;
tStopSD = 1e-6;

%% Element Parameters

rBegin = 1e-3;
rEnd = 1e5;
rNumber = 10;

lBegin = 1e-6;
lEnd = 0.1;
lNumber = 10;

eBegin = 0;
eEnd = 10;
eNumber = 10;

cBegin = 1e-10;
cEnd = 1e-3;
cNumber = 10;

vBegin = 0;
vEnd = 15;
vNumber = 10;

%% Generation

delete ceeData.csv;
header = ['r', 'l', 'c', 'e', 'data'];
dlmwrite('ceeData.csv',header,'delimiter',',','-append');

r = linspace(rBegin, rEnd, rNumber);
l = linspace(lBegin, lEnd, lNumber);
e = linspace(eBegin, eEnd, eNumber);
c = linspace(cBegin, cEnd, cNumber);
v = linspace(vBegin, vEnd, vNumber);

for iN = 1:size(r,2)
    for jN = 1:size(l,2)
        for kN = 1:size(e,2)
            for lN = 1:size(c,2)
                for mN = 1:size(v,2)
                    t1 = normrnd(tStartMean, tStartSD);
                    t2 = normrnd(tStopMean, tStopSD);
                    
                    rVal = r(iN);
                    lVal = l(jN);
                    eVal = e(kN);
                    cVal = c(lN);
                    vVal = v(mN);
                    
                    clear current voltage data
                    simOut = sim('simGenerateData.slx', 'TimeOut',120);
                    current = simOut.get('current');
                    voltage = simOut.get('voltage');
                    if (size(current, 1)==126)
                        data = [rVal, lVal, cVal, eVal, t1, t2, transpose(voltage(:,2)), transpose(current(:,2))];
                        dlmwrite('ceeData.csv',data,'delimiter',',','-append');
                    end
                end
            end
        end
    end
end
fprintf('Completed!\n')

%% End