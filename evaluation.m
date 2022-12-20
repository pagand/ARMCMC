% showing the emprovement in number of sampling
clc;clear;
syms  k;
warning('off');
epsilon = 0.01; delta = 0.99;
Delta = [0.1, 0.5,0.9,.99];
Epsilon = [0.01, 0.03];
for j=1:size(Epsilon,2)
    epsilon = Epsilon(j);
    for i=1:size(Delta,2)
        delta = Delta(i);
        for lambda=0:0.01:1
            k0 = (1-lambda)*k;
            k1 = solve (1/(2*epsilon^2)*log(2/(lambda*(1-delta) +2*(1-lambda)*exp(-2*epsilon^2*k0)))-k,k);
            if mod(lambda*100,10)==0
                disp(lambda);
            end
            K1(lambda*100+1,i,j) = k1;
        end
    end
end

Lambda=0:0.01:1;
for j=1:size(Epsilon,2)
for i=1:size(Delta,2)
    hold on;
    plot(Lambda,K1(:,i,j));
end
end
legend('\delta=0.1,\epsilon=0.01', '\delta=0.5,\epsilon=0.01','\delta=0.9,\epsilon=0.01','\delta=.99,\epsilon=0.01',... 
'\delta=0.1,\epsilon=0.03', '\delta=0.5,\epsilon=0.03','\delta=0.9,\epsilon=0.03','\delta=.99,\epsilon=0.03');
x=1/(2*epsilon^2)*log(2/(1-delta));


figure
plot(Lambda,K1(:,3,1),'linewidth',2)
hold on
plot(Lambda,K1(:,4,1),'r--','linewidth',2)
hold on
plot(Lambda,K1(:,3,2),'k-.','linewidth',2)
hold on
plot(Lambda,K1(:,4,2),'g:','linewidth',2)
hold on
legend('\delta=0.9,\epsilon=0.01','\delta=.99,\epsilon=0.01',...
'\delta=0.9,\epsilon=0.03','\delta=.99,\epsilon=0.03');
ylabel('Minimum number of samples')
xlabel('\lambda')

