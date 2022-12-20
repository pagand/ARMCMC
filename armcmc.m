function [teta,nac] = online_enhanced_mcmc(n,y,u,SampNum,TETA_old)

nac=0;
count = 0;
ParNum = 3;
sigma2_RW = .001;
sigma2 = .5;   
% preallcoation for speed
epsi=zeros(ParNum, 1);
ye1=zeros(ParNum,1);
flag=0; %noninformative prior
inint_ths=100;
init_low=0.1;
init_high=5;
SampMin=2000;
AccMin=0.3;
npdf=1/sqrt(2*pi*sigma2^2);

ye1_candid = zeros(1,n);



  %--------------------- Initializing -----------------------------------
dummy=0;
teta=[TETA_old(:,2:end), (mean(TETA_old'))'];
for i2 = 1:n
    %ye1(i2) = u(i2,:) * teta(:,end) ;
    ye1(i2) = teta(3,end)*log10(u(i2,1))+log10(teta(1,end)+teta(2,end)*u(i2,2)) ;
    dummy=log10(npdf*exp(-(y(i2) - 10^ye1(i2))^2/sigma2^2))+dummy;
    %dummy = log10(normpdf(y(i2) - ye1(i2), 0, sigma2)) + dummy;
end

if dummy>-inint_ths
    prob_teta = dummy;
    flag=1;
end

dummy = inf;
while (isinf(dummy)) && (flag==0)
    teta(:,1) = unifrnd(init_low,init_high,[ParNum,1]);
    teta(3,1) = unifrnd(1,2);
    dummy = 0; % Computing Probability of Previous Sample Parameter
            
    ye1(1:n) = 0; 
            
    for i2 = 1:n

%            ye1(i2) = u(i2,:) * teta(:,1);
           ye1(i2) = teta(3,1)*log10(u(i2,1))+log10(teta(1,1)+teta(2,1)*u(i2,2)) ;
                    % -------- Computing first step of MCMC accordance to noise type ------
           %dummy = log10(normpdf(y(i2) - ye1(i2), 0, sigma2)) + dummy ;
           dummy=log10(npdf*exp(-(y(i2) - 10^ye1(i2))^2/sigma2^2))+dummy;

           if isinf(dummy)
                 break;
           end

    end

    prob_teta = dummy; 
%     count = count + 1
end

if flag==0
for  k = 1:SampNum
      
        %-------------------- Introducing Candidate ---------------------------
                     
               epsi = teta(:,k) +sqrt(sigma2_RW)*randn([size(teta,1),1]);
                      
        %-------------------- Evaluating Acceptance ---------------------------
          % Prior Knowledg
        if ( epsi(1)>5 ) ||( epsi(1)<0 ) || (epsi(2)> 5) ||(epsi(2)< 0) ||  ( epsi(3) > 2)||(epsi(3)< 1) 
            prob_epsi = -inf;
        else

            ye1_candid(1:n) = 0;
            dummy = 0; % Computing Probability of Epsilon Parameter
            for i2 = 1:n
                % ---- Computing candidate probability accordance to noise distribution ----

%                 ye1_candid(i2) =  u(i2,:) * epsi(:);
                ye1_candid(i2) = epsi(3)*log10(u(i2,1))+log10(epsi(1)+epsi(2)*u(i2,2)) ;

                %dummy = log10(normpdf(y(i2) - ye1_candid(i2), 0,sigma2)) + dummy;
                dummy=log10(npdf*exp(-(y(i2) - 10^ye1_candid(i2))^2/sigma2^2))+dummy;

            end

            prob_epsi = dummy;

        end

        alpha = min(1,10^(prob_epsi-prob_teta));
        z = rand(1,1);
        
            if (z < alpha)
                teta(:,k+1) = epsi;
                prob_teta = prob_epsi;
                nac=nac+1;
            else
                teta(:,k+1) = teta(:,k);
            end
            
            if (k>2*SampMin && nac<0.5*k*AccMin)
                break;
            end
            if (k==floor(1.5*SampMin) && nac <0.5*k*AccMin)
                sigma2_RW=0.2*sigma2_RW;
            end
            if (k==2*SampMin && nac <0.8*k*AccMin)
                sigma2_RW=0.2*sigma2_RW;
            end
end
end
    
    
    
if flag==1
    sigma2_RW=0.01*sigma2_RW;
 for  k = 1:SampNum
      
        %-------------------- Introducing Candidate ---------------------------
%                          epsi(:,k) = teta(:,k) + normrnd(0,sqrt(sigma2_RW),[size(teta,1),1]);
                            epsi= teta(:,ceil(rand*ParNum))+sqrt(sigma2_RW)*randn([size(teta,1),1]); 
                            

        %-------------------- Evaluating Acceptance ---------------------------

        % Prior Knowledg
        if ( epsi(1)>5 ) ||( epsi(1)<0 ) || (epsi(2)> 5) ||(epsi(2)< 0) ||  ( epsi(3) > 2)||(epsi(3)< 1) 
            prob_epsi = -inf;
        else

            ye1_candid(1:n) = 0;
            dummy = 0; % Computing Probability of Epsilon Parameter
            for i2 = 1:n
                % ---- Computing candidate probability accordance to noise distribution ----

%                 ye1_candid(i2) =  u(i2,:) * epsi(:);
                ye1_candid(i2) = epsi(3)*log10(u(i2,1))+log10(epsi(1)+epsi(2)*u(i2,2)) ;
                

                %dummy = log10(normpdf(y(i2) - ye1_candid(i2), 0,sigma2)) + dummy;
                dummy=log10(npdf*exp(-(y(i2) - 10^ye1_candid(i2))^2/sigma2^2))+dummy;

            end

            prob_epsi = dummy;

        end
        alpha = min(1,10^(prob_epsi-prob_teta));
        z = rand(1,1);
        
            if (z < alpha)
                teta = [teta(:,2:end), epsi];
                prob_teta = prob_epsi;
                nac=nac+1;
            else
                teta = [teta(:,2:end), teta(:,end)];
            end
            
            if (k>SampMin && nac <k*AccMin)
                break;
            end
            if (k==floor(0.75*SampMin) && nac <0.5*k*AccMin)
                sigma2_RW=0.1*sigma2_RW;
            end
            if (k==0.5*SampMin && nac <0.5*k*AccMin)
                sigma2_RW=0.1*sigma2_RW;
            end
      
 end
end
nac=nac/k;
% k
% flag

end
        