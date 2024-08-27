clc
clear
close all

%% Problem settings
[d,Hd,s,ca,ch]=TravelItineraryData;
Natt = 20;
sol_length = 2*Natt +2;
lb = ones(1,sol_length);

ub = zeros(1,sol_length);

for j = 1:Natt
    ub(j)=ub(j)+2000;
end
for j = Natt+1:2*Natt+1
    ub(j) = ub(j)+3;
end
ub(sol_length)=ub(sol_length)+15000;

prob = @SKS_TravelItinerary;     % Fitness function


%% Algorithm parameters
Np = 50; T = 100;                   % No. of population and iterations
Pc = 0.8; F = 0.85;                 % DE crossover probability & Scaling factor
w = 0.8; c1 = 1.5; c2 = 1.5;        % PSO Inertia weight, Acceleration coefficient

NRuns = 5;

bestsol = NaN(NRuns,length(lb));
bestfitness = NaN(NRuns,1);
BestFitIter = NaN(NRuns,T+1);

for i = 1:NRuns
    rng(i,'twister')                % Controlling the random number generator used by rand, randi
    [~,bestfitness(i,1),~,~,~] = TLBO(prob,lb,ub,Np,T);
    
    rng(i,'twister')                % Controlling the random number generator used by rand, randi
    [~,bestfitness(i,2),~,~,~] = DifferentialEvolution(prob,lb,ub,Np,2*T,Pc,F);
    
    
    rng(i,'twister')                % Controlling the random number generator used by rand, randi
    [~,bestfitness(i,3),~,~,~] = PSO(prob,lb,ub,Np,2*T,w,c1,c2);
    
end

Stat(:,1) = min(bestfitness);             % Determining the best fitness function value
Stat(:,2) = max(bestfitness);             % Determining the worst fitness function value
Stat(:,3) = mean(bestfitness);            % Determining the mean fitness function value
Stat(:,4) = median(bestfitness);          % Determining the median fitness function value
Stat(:,5) = std(bestfitness);             % Determining the standard deviation
