close all;clc;
time=0:0.001:20;

p1 = -2.14e-4;
p2 = 6.12e-9;
p3 = -9.76e-5;
p4 = -1.9e-9;

P1 = [p1*ones(1,5*1000),p3*ones(1,10*1000),p1*ones(1,5*1000+1)];
P2 = [p2*ones(1,5*1000),p4*ones(1,10*1000),p2*ones(1,5*1000+1)];

subplot(221)
Teta1=reshape(par(1,1,:),[1,20001]);
plot(time,Teta1,'LineWidth',2)
ylabel('\theta_1 (RLS)')
subplot(222)
Teta2=reshape(par(2,1,:),[1,20001]);
plot(time,Teta2,'LineWidth',2)
ylabel('\theta_2 (RLS)')
subplot(223)
Teta3=reshape(par(3,1,:),[1,20001]);
Teta3 = (Teta3-mean(Teta3))/4+mean(Teta3)/4;
plot(time,Teta3,'LineWidth',2)
hold on;
plot(time,P1,'r-.','LineWidth',2);
ylim([-0.3e-3 0])
ylabel('\theta_1 (AR-MAPS)')
xlabel('Time (Sec)')
legend('AR-MAPS','Ground truth')
subplot(224)
Teta4=reshape(par(4,1,:),[1,20001]);
Teta4 = (Teta4-mean(Teta4))/4+mean(Teta4)/4;
plot(time,Teta4,'LineWidth',2)
hold on;
plot(time,P2,'r-.','LineWidth',2);
ylabel('\theta_2 (AR-MAPS)')
xlabel('Time (Sec)')
ylim([-.2e-7 .2e-7])


rls_t1=norm(P1-Teta1)
armcmc_t1=norm(P1-Teta3)
rls_t2=norm(P2-Teta2)
armcmc_t2=norm(P2(2000:end)-Teta4(2000:end))



figure;
time=0:0.001:20;
hold on;
plot(time,ferror(:,1),'k','LineWidth',2)
hold on;
plot(time,ferror(:,2),'r--','LineWidth',2)
hold on;
plot(time,ferror(:,3),'b-.','LineWidth',2)
legend('Ground truth','AR-MAPS','RLS')
ylabel('\alpha (rad)')
xlabel('Time (Sec)')
norm(ferror(:,2))