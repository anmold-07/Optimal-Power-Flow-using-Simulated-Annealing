clear all;
clc;

a=[150 600; 100 400; 50 200];

A=[510*1.1 310 78*1.2];
B=[7.2*1.1 7.85 7.97*1.2];
C=[0.00142*1.1 0.00194 0.00482*1.2];
PG=[0 0 0];
NR=0;
DR=0;
PD=550;

for i=1:3
NR = NR + B(i)./(2*C(i));
DR = DR + (1/(2*C(i)));
end

L=(PD + NR) / (DR);

for i=1:3
    PG(i)= (L-B(i))./(2*C(i));
end

for i=1:3
    
    if PG(i)<=a(i,1)
        PG(i)=a(i,1);
    end
    
    if PG(i)>=a(i,2)
        PG(i)=a(i,2);
    end
            
end

DELL=10;

while DELL>0.00000001
   
DELPG=PD-sum(PG);
DELL = DELPG/DR;
L=L+DELL;

for i=1:3
    PG(i)= (L-B(i))./(2*C(i));
end

for i=1:3
    
    if PG(i)<=a(i,1)
        PG(i)=a(i,1);
    end
    
    if PG(i)>=a(i,2)
        PG(i)=a(i,2);
    end
            
end

end
