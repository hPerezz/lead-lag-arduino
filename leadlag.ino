// Definição de pinos
const int sensorPin = A0; // entrada do sensor
const int pwmPin = 9; // saída PWM
// Constantes do controlador
const float b0 = 0.15794;
const float b1 = 0.13351;
const float b2 = 0.00114;
const float a1 = 0.03745;
const float a2 = 0.66996;
// Variáveis para armazenar entradas e saídas passadas
float e[3] = {0.0, 0.0, 0.0}; // erro / entrada
float d[3] = {0.0, 0.0, 0.0}; // saída
// Taxa de amostragem (0.3 segundos)
const unsigned long sampleTime = 300; // em milissegundos
unsigned long lastTime = 0;
void setup() {
pinMode(sensorPin, INPUT);
pinMode(pwmPin, OUTPUT);
Serial.begin(9600); // 9600 rules :)
}
void loop() {
// loop embarcado pra manter tempo de amostragem
if (millis() - lastTime >= sampleTime) {
lastTime = millis();
// Leitura do sensor (normalizando para faixa [-1, 1])
float sensorValue = analogRead(sensorPin);
float e_new = (sensorValue / 1023.0) * 2 - 1;
// novos valores da equação da diferença
float d_new = b0 * e_new + b1 * e[1] + b2 * e[2]
- a1 * d[1] - a2 * d[2];
// Atualiza os valores para a próxima iteração
e[2] = e[1];
e[1] = e_new;
d[2] = d[1];
d[1] = d_new;
// faz regra de 3 pro pwm de saida
int pwmOut = constrain((d_new + 1) * 127.5, 0, 255);
analogWrite(pwmPin, pwmOut);
// Debug no serial monitor
Serial.print("Entrada: "); Serial.print(e_new);
Serial.print("\tSaída PWM: "); Serial.println(pwmOut);
}
}
