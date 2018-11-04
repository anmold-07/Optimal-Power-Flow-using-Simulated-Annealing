function [z,l,b] =sph(x)
%% X-control variables matrix (EK VECTOR HAI FOR ALL VARIABLES);

nbus=14;
lined = Ldata(nbus); 
busd = Bdata(nbus);

%VGMIN=[0.94; 0.94; 0.94; 0.94; 0.94; 0.94; 0.94; 0.94; 0.94; 0.94; 0.94; 0.94; 0.94];
%VGMAX=[1.06; 1.06; 1.06; 1.06; 1.06; 1.06; 1.06; 1.06; 1.06; 1.06; 1.06; 1.06; 1.06];
lined(8,6)=x(9);
lined(9,6)=x(10);
lined(10,6)=x(11);

busd(2,3)=x(1);
busd(2,5)=x(5);
busd(3,3)=x(2);
busd(3,5)=x(6);
busd(6,3)=x(3);
busd(6,5)=x(7);
busd(8,3)=x(4);
busd(8,5)=x(8);
%% Getting 2n data from the line and bus datas.......................

Y = Ybus(nbus);             % Y-Bus                         
BMva = 100;                 % Base
bus = busd(:,1);            % Bus No.
type = busd(:,2);           % Type of Bus 1-Slack, 2-PV, 3-PQ
V = busd(:,3);              % Specified Voltage
del = busd(:,4);            % Voltage Angle
Pg = busd(:,5)/BMva;        % PGi-gen
Qg = busd(:,6)/BMva;        % QGi-gen
Pl = busd(:,7)/BMva;        % PLi-load
Ql = busd(:,8)/BMva;        % QLi-load
Qmin = busd(:,9)/BMva;      % Min Rxn Power Limit
Qmax = busd(:,10)/BMva;     % Max Rxn Power Limit
P = Pg - Pl;                % Injected power 
Q = Qg - Ql;                % injected reactive power 
Psp = P;                    % P 
Qsp = Q;                    % Q
G = real(Y);                          % Conductance matrix
B = imag(Y);                          % Susceptance matrix

pv = find(type == 2 | type == 1);     % PV Buses
pq = find(type == 3);                 % PQ Buses
npv = length(pv);                     % No. of PV buses
npq = length(pq);                     % No. of PQ buses

%% solving the 2n equations and 2n unknowns.....

Tol = 1;  
Iter = 1;

while (Tol > 1e-5)                                      % Start Iteration
    
    P = zeros(nbus,1);
    Q = zeros(nbus,1);
                                                        % Calculate P and Q
    for i = 1:nbus
        for k = 1:nbus
            P(i) = P(i) + V(i)* V(k)*(G(i,k)*cos(del(i)-del(k)) + B(i,k)*sin(del(i)-del(k)));
            Q(i) = Q(i) + V(i)* V(k)*(G(i,k)*sin(del(i)-del(k)) - B(i,k)*cos(del(i)-del(k)));    %%% solving the 2n equations in total
        end
    end
                                              % Checking Q-limit violations
    if Iter <=10  && Iter >= 2
        for n = 2:nbus
            if type(n) == 2                                        % PV-BUS
                QG = Q(n)+Ql(n);              % NET REACTIVE POWER INJECTED
                if QG < Qmin(n)
                    V(n) = V(n) + 0.1;
                elseif QG > Qmax(n)
                    V(n) = V(n) - 0.1;
                end
            end
         end
    end
                             % Calculate change from specified value
    dPa = Psp-P;             % CHANGE 
    dQa = Qsp-Q;
    k = 1;
    dQ = zeros(npq,1);
    
    for i = 1:nbus
        if type(i) == 3
            dQ(k,1) = dQa(i);
            k = k+1;
        end
    end
    
    dP = dPa(2:nbus);
    M = [dP; dQ];                                         % Mismatch Vector
    
   
    % Jacobian1 - Derivative of Real Power Injections with THETA
    
    J1 = zeros(nbus-1,nbus-1);
    for i = 1:(nbus-1)
        m = i+1;
        for k = 1:(nbus-1)
            n = k+1;
            if n == m
                for n = 1:nbus
                    J1(i,k) = J1(i,k) + V(m)* V(n)*(-G(m,n)*sin(del(m)-del(n)) + B(m,n)*cos(del(m)-del(n)));
                end
                J1(i,k) = J1(i,k) - V(m)^2*B(m,m);
            else
                J1(i,k) = V(m)* V(n)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
            end
        end
    end
    
    % Jacobian2 - Derivative of Real Power Injections with V
    
    J2 = zeros(nbus-1,npq);
    for i = 1:(nbus-1)
        m = i+1;
        for k = 1:npq
            n = pq(k);
            if n == m
                for n = 1:nbus
                    J2(i,k) = J2(i,k) + V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                J2(i,k) = J2(i,k) + V(m)*G(m,m);
            else
                J2(i,k) = V(m)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
            end
        end
    end
    
    % Jacobian3 - Derivative of Reactive Power Injections with THETA
    
    J3 = zeros(npq,nbus-1);
    for i = 1:npq
        m = pq(i);
        for k = 1:(nbus-1)
            n = k+1;
            if n == m
                for n = 1:nbus
                    J3(i,k) = J3(i,k) + V(m)* V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                J3(i,k) = J3(i,k) - V(m)^2*G(m,m);
            else
                J3(i,k) = V(m)* V(n)*(-G(m,n)*cos(del(m)-del(n)) - B(m,n)*sin(del(m)-del(n)));
            end
        end
    end
    
    % Jacobian4 - Derivative of Reactive Power Injections with V
    
    J4 = zeros(npq,npq);
    for i = 1:npq
        m = pq(i);
        for k = 1:npq
            n = pq(k);
            if n == m
                for n = 1:nbus
                    J4(i,k) = J4(i,k) + V(n)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
                end
                J4(i,k) = J4(i,k) - V(m)*B(m,m);
            else
                J4(i,k) = V(m)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
            end
        end
    end
    
    J = [J1 J2; J3 J4];                     % Jacobian Matrix
    X = inv(J)*M;                          
    dTh = X(1:nbus-1);                      % Change in Voltage Angle
    dV = X(nbus:end);                       % Change in Voltage Magnitude
                                         
    del(2:nbus) = dTh + del(2:nbus);        % Voltage Angle
    k = 1;
    for i = 2:nbus
        if type(i) == 3
            V(i) = dV(k) + V(i);            % LOAD BUS VOLTAGE CHANGING SO SET IT
            k = k+1;
        end
    end
    
   %V(i)=max(V(i),VGMIN);
   %V(i)=min(V(i),VGMAX);
    
    
    Iter = Iter + 1;
    Tol = max(abs(M));                      % Tolerance
end
%%
[Pi Qi Pg Qg Pl Ql]=print(lined,nbus,V,del,BMva);     

b=busd;
l=lined;
z = (sum(Pg)-sum(Pl)) ;
  
end

    