close all;time=0:0.1:20;
subplot(311);
plot(time,(flag>1)*4,':k','LineWidth',2)
time=0:0.001:20;
Teta1=reshape(par(4,:,:),[20001,1]);
hold on;plot(time,Teta1,'b','LineWidth',2);
Teta1e=reshape(par(1,:,:),[20001,1]);
hold on;plot(time,Teta1e,'r','LineWidth',2);
legend('Ground truth','ARMCMC','RLS')
ylabel('\theta_1')

subplot(312);
time=0:0.1:20;
plot(time,(flag>1)*2.3,':k','LineWidth',2)
time=0:0.001:20;
Teta2=reshape(par(5,:,:),[20001,1]);
hold on;plot(time,Teta2,'b','LineWidth',2);
Teta2e=reshape(par(2,:,:),[20001,1]);
hold on;plot(time,Teta2e,'r','LineWidth',2);
ylabel('\theta_2')


subplot(313);
time=0:0.1:20;
plot(time,(flag>1)*1.7,':k','LineWidth',2)
time=0:0.001:20;
Teta3=reshape(par(6,:,:),[20001,1]);
hold on;plot(time,Teta3,'b','LineWidth',2);
Teta3e=reshape(par(3,:,:),[20001,1]);
hold on;plot(time,Teta3e,'r','LineWidth',2);
xlabel('Time (Sec)')
ylabel('\theta_3')

