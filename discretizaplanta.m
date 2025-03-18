% Definição do sistema contínuo G(s)
numerator = 8;
denominator = [1, 1.6, 4];
G_s = tf(numerator, denominator);
% Definir a taxa de amostragem (T_s)
T_s = 0.3;
% Discretizar usando Zero-Order Hold (ZOH)
G_z = c2d(G_s, T_s, 'zoh');
% Discretizar usando a Transformação Bilinear (Tustin)
G_tustin = c2d(G_s, T_s, 'tustin');
% Exibir os modelos discretos G(z) e G(w)
printf("Modelo discreto G(z) para T_s = %.3f:\n", T_s);
display(G_z);
G_tustin_1 = d2c(G_z, 'tustin');
display(G_tustin_1);
[GM, PM, Wcg, Wcp] = margin(g_tustin_1);
printf("Frequência de cruzamento de ganho: %.3f rad/s\n", Wcg);
printf("Margem de ganho: %.3f dB\n", 20*log10(GM));
printf("Margem de fase: %.3f graus\n", PM);