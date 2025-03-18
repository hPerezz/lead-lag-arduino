pkg load control
% Definição do sistema G(w)
num = [-0.01512, -1.149, 8.332];
den = [1, 1.717, 4.166];
G = tf(num, den);
% Frequência desejada e margem de fase alvo
wc_desired = 2; % Frequência de cruzamento desejada (rad/s)
PM_desired = 60; % Margem de fase desejada (graus)
a0 = 0.8; % Parâmetro do compensador Lag
% -----------------------------------------------
% PASSO 1: PROJETO DO CONTROLADOR LEAD
% -----------------------------------------------
a_lead = 11.5; % Controle do Lead
wz_lead = wc_desired * sqrt(a_lead)
wp_lead = wc_desired / sqrt(a_lead)
% Função de transferência do compensador Lead ajustado
D_lead = tf([1/wz_lead, 1], [1/wp_lead, 1]);
% -----------------------------------------------
% PASSO 2: PROJETO DO CONTROLADOR LAG
% -----------------------------------------------
wp_lag = 60 % Controle do lag
wz_lag = wp_lag / a0 % Zero correspondente
% Função de transferência do compensador Lag
D_lag = tf([1/wz_lag, 1], [1/wp_lag, 1]);
% -----------------------------------------------
% PASSO 3: OBTENÇÃO DO CONTROLADOR FINAL
% -----------------------------------------------
D = D_lead * D_lag; % Compensador total Lead-Lag
display(D)
% -----------------------------------------------
% PASSO 4: SISTEMA COMPENSADO
% -----------------------------------------------
G_compensado = D * G; % Sistema compensado
% -----------------------------------------------
% PASSO 5: ANÁLISE DE DESEMPENHO
% -----------------------------------------------
figure;
bode(G, {0.1, 100});
hold on;
bode(G_compensado, {0.1, 100});
legend('G(w) Original', 'G(w) Compensado');
title('Diagrama de Bode - Ajustado');
grid on;
% Obtendo as novas margens de fase e ganho
[GM, PM, Wcg, Wcp] = margin(G_compensado);
fprintf("\nResultados do Sistema Compensado (Final Ajuste):\n");
fprintf("Nova frequência de cruzamento de ganho: %.3f rad/s\n", Wcp);
fprintf("Nova margem de fase: %.3f graus\n", PM);
fprintf("Nova margem de ganho: %.3f dB\n", 20*log10(GM));
D_z = c2d(D, 0.3, 'tustin');

% Obter coeficientes do numerador e denominador
[num, den] = tfdata(D_z, 'v');
% Exibir equação às diferenças
disp("Equação às diferenças do controlador:");
fprintf("d[n] = %.5f * e[n] + %.5f * e[n-1] ", num(1), num(2));
if length(num) > 2
fprintf("+ %.5f * e[n-2] ", num(3));
end
for i = 2:length(den)
fprintf("- %.5f * d[n-%d] ", den(i), i-1);
end
fprintf("\n");