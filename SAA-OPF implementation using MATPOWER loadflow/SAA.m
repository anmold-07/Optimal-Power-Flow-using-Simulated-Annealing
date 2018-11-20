function out = SAA(func,para)

%% -----------------Problem Definition------------------------------------------------------        
mpc=loadcase('case14');
CostFunction=func.CostFunction;
PGMAX=func.Pgmax; 
PGMIN=func.Pgmin;
VGMIN=func.Vgmin;
VGMAX=func.Vgmax;

ng=length(mpc.gen(:,1))-1;
PG=unifrnd(PGMIN,PGMAX,[ng,1]);
VG=unifrnd(VGMIN,VGMAX,[ng,1]);

XMIN=func.Xmin;
XMAX=func.Xmax;

flag=0;
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
    
    pop(i).Position = [PG; VG];
    
    % Evaluation
    [pop(i).Cost] = CostFunction(pop(i).Position, mpc,flag); 
    
  % IDHAR CALCULATE KARO "IMPORTANT HAI BHAI"
  
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
    
       if it==MaxIt
    fprintf('\nMaximum no. of iterations reached\n');
    flag=1;
    F = BestSol.Position(end);
    Xoptimal = BestSol.Cost(end);
    out.F=F;
    out.Xoptimal=Xoptimal;
    end
    
    for subit=1:submit
                                                                           %-New Solutions--
        newpop = repmat(ind,nPop,nNeigh);
        
        for i=1:nPop
            for j=1:nNeigh        
                % Create Neighbor
                  newpop(i,j).Position=Neh(pop(i).Position,mpc,mu,sigmaV,sigmaP,PGMIN,PGMAX,VGMIN,VGMAX); %%%%%
                 [newpop(i,j).Cost]=CostFunction(newpop(i,j).Position, mpc,flag);          %%%%%
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
                P=(exp(-DELTA/T));        %--------using the glauber function---------
                
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
    sigmaV = 0.99*sigmaV;  

    out.flag=flag;
    out.newpop=newpop;
    out.BestCost=BestCost;
    out.pop=pop;
    out.BestSol=BestSol;

end