close all;
Par_RLS=reshape(par(1:3,1,:),[3,25001]);
Par_MCMC=reshape(par(4:6,1,:),[3,25001]);
ground_truth=[4;2.3;1.7].*ones(3,25001);
time=0:0.001:25;
subplot(311)
plot(time,ground_truth(1,:),'g')
hold on;
plot(time,Par_RLS(1,:),'b--')
hold on;
plot(time,Par_MCMC(1,:),'r')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14)
ylabel('\theta_1') 
legend('Ground Truth','RLS','ARMCMC')
subplot(312)
plot(time,ground_truth(2,:),'g')
hold on;
plot(time,Par_RLS(2,:),'b--')
hold on;
plot(time,Par_MCMC(2,:),'r')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14)
ylabel('\theta_2') 
subplot(313)
plot(time,ground_truth(3,:),'g')
hold on;
plot(time,Par_RLS(3,:),'b--')
hold on;
plot(time,Par_MCMC(3,:),'r')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14)
xlabel('time (Sec)') 
ylabel('\theta_3') 

figure;
time=0:.1:25;
scatter(time,flag,'r')
yticks([0  1 1.1 1.9 2])
yticklabels({'Modification',' (Contact)','Reinforcement', '(Free motion) ','Reinforcement'})
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14)
xlabel('time (Sec)') 
ylabel('Phase') 
