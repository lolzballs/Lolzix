.globl getGPIOAddress
getGPIOAddress:
  ldr r0,=0x20200000 @ 0x20200000 is GPIO Address
  mov pc,lr          @ return this function


.globl setGPIOFunction
setGPIOFunction:     @ params: r0=pin, r1=function

  cmp r0,#53         @ compare 53(max pin) to pin
  cmpls r1,#7        @ if pin < 53 then compare function to 7(max function)
  movhi pc,lr        @ if any of above was true return

  push {lr}          @ push last instruction to stack
  mov r2,r0          @ copy r2 to r0
  bl getGPIOAddress

  functionLoop$:
    cmp r2,#9
    subhi r2,#10
    addhi r0,#4
    bhi functionLoop$

  add r2, r2,lsl #1  @ actually multiplication by 3
  lsl r1,r2
  str r1,[r0]
  pop {pc}           @ pop stack to pc, returns

.globl setGPIO
setGPIO:
  pinNum .req r0
  pinVal .req r1

  cmp pinNum,#53
  movhi pc,lr
  push {lr}
  mov r2,pinNum
  .unreq pinNum
  pinNum .req r2
  bl getGPIOAddress
  gpioAddr .req r0

  pinBank .req r3
  lsr pinBank,pinNum,#5
  lsl pinBank,#2
  add gpioAddr,pinBank
  .unreq pinBank

  and pinNum,#31
  setBit .req r3
  mov setBit,#1
  lsl setBit,pinNum
  .unreq pinNum

  teq pinVal,#0
  .unreq pinVal
  streq setBit,[gpioAddr,#40]
  strne setBit,[gpioAddr,#28]
  .unreq setBit
  .unreq gpioAddr
  pop {pc}

