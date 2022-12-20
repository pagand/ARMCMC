clc; clear; close all;

n = 20;            % Whole number of data
y_init = 0;
SampNum = 3000;     % Number of data in Markov chain
num_chain = 5;
deg = 3;           % Degree of freedom for chi-square and noncentral chi-square noise
dlt = 2;           % Parameter of delta for noncentral chi-square noise
sigma2 = .5;   

% ---------------------- I/O Data Generation --------------------------
b2 = 3;
[y_un, y, u]= data_generator(n,sigma2,b2);

% ksdensity(TETA_old(1,:),dummy,'function','icdf')
teta_old=[2.1 ;3.2 ;1.7]*ones(1,SampNum);
% teta_old=ones(3,SampNum);
[TETA,nac]=online_enhanced_mcmc(n,y,u,SampNum,teta_old);
n_brn = floor(0.4*length(TETA));
DUMMY = [];
nac
for i1 = 1:size(TETA,3)
    dummy = TETA(:,:,i1);
    dummy(:,1:n_brn)=[];
    DUMMY=[DUMMY,dummy];
end

b2 =0.5;
[y_un, y, u]= data_generator(n,sigma2,b2);
% profile on;
[TETA2,nac]=online_enhanced_mcmc(n,y,u,SampNum,DUMMY);
% profile viewer;
nac
n_brn = floor(0*length(TETA2));
DUMMY2 = [];
for i1 = 1:size(TETA2,3)
    dummy = TETA2(:,:,i1);
    dummy(:,1:n_brn)=[];
    DUMMY2=[DUMMY2,dummy];
end
b2 = 0.5;
[y_un, y, u]= data_generator(n,sigma2,b2);
[TETA3,nac]=online_enhanced_mcmc(n,y,u,SampNum,DUMMY2);
nac
n_brn = floor(0*length(TETA3));
DUMMY3 = [];
for i1 = 1:size(TETA3,3)
    dummy = TETA3(:,:,i1);
    dummy(:,1:n_brn)=[];
    DUMMY3=[DUMMY3,dummy];
end


mean1=sum(DUMMY')/size(DUMMY,2)
mean2=sum(DUMMY2')/size(DUMMY2,2)
mean3=sum(DUMMY3')/size(DUMMY3,2)
mod1=mode(DUMMY')
mod2=mode(DUMMY2')
mod3=mode(DUMMY3')
%% -------------------------- Plotting ------------------------------------
plot(y_un); hold on;
plot(y,'r');


figure
plot(DUMMY','linewidth',2);
title('Time Series Plots','fontsize',13);
xlabel('Sample Number','fontsize',10);



% -------------------------- Hist ----------------------------------------

figure
subplot(3,1,1); 
% hist(DUMMY(1,:),10);
ksdensity(DUMMY(1,:))

subplot(3,1,2); 
% hist(DUMMY(2,:),10);
ksdensity(DUMMY(2,:))

subplot(3,1,3);
% hist(DUMMY(3,:),10);
ksdensity(DUMMY(3,:))



figure
plot(DUMMY2','linewidth',2);
title('Time Series Plots','fontsize',13);
xlabel('Sample Number','fontsize',10);

figure
subplot(3,1,1); 
% hist(DUMMY2(1,:),10);
ksdensity(DUMMY2(1,:),'npoints',5)

subplot(3,1,2); 
% hist(DUMMY2(2,:),10);
ksdensity(DUMMY2(2,:))

subplot(3,1,3);
% hist(DUMMY2(3,:),10);
ksdensity(DUMMY2(3,:))


figure
plot(DUMMY3','linewidth',2);
title('Time Series Plots','fontsize',13);
xlabel('Sample Number','fontsize',10);

figure
subplot(3,1,1); 
% hist(DUMMY3(1,:),10);
ksdensity(DUMMY3(1,:))

subplot(3,1,2); 
% hist(DUMMY3(2,:),10);
ksdensity(DUMMY3(2,:))

subplot(3,1,3);
% hist(DUMMY3(3,:));
ksdensity(DUMMY3(3,:))
hold on;






        
        
        
        
        
        
        
        