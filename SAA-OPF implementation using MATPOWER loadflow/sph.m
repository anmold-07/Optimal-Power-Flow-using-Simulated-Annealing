function [F] = sph(X, mpc, flag)
%% X-control variables matrix (EK VECTOR HAI FOR ALL VARIABLES);

mpc1=mpc;
Sbase=mpc.baseMVA;
nb=length(mpc.bus(:,1));
ng=length(mpc.gen(:,1))-1;

%%Modification of the MATPOWER case struct with solution vector
mpc1.gen(2:end,2)=X(1:ng);
mpc1.gen(2:end,6)=X(ng+1:2*ng);

%% Power flow
opt=mpoption('VERBOSE',0,'OUT_ALL',0,'OUT_SYS_SUM',0,'OUT_BUS',0,'OUT_BRANCH',0);

[res]=runpf(mpc1,opt);     % Power Flow Structure
pg=res.gen(:,2);           % All the bus voltages
pd=res.bus(:,3);
Pgslack=pg(1);             % Slack Bus power 
V=res.bus(:,8);            % All the bus voltages
Qgen=res.gen(:,3);

%% Cost Function
cost=sum(pg)-sum(pd);

%% PENALTY FACTORS
P1=555500000;
P2=10000000;
P3=5000;

%% Penalty function for slack bus power violation

Pgslackmin=mpc1.gen(1,10);
Pgslackmax=mpc1.gen(1,9);

if Pgslack>Pgslackmax
        penalty_slack=P1*(((Pgslack-Pgslackmax)/Sbase)^2);
    elseif Pgslack<Pgslackmin
        penalty_slack=P1*(((Pgslackmin-Pgslack)/Sbase)^2);
    else
        penalty_slack=0;
end

%% Penalty function for bus voltage violation

Vmax=mpc1.bus(:,12);
Vmin=mpc1.bus(:,13);
   for i=1:nb
     if res.bus(i,2)==1
       if V(i)>Vmax(i)
            penalty_V(i)=P2*(V(i)-Vmax(i))^2;
        elseif V(i)<Vmin(i)
            penalty_V(i)=P2*(Vmin(i)-V(i))^2;
        else
            penalty_V(i)=0;
       end
    end
   end
   penalty_V=sum(penalty_V);
   
   
%% Penalty function for reactive power generation violation

Qmax=mpc1.gen(:,4);
Qmin=mpc1.gen(:,5);
   for i=1:ng
        if Qgen(i)>Qmax(i)
            penalty_Qgen(i)=P3*(((Qgen(i)-Qmax(i))/Sbase)^2);
        elseif Qgen(i)<Qmin(i)
            penalty_Qgen(i)=P3*(((Qmin(i)-Qgen(i))/Sbase)^2);
        else
            penalty_Qgen(i)=0;
        end
   end
   penalty_Qgen=sum(penalty_Qgen);

%% CUMULATIVE PENALTY FUNTION
penalty=penalty_slack+penalty_V+penalty_Qgen;

%% TOTAL AUGMENTED OBJECTIVE FUNCTION
F = cost + penalty;

%% Optional Printing of objectives
if flag==1
    res1=runpf(mpc1);
    fprintf('\n\n****************************************************************\n\n');
    fprintf('\nMinimum loss = %8.2f \n\n\n',cost);
end

end

    