% Sweep of p/n doping levels and doped-region height
% Simplified analytical diode model (trend study)

clear all;
close all;
clc;
p_doping_levels = logspace(17, 19, 10);
n_doping_levels = logspace(16, 18, 10);

doping_heights = linspace(0.1, 0.5, 8);
bias_voltage = linspace(0, 1.2, 50);
P_AM15G = 100;
Jsc = zeros(length(p_doping_levels), length(n_doping_levels), length(doping_heights));
Voc = zeros(length(p_doping_levels), length(n_doping_levels), length(doping_heights));
Eff = zeros(length(p_doping_levels), length(n_doping_levels), length(doping_heights));
for i = 1:length(p_doping_levels)
for j = 1:length(n_doping_levels)
for k = 1:length(doping_heights)
Jsc_base = 32.5;
Jsc(i,j,k) = Jsc_base * (1 - 0.1*(p_doping_levels(i)/1e18)^-0.5) * ...
(1 - 0.05*(n_doping_levels(j)/1e17)^-0.3);
Voc(i,j,k) = 1.12 - 0.05*log10(p_doping_levels(i)/1e18) + ...
0.03*log10(n_doping_levels(j)/1e17) - ...
0.02*(doping_heights(k)/0.3);
J = Jsc(i,j,k) * (1 - exp((bias_voltage - Voc(i,j,k))/0.026));
P = J .* bias_voltage;
P_max = max(P);
Eff(i,j,k) = (P_max / P_AM15G) * 100;
end
end
end
figure('Name','Análisis de Dopaje','Position',[100 100 1200 900]);
Eff_p = squeeze(max(max(Eff,[],3),[],2));
[~, idx_n] = max(Eff_p);
subplot(2,2,1);
semilogx(p_doping_levels, Eff_p, 'LineWidth',2);
hold on;
plot(p_doping_levels(idx_n), Eff_p(idx_n), 'ro', 'MarkerSize',10);
xlabel('Dopaje p (cm^{-3})');
ylabel('Eficiencia máxima (%)');
title('Eficiencia vs Dopaje p (n y altura óptimos)');

grid on;
Eff_n = squeeze(max(max(Eff,[],3),[],1));
[~, idx_p] = max(Eff_n);
subplot(2,2,2);
semilogx(n_doping_levels, Eff_n, 'LineWidth',2);
hold on;
plot(n_doping_levels(idx_p), Eff_n(idx_p), 'ro', 'MarkerSize',10);
xlabel('Dopaje n (cm^{-3})');
ylabel('Eficiencia máxima (%)');
title('Eficiencia vs Dopaje n (p y altura óptimos)');
grid on;
Eff_h = squeeze(max(max(Eff,[],2),[],1));
[~, idx_h] = max(Eff_h);
subplot(2,2,3);
plot(doping_heights, Eff_h, 'LineWidth',2);
hold on;
plot(doping_heights(idx_h), Eff_h(idx_h), 'ro', 'MarkerSize',10);
xlabel('Altura región dopada (μm)');
ylabel('Eficiencia máxima (%)');
title('Eficiencia vs Altura de Dopaje (p y n óptimos)');
grid on;
subplot(2,2,4);
[X,Y] = meshgrid(log10(p_doping_levels), log10(n_doping_levels));
contourf(X,Y,squeeze(max(Eff,[],3))', 20, 'LineColor','none');
colorbar;
xlabel('log_{10}(Dopaje p) [cm^{-3}]');
ylabel('log_{10}(Dopaje n) [cm^{-3}]');
title('Mapa de Eficiencia (%) - Altura óptima');
colormap(jet);
figure('Name','Parámetros Eléctricos','Position',[100 100 1000 800]);
[~, idx] = max(Eff(:));
[i_opt, j_opt, k_opt] = ind2sub(size(Eff), idx);

J_opt = Jsc(i_opt,j_opt,k_opt) * (1 - exp((bias_voltage - Voc(i_opt,j_opt,k_opt))/0.026));
P_opt = J_opt .* bias_voltage;
subplot(2,2,1);
plot(bias_voltage, J_opt, 'LineWidth',2);
hold on;
plot(bias_voltage, P_opt, 'LineWidth',2);
xlabel('Voltaje (V)');
ylabel('Corriente (mA/cm^2) / Potencia (mW/cm^2)');
title(['Curva J-V óptima - Eff = ' num2str(Eff(i_opt,j_opt,k_opt),'%.2f') '%']);
legend('J-V','Potencia','Location','northeast');
grid on;
subplot(2,2,2);
yyaxis left;
semilogx(p_doping_levels, squeeze(max(max(Jsc,[],3),[],2)), 'LineWidth',2);
ylabel('J_{sc} (mA/cm^2)');
yyaxis right;
semilogx(p_doping_levels, squeeze(max(max(Voc,[],3),[],2)), 'LineWidth',2);
ylabel('V_{oc} (V)');
xlabel('Dopaje p (cm^{-3})');
title('J_{sc} y V_{oc} vs Dopaje p');
grid on;
subplot(2,2,3);
yyaxis left;
semilogx(n_doping_levels, squeeze(max(max(Jsc,[],3),[],1)), 'LineWidth',2);
ylabel('J_{sc} (mA/cm^2)');
yyaxis right;
semilogx(n_doping_levels, squeeze(max(max(Voc,[],3),[],1)), 'LineWidth',2);
ylabel('V_{oc} (V)');
xlabel('Dopaje n (cm^{-3})');
title('J_{sc} y V_{oc} vs Dopaje n');
grid on;

subplot(2,2,4);
yyaxis left;
plot(doping_heights, squeeze(max(max(Jsc,[],2),[],1)), 'LineWidth',2);
ylabel('J_{sc} (mA/cm^2)');
yyaxis right;
plot(doping_heights, squeeze(max(max(Voc,[],2),[],1)), 'LineWidth',2);
ylabel('V_{oc} (V)');
xlabel('Altura región dopada (μm)');
title('J_{sc} y V_{oc} vs Altura de Dopaje');
grid on;
fprintf('\n=== CONFIGURACIÓN ÓPTIMA DE DOPAJE ===\n');
fprintf('Dopaje p: %.2e cm⁻³\n', p_doping_levels(i_opt));
fprintf('Dopaje n: %.2e cm⁻³\n', n_doping_levels(j_opt));
fprintf('Altura regiones dopadas: %.2f μm\n', doping_heights(k_opt));
fprintf('Jsc: %.2f mA/cm²\n', Jsc(i_opt,j_opt,k_opt));
fprintf('Voc: %.3f V\n', Voc(i_opt,j_opt,k_opt));
fprintf('Eficiencia máxima: %.2f%%\n\n', Eff(i_opt,j_opt,k_opt));
fprintf('=== VALORES REPORTADOS EN [4] ===\n');
fprintf('Dopaje p+: 3e18 cm⁻³\n');
fprintf('Dopaje p: 1e18 cm⁻³\n');
fprintf('Dopaje n: 2e17 cm⁻³\n');
fprintf('Dopaje n+: 4e18 cm⁻³\n');
fprintf('Alturas aproximadas: ~0.1-0.3 μm\n');
fprintf('Eficiencia reportada: 28.3%%\n');
