function y=Neh(x,mpc,mu,sigmaV,sigmaP,PGMIN,PGMAX,VGMIN,VGMAX)

mpc1=mpc;
ng=length(mpc.gen(:,1))-1;

%p=[x(1); x(2); x(3); x(4); x(5)];
%v=[x(6); x(7); x(8); x(9); x(10)];
p=x(1:ng);
v=x(ng+1:2*ng);

     V = ( rand(size(v))<=mu );
     JV = find(V==1);
     v1=v;
     v1(JV)=v(JV)+sigmaV*randn(size(JV));
     
     P = ( rand(size(p))<=mu );
     JP = find(P==1);
     p1=p;
     p1(JP)=p(JP)+sigmaP*randn(size(JP));
     
     v1=max(v1,VGMIN);
     v1=min(v1,VGMAX);
     
     p1=max(p1,PGMIN);
     p1=min(p1,PGMAX);
        
     y=[p1; v1];
                                     %----------------Restricting the Y values----------- 
end