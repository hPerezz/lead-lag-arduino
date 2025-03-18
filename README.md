# Controlador Lead-Lag no Arduino

Este repositório contém a implementação de um **Controlador Lead-Lag** para um sistema dinâmico no **Arduino**, baseado na discretização de um sistema contínuo utilizando as transformações **Zero-Order Hold (ZOH)** e **Tustin**.

## 📌 Objetivo
O objetivo deste projeto é projetar e implementar um controlador Lead-Lag para melhorar a estabilidade e o desempenho de um sistema dinâmico, ajustando a **frequência de cruzamento de ganho** e a **margem de fase** para valores desejados.

---

## 📊 Sistema Original

A função de transferência do sistema contínuo **G(s)** é dada por:

```math
G(s) = \frac{8}{s^2 + 1.6s + 4}
```

Para a discretização, foi escolhida uma **taxa de amostragem** de **0.3 segundos**, seguindo a regra de amostragem **10x a frequência natural do sistema**.

A discretização usando o método **Tustin** e resultou na função de transferência discreta **G(z)**:

```math
G(z) = \frac{z - 1.341z + 0.61882}{0.2998z + 0.2551}
```

A conversão para o domínio contínuo usando a transformação **Tustin** gera **G(w)**:

```math
G(w) = \frac{w + 1.717w + 4.1662}{-0.01512w - 1.149w + 8.3322}
```

---

## 🎯 Especificações do Controlador Lead-Lag

O controlador Lead-Lag foi projetado para atender às seguintes especificações:

- **Frequência de cruzamento de ganho**: 2 rad/s
- **Margem de fase**: 60°
- **Parâmetro do compensador Lag**: \( a_0 = 0.8 \)

### 🔹 Controlador Lead

O compensador **Lead** foi projetado com:

```math
D_{lead}(w) = \frac{w + w_{z\_lead}}{w + w_{p\_lead}}
```

onde:

```math
w_{z\_lead} = wc_{desired} \times \sqrt{a_{lead}}
```

```math
w_{p\_lead} = wc_{desired} / \sqrt{a_{lead}}
```

com \( a_{lead} = 11.5 \).

### 🔹 Controlador Lag

O compensador **Lag** foi projetado com:

```math
D_{lag}(w) = \frac{w + w_{z\_lag}}{w + w_{p\_lag}}
```

onde:

```math
w_{p\_lag} = 60, \quad w_{z\_lag} = w_{p\_lag} / a_0
```

### 🔹 Controlador Final

A função de transferência final do controlador **D(w)** é:

```math
D(w) = \frac{0.02826w + 1.712w + 12}{0.001966w + 0.1608w + 12}
```

Após discretização via **Tustin**, obtemos o controlador **D(z)**:

```math
D(z) = \frac{z - 0.03745z - 0.672}{0.1579z + 0.1335z + 0.0011372}
```

---

## 🔄 Implementação no Arduino

O controlador foi implementado no **Arduino** usando uma **equação às diferenças**, derivada da função de transferência discreta.

A equação implementada é:

```math
d[n] = 0.15794 e[n] + 0.13351 e[n-1] + 0.00114 e[n-2] - 0.03745 d[n-1] - 0.66996 d[n-2]
```

---

## 📌 Resultados do Sistema Compensado

Após a implementação do controlador, os novos valores do sistema compensado são:

- **Frequência de cruzamento de ganho**: 1.492 rad/s
- **Margem de fase**: 59.215°
- **Margem de ganho**: 4.894 dB

🔹 A margem de fase ficou **próxima** da especificação, mas a frequência de cruzamento ainda apresenta uma leve diferença.

---

## 📜 Conclusão

Este projeto apresentou o **desenvolvimento, discretização e implementação** de um **controlador Lead-Lag** no **Arduino** para melhorar o desempenho do sistema dinâmico.

🔹 Foram utilizados conceitos de **discretização por Tustin**, **equações às diferenças** e **implementação em microcontroladores**.

📌 O código pode ser ajustado para otimizações futuras no controle digital.

---

## 🔗 Referências

- **Pacote Control do Octave** para análise e discretização do sistema.
- **Arduino** para a implementação do controlador em hardware.

---

## 📎 Como Usar

1. Clone o repositório:
   ```
   git clone https://github.com/hPerezz/lead-lag-arduino.git
   ```
2. Carregue o código no **Arduino** usando o **Arduino IDE**.
3. Conecte um sensor analógico na entrada **A0** e um atuador na saída **PWM 9**.
4. Visualize os dados no **Serial Monitor**.

🎯 **Desfrute do controle digital no seu Arduino!**

---

🚀 **Desenvolvido por:** *Henrique Perez Gomes da Silva*
