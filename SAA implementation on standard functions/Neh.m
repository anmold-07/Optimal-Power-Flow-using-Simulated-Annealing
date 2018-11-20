function y=Neh(x,mu,sigma,Vmin,Vmax)
    A = ( rand(size(x))<=mu );
    J = find(A==1);
    
    y=x;
    y(J)=x(J)+sigma*randn(size(J));

    %----------------Restricting the Y values-----------
    y=max(y,Vmin);
    y=min(y,Vmax);
end