function [tnew,ynew] = pBC_ICa(ic,tspan,gnap,gcan,ip3,gca,gtonic)

% parameters
parameters;
Qca = 2; Qv = 100; camin = 0.005;

% if ip3 == 0.1
%     Qcatot = 50;
% else
    Qcatot = 5;
% end

% equations

minf = @(v) 1/(1+exp((Qv*v-vm)/sm));
ninf = @(v) 1/(1+exp((Qv*v-vn)/sn));
mpinf = @(v) 1/(1+exp((Qv*v-vmp)/smp));
hinf = @(v) 1/(1+exp((Qv*v-vh)/sh));

taun = @(v) taunb/cosh((Qv*v-vn)/(2*sn));
tauh = @(v) tauhb/cosh((Qv*v-vh)/(2*sh));

f = @(ca) 1./(1+((kcan./(Qca*ca)).^ncan));

I_l = @(v) gl*(Qv*v-vl);
I_k = @(v,n) gk*(n.^4).*(Qv*v-vk);
I_na = @(v,n) gna*((minf(v)).^3).*(1-n).*(Qv*v-vna);
I_nap = @(v,h) gnap*mpinf(v).*h.*(Qv*v-vna);
I_can = @(v,ca) gcan*f(ca).*(Qv*v-vna);
I_ca = @(v) gca*mpinf(v).*(Qv*v-vca);
I_tonic = @(v) gtonic*(Qv*v-vsyn);

% ca_er = @(catot,ca) (Qcatot*catot-Qca*ca)./sigma;
ca_er = @(catot,ca) (Qcatot*catot-Qca*ca)./sig;
jerin = @(catot,ca,l) (lip3+pip3.*((ip3.*Qca*ca.*l)./((ip3+ki).*(Qca*ca+ka))).^3).*(ca_er(catot,ca)-Qca*ca);
jerout = @(ca) vserca.*(((Qca*ca).^2)./(kserca^2+(Qca*ca).^2));


% ODEs

dvdt = @(v,n,h,ca) (-I_l(v)-I_k(v,n)-I_na(v,n)-I_nap(v,h) ...
    -I_can(v,ca)-I_ca(v)-I_tonic(v))./(Qv*cm);
dndt = @(v,n) (ninf(v)-n)./taun(v);
dhdt = @(v,h) (hinf(v)-h)/tauh(v);
dcadt = @(v,catot,ca,l) (f_i.*(jerin(catot,ca,l)-jerout(ca)) - alpha_ca*I_ca( ...
    v) - (Qca*ca-camin)/tauca)./Qca;
dcatotdt = @(v,ca) (- alpha_ca*I_ca(v) - (Qca*ca-camin)/tauca)/Qcatot;
dldt = @(ca,l) A*kd.*(1-l)-A.*Qca*ca.*l;

% Solving the ODE system
fn = @(t,y) [dvdt(y(1),y(2),y(3),y(4)); dndt(y(1),y(2)); dhdt(y(1),y(3)); dcadt(y(1), ...
    y(5),y(4),y(6)); dcatotdt(y(1),y(4)); dldt(y(4),y(6))];


options = odeset('BDF','on','RelTol',1e-9,'AbsTol',1e-10);
% options = odeset('BDF','on','RelTol',1e-12,'AbsTol',1e-15,'Refine',2);

[t,y] = ode15s(fn,tspan,ic,options); 

% Getting rid of transients
ic_new = y(end,:);
[tnew,ynew] = ode15s(fn,tspan,ic_new,options);

% Getting rid of transients
ic_new = ynew(end,:);
[tnew,ynew] = ode15s(fn,tspan,ic_new,options);

end