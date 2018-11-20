clc;
clear;
close all;

%%-Problem Definition------------------------------------------------------
func.CostFunction=@(x) Himmelblau(x);         % Cost Function
func.nVar = 2;                           % Decision Variables
VarSize = [1 func.nVar];                 % Decision Variables Matrix Size
func.VarMin = -5;                        % Lower Bound of Decision Variables
func.VarMax =  5;                        % Upper Bound of Decision Variables

%%-Parameter Modification--------------------------------------------------
para.MaxIt=100;                          % Maximum Number of Iterations
para.submit=50;                          % Maximum Number of Sub-iterations
para.T0=100;                             % Initial Temp.
para.alpha=0.5;                          % Temp. Reduction Rate
para.nPop=1;                             % Population Size
para.nNeigh=100;                         % Number of Neighbors per Individual
para.mu = 0.1;                           % Mutation Rate
para.sigma = 2;                          % Mutation Range

%%-Calling function SAA----------------------------------------------------
out= SAA(func,para);
pop = out.pop;
BestCost = out.BestCost;

%% Results-----------------------------------------------------------------
figure;
semilogy(BestCost,'LineWidth',4);
xlabel('Iteration Number');
ylabel('Best Costs');
grid on;

%-----------------------------plotting the function------------------------
o=[func.VarMin:0.1:func.VarMax];
p=[func.VarMin:0.1:func.VarMax];
[oo,pp]=meshgrid(o,p);
O= size(oo,1);
P= size(pp,1);
zz = zeros(O,P);

for i=1:O
    for j=1:P
        zz(i,j) = func.CostFunction([oo(i,j),pp(i,j)]);
    end
end
figure
surf(oo,pp,zz)
hold on
plot3(pop(1).Position(1),pop(1).Position(2),BestCost(para.MaxIt),'.r','markersize',30)

%--------------------------------------------------------------------------

