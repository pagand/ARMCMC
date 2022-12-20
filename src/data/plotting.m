clc;
Teta1=reshape(TETA(1,:,:),[1501,201]);
view(3)
X= (2.61:0.02:4.6);
X= repmat(X,50,1);
Xb=X;
F=zeros(50,100);
Fb=F;

for t = 1:50
    a= Teta1(:,t*4);
    [f,xi]=ksdensity(a','Kernel','epanechnikov');
    if a==0
        f=zeros(1,100);
        xi = 2.61:0.02:4.6;
    else
        [f,xi]=ksdensity(a');
        f=f/max(f);
    end
    hold on;
    time = t/2*ones(size(f));
    plot3(time,xi,f)
    axis([0 20 3 5 0 1])
    X(t,:)=xi;
    F(t,:)=f;
    Time(t,:) =time;
end
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14)
xlabel('Time (Sec)') 
ylabel('\theta_1') 
zlabel('p(\theta_1)') 
grid



Fb(1,1)=0.01; % to render
figure(2);
subplot(311)
contourf(Time,Xb,Fb); hold on;
contourf(Time,X,F,'LineColor','none');
ylabel('p(\theta_1)') 
hold on;
colorbar()