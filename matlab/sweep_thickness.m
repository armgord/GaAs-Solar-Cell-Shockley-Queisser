% Sweep of GaAs absorber and AlGaAs cladding thickness
% Simplified analytical diode model (trend study)

clear all;
close all;
clc;
gaas_thickness = linspace(1.0, 2.5, 15);
algaas_thickness = linspace(0.01, 0.1, 10);
bias_voltage = linspace(0, 1.2, 50);
P_AM15G = 100;
Jsc = zeros(length(gaas_thickness), length(algaas_thickness));
Voc = zeros(length(gaas_thickness), length(algaas_thickness));
Eff = zeros(length(gaas_thickness), length(algaas_thickness));
for i = 1:length(gaas_thickness)
for j = 1:length(algaas_thickness)
Jsc(i,j) = 32.5 * (1 - exp(-gaas_thickness(i)/0.8));
Voc(i,j) = 1.12 * (1 - 0.05*exp(-algaas_thickness(j)/0.03));
J = Jsc(i,j) * (1 - exp((bias_voltage - Voc(i,j))/0.026));
P = J .* bias_voltage;
P_max = max(P);
Eff(i,j) = (P_max / P_AM15G) * 100;
end
end
figure('Name','Análisis de Alturas Óptimas','Position',[100 100 1200 800]);
subplot(2,2,1);
[~, idx_opt] = max(Eff,[],2);
eff_opt_gaas = zeros(size(gaas_thickness));
for k = 1:length(gaas_thickness)
eff_opt_gaas(k) = Eff(k, idx_opt(k));
end
plot(gaas_thickness, eff_opt_gaas, 'LineWidth',2,'Color','b','Marker','o');
hold on;
yline(32.8,'--r','Límite SQ GaAs (32.8%)','LineWidth',1.5);
xlabel('Grosor GaAs (μm)');

ylabel('Eficiencia (%)');
title('Eficiencia vs Grosor GaAs (AlGaAs óptimo)');
grid on;
legend('Eficiencia','Límite teórico','Location','southeast');
subplot(2,2,2);
[~, idx_opt] = max(Eff,[],1);
eff_opt_algaas = zeros(size(algaas_thickness));
for k = 1:length(algaas_thickness)
eff_opt_algaas(k) = Eff(idx_opt(k), k);
end
plot(algaas_thickness, eff_opt_algaas, 'LineWidth',2,'Color','m','Marker','s');
hold on;
yline(32.8,'--r','Límite SQ GaAs (32.8%)','LineWidth',1.5);
xlabel('Grosor AlGaAs (μm)');
ylabel('Eficiencia (%)');
title('Eficiencia vs Grosor AlGaAs (GaAs óptimo)');
grid on;
legend('Eficiencia','Límite teórico','Location','southeast');
subplot(2,2,[3 4]);
imagesc(algaas_thickness, gaas_thickness, Eff);
colorbar;
xlabel('Grosor AlGaAs (μm)');
ylabel('Grosor GaAs (μm)');
title('Mapa de Eficiencia (%)');
set(gca,'YDir','normal');
colormap(jet);
figure('Name','Curvas J-V','Position',[100 100 800 600]);
configs_gaas = [1, round(length(gaas_thickness)/2), length(gaas_thickness)];
configs_algaas = [1, round(length(algaas_thickness)/2), length(algaas_thickness)];
plot_idx = 1;
for i = 1:3

for j = 1:3
J = Jsc(configs_gaas(i), configs_algaas(j)) * ...
(1 - exp((bias_voltage - Voc(configs_gaas(i), configs_algaas(j)))/0.026));
P = J .* bias_voltage;
subplot(3,3,plot_idx);
yyaxis left;
plot(bias_voltage, J, 'LineWidth', 2, 'Color', 'b');
ylabel('Corriente (mA/cm²)', 'Color', 'b');
yyaxis right;
plot(bias_voltage, P, 'LineWidth', 2, 'Color', 'r');
ylabel('Potencia (mW/cm²)', 'Color', 'r');
title(sprintf('GaAs:%.2fμm, AlGaAs:%.3fμm',...
gaas_thickness(configs_gaas(i)), algaas_thickness(configs_algaas(j))));
xlabel('Voltaje (V)');
grid on;
plot_idx = plot_idx + 1;
end
end
[max_eff, idx] = max(Eff(:));
[i_opt, j_opt] = ind2sub(size(Eff), idx);
fprintf('\n=== CONFIGURACIÓN ÓPTIMA ENCONTRADA ===\n');
fprintf('Grosor GaAs: %.3f μm\n', gaas_thickness(i_opt));
fprintf('Grosor AlGaAs: %.3f μm\n', algaas_thickness(j_opt));
fprintf('Jsc: %.2f mA/cm²\n', Jsc(i_opt,j_opt));
fprintf('Voc: %.3f V\n', Voc(i_opt,j_opt));
fprintf('Eficiencia máxima: %.2f%%\n\n', max_eff);
