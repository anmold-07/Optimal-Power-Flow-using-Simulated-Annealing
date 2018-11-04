clc;
clear;
close all;

%%-Problem Definition------------------------------------------------------
func.CostFunction=@(x)sph(x);                         % Cost Function                                                     
func.PVar = 4;
PSize = [1 func.PVar];                               
func.VVar = 4;
VSize =[1 func.VVar];  
func.TVar = 3;
TSize = [1 func.TVar];

func.TAPMIN=[0.9 0.9 0.9];
func.TAPMAX=[1.1 1.1 1.1];
func.PGMAX=[140 50 35 30];
func.PGMIN=[20 15 10 10];
func.VGMIN=[0.94 0.94 0.94 0.94];
func.VGMAX=[1.06 1.06 1.06 1.06];

%%-Parameter Modification--------------------------------------------------
para.MaxIt=50;                    % Maximum Number of Iterations
para.submit=1;                     % Maximum Number of Sub-iterations
para.T0=200;                       % Initial Temp.
para.alpha=0.9;                    % Temp. Reduction Rate
para.nPop=5;                       % Population Size
para.nNeigh=10;                    % Markov Chain 
para.mu = 0.01;                    % Mutation Rate
para.sigmaV = 10;                  % Mutation Range
para.sigmaP = 30;                 % Mutation Range
para.sigmaT = 1;                   % Mutation Range

%%-Calling function SAA----------------------------------------------------
out= SAA(func,para);
pop = out.pop;
BestCost = out.BestCost;

%% Results-----------------------------------------------------------------
figure;
plot(BestCost,'LineWidth',4);
xlabel('Iteration Number');
ylabel('Best Costs');
grid on;

%-----------------------------plotting the function------------------------


%--------------------------------------------------------------------------

