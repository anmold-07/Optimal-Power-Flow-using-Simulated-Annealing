function out = SAA(func,para)

%% -----------------Problem Definition------------------------------------------------------
% opff submitted to opti:

CostFunction=func.CostFunction;                       % Objective Function
PGMAX=func.PGMAX; 
PGMIN=func.PGMIN;
VGMIN=func.VGMIN;
VGMAX=func.VGMIN;
TAPMIN=func.TAPMIN;
TAPMAX=func.TAPMAX;
%XMIN=[VGMIN PGMIN TAPMIN];
%XMAX=[VGMAX PGMAX TAPMAX];

PVar=func.PVar;
VVar=func.VVar;
TVar=func.TVar;
PSize = [1 PVar];   
VSize =[1 VVar]; 
TSize = [1 TVar];

%% -------------------Parameters--------------------------------------------------------------
MaxIt=para.MaxIt;                        % Maximum Number of Iterations
submit=para.submit;                      % Maximum Sub iterations
T0=para.T0;                              % Initial Temp.
alpha=para.alpha;                        % Temp Reduction Rate
nPop=para.nPop;                          % Population Size
nNeigh=para.nNeigh;                      % Number of Neighbors per Individual
mu=para.mu;                              % Mutation Rate
sigmaV=para.sigmaV;                      % Mutation Range
sigmaP=para.sigmaP;                      % Mutation Range
sigmaT=para.sigmaT;                      % Mutation Range

%% ------------------Initialization----------------------------------------
% Empty structure for Individual
ind.Position=[];
ind.Cost=[];

% Create Population Array
pop=repmat(ind, nPop, 1);

% Best Sol Make
BestSol.Cost=inf;

% Initializing Population
for i=1:nPop
    
    % Initialize Position
    b=unifrnd(VGMIN,VGMAX,VSize);
    a=unifrnd(PGMIN,PGMAX,PSize);
    c=unifrnd(TAPMIN,TAPMAX,TSize);
    %c=unifrnd(TAPMIN,TAPMAX,TSize);
    pop(i).Position = [b a c];
    
    % Evaluation
    [pop(i).Cost,k,b]=CostFunction(pop(i).Position);  %% IDHAR CALCULATE KARO "IMPORTANT HAI BHAI"
    
    % Best Sol Update
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end
    
 end

% Hold Best Costs
BestCost=zeros(MaxIt,1);

% Intializing Temp
T=T0;

%% ---------------------------------SAA Main Loop--------------------------
for it=1:MaxIt
    
    for subit=1:submit
                                                                           %-New Solutions--
        newpop = repmat(ind,nPop,nNeigh);
        
        for i=1:nPop
            for j=1:nNeigh        
                % Create Neighbor
                  newpop(i,j).Position=Neh(pop(i).Position,mu,sigmaV,sigmaP,sigmaT,PGMIN,PGMAX,VGMIN,VGMAX,TAPMIN,TAPMAX); %%%%%
                 [newpop(i,j).Cost,k,b]=CostFunction(newpop(i,j).Position);          %%%%%
            end
        end

        newpop=newpop(:);
       
        % ------------Sort Neighbors---------
        [~, SortOrder]=sort([newpop.Cost]); %------------returning the indexes of the sorted order----------------
        n1ewpop=newpop(SortOrder);
        
        for i=1:nPop
            
            if newpop(i).Cost<=pop(i).Cost
               pop(i)=newpop(i);
                
            else
                DELTA=(newpop(i).Cost-pop(i).Cost);
                P=(exp(-DELTA/T))/(1+exp(-DELTA/T));        %--------using the glauber function---------
                
                if rand<=P
                    pop(i)=newpop(i);
                end       
            end
            
 % POP PURANEY VALEY KO PURI TARAH SEIN ACCEPT KAR LIA HAI------------------
                                                                            
            % Update Best Sol Found
            if pop(i).Cost<=BestSol.Cost
                BestSol=pop(i);
            end
        
        end     
    end
    
    % Store Best Cost Found
    BestCost(it)=BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Update Temp.
    T=alpha*T;
    
    sigmaP = 0.99*sigmaP;
    sigmaT = 0.99*sigmaT;
    sigmaV = 0.99*sigmaV;  
    
    out.b=b;
    out.k=k;
    out.newpop=newpop;
    out.BestCost=BestCost;
    out.pop=pop;
    out.BestSol=BestSol;
end