function [y_un, y, u]= data_generator(n,sigma2,b2)
% ----------------- Prerequsite parameter setting -------------------------

a1 = 0;           % Model parameter for generating Output Data
a2 = 0;

b1 = 2;            % Model parameter for generating Output Data
b3 = 1.7;



k_p=b1;
b_p=b2;
n_p=b3;


c0 = 1;
c1 = 0;

% ---------------------- I/O Data Generation --------------------------

dummy = 2*rand(n,1);   % Generating input data
dly_inp = 3;
dly_inp = 2;
u = zeros(n,1);
v = zeros(n,1);
for i1 = 1:dly_inp
    u(:,i1) = [zeros(i1,1);dummy(1:end-i1)];
end

u=2*rand(n,2);


dly_v = 0;
dummy = normrnd(0,sigma2,n,1);  % various type of noise can be added in this section
for i1 = 0:dly_v
    v(:,i1+1) = [zeros(i1,1);dummy(1:end-i1)];
end

% y_un = u * [b1; b2; b3];
% y = u * [b1; b2; b3] + v * c0;
y_un = u(:,1).^n_p.*(k_p*ones(n,1)+b_p*u(:,2));
y = y_un+ v * c0;
end
        
        
        
        