% parameters
% parameters;
gnap = 0; gcan = 1.28; ip3 = 0.64; gca = 0.0002; gtonic = 0;

% solving the ODE
init = rand(6,1);
% init(1) = -0.5 + 0.55*init(1);

[t,y] = pBC_ICa(init,[0 60000],gnap,gcan,ip3,gca,gtonic);

% getting rid of transients
ic_new = y(end,:);
[tnew,ynew] = pBC_ICa(transpose(ic_new),[0 60000],gnap,gcan,ip3,gca,gtonic);

% getting rid of transients
ic_new = ynew(end,:);
[tnew,ynew] = pBC_ICa(transpose(ic_new),[0 60000],gnap,gcan,ip3,gca,gtonic);

% getting rid of transients
ic_new = ynew(end,:);
[tnew,ynew] = pBC_ICa(transpose(ic_new),[0 60000],gnap,gcan,ip3,gca,gtonic);

% getting rid of transients
% ic_new = ynew(end,:);
[~,indmin] = min(ynew(:,1));
% [~,indmin] = min(y(:,1));
ic_new = transpose(ynew(indmin,:));
% ic_new = transpose(y(indmin,:));
[tnew,ynew] = pBC_ICa(ic_new,[0 120000],gnap,gcan,ip3,gca,gtonic);

% % solution for one period
% [minval,ind] = min(y(:,1));
% [pks,locs] = findpeaks(-y(:,1),'MinPeakHeight',-minval-0.01);
% avg = mean(diff(t(locs)));
% ttemp = diff(t(locs));
% P = 0;
% if isempty(pks)
%     % init_new = y(ind(end),:);
%     P = 10000;
% % else
% %     init_new = y(locs(end),:);
% %     T = 20000;
% elseif abs(diff(t(locs)) - avg) < 30
%     P = t(locs(end)) - t(locs(end-1));
% else
%     [~,ind_temp] = findpeaks(-diff(t(locs)),'MinPeakHeight',-min(diff(t(locs)))-1000);
%     for ii = ind_temp(1)+1 : ind_temp(2)
%         P = P + ttemp(ii);
%     end
% end
% 
% init_new = y(ind(end),:);
% [tnew,ynew] = pBC_ICa(init_new,[0 P],gnap,gcan,ip3,gca,gtonic);


%% plots
% figure('Position',[10 10 900 900])
% figure('Position',[10 10 600 900])
% tiledlayout('horizontal')
% subplot(2,3,1)
% tiledlayout(3,2)

% nexttile(6)
figure
subplot(2,1,1)
% nexttile
plot(tnew,ynew(:,1),'k','LineWidth',2)
% hold on
% plot(tnew(indmin),ynew(indmin,1),'r*')
xlim([0 max(tnew)])
ylim([-0.6 0.1])
% xlabel('$t$ (ms)','Interpreter','latex','FontSize',18)
ylabel('$v$','Interpreter','latex','Rotation',0,'FontSize',18)
% title(strcat('\textbf{(H)} ${\rm IP_3} = $',num2str(ip3),', $g_{\rm CAN} = $',num2str(gcan)), ...
%     "Interpreter","latex",'FontSize',16)
% title(strcat('(\textbf{F}) $g_{\rm NaP} = $',num2str(gnap),', $g_{\rm Ca} = $',num2str(gca)), ...
%     "Interpreter","latex",'FontSize',16)
% title(strcat('$g_{\rm NaP} = $',num2str(gnap),', ${\rm IP_3} = $',num2str(ip3)), ...
%     "Interpreter","latex",'FontSize',16)
% title(strcat('(\textbf{C}) $g_{\rm NaP} = $',num2str(gnap),', $g_{\rm Ca} = $',num2str(gca),', ${\rm IP_3} = $',num2str(ip3),', $g_{\rm CAN} = $',num2str(gcan)), ...
    % "Interpreter","latex",'FontSize',16)

% % nexttile(6)
% % % % figure
% subplot(2,1,2)
% plot(tnew,ynew(:,4),'k','LineWidth',2)
% xlim([0 max(tnew)])
% ylim([0 1])
% xlabel('$t$ (ms)','Interpreter','latex','FontSize',18)
% ylabel('$ca$','Interpreter','latex','Rotation',0,'FontSize',18)

subplot(2,1,2)
plot(ynew(:,4),ynew(:,6),'k','LineWidth',2)
xlim([0 1])
ylim([0 1])
xlabel('$t$ (ms)','Interpreter','latex','FontSize',18)
ylabel('$ca$','Interpreter','latex','Rotation',0,'FontSize',18)

fontsize(gcf,scale=1.5)

% tiled plots
% figure('Position',[10 10 300 900])
% % tiledlayout('vertical')
% figure
% % nexttile(3)
% plot(tnew,ynew(:,1),'k','LineWidth',2)
% xlim([0 max(tnew)])
% ylim([-0.6 0.1])
% ylabel('$v$','Interpreter','latex','Rotation',0,'FontSize',16)


% % figure
% subplot(3,2,6)
% plot(tnew,ynew(:,1),'k','LineWidth',2)
% xlim([0 max(tnew)])
% ylim([-0.6 0.1])
% xlabel('$t$ (ms)','Interpreter','latex')
% ylabel('$v$','Interpreter','latex','Rotation',0)
% title('(f)')

% % figure
% figure
% 
% subplot(2,1,1)
% plot(tnew,ynew(:,1),'k','LineWidth',2)
% xlim([0 max(tnew)])
% ylim([-0.6 0.1])
% xlabel('$t$ (ms)','Interpreter','latex','FontSize',16)
% ylabel('$v$','Interpreter','latex','Rotation',0,'FontSize',16)
% title(strcat('$g_{\rm NaP} = $',num2str(gnap),', $g_{\rm Ca} = $',num2str(gca),', ${\rm IP_3} = $',num2str(ip3),', $g_{\rm CAN} = $',num2str(gcan)), ...
%     "Interpreter","latex",'FontSize',16)
% 
% subplot(2,1,2)
% plot(ynew(:,4),ynew(:,6),'k','LineWidth',2)
% xlim([0 max(ynew(:,4))+0.1])
% ylim([min(ynew(:,6))-0.2 1])
% xlabel('$ca$','Interpreter','latex','FontSize',16)
% ylabel('$l$','Interpreter','latex','Rotation',0,'FontSize',16)
% 
% fontsize(gcf,scale=1.5)