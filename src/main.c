#include "ch32v30x.h"

/* Configuración básica del GPIO */
void GPIO_Config(void) {
  GPIO_InitTypeDef GPIO_InitStructure = {0};

  // 1. Habilitar el reloj para el Puerto A
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);

  // 2. Configurar PA0 como salida Push-Pull a 50MHz
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOA, &GPIO_InitStructure);
}

int main(void) {
  // Inicializa el sistema (Clock, Interrupciones, etc.)
  SystemInit();

  GPIO_Config();

  while (1) {
    // Encender LED
    GPIO_WriteBit(GPIOA, GPIO_Pin_0, Bit_SET);
    for (uint32_t i = 0; i < 4000000; i++)
      __asm__("nop"); // Delay rústico

    // Apagar LED
    GPIO_WriteBit(GPIOA, GPIO_Pin_0, Bit_RESET);
    for (uint32_t i = 0; i < 4000000; i++)
      __asm__("nop");
  }
}