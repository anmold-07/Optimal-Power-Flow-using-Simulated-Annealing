function y=Neh(x,mu,sigmaV,sigmaP,sigmaT,PGMIN,PGMAX,VGMIN,VGMAX,TAPMIN,TAPMAX)

v=[x(1) x(2) x(3) x(4)];
p=[x(5) x(6) x(7) x(8)];
t=[x(9) x(10) x(11)];


     V = ( rand(size(v))<=mu );
     JV = find(V==1);
     v1=v;
     v1(JV)=v(JV)+sigmaV*randn(size(JV));
     
     P = ( rand(size(p))<=mu );
     JP = find(P==1);
     p1=p;
     p1(JP)=v(JP)+sigmaP*randn(size(JP));
     
     T = ( rand(size(t))<=mu );
     JT = find(T==1);
     t1=t;
     t1(JT)=v(JT)+sigmaT*randn(size(JT));
     
     v1=max(v1,VGMIN);
     v1=min(v1,VGMAX);
     
     p1=max(p1,PGMIN);
     p1=min(p1,PGMAX);
     
     t1=max(t1,TAPMIN);
     t1=min(t1,TAPMAX);
      
     y=[v1 p1 t1];
                                        %----------------Restricting the Y values----------- 
end