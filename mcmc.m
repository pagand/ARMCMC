clc; clear; close all;

% ----------------- Prerequsite parameter setting -------------------------

a1 = 0;           % Model parameter for generating Output Data
a2 = 0;

b1 = 2.3;            % Model parameter for generating Output Data
b2 = -4.5;
b3 = 1.6;

c0 = 1;
c1 = 0;

n = 20;            % Whole number of data
y_init = 0;
sampNum = 7000;     % Number of data in Markov chain
num_chain = 5;
sigma2 = .1;        % -sigma2 and sigm2 are two parameter of uniform Noise
deg = 3;           % Degree of freedom for chi-square and noncentral chi-square noise
dlt = 2;           % Parameter of delta for noncentral chi-square noise 
sigma2_RW = .05;      % Variance of prior knowledge distribution
%t = (0:n)';        % time of data

% ---------------------- I/O Data Generation --------------------------

dummy = rand(n,1);   % Generating input data
dly_inp = 3;
for i1 = 1:dly_inp
    u(:,i1) = [zeros(i1,1);dummy(1:end-i1)];
end
dly_v = 0;
dummy = normrnd(0,sigma2,n,1);  % various type of noise can be added in this section
for i1 = 0:dly_v
    v(:,i1+1) = [zeros(i1,1);dummy(1:end-i1)];
end

y_un = u * [b1; b2; b3];
y = u * [b1; b2; b3] + v * c0;
plot(y_un); hold on;
plot(y_un,'r');

%%


n_a = 0; n_b = 3; n_c = 0;
count = 0;
for kk=1:num_chain
    count = 0;
    for  k = 1:sampNum
        %--------------------- Initializing -----------------------------------
        dummy = inf;
        while (isinf(dummy)) && (k == 1)

            teta(:,k) = unifrnd(-6,6,[n_a + n_b + n_c,1]);

            dummy = 0; % Computing Probability of Previous Sample Parameter
            ye1(1:n,1) = 0; 
            for i2 = 1:n

                ye1(i2,k) = u(i2,:) * teta(:,k);
%                 ( teta(5,k) - teta(1,k))*y(i2-1,1) + (-teta(2,k))*y(i2-2,1) + ...  % Computing estimated output
%                     teta(3,k)*u(i2,1) + teta(4,k)*u(i2,2) - teta(5,k)*ye1(i2-1,k);                   

                % -------- Computing first step of MCMC accordance to noise type ------

                dummy = log10(normpdf(y(i2) - ye1(i2,k), 0, sigma2)) + dummy ;

                if ( teta(2,k) > 100 ) || ( abs(teta(1,k)) > 100 ) % Prior Knowledge

                    dummy = -inf ;
                    prob_epsi = 0;

                end

                if isinf(dummy)

                    break;
                end


            end

            prob_teta = dummy; 
            count = count + 1

        end


        %-------------------- Introducing Candidate ---------------------------

        epsi(:,k) = teta(:,k) + normrnd(0,sqrt(sigma2_RW),[size(teta,1),1]);

        %-------------------- Evaluating Acceptance ---------------------------



        if ( epsi(2,k) > 100 ) || ( abs(epsi(1,k)) > 100 ) % Prior Knowledge

            prob_epsi = 0;

        else

            ye1_candid(1:n,1) = 0;
            dummy = 0; % Computing Probability of Epsilon Parameter
            for i2 = 1:n

                % ---- Computing candidate probability accordance to noise distribution ----

                ye1_candid(i2,1) =  u(i2,:) * epsi(:,k);

                dummy = log10(normpdf(y(i2,1) - ye1_candid(i2,1), 0,sigma2)) + dummy;

                if (dummy == 0)

                    break;

                end

            end

            prob_epsi = dummy;

        end


        alpha = min(1,10^(prob_epsi-prob_teta));
        z = rand(1,1);

        if (z < alpha)

           teta(:,k+1) = epsi(:,k);
           prob_teta = prob_epsi;
           ye1(:,k+1) = ye1_candid;

        else

           teta(:,k+1) = teta(:,k);
           ye1(:,k+1) = ye1(:,k);

        end
    end
    TETA(:,:,kk)=teta;
    teta = [];
end
    







%% -------------------------- Plotting ------------------------------------

n_brn = floor(0.5*length(TETA));
DUMMY = [];
for i1 = 1:size(TETA,3)
    dummy = TETA(:,:,i1);
    dummy(:,1:n_brn)=[];
    DUMMY=[DUMMY,dummy];
end
figure
plot(DUMMY','linewidth',2);
title('Time Series Plots','fontsize',13);
xlabel('Sample Number','fontsize',10);

% -------------------------- Hist ----------------------------------------

figure
subplot(3,1,1); 
hist(DUMMY(1,:),30);

subplot(3,1,2); 
hist(DUMMY(2,:),30);


subplot(3,1,3);
hist(DUMMY(3,:),30);





        
        
        
        
        
        
        
        