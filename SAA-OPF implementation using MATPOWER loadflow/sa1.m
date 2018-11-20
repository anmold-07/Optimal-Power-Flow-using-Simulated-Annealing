clc;
clear;
close all;

%%-Problem Definition------------------------------------------------------
mpc=loadcase('case14');

func.CostFunction=@(X, mpc,flag)sph(X,mpc,flag);  
ng=length(mpc.gen(:,1))-1;

func.Pgmin=mpc.gen(2:end,10);
func.Pgmax=mpc.gen(2:end,9);
func.Vgmin= (ones([ng,1]))*0.94;
func.Vgmax= (ones([ng,1]))*1.06;

func.Xmin=[func.Pgmin;func.Vgmin];
func.Xmax=[func.Pgmax;func.Vgmax];

%%-Parameter Modification--------------------------------------------------
para.MaxIt=500;                    % Maximum Number of Iterations
para.submit=1;                     % Maximum Number of Sub-iterations
para.T0=100;                       % Initial Temp.
para.alpha=0.5;                    % Temp. Reduction Rate
para.nPop=1;                      % Population Size
para.nNeigh=30;                     % Markov Chain 
para.mu = 0.99;                     % Mutation Rate
para.sigmaV = 0.1;               % Mutation Range
para.sigmaP = 15;                  % Mutation Range

%%-Calling function SAA----------------------------------------------------
out= SAA(func,para);
pop = out.pop;

BestCost = out.BestCost;
F=out.F;
Xoptimal=out.Xoptimal;
flag=out.flag;
%% Results-----------------------------------------------------------------
figure;
plot(BestCost,'LineWidth',4);
xlabel('Iteration Number');
ylabel('Best Costs');
grid on;
