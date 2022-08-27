  .file "blink.s"

  .text
  .cpu cortex-m3
  .global _start
  .thumb
  .syntax unified

  // STACK use from the end of SARM
  .equ STACK_TOP, 0x20005000

  // base address of RCC(Reset and clock control)
  .equ RCC_BASE, 0x40021000

  // APB2 peripheral clock enable register
  .equ RCC_APB2ENR, RCC_BASE + 0x18

  // base address of GPIO Port C
  .equ GPIOC, 0x40011000

  // GPIOC_CRH(Port C configuration register high)
  .equ GPIOC_CRH, GPIOC + 0x04

  // GPIOC_ODR(Port C output data register)
  .equ GPIOC_ODR, GPIOC + 0x0c

_start:
  .org 0x00000000
  .word   STACK_TOP
  .word   init

  .align  2 // 2^2 = 4byte = 32bits
  .type init, function
init:
  //
  // clock enable of GPIOC
  //
  LDR r0, =RCC_APB2ENR
  movw r1, #0x0010 // bit 4 = PORTC
  str r1, [r0]

  // GPIO PC13 (MODE13=0b11:Output mode, max speed 50MHz, CNF13=0b00:General purpose output push-pull)
  // GPIO PC15,PC14,PC12,PC11,PC10,PC9,PC8 (MODEy=0b00:Input mode(reset state) CNFy=0b01:Floating input(reset state)
  LDR r0, =(GPIOC_CRH)
  LDR r1, =#0x44344444
  str r1, [r0]

toggle_led:
  // GPIO PC13 output toggle
  LDR r0, =GPIOC_ODR
  ldr r1, [r0]
  eor r1, #0x2000 // bit13
  str r1, [r0]

  // wait....
  LDR r0, =2000000
wait_loop:
  subs r0, #1
  bne wait_loop

  b toggle_led

  .end

