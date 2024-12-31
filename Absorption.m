% Absorption.m

function [absorption,Energy,k,sticksNorm] = Absorption(sticksFile,parameters)

% This code takes the inputed CTM4XAS sticks.xy (sticksFile) file and 
% converts it into an absorption spectrum

% parameters = [q, minL, cutOff, dL, dOc, Eoff, CTMConv]

% Author: Stephen Londo

%% Start of Code

constant = 2.302585093/(4*pi*14);

% Define parameters
q = parameters(1);                %Fano parameter
minL = parameters(2);             %Lorentzian line width for energies below cutOff
cutOff = parameters(3);           %Energy where the Lorentzian line width begins to broaden linearly
dL = parameters(4);               %Linear rate of broadening Lorentzian line width above cutOff
dOc = parameters(5);              %d-shell orbital occupancy (i.e. number of electrons in the d-shell)
Eoff = parameters(6);             %Energy offset applied to the multiplet spectrum
%CTMConv = parameters(7);          %Parameter to convert CTM4XAS units into absorption units

% Calculate the absorption spectrum from the sticks file
sticks = readSticks(sticksFile);
sticks(:,1) = sticks(:,1)+Eoff;
sticksNorm = normalizeSticks(sticks,dOc);
broadened = lorentzFano(sticksNorm,q,minL,cutOff+Eoff,dL,1,1000,0.05);
Energy = broadened(:,1);
absorption = broadened(:,2);
%absorption = broadened(:,2).*CTMConv;

lambda = 1240./Energy;
k = lambda.*absorption.*constant;

end

