function out = SAA(func,para)

%% -----------------Problem Definition------------------------------------------------------

CostFunction=func.CostFunction;          % Objective Function
nVar = func.nVar;                        % Variables 
VarSize = [1 nVar];                      % Variable Mat Size
VarMin = func.VarMin;                    % Lower Bound 
VarMax = func.VarMax;                    % Upper Bound 

%% -------------------Parameters--------------------------------------------------------------
MaxIt=para.MaxIt;                        % Maximum Number of Iterations
submit=para.submit;                      % Maximum Sub iterations
T0=para.T0;                              % Initial Temp.
alpha=para.alpha;                        % Temp Reduction Rate
nPop=para.nPop;                          % Population Size
nNeigh=para.nNeigh;                      % Number of Neighbors per Individual
mu=para.mu;                              % Mutation Rate
sigma=para.sigma;                        % Mutation Range

%% ------------------Initialization----------------------------------------------------------

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
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    
    % Evaluation
    pop(i).Cost=CostFunction(pop(i).Position);
    
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
        %------New Solutions-----
        newpop = repmat(ind,nPop,nNeigh);
        
        for i=1:nPop
            for j=1:nNeigh
                
                % Create Neighbor
                newpop(i,j).Position=Neh(pop(i).Position,mu,sigma,VarMin,VarMax);
                newpop(i,j).Cost=CostFunction(newpop(i,j).Position);
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
    
    sigma = 0.99*sigma;

    out.BestCost=BestCost;
    out.pop=pop;
    out.BestSol=BestSol;
    
end