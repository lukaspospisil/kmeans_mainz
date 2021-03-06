times1 = [0.266552,0.220792,0.200439,0.192531,0.191104,0.187428,0.197387,0.195842];
times2 = [1.175747,0.683126,0.507045,0.428922,0.369257,0.349725,0.328060,0.313322];
times3 = [10.187930,5.200704,3.571201,2.770886,2.263625,1.968994,1.675098,1.499663];
times4 = [100.277285,50.363332,34.218412,26.339982,21.196080,18.194020,15.189777,13.404175];
times5 = [0.161595,0.164247,0.163254,0.166478,0.166913,0.175962,0.174268,0.185234];

workers = 1:8;

figure
hold on
title('pause in parfor','interpreter','latex')
plot(workers,workers,'k-')
plot(workers,times4(1)./times4,'bs-')
plot(workers,times3(1)./times3,'rs-')
plot(workers,times2(1)./times2,'gs-','Color',[0,0.6,0])
plot(workers,times1(1)./times1,'ms-')
plot(workers,times5(1)./times5,'gs-','Color',[0.8,0.6,0])
legend('optimal', 'pause(1)', 'pause(0.1)', 'pause(0.01)', 'pause(0.001)', 'pause(0.0001)')
xlabel('number of workers','Interpreter','latex')
ylabel('speed up','Interpreter','latex')
hold off
