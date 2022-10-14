
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b4813103          	ld	sp,-1208(sp) # 80008b48 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	b4e70713          	addi	a4,a4,-1202 # 80008ba0 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	26c78793          	addi	a5,a5,620 # 800062d0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb4a57>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	f1c78793          	addi	a5,a5,-228 # 80000fca <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00002097          	auipc	ra,0x2
    80000130:	770080e7          	jalr	1904(ra) # 8000289c <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	794080e7          	jalr	1940(ra) # 800008d0 <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7119                	addi	sp,sp,-128
    80000166:	fc86                	sd	ra,120(sp)
    80000168:	f8a2                	sd	s0,112(sp)
    8000016a:	f4a6                	sd	s1,104(sp)
    8000016c:	f0ca                	sd	s2,96(sp)
    8000016e:	ecce                	sd	s3,88(sp)
    80000170:	e8d2                	sd	s4,80(sp)
    80000172:	e4d6                	sd	s5,72(sp)
    80000174:	e0da                	sd	s6,64(sp)
    80000176:	fc5e                	sd	s7,56(sp)
    80000178:	f862                	sd	s8,48(sp)
    8000017a:	f466                	sd	s9,40(sp)
    8000017c:	f06a                	sd	s10,32(sp)
    8000017e:	ec6e                	sd	s11,24(sp)
    80000180:	0100                	addi	s0,sp,128
    80000182:	8b2a                	mv	s6,a0
    80000184:	8aae                	mv	s5,a1
    80000186:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000018c:	00011517          	auipc	a0,0x11
    80000190:	b5450513          	addi	a0,a0,-1196 # 80010ce0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	b8c080e7          	jalr	-1140(ra) # 80000d20 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00011497          	auipc	s1,0x11
    800001a0:	b4448493          	addi	s1,s1,-1212 # 80010ce0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	89a6                	mv	s3,s1
    800001a6:	00011917          	auipc	s2,0x11
    800001aa:	bd290913          	addi	s2,s2,-1070 # 80010d78 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001ae:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b0:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b2:	4da9                	li	s11,10
  while(n > 0){
    800001b4:	07405b63          	blez	s4,8000022a <consoleread+0xc6>
    while(cons.r == cons.w){
    800001b8:	0984a783          	lw	a5,152(s1)
    800001bc:	09c4a703          	lw	a4,156(s1)
    800001c0:	02f71763          	bne	a4,a5,800001ee <consoleread+0x8a>
      if(killed(myproc())){
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	98c080e7          	jalr	-1652(ra) # 80001b50 <myproc>
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	51a080e7          	jalr	1306(ra) # 800026e6 <killed>
    800001d4:	e535                	bnez	a0,80000240 <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    800001d6:	85ce                	mv	a1,s3
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	2be080e7          	jalr	702(ra) # 80002498 <sleep>
    while(cons.r == cons.w){
    800001e2:	0984a783          	lw	a5,152(s1)
    800001e6:	09c4a703          	lw	a4,156(s1)
    800001ea:	fcf70de3          	beq	a4,a5,800001c4 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	0017871b          	addiw	a4,a5,1
    800001f2:	08e4ac23          	sw	a4,152(s1)
    800001f6:	07f7f713          	andi	a4,a5,127
    800001fa:	9726                	add	a4,a4,s1
    800001fc:	01874703          	lbu	a4,24(a4)
    80000200:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000204:	079c0663          	beq	s8,s9,80000270 <consoleread+0x10c>
    cbuf = c;
    80000208:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020c:	4685                	li	a3,1
    8000020e:	f8f40613          	addi	a2,s0,-113
    80000212:	85d6                	mv	a1,s5
    80000214:	855a                	mv	a0,s6
    80000216:	00002097          	auipc	ra,0x2
    8000021a:	630080e7          	jalr	1584(ra) # 80002846 <either_copyout>
    8000021e:	01a50663          	beq	a0,s10,8000022a <consoleread+0xc6>
    dst++;
    80000222:	0a85                	addi	s5,s5,1
    --n;
    80000224:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80000226:	f9bc17e3          	bne	s8,s11,800001b4 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022a:	00011517          	auipc	a0,0x11
    8000022e:	ab650513          	addi	a0,a0,-1354 # 80010ce0 <cons>
    80000232:	00001097          	auipc	ra,0x1
    80000236:	ba2080e7          	jalr	-1118(ra) # 80000dd4 <release>

  return target - n;
    8000023a:	414b853b          	subw	a0,s7,s4
    8000023e:	a811                	j	80000252 <consoleread+0xee>
        release(&cons.lock);
    80000240:	00011517          	auipc	a0,0x11
    80000244:	aa050513          	addi	a0,a0,-1376 # 80010ce0 <cons>
    80000248:	00001097          	auipc	ra,0x1
    8000024c:	b8c080e7          	jalr	-1140(ra) # 80000dd4 <release>
        return -1;
    80000250:	557d                	li	a0,-1
}
    80000252:	70e6                	ld	ra,120(sp)
    80000254:	7446                	ld	s0,112(sp)
    80000256:	74a6                	ld	s1,104(sp)
    80000258:	7906                	ld	s2,96(sp)
    8000025a:	69e6                	ld	s3,88(sp)
    8000025c:	6a46                	ld	s4,80(sp)
    8000025e:	6aa6                	ld	s5,72(sp)
    80000260:	6b06                	ld	s6,64(sp)
    80000262:	7be2                	ld	s7,56(sp)
    80000264:	7c42                	ld	s8,48(sp)
    80000266:	7ca2                	ld	s9,40(sp)
    80000268:	7d02                	ld	s10,32(sp)
    8000026a:	6de2                	ld	s11,24(sp)
    8000026c:	6109                	addi	sp,sp,128
    8000026e:	8082                	ret
      if(n < target){
    80000270:	000a071b          	sext.w	a4,s4
    80000274:	fb777be3          	bgeu	a4,s7,8000022a <consoleread+0xc6>
        cons.r--;
    80000278:	00011717          	auipc	a4,0x11
    8000027c:	b0f72023          	sw	a5,-1280(a4) # 80010d78 <cons+0x98>
    80000280:	b76d                	j	8000022a <consoleread+0xc6>

0000000080000282 <consputc>:
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028a:	10000793          	li	a5,256
    8000028e:	00f50a63          	beq	a0,a5,800002a2 <consputc+0x20>
    uartputc_sync(c);
    80000292:	00000097          	auipc	ra,0x0
    80000296:	564080e7          	jalr	1380(ra) # 800007f6 <uartputc_sync>
}
    8000029a:	60a2                	ld	ra,8(sp)
    8000029c:	6402                	ld	s0,0(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a2:	4521                	li	a0,8
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	552080e7          	jalr	1362(ra) # 800007f6 <uartputc_sync>
    800002ac:	02000513          	li	a0,32
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	546080e7          	jalr	1350(ra) # 800007f6 <uartputc_sync>
    800002b8:	4521                	li	a0,8
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	53c080e7          	jalr	1340(ra) # 800007f6 <uartputc_sync>
    800002c2:	bfe1                	j	8000029a <consputc+0x18>

00000000800002c4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c4:	1101                	addi	sp,sp,-32
    800002c6:	ec06                	sd	ra,24(sp)
    800002c8:	e822                	sd	s0,16(sp)
    800002ca:	e426                	sd	s1,8(sp)
    800002cc:	e04a                	sd	s2,0(sp)
    800002ce:	1000                	addi	s0,sp,32
    800002d0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d2:	00011517          	auipc	a0,0x11
    800002d6:	a0e50513          	addi	a0,a0,-1522 # 80010ce0 <cons>
    800002da:	00001097          	auipc	ra,0x1
    800002de:	a46080e7          	jalr	-1466(ra) # 80000d20 <acquire>

  switch(c){
    800002e2:	47d5                	li	a5,21
    800002e4:	0af48663          	beq	s1,a5,80000390 <consoleintr+0xcc>
    800002e8:	0297ca63          	blt	a5,s1,8000031c <consoleintr+0x58>
    800002ec:	47a1                	li	a5,8
    800002ee:	0ef48763          	beq	s1,a5,800003dc <consoleintr+0x118>
    800002f2:	47c1                	li	a5,16
    800002f4:	10f49a63          	bne	s1,a5,80000408 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f8:	00002097          	auipc	ra,0x2
    800002fc:	5fa080e7          	jalr	1530(ra) # 800028f2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000300:	00011517          	auipc	a0,0x11
    80000304:	9e050513          	addi	a0,a0,-1568 # 80010ce0 <cons>
    80000308:	00001097          	auipc	ra,0x1
    8000030c:	acc080e7          	jalr	-1332(ra) # 80000dd4 <release>
}
    80000310:	60e2                	ld	ra,24(sp)
    80000312:	6442                	ld	s0,16(sp)
    80000314:	64a2                	ld	s1,8(sp)
    80000316:	6902                	ld	s2,0(sp)
    80000318:	6105                	addi	sp,sp,32
    8000031a:	8082                	ret
  switch(c){
    8000031c:	07f00793          	li	a5,127
    80000320:	0af48e63          	beq	s1,a5,800003dc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000324:	00011717          	auipc	a4,0x11
    80000328:	9bc70713          	addi	a4,a4,-1604 # 80010ce0 <cons>
    8000032c:	0a072783          	lw	a5,160(a4)
    80000330:	09872703          	lw	a4,152(a4)
    80000334:	9f99                	subw	a5,a5,a4
    80000336:	07f00713          	li	a4,127
    8000033a:	fcf763e3          	bltu	a4,a5,80000300 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033e:	47b5                	li	a5,13
    80000340:	0cf48763          	beq	s1,a5,8000040e <consoleintr+0x14a>
      consputc(c);
    80000344:	8526                	mv	a0,s1
    80000346:	00000097          	auipc	ra,0x0
    8000034a:	f3c080e7          	jalr	-196(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000034e:	00011797          	auipc	a5,0x11
    80000352:	99278793          	addi	a5,a5,-1646 # 80010ce0 <cons>
    80000356:	0a07a683          	lw	a3,160(a5)
    8000035a:	0016871b          	addiw	a4,a3,1
    8000035e:	0007061b          	sext.w	a2,a4
    80000362:	0ae7a023          	sw	a4,160(a5)
    80000366:	07f6f693          	andi	a3,a3,127
    8000036a:	97b6                	add	a5,a5,a3
    8000036c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000370:	47a9                	li	a5,10
    80000372:	0cf48563          	beq	s1,a5,8000043c <consoleintr+0x178>
    80000376:	4791                	li	a5,4
    80000378:	0cf48263          	beq	s1,a5,8000043c <consoleintr+0x178>
    8000037c:	00011797          	auipc	a5,0x11
    80000380:	9fc7a783          	lw	a5,-1540(a5) # 80010d78 <cons+0x98>
    80000384:	9f1d                	subw	a4,a4,a5
    80000386:	08000793          	li	a5,128
    8000038a:	f6f71be3          	bne	a4,a5,80000300 <consoleintr+0x3c>
    8000038e:	a07d                	j	8000043c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000390:	00011717          	auipc	a4,0x11
    80000394:	95070713          	addi	a4,a4,-1712 # 80010ce0 <cons>
    80000398:	0a072783          	lw	a5,160(a4)
    8000039c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a0:	00011497          	auipc	s1,0x11
    800003a4:	94048493          	addi	s1,s1,-1728 # 80010ce0 <cons>
    while(cons.e != cons.w &&
    800003a8:	4929                	li	s2,10
    800003aa:	f4f70be3          	beq	a4,a5,80000300 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003ae:	37fd                	addiw	a5,a5,-1
    800003b0:	07f7f713          	andi	a4,a5,127
    800003b4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b6:	01874703          	lbu	a4,24(a4)
    800003ba:	f52703e3          	beq	a4,s2,80000300 <consoleintr+0x3c>
      cons.e--;
    800003be:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c2:	10000513          	li	a0,256
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	ebc080e7          	jalr	-324(ra) # 80000282 <consputc>
    while(cons.e != cons.w &&
    800003ce:	0a04a783          	lw	a5,160(s1)
    800003d2:	09c4a703          	lw	a4,156(s1)
    800003d6:	fcf71ce3          	bne	a4,a5,800003ae <consoleintr+0xea>
    800003da:	b71d                	j	80000300 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003dc:	00011717          	auipc	a4,0x11
    800003e0:	90470713          	addi	a4,a4,-1788 # 80010ce0 <cons>
    800003e4:	0a072783          	lw	a5,160(a4)
    800003e8:	09c72703          	lw	a4,156(a4)
    800003ec:	f0f70ae3          	beq	a4,a5,80000300 <consoleintr+0x3c>
      cons.e--;
    800003f0:	37fd                	addiw	a5,a5,-1
    800003f2:	00011717          	auipc	a4,0x11
    800003f6:	98f72723          	sw	a5,-1650(a4) # 80010d80 <cons+0xa0>
      consputc(BACKSPACE);
    800003fa:	10000513          	li	a0,256
    800003fe:	00000097          	auipc	ra,0x0
    80000402:	e84080e7          	jalr	-380(ra) # 80000282 <consputc>
    80000406:	bded                	j	80000300 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000408:	ee048ce3          	beqz	s1,80000300 <consoleintr+0x3c>
    8000040c:	bf21                	j	80000324 <consoleintr+0x60>
      consputc(c);
    8000040e:	4529                	li	a0,10
    80000410:	00000097          	auipc	ra,0x0
    80000414:	e72080e7          	jalr	-398(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000418:	00011797          	auipc	a5,0x11
    8000041c:	8c878793          	addi	a5,a5,-1848 # 80010ce0 <cons>
    80000420:	0a07a703          	lw	a4,160(a5)
    80000424:	0017069b          	addiw	a3,a4,1
    80000428:	0006861b          	sext.w	a2,a3
    8000042c:	0ad7a023          	sw	a3,160(a5)
    80000430:	07f77713          	andi	a4,a4,127
    80000434:	97ba                	add	a5,a5,a4
    80000436:	4729                	li	a4,10
    80000438:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043c:	00011797          	auipc	a5,0x11
    80000440:	94c7a023          	sw	a2,-1728(a5) # 80010d7c <cons+0x9c>
        wakeup(&cons.r);
    80000444:	00011517          	auipc	a0,0x11
    80000448:	93450513          	addi	a0,a0,-1740 # 80010d78 <cons+0x98>
    8000044c:	00002097          	auipc	ra,0x2
    80000450:	cca080e7          	jalr	-822(ra) # 80002116 <wakeup>
    80000454:	b575                	j	80000300 <consoleintr+0x3c>

0000000080000456 <consoleinit>:

void
consoleinit(void)
{
    80000456:	1141                	addi	sp,sp,-16
    80000458:	e406                	sd	ra,8(sp)
    8000045a:	e022                	sd	s0,0(sp)
    8000045c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045e:	00008597          	auipc	a1,0x8
    80000462:	bb258593          	addi	a1,a1,-1102 # 80008010 <etext+0x10>
    80000466:	00011517          	auipc	a0,0x11
    8000046a:	87a50513          	addi	a0,a0,-1926 # 80010ce0 <cons>
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	822080e7          	jalr	-2014(ra) # 80000c90 <initlock>

  uartinit();
    80000476:	00000097          	auipc	ra,0x0
    8000047a:	330080e7          	jalr	816(ra) # 800007a6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047e:	00247797          	auipc	a5,0x247
    80000482:	41278793          	addi	a5,a5,1042 # 80247890 <devsw>
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	cde70713          	addi	a4,a4,-802 # 80000164 <consoleread>
    8000048e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c7270713          	addi	a4,a4,-910 # 80000102 <consolewrite>
    80000498:	ef98                	sd	a4,24(a5)
}
    8000049a:	60a2                	ld	ra,8(sp)
    8000049c:	6402                	ld	s0,0(sp)
    8000049e:	0141                	addi	sp,sp,16
    800004a0:	8082                	ret

00000000800004a2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a2:	7179                	addi	sp,sp,-48
    800004a4:	f406                	sd	ra,40(sp)
    800004a6:	f022                	sd	s0,32(sp)
    800004a8:	ec26                	sd	s1,24(sp)
    800004aa:	e84a                	sd	s2,16(sp)
    800004ac:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004ae:	c219                	beqz	a2,800004b4 <printint+0x12>
    800004b0:	08054663          	bltz	a0,8000053c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b4:	2501                	sext.w	a0,a0
    800004b6:	4881                	li	a7,0
    800004b8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004bc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004be:	2581                	sext.w	a1,a1
    800004c0:	00008617          	auipc	a2,0x8
    800004c4:	b8060613          	addi	a2,a2,-1152 # 80008040 <digits>
    800004c8:	883a                	mv	a6,a4
    800004ca:	2705                	addiw	a4,a4,1
    800004cc:	02b577bb          	remuw	a5,a0,a1
    800004d0:	1782                	slli	a5,a5,0x20
    800004d2:	9381                	srli	a5,a5,0x20
    800004d4:	97b2                	add	a5,a5,a2
    800004d6:	0007c783          	lbu	a5,0(a5)
    800004da:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004de:	0005079b          	sext.w	a5,a0
    800004e2:	02b5553b          	divuw	a0,a0,a1
    800004e6:	0685                	addi	a3,a3,1
    800004e8:	feb7f0e3          	bgeu	a5,a1,800004c8 <printint+0x26>

  if(sign)
    800004ec:	00088b63          	beqz	a7,80000502 <printint+0x60>
    buf[i++] = '-';
    800004f0:	fe040793          	addi	a5,s0,-32
    800004f4:	973e                	add	a4,a4,a5
    800004f6:	02d00793          	li	a5,45
    800004fa:	fef70823          	sb	a5,-16(a4)
    800004fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000502:	02e05763          	blez	a4,80000530 <printint+0x8e>
    80000506:	fd040793          	addi	a5,s0,-48
    8000050a:	00e784b3          	add	s1,a5,a4
    8000050e:	fff78913          	addi	s2,a5,-1
    80000512:	993a                	add	s2,s2,a4
    80000514:	377d                	addiw	a4,a4,-1
    80000516:	1702                	slli	a4,a4,0x20
    80000518:	9301                	srli	a4,a4,0x20
    8000051a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051e:	fff4c503          	lbu	a0,-1(s1)
    80000522:	00000097          	auipc	ra,0x0
    80000526:	d60080e7          	jalr	-672(ra) # 80000282 <consputc>
  while(--i >= 0)
    8000052a:	14fd                	addi	s1,s1,-1
    8000052c:	ff2499e3          	bne	s1,s2,8000051e <printint+0x7c>
}
    80000530:	70a2                	ld	ra,40(sp)
    80000532:	7402                	ld	s0,32(sp)
    80000534:	64e2                	ld	s1,24(sp)
    80000536:	6942                	ld	s2,16(sp)
    80000538:	6145                	addi	sp,sp,48
    8000053a:	8082                	ret
    x = -xx;
    8000053c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000540:	4885                	li	a7,1
    x = -xx;
    80000542:	bf9d                	j	800004b8 <printint+0x16>

0000000080000544 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000544:	1101                	addi	sp,sp,-32
    80000546:	ec06                	sd	ra,24(sp)
    80000548:	e822                	sd	s0,16(sp)
    8000054a:	e426                	sd	s1,8(sp)
    8000054c:	1000                	addi	s0,sp,32
    8000054e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000550:	00011797          	auipc	a5,0x11
    80000554:	8407a823          	sw	zero,-1968(a5) # 80010da0 <pr+0x18>
  printf("panic: ");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	ac050513          	addi	a0,a0,-1344 # 80008018 <etext+0x18>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	02e080e7          	jalr	46(ra) # 8000058e <printf>
  printf(s);
    80000568:	8526                	mv	a0,s1
    8000056a:	00000097          	auipc	ra,0x0
    8000056e:	024080e7          	jalr	36(ra) # 8000058e <printf>
  printf("\n");
    80000572:	00008517          	auipc	a0,0x8
    80000576:	b8e50513          	addi	a0,a0,-1138 # 80008100 <digits+0xc0>
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	014080e7          	jalr	20(ra) # 8000058e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000582:	4785                	li	a5,1
    80000584:	00008717          	auipc	a4,0x8
    80000588:	5cf72e23          	sw	a5,1500(a4) # 80008b60 <panicked>
  for(;;)
    8000058c:	a001                	j	8000058c <panic+0x48>

000000008000058e <printf>:
{
    8000058e:	7131                	addi	sp,sp,-192
    80000590:	fc86                	sd	ra,120(sp)
    80000592:	f8a2                	sd	s0,112(sp)
    80000594:	f4a6                	sd	s1,104(sp)
    80000596:	f0ca                	sd	s2,96(sp)
    80000598:	ecce                	sd	s3,88(sp)
    8000059a:	e8d2                	sd	s4,80(sp)
    8000059c:	e4d6                	sd	s5,72(sp)
    8000059e:	e0da                	sd	s6,64(sp)
    800005a0:	fc5e                	sd	s7,56(sp)
    800005a2:	f862                	sd	s8,48(sp)
    800005a4:	f466                	sd	s9,40(sp)
    800005a6:	f06a                	sd	s10,32(sp)
    800005a8:	ec6e                	sd	s11,24(sp)
    800005aa:	0100                	addi	s0,sp,128
    800005ac:	8a2a                	mv	s4,a0
    800005ae:	e40c                	sd	a1,8(s0)
    800005b0:	e810                	sd	a2,16(s0)
    800005b2:	ec14                	sd	a3,24(s0)
    800005b4:	f018                	sd	a4,32(s0)
    800005b6:	f41c                	sd	a5,40(s0)
    800005b8:	03043823          	sd	a6,48(s0)
    800005bc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c0:	00010d97          	auipc	s11,0x10
    800005c4:	7e0dad83          	lw	s11,2016(s11) # 80010da0 <pr+0x18>
  if(locking)
    800005c8:	020d9b63          	bnez	s11,800005fe <printf+0x70>
  if (fmt == 0)
    800005cc:	040a0263          	beqz	s4,80000610 <printf+0x82>
  va_start(ap, fmt);
    800005d0:	00840793          	addi	a5,s0,8
    800005d4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d8:	000a4503          	lbu	a0,0(s4)
    800005dc:	16050263          	beqz	a0,80000740 <printf+0x1b2>
    800005e0:	4481                	li	s1,0
    if(c != '%'){
    800005e2:	02500a93          	li	s5,37
    switch(c){
    800005e6:	07000b13          	li	s6,112
  consputc('x');
    800005ea:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005ec:	00008b97          	auipc	s7,0x8
    800005f0:	a54b8b93          	addi	s7,s7,-1452 # 80008040 <digits>
    switch(c){
    800005f4:	07300c93          	li	s9,115
    800005f8:	06400c13          	li	s8,100
    800005fc:	a82d                	j	80000636 <printf+0xa8>
    acquire(&pr.lock);
    800005fe:	00010517          	auipc	a0,0x10
    80000602:	78a50513          	addi	a0,a0,1930 # 80010d88 <pr>
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	71a080e7          	jalr	1818(ra) # 80000d20 <acquire>
    8000060e:	bf7d                	j	800005cc <printf+0x3e>
    panic("null fmt");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a1850513          	addi	a0,a0,-1512 # 80008028 <etext+0x28>
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	f2c080e7          	jalr	-212(ra) # 80000544 <panic>
      consputc(c);
    80000620:	00000097          	auipc	ra,0x0
    80000624:	c62080e7          	jalr	-926(ra) # 80000282 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000628:	2485                	addiw	s1,s1,1
    8000062a:	009a07b3          	add	a5,s4,s1
    8000062e:	0007c503          	lbu	a0,0(a5)
    80000632:	10050763          	beqz	a0,80000740 <printf+0x1b2>
    if(c != '%'){
    80000636:	ff5515e3          	bne	a0,s5,80000620 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063a:	2485                	addiw	s1,s1,1
    8000063c:	009a07b3          	add	a5,s4,s1
    80000640:	0007c783          	lbu	a5,0(a5)
    80000644:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000648:	cfe5                	beqz	a5,80000740 <printf+0x1b2>
    switch(c){
    8000064a:	05678a63          	beq	a5,s6,8000069e <printf+0x110>
    8000064e:	02fb7663          	bgeu	s6,a5,8000067a <printf+0xec>
    80000652:	09978963          	beq	a5,s9,800006e4 <printf+0x156>
    80000656:	07800713          	li	a4,120
    8000065a:	0ce79863          	bne	a5,a4,8000072a <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4605                	li	a2,1
    8000066c:	85ea                	mv	a1,s10
    8000066e:	4388                	lw	a0,0(a5)
    80000670:	00000097          	auipc	ra,0x0
    80000674:	e32080e7          	jalr	-462(ra) # 800004a2 <printint>
      break;
    80000678:	bf45                	j	80000628 <printf+0x9a>
    switch(c){
    8000067a:	0b578263          	beq	a5,s5,8000071e <printf+0x190>
    8000067e:	0b879663          	bne	a5,s8,8000072a <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4605                	li	a2,1
    80000690:	45a9                	li	a1,10
    80000692:	4388                	lw	a0,0(a5)
    80000694:	00000097          	auipc	ra,0x0
    80000698:	e0e080e7          	jalr	-498(ra) # 800004a2 <printint>
      break;
    8000069c:	b771                	j	80000628 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006ae:	03000513          	li	a0,48
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	bd0080e7          	jalr	-1072(ra) # 80000282 <consputc>
  consputc('x');
    800006ba:	07800513          	li	a0,120
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	bc4080e7          	jalr	-1084(ra) # 80000282 <consputc>
    800006c6:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c8:	03c9d793          	srli	a5,s3,0x3c
    800006cc:	97de                	add	a5,a5,s7
    800006ce:	0007c503          	lbu	a0,0(a5)
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	bb0080e7          	jalr	-1104(ra) # 80000282 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006da:	0992                	slli	s3,s3,0x4
    800006dc:	397d                	addiw	s2,s2,-1
    800006de:	fe0915e3          	bnez	s2,800006c8 <printf+0x13a>
    800006e2:	b799                	j	80000628 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e4:	f8843783          	ld	a5,-120(s0)
    800006e8:	00878713          	addi	a4,a5,8
    800006ec:	f8e43423          	sd	a4,-120(s0)
    800006f0:	0007b903          	ld	s2,0(a5)
    800006f4:	00090e63          	beqz	s2,80000710 <printf+0x182>
      for(; *s; s++)
    800006f8:	00094503          	lbu	a0,0(s2)
    800006fc:	d515                	beqz	a0,80000628 <printf+0x9a>
        consputc(*s);
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	b84080e7          	jalr	-1148(ra) # 80000282 <consputc>
      for(; *s; s++)
    80000706:	0905                	addi	s2,s2,1
    80000708:	00094503          	lbu	a0,0(s2)
    8000070c:	f96d                	bnez	a0,800006fe <printf+0x170>
    8000070e:	bf29                	j	80000628 <printf+0x9a>
        s = "(null)";
    80000710:	00008917          	auipc	s2,0x8
    80000714:	91090913          	addi	s2,s2,-1776 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000718:	02800513          	li	a0,40
    8000071c:	b7cd                	j	800006fe <printf+0x170>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b62080e7          	jalr	-1182(ra) # 80000282 <consputc>
      break;
    80000728:	b701                	j	80000628 <printf+0x9a>
      consputc('%');
    8000072a:	8556                	mv	a0,s5
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b56080e7          	jalr	-1194(ra) # 80000282 <consputc>
      consputc(c);
    80000734:	854a                	mv	a0,s2
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	b4c080e7          	jalr	-1204(ra) # 80000282 <consputc>
      break;
    8000073e:	b5ed                	j	80000628 <printf+0x9a>
  if(locking)
    80000740:	020d9163          	bnez	s11,80000762 <printf+0x1d4>
}
    80000744:	70e6                	ld	ra,120(sp)
    80000746:	7446                	ld	s0,112(sp)
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	7906                	ld	s2,96(sp)
    8000074c:	69e6                	ld	s3,88(sp)
    8000074e:	6a46                	ld	s4,80(sp)
    80000750:	6aa6                	ld	s5,72(sp)
    80000752:	6b06                	ld	s6,64(sp)
    80000754:	7be2                	ld	s7,56(sp)
    80000756:	7c42                	ld	s8,48(sp)
    80000758:	7ca2                	ld	s9,40(sp)
    8000075a:	7d02                	ld	s10,32(sp)
    8000075c:	6de2                	ld	s11,24(sp)
    8000075e:	6129                	addi	sp,sp,192
    80000760:	8082                	ret
    release(&pr.lock);
    80000762:	00010517          	auipc	a0,0x10
    80000766:	62650513          	addi	a0,a0,1574 # 80010d88 <pr>
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	66a080e7          	jalr	1642(ra) # 80000dd4 <release>
}
    80000772:	bfc9                	j	80000744 <printf+0x1b6>

0000000080000774 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000774:	1101                	addi	sp,sp,-32
    80000776:	ec06                	sd	ra,24(sp)
    80000778:	e822                	sd	s0,16(sp)
    8000077a:	e426                	sd	s1,8(sp)
    8000077c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077e:	00010497          	auipc	s1,0x10
    80000782:	60a48493          	addi	s1,s1,1546 # 80010d88 <pr>
    80000786:	00008597          	auipc	a1,0x8
    8000078a:	8b258593          	addi	a1,a1,-1870 # 80008038 <etext+0x38>
    8000078e:	8526                	mv	a0,s1
    80000790:	00000097          	auipc	ra,0x0
    80000794:	500080e7          	jalr	1280(ra) # 80000c90 <initlock>
  pr.locking = 1;
    80000798:	4785                	li	a5,1
    8000079a:	cc9c                	sw	a5,24(s1)
}
    8000079c:	60e2                	ld	ra,24(sp)
    8000079e:	6442                	ld	s0,16(sp)
    800007a0:	64a2                	ld	s1,8(sp)
    800007a2:	6105                	addi	sp,sp,32
    800007a4:	8082                	ret

00000000800007a6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007a6:	1141                	addi	sp,sp,-16
    800007a8:	e406                	sd	ra,8(sp)
    800007aa:	e022                	sd	s0,0(sp)
    800007ac:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ae:	100007b7          	lui	a5,0x10000
    800007b2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007b6:	f8000713          	li	a4,-128
    800007ba:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007be:	470d                	li	a4,3
    800007c0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007cc:	469d                	li	a3,7
    800007ce:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007d2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007d6:	00008597          	auipc	a1,0x8
    800007da:	88258593          	addi	a1,a1,-1918 # 80008058 <digits+0x18>
    800007de:	00010517          	auipc	a0,0x10
    800007e2:	5ca50513          	addi	a0,a0,1482 # 80010da8 <uart_tx_lock>
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	4aa080e7          	jalr	1194(ra) # 80000c90 <initlock>
}
    800007ee:	60a2                	ld	ra,8(sp)
    800007f0:	6402                	ld	s0,0(sp)
    800007f2:	0141                	addi	sp,sp,16
    800007f4:	8082                	ret

00000000800007f6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007f6:	1101                	addi	sp,sp,-32
    800007f8:	ec06                	sd	ra,24(sp)
    800007fa:	e822                	sd	s0,16(sp)
    800007fc:	e426                	sd	s1,8(sp)
    800007fe:	1000                	addi	s0,sp,32
    80000800:	84aa                	mv	s1,a0
  push_off();
    80000802:	00000097          	auipc	ra,0x0
    80000806:	4d2080e7          	jalr	1234(ra) # 80000cd4 <push_off>

  if(panicked){
    8000080a:	00008797          	auipc	a5,0x8
    8000080e:	3567a783          	lw	a5,854(a5) # 80008b60 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000812:	10000737          	lui	a4,0x10000
  if(panicked){
    80000816:	c391                	beqz	a5,8000081a <uartputc_sync+0x24>
    for(;;)
    80000818:	a001                	j	80000818 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000081a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000081e:	0ff7f793          	andi	a5,a5,255
    80000822:	0207f793          	andi	a5,a5,32
    80000826:	dbf5                	beqz	a5,8000081a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000828:	0ff4f793          	andi	a5,s1,255
    8000082c:	10000737          	lui	a4,0x10000
    80000830:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000834:	00000097          	auipc	ra,0x0
    80000838:	540080e7          	jalr	1344(ra) # 80000d74 <pop_off>
}
    8000083c:	60e2                	ld	ra,24(sp)
    8000083e:	6442                	ld	s0,16(sp)
    80000840:	64a2                	ld	s1,8(sp)
    80000842:	6105                	addi	sp,sp,32
    80000844:	8082                	ret

0000000080000846 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000846:	00008717          	auipc	a4,0x8
    8000084a:	32273703          	ld	a4,802(a4) # 80008b68 <uart_tx_r>
    8000084e:	00008797          	auipc	a5,0x8
    80000852:	3227b783          	ld	a5,802(a5) # 80008b70 <uart_tx_w>
    80000856:	06e78c63          	beq	a5,a4,800008ce <uartstart+0x88>
{
    8000085a:	7139                	addi	sp,sp,-64
    8000085c:	fc06                	sd	ra,56(sp)
    8000085e:	f822                	sd	s0,48(sp)
    80000860:	f426                	sd	s1,40(sp)
    80000862:	f04a                	sd	s2,32(sp)
    80000864:	ec4e                	sd	s3,24(sp)
    80000866:	e852                	sd	s4,16(sp)
    80000868:	e456                	sd	s5,8(sp)
    8000086a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000086c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000870:	00010a17          	auipc	s4,0x10
    80000874:	538a0a13          	addi	s4,s4,1336 # 80010da8 <uart_tx_lock>
    uart_tx_r += 1;
    80000878:	00008497          	auipc	s1,0x8
    8000087c:	2f048493          	addi	s1,s1,752 # 80008b68 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000880:	00008997          	auipc	s3,0x8
    80000884:	2f098993          	addi	s3,s3,752 # 80008b70 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000888:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000088c:	0ff7f793          	andi	a5,a5,255
    80000890:	0207f793          	andi	a5,a5,32
    80000894:	c785                	beqz	a5,800008bc <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000896:	01f77793          	andi	a5,a4,31
    8000089a:	97d2                	add	a5,a5,s4
    8000089c:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800008a0:	0705                	addi	a4,a4,1
    800008a2:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a4:	8526                	mv	a0,s1
    800008a6:	00002097          	auipc	ra,0x2
    800008aa:	870080e7          	jalr	-1936(ra) # 80002116 <wakeup>
    
    WriteReg(THR, c);
    800008ae:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b2:	6098                	ld	a4,0(s1)
    800008b4:	0009b783          	ld	a5,0(s3)
    800008b8:	fce798e3          	bne	a5,a4,80000888 <uartstart+0x42>
  }
}
    800008bc:	70e2                	ld	ra,56(sp)
    800008be:	7442                	ld	s0,48(sp)
    800008c0:	74a2                	ld	s1,40(sp)
    800008c2:	7902                	ld	s2,32(sp)
    800008c4:	69e2                	ld	s3,24(sp)
    800008c6:	6a42                	ld	s4,16(sp)
    800008c8:	6aa2                	ld	s5,8(sp)
    800008ca:	6121                	addi	sp,sp,64
    800008cc:	8082                	ret
    800008ce:	8082                	ret

00000000800008d0 <uartputc>:
{
    800008d0:	7179                	addi	sp,sp,-48
    800008d2:	f406                	sd	ra,40(sp)
    800008d4:	f022                	sd	s0,32(sp)
    800008d6:	ec26                	sd	s1,24(sp)
    800008d8:	e84a                	sd	s2,16(sp)
    800008da:	e44e                	sd	s3,8(sp)
    800008dc:	e052                	sd	s4,0(sp)
    800008de:	1800                	addi	s0,sp,48
    800008e0:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800008e2:	00010517          	auipc	a0,0x10
    800008e6:	4c650513          	addi	a0,a0,1222 # 80010da8 <uart_tx_lock>
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	436080e7          	jalr	1078(ra) # 80000d20 <acquire>
  if(panicked){
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	26e7a783          	lw	a5,622(a5) # 80008b60 <panicked>
    800008fa:	e7c9                	bnez	a5,80000984 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fc:	00008797          	auipc	a5,0x8
    80000900:	2747b783          	ld	a5,628(a5) # 80008b70 <uart_tx_w>
    80000904:	00008717          	auipc	a4,0x8
    80000908:	26473703          	ld	a4,612(a4) # 80008b68 <uart_tx_r>
    8000090c:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000910:	00010a17          	auipc	s4,0x10
    80000914:	498a0a13          	addi	s4,s4,1176 # 80010da8 <uart_tx_lock>
    80000918:	00008497          	auipc	s1,0x8
    8000091c:	25048493          	addi	s1,s1,592 # 80008b68 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000920:	00008917          	auipc	s2,0x8
    80000924:	25090913          	addi	s2,s2,592 # 80008b70 <uart_tx_w>
    80000928:	00f71f63          	bne	a4,a5,80000946 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000092c:	85d2                	mv	a1,s4
    8000092e:	8526                	mv	a0,s1
    80000930:	00002097          	auipc	ra,0x2
    80000934:	b68080e7          	jalr	-1176(ra) # 80002498 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000938:	00093783          	ld	a5,0(s2)
    8000093c:	6098                	ld	a4,0(s1)
    8000093e:	02070713          	addi	a4,a4,32
    80000942:	fef705e3          	beq	a4,a5,8000092c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000946:	00010497          	auipc	s1,0x10
    8000094a:	46248493          	addi	s1,s1,1122 # 80010da8 <uart_tx_lock>
    8000094e:	01f7f713          	andi	a4,a5,31
    80000952:	9726                	add	a4,a4,s1
    80000954:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80000958:	0785                	addi	a5,a5,1
    8000095a:	00008717          	auipc	a4,0x8
    8000095e:	20f73b23          	sd	a5,534(a4) # 80008b70 <uart_tx_w>
  uartstart();
    80000962:	00000097          	auipc	ra,0x0
    80000966:	ee4080e7          	jalr	-284(ra) # 80000846 <uartstart>
  release(&uart_tx_lock);
    8000096a:	8526                	mv	a0,s1
    8000096c:	00000097          	auipc	ra,0x0
    80000970:	468080e7          	jalr	1128(ra) # 80000dd4 <release>
}
    80000974:	70a2                	ld	ra,40(sp)
    80000976:	7402                	ld	s0,32(sp)
    80000978:	64e2                	ld	s1,24(sp)
    8000097a:	6942                	ld	s2,16(sp)
    8000097c:	69a2                	ld	s3,8(sp)
    8000097e:	6a02                	ld	s4,0(sp)
    80000980:	6145                	addi	sp,sp,48
    80000982:	8082                	ret
    for(;;)
    80000984:	a001                	j	80000984 <uartputc+0xb4>

0000000080000986 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000986:	1141                	addi	sp,sp,-16
    80000988:	e422                	sd	s0,8(sp)
    8000098a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000098c:	100007b7          	lui	a5,0x10000
    80000990:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000994:	8b85                	andi	a5,a5,1
    80000996:	cb91                	beqz	a5,800009aa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000998:	100007b7          	lui	a5,0x10000
    8000099c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009a0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009a4:	6422                	ld	s0,8(sp)
    800009a6:	0141                	addi	sp,sp,16
    800009a8:	8082                	ret
    return -1;
    800009aa:	557d                	li	a0,-1
    800009ac:	bfe5                	j	800009a4 <uartgetc+0x1e>

00000000800009ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ae:	1101                	addi	sp,sp,-32
    800009b0:	ec06                	sd	ra,24(sp)
    800009b2:	e822                	sd	s0,16(sp)
    800009b4:	e426                	sd	s1,8(sp)
    800009b6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009b8:	54fd                	li	s1,-1
    int c = uartgetc();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	fcc080e7          	jalr	-52(ra) # 80000986 <uartgetc>
    if(c == -1)
    800009c2:	00950763          	beq	a0,s1,800009d0 <uartintr+0x22>
      break;
    consoleintr(c);
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	8fe080e7          	jalr	-1794(ra) # 800002c4 <consoleintr>
  while(1){
    800009ce:	b7f5                	j	800009ba <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009d0:	00010497          	auipc	s1,0x10
    800009d4:	3d848493          	addi	s1,s1,984 # 80010da8 <uart_tx_lock>
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	346080e7          	jalr	838(ra) # 80000d20 <acquire>
  uartstart();
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	e64080e7          	jalr	-412(ra) # 80000846 <uartstart>
  release(&uart_tx_lock);
    800009ea:	8526                	mv	a0,s1
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	3e8080e7          	jalr	1000(ra) # 80000dd4 <release>
}
    800009f4:	60e2                	ld	ra,24(sp)
    800009f6:	6442                	ld	s0,16(sp)
    800009f8:	64a2                	ld	s1,8(sp)
    800009fa:	6105                	addi	sp,sp,32
    800009fc:	8082                	ret

00000000800009fe <increse>:
  release(&kmem.lock);
}
*/

void increse(uint64 pa)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
    80000a08:	84aa                	mv	s1,a0
    //acquire the lock
  acquire(&kmem.lock);
    80000a0a:	00010517          	auipc	a0,0x10
    80000a0e:	3d650513          	addi	a0,a0,982 # 80010de0 <kmem>
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	30e080e7          	jalr	782(ra) # 80000d20 <acquire>
  int pn = pa / PGSIZE;
  if(pa>PHYSTOP || refcnt[pn]<1){
    80000a1a:	4745                	li	a4,17
    80000a1c:	076e                	slli	a4,a4,0x1b
    80000a1e:	04976463          	bltu	a4,s1,80000a66 <increse+0x68>
    80000a22:	00c4d793          	srli	a5,s1,0xc
    80000a26:	2781                	sext.w	a5,a5
    80000a28:	00279693          	slli	a3,a5,0x2
    80000a2c:	00010717          	auipc	a4,0x10
    80000a30:	3d470713          	addi	a4,a4,980 # 80010e00 <refcnt>
    80000a34:	9736                	add	a4,a4,a3
    80000a36:	4318                	lw	a4,0(a4)
    80000a38:	02e05763          	blez	a4,80000a66 <increse+0x68>
    panic("increase ref cnt");
  }
  refcnt[pn]++;
    80000a3c:	078a                	slli	a5,a5,0x2
    80000a3e:	00010697          	auipc	a3,0x10
    80000a42:	3c268693          	addi	a3,a3,962 # 80010e00 <refcnt>
    80000a46:	97b6                	add	a5,a5,a3
    80000a48:	2705                	addiw	a4,a4,1
    80000a4a:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    80000a4c:	00010517          	auipc	a0,0x10
    80000a50:	39450513          	addi	a0,a0,916 # 80010de0 <kmem>
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	380080e7          	jalr	896(ra) # 80000dd4 <release>
}
    80000a5c:	60e2                	ld	ra,24(sp)
    80000a5e:	6442                	ld	s0,16(sp)
    80000a60:	64a2                	ld	s1,8(sp)
    80000a62:	6105                	addi	sp,sp,32
    80000a64:	8082                	ret
    panic("increase ref cnt");
    80000a66:	00007517          	auipc	a0,0x7
    80000a6a:	5fa50513          	addi	a0,a0,1530 # 80008060 <digits+0x20>
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	ad6080e7          	jalr	-1322(ra) # 80000544 <panic>

0000000080000a76 <kfree>:

void kfree(void *pa)
{
    80000a76:	1101                	addi	sp,sp,-32
    80000a78:	ec06                	sd	ra,24(sp)
    80000a7a:	e822                	sd	s0,16(sp)
    80000a7c:	e426                	sd	s1,8(sp)
    80000a7e:	e04a                	sd	s2,0(sp)
    80000a80:	1000                	addi	s0,sp,32
  struct run *r;
  r = (struct run *)pa;
  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a82:	03451793          	slli	a5,a0,0x34
    80000a86:	ebbd                	bnez	a5,80000afc <kfree+0x86>
    80000a88:	84aa                	mv	s1,a0
    80000a8a:	00249797          	auipc	a5,0x249
    80000a8e:	31e78793          	addi	a5,a5,798 # 80249da8 <end>
    80000a92:	06f56563          	bltu	a0,a5,80000afc <kfree+0x86>
    80000a96:	47c5                	li	a5,17
    80000a98:	07ee                	slli	a5,a5,0x1b
    80000a9a:	06f57163          	bgeu	a0,a5,80000afc <kfree+0x86>
    panic("kfree");
	//when we free the page decraese the refcnt of the pa
    //we need to acquire the lock
    //and get the really current cnt for the current fucntion
  acquire(&kmem.lock);
    80000a9e:	00010517          	auipc	a0,0x10
    80000aa2:	34250513          	addi	a0,a0,834 # 80010de0 <kmem>
    80000aa6:	00000097          	auipc	ra,0x0
    80000aaa:	27a080e7          	jalr	634(ra) # 80000d20 <acquire>
  int pn = (uint64)r / PGSIZE;
    80000aae:	00c4d793          	srli	a5,s1,0xc
    80000ab2:	2781                	sext.w	a5,a5
  if (refcnt[pn] < 1)
    80000ab4:	00279693          	slli	a3,a5,0x2
    80000ab8:	00010717          	auipc	a4,0x10
    80000abc:	34870713          	addi	a4,a4,840 # 80010e00 <refcnt>
    80000ac0:	9736                	add	a4,a4,a3
    80000ac2:	4318                	lw	a4,0(a4)
    80000ac4:	04e05463          	blez	a4,80000b0c <kfree+0x96>
    panic("kfree panic");
  refcnt[pn] -= 1;
    80000ac8:	377d                	addiw	a4,a4,-1
    80000aca:	0007091b          	sext.w	s2,a4
    80000ace:	078a                	slli	a5,a5,0x2
    80000ad0:	00010697          	auipc	a3,0x10
    80000ad4:	33068693          	addi	a3,a3,816 # 80010e00 <refcnt>
    80000ad8:	97b6                	add	a5,a5,a3
    80000ada:	c398                	sw	a4,0(a5)
  int tmp = refcnt[pn];
  release(&kmem.lock);
    80000adc:	00010517          	auipc	a0,0x10
    80000ae0:	30450513          	addi	a0,a0,772 # 80010de0 <kmem>
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	2f0080e7          	jalr	752(ra) # 80000dd4 <release>

  if (tmp >0)
    80000aec:	03205863          	blez	s2,80000b1c <kfree+0xa6>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000af0:	60e2                	ld	ra,24(sp)
    80000af2:	6442                	ld	s0,16(sp)
    80000af4:	64a2                	ld	s1,8(sp)
    80000af6:	6902                	ld	s2,0(sp)
    80000af8:	6105                	addi	sp,sp,32
    80000afa:	8082                	ret
    panic("kfree");
    80000afc:	00007517          	auipc	a0,0x7
    80000b00:	57c50513          	addi	a0,a0,1404 # 80008078 <digits+0x38>
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	a40080e7          	jalr	-1472(ra) # 80000544 <panic>
    panic("kfree panic");
    80000b0c:	00007517          	auipc	a0,0x7
    80000b10:	57450513          	addi	a0,a0,1396 # 80008080 <digits+0x40>
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	a30080e7          	jalr	-1488(ra) # 80000544 <panic>
  memset(pa, 1, PGSIZE);
    80000b1c:	6605                	lui	a2,0x1
    80000b1e:	4585                	li	a1,1
    80000b20:	8526                	mv	a0,s1
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	2fa080e7          	jalr	762(ra) # 80000e1c <memset>
  acquire(&kmem.lock);
    80000b2a:	00010917          	auipc	s2,0x10
    80000b2e:	2b690913          	addi	s2,s2,694 # 80010de0 <kmem>
    80000b32:	854a                	mv	a0,s2
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	1ec080e7          	jalr	492(ra) # 80000d20 <acquire>
  r->next = kmem.freelist;
    80000b3c:	01893783          	ld	a5,24(s2)
    80000b40:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000b42:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000b46:	854a                	mv	a0,s2
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	28c080e7          	jalr	652(ra) # 80000dd4 <release>
    80000b50:	b745                	j	80000af0 <kfree+0x7a>

0000000080000b52 <freerange>:
{
    80000b52:	7139                	addi	sp,sp,-64
    80000b54:	fc06                	sd	ra,56(sp)
    80000b56:	f822                	sd	s0,48(sp)
    80000b58:	f426                	sd	s1,40(sp)
    80000b5a:	f04a                	sd	s2,32(sp)
    80000b5c:	ec4e                	sd	s3,24(sp)
    80000b5e:	e852                	sd	s4,16(sp)
    80000b60:	e456                	sd	s5,8(sp)
    80000b62:	e05a                	sd	s6,0(sp)
    80000b64:	0080                	addi	s0,sp,64
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000b66:	6785                	lui	a5,0x1
    80000b68:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000b6c:	9526                	add	a0,a0,s1
    80000b6e:	74fd                	lui	s1,0xfffff
    80000b70:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b72:	97a6                	add	a5,a5,s1
    80000b74:	02f5ea63          	bltu	a1,a5,80000ba8 <freerange+0x56>
    80000b78:	892e                	mv	s2,a1
    refcnt[(uint64)p / PGSIZE] = 1;
    80000b7a:	00010b17          	auipc	s6,0x10
    80000b7e:	286b0b13          	addi	s6,s6,646 # 80010e00 <refcnt>
    80000b82:	4a85                	li	s5,1
    80000b84:	6a05                	lui	s4,0x1
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b86:	6989                	lui	s3,0x2
    refcnt[(uint64)p / PGSIZE] = 1;
    80000b88:	00c4d793          	srli	a5,s1,0xc
    80000b8c:	078a                	slli	a5,a5,0x2
    80000b8e:	97da                	add	a5,a5,s6
    80000b90:	0157a023          	sw	s5,0(a5)
    kfree(p);
    80000b94:	8526                	mv	a0,s1
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	ee0080e7          	jalr	-288(ra) # 80000a76 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b9e:	87a6                	mv	a5,s1
    80000ba0:	94d2                	add	s1,s1,s4
    80000ba2:	97ce                	add	a5,a5,s3
    80000ba4:	fef972e3          	bgeu	s2,a5,80000b88 <freerange+0x36>
}
    80000ba8:	70e2                	ld	ra,56(sp)
    80000baa:	7442                	ld	s0,48(sp)
    80000bac:	74a2                	ld	s1,40(sp)
    80000bae:	7902                	ld	s2,32(sp)
    80000bb0:	69e2                	ld	s3,24(sp)
    80000bb2:	6a42                	ld	s4,16(sp)
    80000bb4:	6aa2                	ld	s5,8(sp)
    80000bb6:	6b02                	ld	s6,0(sp)
    80000bb8:	6121                	addi	sp,sp,64
    80000bba:	8082                	ret

0000000080000bbc <kinit>:
{
    80000bbc:	1141                	addi	sp,sp,-16
    80000bbe:	e406                	sd	ra,8(sp)
    80000bc0:	e022                	sd	s0,0(sp)
    80000bc2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000bc4:	00007597          	auipc	a1,0x7
    80000bc8:	4cc58593          	addi	a1,a1,1228 # 80008090 <digits+0x50>
    80000bcc:	00010517          	auipc	a0,0x10
    80000bd0:	21450513          	addi	a0,a0,532 # 80010de0 <kmem>
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	0bc080e7          	jalr	188(ra) # 80000c90 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000bdc:	45c5                	li	a1,17
    80000bde:	05ee                	slli	a1,a1,0x1b
    80000be0:	00249517          	auipc	a0,0x249
    80000be4:	1c850513          	addi	a0,a0,456 # 80249da8 <end>
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	f6a080e7          	jalr	-150(ra) # 80000b52 <freerange>
}
    80000bf0:	60a2                	ld	ra,8(sp)
    80000bf2:	6402                	ld	s0,0(sp)
    80000bf4:	0141                	addi	sp,sp,16
    80000bf6:	8082                	ret

0000000080000bf8 <kalloc>:
}
*/

void *
kalloc(void)
{
    80000bf8:	1101                	addi	sp,sp,-32
    80000bfa:	ec06                	sd	ra,24(sp)
    80000bfc:	e822                	sd	s0,16(sp)
    80000bfe:	e426                	sd	s1,8(sp)
    80000c00:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c02:	00010497          	auipc	s1,0x10
    80000c06:	1de48493          	addi	s1,s1,478 # 80010de0 <kmem>
    80000c0a:	8526                	mv	a0,s1
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	114080e7          	jalr	276(ra) # 80000d20 <acquire>
  r = kmem.freelist;
    80000c14:	6c84                	ld	s1,24(s1)

  if (r)
    80000c16:	c4a5                	beqz	s1,80000c7e <kalloc+0x86>
  {
    int pn = (uint64)r / PGSIZE;
    80000c18:	00c4d793          	srli	a5,s1,0xc
    80000c1c:	2781                	sext.w	a5,a5
    if(refcnt[pn]!=0){
    80000c1e:	00279693          	slli	a3,a5,0x2
    80000c22:	00010717          	auipc	a4,0x10
    80000c26:	1de70713          	addi	a4,a4,478 # 80010e00 <refcnt>
    80000c2a:	9736                	add	a4,a4,a3
    80000c2c:	4318                	lw	a4,0(a4)
    80000c2e:	e321                	bnez	a4,80000c6e <kalloc+0x76>
      panic("refcnt kalloc");
    }
    refcnt[pn] = 1;
    80000c30:	078a                	slli	a5,a5,0x2
    80000c32:	00010717          	auipc	a4,0x10
    80000c36:	1ce70713          	addi	a4,a4,462 # 80010e00 <refcnt>
    80000c3a:	97ba                	add	a5,a5,a4
    80000c3c:	4705                	li	a4,1
    80000c3e:	c398                	sw	a4,0(a5)
    kmem.freelist = r->next;
    80000c40:	609c                	ld	a5,0(s1)
    80000c42:	00010517          	auipc	a0,0x10
    80000c46:	19e50513          	addi	a0,a0,414 # 80010de0 <kmem>
    80000c4a:	ed1c                	sd	a5,24(a0)
  }

  release(&kmem.lock);
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	188080e7          	jalr	392(ra) # 80000dd4 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000c54:	6605                	lui	a2,0x1
    80000c56:	4595                	li	a1,5
    80000c58:	8526                	mv	a0,s1
    80000c5a:	00000097          	auipc	ra,0x0
    80000c5e:	1c2080e7          	jalr	450(ra) # 80000e1c <memset>
  return (void *)r;
}
    80000c62:	8526                	mv	a0,s1
    80000c64:	60e2                	ld	ra,24(sp)
    80000c66:	6442                	ld	s0,16(sp)
    80000c68:	64a2                	ld	s1,8(sp)
    80000c6a:	6105                	addi	sp,sp,32
    80000c6c:	8082                	ret
      panic("refcnt kalloc");
    80000c6e:	00007517          	auipc	a0,0x7
    80000c72:	42a50513          	addi	a0,a0,1066 # 80008098 <digits+0x58>
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	8ce080e7          	jalr	-1842(ra) # 80000544 <panic>
  release(&kmem.lock);
    80000c7e:	00010517          	auipc	a0,0x10
    80000c82:	16250513          	addi	a0,a0,354 # 80010de0 <kmem>
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	14e080e7          	jalr	334(ra) # 80000dd4 <release>
  if (r)
    80000c8e:	bfd1                	j	80000c62 <kalloc+0x6a>

0000000080000c90 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c90:	1141                	addi	sp,sp,-16
    80000c92:	e422                	sd	s0,8(sp)
    80000c94:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c96:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c98:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c9c:	00053823          	sd	zero,16(a0)
}
    80000ca0:	6422                	ld	s0,8(sp)
    80000ca2:	0141                	addi	sp,sp,16
    80000ca4:	8082                	ret

0000000080000ca6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000ca6:	411c                	lw	a5,0(a0)
    80000ca8:	e399                	bnez	a5,80000cae <holding+0x8>
    80000caa:	4501                	li	a0,0
  return r;
}
    80000cac:	8082                	ret
{
    80000cae:	1101                	addi	sp,sp,-32
    80000cb0:	ec06                	sd	ra,24(sp)
    80000cb2:	e822                	sd	s0,16(sp)
    80000cb4:	e426                	sd	s1,8(sp)
    80000cb6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000cb8:	6904                	ld	s1,16(a0)
    80000cba:	00001097          	auipc	ra,0x1
    80000cbe:	e7a080e7          	jalr	-390(ra) # 80001b34 <mycpu>
    80000cc2:	40a48533          	sub	a0,s1,a0
    80000cc6:	00153513          	seqz	a0,a0
}
    80000cca:	60e2                	ld	ra,24(sp)
    80000ccc:	6442                	ld	s0,16(sp)
    80000cce:	64a2                	ld	s1,8(sp)
    80000cd0:	6105                	addi	sp,sp,32
    80000cd2:	8082                	ret

0000000080000cd4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cd4:	1101                	addi	sp,sp,-32
    80000cd6:	ec06                	sd	ra,24(sp)
    80000cd8:	e822                	sd	s0,16(sp)
    80000cda:	e426                	sd	s1,8(sp)
    80000cdc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cde:	100024f3          	csrr	s1,sstatus
    80000ce2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000ce6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ce8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000cec:	00001097          	auipc	ra,0x1
    80000cf0:	e48080e7          	jalr	-440(ra) # 80001b34 <mycpu>
    80000cf4:	5d3c                	lw	a5,120(a0)
    80000cf6:	cf89                	beqz	a5,80000d10 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000cf8:	00001097          	auipc	ra,0x1
    80000cfc:	e3c080e7          	jalr	-452(ra) # 80001b34 <mycpu>
    80000d00:	5d3c                	lw	a5,120(a0)
    80000d02:	2785                	addiw	a5,a5,1
    80000d04:	dd3c                	sw	a5,120(a0)
}
    80000d06:	60e2                	ld	ra,24(sp)
    80000d08:	6442                	ld	s0,16(sp)
    80000d0a:	64a2                	ld	s1,8(sp)
    80000d0c:	6105                	addi	sp,sp,32
    80000d0e:	8082                	ret
    mycpu()->intena = old;
    80000d10:	00001097          	auipc	ra,0x1
    80000d14:	e24080e7          	jalr	-476(ra) # 80001b34 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d18:	8085                	srli	s1,s1,0x1
    80000d1a:	8885                	andi	s1,s1,1
    80000d1c:	dd64                	sw	s1,124(a0)
    80000d1e:	bfe9                	j	80000cf8 <push_off+0x24>

0000000080000d20 <acquire>:
{
    80000d20:	1101                	addi	sp,sp,-32
    80000d22:	ec06                	sd	ra,24(sp)
    80000d24:	e822                	sd	s0,16(sp)
    80000d26:	e426                	sd	s1,8(sp)
    80000d28:	1000                	addi	s0,sp,32
    80000d2a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	fa8080e7          	jalr	-88(ra) # 80000cd4 <push_off>
  if(holding(lk))
    80000d34:	8526                	mv	a0,s1
    80000d36:	00000097          	auipc	ra,0x0
    80000d3a:	f70080e7          	jalr	-144(ra) # 80000ca6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d3e:	4705                	li	a4,1
  if(holding(lk))
    80000d40:	e115                	bnez	a0,80000d64 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d42:	87ba                	mv	a5,a4
    80000d44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d48:	2781                	sext.w	a5,a5
    80000d4a:	ffe5                	bnez	a5,80000d42 <acquire+0x22>
  __sync_synchronize();
    80000d4c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d50:	00001097          	auipc	ra,0x1
    80000d54:	de4080e7          	jalr	-540(ra) # 80001b34 <mycpu>
    80000d58:	e888                	sd	a0,16(s1)
}
    80000d5a:	60e2                	ld	ra,24(sp)
    80000d5c:	6442                	ld	s0,16(sp)
    80000d5e:	64a2                	ld	s1,8(sp)
    80000d60:	6105                	addi	sp,sp,32
    80000d62:	8082                	ret
    panic("acquire");
    80000d64:	00007517          	auipc	a0,0x7
    80000d68:	34450513          	addi	a0,a0,836 # 800080a8 <digits+0x68>
    80000d6c:	fffff097          	auipc	ra,0xfffff
    80000d70:	7d8080e7          	jalr	2008(ra) # 80000544 <panic>

0000000080000d74 <pop_off>:

void
pop_off(void)
{
    80000d74:	1141                	addi	sp,sp,-16
    80000d76:	e406                	sd	ra,8(sp)
    80000d78:	e022                	sd	s0,0(sp)
    80000d7a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d7c:	00001097          	auipc	ra,0x1
    80000d80:	db8080e7          	jalr	-584(ra) # 80001b34 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d84:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d88:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d8a:	e78d                	bnez	a5,80000db4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d8c:	5d3c                	lw	a5,120(a0)
    80000d8e:	02f05b63          	blez	a5,80000dc4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d92:	37fd                	addiw	a5,a5,-1
    80000d94:	0007871b          	sext.w	a4,a5
    80000d98:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d9a:	eb09                	bnez	a4,80000dac <pop_off+0x38>
    80000d9c:	5d7c                	lw	a5,124(a0)
    80000d9e:	c799                	beqz	a5,80000dac <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000da0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000da4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000da8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000dac:	60a2                	ld	ra,8(sp)
    80000dae:	6402                	ld	s0,0(sp)
    80000db0:	0141                	addi	sp,sp,16
    80000db2:	8082                	ret
    panic("pop_off - interruptible");
    80000db4:	00007517          	auipc	a0,0x7
    80000db8:	2fc50513          	addi	a0,a0,764 # 800080b0 <digits+0x70>
    80000dbc:	fffff097          	auipc	ra,0xfffff
    80000dc0:	788080e7          	jalr	1928(ra) # 80000544 <panic>
    panic("pop_off");
    80000dc4:	00007517          	auipc	a0,0x7
    80000dc8:	30450513          	addi	a0,a0,772 # 800080c8 <digits+0x88>
    80000dcc:	fffff097          	auipc	ra,0xfffff
    80000dd0:	778080e7          	jalr	1912(ra) # 80000544 <panic>

0000000080000dd4 <release>:
{
    80000dd4:	1101                	addi	sp,sp,-32
    80000dd6:	ec06                	sd	ra,24(sp)
    80000dd8:	e822                	sd	s0,16(sp)
    80000dda:	e426                	sd	s1,8(sp)
    80000ddc:	1000                	addi	s0,sp,32
    80000dde:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000de0:	00000097          	auipc	ra,0x0
    80000de4:	ec6080e7          	jalr	-314(ra) # 80000ca6 <holding>
    80000de8:	c115                	beqz	a0,80000e0c <release+0x38>
  lk->cpu = 0;
    80000dea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000dee:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000df2:	0f50000f          	fence	iorw,ow
    80000df6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000dfa:	00000097          	auipc	ra,0x0
    80000dfe:	f7a080e7          	jalr	-134(ra) # 80000d74 <pop_off>
}
    80000e02:	60e2                	ld	ra,24(sp)
    80000e04:	6442                	ld	s0,16(sp)
    80000e06:	64a2                	ld	s1,8(sp)
    80000e08:	6105                	addi	sp,sp,32
    80000e0a:	8082                	ret
    panic("release");
    80000e0c:	00007517          	auipc	a0,0x7
    80000e10:	2c450513          	addi	a0,a0,708 # 800080d0 <digits+0x90>
    80000e14:	fffff097          	auipc	ra,0xfffff
    80000e18:	730080e7          	jalr	1840(ra) # 80000544 <panic>

0000000080000e1c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e22:	ce09                	beqz	a2,80000e3c <memset+0x20>
    80000e24:	87aa                	mv	a5,a0
    80000e26:	fff6071b          	addiw	a4,a2,-1
    80000e2a:	1702                	slli	a4,a4,0x20
    80000e2c:	9301                	srli	a4,a4,0x20
    80000e2e:	0705                	addi	a4,a4,1
    80000e30:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000e32:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e36:	0785                	addi	a5,a5,1
    80000e38:	fee79de3          	bne	a5,a4,80000e32 <memset+0x16>
  }
  return dst;
}
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e48:	ca05                	beqz	a2,80000e78 <memcmp+0x36>
    80000e4a:	fff6069b          	addiw	a3,a2,-1
    80000e4e:	1682                	slli	a3,a3,0x20
    80000e50:	9281                	srli	a3,a3,0x20
    80000e52:	0685                	addi	a3,a3,1
    80000e54:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e56:	00054783          	lbu	a5,0(a0)
    80000e5a:	0005c703          	lbu	a4,0(a1)
    80000e5e:	00e79863          	bne	a5,a4,80000e6e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e62:	0505                	addi	a0,a0,1
    80000e64:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e66:	fed518e3          	bne	a0,a3,80000e56 <memcmp+0x14>
  }

  return 0;
    80000e6a:	4501                	li	a0,0
    80000e6c:	a019                	j	80000e72 <memcmp+0x30>
      return *s1 - *s2;
    80000e6e:	40e7853b          	subw	a0,a5,a4
}
    80000e72:	6422                	ld	s0,8(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret
  return 0;
    80000e78:	4501                	li	a0,0
    80000e7a:	bfe5                	j	80000e72 <memcmp+0x30>

0000000080000e7c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e422                	sd	s0,8(sp)
    80000e80:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e82:	ca0d                	beqz	a2,80000eb4 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e84:	00a5f963          	bgeu	a1,a0,80000e96 <memmove+0x1a>
    80000e88:	02061693          	slli	a3,a2,0x20
    80000e8c:	9281                	srli	a3,a3,0x20
    80000e8e:	00d58733          	add	a4,a1,a3
    80000e92:	02e56463          	bltu	a0,a4,80000eba <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e96:	fff6079b          	addiw	a5,a2,-1
    80000e9a:	1782                	slli	a5,a5,0x20
    80000e9c:	9381                	srli	a5,a5,0x20
    80000e9e:	0785                	addi	a5,a5,1
    80000ea0:	97ae                	add	a5,a5,a1
    80000ea2:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ea4:	0585                	addi	a1,a1,1
    80000ea6:	0705                	addi	a4,a4,1
    80000ea8:	fff5c683          	lbu	a3,-1(a1)
    80000eac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000eb0:	fef59ae3          	bne	a1,a5,80000ea4 <memmove+0x28>

  return dst;
}
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret
    d += n;
    80000eba:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000ebc:	fff6079b          	addiw	a5,a2,-1
    80000ec0:	1782                	slli	a5,a5,0x20
    80000ec2:	9381                	srli	a5,a5,0x20
    80000ec4:	fff7c793          	not	a5,a5
    80000ec8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000eca:	177d                	addi	a4,a4,-1
    80000ecc:	16fd                	addi	a3,a3,-1
    80000ece:	00074603          	lbu	a2,0(a4)
    80000ed2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ed6:	fef71ae3          	bne	a4,a5,80000eca <memmove+0x4e>
    80000eda:	bfe9                	j	80000eb4 <memmove+0x38>

0000000080000edc <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000edc:	1141                	addi	sp,sp,-16
    80000ede:	e406                	sd	ra,8(sp)
    80000ee0:	e022                	sd	s0,0(sp)
    80000ee2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ee4:	00000097          	auipc	ra,0x0
    80000ee8:	f98080e7          	jalr	-104(ra) # 80000e7c <memmove>
}
    80000eec:	60a2                	ld	ra,8(sp)
    80000eee:	6402                	ld	s0,0(sp)
    80000ef0:	0141                	addi	sp,sp,16
    80000ef2:	8082                	ret

0000000080000ef4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000ef4:	1141                	addi	sp,sp,-16
    80000ef6:	e422                	sd	s0,8(sp)
    80000ef8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000efa:	ce11                	beqz	a2,80000f16 <strncmp+0x22>
    80000efc:	00054783          	lbu	a5,0(a0)
    80000f00:	cf89                	beqz	a5,80000f1a <strncmp+0x26>
    80000f02:	0005c703          	lbu	a4,0(a1)
    80000f06:	00f71a63          	bne	a4,a5,80000f1a <strncmp+0x26>
    n--, p++, q++;
    80000f0a:	367d                	addiw	a2,a2,-1
    80000f0c:	0505                	addi	a0,a0,1
    80000f0e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f10:	f675                	bnez	a2,80000efc <strncmp+0x8>
  if(n == 0)
    return 0;
    80000f12:	4501                	li	a0,0
    80000f14:	a809                	j	80000f26 <strncmp+0x32>
    80000f16:	4501                	li	a0,0
    80000f18:	a039                	j	80000f26 <strncmp+0x32>
  if(n == 0)
    80000f1a:	ca09                	beqz	a2,80000f2c <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000f1c:	00054503          	lbu	a0,0(a0)
    80000f20:	0005c783          	lbu	a5,0(a1)
    80000f24:	9d1d                	subw	a0,a0,a5
}
    80000f26:	6422                	ld	s0,8(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret
    return 0;
    80000f2c:	4501                	li	a0,0
    80000f2e:	bfe5                	j	80000f26 <strncmp+0x32>

0000000080000f30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f30:	1141                	addi	sp,sp,-16
    80000f32:	e422                	sd	s0,8(sp)
    80000f34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f36:	872a                	mv	a4,a0
    80000f38:	8832                	mv	a6,a2
    80000f3a:	367d                	addiw	a2,a2,-1
    80000f3c:	01005963          	blez	a6,80000f4e <strncpy+0x1e>
    80000f40:	0705                	addi	a4,a4,1
    80000f42:	0005c783          	lbu	a5,0(a1)
    80000f46:	fef70fa3          	sb	a5,-1(a4)
    80000f4a:	0585                	addi	a1,a1,1
    80000f4c:	f7f5                	bnez	a5,80000f38 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f4e:	00c05d63          	blez	a2,80000f68 <strncpy+0x38>
    80000f52:	86ba                	mv	a3,a4
    *s++ = 0;
    80000f54:	0685                	addi	a3,a3,1
    80000f56:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000f5a:	fff6c793          	not	a5,a3
    80000f5e:	9fb9                	addw	a5,a5,a4
    80000f60:	010787bb          	addw	a5,a5,a6
    80000f64:	fef048e3          	bgtz	a5,80000f54 <strncpy+0x24>
  return os;
}
    80000f68:	6422                	ld	s0,8(sp)
    80000f6a:	0141                	addi	sp,sp,16
    80000f6c:	8082                	ret

0000000080000f6e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f6e:	1141                	addi	sp,sp,-16
    80000f70:	e422                	sd	s0,8(sp)
    80000f72:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f74:	02c05363          	blez	a2,80000f9a <safestrcpy+0x2c>
    80000f78:	fff6069b          	addiw	a3,a2,-1
    80000f7c:	1682                	slli	a3,a3,0x20
    80000f7e:	9281                	srli	a3,a3,0x20
    80000f80:	96ae                	add	a3,a3,a1
    80000f82:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f84:	00d58963          	beq	a1,a3,80000f96 <safestrcpy+0x28>
    80000f88:	0585                	addi	a1,a1,1
    80000f8a:	0785                	addi	a5,a5,1
    80000f8c:	fff5c703          	lbu	a4,-1(a1)
    80000f90:	fee78fa3          	sb	a4,-1(a5)
    80000f94:	fb65                	bnez	a4,80000f84 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f96:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f9a:	6422                	ld	s0,8(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret

0000000080000fa0 <strlen>:

int
strlen(const char *s)
{
    80000fa0:	1141                	addi	sp,sp,-16
    80000fa2:	e422                	sd	s0,8(sp)
    80000fa4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000fa6:	00054783          	lbu	a5,0(a0)
    80000faa:	cf91                	beqz	a5,80000fc6 <strlen+0x26>
    80000fac:	0505                	addi	a0,a0,1
    80000fae:	87aa                	mv	a5,a0
    80000fb0:	4685                	li	a3,1
    80000fb2:	9e89                	subw	a3,a3,a0
    80000fb4:	00f6853b          	addw	a0,a3,a5
    80000fb8:	0785                	addi	a5,a5,1
    80000fba:	fff7c703          	lbu	a4,-1(a5)
    80000fbe:	fb7d                	bnez	a4,80000fb4 <strlen+0x14>
    ;
  return n;
}
    80000fc0:	6422                	ld	s0,8(sp)
    80000fc2:	0141                	addi	sp,sp,16
    80000fc4:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fc6:	4501                	li	a0,0
    80000fc8:	bfe5                	j	80000fc0 <strlen+0x20>

0000000080000fca <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000fca:	1141                	addi	sp,sp,-16
    80000fcc:	e406                	sd	ra,8(sp)
    80000fce:	e022                	sd	s0,0(sp)
    80000fd0:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000fd2:	00001097          	auipc	ra,0x1
    80000fd6:	b52080e7          	jalr	-1198(ra) # 80001b24 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000fda:	00008717          	auipc	a4,0x8
    80000fde:	b9e70713          	addi	a4,a4,-1122 # 80008b78 <started>
  if(cpuid() == 0){
    80000fe2:	c139                	beqz	a0,80001028 <main+0x5e>
    while(started == 0)
    80000fe4:	431c                	lw	a5,0(a4)
    80000fe6:	2781                	sext.w	a5,a5
    80000fe8:	dff5                	beqz	a5,80000fe4 <main+0x1a>
      ;
    __sync_synchronize();
    80000fea:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	b36080e7          	jalr	-1226(ra) # 80001b24 <cpuid>
    80000ff6:	85aa                	mv	a1,a0
    80000ff8:	00007517          	auipc	a0,0x7
    80000ffc:	0f850513          	addi	a0,a0,248 # 800080f0 <digits+0xb0>
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	58e080e7          	jalr	1422(ra) # 8000058e <printf>
    kvminithart();    // turn on paging
    80001008:	00000097          	auipc	ra,0x0
    8000100c:	0d8080e7          	jalr	216(ra) # 800010e0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001010:	00002097          	auipc	ra,0x2
    80001014:	aa6080e7          	jalr	-1370(ra) # 80002ab6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001018:	00005097          	auipc	ra,0x5
    8000101c:	2f8080e7          	jalr	760(ra) # 80006310 <plicinithart>
  }

  scheduler();        
    80001020:	00001097          	auipc	ra,0x1
    80001024:	1e4080e7          	jalr	484(ra) # 80002204 <scheduler>
    consoleinit();
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	42e080e7          	jalr	1070(ra) # 80000456 <consoleinit>
    printfinit();
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	744080e7          	jalr	1860(ra) # 80000774 <printfinit>
    printf("\n");
    80001038:	00007517          	auipc	a0,0x7
    8000103c:	0c850513          	addi	a0,a0,200 # 80008100 <digits+0xc0>
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	54e080e7          	jalr	1358(ra) # 8000058e <printf>
    printf("xv6 kernel is booting\n");
    80001048:	00007517          	auipc	a0,0x7
    8000104c:	09050513          	addi	a0,a0,144 # 800080d8 <digits+0x98>
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	53e080e7          	jalr	1342(ra) # 8000058e <printf>
    printf("\n");
    80001058:	00007517          	auipc	a0,0x7
    8000105c:	0a850513          	addi	a0,a0,168 # 80008100 <digits+0xc0>
    80001060:	fffff097          	auipc	ra,0xfffff
    80001064:	52e080e7          	jalr	1326(ra) # 8000058e <printf>
    kinit();         // physical page allocator
    80001068:	00000097          	auipc	ra,0x0
    8000106c:	b54080e7          	jalr	-1196(ra) # 80000bbc <kinit>
    kvminit();       // create kernel page table
    80001070:	00000097          	auipc	ra,0x0
    80001074:	326080e7          	jalr	806(ra) # 80001396 <kvminit>
    kvminithart();   // turn on paging
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	068080e7          	jalr	104(ra) # 800010e0 <kvminithart>
    procinit();      // process table
    80001080:	00001097          	auipc	ra,0x1
    80001084:	9f0080e7          	jalr	-1552(ra) # 80001a70 <procinit>
    trapinit();      // trap vectors
    80001088:	00002097          	auipc	ra,0x2
    8000108c:	a06080e7          	jalr	-1530(ra) # 80002a8e <trapinit>
    trapinithart();  // install kernel trap vector
    80001090:	00002097          	auipc	ra,0x2
    80001094:	a26080e7          	jalr	-1498(ra) # 80002ab6 <trapinithart>
    plicinit();      // set up interrupt controller
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	262080e7          	jalr	610(ra) # 800062fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	270080e7          	jalr	624(ra) # 80006310 <plicinithart>
    binit();         // buffer cache
    800010a8:	00002097          	auipc	ra,0x2
    800010ac:	41c080e7          	jalr	1052(ra) # 800034c4 <binit>
    iinit();         // inode table
    800010b0:	00003097          	auipc	ra,0x3
    800010b4:	ac0080e7          	jalr	-1344(ra) # 80003b70 <iinit>
    fileinit();      // file table
    800010b8:	00004097          	auipc	ra,0x4
    800010bc:	a5e080e7          	jalr	-1442(ra) # 80004b16 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010c0:	00005097          	auipc	ra,0x5
    800010c4:	358080e7          	jalr	856(ra) # 80006418 <virtio_disk_init>
    userinit();      // first user process
    800010c8:	00001097          	auipc	ra,0x1
    800010cc:	dca080e7          	jalr	-566(ra) # 80001e92 <userinit>
    __sync_synchronize();
    800010d0:	0ff0000f          	fence
    started = 1;
    800010d4:	4785                	li	a5,1
    800010d6:	00008717          	auipc	a4,0x8
    800010da:	aaf72123          	sw	a5,-1374(a4) # 80008b78 <started>
    800010de:	b789                	j	80001020 <main+0x56>

00000000800010e0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800010e0:	1141                	addi	sp,sp,-16
    800010e2:	e422                	sd	s0,8(sp)
    800010e4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800010e6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800010ea:	00008797          	auipc	a5,0x8
    800010ee:	a967b783          	ld	a5,-1386(a5) # 80008b80 <kernel_pagetable>
    800010f2:	83b1                	srli	a5,a5,0xc
    800010f4:	577d                	li	a4,-1
    800010f6:	177e                	slli	a4,a4,0x3f
    800010f8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800010fa:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800010fe:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001102:	6422                	ld	s0,8(sp)
    80001104:	0141                	addi	sp,sp,16
    80001106:	8082                	ret

0000000080001108 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001108:	7139                	addi	sp,sp,-64
    8000110a:	fc06                	sd	ra,56(sp)
    8000110c:	f822                	sd	s0,48(sp)
    8000110e:	f426                	sd	s1,40(sp)
    80001110:	f04a                	sd	s2,32(sp)
    80001112:	ec4e                	sd	s3,24(sp)
    80001114:	e852                	sd	s4,16(sp)
    80001116:	e456                	sd	s5,8(sp)
    80001118:	e05a                	sd	s6,0(sp)
    8000111a:	0080                	addi	s0,sp,64
    8000111c:	84aa                	mv	s1,a0
    8000111e:	89ae                	mv	s3,a1
    80001120:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001122:	57fd                	li	a5,-1
    80001124:	83e9                	srli	a5,a5,0x1a
    80001126:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001128:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000112a:	04b7f263          	bgeu	a5,a1,8000116e <walk+0x66>
    panic("walk");
    8000112e:	00007517          	auipc	a0,0x7
    80001132:	fda50513          	addi	a0,a0,-38 # 80008108 <digits+0xc8>
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	40e080e7          	jalr	1038(ra) # 80000544 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000113e:	060a8663          	beqz	s5,800011aa <walk+0xa2>
    80001142:	00000097          	auipc	ra,0x0
    80001146:	ab6080e7          	jalr	-1354(ra) # 80000bf8 <kalloc>
    8000114a:	84aa                	mv	s1,a0
    8000114c:	c529                	beqz	a0,80001196 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000114e:	6605                	lui	a2,0x1
    80001150:	4581                	li	a1,0
    80001152:	00000097          	auipc	ra,0x0
    80001156:	cca080e7          	jalr	-822(ra) # 80000e1c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000115a:	00c4d793          	srli	a5,s1,0xc
    8000115e:	07aa                	slli	a5,a5,0xa
    80001160:	0017e793          	ori	a5,a5,1
    80001164:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001168:	3a5d                	addiw	s4,s4,-9
    8000116a:	036a0063          	beq	s4,s6,8000118a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000116e:	0149d933          	srl	s2,s3,s4
    80001172:	1ff97913          	andi	s2,s2,511
    80001176:	090e                	slli	s2,s2,0x3
    80001178:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000117a:	00093483          	ld	s1,0(s2)
    8000117e:	0014f793          	andi	a5,s1,1
    80001182:	dfd5                	beqz	a5,8000113e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001184:	80a9                	srli	s1,s1,0xa
    80001186:	04b2                	slli	s1,s1,0xc
    80001188:	b7c5                	j	80001168 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000118a:	00c9d513          	srli	a0,s3,0xc
    8000118e:	1ff57513          	andi	a0,a0,511
    80001192:	050e                	slli	a0,a0,0x3
    80001194:	9526                	add	a0,a0,s1
}
    80001196:	70e2                	ld	ra,56(sp)
    80001198:	7442                	ld	s0,48(sp)
    8000119a:	74a2                	ld	s1,40(sp)
    8000119c:	7902                	ld	s2,32(sp)
    8000119e:	69e2                	ld	s3,24(sp)
    800011a0:	6a42                	ld	s4,16(sp)
    800011a2:	6aa2                	ld	s5,8(sp)
    800011a4:	6b02                	ld	s6,0(sp)
    800011a6:	6121                	addi	sp,sp,64
    800011a8:	8082                	ret
        return 0;
    800011aa:	4501                	li	a0,0
    800011ac:	b7ed                	j	80001196 <walk+0x8e>

00000000800011ae <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800011ae:	57fd                	li	a5,-1
    800011b0:	83e9                	srli	a5,a5,0x1a
    800011b2:	00b7f463          	bgeu	a5,a1,800011ba <walkaddr+0xc>
    return 0;
    800011b6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011b8:	8082                	ret
{
    800011ba:	1141                	addi	sp,sp,-16
    800011bc:	e406                	sd	ra,8(sp)
    800011be:	e022                	sd	s0,0(sp)
    800011c0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011c2:	4601                	li	a2,0
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	f44080e7          	jalr	-188(ra) # 80001108 <walk>
  if(pte == 0)
    800011cc:	c105                	beqz	a0,800011ec <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800011ce:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800011d0:	0117f693          	andi	a3,a5,17
    800011d4:	4745                	li	a4,17
    return 0;
    800011d6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011d8:	00e68663          	beq	a3,a4,800011e4 <walkaddr+0x36>
}
    800011dc:	60a2                	ld	ra,8(sp)
    800011de:	6402                	ld	s0,0(sp)
    800011e0:	0141                	addi	sp,sp,16
    800011e2:	8082                	ret
  pa = PTE2PA(*pte);
    800011e4:	00a7d513          	srli	a0,a5,0xa
    800011e8:	0532                	slli	a0,a0,0xc
  return pa;
    800011ea:	bfcd                	j	800011dc <walkaddr+0x2e>
    return 0;
    800011ec:	4501                	li	a0,0
    800011ee:	b7fd                	j	800011dc <walkaddr+0x2e>

00000000800011f0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800011f0:	715d                	addi	sp,sp,-80
    800011f2:	e486                	sd	ra,72(sp)
    800011f4:	e0a2                	sd	s0,64(sp)
    800011f6:	fc26                	sd	s1,56(sp)
    800011f8:	f84a                	sd	s2,48(sp)
    800011fa:	f44e                	sd	s3,40(sp)
    800011fc:	f052                	sd	s4,32(sp)
    800011fe:	ec56                	sd	s5,24(sp)
    80001200:	e85a                	sd	s6,16(sp)
    80001202:	e45e                	sd	s7,8(sp)
    80001204:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001206:	c205                	beqz	a2,80001226 <mappages+0x36>
    80001208:	8aaa                	mv	s5,a0
    8000120a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000120c:	77fd                	lui	a5,0xfffff
    8000120e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80001212:	15fd                	addi	a1,a1,-1
    80001214:	00c589b3          	add	s3,a1,a2
    80001218:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000121c:	8952                	mv	s2,s4
    8000121e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001222:	6b85                	lui	s7,0x1
    80001224:	a015                	j	80001248 <mappages+0x58>
    panic("mappages: size");
    80001226:	00007517          	auipc	a0,0x7
    8000122a:	eea50513          	addi	a0,a0,-278 # 80008110 <digits+0xd0>
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	316080e7          	jalr	790(ra) # 80000544 <panic>
      panic("mappages: remap");
    80001236:	00007517          	auipc	a0,0x7
    8000123a:	eea50513          	addi	a0,a0,-278 # 80008120 <digits+0xe0>
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	306080e7          	jalr	774(ra) # 80000544 <panic>
    a += PGSIZE;
    80001246:	995e                	add	s2,s2,s7
  for(;;){
    80001248:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000124c:	4605                	li	a2,1
    8000124e:	85ca                	mv	a1,s2
    80001250:	8556                	mv	a0,s5
    80001252:	00000097          	auipc	ra,0x0
    80001256:	eb6080e7          	jalr	-330(ra) # 80001108 <walk>
    8000125a:	cd19                	beqz	a0,80001278 <mappages+0x88>
    if(*pte & PTE_V)
    8000125c:	611c                	ld	a5,0(a0)
    8000125e:	8b85                	andi	a5,a5,1
    80001260:	fbf9                	bnez	a5,80001236 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001262:	80b1                	srli	s1,s1,0xc
    80001264:	04aa                	slli	s1,s1,0xa
    80001266:	0164e4b3          	or	s1,s1,s6
    8000126a:	0014e493          	ori	s1,s1,1
    8000126e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001270:	fd391be3          	bne	s2,s3,80001246 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80001274:	4501                	li	a0,0
    80001276:	a011                	j	8000127a <mappages+0x8a>
      return -1;
    80001278:	557d                	li	a0,-1
}
    8000127a:	60a6                	ld	ra,72(sp)
    8000127c:	6406                	ld	s0,64(sp)
    8000127e:	74e2                	ld	s1,56(sp)
    80001280:	7942                	ld	s2,48(sp)
    80001282:	79a2                	ld	s3,40(sp)
    80001284:	7a02                	ld	s4,32(sp)
    80001286:	6ae2                	ld	s5,24(sp)
    80001288:	6b42                	ld	s6,16(sp)
    8000128a:	6ba2                	ld	s7,8(sp)
    8000128c:	6161                	addi	sp,sp,80
    8000128e:	8082                	ret

0000000080001290 <kvmmap>:
{
    80001290:	1141                	addi	sp,sp,-16
    80001292:	e406                	sd	ra,8(sp)
    80001294:	e022                	sd	s0,0(sp)
    80001296:	0800                	addi	s0,sp,16
    80001298:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000129a:	86b2                	mv	a3,a2
    8000129c:	863e                	mv	a2,a5
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	f52080e7          	jalr	-174(ra) # 800011f0 <mappages>
    800012a6:	e509                	bnez	a0,800012b0 <kvmmap+0x20>
}
    800012a8:	60a2                	ld	ra,8(sp)
    800012aa:	6402                	ld	s0,0(sp)
    800012ac:	0141                	addi	sp,sp,16
    800012ae:	8082                	ret
    panic("kvmmap");
    800012b0:	00007517          	auipc	a0,0x7
    800012b4:	e8050513          	addi	a0,a0,-384 # 80008130 <digits+0xf0>
    800012b8:	fffff097          	auipc	ra,0xfffff
    800012bc:	28c080e7          	jalr	652(ra) # 80000544 <panic>

00000000800012c0 <kvmmake>:
{
    800012c0:	1101                	addi	sp,sp,-32
    800012c2:	ec06                	sd	ra,24(sp)
    800012c4:	e822                	sd	s0,16(sp)
    800012c6:	e426                	sd	s1,8(sp)
    800012c8:	e04a                	sd	s2,0(sp)
    800012ca:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800012cc:	00000097          	auipc	ra,0x0
    800012d0:	92c080e7          	jalr	-1748(ra) # 80000bf8 <kalloc>
    800012d4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012d6:	6605                	lui	a2,0x1
    800012d8:	4581                	li	a1,0
    800012da:	00000097          	auipc	ra,0x0
    800012de:	b42080e7          	jalr	-1214(ra) # 80000e1c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012e2:	4719                	li	a4,6
    800012e4:	6685                	lui	a3,0x1
    800012e6:	10000637          	lui	a2,0x10000
    800012ea:	100005b7          	lui	a1,0x10000
    800012ee:	8526                	mv	a0,s1
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	fa0080e7          	jalr	-96(ra) # 80001290 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012f8:	4719                	li	a4,6
    800012fa:	6685                	lui	a3,0x1
    800012fc:	10001637          	lui	a2,0x10001
    80001300:	100015b7          	lui	a1,0x10001
    80001304:	8526                	mv	a0,s1
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	f8a080e7          	jalr	-118(ra) # 80001290 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000130e:	4719                	li	a4,6
    80001310:	004006b7          	lui	a3,0x400
    80001314:	0c000637          	lui	a2,0xc000
    80001318:	0c0005b7          	lui	a1,0xc000
    8000131c:	8526                	mv	a0,s1
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	f72080e7          	jalr	-142(ra) # 80001290 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001326:	00007917          	auipc	s2,0x7
    8000132a:	cda90913          	addi	s2,s2,-806 # 80008000 <etext>
    8000132e:	4729                	li	a4,10
    80001330:	80007697          	auipc	a3,0x80007
    80001334:	cd068693          	addi	a3,a3,-816 # 8000 <_entry-0x7fff8000>
    80001338:	4605                	li	a2,1
    8000133a:	067e                	slli	a2,a2,0x1f
    8000133c:	85b2                	mv	a1,a2
    8000133e:	8526                	mv	a0,s1
    80001340:	00000097          	auipc	ra,0x0
    80001344:	f50080e7          	jalr	-176(ra) # 80001290 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001348:	4719                	li	a4,6
    8000134a:	46c5                	li	a3,17
    8000134c:	06ee                	slli	a3,a3,0x1b
    8000134e:	412686b3          	sub	a3,a3,s2
    80001352:	864a                	mv	a2,s2
    80001354:	85ca                	mv	a1,s2
    80001356:	8526                	mv	a0,s1
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	f38080e7          	jalr	-200(ra) # 80001290 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001360:	4729                	li	a4,10
    80001362:	6685                	lui	a3,0x1
    80001364:	00006617          	auipc	a2,0x6
    80001368:	c9c60613          	addi	a2,a2,-868 # 80007000 <_trampoline>
    8000136c:	040005b7          	lui	a1,0x4000
    80001370:	15fd                	addi	a1,a1,-1
    80001372:	05b2                	slli	a1,a1,0xc
    80001374:	8526                	mv	a0,s1
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	f1a080e7          	jalr	-230(ra) # 80001290 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000137e:	8526                	mv	a0,s1
    80001380:	00000097          	auipc	ra,0x0
    80001384:	65a080e7          	jalr	1626(ra) # 800019da <proc_mapstacks>
}
    80001388:	8526                	mv	a0,s1
    8000138a:	60e2                	ld	ra,24(sp)
    8000138c:	6442                	ld	s0,16(sp)
    8000138e:	64a2                	ld	s1,8(sp)
    80001390:	6902                	ld	s2,0(sp)
    80001392:	6105                	addi	sp,sp,32
    80001394:	8082                	ret

0000000080001396 <kvminit>:
{
    80001396:	1141                	addi	sp,sp,-16
    80001398:	e406                	sd	ra,8(sp)
    8000139a:	e022                	sd	s0,0(sp)
    8000139c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	f22080e7          	jalr	-222(ra) # 800012c0 <kvmmake>
    800013a6:	00007797          	auipc	a5,0x7
    800013aa:	7ca7bd23          	sd	a0,2010(a5) # 80008b80 <kernel_pagetable>
}
    800013ae:	60a2                	ld	ra,8(sp)
    800013b0:	6402                	ld	s0,0(sp)
    800013b2:	0141                	addi	sp,sp,16
    800013b4:	8082                	ret

00000000800013b6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800013b6:	715d                	addi	sp,sp,-80
    800013b8:	e486                	sd	ra,72(sp)
    800013ba:	e0a2                	sd	s0,64(sp)
    800013bc:	fc26                	sd	s1,56(sp)
    800013be:	f84a                	sd	s2,48(sp)
    800013c0:	f44e                	sd	s3,40(sp)
    800013c2:	f052                	sd	s4,32(sp)
    800013c4:	ec56                	sd	s5,24(sp)
    800013c6:	e85a                	sd	s6,16(sp)
    800013c8:	e45e                	sd	s7,8(sp)
    800013ca:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800013cc:	03459793          	slli	a5,a1,0x34
    800013d0:	e795                	bnez	a5,800013fc <uvmunmap+0x46>
    800013d2:	8a2a                	mv	s4,a0
    800013d4:	892e                	mv	s2,a1
    800013d6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013d8:	0632                	slli	a2,a2,0xc
    800013da:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800013de:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013e0:	6b05                	lui	s6,0x1
    800013e2:	0735e863          	bltu	a1,s3,80001452 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800013e6:	60a6                	ld	ra,72(sp)
    800013e8:	6406                	ld	s0,64(sp)
    800013ea:	74e2                	ld	s1,56(sp)
    800013ec:	7942                	ld	s2,48(sp)
    800013ee:	79a2                	ld	s3,40(sp)
    800013f0:	7a02                	ld	s4,32(sp)
    800013f2:	6ae2                	ld	s5,24(sp)
    800013f4:	6b42                	ld	s6,16(sp)
    800013f6:	6ba2                	ld	s7,8(sp)
    800013f8:	6161                	addi	sp,sp,80
    800013fa:	8082                	ret
    panic("uvmunmap: not aligned");
    800013fc:	00007517          	auipc	a0,0x7
    80001400:	d3c50513          	addi	a0,a0,-708 # 80008138 <digits+0xf8>
    80001404:	fffff097          	auipc	ra,0xfffff
    80001408:	140080e7          	jalr	320(ra) # 80000544 <panic>
      panic("uvmunmap: walk");
    8000140c:	00007517          	auipc	a0,0x7
    80001410:	d4450513          	addi	a0,a0,-700 # 80008150 <digits+0x110>
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	130080e7          	jalr	304(ra) # 80000544 <panic>
      panic("uvmunmap: not mapped");
    8000141c:	00007517          	auipc	a0,0x7
    80001420:	d4450513          	addi	a0,a0,-700 # 80008160 <digits+0x120>
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	120080e7          	jalr	288(ra) # 80000544 <panic>
      panic("uvmunmap: not a leaf");
    8000142c:	00007517          	auipc	a0,0x7
    80001430:	d4c50513          	addi	a0,a0,-692 # 80008178 <digits+0x138>
    80001434:	fffff097          	auipc	ra,0xfffff
    80001438:	110080e7          	jalr	272(ra) # 80000544 <panic>
      uint64 pa = PTE2PA(*pte);
    8000143c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000143e:	0532                	slli	a0,a0,0xc
    80001440:	fffff097          	auipc	ra,0xfffff
    80001444:	636080e7          	jalr	1590(ra) # 80000a76 <kfree>
    *pte = 0;
    80001448:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000144c:	995a                	add	s2,s2,s6
    8000144e:	f9397ce3          	bgeu	s2,s3,800013e6 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001452:	4601                	li	a2,0
    80001454:	85ca                	mv	a1,s2
    80001456:	8552                	mv	a0,s4
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	cb0080e7          	jalr	-848(ra) # 80001108 <walk>
    80001460:	84aa                	mv	s1,a0
    80001462:	d54d                	beqz	a0,8000140c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001464:	6108                	ld	a0,0(a0)
    80001466:	00157793          	andi	a5,a0,1
    8000146a:	dbcd                	beqz	a5,8000141c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000146c:	3ff57793          	andi	a5,a0,1023
    80001470:	fb778ee3          	beq	a5,s7,8000142c <uvmunmap+0x76>
    if(do_free){
    80001474:	fc0a8ae3          	beqz	s5,80001448 <uvmunmap+0x92>
    80001478:	b7d1                	j	8000143c <uvmunmap+0x86>

000000008000147a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000147a:	1101                	addi	sp,sp,-32
    8000147c:	ec06                	sd	ra,24(sp)
    8000147e:	e822                	sd	s0,16(sp)
    80001480:	e426                	sd	s1,8(sp)
    80001482:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	774080e7          	jalr	1908(ra) # 80000bf8 <kalloc>
    8000148c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000148e:	c519                	beqz	a0,8000149c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001490:	6605                	lui	a2,0x1
    80001492:	4581                	li	a1,0
    80001494:	00000097          	auipc	ra,0x0
    80001498:	988080e7          	jalr	-1656(ra) # 80000e1c <memset>
  return pagetable;
}
    8000149c:	8526                	mv	a0,s1
    8000149e:	60e2                	ld	ra,24(sp)
    800014a0:	6442                	ld	s0,16(sp)
    800014a2:	64a2                	ld	s1,8(sp)
    800014a4:	6105                	addi	sp,sp,32
    800014a6:	8082                	ret

00000000800014a8 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800014a8:	7179                	addi	sp,sp,-48
    800014aa:	f406                	sd	ra,40(sp)
    800014ac:	f022                	sd	s0,32(sp)
    800014ae:	ec26                	sd	s1,24(sp)
    800014b0:	e84a                	sd	s2,16(sp)
    800014b2:	e44e                	sd	s3,8(sp)
    800014b4:	e052                	sd	s4,0(sp)
    800014b6:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800014b8:	6785                	lui	a5,0x1
    800014ba:	04f67863          	bgeu	a2,a5,8000150a <uvmfirst+0x62>
    800014be:	8a2a                	mv	s4,a0
    800014c0:	89ae                	mv	s3,a1
    800014c2:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800014c4:	fffff097          	auipc	ra,0xfffff
    800014c8:	734080e7          	jalr	1844(ra) # 80000bf8 <kalloc>
    800014cc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014ce:	6605                	lui	a2,0x1
    800014d0:	4581                	li	a1,0
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	94a080e7          	jalr	-1718(ra) # 80000e1c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014da:	4779                	li	a4,30
    800014dc:	86ca                	mv	a3,s2
    800014de:	6605                	lui	a2,0x1
    800014e0:	4581                	li	a1,0
    800014e2:	8552                	mv	a0,s4
    800014e4:	00000097          	auipc	ra,0x0
    800014e8:	d0c080e7          	jalr	-756(ra) # 800011f0 <mappages>
  memmove(mem, src, sz);
    800014ec:	8626                	mv	a2,s1
    800014ee:	85ce                	mv	a1,s3
    800014f0:	854a                	mv	a0,s2
    800014f2:	00000097          	auipc	ra,0x0
    800014f6:	98a080e7          	jalr	-1654(ra) # 80000e7c <memmove>
}
    800014fa:	70a2                	ld	ra,40(sp)
    800014fc:	7402                	ld	s0,32(sp)
    800014fe:	64e2                	ld	s1,24(sp)
    80001500:	6942                	ld	s2,16(sp)
    80001502:	69a2                	ld	s3,8(sp)
    80001504:	6a02                	ld	s4,0(sp)
    80001506:	6145                	addi	sp,sp,48
    80001508:	8082                	ret
    panic("uvmfirst: more than a page");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	c8650513          	addi	a0,a0,-890 # 80008190 <digits+0x150>
    80001512:	fffff097          	auipc	ra,0xfffff
    80001516:	032080e7          	jalr	50(ra) # 80000544 <panic>

000000008000151a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000151a:	1101                	addi	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001524:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001526:	00b67d63          	bgeu	a2,a1,80001540 <uvmdealloc+0x26>
    8000152a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000152c:	6785                	lui	a5,0x1
    8000152e:	17fd                	addi	a5,a5,-1
    80001530:	00f60733          	add	a4,a2,a5
    80001534:	767d                	lui	a2,0xfffff
    80001536:	8f71                	and	a4,a4,a2
    80001538:	97ae                	add	a5,a5,a1
    8000153a:	8ff1                	and	a5,a5,a2
    8000153c:	00f76863          	bltu	a4,a5,8000154c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001540:	8526                	mv	a0,s1
    80001542:	60e2                	ld	ra,24(sp)
    80001544:	6442                	ld	s0,16(sp)
    80001546:	64a2                	ld	s1,8(sp)
    80001548:	6105                	addi	sp,sp,32
    8000154a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000154c:	8f99                	sub	a5,a5,a4
    8000154e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001550:	4685                	li	a3,1
    80001552:	0007861b          	sext.w	a2,a5
    80001556:	85ba                	mv	a1,a4
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	e5e080e7          	jalr	-418(ra) # 800013b6 <uvmunmap>
    80001560:	b7c5                	j	80001540 <uvmdealloc+0x26>

0000000080001562 <uvmalloc>:
  if(newsz < oldsz)
    80001562:	0ab66563          	bltu	a2,a1,8000160c <uvmalloc+0xaa>
{
    80001566:	7139                	addi	sp,sp,-64
    80001568:	fc06                	sd	ra,56(sp)
    8000156a:	f822                	sd	s0,48(sp)
    8000156c:	f426                	sd	s1,40(sp)
    8000156e:	f04a                	sd	s2,32(sp)
    80001570:	ec4e                	sd	s3,24(sp)
    80001572:	e852                	sd	s4,16(sp)
    80001574:	e456                	sd	s5,8(sp)
    80001576:	e05a                	sd	s6,0(sp)
    80001578:	0080                	addi	s0,sp,64
    8000157a:	8aaa                	mv	s5,a0
    8000157c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000157e:	6985                	lui	s3,0x1
    80001580:	19fd                	addi	s3,s3,-1
    80001582:	95ce                	add	a1,a1,s3
    80001584:	79fd                	lui	s3,0xfffff
    80001586:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000158a:	08c9f363          	bgeu	s3,a2,80001610 <uvmalloc+0xae>
    8000158e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001590:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001594:	fffff097          	auipc	ra,0xfffff
    80001598:	664080e7          	jalr	1636(ra) # 80000bf8 <kalloc>
    8000159c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000159e:	c51d                	beqz	a0,800015cc <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800015a0:	6605                	lui	a2,0x1
    800015a2:	4581                	li	a1,0
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	878080e7          	jalr	-1928(ra) # 80000e1c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015ac:	875a                	mv	a4,s6
    800015ae:	86a6                	mv	a3,s1
    800015b0:	6605                	lui	a2,0x1
    800015b2:	85ca                	mv	a1,s2
    800015b4:	8556                	mv	a0,s5
    800015b6:	00000097          	auipc	ra,0x0
    800015ba:	c3a080e7          	jalr	-966(ra) # 800011f0 <mappages>
    800015be:	e90d                	bnez	a0,800015f0 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015c0:	6785                	lui	a5,0x1
    800015c2:	993e                	add	s2,s2,a5
    800015c4:	fd4968e3          	bltu	s2,s4,80001594 <uvmalloc+0x32>
  return newsz;
    800015c8:	8552                	mv	a0,s4
    800015ca:	a809                	j	800015dc <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    800015cc:	864e                	mv	a2,s3
    800015ce:	85ca                	mv	a1,s2
    800015d0:	8556                	mv	a0,s5
    800015d2:	00000097          	auipc	ra,0x0
    800015d6:	f48080e7          	jalr	-184(ra) # 8000151a <uvmdealloc>
      return 0;
    800015da:	4501                	li	a0,0
}
    800015dc:	70e2                	ld	ra,56(sp)
    800015de:	7442                	ld	s0,48(sp)
    800015e0:	74a2                	ld	s1,40(sp)
    800015e2:	7902                	ld	s2,32(sp)
    800015e4:	69e2                	ld	s3,24(sp)
    800015e6:	6a42                	ld	s4,16(sp)
    800015e8:	6aa2                	ld	s5,8(sp)
    800015ea:	6b02                	ld	s6,0(sp)
    800015ec:	6121                	addi	sp,sp,64
    800015ee:	8082                	ret
      kfree(mem);
    800015f0:	8526                	mv	a0,s1
    800015f2:	fffff097          	auipc	ra,0xfffff
    800015f6:	484080e7          	jalr	1156(ra) # 80000a76 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015fa:	864e                	mv	a2,s3
    800015fc:	85ca                	mv	a1,s2
    800015fe:	8556                	mv	a0,s5
    80001600:	00000097          	auipc	ra,0x0
    80001604:	f1a080e7          	jalr	-230(ra) # 8000151a <uvmdealloc>
      return 0;
    80001608:	4501                	li	a0,0
    8000160a:	bfc9                	j	800015dc <uvmalloc+0x7a>
    return oldsz;
    8000160c:	852e                	mv	a0,a1
}
    8000160e:	8082                	ret
  return newsz;
    80001610:	8532                	mv	a0,a2
    80001612:	b7e9                	j	800015dc <uvmalloc+0x7a>

0000000080001614 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001614:	7179                	addi	sp,sp,-48
    80001616:	f406                	sd	ra,40(sp)
    80001618:	f022                	sd	s0,32(sp)
    8000161a:	ec26                	sd	s1,24(sp)
    8000161c:	e84a                	sd	s2,16(sp)
    8000161e:	e44e                	sd	s3,8(sp)
    80001620:	e052                	sd	s4,0(sp)
    80001622:	1800                	addi	s0,sp,48
    80001624:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001626:	84aa                	mv	s1,a0
    80001628:	6905                	lui	s2,0x1
    8000162a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000162c:	4985                	li	s3,1
    8000162e:	a821                	j	80001646 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001630:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001632:	0532                	slli	a0,a0,0xc
    80001634:	00000097          	auipc	ra,0x0
    80001638:	fe0080e7          	jalr	-32(ra) # 80001614 <freewalk>
      pagetable[i] = 0;
    8000163c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001640:	04a1                	addi	s1,s1,8
    80001642:	03248163          	beq	s1,s2,80001664 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001646:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001648:	00f57793          	andi	a5,a0,15
    8000164c:	ff3782e3          	beq	a5,s3,80001630 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001650:	8905                	andi	a0,a0,1
    80001652:	d57d                	beqz	a0,80001640 <freewalk+0x2c>
      panic("freewalk: leaf");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	b5c50513          	addi	a0,a0,-1188 # 800081b0 <digits+0x170>
    8000165c:	fffff097          	auipc	ra,0xfffff
    80001660:	ee8080e7          	jalr	-280(ra) # 80000544 <panic>
    }
  }
  kfree((void*)pagetable);
    80001664:	8552                	mv	a0,s4
    80001666:	fffff097          	auipc	ra,0xfffff
    8000166a:	410080e7          	jalr	1040(ra) # 80000a76 <kfree>
}
    8000166e:	70a2                	ld	ra,40(sp)
    80001670:	7402                	ld	s0,32(sp)
    80001672:	64e2                	ld	s1,24(sp)
    80001674:	6942                	ld	s2,16(sp)
    80001676:	69a2                	ld	s3,8(sp)
    80001678:	6a02                	ld	s4,0(sp)
    8000167a:	6145                	addi	sp,sp,48
    8000167c:	8082                	ret

000000008000167e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000167e:	1101                	addi	sp,sp,-32
    80001680:	ec06                	sd	ra,24(sp)
    80001682:	e822                	sd	s0,16(sp)
    80001684:	e426                	sd	s1,8(sp)
    80001686:	1000                	addi	s0,sp,32
    80001688:	84aa                	mv	s1,a0
  if(sz > 0)
    8000168a:	e999                	bnez	a1,800016a0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	f86080e7          	jalr	-122(ra) # 80001614 <freewalk>
}
    80001696:	60e2                	ld	ra,24(sp)
    80001698:	6442                	ld	s0,16(sp)
    8000169a:	64a2                	ld	s1,8(sp)
    8000169c:	6105                	addi	sp,sp,32
    8000169e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800016a0:	6605                	lui	a2,0x1
    800016a2:	167d                	addi	a2,a2,-1
    800016a4:	962e                	add	a2,a2,a1
    800016a6:	4685                	li	a3,1
    800016a8:	8231                	srli	a2,a2,0xc
    800016aa:	4581                	li	a1,0
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	d0a080e7          	jalr	-758(ra) # 800013b6 <uvmunmap>
    800016b4:	bfe1                	j	8000168c <uvmfree+0xe>

00000000800016b6 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE)
    800016b6:	ca55                	beqz	a2,8000176a <uvmcopy+0xb4>
{
    800016b8:	7139                	addi	sp,sp,-64
    800016ba:	fc06                	sd	ra,56(sp)
    800016bc:	f822                	sd	s0,48(sp)
    800016be:	f426                	sd	s1,40(sp)
    800016c0:	f04a                	sd	s2,32(sp)
    800016c2:	ec4e                	sd	s3,24(sp)
    800016c4:	e852                	sd	s4,16(sp)
    800016c6:	e456                	sd	s5,8(sp)
    800016c8:	e05a                	sd	s6,0(sp)
    800016ca:	0080                	addi	s0,sp,64
    800016cc:	8b2a                	mv	s6,a0
    800016ce:	8aae                	mv	s5,a1
    800016d0:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE)
    800016d2:	4901                	li	s2,0
  {
    if ((pte = walk(old, i, 0)) == 0)
    800016d4:	4601                	li	a2,0
    800016d6:	85ca                	mv	a1,s2
    800016d8:	855a                	mv	a0,s6
    800016da:	00000097          	auipc	ra,0x0
    800016de:	a2e080e7          	jalr	-1490(ra) # 80001108 <walk>
    800016e2:	c121                	beqz	a0,80001722 <uvmcopy+0x6c>
      panic("uvmcopy: pte should exist");
    if ((*pte & PTE_V) == 0)
    800016e4:	6118                	ld	a4,0(a0)
    800016e6:	00177793          	andi	a5,a4,1
    800016ea:	c7a1                	beqz	a5,80001732 <uvmcopy+0x7c>
      panic("uvmcopy: page not present");
    //fix the permission bits
    pa = PTE2PA(*pte);
    800016ec:	00a75993          	srli	s3,a4,0xa
    800016f0:	09b2                	slli	s3,s3,0xc
    *pte &= ~PTE_W;
    800016f2:	ffb77493          	andi	s1,a4,-5
    800016f6:	e104                	sd	s1,0(a0)
	//not allocated
    // if((mem = kalloc()) == 0)
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);
	//increase refcnt
    increse(pa);
    800016f8:	854e                	mv	a0,s3
    800016fa:	fffff097          	auipc	ra,0xfffff
    800016fe:	304080e7          	jalr	772(ra) # 800009fe <increse>
    //map the va to the same pa using flags
    if (mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    80001702:	3fb4f713          	andi	a4,s1,1019
    80001706:	86ce                	mv	a3,s3
    80001708:	6605                	lui	a2,0x1
    8000170a:	85ca                	mv	a1,s2
    8000170c:	8556                	mv	a0,s5
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	ae2080e7          	jalr	-1310(ra) # 800011f0 <mappages>
    80001716:	e515                	bnez	a0,80001742 <uvmcopy+0x8c>
  for (i = 0; i < sz; i += PGSIZE)
    80001718:	6785                	lui	a5,0x1
    8000171a:	993e                	add	s2,s2,a5
    8000171c:	fb496ce3          	bltu	s2,s4,800016d4 <uvmcopy+0x1e>
    80001720:	a81d                	j	80001756 <uvmcopy+0xa0>
      panic("uvmcopy: pte should exist");
    80001722:	00007517          	auipc	a0,0x7
    80001726:	a9e50513          	addi	a0,a0,-1378 # 800081c0 <digits+0x180>
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	e1a080e7          	jalr	-486(ra) # 80000544 <panic>
      panic("uvmcopy: page not present");
    80001732:	00007517          	auipc	a0,0x7
    80001736:	aae50513          	addi	a0,a0,-1362 # 800081e0 <digits+0x1a0>
    8000173a:	fffff097          	auipc	ra,0xfffff
    8000173e:	e0a080e7          	jalr	-502(ra) # 80000544 <panic>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001742:	4685                	li	a3,1
    80001744:	00c95613          	srli	a2,s2,0xc
    80001748:	4581                	li	a1,0
    8000174a:	8556                	mv	a0,s5
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	c6a080e7          	jalr	-918(ra) # 800013b6 <uvmunmap>
  return -1;
    80001754:	557d                	li	a0,-1
}
    80001756:	70e2                	ld	ra,56(sp)
    80001758:	7442                	ld	s0,48(sp)
    8000175a:	74a2                	ld	s1,40(sp)
    8000175c:	7902                	ld	s2,32(sp)
    8000175e:	69e2                	ld	s3,24(sp)
    80001760:	6a42                	ld	s4,16(sp)
    80001762:	6aa2                	ld	s5,8(sp)
    80001764:	6b02                	ld	s6,0(sp)
    80001766:	6121                	addi	sp,sp,64
    80001768:	8082                	ret
  return 0;
    8000176a:	4501                	li	a0,0
}
    8000176c:	8082                	ret

000000008000176e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000176e:	1141                	addi	sp,sp,-16
    80001770:	e406                	sd	ra,8(sp)
    80001772:	e022                	sd	s0,0(sp)
    80001774:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001776:	4601                	li	a2,0
    80001778:	00000097          	auipc	ra,0x0
    8000177c:	990080e7          	jalr	-1648(ra) # 80001108 <walk>
  if(pte == 0)
    80001780:	c901                	beqz	a0,80001790 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001782:	611c                	ld	a5,0(a0)
    80001784:	9bbd                	andi	a5,a5,-17
    80001786:	e11c                	sd	a5,0(a0)
}
    80001788:	60a2                	ld	ra,8(sp)
    8000178a:	6402                	ld	s0,0(sp)
    8000178c:	0141                	addi	sp,sp,16
    8000178e:	8082                	ret
    panic("uvmclear");
    80001790:	00007517          	auipc	a0,0x7
    80001794:	a7050513          	addi	a0,a0,-1424 # 80008200 <digits+0x1c0>
    80001798:	fffff097          	auipc	ra,0xfffff
    8000179c:	dac080e7          	jalr	-596(ra) # 80000544 <panic>

00000000800017a0 <copyout>:
{
  uint64 n, va0, pa0;
  va0 = PGROUNDDOWN(dstva);


  while(len > 0){
    800017a0:	cad1                	beqz	a3,80001834 <copyout+0x94>
{
    800017a2:	711d                	addi	sp,sp,-96
    800017a4:	ec86                	sd	ra,88(sp)
    800017a6:	e8a2                	sd	s0,80(sp)
    800017a8:	e4a6                	sd	s1,72(sp)
    800017aa:	e0ca                	sd	s2,64(sp)
    800017ac:	fc4e                	sd	s3,56(sp)
    800017ae:	f852                	sd	s4,48(sp)
    800017b0:	f456                	sd	s5,40(sp)
    800017b2:	f05a                	sd	s6,32(sp)
    800017b4:	ec5e                	sd	s7,24(sp)
    800017b6:	e862                	sd	s8,16(sp)
    800017b8:	e466                	sd	s9,8(sp)
    800017ba:	1080                	addi	s0,sp,96
    800017bc:	8baa                	mv	s7,a0
    800017be:	8aae                	mv	s5,a1
    800017c0:	8b32                	mv	s6,a2
    800017c2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800017c4:	74fd                	lui	s1,0xfffff
    800017c6:	8ced                	and	s1,s1,a1
    if (va0 > MAXVA)
    800017c8:	4785                	li	a5,1
    800017ca:	179a                	slli	a5,a5,0x26
    800017cc:	0697e663          	bltu	a5,s1,80001838 <copyout+0x98>
    800017d0:	6c85                	lui	s9,0x1
    800017d2:	04000c37          	lui	s8,0x4000
    800017d6:	0c05                	addi	s8,s8,1
    800017d8:	0c32                	slli	s8,s8,0xc
    800017da:	a025                	j	80001802 <copyout+0x62>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800017dc:	409a84b3          	sub	s1,s5,s1
    800017e0:	0009061b          	sext.w	a2,s2
    800017e4:	85da                	mv	a1,s6
    800017e6:	9526                	add	a0,a0,s1
    800017e8:	fffff097          	auipc	ra,0xfffff
    800017ec:	694080e7          	jalr	1684(ra) # 80000e7c <memmove>

    len -= n;
    800017f0:	412989b3          	sub	s3,s3,s2
    src += n;
    800017f4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800017f6:	02098d63          	beqz	s3,80001830 <copyout+0x90>
    if (va0 > MAXVA)
    800017fa:	058a0163          	beq	s4,s8,8000183c <copyout+0x9c>
    va0 = PGROUNDDOWN(dstva);
    800017fe:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80001800:	8ad2                	mv	s5,s4
    if(cowfault(pagetable,va0)<0){
    80001802:	85a6                	mv	a1,s1
    80001804:	855e                	mv	a0,s7
    80001806:	00001097          	auipc	ra,0x1
    8000180a:	2c8080e7          	jalr	712(ra) # 80002ace <cowfault>
    8000180e:	02054963          	bltz	a0,80001840 <copyout+0xa0>
    pa0 = walkaddr(pagetable, va0);
    80001812:	85a6                	mv	a1,s1
    80001814:	855e                	mv	a0,s7
    80001816:	00000097          	auipc	ra,0x0
    8000181a:	998080e7          	jalr	-1640(ra) # 800011ae <walkaddr>
    if(pa0 == 0)
    8000181e:	cd1d                	beqz	a0,8000185c <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80001820:	01948a33          	add	s4,s1,s9
    80001824:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001828:	fb29fae3          	bgeu	s3,s2,800017dc <copyout+0x3c>
    8000182c:	894e                	mv	s2,s3
    8000182e:	b77d                	j	800017dc <copyout+0x3c>
  }
  return 0;
    80001830:	4501                	li	a0,0
    80001832:	a801                	j	80001842 <copyout+0xa2>
    80001834:	4501                	li	a0,0
}
    80001836:	8082                	ret
	    return -1;
    80001838:	557d                	li	a0,-1
    8000183a:	a021                	j	80001842 <copyout+0xa2>
    8000183c:	557d                	li	a0,-1
    8000183e:	a011                	j	80001842 <copyout+0xa2>
	    return -1;
    80001840:	557d                	li	a0,-1
}
    80001842:	60e6                	ld	ra,88(sp)
    80001844:	6446                	ld	s0,80(sp)
    80001846:	64a6                	ld	s1,72(sp)
    80001848:	6906                	ld	s2,64(sp)
    8000184a:	79e2                	ld	s3,56(sp)
    8000184c:	7a42                	ld	s4,48(sp)
    8000184e:	7aa2                	ld	s5,40(sp)
    80001850:	7b02                	ld	s6,32(sp)
    80001852:	6be2                	ld	s7,24(sp)
    80001854:	6c42                	ld	s8,16(sp)
    80001856:	6ca2                	ld	s9,8(sp)
    80001858:	6125                	addi	sp,sp,96
    8000185a:	8082                	ret
      return -1;
    8000185c:	557d                	li	a0,-1
    8000185e:	b7d5                	j	80001842 <copyout+0xa2>

0000000080001860 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001860:	c6bd                	beqz	a3,800018ce <copyin+0x6e>
{
    80001862:	715d                	addi	sp,sp,-80
    80001864:	e486                	sd	ra,72(sp)
    80001866:	e0a2                	sd	s0,64(sp)
    80001868:	fc26                	sd	s1,56(sp)
    8000186a:	f84a                	sd	s2,48(sp)
    8000186c:	f44e                	sd	s3,40(sp)
    8000186e:	f052                	sd	s4,32(sp)
    80001870:	ec56                	sd	s5,24(sp)
    80001872:	e85a                	sd	s6,16(sp)
    80001874:	e45e                	sd	s7,8(sp)
    80001876:	e062                	sd	s8,0(sp)
    80001878:	0880                	addi	s0,sp,80
    8000187a:	8b2a                	mv	s6,a0
    8000187c:	8a2e                	mv	s4,a1
    8000187e:	8c32                	mv	s8,a2
    80001880:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001882:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001884:	6a85                	lui	s5,0x1
    80001886:	a015                	j	800018aa <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001888:	9562                	add	a0,a0,s8
    8000188a:	0004861b          	sext.w	a2,s1
    8000188e:	412505b3          	sub	a1,a0,s2
    80001892:	8552                	mv	a0,s4
    80001894:	fffff097          	auipc	ra,0xfffff
    80001898:	5e8080e7          	jalr	1512(ra) # 80000e7c <memmove>

    len -= n;
    8000189c:	409989b3          	sub	s3,s3,s1
    dst += n;
    800018a0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800018a2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800018a6:	02098263          	beqz	s3,800018ca <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    800018aa:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800018ae:	85ca                	mv	a1,s2
    800018b0:	855a                	mv	a0,s6
    800018b2:	00000097          	auipc	ra,0x0
    800018b6:	8fc080e7          	jalr	-1796(ra) # 800011ae <walkaddr>
    if(pa0 == 0)
    800018ba:	cd01                	beqz	a0,800018d2 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    800018bc:	418904b3          	sub	s1,s2,s8
    800018c0:	94d6                	add	s1,s1,s5
    if(n > len)
    800018c2:	fc99f3e3          	bgeu	s3,s1,80001888 <copyin+0x28>
    800018c6:	84ce                	mv	s1,s3
    800018c8:	b7c1                	j	80001888 <copyin+0x28>
  }
  return 0;
    800018ca:	4501                	li	a0,0
    800018cc:	a021                	j	800018d4 <copyin+0x74>
    800018ce:	4501                	li	a0,0
}
    800018d0:	8082                	ret
      return -1;
    800018d2:	557d                	li	a0,-1
}
    800018d4:	60a6                	ld	ra,72(sp)
    800018d6:	6406                	ld	s0,64(sp)
    800018d8:	74e2                	ld	s1,56(sp)
    800018da:	7942                	ld	s2,48(sp)
    800018dc:	79a2                	ld	s3,40(sp)
    800018de:	7a02                	ld	s4,32(sp)
    800018e0:	6ae2                	ld	s5,24(sp)
    800018e2:	6b42                	ld	s6,16(sp)
    800018e4:	6ba2                	ld	s7,8(sp)
    800018e6:	6c02                	ld	s8,0(sp)
    800018e8:	6161                	addi	sp,sp,80
    800018ea:	8082                	ret

00000000800018ec <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800018ec:	c6c5                	beqz	a3,80001994 <copyinstr+0xa8>
{
    800018ee:	715d                	addi	sp,sp,-80
    800018f0:	e486                	sd	ra,72(sp)
    800018f2:	e0a2                	sd	s0,64(sp)
    800018f4:	fc26                	sd	s1,56(sp)
    800018f6:	f84a                	sd	s2,48(sp)
    800018f8:	f44e                	sd	s3,40(sp)
    800018fa:	f052                	sd	s4,32(sp)
    800018fc:	ec56                	sd	s5,24(sp)
    800018fe:	e85a                	sd	s6,16(sp)
    80001900:	e45e                	sd	s7,8(sp)
    80001902:	0880                	addi	s0,sp,80
    80001904:	8a2a                	mv	s4,a0
    80001906:	8b2e                	mv	s6,a1
    80001908:	8bb2                	mv	s7,a2
    8000190a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000190c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000190e:	6985                	lui	s3,0x1
    80001910:	a035                	j	8000193c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001912:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001916:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001918:	0017b793          	seqz	a5,a5
    8000191c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001920:	60a6                	ld	ra,72(sp)
    80001922:	6406                	ld	s0,64(sp)
    80001924:	74e2                	ld	s1,56(sp)
    80001926:	7942                	ld	s2,48(sp)
    80001928:	79a2                	ld	s3,40(sp)
    8000192a:	7a02                	ld	s4,32(sp)
    8000192c:	6ae2                	ld	s5,24(sp)
    8000192e:	6b42                	ld	s6,16(sp)
    80001930:	6ba2                	ld	s7,8(sp)
    80001932:	6161                	addi	sp,sp,80
    80001934:	8082                	ret
    srcva = va0 + PGSIZE;
    80001936:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000193a:	c8a9                	beqz	s1,8000198c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    8000193c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001940:	85ca                	mv	a1,s2
    80001942:	8552                	mv	a0,s4
    80001944:	00000097          	auipc	ra,0x0
    80001948:	86a080e7          	jalr	-1942(ra) # 800011ae <walkaddr>
    if(pa0 == 0)
    8000194c:	c131                	beqz	a0,80001990 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    8000194e:	41790833          	sub	a6,s2,s7
    80001952:	984e                	add	a6,a6,s3
    if(n > max)
    80001954:	0104f363          	bgeu	s1,a6,8000195a <copyinstr+0x6e>
    80001958:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000195a:	955e                	add	a0,a0,s7
    8000195c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001960:	fc080be3          	beqz	a6,80001936 <copyinstr+0x4a>
    80001964:	985a                	add	a6,a6,s6
    80001966:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001968:	41650633          	sub	a2,a0,s6
    8000196c:	14fd                	addi	s1,s1,-1
    8000196e:	9b26                	add	s6,s6,s1
    80001970:	00f60733          	add	a4,a2,a5
    80001974:	00074703          	lbu	a4,0(a4)
    80001978:	df49                	beqz	a4,80001912 <copyinstr+0x26>
        *dst = *p;
    8000197a:	00e78023          	sb	a4,0(a5)
      --max;
    8000197e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001982:	0785                	addi	a5,a5,1
    while(n > 0){
    80001984:	ff0796e3          	bne	a5,a6,80001970 <copyinstr+0x84>
      dst++;
    80001988:	8b42                	mv	s6,a6
    8000198a:	b775                	j	80001936 <copyinstr+0x4a>
    8000198c:	4781                	li	a5,0
    8000198e:	b769                	j	80001918 <copyinstr+0x2c>
      return -1;
    80001990:	557d                	li	a0,-1
    80001992:	b779                	j	80001920 <copyinstr+0x34>
  int got_null = 0;
    80001994:	4781                	li	a5,0
  if(got_null){
    80001996:	0017b793          	seqz	a5,a5
    8000199a:	40f00533          	neg	a0,a5
}
    8000199e:	8082                	ret

00000000800019a0 <wakeup1>:
  return 0;
}

static void
wakeup1(void* chan)
{
    800019a0:	1141                	addi	sp,sp,-16
    800019a2:	e422                	sd	s0,8(sp)
    800019a4:	0800                	addi	s0,sp,16
  struct proc *p;
  for(p = proc; p<&proc[NPROC]; p++)
    800019a6:	00230797          	auipc	a5,0x230
    800019aa:	2a278793          	addi	a5,a5,674 # 80231c48 <proc>
  {
    if(p->state == SLEEPING && p->chan == chan)
    800019ae:	4609                	li	a2,2
    {
      p->state = RUNNABLE;
    800019b0:	458d                	li	a1,3
  for(p = proc; p<&proc[NPROC]; p++)
    800019b2:	0023c697          	auipc	a3,0x23c
    800019b6:	c9668693          	addi	a3,a3,-874 # 8023d648 <tickslock>
    800019ba:	a031                	j	800019c6 <wakeup1+0x26>
      p->state = RUNNABLE;
    800019bc:	cf8c                	sw	a1,24(a5)
  for(p = proc; p<&proc[NPROC]; p++)
    800019be:	2e878793          	addi	a5,a5,744
    800019c2:	00d78963          	beq	a5,a3,800019d4 <wakeup1+0x34>
    if(p->state == SLEEPING && p->chan == chan)
    800019c6:	4f98                	lw	a4,24(a5)
    800019c8:	fec71be3          	bne	a4,a2,800019be <wakeup1+0x1e>
    800019cc:	7398                	ld	a4,32(a5)
    800019ce:	fea718e3          	bne	a4,a0,800019be <wakeup1+0x1e>
    800019d2:	b7ed                	j	800019bc <wakeup1+0x1c>
        queue[p->q][qProc[p->q]] = p;
        qProc[p->q]++;
      #endif
    }
  }
}
    800019d4:	6422                	ld	s0,8(sp)
    800019d6:	0141                	addi	sp,sp,16
    800019d8:	8082                	ret

00000000800019da <proc_mapstacks>:
{
    800019da:	7139                	addi	sp,sp,-64
    800019dc:	fc06                	sd	ra,56(sp)
    800019de:	f822                	sd	s0,48(sp)
    800019e0:	f426                	sd	s1,40(sp)
    800019e2:	f04a                	sd	s2,32(sp)
    800019e4:	ec4e                	sd	s3,24(sp)
    800019e6:	e852                	sd	s4,16(sp)
    800019e8:	e456                	sd	s5,8(sp)
    800019ea:	e05a                	sd	s6,0(sp)
    800019ec:	0080                	addi	s0,sp,64
    800019ee:	89aa                	mv	s3,a0
  for (p = proc; p < &proc[NPROC]; p++)
    800019f0:	00230497          	auipc	s1,0x230
    800019f4:	25848493          	addi	s1,s1,600 # 80231c48 <proc>
    uint64 va = KSTACK((int)(p - proc));
    800019f8:	8b26                	mv	s6,s1
    800019fa:	00006a97          	auipc	s5,0x6
    800019fe:	606a8a93          	addi	s5,s5,1542 # 80008000 <etext>
    80001a02:	04000937          	lui	s2,0x4000
    80001a06:	197d                	addi	s2,s2,-1
    80001a08:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001a0a:	0023ca17          	auipc	s4,0x23c
    80001a0e:	c3ea0a13          	addi	s4,s4,-962 # 8023d648 <tickslock>
    char *pa = kalloc();
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	1e6080e7          	jalr	486(ra) # 80000bf8 <kalloc>
    80001a1a:	862a                	mv	a2,a0
    if (pa == 0)
    80001a1c:	c131                	beqz	a0,80001a60 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001a1e:	416485b3          	sub	a1,s1,s6
    80001a22:	858d                	srai	a1,a1,0x3
    80001a24:	000ab783          	ld	a5,0(s5)
    80001a28:	02f585b3          	mul	a1,a1,a5
    80001a2c:	2585                	addiw	a1,a1,1
    80001a2e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a32:	4719                	li	a4,6
    80001a34:	6685                	lui	a3,0x1
    80001a36:	40b905b3          	sub	a1,s2,a1
    80001a3a:	854e                	mv	a0,s3
    80001a3c:	00000097          	auipc	ra,0x0
    80001a40:	854080e7          	jalr	-1964(ra) # 80001290 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a44:	2e848493          	addi	s1,s1,744
    80001a48:	fd4495e3          	bne	s1,s4,80001a12 <proc_mapstacks+0x38>
}
    80001a4c:	70e2                	ld	ra,56(sp)
    80001a4e:	7442                	ld	s0,48(sp)
    80001a50:	74a2                	ld	s1,40(sp)
    80001a52:	7902                	ld	s2,32(sp)
    80001a54:	69e2                	ld	s3,24(sp)
    80001a56:	6a42                	ld	s4,16(sp)
    80001a58:	6aa2                	ld	s5,8(sp)
    80001a5a:	6b02                	ld	s6,0(sp)
    80001a5c:	6121                	addi	sp,sp,64
    80001a5e:	8082                	ret
      panic("kalloc");
    80001a60:	00006517          	auipc	a0,0x6
    80001a64:	7b050513          	addi	a0,a0,1968 # 80008210 <digits+0x1d0>
    80001a68:	fffff097          	auipc	ra,0xfffff
    80001a6c:	adc080e7          	jalr	-1316(ra) # 80000544 <panic>

0000000080001a70 <procinit>:
{
    80001a70:	7139                	addi	sp,sp,-64
    80001a72:	fc06                	sd	ra,56(sp)
    80001a74:	f822                	sd	s0,48(sp)
    80001a76:	f426                	sd	s1,40(sp)
    80001a78:	f04a                	sd	s2,32(sp)
    80001a7a:	ec4e                	sd	s3,24(sp)
    80001a7c:	e852                	sd	s4,16(sp)
    80001a7e:	e456                	sd	s5,8(sp)
    80001a80:	e05a                	sd	s6,0(sp)
    80001a82:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80001a84:	00006597          	auipc	a1,0x6
    80001a88:	79458593          	addi	a1,a1,1940 # 80008218 <digits+0x1d8>
    80001a8c:	0022f517          	auipc	a0,0x22f
    80001a90:	37450513          	addi	a0,a0,884 # 80230e00 <pid_lock>
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	1fc080e7          	jalr	508(ra) # 80000c90 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001a9c:	00006597          	auipc	a1,0x6
    80001aa0:	78458593          	addi	a1,a1,1924 # 80008220 <digits+0x1e0>
    80001aa4:	0022f517          	auipc	a0,0x22f
    80001aa8:	37450513          	addi	a0,a0,884 # 80230e18 <wait_lock>
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	1e4080e7          	jalr	484(ra) # 80000c90 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001ab4:	00230497          	auipc	s1,0x230
    80001ab8:	19448493          	addi	s1,s1,404 # 80231c48 <proc>
    initlock(&p->lock, "proc");
    80001abc:	00006b17          	auipc	s6,0x6
    80001ac0:	774b0b13          	addi	s6,s6,1908 # 80008230 <digits+0x1f0>
    p->kstack = KSTACK((int)(p - proc));
    80001ac4:	8aa6                	mv	s5,s1
    80001ac6:	00006a17          	auipc	s4,0x6
    80001aca:	53aa0a13          	addi	s4,s4,1338 # 80008000 <etext>
    80001ace:	04000937          	lui	s2,0x4000
    80001ad2:	197d                	addi	s2,s2,-1
    80001ad4:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001ad6:	0023c997          	auipc	s3,0x23c
    80001ada:	b7298993          	addi	s3,s3,-1166 # 8023d648 <tickslock>
    initlock(&p->lock, "proc");
    80001ade:	85da                	mv	a1,s6
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	1ae080e7          	jalr	430(ra) # 80000c90 <initlock>
    p->state = UNUSED;
    80001aea:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001aee:	415487b3          	sub	a5,s1,s5
    80001af2:	878d                	srai	a5,a5,0x3
    80001af4:	000a3703          	ld	a4,0(s4)
    80001af8:	02e787b3          	mul	a5,a5,a4
    80001afc:	2785                	addiw	a5,a5,1
    80001afe:	00d7979b          	slliw	a5,a5,0xd
    80001b02:	40f907b3          	sub	a5,s2,a5
    80001b06:	e8bc                	sd	a5,80(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001b08:	2e848493          	addi	s1,s1,744
    80001b0c:	fd3499e3          	bne	s1,s3,80001ade <procinit+0x6e>
}
    80001b10:	70e2                	ld	ra,56(sp)
    80001b12:	7442                	ld	s0,48(sp)
    80001b14:	74a2                	ld	s1,40(sp)
    80001b16:	7902                	ld	s2,32(sp)
    80001b18:	69e2                	ld	s3,24(sp)
    80001b1a:	6a42                	ld	s4,16(sp)
    80001b1c:	6aa2                	ld	s5,8(sp)
    80001b1e:	6b02                	ld	s6,0(sp)
    80001b20:	6121                	addi	sp,sp,64
    80001b22:	8082                	ret

0000000080001b24 <cpuid>:
{
    80001b24:	1141                	addi	sp,sp,-16
    80001b26:	e422                	sd	s0,8(sp)
    80001b28:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b2a:	8512                	mv	a0,tp
}
    80001b2c:	2501                	sext.w	a0,a0
    80001b2e:	6422                	ld	s0,8(sp)
    80001b30:	0141                	addi	sp,sp,16
    80001b32:	8082                	ret

0000000080001b34 <mycpu>:
{
    80001b34:	1141                	addi	sp,sp,-16
    80001b36:	e422                	sd	s0,8(sp)
    80001b38:	0800                	addi	s0,sp,16
    80001b3a:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001b3c:	2781                	sext.w	a5,a5
    80001b3e:	079e                	slli	a5,a5,0x7
}
    80001b40:	0022f517          	auipc	a0,0x22f
    80001b44:	2f050513          	addi	a0,a0,752 # 80230e30 <cpus>
    80001b48:	953e                	add	a0,a0,a5
    80001b4a:	6422                	ld	s0,8(sp)
    80001b4c:	0141                	addi	sp,sp,16
    80001b4e:	8082                	ret

0000000080001b50 <myproc>:
{
    80001b50:	1101                	addi	sp,sp,-32
    80001b52:	ec06                	sd	ra,24(sp)
    80001b54:	e822                	sd	s0,16(sp)
    80001b56:	e426                	sd	s1,8(sp)
    80001b58:	1000                	addi	s0,sp,32
  push_off();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	17a080e7          	jalr	378(ra) # 80000cd4 <push_off>
    80001b62:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001b64:	2781                	sext.w	a5,a5
    80001b66:	079e                	slli	a5,a5,0x7
    80001b68:	0022f717          	auipc	a4,0x22f
    80001b6c:	29870713          	addi	a4,a4,664 # 80230e00 <pid_lock>
    80001b70:	97ba                	add	a5,a5,a4
    80001b72:	7b84                	ld	s1,48(a5)
  pop_off();
    80001b74:	fffff097          	auipc	ra,0xfffff
    80001b78:	200080e7          	jalr	512(ra) # 80000d74 <pop_off>
}
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	60e2                	ld	ra,24(sp)
    80001b80:	6442                	ld	s0,16(sp)
    80001b82:	64a2                	ld	s1,8(sp)
    80001b84:	6105                	addi	sp,sp,32
    80001b86:	8082                	ret

0000000080001b88 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001b88:	1141                	addi	sp,sp,-16
    80001b8a:	e406                	sd	ra,8(sp)
    80001b8c:	e022                	sd	s0,0(sp)
    80001b8e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001b90:	00000097          	auipc	ra,0x0
    80001b94:	fc0080e7          	jalr	-64(ra) # 80001b50 <myproc>
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	23c080e7          	jalr	572(ra) # 80000dd4 <release>

  if (first)
    80001ba0:	00007797          	auipc	a5,0x7
    80001ba4:	f407a783          	lw	a5,-192(a5) # 80008ae0 <first.1946>
    80001ba8:	eb89                	bnez	a5,80001bba <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001baa:	00001097          	auipc	ra,0x1
    80001bae:	fa8080e7          	jalr	-88(ra) # 80002b52 <usertrapret>
}
    80001bb2:	60a2                	ld	ra,8(sp)
    80001bb4:	6402                	ld	s0,0(sp)
    80001bb6:	0141                	addi	sp,sp,16
    80001bb8:	8082                	ret
    first = 0;
    80001bba:	00007797          	auipc	a5,0x7
    80001bbe:	f207a323          	sw	zero,-218(a5) # 80008ae0 <first.1946>
    fsinit(ROOTDEV);
    80001bc2:	4505                	li	a0,1
    80001bc4:	00002097          	auipc	ra,0x2
    80001bc8:	f2c080e7          	jalr	-212(ra) # 80003af0 <fsinit>
    80001bcc:	bff9                	j	80001baa <forkret+0x22>

0000000080001bce <allocpid>:
{
    80001bce:	1101                	addi	sp,sp,-32
    80001bd0:	ec06                	sd	ra,24(sp)
    80001bd2:	e822                	sd	s0,16(sp)
    80001bd4:	e426                	sd	s1,8(sp)
    80001bd6:	e04a                	sd	s2,0(sp)
    80001bd8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001bda:	0022f917          	auipc	s2,0x22f
    80001bde:	22690913          	addi	s2,s2,550 # 80230e00 <pid_lock>
    80001be2:	854a                	mv	a0,s2
    80001be4:	fffff097          	auipc	ra,0xfffff
    80001be8:	13c080e7          	jalr	316(ra) # 80000d20 <acquire>
  pid = nextpid;
    80001bec:	00007797          	auipc	a5,0x7
    80001bf0:	ef878793          	addi	a5,a5,-264 # 80008ae4 <nextpid>
    80001bf4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001bf6:	0014871b          	addiw	a4,s1,1
    80001bfa:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001bfc:	854a                	mv	a0,s2
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	1d6080e7          	jalr	470(ra) # 80000dd4 <release>
}
    80001c06:	8526                	mv	a0,s1
    80001c08:	60e2                	ld	ra,24(sp)
    80001c0a:	6442                	ld	s0,16(sp)
    80001c0c:	64a2                	ld	s1,8(sp)
    80001c0e:	6902                	ld	s2,0(sp)
    80001c10:	6105                	addi	sp,sp,32
    80001c12:	8082                	ret

0000000080001c14 <proc_pagetable>:
{
    80001c14:	1101                	addi	sp,sp,-32
    80001c16:	ec06                	sd	ra,24(sp)
    80001c18:	e822                	sd	s0,16(sp)
    80001c1a:	e426                	sd	s1,8(sp)
    80001c1c:	e04a                	sd	s2,0(sp)
    80001c1e:	1000                	addi	s0,sp,32
    80001c20:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001c22:	00000097          	auipc	ra,0x0
    80001c26:	858080e7          	jalr	-1960(ra) # 8000147a <uvmcreate>
    80001c2a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001c2c:	c121                	beqz	a0,80001c6c <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c2e:	4729                	li	a4,10
    80001c30:	00005697          	auipc	a3,0x5
    80001c34:	3d068693          	addi	a3,a3,976 # 80007000 <_trampoline>
    80001c38:	6605                	lui	a2,0x1
    80001c3a:	040005b7          	lui	a1,0x4000
    80001c3e:	15fd                	addi	a1,a1,-1
    80001c40:	05b2                	slli	a1,a1,0xc
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	5ae080e7          	jalr	1454(ra) # 800011f0 <mappages>
    80001c4a:	02054863          	bltz	a0,80001c7a <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c4e:	4719                	li	a4,6
    80001c50:	06893683          	ld	a3,104(s2)
    80001c54:	6605                	lui	a2,0x1
    80001c56:	020005b7          	lui	a1,0x2000
    80001c5a:	15fd                	addi	a1,a1,-1
    80001c5c:	05b6                	slli	a1,a1,0xd
    80001c5e:	8526                	mv	a0,s1
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	590080e7          	jalr	1424(ra) # 800011f0 <mappages>
    80001c68:	02054163          	bltz	a0,80001c8a <proc_pagetable+0x76>
}
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	60e2                	ld	ra,24(sp)
    80001c70:	6442                	ld	s0,16(sp)
    80001c72:	64a2                	ld	s1,8(sp)
    80001c74:	6902                	ld	s2,0(sp)
    80001c76:	6105                	addi	sp,sp,32
    80001c78:	8082                	ret
    uvmfree(pagetable, 0);
    80001c7a:	4581                	li	a1,0
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	a00080e7          	jalr	-1536(ra) # 8000167e <uvmfree>
    return 0;
    80001c86:	4481                	li	s1,0
    80001c88:	b7d5                	j	80001c6c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c8a:	4681                	li	a3,0
    80001c8c:	4605                	li	a2,1
    80001c8e:	040005b7          	lui	a1,0x4000
    80001c92:	15fd                	addi	a1,a1,-1
    80001c94:	05b2                	slli	a1,a1,0xc
    80001c96:	8526                	mv	a0,s1
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	71e080e7          	jalr	1822(ra) # 800013b6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001ca0:	4581                	li	a1,0
    80001ca2:	8526                	mv	a0,s1
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	9da080e7          	jalr	-1574(ra) # 8000167e <uvmfree>
    return 0;
    80001cac:	4481                	li	s1,0
    80001cae:	bf7d                	j	80001c6c <proc_pagetable+0x58>

0000000080001cb0 <proc_freepagetable>:
{
    80001cb0:	1101                	addi	sp,sp,-32
    80001cb2:	ec06                	sd	ra,24(sp)
    80001cb4:	e822                	sd	s0,16(sp)
    80001cb6:	e426                	sd	s1,8(sp)
    80001cb8:	e04a                	sd	s2,0(sp)
    80001cba:	1000                	addi	s0,sp,32
    80001cbc:	84aa                	mv	s1,a0
    80001cbe:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001cc0:	4681                	li	a3,0
    80001cc2:	4605                	li	a2,1
    80001cc4:	040005b7          	lui	a1,0x4000
    80001cc8:	15fd                	addi	a1,a1,-1
    80001cca:	05b2                	slli	a1,a1,0xc
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	6ea080e7          	jalr	1770(ra) # 800013b6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001cd4:	4681                	li	a3,0
    80001cd6:	4605                	li	a2,1
    80001cd8:	020005b7          	lui	a1,0x2000
    80001cdc:	15fd                	addi	a1,a1,-1
    80001cde:	05b6                	slli	a1,a1,0xd
    80001ce0:	8526                	mv	a0,s1
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	6d4080e7          	jalr	1748(ra) # 800013b6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001cea:	85ca                	mv	a1,s2
    80001cec:	8526                	mv	a0,s1
    80001cee:	00000097          	auipc	ra,0x0
    80001cf2:	990080e7          	jalr	-1648(ra) # 8000167e <uvmfree>
}
    80001cf6:	60e2                	ld	ra,24(sp)
    80001cf8:	6442                	ld	s0,16(sp)
    80001cfa:	64a2                	ld	s1,8(sp)
    80001cfc:	6902                	ld	s2,0(sp)
    80001cfe:	6105                	addi	sp,sp,32
    80001d00:	8082                	ret

0000000080001d02 <freeproc>:
{
    80001d02:	1101                	addi	sp,sp,-32
    80001d04:	ec06                	sd	ra,24(sp)
    80001d06:	e822                	sd	s0,16(sp)
    80001d08:	e426                	sd	s1,8(sp)
    80001d0a:	1000                	addi	s0,sp,32
    80001d0c:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001d0e:	7528                	ld	a0,104(a0)
    80001d10:	c509                	beqz	a0,80001d1a <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	d64080e7          	jalr	-668(ra) # 80000a76 <kfree>
  p->trapframe = 0;
    80001d1a:	0604b423          	sd	zero,104(s1)
  if (p->pagetable)
    80001d1e:	70a8                	ld	a0,96(s1)
    80001d20:	c511                	beqz	a0,80001d2c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001d22:	6cac                	ld	a1,88(s1)
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	f8c080e7          	jalr	-116(ra) # 80001cb0 <proc_freepagetable>
  p->pagetable = 0;
    80001d2c:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001d30:	0404bc23          	sd	zero,88(s1)
  p->pid = 0;
    80001d34:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001d38:	0404b423          	sd	zero,72(s1)
  p->name[0] = 0;
    80001d3c:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001d40:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001d44:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001d48:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001d4c:	0004ac23          	sw	zero,24(s1)
}
    80001d50:	60e2                	ld	ra,24(sp)
    80001d52:	6442                	ld	s0,16(sp)
    80001d54:	64a2                	ld	s1,8(sp)
    80001d56:	6105                	addi	sp,sp,32
    80001d58:	8082                	ret

0000000080001d5a <allocproc>:
{
    80001d5a:	1101                	addi	sp,sp,-32
    80001d5c:	ec06                	sd	ra,24(sp)
    80001d5e:	e822                	sd	s0,16(sp)
    80001d60:	e426                	sd	s1,8(sp)
    80001d62:	e04a                	sd	s2,0(sp)
    80001d64:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001d66:	00230497          	auipc	s1,0x230
    80001d6a:	ee248493          	addi	s1,s1,-286 # 80231c48 <proc>
    80001d6e:	0023c917          	auipc	s2,0x23c
    80001d72:	8da90913          	addi	s2,s2,-1830 # 8023d648 <tickslock>
    acquire(&p->lock);
    80001d76:	8526                	mv	a0,s1
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	fa8080e7          	jalr	-88(ra) # 80000d20 <acquire>
    if (p->state == UNUSED)
    80001d80:	4c9c                	lw	a5,24(s1)
    80001d82:	cf81                	beqz	a5,80001d9a <allocproc+0x40>
      release(&p->lock);
    80001d84:	8526                	mv	a0,s1
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	04e080e7          	jalr	78(ra) # 80000dd4 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001d8e:	2e848493          	addi	s1,s1,744
    80001d92:	ff2492e3          	bne	s1,s2,80001d76 <allocproc+0x1c>
  return 0;
    80001d96:	4481                	li	s1,0
    80001d98:	a875                	j	80001e54 <allocproc+0xfa>
  p->start = ticks;
    80001d9a:	00007797          	auipc	a5,0x7
    80001d9e:	df67a783          	lw	a5,-522(a5) # 80008b90 <ticks>
    80001da2:	d8dc                	sw	a5,52(s1)
  p->pid = allocpid();
    80001da4:	00000097          	auipc	ra,0x0
    80001da8:	e2a080e7          	jalr	-470(ra) # 80001bce <allocpid>
    80001dac:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001dae:	4785                	li	a5,1
    80001db0:	cc9c                	sw	a5,24(s1)
  p->rep = 0;
    80001db2:	0404a023          	sw	zero,64(s1)
  p->sp = 60;
    80001db6:	03c00713          	li	a4,60
    80001dba:	dcd8                	sw	a4,60(s1)
  p->rtime = 0;
    80001dbc:	1604ac23          	sw	zero,376(s1)
  p->startTime = 0;
    80001dc0:	1804a223          	sw	zero,388(s1)
  p->slep = 0;
    80001dc4:	0404a223          	sw	zero,68(s1)
  p->totTime = 0;
    80001dc8:	1804a423          	sw	zero,392(s1)
  p->endTime = 0;
    80001dcc:	1804a623          	sw	zero,396(s1)
  p->tickets = 1;
    80001dd0:	dc9c                	sw	a5,56(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001dd2:	fffff097          	auipc	ra,0xfffff
    80001dd6:	e26080e7          	jalr	-474(ra) # 80000bf8 <kalloc>
    80001dda:	892a                	mv	s2,a0
    80001ddc:	f4a8                	sd	a0,104(s1)
    80001dde:	c151                	beqz	a0,80001e62 <allocproc+0x108>
  p->pagetable = proc_pagetable(p);
    80001de0:	8526                	mv	a0,s1
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	e32080e7          	jalr	-462(ra) # 80001c14 <proc_pagetable>
    80001dea:	892a                	mv	s2,a0
    80001dec:	f0a8                	sd	a0,96(s1)
  if (p->pagetable == 0)
    80001dee:	c551                	beqz	a0,80001e7a <allocproc+0x120>
  memset(&p->context, 0, sizeof(p->context));
    80001df0:	07000613          	li	a2,112
    80001df4:	4581                	li	a1,0
    80001df6:	07048513          	addi	a0,s1,112
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	022080e7          	jalr	34(ra) # 80000e1c <memset>
  p->context.ra = (uint64)forkret;
    80001e02:	00000797          	auipc	a5,0x0
    80001e06:	d8678793          	addi	a5,a5,-634 # 80001b88 <forkret>
    80001e0a:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001e0c:	68bc                	ld	a5,80(s1)
    80001e0e:	6705                	lui	a4,0x1
    80001e10:	97ba                	add	a5,a5,a4
    80001e12:	fcbc                	sd	a5,120(s1)
  p->rtime = 0;
    80001e14:	1604ac23          	sw	zero,376(s1)
  p->etime = 0;
    80001e18:	1804a023          	sw	zero,384(s1)
  p->ctime = ticks;
    80001e1c:	00007797          	auipc	a5,0x7
    80001e20:	d747a783          	lw	a5,-652(a5) # 80008b90 <ticks>
    80001e24:	16f4ae23          	sw	a5,380(s1)
  p->alarm_interval = 0;
    80001e28:	1a04aa23          	sw	zero,436(s1)
  p->alarm_passed = 0;
    80001e2c:	1a04ac23          	sw	zero,440(s1)
  p->alarm_handler = 0;
    80001e30:	1c04b023          	sd	zero,448(s1)
  p->cpuTime = 0;
    80001e34:	1804a823          	sw	zero,400(s1)
  p->q = 0;
    80001e38:	1804aa23          	sw	zero,404(s1)
  p->q_in = 0;
    80001e3c:	1804ac23          	sw	zero,408(s1)
    p->timeInQ[i] = 0;
    80001e40:	1804ae23          	sw	zero,412(s1)
    80001e44:	1a04a023          	sw	zero,416(s1)
    80001e48:	1a04a223          	sw	zero,420(s1)
    80001e4c:	1a04a423          	sw	zero,424(s1)
    80001e50:	1a04a623          	sw	zero,428(s1)
}
    80001e54:	8526                	mv	a0,s1
    80001e56:	60e2                	ld	ra,24(sp)
    80001e58:	6442                	ld	s0,16(sp)
    80001e5a:	64a2                	ld	s1,8(sp)
    80001e5c:	6902                	ld	s2,0(sp)
    80001e5e:	6105                	addi	sp,sp,32
    80001e60:	8082                	ret
    freeproc(p);
    80001e62:	8526                	mv	a0,s1
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	e9e080e7          	jalr	-354(ra) # 80001d02 <freeproc>
    release(&p->lock);
    80001e6c:	8526                	mv	a0,s1
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	f66080e7          	jalr	-154(ra) # 80000dd4 <release>
    return 0;
    80001e76:	84ca                	mv	s1,s2
    80001e78:	bff1                	j	80001e54 <allocproc+0xfa>
    freeproc(p);
    80001e7a:	8526                	mv	a0,s1
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	e86080e7          	jalr	-378(ra) # 80001d02 <freeproc>
    release(&p->lock);
    80001e84:	8526                	mv	a0,s1
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	f4e080e7          	jalr	-178(ra) # 80000dd4 <release>
    return 0;
    80001e8e:	84ca                	mv	s1,s2
    80001e90:	b7d1                	j	80001e54 <allocproc+0xfa>

0000000080001e92 <userinit>:
{
    80001e92:	1101                	addi	sp,sp,-32
    80001e94:	ec06                	sd	ra,24(sp)
    80001e96:	e822                	sd	s0,16(sp)
    80001e98:	e426                	sd	s1,8(sp)
    80001e9a:	1000                	addi	s0,sp,32
  p = allocproc();
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	ebe080e7          	jalr	-322(ra) # 80001d5a <allocproc>
    80001ea4:	84aa                	mv	s1,a0
  initproc = p;
    80001ea6:	00007797          	auipc	a5,0x7
    80001eaa:	cea7b123          	sd	a0,-798(a5) # 80008b88 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001eae:	03400613          	li	a2,52
    80001eb2:	00007597          	auipc	a1,0x7
    80001eb6:	c3e58593          	addi	a1,a1,-962 # 80008af0 <initcode>
    80001eba:	7128                	ld	a0,96(a0)
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	5ec080e7          	jalr	1516(ra) # 800014a8 <uvmfirst>
  p->sz = PGSIZE;
    80001ec4:	6785                	lui	a5,0x1
    80001ec6:	ecbc                	sd	a5,88(s1)
  p->trapframe->epc = 0;     // user program counter
    80001ec8:	74b8                	ld	a4,104(s1)
    80001eca:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001ece:	74b8                	ld	a4,104(s1)
    80001ed0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ed2:	4641                	li	a2,16
    80001ed4:	00006597          	auipc	a1,0x6
    80001ed8:	36458593          	addi	a1,a1,868 # 80008238 <digits+0x1f8>
    80001edc:	16848513          	addi	a0,s1,360
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	08e080e7          	jalr	142(ra) # 80000f6e <safestrcpy>
  p->cwd = namei("/");
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	36050513          	addi	a0,a0,864 # 80008248 <digits+0x208>
    80001ef0:	00002097          	auipc	ra,0x2
    80001ef4:	622080e7          	jalr	1570(ra) # 80004512 <namei>
    80001ef8:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80001efc:	478d                	li	a5,3
    80001efe:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f00:	8526                	mv	a0,s1
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	ed2080e7          	jalr	-302(ra) # 80000dd4 <release>
}
    80001f0a:	60e2                	ld	ra,24(sp)
    80001f0c:	6442                	ld	s0,16(sp)
    80001f0e:	64a2                	ld	s1,8(sp)
    80001f10:	6105                	addi	sp,sp,32
    80001f12:	8082                	ret

0000000080001f14 <growproc>:
{
    80001f14:	1101                	addi	sp,sp,-32
    80001f16:	ec06                	sd	ra,24(sp)
    80001f18:	e822                	sd	s0,16(sp)
    80001f1a:	e426                	sd	s1,8(sp)
    80001f1c:	e04a                	sd	s2,0(sp)
    80001f1e:	1000                	addi	s0,sp,32
    80001f20:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	c2e080e7          	jalr	-978(ra) # 80001b50 <myproc>
    80001f2a:	84aa                	mv	s1,a0
  sz = p->sz;
    80001f2c:	6d2c                	ld	a1,88(a0)
  if (n > 0)
    80001f2e:	01204c63          	bgtz	s2,80001f46 <growproc+0x32>
  else if (n < 0)
    80001f32:	02094663          	bltz	s2,80001f5e <growproc+0x4a>
  p->sz = sz;
    80001f36:	ecac                	sd	a1,88(s1)
  return 0;
    80001f38:	4501                	li	a0,0
}
    80001f3a:	60e2                	ld	ra,24(sp)
    80001f3c:	6442                	ld	s0,16(sp)
    80001f3e:	64a2                	ld	s1,8(sp)
    80001f40:	6902                	ld	s2,0(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001f46:	4691                	li	a3,4
    80001f48:	00b90633          	add	a2,s2,a1
    80001f4c:	7128                	ld	a0,96(a0)
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	614080e7          	jalr	1556(ra) # 80001562 <uvmalloc>
    80001f56:	85aa                	mv	a1,a0
    80001f58:	fd79                	bnez	a0,80001f36 <growproc+0x22>
      return -1;
    80001f5a:	557d                	li	a0,-1
    80001f5c:	bff9                	j	80001f3a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001f5e:	00b90633          	add	a2,s2,a1
    80001f62:	7128                	ld	a0,96(a0)
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	5b6080e7          	jalr	1462(ra) # 8000151a <uvmdealloc>
    80001f6c:	85aa                	mv	a1,a0
    80001f6e:	b7e1                	j	80001f36 <growproc+0x22>

0000000080001f70 <fork>:
{
    80001f70:	7179                	addi	sp,sp,-48
    80001f72:	f406                	sd	ra,40(sp)
    80001f74:	f022                	sd	s0,32(sp)
    80001f76:	ec26                	sd	s1,24(sp)
    80001f78:	e84a                	sd	s2,16(sp)
    80001f7a:	e44e                	sd	s3,8(sp)
    80001f7c:	e052                	sd	s4,0(sp)
    80001f7e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	bd0080e7          	jalr	-1072(ra) # 80001b50 <myproc>
    80001f88:	892a                	mv	s2,a0
  if ((np = allocproc()) == 0)
    80001f8a:	00000097          	auipc	ra,0x0
    80001f8e:	dd0080e7          	jalr	-560(ra) # 80001d5a <allocproc>
    80001f92:	12050363          	beqz	a0,800020b8 <fork+0x148>
    80001f96:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001f98:	05893603          	ld	a2,88(s2)
    80001f9c:	712c                	ld	a1,96(a0)
    80001f9e:	06093503          	ld	a0,96(s2)
    80001fa2:	fffff097          	auipc	ra,0xfffff
    80001fa6:	714080e7          	jalr	1812(ra) # 800016b6 <uvmcopy>
    80001faa:	04054a63          	bltz	a0,80001ffe <fork+0x8e>
  np->sz = p->sz;
    80001fae:	05893783          	ld	a5,88(s2)
    80001fb2:	04f9bc23          	sd	a5,88(s3)
  np->mask = p->mask;
    80001fb6:	1b092783          	lw	a5,432(s2)
    80001fba:	1af9a823          	sw	a5,432(s3)
  *(np->trapframe) = *(p->trapframe);
    80001fbe:	06893683          	ld	a3,104(s2)
    80001fc2:	87b6                	mv	a5,a3
    80001fc4:	0689b703          	ld	a4,104(s3)
    80001fc8:	12068693          	addi	a3,a3,288
    80001fcc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001fd0:	6788                	ld	a0,8(a5)
    80001fd2:	6b8c                	ld	a1,16(a5)
    80001fd4:	6f90                	ld	a2,24(a5)
    80001fd6:	01073023          	sd	a6,0(a4)
    80001fda:	e708                	sd	a0,8(a4)
    80001fdc:	eb0c                	sd	a1,16(a4)
    80001fde:	ef10                	sd	a2,24(a4)
    80001fe0:	02078793          	addi	a5,a5,32
    80001fe4:	02070713          	addi	a4,a4,32
    80001fe8:	fed792e3          	bne	a5,a3,80001fcc <fork+0x5c>
  np->trapframe->a0 = 0;
    80001fec:	0689b783          	ld	a5,104(s3)
    80001ff0:	0607b823          	sd	zero,112(a5)
    80001ff4:	0e000493          	li	s1,224
  for (i = 0; i < NOFILE; i++)
    80001ff8:	16000a13          	li	s4,352
    80001ffc:	a03d                	j	8000202a <fork+0xba>
    freeproc(np);
    80001ffe:	854e                	mv	a0,s3
    80002000:	00000097          	auipc	ra,0x0
    80002004:	d02080e7          	jalr	-766(ra) # 80001d02 <freeproc>
    release(&np->lock);
    80002008:	854e                	mv	a0,s3
    8000200a:	fffff097          	auipc	ra,0xfffff
    8000200e:	dca080e7          	jalr	-566(ra) # 80000dd4 <release>
    return -1;
    80002012:	5a7d                	li	s4,-1
    80002014:	a849                	j	800020a6 <fork+0x136>
      np->ofile[i] = filedup(p->ofile[i]);
    80002016:	00003097          	auipc	ra,0x3
    8000201a:	b92080e7          	jalr	-1134(ra) # 80004ba8 <filedup>
    8000201e:	009987b3          	add	a5,s3,s1
    80002022:	e388                	sd	a0,0(a5)
  for (i = 0; i < NOFILE; i++)
    80002024:	04a1                	addi	s1,s1,8
    80002026:	01448763          	beq	s1,s4,80002034 <fork+0xc4>
    if (p->ofile[i])
    8000202a:	009907b3          	add	a5,s2,s1
    8000202e:	6388                	ld	a0,0(a5)
    80002030:	f17d                	bnez	a0,80002016 <fork+0xa6>
    80002032:	bfcd                	j	80002024 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80002034:	16093503          	ld	a0,352(s2)
    80002038:	00002097          	auipc	ra,0x2
    8000203c:	cf6080e7          	jalr	-778(ra) # 80003d2e <idup>
    80002040:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002044:	4641                	li	a2,16
    80002046:	16890593          	addi	a1,s2,360
    8000204a:	16898513          	addi	a0,s3,360
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	f20080e7          	jalr	-224(ra) # 80000f6e <safestrcpy>
  pid = np->pid;
    80002056:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000205a:	854e                	mv	a0,s3
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	d78080e7          	jalr	-648(ra) # 80000dd4 <release>
  acquire(&wait_lock);
    80002064:	0022f497          	auipc	s1,0x22f
    80002068:	db448493          	addi	s1,s1,-588 # 80230e18 <wait_lock>
    8000206c:	8526                	mv	a0,s1
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	cb2080e7          	jalr	-846(ra) # 80000d20 <acquire>
  np->parent = p;
    80002076:	0529b423          	sd	s2,72(s3)
  release(&wait_lock);
    8000207a:	8526                	mv	a0,s1
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	d58080e7          	jalr	-680(ra) # 80000dd4 <release>
  acquire(&np->lock);
    80002084:	854e                	mv	a0,s3
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	c9a080e7          	jalr	-870(ra) # 80000d20 <acquire>
  np->state = RUNNABLE;
    8000208e:	478d                	li	a5,3
    80002090:	00f9ac23          	sw	a5,24(s3)
  np->tickets = p->tickets;
    80002094:	03892783          	lw	a5,56(s2)
    80002098:	02f9ac23          	sw	a5,56(s3)
  release(&np->lock);
    8000209c:	854e                	mv	a0,s3
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	d36080e7          	jalr	-714(ra) # 80000dd4 <release>
}
    800020a6:	8552                	mv	a0,s4
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6942                	ld	s2,16(sp)
    800020b0:	69a2                	ld	s3,8(sp)
    800020b2:	6a02                	ld	s4,0(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret
    return -1;
    800020b8:	5a7d                	li	s4,-1
    800020ba:	b7f5                	j	800020a6 <fork+0x136>

00000000800020bc <reparent>:
{
    800020bc:	7179                	addi	sp,sp,-48
    800020be:	f406                	sd	ra,40(sp)
    800020c0:	f022                	sd	s0,32(sp)
    800020c2:	ec26                	sd	s1,24(sp)
    800020c4:	e84a                	sd	s2,16(sp)
    800020c6:	e44e                	sd	s3,8(sp)
    800020c8:	e052                	sd	s4,0(sp)
    800020ca:	1800                	addi	s0,sp,48
    800020cc:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800020ce:	00230497          	auipc	s1,0x230
    800020d2:	b7a48493          	addi	s1,s1,-1158 # 80231c48 <proc>
      pp->parent = initproc;
    800020d6:	00007a17          	auipc	s4,0x7
    800020da:	ab2a0a13          	addi	s4,s4,-1358 # 80008b88 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800020de:	0023b997          	auipc	s3,0x23b
    800020e2:	56a98993          	addi	s3,s3,1386 # 8023d648 <tickslock>
    800020e6:	a029                	j	800020f0 <reparent+0x34>
    800020e8:	2e848493          	addi	s1,s1,744
    800020ec:	01348d63          	beq	s1,s3,80002106 <reparent+0x4a>
    if (pp->parent == p)
    800020f0:	64bc                	ld	a5,72(s1)
    800020f2:	ff279be3          	bne	a5,s2,800020e8 <reparent+0x2c>
      pp->parent = initproc;
    800020f6:	000a3503          	ld	a0,0(s4)
    800020fa:	e4a8                	sd	a0,72(s1)
      wakeup1(initproc);
    800020fc:	00000097          	auipc	ra,0x0
    80002100:	8a4080e7          	jalr	-1884(ra) # 800019a0 <wakeup1>
    80002104:	b7d5                	j	800020e8 <reparent+0x2c>
}
    80002106:	70a2                	ld	ra,40(sp)
    80002108:	7402                	ld	s0,32(sp)
    8000210a:	64e2                	ld	s1,24(sp)
    8000210c:	6942                	ld	s2,16(sp)
    8000210e:	69a2                	ld	s3,8(sp)
    80002110:	6a02                	ld	s4,0(sp)
    80002112:	6145                	addi	sp,sp,48
    80002114:	8082                	ret

0000000080002116 <wakeup>:
{
    80002116:	7139                	addi	sp,sp,-64
    80002118:	fc06                	sd	ra,56(sp)
    8000211a:	f822                	sd	s0,48(sp)
    8000211c:	f426                	sd	s1,40(sp)
    8000211e:	f04a                	sd	s2,32(sp)
    80002120:	ec4e                	sd	s3,24(sp)
    80002122:	e852                	sd	s4,16(sp)
    80002124:	e456                	sd	s5,8(sp)
    80002126:	0080                	addi	s0,sp,64
    80002128:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++)
    8000212a:	00230497          	auipc	s1,0x230
    8000212e:	b1e48493          	addi	s1,s1,-1250 # 80231c48 <proc>
      if (p->state == SLEEPING && p->chan == chan)
    80002132:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002134:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002136:	0023b917          	auipc	s2,0x23b
    8000213a:	51290913          	addi	s2,s2,1298 # 8023d648 <tickslock>
    8000213e:	a821                	j	80002156 <wakeup+0x40>
        p->state = RUNNABLE;
    80002140:	0154ac23          	sw	s5,24(s1)
      release(&p->lock);
    80002144:	8526                	mv	a0,s1
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	c8e080e7          	jalr	-882(ra) # 80000dd4 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000214e:	2e848493          	addi	s1,s1,744
    80002152:	03248463          	beq	s1,s2,8000217a <wakeup+0x64>
    if (p != myproc())
    80002156:	00000097          	auipc	ra,0x0
    8000215a:	9fa080e7          	jalr	-1542(ra) # 80001b50 <myproc>
    8000215e:	fea488e3          	beq	s1,a0,8000214e <wakeup+0x38>
      acquire(&p->lock);
    80002162:	8526                	mv	a0,s1
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	bbc080e7          	jalr	-1092(ra) # 80000d20 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    8000216c:	4c9c                	lw	a5,24(s1)
    8000216e:	fd379be3          	bne	a5,s3,80002144 <wakeup+0x2e>
    80002172:	709c                	ld	a5,32(s1)
    80002174:	fd4798e3          	bne	a5,s4,80002144 <wakeup+0x2e>
    80002178:	b7e1                	j	80002140 <wakeup+0x2a>
}
    8000217a:	70e2                	ld	ra,56(sp)
    8000217c:	7442                	ld	s0,48(sp)
    8000217e:	74a2                	ld	s1,40(sp)
    80002180:	7902                	ld	s2,32(sp)
    80002182:	69e2                	ld	s3,24(sp)
    80002184:	6a42                	ld	s4,16(sp)
    80002186:	6aa2                	ld	s5,8(sp)
    80002188:	6121                	addi	sp,sp,64
    8000218a:	8082                	ret

000000008000218c <update_time>:
{
    8000218c:	7179                	addi	sp,sp,-48
    8000218e:	f406                	sd	ra,40(sp)
    80002190:	f022                	sd	s0,32(sp)
    80002192:	ec26                	sd	s1,24(sp)
    80002194:	e84a                	sd	s2,16(sp)
    80002196:	e44e                	sd	s3,8(sp)
    80002198:	e052                	sd	s4,0(sp)
    8000219a:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++)
    8000219c:	00230497          	auipc	s1,0x230
    800021a0:	aac48493          	addi	s1,s1,-1364 # 80231c48 <proc>
    if (p->state == RUNNING)
    800021a4:	4991                	li	s3,4
    if (p->state == SLEEPING)
    800021a6:	4a09                	li	s4,2
  for (p = proc; p < &proc[NPROC]; p++)
    800021a8:	0023b917          	auipc	s2,0x23b
    800021ac:	4a090913          	addi	s2,s2,1184 # 8023d648 <tickslock>
    800021b0:	a025                	j	800021d8 <update_time+0x4c>
      p->rtime++;
    800021b2:	1784a783          	lw	a5,376(s1)
    800021b6:	2785                	addiw	a5,a5,1
    800021b8:	16f4ac23          	sw	a5,376(s1)
      p->totTime++;
    800021bc:	1884a783          	lw	a5,392(s1)
    800021c0:	2785                	addiw	a5,a5,1
    800021c2:	18f4a423          	sw	a5,392(s1)
    release(&p->lock);
    800021c6:	8526                	mv	a0,s1
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	c0c080e7          	jalr	-1012(ra) # 80000dd4 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800021d0:	2e848493          	addi	s1,s1,744
    800021d4:	03248063          	beq	s1,s2,800021f4 <update_time+0x68>
    acquire(&p->lock);
    800021d8:	8526                	mv	a0,s1
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	b46080e7          	jalr	-1210(ra) # 80000d20 <acquire>
    if (p->state == RUNNING)
    800021e2:	4c9c                	lw	a5,24(s1)
    800021e4:	fd3787e3          	beq	a5,s3,800021b2 <update_time+0x26>
    if (p->state == SLEEPING)
    800021e8:	fd479fe3          	bne	a5,s4,800021c6 <update_time+0x3a>
      p->slep++;
    800021ec:	40fc                	lw	a5,68(s1)
    800021ee:	2785                	addiw	a5,a5,1
    800021f0:	c0fc                	sw	a5,68(s1)
    800021f2:	bfd1                	j	800021c6 <update_time+0x3a>
}
    800021f4:	70a2                	ld	ra,40(sp)
    800021f6:	7402                	ld	s0,32(sp)
    800021f8:	64e2                	ld	s1,24(sp)
    800021fa:	6942                	ld	s2,16(sp)
    800021fc:	69a2                	ld	s3,8(sp)
    800021fe:	6a02                	ld	s4,0(sp)
    80002200:	6145                	addi	sp,sp,48
    80002202:	8082                	ret

0000000080002204 <scheduler>:
{
    80002204:	7139                	addi	sp,sp,-64
    80002206:	fc06                	sd	ra,56(sp)
    80002208:	f822                	sd	s0,48(sp)
    8000220a:	f426                	sd	s1,40(sp)
    8000220c:	f04a                	sd	s2,32(sp)
    8000220e:	ec4e                	sd	s3,24(sp)
    80002210:	e852                	sd	s4,16(sp)
    80002212:	e456                	sd	s5,8(sp)
    80002214:	e05a                	sd	s6,0(sp)
    80002216:	0080                	addi	s0,sp,64
    80002218:	8792                	mv	a5,tp
  int id = r_tp();
    8000221a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000221c:	00779a93          	slli	s5,a5,0x7
    80002220:	0022f717          	auipc	a4,0x22f
    80002224:	be070713          	addi	a4,a4,-1056 # 80230e00 <pid_lock>
    80002228:	9756                	add	a4,a4,s5
    8000222a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000222e:	0022f717          	auipc	a4,0x22f
    80002232:	c0a70713          	addi	a4,a4,-1014 # 80230e38 <cpus+0x8>
    80002236:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    80002238:	498d                	li	s3,3
        p->state = RUNNING;
    8000223a:	4b11                	li	s6,4
        c->proc = p;
    8000223c:	079e                	slli	a5,a5,0x7
    8000223e:	0022fa17          	auipc	s4,0x22f
    80002242:	bc2a0a13          	addi	s4,s4,-1086 # 80230e00 <pid_lock>
    80002246:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80002248:	0023b917          	auipc	s2,0x23b
    8000224c:	40090913          	addi	s2,s2,1024 # 8023d648 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002250:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002254:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002258:	10079073          	csrw	sstatus,a5
    8000225c:	00230497          	auipc	s1,0x230
    80002260:	9ec48493          	addi	s1,s1,-1556 # 80231c48 <proc>
    80002264:	a03d                	j	80002292 <scheduler+0x8e>
        p->state = RUNNING;
    80002266:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000226a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000226e:	07048593          	addi	a1,s1,112
    80002272:	8556                	mv	a0,s5
    80002274:	00000097          	auipc	ra,0x0
    80002278:	7b0080e7          	jalr	1968(ra) # 80002a24 <swtch>
        c->proc = 0;
    8000227c:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80002280:	8526                	mv	a0,s1
    80002282:	fffff097          	auipc	ra,0xfffff
    80002286:	b52080e7          	jalr	-1198(ra) # 80000dd4 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000228a:	2e848493          	addi	s1,s1,744
    8000228e:	fd2481e3          	beq	s1,s2,80002250 <scheduler+0x4c>
      acquire(&p->lock);
    80002292:	8526                	mv	a0,s1
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	a8c080e7          	jalr	-1396(ra) # 80000d20 <acquire>
      if (p->state == RUNNABLE)
    8000229c:	4c9c                	lw	a5,24(s1)
    8000229e:	ff3791e3          	bne	a5,s3,80002280 <scheduler+0x7c>
    800022a2:	b7d1                	j	80002266 <scheduler+0x62>

00000000800022a4 <sched>:
{
    800022a4:	7179                	addi	sp,sp,-48
    800022a6:	f406                	sd	ra,40(sp)
    800022a8:	f022                	sd	s0,32(sp)
    800022aa:	ec26                	sd	s1,24(sp)
    800022ac:	e84a                	sd	s2,16(sp)
    800022ae:	e44e                	sd	s3,8(sp)
    800022b0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800022b2:	00000097          	auipc	ra,0x0
    800022b6:	89e080e7          	jalr	-1890(ra) # 80001b50 <myproc>
    800022ba:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	9ea080e7          	jalr	-1558(ra) # 80000ca6 <holding>
    800022c4:	c93d                	beqz	a0,8000233a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800022c6:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800022c8:	2781                	sext.w	a5,a5
    800022ca:	079e                	slli	a5,a5,0x7
    800022cc:	0022f717          	auipc	a4,0x22f
    800022d0:	b3470713          	addi	a4,a4,-1228 # 80230e00 <pid_lock>
    800022d4:	97ba                	add	a5,a5,a4
    800022d6:	0a87a703          	lw	a4,168(a5)
    800022da:	4785                	li	a5,1
    800022dc:	06f71763          	bne	a4,a5,8000234a <sched+0xa6>
  if (p->state == RUNNING)
    800022e0:	4c98                	lw	a4,24(s1)
    800022e2:	4791                	li	a5,4
    800022e4:	06f70b63          	beq	a4,a5,8000235a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022e8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800022ec:	8b89                	andi	a5,a5,2
  if (intr_get())
    800022ee:	efb5                	bnez	a5,8000236a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800022f0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800022f2:	0022f917          	auipc	s2,0x22f
    800022f6:	b0e90913          	addi	s2,s2,-1266 # 80230e00 <pid_lock>
    800022fa:	2781                	sext.w	a5,a5
    800022fc:	079e                	slli	a5,a5,0x7
    800022fe:	97ca                	add	a5,a5,s2
    80002300:	0ac7a983          	lw	s3,172(a5)
    80002304:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002306:	2781                	sext.w	a5,a5
    80002308:	079e                	slli	a5,a5,0x7
    8000230a:	0022f597          	auipc	a1,0x22f
    8000230e:	b2e58593          	addi	a1,a1,-1234 # 80230e38 <cpus+0x8>
    80002312:	95be                	add	a1,a1,a5
    80002314:	07048513          	addi	a0,s1,112
    80002318:	00000097          	auipc	ra,0x0
    8000231c:	70c080e7          	jalr	1804(ra) # 80002a24 <swtch>
    80002320:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002322:	2781                	sext.w	a5,a5
    80002324:	079e                	slli	a5,a5,0x7
    80002326:	97ca                	add	a5,a5,s2
    80002328:	0b37a623          	sw	s3,172(a5)
}
    8000232c:	70a2                	ld	ra,40(sp)
    8000232e:	7402                	ld	s0,32(sp)
    80002330:	64e2                	ld	s1,24(sp)
    80002332:	6942                	ld	s2,16(sp)
    80002334:	69a2                	ld	s3,8(sp)
    80002336:	6145                	addi	sp,sp,48
    80002338:	8082                	ret
    panic("sched p->lock");
    8000233a:	00006517          	auipc	a0,0x6
    8000233e:	f1650513          	addi	a0,a0,-234 # 80008250 <digits+0x210>
    80002342:	ffffe097          	auipc	ra,0xffffe
    80002346:	202080e7          	jalr	514(ra) # 80000544 <panic>
    panic("sched locks");
    8000234a:	00006517          	auipc	a0,0x6
    8000234e:	f1650513          	addi	a0,a0,-234 # 80008260 <digits+0x220>
    80002352:	ffffe097          	auipc	ra,0xffffe
    80002356:	1f2080e7          	jalr	498(ra) # 80000544 <panic>
    panic("sched running");
    8000235a:	00006517          	auipc	a0,0x6
    8000235e:	f1650513          	addi	a0,a0,-234 # 80008270 <digits+0x230>
    80002362:	ffffe097          	auipc	ra,0xffffe
    80002366:	1e2080e7          	jalr	482(ra) # 80000544 <panic>
    panic("sched interruptible");
    8000236a:	00006517          	auipc	a0,0x6
    8000236e:	f1650513          	addi	a0,a0,-234 # 80008280 <digits+0x240>
    80002372:	ffffe097          	auipc	ra,0xffffe
    80002376:	1d2080e7          	jalr	466(ra) # 80000544 <panic>

000000008000237a <exit>:
{
    8000237a:	7179                	addi	sp,sp,-48
    8000237c:	f406                	sd	ra,40(sp)
    8000237e:	f022                	sd	s0,32(sp)
    80002380:	ec26                	sd	s1,24(sp)
    80002382:	e84a                	sd	s2,16(sp)
    80002384:	e44e                	sd	s3,8(sp)
    80002386:	e052                	sd	s4,0(sp)
    80002388:	1800                	addi	s0,sp,48
    8000238a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	7c4080e7          	jalr	1988(ra) # 80001b50 <myproc>
    80002394:	89aa                	mv	s3,a0
  if (p == initproc)
    80002396:	00006797          	auipc	a5,0x6
    8000239a:	7f27b783          	ld	a5,2034(a5) # 80008b88 <initproc>
    8000239e:	0e050493          	addi	s1,a0,224
    800023a2:	16050913          	addi	s2,a0,352
    800023a6:	02a79363          	bne	a5,a0,800023cc <exit+0x52>
    panic("init exiting");
    800023aa:	00006517          	auipc	a0,0x6
    800023ae:	eee50513          	addi	a0,a0,-274 # 80008298 <digits+0x258>
    800023b2:	ffffe097          	auipc	ra,0xffffe
    800023b6:	192080e7          	jalr	402(ra) # 80000544 <panic>
      fileclose(f);
    800023ba:	00003097          	auipc	ra,0x3
    800023be:	840080e7          	jalr	-1984(ra) # 80004bfa <fileclose>
      p->ofile[fd] = 0;
    800023c2:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    800023c6:	04a1                	addi	s1,s1,8
    800023c8:	01248563          	beq	s1,s2,800023d2 <exit+0x58>
    if (p->ofile[fd])
    800023cc:	6088                	ld	a0,0(s1)
    800023ce:	f575                	bnez	a0,800023ba <exit+0x40>
    800023d0:	bfdd                	j	800023c6 <exit+0x4c>
  begin_op();
    800023d2:	00002097          	auipc	ra,0x2
    800023d6:	35c080e7          	jalr	860(ra) # 8000472e <begin_op>
  iput(p->cwd);
    800023da:	1609b503          	ld	a0,352(s3)
    800023de:	00002097          	auipc	ra,0x2
    800023e2:	b48080e7          	jalr	-1208(ra) # 80003f26 <iput>
  end_op();
    800023e6:	00002097          	auipc	ra,0x2
    800023ea:	3c8080e7          	jalr	968(ra) # 800047ae <end_op>
  p->cwd = 0;
    800023ee:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    800023f2:	0022f497          	auipc	s1,0x22f
    800023f6:	a2648493          	addi	s1,s1,-1498 # 80230e18 <wait_lock>
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	924080e7          	jalr	-1756(ra) # 80000d20 <acquire>
  reparent(p);
    80002404:	854e                	mv	a0,s3
    80002406:	00000097          	auipc	ra,0x0
    8000240a:	cb6080e7          	jalr	-842(ra) # 800020bc <reparent>
  wakeup1(p->parent);
    8000240e:	0489b503          	ld	a0,72(s3)
    80002412:	fffff097          	auipc	ra,0xfffff
    80002416:	58e080e7          	jalr	1422(ra) # 800019a0 <wakeup1>
  acquire(&p->lock);
    8000241a:	854e                	mv	a0,s3
    8000241c:	fffff097          	auipc	ra,0xfffff
    80002420:	904080e7          	jalr	-1788(ra) # 80000d20 <acquire>
  p->xstate = status;
    80002424:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002428:	4795                	li	a5,5
    8000242a:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    8000242e:	00006797          	auipc	a5,0x6
    80002432:	7627a783          	lw	a5,1890(a5) # 80008b90 <ticks>
    80002436:	18f9a023          	sw	a5,384(s3)
  release(&wait_lock);
    8000243a:	8526                	mv	a0,s1
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	998080e7          	jalr	-1640(ra) # 80000dd4 <release>
  sched();
    80002444:	00000097          	auipc	ra,0x0
    80002448:	e60080e7          	jalr	-416(ra) # 800022a4 <sched>
  panic("zombie exit");
    8000244c:	00006517          	auipc	a0,0x6
    80002450:	e5c50513          	addi	a0,a0,-420 # 800082a8 <digits+0x268>
    80002454:	ffffe097          	auipc	ra,0xffffe
    80002458:	0f0080e7          	jalr	240(ra) # 80000544 <panic>

000000008000245c <yield>:
{
    8000245c:	1101                	addi	sp,sp,-32
    8000245e:	ec06                	sd	ra,24(sp)
    80002460:	e822                	sd	s0,16(sp)
    80002462:	e426                	sd	s1,8(sp)
    80002464:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	6ea080e7          	jalr	1770(ra) # 80001b50 <myproc>
    8000246e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	8b0080e7          	jalr	-1872(ra) # 80000d20 <acquire>
  p->state = RUNNABLE;
    80002478:	478d                	li	a5,3
    8000247a:	cc9c                	sw	a5,24(s1)
  sched();
    8000247c:	00000097          	auipc	ra,0x0
    80002480:	e28080e7          	jalr	-472(ra) # 800022a4 <sched>
  release(&p->lock);
    80002484:	8526                	mv	a0,s1
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	94e080e7          	jalr	-1714(ra) # 80000dd4 <release>
}
    8000248e:	60e2                	ld	ra,24(sp)
    80002490:	6442                	ld	s0,16(sp)
    80002492:	64a2                	ld	s1,8(sp)
    80002494:	6105                	addi	sp,sp,32
    80002496:	8082                	ret

0000000080002498 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002498:	7179                	addi	sp,sp,-48
    8000249a:	f406                	sd	ra,40(sp)
    8000249c:	f022                	sd	s0,32(sp)
    8000249e:	ec26                	sd	s1,24(sp)
    800024a0:	e84a                	sd	s2,16(sp)
    800024a2:	e44e                	sd	s3,8(sp)
    800024a4:	1800                	addi	s0,sp,48
    800024a6:	89aa                	mv	s3,a0
    800024a8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800024aa:	fffff097          	auipc	ra,0xfffff
    800024ae:	6a6080e7          	jalr	1702(ra) # 80001b50 <myproc>
    800024b2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup1
  // (wakeup1 locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); //DOC: sleeplock1
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	86c080e7          	jalr	-1940(ra) # 80000d20 <acquire>
  release(lk);
    800024bc:	854a                	mv	a0,s2
    800024be:	fffff097          	auipc	ra,0xfffff
    800024c2:	916080e7          	jalr	-1770(ra) # 80000dd4 <release>

  // Go to sleep.
  p->chan = chan;
    800024c6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800024ca:	4789                	li	a5,2
    800024cc:	cc9c                	sw	a5,24(s1)

  sched();
    800024ce:	00000097          	auipc	ra,0x0
    800024d2:	dd6080e7          	jalr	-554(ra) # 800022a4 <sched>

  // Tidy up.
  p->chan = 0;
    800024d6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800024da:	8526                	mv	a0,s1
    800024dc:	fffff097          	auipc	ra,0xfffff
    800024e0:	8f8080e7          	jalr	-1800(ra) # 80000dd4 <release>
  acquire(lk);
    800024e4:	854a                	mv	a0,s2
    800024e6:	fffff097          	auipc	ra,0xfffff
    800024ea:	83a080e7          	jalr	-1990(ra) # 80000d20 <acquire>
}
    800024ee:	70a2                	ld	ra,40(sp)
    800024f0:	7402                	ld	s0,32(sp)
    800024f2:	64e2                	ld	s1,24(sp)
    800024f4:	6942                	ld	s2,16(sp)
    800024f6:	69a2                	ld	s3,8(sp)
    800024f8:	6145                	addi	sp,sp,48
    800024fa:	8082                	ret

00000000800024fc <waitx>:
{
    800024fc:	711d                	addi	sp,sp,-96
    800024fe:	ec86                	sd	ra,88(sp)
    80002500:	e8a2                	sd	s0,80(sp)
    80002502:	e4a6                	sd	s1,72(sp)
    80002504:	e0ca                	sd	s2,64(sp)
    80002506:	fc4e                	sd	s3,56(sp)
    80002508:	f852                	sd	s4,48(sp)
    8000250a:	f456                	sd	s5,40(sp)
    8000250c:	f05a                	sd	s6,32(sp)
    8000250e:	ec5e                	sd	s7,24(sp)
    80002510:	e862                	sd	s8,16(sp)
    80002512:	e466                	sd	s9,8(sp)
    80002514:	e06a                	sd	s10,0(sp)
    80002516:	1080                	addi	s0,sp,96
    80002518:	8b2a                	mv	s6,a0
    8000251a:	8bae                	mv	s7,a1
    8000251c:	8c32                	mv	s8,a2
  struct proc *p = myproc();
    8000251e:	fffff097          	auipc	ra,0xfffff
    80002522:	632080e7          	jalr	1586(ra) # 80001b50 <myproc>
    80002526:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002528:	0022f517          	auipc	a0,0x22f
    8000252c:	8f050513          	addi	a0,a0,-1808 # 80230e18 <wait_lock>
    80002530:	ffffe097          	auipc	ra,0xffffe
    80002534:	7f0080e7          	jalr	2032(ra) # 80000d20 <acquire>
    havekids = 0;
    80002538:	4c81                	li	s9,0
        if (np->state == ZOMBIE)
    8000253a:	4a15                	li	s4,5
    for (np = proc; np < &proc[NPROC]; np++)
    8000253c:	0023b997          	auipc	s3,0x23b
    80002540:	10c98993          	addi	s3,s3,268 # 8023d648 <tickslock>
        havekids = 1;
    80002544:	4a85                	li	s5,1
    sleep(p, &wait_lock); //DOC: wait-sleep
    80002546:	0022fd17          	auipc	s10,0x22f
    8000254a:	8d2d0d13          	addi	s10,s10,-1838 # 80230e18 <wait_lock>
    havekids = 0;
    8000254e:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002550:	0022f497          	auipc	s1,0x22f
    80002554:	6f848493          	addi	s1,s1,1784 # 80231c48 <proc>
    80002558:	a059                	j	800025de <waitx+0xe2>
          pid = np->pid;
    8000255a:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    8000255e:	1784a703          	lw	a4,376(s1)
    80002562:	00ec2023          	sw	a4,0(s8) # 4000000 <_entry-0x7c000000>
          *wtime = np->etime - np->ctime - np->rtime;
    80002566:	17c4a783          	lw	a5,380(s1)
    8000256a:	9f3d                	addw	a4,a4,a5
    8000256c:	1804a783          	lw	a5,384(s1)
    80002570:	9f99                	subw	a5,a5,a4
    80002572:	00fba023          	sw	a5,0(s7) # fffffffffffff000 <end+0xffffffff7fdb5258>
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002576:	000b0e63          	beqz	s6,80002592 <waitx+0x96>
    8000257a:	4691                	li	a3,4
    8000257c:	02c48613          	addi	a2,s1,44
    80002580:	85da                	mv	a1,s6
    80002582:	06093503          	ld	a0,96(s2)
    80002586:	fffff097          	auipc	ra,0xfffff
    8000258a:	21a080e7          	jalr	538(ra) # 800017a0 <copyout>
    8000258e:	02054563          	bltz	a0,800025b8 <waitx+0xbc>
          freeproc(np);
    80002592:	8526                	mv	a0,s1
    80002594:	fffff097          	auipc	ra,0xfffff
    80002598:	76e080e7          	jalr	1902(ra) # 80001d02 <freeproc>
          release(&np->lock);
    8000259c:	8526                	mv	a0,s1
    8000259e:	fffff097          	auipc	ra,0xfffff
    800025a2:	836080e7          	jalr	-1994(ra) # 80000dd4 <release>
          release(&wait_lock);
    800025a6:	0022f517          	auipc	a0,0x22f
    800025aa:	87250513          	addi	a0,a0,-1934 # 80230e18 <wait_lock>
    800025ae:	fffff097          	auipc	ra,0xfffff
    800025b2:	826080e7          	jalr	-2010(ra) # 80000dd4 <release>
          return pid;
    800025b6:	a09d                	j	8000261c <waitx+0x120>
            release(&np->lock);
    800025b8:	8526                	mv	a0,s1
    800025ba:	fffff097          	auipc	ra,0xfffff
    800025be:	81a080e7          	jalr	-2022(ra) # 80000dd4 <release>
            release(&wait_lock);
    800025c2:	0022f517          	auipc	a0,0x22f
    800025c6:	85650513          	addi	a0,a0,-1962 # 80230e18 <wait_lock>
    800025ca:	fffff097          	auipc	ra,0xfffff
    800025ce:	80a080e7          	jalr	-2038(ra) # 80000dd4 <release>
            return -1;
    800025d2:	59fd                	li	s3,-1
    800025d4:	a0a1                	j	8000261c <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    800025d6:	2e848493          	addi	s1,s1,744
    800025da:	03348463          	beq	s1,s3,80002602 <waitx+0x106>
      if (np->parent == p)
    800025de:	64bc                	ld	a5,72(s1)
    800025e0:	ff279be3          	bne	a5,s2,800025d6 <waitx+0xda>
        acquire(&np->lock);
    800025e4:	8526                	mv	a0,s1
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	73a080e7          	jalr	1850(ra) # 80000d20 <acquire>
        if (np->state == ZOMBIE)
    800025ee:	4c9c                	lw	a5,24(s1)
    800025f0:	f74785e3          	beq	a5,s4,8000255a <waitx+0x5e>
        release(&np->lock);
    800025f4:	8526                	mv	a0,s1
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	7de080e7          	jalr	2014(ra) # 80000dd4 <release>
        havekids = 1;
    800025fe:	8756                	mv	a4,s5
    80002600:	bfd9                	j	800025d6 <waitx+0xda>
    if (!havekids || p->killed)
    80002602:	c701                	beqz	a4,8000260a <waitx+0x10e>
    80002604:	02892783          	lw	a5,40(s2)
    80002608:	cb8d                	beqz	a5,8000263a <waitx+0x13e>
      release(&wait_lock);
    8000260a:	0022f517          	auipc	a0,0x22f
    8000260e:	80e50513          	addi	a0,a0,-2034 # 80230e18 <wait_lock>
    80002612:	ffffe097          	auipc	ra,0xffffe
    80002616:	7c2080e7          	jalr	1986(ra) # 80000dd4 <release>
      return -1;
    8000261a:	59fd                	li	s3,-1
}
    8000261c:	854e                	mv	a0,s3
    8000261e:	60e6                	ld	ra,88(sp)
    80002620:	6446                	ld	s0,80(sp)
    80002622:	64a6                	ld	s1,72(sp)
    80002624:	6906                	ld	s2,64(sp)
    80002626:	79e2                	ld	s3,56(sp)
    80002628:	7a42                	ld	s4,48(sp)
    8000262a:	7aa2                	ld	s5,40(sp)
    8000262c:	7b02                	ld	s6,32(sp)
    8000262e:	6be2                	ld	s7,24(sp)
    80002630:	6c42                	ld	s8,16(sp)
    80002632:	6ca2                	ld	s9,8(sp)
    80002634:	6d02                	ld	s10,0(sp)
    80002636:	6125                	addi	sp,sp,96
    80002638:	8082                	ret
    sleep(p, &wait_lock); //DOC: wait-sleep
    8000263a:	85ea                	mv	a1,s10
    8000263c:	854a                	mv	a0,s2
    8000263e:	00000097          	auipc	ra,0x0
    80002642:	e5a080e7          	jalr	-422(ra) # 80002498 <sleep>
    havekids = 0;
    80002646:	b721                	j	8000254e <waitx+0x52>

0000000080002648 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002648:	7179                	addi	sp,sp,-48
    8000264a:	f406                	sd	ra,40(sp)
    8000264c:	f022                	sd	s0,32(sp)
    8000264e:	ec26                	sd	s1,24(sp)
    80002650:	e84a                	sd	s2,16(sp)
    80002652:	e44e                	sd	s3,8(sp)
    80002654:	1800                	addi	s0,sp,48
    80002656:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002658:	0022f497          	auipc	s1,0x22f
    8000265c:	5f048493          	addi	s1,s1,1520 # 80231c48 <proc>
    80002660:	0023b997          	auipc	s3,0x23b
    80002664:	fe898993          	addi	s3,s3,-24 # 8023d648 <tickslock>
  {
    acquire(&p->lock);
    80002668:	8526                	mv	a0,s1
    8000266a:	ffffe097          	auipc	ra,0xffffe
    8000266e:	6b6080e7          	jalr	1718(ra) # 80000d20 <acquire>
    if (p->pid == pid)
    80002672:	589c                	lw	a5,48(s1)
    80002674:	01278d63          	beq	a5,s2,8000268e <kill+0x46>
        #endif
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002678:	8526                	mv	a0,s1
    8000267a:	ffffe097          	auipc	ra,0xffffe
    8000267e:	75a080e7          	jalr	1882(ra) # 80000dd4 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002682:	2e848493          	addi	s1,s1,744
    80002686:	ff3491e3          	bne	s1,s3,80002668 <kill+0x20>
  }
  return -1;
    8000268a:	557d                	li	a0,-1
    8000268c:	a829                	j	800026a6 <kill+0x5e>
      p->killed = 1;
    8000268e:	4785                	li	a5,1
    80002690:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002692:	4c98                	lw	a4,24(s1)
    80002694:	4789                	li	a5,2
    80002696:	00f70f63          	beq	a4,a5,800026b4 <kill+0x6c>
      release(&p->lock);
    8000269a:	8526                	mv	a0,s1
    8000269c:	ffffe097          	auipc	ra,0xffffe
    800026a0:	738080e7          	jalr	1848(ra) # 80000dd4 <release>
      return 0;
    800026a4:	4501                	li	a0,0
}
    800026a6:	70a2                	ld	ra,40(sp)
    800026a8:	7402                	ld	s0,32(sp)
    800026aa:	64e2                	ld	s1,24(sp)
    800026ac:	6942                	ld	s2,16(sp)
    800026ae:	69a2                	ld	s3,8(sp)
    800026b0:	6145                	addi	sp,sp,48
    800026b2:	8082                	ret
        p->state = RUNNABLE;
    800026b4:	478d                	li	a5,3
    800026b6:	cc9c                	sw	a5,24(s1)
    800026b8:	b7cd                	j	8000269a <kill+0x52>

00000000800026ba <setkilled>:

void setkilled(struct proc *p)
{
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	1000                	addi	s0,sp,32
    800026c4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800026c6:	ffffe097          	auipc	ra,0xffffe
    800026ca:	65a080e7          	jalr	1626(ra) # 80000d20 <acquire>
  p->killed = 1;
    800026ce:	4785                	li	a5,1
    800026d0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800026d2:	8526                	mv	a0,s1
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	700080e7          	jalr	1792(ra) # 80000dd4 <release>
}
    800026dc:	60e2                	ld	ra,24(sp)
    800026de:	6442                	ld	s0,16(sp)
    800026e0:	64a2                	ld	s1,8(sp)
    800026e2:	6105                	addi	sp,sp,32
    800026e4:	8082                	ret

00000000800026e6 <killed>:

int killed(struct proc *p)
{
    800026e6:	1101                	addi	sp,sp,-32
    800026e8:	ec06                	sd	ra,24(sp)
    800026ea:	e822                	sd	s0,16(sp)
    800026ec:	e426                	sd	s1,8(sp)
    800026ee:	e04a                	sd	s2,0(sp)
    800026f0:	1000                	addi	s0,sp,32
    800026f2:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800026f4:	ffffe097          	auipc	ra,0xffffe
    800026f8:	62c080e7          	jalr	1580(ra) # 80000d20 <acquire>
  k = p->killed;
    800026fc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002700:	8526                	mv	a0,s1
    80002702:	ffffe097          	auipc	ra,0xffffe
    80002706:	6d2080e7          	jalr	1746(ra) # 80000dd4 <release>
  return k;
}
    8000270a:	854a                	mv	a0,s2
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6902                	ld	s2,0(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret

0000000080002718 <wait>:
{
    80002718:	715d                	addi	sp,sp,-80
    8000271a:	e486                	sd	ra,72(sp)
    8000271c:	e0a2                	sd	s0,64(sp)
    8000271e:	fc26                	sd	s1,56(sp)
    80002720:	f84a                	sd	s2,48(sp)
    80002722:	f44e                	sd	s3,40(sp)
    80002724:	f052                	sd	s4,32(sp)
    80002726:	ec56                	sd	s5,24(sp)
    80002728:	e85a                	sd	s6,16(sp)
    8000272a:	e45e                	sd	s7,8(sp)
    8000272c:	e062                	sd	s8,0(sp)
    8000272e:	0880                	addi	s0,sp,80
    80002730:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002732:	fffff097          	auipc	ra,0xfffff
    80002736:	41e080e7          	jalr	1054(ra) # 80001b50 <myproc>
    8000273a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000273c:	0022e517          	auipc	a0,0x22e
    80002740:	6dc50513          	addi	a0,a0,1756 # 80230e18 <wait_lock>
    80002744:	ffffe097          	auipc	ra,0xffffe
    80002748:	5dc080e7          	jalr	1500(ra) # 80000d20 <acquire>
    havekids = 0;
    8000274c:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    8000274e:	4a15                	li	s4,5
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002750:	0023b997          	auipc	s3,0x23b
    80002754:	ef898993          	addi	s3,s3,-264 # 8023d648 <tickslock>
        havekids = 1;
    80002758:	4a85                	li	s5,1
    sleep(p, &wait_lock); //DOC: wait-sleep
    8000275a:	0022ec17          	auipc	s8,0x22e
    8000275e:	6bec0c13          	addi	s8,s8,1726 # 80230e18 <wait_lock>
    havekids = 0;
    80002762:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002764:	0022f497          	auipc	s1,0x22f
    80002768:	4e448493          	addi	s1,s1,1252 # 80231c48 <proc>
    8000276c:	a0bd                	j	800027da <wait+0xc2>
          pid = pp->pid;
    8000276e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002772:	000b0e63          	beqz	s6,8000278e <wait+0x76>
    80002776:	4691                	li	a3,4
    80002778:	02c48613          	addi	a2,s1,44
    8000277c:	85da                	mv	a1,s6
    8000277e:	06093503          	ld	a0,96(s2)
    80002782:	fffff097          	auipc	ra,0xfffff
    80002786:	01e080e7          	jalr	30(ra) # 800017a0 <copyout>
    8000278a:	02054563          	bltz	a0,800027b4 <wait+0x9c>
          freeproc(pp);
    8000278e:	8526                	mv	a0,s1
    80002790:	fffff097          	auipc	ra,0xfffff
    80002794:	572080e7          	jalr	1394(ra) # 80001d02 <freeproc>
          release(&pp->lock);
    80002798:	8526                	mv	a0,s1
    8000279a:	ffffe097          	auipc	ra,0xffffe
    8000279e:	63a080e7          	jalr	1594(ra) # 80000dd4 <release>
          release(&wait_lock);
    800027a2:	0022e517          	auipc	a0,0x22e
    800027a6:	67650513          	addi	a0,a0,1654 # 80230e18 <wait_lock>
    800027aa:	ffffe097          	auipc	ra,0xffffe
    800027ae:	62a080e7          	jalr	1578(ra) # 80000dd4 <release>
          return pid;
    800027b2:	a0b5                	j	8000281e <wait+0x106>
            release(&pp->lock);
    800027b4:	8526                	mv	a0,s1
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	61e080e7          	jalr	1566(ra) # 80000dd4 <release>
            release(&wait_lock);
    800027be:	0022e517          	auipc	a0,0x22e
    800027c2:	65a50513          	addi	a0,a0,1626 # 80230e18 <wait_lock>
    800027c6:	ffffe097          	auipc	ra,0xffffe
    800027ca:	60e080e7          	jalr	1550(ra) # 80000dd4 <release>
            return -1;
    800027ce:	59fd                	li	s3,-1
    800027d0:	a0b9                	j	8000281e <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027d2:	2e848493          	addi	s1,s1,744
    800027d6:	03348463          	beq	s1,s3,800027fe <wait+0xe6>
      if (pp->parent == p)
    800027da:	64bc                	ld	a5,72(s1)
    800027dc:	ff279be3          	bne	a5,s2,800027d2 <wait+0xba>
        acquire(&pp->lock);
    800027e0:	8526                	mv	a0,s1
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	53e080e7          	jalr	1342(ra) # 80000d20 <acquire>
        if (pp->state == ZOMBIE)
    800027ea:	4c9c                	lw	a5,24(s1)
    800027ec:	f94781e3          	beq	a5,s4,8000276e <wait+0x56>
        release(&pp->lock);
    800027f0:	8526                	mv	a0,s1
    800027f2:	ffffe097          	auipc	ra,0xffffe
    800027f6:	5e2080e7          	jalr	1506(ra) # 80000dd4 <release>
        havekids = 1;
    800027fa:	8756                	mv	a4,s5
    800027fc:	bfd9                	j	800027d2 <wait+0xba>
    if (!havekids || killed(p))
    800027fe:	c719                	beqz	a4,8000280c <wait+0xf4>
    80002800:	854a                	mv	a0,s2
    80002802:	00000097          	auipc	ra,0x0
    80002806:	ee4080e7          	jalr	-284(ra) # 800026e6 <killed>
    8000280a:	c51d                	beqz	a0,80002838 <wait+0x120>
      release(&wait_lock);
    8000280c:	0022e517          	auipc	a0,0x22e
    80002810:	60c50513          	addi	a0,a0,1548 # 80230e18 <wait_lock>
    80002814:	ffffe097          	auipc	ra,0xffffe
    80002818:	5c0080e7          	jalr	1472(ra) # 80000dd4 <release>
      return -1;
    8000281c:	59fd                	li	s3,-1
}
    8000281e:	854e                	mv	a0,s3
    80002820:	60a6                	ld	ra,72(sp)
    80002822:	6406                	ld	s0,64(sp)
    80002824:	74e2                	ld	s1,56(sp)
    80002826:	7942                	ld	s2,48(sp)
    80002828:	79a2                	ld	s3,40(sp)
    8000282a:	7a02                	ld	s4,32(sp)
    8000282c:	6ae2                	ld	s5,24(sp)
    8000282e:	6b42                	ld	s6,16(sp)
    80002830:	6ba2                	ld	s7,8(sp)
    80002832:	6c02                	ld	s8,0(sp)
    80002834:	6161                	addi	sp,sp,80
    80002836:	8082                	ret
    sleep(p, &wait_lock); //DOC: wait-sleep
    80002838:	85e2                	mv	a1,s8
    8000283a:	854a                	mv	a0,s2
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	c5c080e7          	jalr	-932(ra) # 80002498 <sleep>
    havekids = 0;
    80002844:	bf39                	j	80002762 <wait+0x4a>

0000000080002846 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002846:	7179                	addi	sp,sp,-48
    80002848:	f406                	sd	ra,40(sp)
    8000284a:	f022                	sd	s0,32(sp)
    8000284c:	ec26                	sd	s1,24(sp)
    8000284e:	e84a                	sd	s2,16(sp)
    80002850:	e44e                	sd	s3,8(sp)
    80002852:	e052                	sd	s4,0(sp)
    80002854:	1800                	addi	s0,sp,48
    80002856:	84aa                	mv	s1,a0
    80002858:	892e                	mv	s2,a1
    8000285a:	89b2                	mv	s3,a2
    8000285c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000285e:	fffff097          	auipc	ra,0xfffff
    80002862:	2f2080e7          	jalr	754(ra) # 80001b50 <myproc>
  if (user_dst)
    80002866:	c08d                	beqz	s1,80002888 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80002868:	86d2                	mv	a3,s4
    8000286a:	864e                	mv	a2,s3
    8000286c:	85ca                	mv	a1,s2
    8000286e:	7128                	ld	a0,96(a0)
    80002870:	fffff097          	auipc	ra,0xfffff
    80002874:	f30080e7          	jalr	-208(ra) # 800017a0 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002878:	70a2                	ld	ra,40(sp)
    8000287a:	7402                	ld	s0,32(sp)
    8000287c:	64e2                	ld	s1,24(sp)
    8000287e:	6942                	ld	s2,16(sp)
    80002880:	69a2                	ld	s3,8(sp)
    80002882:	6a02                	ld	s4,0(sp)
    80002884:	6145                	addi	sp,sp,48
    80002886:	8082                	ret
    memmove((char *)dst, src, len);
    80002888:	000a061b          	sext.w	a2,s4
    8000288c:	85ce                	mv	a1,s3
    8000288e:	854a                	mv	a0,s2
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	5ec080e7          	jalr	1516(ra) # 80000e7c <memmove>
    return 0;
    80002898:	8526                	mv	a0,s1
    8000289a:	bff9                	j	80002878 <either_copyout+0x32>

000000008000289c <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000289c:	7179                	addi	sp,sp,-48
    8000289e:	f406                	sd	ra,40(sp)
    800028a0:	f022                	sd	s0,32(sp)
    800028a2:	ec26                	sd	s1,24(sp)
    800028a4:	e84a                	sd	s2,16(sp)
    800028a6:	e44e                	sd	s3,8(sp)
    800028a8:	e052                	sd	s4,0(sp)
    800028aa:	1800                	addi	s0,sp,48
    800028ac:	892a                	mv	s2,a0
    800028ae:	84ae                	mv	s1,a1
    800028b0:	89b2                	mv	s3,a2
    800028b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028b4:	fffff097          	auipc	ra,0xfffff
    800028b8:	29c080e7          	jalr	668(ra) # 80001b50 <myproc>
  if (user_src)
    800028bc:	c08d                	beqz	s1,800028de <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    800028be:	86d2                	mv	a3,s4
    800028c0:	864e                	mv	a2,s3
    800028c2:	85ca                	mv	a1,s2
    800028c4:	7128                	ld	a0,96(a0)
    800028c6:	fffff097          	auipc	ra,0xfffff
    800028ca:	f9a080e7          	jalr	-102(ra) # 80001860 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800028ce:	70a2                	ld	ra,40(sp)
    800028d0:	7402                	ld	s0,32(sp)
    800028d2:	64e2                	ld	s1,24(sp)
    800028d4:	6942                	ld	s2,16(sp)
    800028d6:	69a2                	ld	s3,8(sp)
    800028d8:	6a02                	ld	s4,0(sp)
    800028da:	6145                	addi	sp,sp,48
    800028dc:	8082                	ret
    memmove(dst, (char *)src, len);
    800028de:	000a061b          	sext.w	a2,s4
    800028e2:	85ce                	mv	a1,s3
    800028e4:	854a                	mv	a0,s2
    800028e6:	ffffe097          	auipc	ra,0xffffe
    800028ea:	596080e7          	jalr	1430(ra) # 80000e7c <memmove>
    return 0;
    800028ee:	8526                	mv	a0,s1
    800028f0:	bff9                	j	800028ce <either_copyin+0x32>

00000000800028f2 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800028f2:	715d                	addi	sp,sp,-80
    800028f4:	e486                	sd	ra,72(sp)
    800028f6:	e0a2                	sd	s0,64(sp)
    800028f8:	fc26                	sd	s1,56(sp)
    800028fa:	f84a                	sd	s2,48(sp)
    800028fc:	f44e                	sd	s3,40(sp)
    800028fe:	f052                	sd	s4,32(sp)
    80002900:	ec56                	sd	s5,24(sp)
    80002902:	e85a                	sd	s6,16(sp)
    80002904:	e45e                	sd	s7,8(sp)
    80002906:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002908:	00005517          	auipc	a0,0x5
    8000290c:	7f850513          	addi	a0,a0,2040 # 80008100 <digits+0xc0>
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	c7e080e7          	jalr	-898(ra) # 8000058e <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002918:	0022f497          	auipc	s1,0x22f
    8000291c:	49848493          	addi	s1,s1,1176 # 80231db0 <proc+0x168>
    80002920:	0023b917          	auipc	s2,0x23b
    80002924:	e9090913          	addi	s2,s2,-368 # 8023d7b0 <bcache+0x150>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002928:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000292a:	00006997          	auipc	s3,0x6
    8000292e:	98e98993          	addi	s3,s3,-1650 # 800082b8 <digits+0x278>
    printf("%d %s %s", p->pid, state, p->name);
    80002932:	00006a97          	auipc	s5,0x6
    80002936:	98ea8a93          	addi	s5,s5,-1650 # 800082c0 <digits+0x280>
    printf("\n");
    8000293a:	00005a17          	auipc	s4,0x5
    8000293e:	7c6a0a13          	addi	s4,s4,1990 # 80008100 <digits+0xc0>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002942:	00006b97          	auipc	s7,0x6
    80002946:	9beb8b93          	addi	s7,s7,-1602 # 80008300 <states.1983>
    8000294a:	a00d                	j	8000296c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000294c:	ec86a583          	lw	a1,-312(a3)
    80002950:	8556                	mv	a0,s5
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	c3c080e7          	jalr	-964(ra) # 8000058e <printf>
    printf("\n");
    8000295a:	8552                	mv	a0,s4
    8000295c:	ffffe097          	auipc	ra,0xffffe
    80002960:	c32080e7          	jalr	-974(ra) # 8000058e <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002964:	2e848493          	addi	s1,s1,744
    80002968:	03248163          	beq	s1,s2,8000298a <procdump+0x98>
    if (p->state == UNUSED)
    8000296c:	86a6                	mv	a3,s1
    8000296e:	eb04a783          	lw	a5,-336(s1)
    80002972:	dbed                	beqz	a5,80002964 <procdump+0x72>
      state = "???";
    80002974:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002976:	fcfb6be3          	bltu	s6,a5,8000294c <procdump+0x5a>
    8000297a:	1782                	slli	a5,a5,0x20
    8000297c:	9381                	srli	a5,a5,0x20
    8000297e:	078e                	slli	a5,a5,0x3
    80002980:	97de                	add	a5,a5,s7
    80002982:	6390                	ld	a2,0(a5)
    80002984:	f661                	bnez	a2,8000294c <procdump+0x5a>
      state = "???";
    80002986:	864e                	mv	a2,s3
    80002988:	b7d1                	j	8000294c <procdump+0x5a>
  }
}
    8000298a:	60a6                	ld	ra,72(sp)
    8000298c:	6406                	ld	s0,64(sp)
    8000298e:	74e2                	ld	s1,56(sp)
    80002990:	7942                	ld	s2,48(sp)
    80002992:	79a2                	ld	s3,40(sp)
    80002994:	7a02                	ld	s4,32(sp)
    80002996:	6ae2                	ld	s5,24(sp)
    80002998:	6b42                	ld	s6,16(sp)
    8000299a:	6ba2                	ld	s7,8(sp)
    8000299c:	6161                	addi	sp,sp,80
    8000299e:	8082                	ret

00000000800029a0 <set_priority>:

int set_priority(int priority, int pid)
{
    800029a0:	7179                	addi	sp,sp,-48
    800029a2:	f406                	sd	ra,40(sp)
    800029a4:	f022                	sd	s0,32(sp)
    800029a6:	ec26                	sd	s1,24(sp)
    800029a8:	e84a                	sd	s2,16(sp)
    800029aa:	e44e                	sd	s3,8(sp)
    800029ac:	e052                	sd	s4,0(sp)
    800029ae:	1800                	addi	s0,sp,48
    800029b0:	8a2a                	mv	s4,a0
    800029b2:	892e                	mv	s2,a1
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800029b4:	0022f497          	auipc	s1,0x22f
    800029b8:	29448493          	addi	s1,s1,660 # 80231c48 <proc>
    800029bc:	0023b997          	auipc	s3,0x23b
    800029c0:	c8c98993          	addi	s3,s3,-884 # 8023d648 <tickslock>
  {
    acquire(&p->lock);
    800029c4:	8526                	mv	a0,s1
    800029c6:	ffffe097          	auipc	ra,0xffffe
    800029ca:	35a080e7          	jalr	858(ra) # 80000d20 <acquire>

    if (p->pid == pid)
    800029ce:	589c                	lw	a5,48(s1)
    800029d0:	01278d63          	beq	a5,s2,800029ea <set_priority+0x4a>

      if (val > priority)
        yield();
      return val;
    }
    release(&p->lock);
    800029d4:	8526                	mv	a0,s1
    800029d6:	ffffe097          	auipc	ra,0xffffe
    800029da:	3fe080e7          	jalr	1022(ra) # 80000dd4 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800029de:	2e848493          	addi	s1,s1,744
    800029e2:	ff3491e3          	bne	s1,s3,800029c4 <set_priority+0x24>
  }
  return -1;
    800029e6:	597d                	li	s2,-1
    800029e8:	a005                	j	80002a08 <set_priority+0x68>
      int val = p->sp;
    800029ea:	03c4a903          	lw	s2,60(s1)
      p->sp = priority;
    800029ee:	0344ae23          	sw	s4,60(s1)
      p->rtime = 0;
    800029f2:	1604ac23          	sw	zero,376(s1)
      p->slep = 0;
    800029f6:	0404a223          	sw	zero,68(s1)
      release(&p->lock);
    800029fa:	8526                	mv	a0,s1
    800029fc:	ffffe097          	auipc	ra,0xffffe
    80002a00:	3d8080e7          	jalr	984(ra) # 80000dd4 <release>
      if (val > priority)
    80002a04:	012a4b63          	blt	s4,s2,80002a1a <set_priority+0x7a>
    80002a08:	854a                	mv	a0,s2
    80002a0a:	70a2                	ld	ra,40(sp)
    80002a0c:	7402                	ld	s0,32(sp)
    80002a0e:	64e2                	ld	s1,24(sp)
    80002a10:	6942                	ld	s2,16(sp)
    80002a12:	69a2                	ld	s3,8(sp)
    80002a14:	6a02                	ld	s4,0(sp)
    80002a16:	6145                	addi	sp,sp,48
    80002a18:	8082                	ret
        yield();
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	a42080e7          	jalr	-1470(ra) # 8000245c <yield>
    80002a22:	b7dd                	j	80002a08 <set_priority+0x68>

0000000080002a24 <swtch>:
    80002a24:	00153023          	sd	ra,0(a0)
    80002a28:	00253423          	sd	sp,8(a0)
    80002a2c:	e900                	sd	s0,16(a0)
    80002a2e:	ed04                	sd	s1,24(a0)
    80002a30:	03253023          	sd	s2,32(a0)
    80002a34:	03353423          	sd	s3,40(a0)
    80002a38:	03453823          	sd	s4,48(a0)
    80002a3c:	03553c23          	sd	s5,56(a0)
    80002a40:	05653023          	sd	s6,64(a0)
    80002a44:	05753423          	sd	s7,72(a0)
    80002a48:	05853823          	sd	s8,80(a0)
    80002a4c:	05953c23          	sd	s9,88(a0)
    80002a50:	07a53023          	sd	s10,96(a0)
    80002a54:	07b53423          	sd	s11,104(a0)
    80002a58:	0005b083          	ld	ra,0(a1)
    80002a5c:	0085b103          	ld	sp,8(a1)
    80002a60:	6980                	ld	s0,16(a1)
    80002a62:	6d84                	ld	s1,24(a1)
    80002a64:	0205b903          	ld	s2,32(a1)
    80002a68:	0285b983          	ld	s3,40(a1)
    80002a6c:	0305ba03          	ld	s4,48(a1)
    80002a70:	0385ba83          	ld	s5,56(a1)
    80002a74:	0405bb03          	ld	s6,64(a1)
    80002a78:	0485bb83          	ld	s7,72(a1)
    80002a7c:	0505bc03          	ld	s8,80(a1)
    80002a80:	0585bc83          	ld	s9,88(a1)
    80002a84:	0605bd03          	ld	s10,96(a1)
    80002a88:	0685bd83          	ld	s11,104(a1)
    80002a8c:	8082                	ret

0000000080002a8e <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002a8e:	1141                	addi	sp,sp,-16
    80002a90:	e406                	sd	ra,8(sp)
    80002a92:	e022                	sd	s0,0(sp)
    80002a94:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a96:	00006597          	auipc	a1,0x6
    80002a9a:	89a58593          	addi	a1,a1,-1894 # 80008330 <states.1983+0x30>
    80002a9e:	0023b517          	auipc	a0,0x23b
    80002aa2:	baa50513          	addi	a0,a0,-1110 # 8023d648 <tickslock>
    80002aa6:	ffffe097          	auipc	ra,0xffffe
    80002aaa:	1ea080e7          	jalr	490(ra) # 80000c90 <initlock>
}
    80002aae:	60a2                	ld	ra,8(sp)
    80002ab0:	6402                	ld	s0,0(sp)
    80002ab2:	0141                	addi	sp,sp,16
    80002ab4:	8082                	ret

0000000080002ab6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002ab6:	1141                	addi	sp,sp,-16
    80002ab8:	e422                	sd	s0,8(sp)
    80002aba:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002abc:	00003797          	auipc	a5,0x3
    80002ac0:	78478793          	addi	a5,a5,1924 # 80006240 <kernelvec>
    80002ac4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002ac8:	6422                	ld	s0,8(sp)
    80002aca:	0141                	addi	sp,sp,16
    80002acc:	8082                	ret

0000000080002ace <cowfault>:
// called from trampoline.S
//

int cowfault(pagetable_t pagetable, uint64 va)
{
  if (va >= MAXVA)
    80002ace:	57fd                	li	a5,-1
    80002ad0:	83e9                	srli	a5,a5,0x1a
    80002ad2:	06b7e863          	bltu	a5,a1,80002b42 <cowfault+0x74>
{
    80002ad6:	7179                	addi	sp,sp,-48
    80002ad8:	f406                	sd	ra,40(sp)
    80002ada:	f022                	sd	s0,32(sp)
    80002adc:	ec26                	sd	s1,24(sp)
    80002ade:	e84a                	sd	s2,16(sp)
    80002ae0:	e44e                	sd	s3,8(sp)
    80002ae2:	1800                	addi	s0,sp,48
    return -1;
  pte_t *pte = walk(pagetable, va, 0);
    80002ae4:	4601                	li	a2,0
    80002ae6:	ffffe097          	auipc	ra,0xffffe
    80002aea:	622080e7          	jalr	1570(ra) # 80001108 <walk>
    80002aee:	89aa                	mv	s3,a0
  if (pte == 0)
    80002af0:	c939                	beqz	a0,80002b46 <cowfault+0x78>
    return -1;
  if ((*pte & PTE_U) == 0 || (*pte & PTE_V) == 0)
    80002af2:	610c                	ld	a1,0(a0)
    80002af4:	0115f713          	andi	a4,a1,17
    80002af8:	47c5                	li	a5,17
    80002afa:	04f71863          	bne	a4,a5,80002b4a <cowfault+0x7c>
    return -1;
  uint64 pa1 = PTE2PA(*pte);
    80002afe:	81a9                	srli	a1,a1,0xa
    80002b00:	00c59913          	slli	s2,a1,0xc
  uint64 pa2 = (uint64)kalloc();
    80002b04:	ffffe097          	auipc	ra,0xffffe
    80002b08:	0f4080e7          	jalr	244(ra) # 80000bf8 <kalloc>
    80002b0c:	84aa                	mv	s1,a0
  if (pa2 == 0)
    80002b0e:	c121                	beqz	a0,80002b4e <cowfault+0x80>
  {
    //panic("cow panic kalloc");
    return -1;
  }

  memmove((void *)pa2, (void *)pa1, PGSIZE);
    80002b10:	6605                	lui	a2,0x1
    80002b12:	85ca                	mv	a1,s2
    80002b14:	ffffe097          	auipc	ra,0xffffe
    80002b18:	368080e7          	jalr	872(ra) # 80000e7c <memmove>
  *pte = PA2PTE(pa2) | PTE_U | PTE_V | PTE_W | PTE_X | PTE_R;
    80002b1c:	80b1                	srli	s1,s1,0xc
    80002b1e:	04aa                	slli	s1,s1,0xa
    80002b20:	01f4e493          	ori	s1,s1,31
    80002b24:	0099b023          	sd	s1,0(s3)
  kfree((void *)pa1);
    80002b28:	854a                	mv	a0,s2
    80002b2a:	ffffe097          	auipc	ra,0xffffe
    80002b2e:	f4c080e7          	jalr	-180(ra) # 80000a76 <kfree>
  return 0;
    80002b32:	4501                	li	a0,0
}
    80002b34:	70a2                	ld	ra,40(sp)
    80002b36:	7402                	ld	s0,32(sp)
    80002b38:	64e2                	ld	s1,24(sp)
    80002b3a:	6942                	ld	s2,16(sp)
    80002b3c:	69a2                	ld	s3,8(sp)
    80002b3e:	6145                	addi	sp,sp,48
    80002b40:	8082                	ret
    return -1;
    80002b42:	557d                	li	a0,-1
}
    80002b44:	8082                	ret
    return -1;
    80002b46:	557d                	li	a0,-1
    80002b48:	b7f5                	j	80002b34 <cowfault+0x66>
    return -1;
    80002b4a:	557d                	li	a0,-1
    80002b4c:	b7e5                	j	80002b34 <cowfault+0x66>
    return -1;
    80002b4e:	557d                	li	a0,-1
    80002b50:	b7d5                	j	80002b34 <cowfault+0x66>

0000000080002b52 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002b52:	1141                	addi	sp,sp,-16
    80002b54:	e406                	sd	ra,8(sp)
    80002b56:	e022                	sd	s0,0(sp)
    80002b58:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b5a:	fffff097          	auipc	ra,0xfffff
    80002b5e:	ff6080e7          	jalr	-10(ra) # 80001b50 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b68:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b6c:	00004617          	auipc	a2,0x4
    80002b70:	49460613          	addi	a2,a2,1172 # 80007000 <_trampoline>
    80002b74:	00004697          	auipc	a3,0x4
    80002b78:	48c68693          	addi	a3,a3,1164 # 80007000 <_trampoline>
    80002b7c:	8e91                	sub	a3,a3,a2
    80002b7e:	040007b7          	lui	a5,0x4000
    80002b82:	17fd                	addi	a5,a5,-1
    80002b84:	07b2                	slli	a5,a5,0xc
    80002b86:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b88:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b8c:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002b8e:	180026f3          	csrr	a3,satp
    80002b92:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b94:	7538                	ld	a4,104(a0)
    80002b96:	6934                	ld	a3,80(a0)
    80002b98:	6585                	lui	a1,0x1
    80002b9a:	96ae                	add	a3,a3,a1
    80002b9c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b9e:	7538                	ld	a4,104(a0)
    80002ba0:	00000697          	auipc	a3,0x0
    80002ba4:	13e68693          	addi	a3,a3,318 # 80002cde <usertrap>
    80002ba8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002baa:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bac:	8692                	mv	a3,tp
    80002bae:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bb0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bb4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bb8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bbc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002bc0:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bc2:	6f18                	ld	a4,24(a4)
    80002bc4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002bc8:	7128                	ld	a0,96(a0)
    80002bca:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002bcc:	00004717          	auipc	a4,0x4
    80002bd0:	4d070713          	addi	a4,a4,1232 # 8000709c <userret>
    80002bd4:	8f11                	sub	a4,a4,a2
    80002bd6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002bd8:	577d                	li	a4,-1
    80002bda:	177e                	slli	a4,a4,0x3f
    80002bdc:	8d59                	or	a0,a0,a4
    80002bde:	9782                	jalr	a5
}
    80002be0:	60a2                	ld	ra,8(sp)
    80002be2:	6402                	ld	s0,0(sp)
    80002be4:	0141                	addi	sp,sp,16
    80002be6:	8082                	ret

0000000080002be8 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002be8:	1101                	addi	sp,sp,-32
    80002bea:	ec06                	sd	ra,24(sp)
    80002bec:	e822                	sd	s0,16(sp)
    80002bee:	e426                	sd	s1,8(sp)
    80002bf0:	e04a                	sd	s2,0(sp)
    80002bf2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002bf4:	0023b917          	auipc	s2,0x23b
    80002bf8:	a5490913          	addi	s2,s2,-1452 # 8023d648 <tickslock>
    80002bfc:	854a                	mv	a0,s2
    80002bfe:	ffffe097          	auipc	ra,0xffffe
    80002c02:	122080e7          	jalr	290(ra) # 80000d20 <acquire>
  ticks++;
    80002c06:	00006497          	auipc	s1,0x6
    80002c0a:	f8a48493          	addi	s1,s1,-118 # 80008b90 <ticks>
    80002c0e:	409c                	lw	a5,0(s1)
    80002c10:	2785                	addiw	a5,a5,1
    80002c12:	c09c                	sw	a5,0(s1)
  update_time();
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	578080e7          	jalr	1400(ra) # 8000218c <update_time>
  wakeup(&ticks);
    80002c1c:	8526                	mv	a0,s1
    80002c1e:	fffff097          	auipc	ra,0xfffff
    80002c22:	4f8080e7          	jalr	1272(ra) # 80002116 <wakeup>
  release(&tickslock);
    80002c26:	854a                	mv	a0,s2
    80002c28:	ffffe097          	auipc	ra,0xffffe
    80002c2c:	1ac080e7          	jalr	428(ra) # 80000dd4 <release>
}
    80002c30:	60e2                	ld	ra,24(sp)
    80002c32:	6442                	ld	s0,16(sp)
    80002c34:	64a2                	ld	s1,8(sp)
    80002c36:	6902                	ld	s2,0(sp)
    80002c38:	6105                	addi	sp,sp,32
    80002c3a:	8082                	ret

0000000080002c3c <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002c3c:	1101                	addi	sp,sp,-32
    80002c3e:	ec06                	sd	ra,24(sp)
    80002c40:	e822                	sd	s0,16(sp)
    80002c42:	e426                	sd	s1,8(sp)
    80002c44:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c46:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80002c4a:	00074d63          	bltz	a4,80002c64 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80002c4e:	57fd                	li	a5,-1
    80002c50:	17fe                	slli	a5,a5,0x3f
    80002c52:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002c54:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002c56:	06f70363          	beq	a4,a5,80002cbc <devintr+0x80>
  }
}
    80002c5a:	60e2                	ld	ra,24(sp)
    80002c5c:	6442                	ld	s0,16(sp)
    80002c5e:	64a2                	ld	s1,8(sp)
    80002c60:	6105                	addi	sp,sp,32
    80002c62:	8082                	ret
      (scause & 0xff) == 9)
    80002c64:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80002c68:	46a5                	li	a3,9
    80002c6a:	fed792e3          	bne	a5,a3,80002c4e <devintr+0x12>
    int irq = plic_claim();
    80002c6e:	00003097          	auipc	ra,0x3
    80002c72:	6da080e7          	jalr	1754(ra) # 80006348 <plic_claim>
    80002c76:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002c78:	47a9                	li	a5,10
    80002c7a:	02f50763          	beq	a0,a5,80002ca8 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002c7e:	4785                	li	a5,1
    80002c80:	02f50963          	beq	a0,a5,80002cb2 <devintr+0x76>
    return 1;
    80002c84:	4505                	li	a0,1
    else if (irq)
    80002c86:	d8f1                	beqz	s1,80002c5a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c88:	85a6                	mv	a1,s1
    80002c8a:	00005517          	auipc	a0,0x5
    80002c8e:	6ae50513          	addi	a0,a0,1710 # 80008338 <states.1983+0x38>
    80002c92:	ffffe097          	auipc	ra,0xffffe
    80002c96:	8fc080e7          	jalr	-1796(ra) # 8000058e <printf>
      plic_complete(irq);
    80002c9a:	8526                	mv	a0,s1
    80002c9c:	00003097          	auipc	ra,0x3
    80002ca0:	6d0080e7          	jalr	1744(ra) # 8000636c <plic_complete>
    return 1;
    80002ca4:	4505                	li	a0,1
    80002ca6:	bf55                	j	80002c5a <devintr+0x1e>
      uartintr();
    80002ca8:	ffffe097          	auipc	ra,0xffffe
    80002cac:	d06080e7          	jalr	-762(ra) # 800009ae <uartintr>
    80002cb0:	b7ed                	j	80002c9a <devintr+0x5e>
      virtio_disk_intr();
    80002cb2:	00004097          	auipc	ra,0x4
    80002cb6:	be4080e7          	jalr	-1052(ra) # 80006896 <virtio_disk_intr>
    80002cba:	b7c5                	j	80002c9a <devintr+0x5e>
    if (cpuid() == 0)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	e68080e7          	jalr	-408(ra) # 80001b24 <cpuid>
    80002cc4:	c901                	beqz	a0,80002cd4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002cc6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002cca:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002ccc:	14479073          	csrw	sip,a5
    return 2;
    80002cd0:	4509                	li	a0,2
    80002cd2:	b761                	j	80002c5a <devintr+0x1e>
      clockintr();
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	f14080e7          	jalr	-236(ra) # 80002be8 <clockintr>
    80002cdc:	b7ed                	j	80002cc6 <devintr+0x8a>

0000000080002cde <usertrap>:
{
    80002cde:	1101                	addi	sp,sp,-32
    80002ce0:	ec06                	sd	ra,24(sp)
    80002ce2:	e822                	sd	s0,16(sp)
    80002ce4:	e426                	sd	s1,8(sp)
    80002ce6:	e04a                	sd	s2,0(sp)
    80002ce8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cea:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002cee:	1007f793          	andi	a5,a5,256
    80002cf2:	e7b9                	bnez	a5,80002d40 <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cf4:	00003797          	auipc	a5,0x3
    80002cf8:	54c78793          	addi	a5,a5,1356 # 80006240 <kernelvec>
    80002cfc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002d00:	fffff097          	auipc	ra,0xfffff
    80002d04:	e50080e7          	jalr	-432(ra) # 80001b50 <myproc>
    80002d08:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d0a:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d0c:	14102773          	csrr	a4,sepc
    80002d10:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d12:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002d16:	47a1                	li	a5,8
    80002d18:	02f70c63          	beq	a4,a5,80002d50 <usertrap+0x72>
    80002d1c:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80002d20:	47bd                	li	a5,15
    80002d22:	08f70063          	beq	a4,a5,80002da2 <usertrap+0xc4>
  else if ((which_dev = devintr()) != 0)
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	f16080e7          	jalr	-234(ra) # 80002c3c <devintr>
    80002d2e:	892a                	mv	s2,a0
    80002d30:	c549                	beqz	a0,80002dba <usertrap+0xdc>
  if (killed(p))
    80002d32:	8526                	mv	a0,s1
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	9b2080e7          	jalr	-1614(ra) # 800026e6 <killed>
    80002d3c:	c171                	beqz	a0,80002e00 <usertrap+0x122>
    80002d3e:	a865                	j	80002df6 <usertrap+0x118>
    panic("usertrap: not from user mode");
    80002d40:	00005517          	auipc	a0,0x5
    80002d44:	61850513          	addi	a0,a0,1560 # 80008358 <states.1983+0x58>
    80002d48:	ffffd097          	auipc	ra,0xffffd
    80002d4c:	7fc080e7          	jalr	2044(ra) # 80000544 <panic>
    if (killed(p))
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	996080e7          	jalr	-1642(ra) # 800026e6 <killed>
    80002d58:	ed1d                	bnez	a0,80002d96 <usertrap+0xb8>
    p->trapframe->epc += 4;
    80002d5a:	74b8                	ld	a4,104(s1)
    80002d5c:	6f1c                	ld	a5,24(a4)
    80002d5e:	0791                	addi	a5,a5,4
    80002d60:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d66:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d6a:	10079073          	csrw	sstatus,a5
    syscall();
    80002d6e:	00000097          	auipc	ra,0x0
    80002d72:	320080e7          	jalr	800(ra) # 8000308e <syscall>
  if (killed(p))
    80002d76:	8526                	mv	a0,s1
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	96e080e7          	jalr	-1682(ra) # 800026e6 <killed>
    80002d80:	e935                	bnez	a0,80002df4 <usertrap+0x116>
  usertrapret();
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	dd0080e7          	jalr	-560(ra) # 80002b52 <usertrapret>
}
    80002d8a:	60e2                	ld	ra,24(sp)
    80002d8c:	6442                	ld	s0,16(sp)
    80002d8e:	64a2                	ld	s1,8(sp)
    80002d90:	6902                	ld	s2,0(sp)
    80002d92:	6105                	addi	sp,sp,32
    80002d94:	8082                	ret
      exit(-1);
    80002d96:	557d                	li	a0,-1
    80002d98:	fffff097          	auipc	ra,0xfffff
    80002d9c:	5e2080e7          	jalr	1506(ra) # 8000237a <exit>
    80002da0:	bf6d                	j	80002d5a <usertrap+0x7c>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002da2:	143025f3          	csrr	a1,stval
    if ((cowfault(p->pagetable, r_stval())) < 0)
    80002da6:	7128                	ld	a0,96(a0)
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	d26080e7          	jalr	-730(ra) # 80002ace <cowfault>
    80002db0:	fc0553e3          	bgez	a0,80002d76 <usertrap+0x98>
      p->killed = 1;
    80002db4:	4785                	li	a5,1
    80002db6:	d49c                	sw	a5,40(s1)
    80002db8:	bf7d                	j	80002d76 <usertrap+0x98>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002dba:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002dbe:	5890                	lw	a2,48(s1)
    80002dc0:	00005517          	auipc	a0,0x5
    80002dc4:	5b850513          	addi	a0,a0,1464 # 80008378 <states.1983+0x78>
    80002dc8:	ffffd097          	auipc	ra,0xffffd
    80002dcc:	7c6080e7          	jalr	1990(ra) # 8000058e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dd0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dd4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dd8:	00005517          	auipc	a0,0x5
    80002ddc:	5d050513          	addi	a0,a0,1488 # 800083a8 <states.1983+0xa8>
    80002de0:	ffffd097          	auipc	ra,0xffffd
    80002de4:	7ae080e7          	jalr	1966(ra) # 8000058e <printf>
    setkilled(p);
    80002de8:	8526                	mv	a0,s1
    80002dea:	00000097          	auipc	ra,0x0
    80002dee:	8d0080e7          	jalr	-1840(ra) # 800026ba <setkilled>
    80002df2:	b751                	j	80002d76 <usertrap+0x98>
  if (killed(p))
    80002df4:	4901                	li	s2,0
    exit(-1);
    80002df6:	557d                	li	a0,-1
    80002df8:	fffff097          	auipc	ra,0xfffff
    80002dfc:	582080e7          	jalr	1410(ra) # 8000237a <exit>
  if (which_dev == 2)
    80002e00:	4789                	li	a5,2
    80002e02:	f8f910e3          	bne	s2,a5,80002d82 <usertrap+0xa4>
    if (p->alarm_interval /*&& p->alarm_handler*/)
    80002e06:	1b44a783          	lw	a5,436(s1)
    80002e0a:	cb91                	beqz	a5,80002e1e <usertrap+0x140>
      if (++p->alarm_passed == p->alarm_interval)
    80002e0c:	1b84a703          	lw	a4,440(s1)
    80002e10:	2705                	addiw	a4,a4,1
    80002e12:	0007069b          	sext.w	a3,a4
    80002e16:	1ae4ac23          	sw	a4,440(s1)
    80002e1a:	00d78763          	beq	a5,a3,80002e28 <usertrap+0x14a>
    yield();
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	63e080e7          	jalr	1598(ra) # 8000245c <yield>
    80002e26:	bfb1                	j	80002d82 <usertrap+0xa4>
        memmove(&(p->etpfm), p->trapframe, sizeof(struct trapframe));
    80002e28:	12000613          	li	a2,288
    80002e2c:	74ac                	ld	a1,104(s1)
    80002e2e:	1c848513          	addi	a0,s1,456
    80002e32:	ffffe097          	auipc	ra,0xffffe
    80002e36:	04a080e7          	jalr	74(ra) # 80000e7c <memmove>
        p->trapframe->epc = p->alarm_handler;
    80002e3a:	74bc                	ld	a5,104(s1)
    80002e3c:	1c04b703          	ld	a4,448(s1)
    80002e40:	ef98                	sd	a4,24(a5)
    80002e42:	bff1                	j	80002e1e <usertrap+0x140>

0000000080002e44 <kerneltrap>:
{
    80002e44:	7179                	addi	sp,sp,-48
    80002e46:	f406                	sd	ra,40(sp)
    80002e48:	f022                	sd	s0,32(sp)
    80002e4a:	ec26                	sd	s1,24(sp)
    80002e4c:	e84a                	sd	s2,16(sp)
    80002e4e:	e44e                	sd	s3,8(sp)
    80002e50:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e52:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e56:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e5a:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002e5e:	1004f793          	andi	a5,s1,256
    80002e62:	cb85                	beqz	a5,80002e92 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e64:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e68:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002e6a:	ef85                	bnez	a5,80002ea2 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002e6c:	00000097          	auipc	ra,0x0
    80002e70:	dd0080e7          	jalr	-560(ra) # 80002c3c <devintr>
    80002e74:	cd1d                	beqz	a0,80002eb2 <kerneltrap+0x6e>
  if ((which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING))
    80002e76:	4789                	li	a5,2
    80002e78:	06f50a63          	beq	a0,a5,80002eec <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e7c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e80:	10049073          	csrw	sstatus,s1
}
    80002e84:	70a2                	ld	ra,40(sp)
    80002e86:	7402                	ld	s0,32(sp)
    80002e88:	64e2                	ld	s1,24(sp)
    80002e8a:	6942                	ld	s2,16(sp)
    80002e8c:	69a2                	ld	s3,8(sp)
    80002e8e:	6145                	addi	sp,sp,48
    80002e90:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e92:	00005517          	auipc	a0,0x5
    80002e96:	53650513          	addi	a0,a0,1334 # 800083c8 <states.1983+0xc8>
    80002e9a:	ffffd097          	auipc	ra,0xffffd
    80002e9e:	6aa080e7          	jalr	1706(ra) # 80000544 <panic>
    panic("kerneltrap: interrupts enabled");
    80002ea2:	00005517          	auipc	a0,0x5
    80002ea6:	54e50513          	addi	a0,a0,1358 # 800083f0 <states.1983+0xf0>
    80002eaa:	ffffd097          	auipc	ra,0xffffd
    80002eae:	69a080e7          	jalr	1690(ra) # 80000544 <panic>
    printf("scause %p\n", scause);
    80002eb2:	85ce                	mv	a1,s3
    80002eb4:	00005517          	auipc	a0,0x5
    80002eb8:	55c50513          	addi	a0,a0,1372 # 80008410 <states.1983+0x110>
    80002ebc:	ffffd097          	auipc	ra,0xffffd
    80002ec0:	6d2080e7          	jalr	1746(ra) # 8000058e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ec4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ec8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ecc:	00005517          	auipc	a0,0x5
    80002ed0:	55450513          	addi	a0,a0,1364 # 80008420 <states.1983+0x120>
    80002ed4:	ffffd097          	auipc	ra,0xffffd
    80002ed8:	6ba080e7          	jalr	1722(ra) # 8000058e <printf>
    panic("kerneltrap");
    80002edc:	00005517          	auipc	a0,0x5
    80002ee0:	55c50513          	addi	a0,a0,1372 # 80008438 <states.1983+0x138>
    80002ee4:	ffffd097          	auipc	ra,0xffffd
    80002ee8:	660080e7          	jalr	1632(ra) # 80000544 <panic>
  if ((which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING))
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	c64080e7          	jalr	-924(ra) # 80001b50 <myproc>
    80002ef4:	d541                	beqz	a0,80002e7c <kerneltrap+0x38>
    80002ef6:	fffff097          	auipc	ra,0xfffff
    80002efa:	c5a080e7          	jalr	-934(ra) # 80001b50 <myproc>
    80002efe:	4d18                	lw	a4,24(a0)
    80002f00:	4791                	li	a5,4
    80002f02:	f6f71de3          	bne	a4,a5,80002e7c <kerneltrap+0x38>
    yield();
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	556080e7          	jalr	1366(ra) # 8000245c <yield>
    80002f0e:	b7bd                	j	80002e7c <kerneltrap+0x38>

0000000080002f10 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002f10:	1101                	addi	sp,sp,-32
    80002f12:	ec06                	sd	ra,24(sp)
    80002f14:	e822                	sd	s0,16(sp)
    80002f16:	e426                	sd	s1,8(sp)
    80002f18:	1000                	addi	s0,sp,32
    80002f1a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	c34080e7          	jalr	-972(ra) # 80001b50 <myproc>
  switch (n)
    80002f24:	4795                	li	a5,5
    80002f26:	0497e163          	bltu	a5,s1,80002f68 <argraw+0x58>
    80002f2a:	048a                	slli	s1,s1,0x2
    80002f2c:	00005717          	auipc	a4,0x5
    80002f30:	65470713          	addi	a4,a4,1620 # 80008580 <states.1983+0x280>
    80002f34:	94ba                	add	s1,s1,a4
    80002f36:	409c                	lw	a5,0(s1)
    80002f38:	97ba                	add	a5,a5,a4
    80002f3a:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    80002f3c:	753c                	ld	a5,104(a0)
    80002f3e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002f40:	60e2                	ld	ra,24(sp)
    80002f42:	6442                	ld	s0,16(sp)
    80002f44:	64a2                	ld	s1,8(sp)
    80002f46:	6105                	addi	sp,sp,32
    80002f48:	8082                	ret
    return p->trapframe->a1;
    80002f4a:	753c                	ld	a5,104(a0)
    80002f4c:	7fa8                	ld	a0,120(a5)
    80002f4e:	bfcd                	j	80002f40 <argraw+0x30>
    return p->trapframe->a2;
    80002f50:	753c                	ld	a5,104(a0)
    80002f52:	63c8                	ld	a0,128(a5)
    80002f54:	b7f5                	j	80002f40 <argraw+0x30>
    return p->trapframe->a3;
    80002f56:	753c                	ld	a5,104(a0)
    80002f58:	67c8                	ld	a0,136(a5)
    80002f5a:	b7dd                	j	80002f40 <argraw+0x30>
    return p->trapframe->a4;
    80002f5c:	753c                	ld	a5,104(a0)
    80002f5e:	6bc8                	ld	a0,144(a5)
    80002f60:	b7c5                	j	80002f40 <argraw+0x30>
    return p->trapframe->a5;
    80002f62:	753c                	ld	a5,104(a0)
    80002f64:	6fc8                	ld	a0,152(a5)
    80002f66:	bfe9                	j	80002f40 <argraw+0x30>
  panic("argraw");
    80002f68:	00005517          	auipc	a0,0x5
    80002f6c:	4e050513          	addi	a0,a0,1248 # 80008448 <states.1983+0x148>
    80002f70:	ffffd097          	auipc	ra,0xffffd
    80002f74:	5d4080e7          	jalr	1492(ra) # 80000544 <panic>

0000000080002f78 <fetchaddr>:
{
    80002f78:	1101                	addi	sp,sp,-32
    80002f7a:	ec06                	sd	ra,24(sp)
    80002f7c:	e822                	sd	s0,16(sp)
    80002f7e:	e426                	sd	s1,8(sp)
    80002f80:	e04a                	sd	s2,0(sp)
    80002f82:	1000                	addi	s0,sp,32
    80002f84:	84aa                	mv	s1,a0
    80002f86:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002f88:	fffff097          	auipc	ra,0xfffff
    80002f8c:	bc8080e7          	jalr	-1080(ra) # 80001b50 <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002f90:	6d3c                	ld	a5,88(a0)
    80002f92:	02f4f863          	bgeu	s1,a5,80002fc2 <fetchaddr+0x4a>
    80002f96:	00848713          	addi	a4,s1,8
    80002f9a:	02e7e663          	bltu	a5,a4,80002fc6 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f9e:	46a1                	li	a3,8
    80002fa0:	8626                	mv	a2,s1
    80002fa2:	85ca                	mv	a1,s2
    80002fa4:	7128                	ld	a0,96(a0)
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	8ba080e7          	jalr	-1862(ra) # 80001860 <copyin>
    80002fae:	00a03533          	snez	a0,a0
    80002fb2:	40a00533          	neg	a0,a0
}
    80002fb6:	60e2                	ld	ra,24(sp)
    80002fb8:	6442                	ld	s0,16(sp)
    80002fba:	64a2                	ld	s1,8(sp)
    80002fbc:	6902                	ld	s2,0(sp)
    80002fbe:	6105                	addi	sp,sp,32
    80002fc0:	8082                	ret
    return -1;
    80002fc2:	557d                	li	a0,-1
    80002fc4:	bfcd                	j	80002fb6 <fetchaddr+0x3e>
    80002fc6:	557d                	li	a0,-1
    80002fc8:	b7fd                	j	80002fb6 <fetchaddr+0x3e>

0000000080002fca <fetchstr>:
{
    80002fca:	7179                	addi	sp,sp,-48
    80002fcc:	f406                	sd	ra,40(sp)
    80002fce:	f022                	sd	s0,32(sp)
    80002fd0:	ec26                	sd	s1,24(sp)
    80002fd2:	e84a                	sd	s2,16(sp)
    80002fd4:	e44e                	sd	s3,8(sp)
    80002fd6:	1800                	addi	s0,sp,48
    80002fd8:	892a                	mv	s2,a0
    80002fda:	84ae                	mv	s1,a1
    80002fdc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	b72080e7          	jalr	-1166(ra) # 80001b50 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002fe6:	86ce                	mv	a3,s3
    80002fe8:	864a                	mv	a2,s2
    80002fea:	85a6                	mv	a1,s1
    80002fec:	7128                	ld	a0,96(a0)
    80002fee:	fffff097          	auipc	ra,0xfffff
    80002ff2:	8fe080e7          	jalr	-1794(ra) # 800018ec <copyinstr>
    80002ff6:	00054e63          	bltz	a0,80003012 <fetchstr+0x48>
  return strlen(buf);
    80002ffa:	8526                	mv	a0,s1
    80002ffc:	ffffe097          	auipc	ra,0xffffe
    80003000:	fa4080e7          	jalr	-92(ra) # 80000fa0 <strlen>
}
    80003004:	70a2                	ld	ra,40(sp)
    80003006:	7402                	ld	s0,32(sp)
    80003008:	64e2                	ld	s1,24(sp)
    8000300a:	6942                	ld	s2,16(sp)
    8000300c:	69a2                	ld	s3,8(sp)
    8000300e:	6145                	addi	sp,sp,48
    80003010:	8082                	ret
    return -1;
    80003012:	557d                	li	a0,-1
    80003014:	bfc5                	j	80003004 <fetchstr+0x3a>

0000000080003016 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80003016:	1101                	addi	sp,sp,-32
    80003018:	ec06                	sd	ra,24(sp)
    8000301a:	e822                	sd	s0,16(sp)
    8000301c:	e426                	sd	s1,8(sp)
    8000301e:	1000                	addi	s0,sp,32
    80003020:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003022:	00000097          	auipc	ra,0x0
    80003026:	eee080e7          	jalr	-274(ra) # 80002f10 <argraw>
    8000302a:	c088                	sw	a0,0(s1)
}
    8000302c:	60e2                	ld	ra,24(sp)
    8000302e:	6442                	ld	s0,16(sp)
    80003030:	64a2                	ld	s1,8(sp)
    80003032:	6105                	addi	sp,sp,32
    80003034:	8082                	ret

0000000080003036 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80003036:	1101                	addi	sp,sp,-32
    80003038:	ec06                	sd	ra,24(sp)
    8000303a:	e822                	sd	s0,16(sp)
    8000303c:	e426                	sd	s1,8(sp)
    8000303e:	1000                	addi	s0,sp,32
    80003040:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003042:	00000097          	auipc	ra,0x0
    80003046:	ece080e7          	jalr	-306(ra) # 80002f10 <argraw>
    8000304a:	e088                	sd	a0,0(s1)
}
    8000304c:	60e2                	ld	ra,24(sp)
    8000304e:	6442                	ld	s0,16(sp)
    80003050:	64a2                	ld	s1,8(sp)
    80003052:	6105                	addi	sp,sp,32
    80003054:	8082                	ret

0000000080003056 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80003056:	7179                	addi	sp,sp,-48
    80003058:	f406                	sd	ra,40(sp)
    8000305a:	f022                	sd	s0,32(sp)
    8000305c:	ec26                	sd	s1,24(sp)
    8000305e:	e84a                	sd	s2,16(sp)
    80003060:	1800                	addi	s0,sp,48
    80003062:	84ae                	mv	s1,a1
    80003064:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003066:	fd840593          	addi	a1,s0,-40
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	fcc080e7          	jalr	-52(ra) # 80003036 <argaddr>
  return fetchstr(addr, buf, max);
    80003072:	864a                	mv	a2,s2
    80003074:	85a6                	mv	a1,s1
    80003076:	fd843503          	ld	a0,-40(s0)
    8000307a:	00000097          	auipc	ra,0x0
    8000307e:	f50080e7          	jalr	-176(ra) # 80002fca <fetchstr>
}
    80003082:	70a2                	ld	ra,40(sp)
    80003084:	7402                	ld	s0,32(sp)
    80003086:	64e2                	ld	s1,24(sp)
    80003088:	6942                	ld	s2,16(sp)
    8000308a:	6145                	addi	sp,sp,48
    8000308c:	8082                	ret

000000008000308e <syscall>:
    "none", "fork", "exit", "wait", "pipe", "read", "kill", "exec",
    "fstat", "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open",
    "write", "mknod", "unlink", "link", "mkdir", "close", "strace", "sigalarm", "sigreturn", "waitx", "set_priority", "settickets"};

void syscall(void)
{
    8000308e:	7179                	addi	sp,sp,-48
    80003090:	f406                	sd	ra,40(sp)
    80003092:	f022                	sd	s0,32(sp)
    80003094:	ec26                	sd	s1,24(sp)
    80003096:	e84a                	sd	s2,16(sp)
    80003098:	e44e                	sd	s3,8(sp)
    8000309a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	ab4080e7          	jalr	-1356(ra) # 80001b50 <myproc>
    800030a4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800030a6:	06853903          	ld	s2,104(a0)
    800030aa:	0a893783          	ld	a5,168(s2)
    800030ae:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800030b2:	37fd                	addiw	a5,a5,-1
    800030b4:	4769                	li	a4,26
    800030b6:	04f76863          	bltu	a4,a5,80003106 <syscall+0x78>
    800030ba:	00399713          	slli	a4,s3,0x3
    800030be:	00005797          	auipc	a5,0x5
    800030c2:	4da78793          	addi	a5,a5,1242 # 80008598 <syscalls>
    800030c6:	97ba                	add	a5,a5,a4
    800030c8:	639c                	ld	a5,0(a5)
    800030ca:	cf95                	beqz	a5,80003106 <syscall+0x78>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800030cc:	9782                	jalr	a5
    800030ce:	06a93823          	sd	a0,112(s2)
    if (p->mask & (1 << num))
    800030d2:	1b04a783          	lw	a5,432(s1)
    800030d6:	4137d7bb          	sraw	a5,a5,s3
    800030da:	8b85                	andi	a5,a5,1
    800030dc:	c7a1                	beqz	a5,80003124 <syscall+0x96>
    {
      printf("%d: syscall %s -> %d\n", p->pid, syscall_list[num],p->trapframe->a0);
    800030de:	74b8                	ld	a4,104(s1)
    800030e0:	098e                	slli	s3,s3,0x3
    800030e2:	00005797          	auipc	a5,0x5
    800030e6:	4b678793          	addi	a5,a5,1206 # 80008598 <syscalls>
    800030ea:	99be                	add	s3,s3,a5
    800030ec:	7b34                	ld	a3,112(a4)
    800030ee:	0e09b603          	ld	a2,224(s3)
    800030f2:	588c                	lw	a1,48(s1)
    800030f4:	00005517          	auipc	a0,0x5
    800030f8:	35c50513          	addi	a0,a0,860 # 80008450 <states.1983+0x150>
    800030fc:	ffffd097          	auipc	ra,0xffffd
    80003100:	492080e7          	jalr	1170(ra) # 8000058e <printf>
    80003104:	a005                	j	80003124 <syscall+0x96>
    }
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    80003106:	86ce                	mv	a3,s3
    80003108:	16848613          	addi	a2,s1,360
    8000310c:	588c                	lw	a1,48(s1)
    8000310e:	00005517          	auipc	a0,0x5
    80003112:	35a50513          	addi	a0,a0,858 # 80008468 <states.1983+0x168>
    80003116:	ffffd097          	auipc	ra,0xffffd
    8000311a:	478080e7          	jalr	1144(ra) # 8000058e <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000311e:	74bc                	ld	a5,104(s1)
    80003120:	577d                	li	a4,-1
    80003122:	fbb8                	sd	a4,112(a5)
  }
}
    80003124:	70a2                	ld	ra,40(sp)
    80003126:	7402                	ld	s0,32(sp)
    80003128:	64e2                	ld	s1,24(sp)
    8000312a:	6942                	ld	s2,16(sp)
    8000312c:	69a2                	ld	s3,8(sp)
    8000312e:	6145                	addi	sp,sp,48
    80003130:	8082                	ret

0000000080003132 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003132:	1101                	addi	sp,sp,-32
    80003134:	ec06                	sd	ra,24(sp)
    80003136:	e822                	sd	s0,16(sp)
    80003138:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000313a:	fec40593          	addi	a1,s0,-20
    8000313e:	4501                	li	a0,0
    80003140:	00000097          	auipc	ra,0x0
    80003144:	ed6080e7          	jalr	-298(ra) # 80003016 <argint>
  exit(n);
    80003148:	fec42503          	lw	a0,-20(s0)
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	22e080e7          	jalr	558(ra) # 8000237a <exit>
  return 0; // not reached
}
    80003154:	4501                	li	a0,0
    80003156:	60e2                	ld	ra,24(sp)
    80003158:	6442                	ld	s0,16(sp)
    8000315a:	6105                	addi	sp,sp,32
    8000315c:	8082                	ret

000000008000315e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000315e:	1141                	addi	sp,sp,-16
    80003160:	e406                	sd	ra,8(sp)
    80003162:	e022                	sd	s0,0(sp)
    80003164:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	9ea080e7          	jalr	-1558(ra) # 80001b50 <myproc>
}
    8000316e:	5908                	lw	a0,48(a0)
    80003170:	60a2                	ld	ra,8(sp)
    80003172:	6402                	ld	s0,0(sp)
    80003174:	0141                	addi	sp,sp,16
    80003176:	8082                	ret

0000000080003178 <sys_fork>:

uint64
sys_fork(void)
{
    80003178:	1141                	addi	sp,sp,-16
    8000317a:	e406                	sd	ra,8(sp)
    8000317c:	e022                	sd	s0,0(sp)
    8000317e:	0800                	addi	s0,sp,16
  return fork();
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	df0080e7          	jalr	-528(ra) # 80001f70 <fork>
}
    80003188:	60a2                	ld	ra,8(sp)
    8000318a:	6402                	ld	s0,0(sp)
    8000318c:	0141                	addi	sp,sp,16
    8000318e:	8082                	ret

0000000080003190 <sys_wait>:

uint64
sys_wait(void)
{
    80003190:	1101                	addi	sp,sp,-32
    80003192:	ec06                	sd	ra,24(sp)
    80003194:	e822                	sd	s0,16(sp)
    80003196:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003198:	fe840593          	addi	a1,s0,-24
    8000319c:	4501                	li	a0,0
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	e98080e7          	jalr	-360(ra) # 80003036 <argaddr>
  return wait(p);
    800031a6:	fe843503          	ld	a0,-24(s0)
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	56e080e7          	jalr	1390(ra) # 80002718 <wait>
}
    800031b2:	60e2                	ld	ra,24(sp)
    800031b4:	6442                	ld	s0,16(sp)
    800031b6:	6105                	addi	sp,sp,32
    800031b8:	8082                	ret

00000000800031ba <sys_waitx>:

uint64
sys_waitx(void)
{
    800031ba:	7139                	addi	sp,sp,-64
    800031bc:	fc06                	sd	ra,56(sp)
    800031be:	f822                	sd	s0,48(sp)
    800031c0:	f426                	sd	s1,40(sp)
    800031c2:	f04a                	sd	s2,32(sp)
    800031c4:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    800031c6:	fd840593          	addi	a1,s0,-40
    800031ca:	4501                	li	a0,0
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	e6a080e7          	jalr	-406(ra) # 80003036 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    800031d4:	fd040593          	addi	a1,s0,-48
    800031d8:	4505                	li	a0,1
    800031da:	00000097          	auipc	ra,0x0
    800031de:	e5c080e7          	jalr	-420(ra) # 80003036 <argaddr>
  argaddr(2, &addr2);
    800031e2:	fc840593          	addi	a1,s0,-56
    800031e6:	4509                	li	a0,2
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	e4e080e7          	jalr	-434(ra) # 80003036 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    800031f0:	fc040613          	addi	a2,s0,-64
    800031f4:	fc440593          	addi	a1,s0,-60
    800031f8:	fd843503          	ld	a0,-40(s0)
    800031fc:	fffff097          	auipc	ra,0xfffff
    80003200:	300080e7          	jalr	768(ra) # 800024fc <waitx>
    80003204:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80003206:	fffff097          	auipc	ra,0xfffff
    8000320a:	94a080e7          	jalr	-1718(ra) # 80001b50 <myproc>
    8000320e:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003210:	4691                	li	a3,4
    80003212:	fc440613          	addi	a2,s0,-60
    80003216:	fd043583          	ld	a1,-48(s0)
    8000321a:	7128                	ld	a0,96(a0)
    8000321c:	ffffe097          	auipc	ra,0xffffe
    80003220:	584080e7          	jalr	1412(ra) # 800017a0 <copyout>
    return -1;
    80003224:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003226:	00054f63          	bltz	a0,80003244 <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    8000322a:	4691                	li	a3,4
    8000322c:	fc040613          	addi	a2,s0,-64
    80003230:	fc843583          	ld	a1,-56(s0)
    80003234:	70a8                	ld	a0,96(s1)
    80003236:	ffffe097          	auipc	ra,0xffffe
    8000323a:	56a080e7          	jalr	1386(ra) # 800017a0 <copyout>
    8000323e:	00054a63          	bltz	a0,80003252 <sys_waitx+0x98>
    return -1;
  return ret;
    80003242:	87ca                	mv	a5,s2
}
    80003244:	853e                	mv	a0,a5
    80003246:	70e2                	ld	ra,56(sp)
    80003248:	7442                	ld	s0,48(sp)
    8000324a:	74a2                	ld	s1,40(sp)
    8000324c:	7902                	ld	s2,32(sp)
    8000324e:	6121                	addi	sp,sp,64
    80003250:	8082                	ret
    return -1;
    80003252:	57fd                	li	a5,-1
    80003254:	bfc5                	j	80003244 <sys_waitx+0x8a>

0000000080003256 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003256:	7179                	addi	sp,sp,-48
    80003258:	f406                	sd	ra,40(sp)
    8000325a:	f022                	sd	s0,32(sp)
    8000325c:	ec26                	sd	s1,24(sp)
    8000325e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80003260:	fdc40593          	addi	a1,s0,-36
    80003264:	4501                	li	a0,0
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	db0080e7          	jalr	-592(ra) # 80003016 <argint>
  addr = myproc()->sz;
    8000326e:	fffff097          	auipc	ra,0xfffff
    80003272:	8e2080e7          	jalr	-1822(ra) # 80001b50 <myproc>
    80003276:	6d24                	ld	s1,88(a0)
  if (growproc(n) < 0)
    80003278:	fdc42503          	lw	a0,-36(s0)
    8000327c:	fffff097          	auipc	ra,0xfffff
    80003280:	c98080e7          	jalr	-872(ra) # 80001f14 <growproc>
    80003284:	00054863          	bltz	a0,80003294 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80003288:	8526                	mv	a0,s1
    8000328a:	70a2                	ld	ra,40(sp)
    8000328c:	7402                	ld	s0,32(sp)
    8000328e:	64e2                	ld	s1,24(sp)
    80003290:	6145                	addi	sp,sp,48
    80003292:	8082                	ret
    return -1;
    80003294:	54fd                	li	s1,-1
    80003296:	bfcd                	j	80003288 <sys_sbrk+0x32>

0000000080003298 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003298:	7139                	addi	sp,sp,-64
    8000329a:	fc06                	sd	ra,56(sp)
    8000329c:	f822                	sd	s0,48(sp)
    8000329e:	f426                	sd	s1,40(sp)
    800032a0:	f04a                	sd	s2,32(sp)
    800032a2:	ec4e                	sd	s3,24(sp)
    800032a4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800032a6:	fcc40593          	addi	a1,s0,-52
    800032aa:	4501                	li	a0,0
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	d6a080e7          	jalr	-662(ra) # 80003016 <argint>
  acquire(&tickslock);
    800032b4:	0023a517          	auipc	a0,0x23a
    800032b8:	39450513          	addi	a0,a0,916 # 8023d648 <tickslock>
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	a64080e7          	jalr	-1436(ra) # 80000d20 <acquire>
  ticks0 = ticks;
    800032c4:	00006917          	auipc	s2,0x6
    800032c8:	8cc92903          	lw	s2,-1844(s2) # 80008b90 <ticks>
  while (ticks - ticks0 < n)
    800032cc:	fcc42783          	lw	a5,-52(s0)
    800032d0:	cf9d                	beqz	a5,8000330e <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800032d2:	0023a997          	auipc	s3,0x23a
    800032d6:	37698993          	addi	s3,s3,886 # 8023d648 <tickslock>
    800032da:	00006497          	auipc	s1,0x6
    800032de:	8b648493          	addi	s1,s1,-1866 # 80008b90 <ticks>
    if (killed(myproc()))
    800032e2:	fffff097          	auipc	ra,0xfffff
    800032e6:	86e080e7          	jalr	-1938(ra) # 80001b50 <myproc>
    800032ea:	fffff097          	auipc	ra,0xfffff
    800032ee:	3fc080e7          	jalr	1020(ra) # 800026e6 <killed>
    800032f2:	ed15                	bnez	a0,8000332e <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800032f4:	85ce                	mv	a1,s3
    800032f6:	8526                	mv	a0,s1
    800032f8:	fffff097          	auipc	ra,0xfffff
    800032fc:	1a0080e7          	jalr	416(ra) # 80002498 <sleep>
  while (ticks - ticks0 < n)
    80003300:	409c                	lw	a5,0(s1)
    80003302:	412787bb          	subw	a5,a5,s2
    80003306:	fcc42703          	lw	a4,-52(s0)
    8000330a:	fce7ece3          	bltu	a5,a4,800032e2 <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000330e:	0023a517          	auipc	a0,0x23a
    80003312:	33a50513          	addi	a0,a0,826 # 8023d648 <tickslock>
    80003316:	ffffe097          	auipc	ra,0xffffe
    8000331a:	abe080e7          	jalr	-1346(ra) # 80000dd4 <release>
  return 0;
    8000331e:	4501                	li	a0,0
}
    80003320:	70e2                	ld	ra,56(sp)
    80003322:	7442                	ld	s0,48(sp)
    80003324:	74a2                	ld	s1,40(sp)
    80003326:	7902                	ld	s2,32(sp)
    80003328:	69e2                	ld	s3,24(sp)
    8000332a:	6121                	addi	sp,sp,64
    8000332c:	8082                	ret
      release(&tickslock);
    8000332e:	0023a517          	auipc	a0,0x23a
    80003332:	31a50513          	addi	a0,a0,794 # 8023d648 <tickslock>
    80003336:	ffffe097          	auipc	ra,0xffffe
    8000333a:	a9e080e7          	jalr	-1378(ra) # 80000dd4 <release>
      return -1;
    8000333e:	557d                	li	a0,-1
    80003340:	b7c5                	j	80003320 <sys_sleep+0x88>

0000000080003342 <sys_kill>:

uint64
sys_kill(void)
{
    80003342:	1101                	addi	sp,sp,-32
    80003344:	ec06                	sd	ra,24(sp)
    80003346:	e822                	sd	s0,16(sp)
    80003348:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000334a:	fec40593          	addi	a1,s0,-20
    8000334e:	4501                	li	a0,0
    80003350:	00000097          	auipc	ra,0x0
    80003354:	cc6080e7          	jalr	-826(ra) # 80003016 <argint>
  return kill(pid);
    80003358:	fec42503          	lw	a0,-20(s0)
    8000335c:	fffff097          	auipc	ra,0xfffff
    80003360:	2ec080e7          	jalr	748(ra) # 80002648 <kill>
}
    80003364:	60e2                	ld	ra,24(sp)
    80003366:	6442                	ld	s0,16(sp)
    80003368:	6105                	addi	sp,sp,32
    8000336a:	8082                	ret

000000008000336c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000336c:	1101                	addi	sp,sp,-32
    8000336e:	ec06                	sd	ra,24(sp)
    80003370:	e822                	sd	s0,16(sp)
    80003372:	e426                	sd	s1,8(sp)
    80003374:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003376:	0023a517          	auipc	a0,0x23a
    8000337a:	2d250513          	addi	a0,a0,722 # 8023d648 <tickslock>
    8000337e:	ffffe097          	auipc	ra,0xffffe
    80003382:	9a2080e7          	jalr	-1630(ra) # 80000d20 <acquire>
  xticks = ticks;
    80003386:	00006497          	auipc	s1,0x6
    8000338a:	80a4a483          	lw	s1,-2038(s1) # 80008b90 <ticks>
  release(&tickslock);
    8000338e:	0023a517          	auipc	a0,0x23a
    80003392:	2ba50513          	addi	a0,a0,698 # 8023d648 <tickslock>
    80003396:	ffffe097          	auipc	ra,0xffffe
    8000339a:	a3e080e7          	jalr	-1474(ra) # 80000dd4 <release>
  return xticks;
}
    8000339e:	02049513          	slli	a0,s1,0x20
    800033a2:	9101                	srli	a0,a0,0x20
    800033a4:	60e2                	ld	ra,24(sp)
    800033a6:	6442                	ld	s0,16(sp)
    800033a8:	64a2                	ld	s1,8(sp)
    800033aa:	6105                	addi	sp,sp,32
    800033ac:	8082                	ret

00000000800033ae <sys_trace>:

uint64
sys_trace(void)
{
    800033ae:	1101                	addi	sp,sp,-32
    800033b0:	ec06                	sd	ra,24(sp)
    800033b2:	e822                	sd	s0,16(sp)
    800033b4:	1000                	addi	s0,sp,32
  int mask;

  argint(0, &mask);
    800033b6:	fec40593          	addi	a1,s0,-20
    800033ba:	4501                	li	a0,0
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	c5a080e7          	jalr	-934(ra) # 80003016 <argint>

  myproc()->mask = mask;
    800033c4:	ffffe097          	auipc	ra,0xffffe
    800033c8:	78c080e7          	jalr	1932(ra) # 80001b50 <myproc>
    800033cc:	fec42783          	lw	a5,-20(s0)
    800033d0:	1af52823          	sw	a5,432(a0)

  return 0;
}
    800033d4:	4501                	li	a0,0
    800033d6:	60e2                	ld	ra,24(sp)
    800033d8:	6442                	ld	s0,16(sp)
    800033da:	6105                	addi	sp,sp,32
    800033dc:	8082                	ret

00000000800033de <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    800033de:	1101                	addi	sp,sp,-32
    800033e0:	ec06                	sd	ra,24(sp)
    800033e2:	e822                	sd	s0,16(sp)
    800033e4:	1000                	addi	s0,sp,32
	int interval;
	uint64 handler;

	argint(0, &interval);
    800033e6:	fec40593          	addi	a1,s0,-20
    800033ea:	4501                	li	a0,0
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	c2a080e7          	jalr	-982(ra) # 80003016 <argint>

	argaddr(1, &handler);
    800033f4:	fe040593          	addi	a1,s0,-32
    800033f8:	4505                	li	a0,1
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	c3c080e7          	jalr	-964(ra) # 80003036 <argaddr>

	struct proc *p = myproc();
    80003402:	ffffe097          	auipc	ra,0xffffe
    80003406:	74e080e7          	jalr	1870(ra) # 80001b50 <myproc>

	p->alarm_interval = interval;
    8000340a:	fec42783          	lw	a5,-20(s0)
    8000340e:	1af52a23          	sw	a5,436(a0)
	p->alarm_handler = handler;
    80003412:	fe043783          	ld	a5,-32(s0)
    80003416:	1cf53023          	sd	a5,448(a0)

	return 0;
}
    8000341a:	4501                	li	a0,0
    8000341c:	60e2                	ld	ra,24(sp)
    8000341e:	6442                	ld	s0,16(sp)
    80003420:	6105                	addi	sp,sp,32
    80003422:	8082                	ret

0000000080003424 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    80003424:	1101                	addi	sp,sp,-32
    80003426:	ec06                	sd	ra,24(sp)
    80003428:	e822                	sd	s0,16(sp)
    8000342a:	e426                	sd	s1,8(sp)
    8000342c:	1000                	addi	s0,sp,32
	struct proc *p = myproc();
    8000342e:	ffffe097          	auipc	ra,0xffffe
    80003432:	722080e7          	jalr	1826(ra) # 80001b50 <myproc>
    80003436:	84aa                	mv	s1,a0
	memmove(p->trapframe, &(p->etpfm), sizeof(struct trapframe));
    80003438:	12000613          	li	a2,288
    8000343c:	1c850593          	addi	a1,a0,456
    80003440:	7528                	ld	a0,104(a0)
    80003442:	ffffe097          	auipc	ra,0xffffe
    80003446:	a3a080e7          	jalr	-1478(ra) # 80000e7c <memmove>
	p->alarm_passed = 0;
    8000344a:	1a04ac23          	sw	zero,440(s1)
	return 0;
}
    8000344e:	4501                	li	a0,0
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	64a2                	ld	s1,8(sp)
    80003456:	6105                	addi	sp,sp,32
    80003458:	8082                	ret

000000008000345a <sys_set_priority>:

uint64
sys_set_priority()
{
    8000345a:	1101                	addi	sp,sp,-32
    8000345c:	ec06                	sd	ra,24(sp)
    8000345e:	e822                	sd	s0,16(sp)
    80003460:	1000                	addi	s0,sp,32
  int pid, priority;
  argint(0, &priority);
    80003462:	fe840593          	addi	a1,s0,-24
    80003466:	4501                	li	a0,0
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	bae080e7          	jalr	-1106(ra) # 80003016 <argint>
  argint(1, &pid);
    80003470:	fec40593          	addi	a1,s0,-20
    80003474:	4505                	li	a0,1
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	ba0080e7          	jalr	-1120(ra) # 80003016 <argint>

  return set_priority(priority, pid);
    8000347e:	fec42583          	lw	a1,-20(s0)
    80003482:	fe842503          	lw	a0,-24(s0)
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	51a080e7          	jalr	1306(ra) # 800029a0 <set_priority>
}
    8000348e:	60e2                	ld	ra,24(sp)
    80003490:	6442                	ld	s0,16(sp)
    80003492:	6105                	addi	sp,sp,32
    80003494:	8082                	ret

0000000080003496 <sys_settickets>:

uint64
sys_settickets(void)
{
    80003496:	1101                	addi	sp,sp,-32
    80003498:	ec06                	sd	ra,24(sp)
    8000349a:	e822                	sd	s0,16(sp)
    8000349c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000349e:	fec40593          	addi	a1,s0,-20
    800034a2:	4501                	li	a0,0
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	b72080e7          	jalr	-1166(ra) # 80003016 <argint>
  struct proc *p = myproc();
    800034ac:	ffffe097          	auipc	ra,0xffffe
    800034b0:	6a4080e7          	jalr	1700(ra) # 80001b50 <myproc>
  p->tickets = n;
    800034b4:	fec42783          	lw	a5,-20(s0)
    800034b8:	dd1c                	sw	a5,56(a0)
  return n;
    800034ba:	853e                	mv	a0,a5
    800034bc:	60e2                	ld	ra,24(sp)
    800034be:	6442                	ld	s0,16(sp)
    800034c0:	6105                	addi	sp,sp,32
    800034c2:	8082                	ret

00000000800034c4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800034c4:	7179                	addi	sp,sp,-48
    800034c6:	f406                	sd	ra,40(sp)
    800034c8:	f022                	sd	s0,32(sp)
    800034ca:	ec26                	sd	s1,24(sp)
    800034cc:	e84a                	sd	s2,16(sp)
    800034ce:	e44e                	sd	s3,8(sp)
    800034d0:	e052                	sd	s4,0(sp)
    800034d2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800034d4:	00005597          	auipc	a1,0x5
    800034d8:	2bc58593          	addi	a1,a1,700 # 80008790 <syscall_list+0x118>
    800034dc:	0023a517          	auipc	a0,0x23a
    800034e0:	18450513          	addi	a0,a0,388 # 8023d660 <bcache>
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	7ac080e7          	jalr	1964(ra) # 80000c90 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800034ec:	00242797          	auipc	a5,0x242
    800034f0:	17478793          	addi	a5,a5,372 # 80245660 <bcache+0x8000>
    800034f4:	00242717          	auipc	a4,0x242
    800034f8:	3d470713          	addi	a4,a4,980 # 802458c8 <bcache+0x8268>
    800034fc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003500:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003504:	0023a497          	auipc	s1,0x23a
    80003508:	17448493          	addi	s1,s1,372 # 8023d678 <bcache+0x18>
    b->next = bcache.head.next;
    8000350c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000350e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003510:	00005a17          	auipc	s4,0x5
    80003514:	288a0a13          	addi	s4,s4,648 # 80008798 <syscall_list+0x120>
    b->next = bcache.head.next;
    80003518:	2b893783          	ld	a5,696(s2)
    8000351c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000351e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003522:	85d2                	mv	a1,s4
    80003524:	01048513          	addi	a0,s1,16
    80003528:	00001097          	auipc	ra,0x1
    8000352c:	4c4080e7          	jalr	1220(ra) # 800049ec <initsleeplock>
    bcache.head.next->prev = b;
    80003530:	2b893783          	ld	a5,696(s2)
    80003534:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003536:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000353a:	45848493          	addi	s1,s1,1112
    8000353e:	fd349de3          	bne	s1,s3,80003518 <binit+0x54>
  }
}
    80003542:	70a2                	ld	ra,40(sp)
    80003544:	7402                	ld	s0,32(sp)
    80003546:	64e2                	ld	s1,24(sp)
    80003548:	6942                	ld	s2,16(sp)
    8000354a:	69a2                	ld	s3,8(sp)
    8000354c:	6a02                	ld	s4,0(sp)
    8000354e:	6145                	addi	sp,sp,48
    80003550:	8082                	ret

0000000080003552 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003552:	7179                	addi	sp,sp,-48
    80003554:	f406                	sd	ra,40(sp)
    80003556:	f022                	sd	s0,32(sp)
    80003558:	ec26                	sd	s1,24(sp)
    8000355a:	e84a                	sd	s2,16(sp)
    8000355c:	e44e                	sd	s3,8(sp)
    8000355e:	1800                	addi	s0,sp,48
    80003560:	89aa                	mv	s3,a0
    80003562:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80003564:	0023a517          	auipc	a0,0x23a
    80003568:	0fc50513          	addi	a0,a0,252 # 8023d660 <bcache>
    8000356c:	ffffd097          	auipc	ra,0xffffd
    80003570:	7b4080e7          	jalr	1972(ra) # 80000d20 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003574:	00242497          	auipc	s1,0x242
    80003578:	3a44b483          	ld	s1,932(s1) # 80245918 <bcache+0x82b8>
    8000357c:	00242797          	auipc	a5,0x242
    80003580:	34c78793          	addi	a5,a5,844 # 802458c8 <bcache+0x8268>
    80003584:	02f48f63          	beq	s1,a5,800035c2 <bread+0x70>
    80003588:	873e                	mv	a4,a5
    8000358a:	a021                	j	80003592 <bread+0x40>
    8000358c:	68a4                	ld	s1,80(s1)
    8000358e:	02e48a63          	beq	s1,a4,800035c2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003592:	449c                	lw	a5,8(s1)
    80003594:	ff379ce3          	bne	a5,s3,8000358c <bread+0x3a>
    80003598:	44dc                	lw	a5,12(s1)
    8000359a:	ff2799e3          	bne	a5,s2,8000358c <bread+0x3a>
      b->refcnt++;
    8000359e:	40bc                	lw	a5,64(s1)
    800035a0:	2785                	addiw	a5,a5,1
    800035a2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800035a4:	0023a517          	auipc	a0,0x23a
    800035a8:	0bc50513          	addi	a0,a0,188 # 8023d660 <bcache>
    800035ac:	ffffe097          	auipc	ra,0xffffe
    800035b0:	828080e7          	jalr	-2008(ra) # 80000dd4 <release>
      acquiresleep(&b->lock);
    800035b4:	01048513          	addi	a0,s1,16
    800035b8:	00001097          	auipc	ra,0x1
    800035bc:	46e080e7          	jalr	1134(ra) # 80004a26 <acquiresleep>
      return b;
    800035c0:	a8b9                	j	8000361e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035c2:	00242497          	auipc	s1,0x242
    800035c6:	34e4b483          	ld	s1,846(s1) # 80245910 <bcache+0x82b0>
    800035ca:	00242797          	auipc	a5,0x242
    800035ce:	2fe78793          	addi	a5,a5,766 # 802458c8 <bcache+0x8268>
    800035d2:	00f48863          	beq	s1,a5,800035e2 <bread+0x90>
    800035d6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800035d8:	40bc                	lw	a5,64(s1)
    800035da:	cf81                	beqz	a5,800035f2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035dc:	64a4                	ld	s1,72(s1)
    800035de:	fee49de3          	bne	s1,a4,800035d8 <bread+0x86>
  panic("bget: no buffers");
    800035e2:	00005517          	auipc	a0,0x5
    800035e6:	1be50513          	addi	a0,a0,446 # 800087a0 <syscall_list+0x128>
    800035ea:	ffffd097          	auipc	ra,0xffffd
    800035ee:	f5a080e7          	jalr	-166(ra) # 80000544 <panic>
      b->dev = dev;
    800035f2:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800035f6:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800035fa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800035fe:	4785                	li	a5,1
    80003600:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003602:	0023a517          	auipc	a0,0x23a
    80003606:	05e50513          	addi	a0,a0,94 # 8023d660 <bcache>
    8000360a:	ffffd097          	auipc	ra,0xffffd
    8000360e:	7ca080e7          	jalr	1994(ra) # 80000dd4 <release>
      acquiresleep(&b->lock);
    80003612:	01048513          	addi	a0,s1,16
    80003616:	00001097          	auipc	ra,0x1
    8000361a:	410080e7          	jalr	1040(ra) # 80004a26 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000361e:	409c                	lw	a5,0(s1)
    80003620:	cb89                	beqz	a5,80003632 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003622:	8526                	mv	a0,s1
    80003624:	70a2                	ld	ra,40(sp)
    80003626:	7402                	ld	s0,32(sp)
    80003628:	64e2                	ld	s1,24(sp)
    8000362a:	6942                	ld	s2,16(sp)
    8000362c:	69a2                	ld	s3,8(sp)
    8000362e:	6145                	addi	sp,sp,48
    80003630:	8082                	ret
    virtio_disk_rw(b, 0);
    80003632:	4581                	li	a1,0
    80003634:	8526                	mv	a0,s1
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	fd2080e7          	jalr	-46(ra) # 80006608 <virtio_disk_rw>
    b->valid = 1;
    8000363e:	4785                	li	a5,1
    80003640:	c09c                	sw	a5,0(s1)
  return b;
    80003642:	b7c5                	j	80003622 <bread+0xd0>

0000000080003644 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003644:	1101                	addi	sp,sp,-32
    80003646:	ec06                	sd	ra,24(sp)
    80003648:	e822                	sd	s0,16(sp)
    8000364a:	e426                	sd	s1,8(sp)
    8000364c:	1000                	addi	s0,sp,32
    8000364e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003650:	0541                	addi	a0,a0,16
    80003652:	00001097          	auipc	ra,0x1
    80003656:	46e080e7          	jalr	1134(ra) # 80004ac0 <holdingsleep>
    8000365a:	cd01                	beqz	a0,80003672 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000365c:	4585                	li	a1,1
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	fa8080e7          	jalr	-88(ra) # 80006608 <virtio_disk_rw>
}
    80003668:	60e2                	ld	ra,24(sp)
    8000366a:	6442                	ld	s0,16(sp)
    8000366c:	64a2                	ld	s1,8(sp)
    8000366e:	6105                	addi	sp,sp,32
    80003670:	8082                	ret
    panic("bwrite");
    80003672:	00005517          	auipc	a0,0x5
    80003676:	14650513          	addi	a0,a0,326 # 800087b8 <syscall_list+0x140>
    8000367a:	ffffd097          	auipc	ra,0xffffd
    8000367e:	eca080e7          	jalr	-310(ra) # 80000544 <panic>

0000000080003682 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003682:	1101                	addi	sp,sp,-32
    80003684:	ec06                	sd	ra,24(sp)
    80003686:	e822                	sd	s0,16(sp)
    80003688:	e426                	sd	s1,8(sp)
    8000368a:	e04a                	sd	s2,0(sp)
    8000368c:	1000                	addi	s0,sp,32
    8000368e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003690:	01050913          	addi	s2,a0,16
    80003694:	854a                	mv	a0,s2
    80003696:	00001097          	auipc	ra,0x1
    8000369a:	42a080e7          	jalr	1066(ra) # 80004ac0 <holdingsleep>
    8000369e:	c92d                	beqz	a0,80003710 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800036a0:	854a                	mv	a0,s2
    800036a2:	00001097          	auipc	ra,0x1
    800036a6:	3da080e7          	jalr	986(ra) # 80004a7c <releasesleep>

  acquire(&bcache.lock);
    800036aa:	0023a517          	auipc	a0,0x23a
    800036ae:	fb650513          	addi	a0,a0,-74 # 8023d660 <bcache>
    800036b2:	ffffd097          	auipc	ra,0xffffd
    800036b6:	66e080e7          	jalr	1646(ra) # 80000d20 <acquire>
  b->refcnt--;
    800036ba:	40bc                	lw	a5,64(s1)
    800036bc:	37fd                	addiw	a5,a5,-1
    800036be:	0007871b          	sext.w	a4,a5
    800036c2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800036c4:	eb05                	bnez	a4,800036f4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800036c6:	68bc                	ld	a5,80(s1)
    800036c8:	64b8                	ld	a4,72(s1)
    800036ca:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800036cc:	64bc                	ld	a5,72(s1)
    800036ce:	68b8                	ld	a4,80(s1)
    800036d0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800036d2:	00242797          	auipc	a5,0x242
    800036d6:	f8e78793          	addi	a5,a5,-114 # 80245660 <bcache+0x8000>
    800036da:	2b87b703          	ld	a4,696(a5)
    800036de:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800036e0:	00242717          	auipc	a4,0x242
    800036e4:	1e870713          	addi	a4,a4,488 # 802458c8 <bcache+0x8268>
    800036e8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800036ea:	2b87b703          	ld	a4,696(a5)
    800036ee:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800036f0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800036f4:	0023a517          	auipc	a0,0x23a
    800036f8:	f6c50513          	addi	a0,a0,-148 # 8023d660 <bcache>
    800036fc:	ffffd097          	auipc	ra,0xffffd
    80003700:	6d8080e7          	jalr	1752(ra) # 80000dd4 <release>
}
    80003704:	60e2                	ld	ra,24(sp)
    80003706:	6442                	ld	s0,16(sp)
    80003708:	64a2                	ld	s1,8(sp)
    8000370a:	6902                	ld	s2,0(sp)
    8000370c:	6105                	addi	sp,sp,32
    8000370e:	8082                	ret
    panic("brelse");
    80003710:	00005517          	auipc	a0,0x5
    80003714:	0b050513          	addi	a0,a0,176 # 800087c0 <syscall_list+0x148>
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	e2c080e7          	jalr	-468(ra) # 80000544 <panic>

0000000080003720 <bpin>:

void
bpin(struct buf *b) {
    80003720:	1101                	addi	sp,sp,-32
    80003722:	ec06                	sd	ra,24(sp)
    80003724:	e822                	sd	s0,16(sp)
    80003726:	e426                	sd	s1,8(sp)
    80003728:	1000                	addi	s0,sp,32
    8000372a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000372c:	0023a517          	auipc	a0,0x23a
    80003730:	f3450513          	addi	a0,a0,-204 # 8023d660 <bcache>
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	5ec080e7          	jalr	1516(ra) # 80000d20 <acquire>
  b->refcnt++;
    8000373c:	40bc                	lw	a5,64(s1)
    8000373e:	2785                	addiw	a5,a5,1
    80003740:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003742:	0023a517          	auipc	a0,0x23a
    80003746:	f1e50513          	addi	a0,a0,-226 # 8023d660 <bcache>
    8000374a:	ffffd097          	auipc	ra,0xffffd
    8000374e:	68a080e7          	jalr	1674(ra) # 80000dd4 <release>
}
    80003752:	60e2                	ld	ra,24(sp)
    80003754:	6442                	ld	s0,16(sp)
    80003756:	64a2                	ld	s1,8(sp)
    80003758:	6105                	addi	sp,sp,32
    8000375a:	8082                	ret

000000008000375c <bunpin>:

void
bunpin(struct buf *b) {
    8000375c:	1101                	addi	sp,sp,-32
    8000375e:	ec06                	sd	ra,24(sp)
    80003760:	e822                	sd	s0,16(sp)
    80003762:	e426                	sd	s1,8(sp)
    80003764:	1000                	addi	s0,sp,32
    80003766:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003768:	0023a517          	auipc	a0,0x23a
    8000376c:	ef850513          	addi	a0,a0,-264 # 8023d660 <bcache>
    80003770:	ffffd097          	auipc	ra,0xffffd
    80003774:	5b0080e7          	jalr	1456(ra) # 80000d20 <acquire>
  b->refcnt--;
    80003778:	40bc                	lw	a5,64(s1)
    8000377a:	37fd                	addiw	a5,a5,-1
    8000377c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000377e:	0023a517          	auipc	a0,0x23a
    80003782:	ee250513          	addi	a0,a0,-286 # 8023d660 <bcache>
    80003786:	ffffd097          	auipc	ra,0xffffd
    8000378a:	64e080e7          	jalr	1614(ra) # 80000dd4 <release>
}
    8000378e:	60e2                	ld	ra,24(sp)
    80003790:	6442                	ld	s0,16(sp)
    80003792:	64a2                	ld	s1,8(sp)
    80003794:	6105                	addi	sp,sp,32
    80003796:	8082                	ret

0000000080003798 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003798:	1101                	addi	sp,sp,-32
    8000379a:	ec06                	sd	ra,24(sp)
    8000379c:	e822                	sd	s0,16(sp)
    8000379e:	e426                	sd	s1,8(sp)
    800037a0:	e04a                	sd	s2,0(sp)
    800037a2:	1000                	addi	s0,sp,32
    800037a4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800037a6:	00d5d59b          	srliw	a1,a1,0xd
    800037aa:	00242797          	auipc	a5,0x242
    800037ae:	5927a783          	lw	a5,1426(a5) # 80245d3c <sb+0x1c>
    800037b2:	9dbd                	addw	a1,a1,a5
    800037b4:	00000097          	auipc	ra,0x0
    800037b8:	d9e080e7          	jalr	-610(ra) # 80003552 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800037bc:	0074f713          	andi	a4,s1,7
    800037c0:	4785                	li	a5,1
    800037c2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800037c6:	14ce                	slli	s1,s1,0x33
    800037c8:	90d9                	srli	s1,s1,0x36
    800037ca:	00950733          	add	a4,a0,s1
    800037ce:	05874703          	lbu	a4,88(a4)
    800037d2:	00e7f6b3          	and	a3,a5,a4
    800037d6:	c69d                	beqz	a3,80003804 <bfree+0x6c>
    800037d8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800037da:	94aa                	add	s1,s1,a0
    800037dc:	fff7c793          	not	a5,a5
    800037e0:	8ff9                	and	a5,a5,a4
    800037e2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800037e6:	00001097          	auipc	ra,0x1
    800037ea:	120080e7          	jalr	288(ra) # 80004906 <log_write>
  brelse(bp);
    800037ee:	854a                	mv	a0,s2
    800037f0:	00000097          	auipc	ra,0x0
    800037f4:	e92080e7          	jalr	-366(ra) # 80003682 <brelse>
}
    800037f8:	60e2                	ld	ra,24(sp)
    800037fa:	6442                	ld	s0,16(sp)
    800037fc:	64a2                	ld	s1,8(sp)
    800037fe:	6902                	ld	s2,0(sp)
    80003800:	6105                	addi	sp,sp,32
    80003802:	8082                	ret
    panic("freeing free block");
    80003804:	00005517          	auipc	a0,0x5
    80003808:	fc450513          	addi	a0,a0,-60 # 800087c8 <syscall_list+0x150>
    8000380c:	ffffd097          	auipc	ra,0xffffd
    80003810:	d38080e7          	jalr	-712(ra) # 80000544 <panic>

0000000080003814 <balloc>:
{
    80003814:	711d                	addi	sp,sp,-96
    80003816:	ec86                	sd	ra,88(sp)
    80003818:	e8a2                	sd	s0,80(sp)
    8000381a:	e4a6                	sd	s1,72(sp)
    8000381c:	e0ca                	sd	s2,64(sp)
    8000381e:	fc4e                	sd	s3,56(sp)
    80003820:	f852                	sd	s4,48(sp)
    80003822:	f456                	sd	s5,40(sp)
    80003824:	f05a                	sd	s6,32(sp)
    80003826:	ec5e                	sd	s7,24(sp)
    80003828:	e862                	sd	s8,16(sp)
    8000382a:	e466                	sd	s9,8(sp)
    8000382c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000382e:	00242797          	auipc	a5,0x242
    80003832:	4f67a783          	lw	a5,1270(a5) # 80245d24 <sb+0x4>
    80003836:	10078163          	beqz	a5,80003938 <balloc+0x124>
    8000383a:	8baa                	mv	s7,a0
    8000383c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000383e:	00242b17          	auipc	s6,0x242
    80003842:	4e2b0b13          	addi	s6,s6,1250 # 80245d20 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003846:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003848:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000384a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000384c:	6c89                	lui	s9,0x2
    8000384e:	a061                	j	800038d6 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003850:	974a                	add	a4,a4,s2
    80003852:	8fd5                	or	a5,a5,a3
    80003854:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003858:	854a                	mv	a0,s2
    8000385a:	00001097          	auipc	ra,0x1
    8000385e:	0ac080e7          	jalr	172(ra) # 80004906 <log_write>
        brelse(bp);
    80003862:	854a                	mv	a0,s2
    80003864:	00000097          	auipc	ra,0x0
    80003868:	e1e080e7          	jalr	-482(ra) # 80003682 <brelse>
  bp = bread(dev, bno);
    8000386c:	85a6                	mv	a1,s1
    8000386e:	855e                	mv	a0,s7
    80003870:	00000097          	auipc	ra,0x0
    80003874:	ce2080e7          	jalr	-798(ra) # 80003552 <bread>
    80003878:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000387a:	40000613          	li	a2,1024
    8000387e:	4581                	li	a1,0
    80003880:	05850513          	addi	a0,a0,88
    80003884:	ffffd097          	auipc	ra,0xffffd
    80003888:	598080e7          	jalr	1432(ra) # 80000e1c <memset>
  log_write(bp);
    8000388c:	854a                	mv	a0,s2
    8000388e:	00001097          	auipc	ra,0x1
    80003892:	078080e7          	jalr	120(ra) # 80004906 <log_write>
  brelse(bp);
    80003896:	854a                	mv	a0,s2
    80003898:	00000097          	auipc	ra,0x0
    8000389c:	dea080e7          	jalr	-534(ra) # 80003682 <brelse>
}
    800038a0:	8526                	mv	a0,s1
    800038a2:	60e6                	ld	ra,88(sp)
    800038a4:	6446                	ld	s0,80(sp)
    800038a6:	64a6                	ld	s1,72(sp)
    800038a8:	6906                	ld	s2,64(sp)
    800038aa:	79e2                	ld	s3,56(sp)
    800038ac:	7a42                	ld	s4,48(sp)
    800038ae:	7aa2                	ld	s5,40(sp)
    800038b0:	7b02                	ld	s6,32(sp)
    800038b2:	6be2                	ld	s7,24(sp)
    800038b4:	6c42                	ld	s8,16(sp)
    800038b6:	6ca2                	ld	s9,8(sp)
    800038b8:	6125                	addi	sp,sp,96
    800038ba:	8082                	ret
    brelse(bp);
    800038bc:	854a                	mv	a0,s2
    800038be:	00000097          	auipc	ra,0x0
    800038c2:	dc4080e7          	jalr	-572(ra) # 80003682 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800038c6:	015c87bb          	addw	a5,s9,s5
    800038ca:	00078a9b          	sext.w	s5,a5
    800038ce:	004b2703          	lw	a4,4(s6)
    800038d2:	06eaf363          	bgeu	s5,a4,80003938 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800038d6:	41fad79b          	sraiw	a5,s5,0x1f
    800038da:	0137d79b          	srliw	a5,a5,0x13
    800038de:	015787bb          	addw	a5,a5,s5
    800038e2:	40d7d79b          	sraiw	a5,a5,0xd
    800038e6:	01cb2583          	lw	a1,28(s6)
    800038ea:	9dbd                	addw	a1,a1,a5
    800038ec:	855e                	mv	a0,s7
    800038ee:	00000097          	auipc	ra,0x0
    800038f2:	c64080e7          	jalr	-924(ra) # 80003552 <bread>
    800038f6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038f8:	004b2503          	lw	a0,4(s6)
    800038fc:	000a849b          	sext.w	s1,s5
    80003900:	8662                	mv	a2,s8
    80003902:	faa4fde3          	bgeu	s1,a0,800038bc <balloc+0xa8>
      m = 1 << (bi % 8);
    80003906:	41f6579b          	sraiw	a5,a2,0x1f
    8000390a:	01d7d69b          	srliw	a3,a5,0x1d
    8000390e:	00c6873b          	addw	a4,a3,a2
    80003912:	00777793          	andi	a5,a4,7
    80003916:	9f95                	subw	a5,a5,a3
    80003918:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000391c:	4037571b          	sraiw	a4,a4,0x3
    80003920:	00e906b3          	add	a3,s2,a4
    80003924:	0586c683          	lbu	a3,88(a3)
    80003928:	00d7f5b3          	and	a1,a5,a3
    8000392c:	d195                	beqz	a1,80003850 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000392e:	2605                	addiw	a2,a2,1
    80003930:	2485                	addiw	s1,s1,1
    80003932:	fd4618e3          	bne	a2,s4,80003902 <balloc+0xee>
    80003936:	b759                	j	800038bc <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003938:	00005517          	auipc	a0,0x5
    8000393c:	ea850513          	addi	a0,a0,-344 # 800087e0 <syscall_list+0x168>
    80003940:	ffffd097          	auipc	ra,0xffffd
    80003944:	c4e080e7          	jalr	-946(ra) # 8000058e <printf>
  return 0;
    80003948:	4481                	li	s1,0
    8000394a:	bf99                	j	800038a0 <balloc+0x8c>

000000008000394c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000394c:	7179                	addi	sp,sp,-48
    8000394e:	f406                	sd	ra,40(sp)
    80003950:	f022                	sd	s0,32(sp)
    80003952:	ec26                	sd	s1,24(sp)
    80003954:	e84a                	sd	s2,16(sp)
    80003956:	e44e                	sd	s3,8(sp)
    80003958:	e052                	sd	s4,0(sp)
    8000395a:	1800                	addi	s0,sp,48
    8000395c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000395e:	47ad                	li	a5,11
    80003960:	02b7e763          	bltu	a5,a1,8000398e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003964:	02059493          	slli	s1,a1,0x20
    80003968:	9081                	srli	s1,s1,0x20
    8000396a:	048a                	slli	s1,s1,0x2
    8000396c:	94aa                	add	s1,s1,a0
    8000396e:	0504a903          	lw	s2,80(s1)
    80003972:	06091e63          	bnez	s2,800039ee <bmap+0xa2>
      addr = balloc(ip->dev);
    80003976:	4108                	lw	a0,0(a0)
    80003978:	00000097          	auipc	ra,0x0
    8000397c:	e9c080e7          	jalr	-356(ra) # 80003814 <balloc>
    80003980:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003984:	06090563          	beqz	s2,800039ee <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003988:	0524a823          	sw	s2,80(s1)
    8000398c:	a08d                	j	800039ee <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000398e:	ff45849b          	addiw	s1,a1,-12
    80003992:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003996:	0ff00793          	li	a5,255
    8000399a:	08e7e563          	bltu	a5,a4,80003a24 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000399e:	08052903          	lw	s2,128(a0)
    800039a2:	00091d63          	bnez	s2,800039bc <bmap+0x70>
      addr = balloc(ip->dev);
    800039a6:	4108                	lw	a0,0(a0)
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	e6c080e7          	jalr	-404(ra) # 80003814 <balloc>
    800039b0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800039b4:	02090d63          	beqz	s2,800039ee <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800039b8:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800039bc:	85ca                	mv	a1,s2
    800039be:	0009a503          	lw	a0,0(s3)
    800039c2:	00000097          	auipc	ra,0x0
    800039c6:	b90080e7          	jalr	-1136(ra) # 80003552 <bread>
    800039ca:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800039cc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800039d0:	02049593          	slli	a1,s1,0x20
    800039d4:	9181                	srli	a1,a1,0x20
    800039d6:	058a                	slli	a1,a1,0x2
    800039d8:	00b784b3          	add	s1,a5,a1
    800039dc:	0004a903          	lw	s2,0(s1)
    800039e0:	02090063          	beqz	s2,80003a00 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800039e4:	8552                	mv	a0,s4
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	c9c080e7          	jalr	-868(ra) # 80003682 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800039ee:	854a                	mv	a0,s2
    800039f0:	70a2                	ld	ra,40(sp)
    800039f2:	7402                	ld	s0,32(sp)
    800039f4:	64e2                	ld	s1,24(sp)
    800039f6:	6942                	ld	s2,16(sp)
    800039f8:	69a2                	ld	s3,8(sp)
    800039fa:	6a02                	ld	s4,0(sp)
    800039fc:	6145                	addi	sp,sp,48
    800039fe:	8082                	ret
      addr = balloc(ip->dev);
    80003a00:	0009a503          	lw	a0,0(s3)
    80003a04:	00000097          	auipc	ra,0x0
    80003a08:	e10080e7          	jalr	-496(ra) # 80003814 <balloc>
    80003a0c:	0005091b          	sext.w	s2,a0
      if(addr){
    80003a10:	fc090ae3          	beqz	s2,800039e4 <bmap+0x98>
        a[bn] = addr;
    80003a14:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003a18:	8552                	mv	a0,s4
    80003a1a:	00001097          	auipc	ra,0x1
    80003a1e:	eec080e7          	jalr	-276(ra) # 80004906 <log_write>
    80003a22:	b7c9                	j	800039e4 <bmap+0x98>
  panic("bmap: out of range");
    80003a24:	00005517          	auipc	a0,0x5
    80003a28:	dd450513          	addi	a0,a0,-556 # 800087f8 <syscall_list+0x180>
    80003a2c:	ffffd097          	auipc	ra,0xffffd
    80003a30:	b18080e7          	jalr	-1256(ra) # 80000544 <panic>

0000000080003a34 <iget>:
{
    80003a34:	7179                	addi	sp,sp,-48
    80003a36:	f406                	sd	ra,40(sp)
    80003a38:	f022                	sd	s0,32(sp)
    80003a3a:	ec26                	sd	s1,24(sp)
    80003a3c:	e84a                	sd	s2,16(sp)
    80003a3e:	e44e                	sd	s3,8(sp)
    80003a40:	e052                	sd	s4,0(sp)
    80003a42:	1800                	addi	s0,sp,48
    80003a44:	89aa                	mv	s3,a0
    80003a46:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003a48:	00242517          	auipc	a0,0x242
    80003a4c:	2f850513          	addi	a0,a0,760 # 80245d40 <itable>
    80003a50:	ffffd097          	auipc	ra,0xffffd
    80003a54:	2d0080e7          	jalr	720(ra) # 80000d20 <acquire>
  empty = 0;
    80003a58:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a5a:	00242497          	auipc	s1,0x242
    80003a5e:	2fe48493          	addi	s1,s1,766 # 80245d58 <itable+0x18>
    80003a62:	00244697          	auipc	a3,0x244
    80003a66:	d8668693          	addi	a3,a3,-634 # 802477e8 <log>
    80003a6a:	a039                	j	80003a78 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a6c:	02090b63          	beqz	s2,80003aa2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a70:	08848493          	addi	s1,s1,136
    80003a74:	02d48a63          	beq	s1,a3,80003aa8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003a78:	449c                	lw	a5,8(s1)
    80003a7a:	fef059e3          	blez	a5,80003a6c <iget+0x38>
    80003a7e:	4098                	lw	a4,0(s1)
    80003a80:	ff3716e3          	bne	a4,s3,80003a6c <iget+0x38>
    80003a84:	40d8                	lw	a4,4(s1)
    80003a86:	ff4713e3          	bne	a4,s4,80003a6c <iget+0x38>
      ip->ref++;
    80003a8a:	2785                	addiw	a5,a5,1
    80003a8c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003a8e:	00242517          	auipc	a0,0x242
    80003a92:	2b250513          	addi	a0,a0,690 # 80245d40 <itable>
    80003a96:	ffffd097          	auipc	ra,0xffffd
    80003a9a:	33e080e7          	jalr	830(ra) # 80000dd4 <release>
      return ip;
    80003a9e:	8926                	mv	s2,s1
    80003aa0:	a03d                	j	80003ace <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003aa2:	f7f9                	bnez	a5,80003a70 <iget+0x3c>
    80003aa4:	8926                	mv	s2,s1
    80003aa6:	b7e9                	j	80003a70 <iget+0x3c>
  if(empty == 0)
    80003aa8:	02090c63          	beqz	s2,80003ae0 <iget+0xac>
  ip->dev = dev;
    80003aac:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003ab0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003ab4:	4785                	li	a5,1
    80003ab6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003aba:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003abe:	00242517          	auipc	a0,0x242
    80003ac2:	28250513          	addi	a0,a0,642 # 80245d40 <itable>
    80003ac6:	ffffd097          	auipc	ra,0xffffd
    80003aca:	30e080e7          	jalr	782(ra) # 80000dd4 <release>
}
    80003ace:	854a                	mv	a0,s2
    80003ad0:	70a2                	ld	ra,40(sp)
    80003ad2:	7402                	ld	s0,32(sp)
    80003ad4:	64e2                	ld	s1,24(sp)
    80003ad6:	6942                	ld	s2,16(sp)
    80003ad8:	69a2                	ld	s3,8(sp)
    80003ada:	6a02                	ld	s4,0(sp)
    80003adc:	6145                	addi	sp,sp,48
    80003ade:	8082                	ret
    panic("iget: no inodes");
    80003ae0:	00005517          	auipc	a0,0x5
    80003ae4:	d3050513          	addi	a0,a0,-720 # 80008810 <syscall_list+0x198>
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	a5c080e7          	jalr	-1444(ra) # 80000544 <panic>

0000000080003af0 <fsinit>:
fsinit(int dev) {
    80003af0:	7179                	addi	sp,sp,-48
    80003af2:	f406                	sd	ra,40(sp)
    80003af4:	f022                	sd	s0,32(sp)
    80003af6:	ec26                	sd	s1,24(sp)
    80003af8:	e84a                	sd	s2,16(sp)
    80003afa:	e44e                	sd	s3,8(sp)
    80003afc:	1800                	addi	s0,sp,48
    80003afe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003b00:	4585                	li	a1,1
    80003b02:	00000097          	auipc	ra,0x0
    80003b06:	a50080e7          	jalr	-1456(ra) # 80003552 <bread>
    80003b0a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003b0c:	00242997          	auipc	s3,0x242
    80003b10:	21498993          	addi	s3,s3,532 # 80245d20 <sb>
    80003b14:	02000613          	li	a2,32
    80003b18:	05850593          	addi	a1,a0,88
    80003b1c:	854e                	mv	a0,s3
    80003b1e:	ffffd097          	auipc	ra,0xffffd
    80003b22:	35e080e7          	jalr	862(ra) # 80000e7c <memmove>
  brelse(bp);
    80003b26:	8526                	mv	a0,s1
    80003b28:	00000097          	auipc	ra,0x0
    80003b2c:	b5a080e7          	jalr	-1190(ra) # 80003682 <brelse>
  if(sb.magic != FSMAGIC)
    80003b30:	0009a703          	lw	a4,0(s3)
    80003b34:	102037b7          	lui	a5,0x10203
    80003b38:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b3c:	02f71263          	bne	a4,a5,80003b60 <fsinit+0x70>
  initlog(dev, &sb);
    80003b40:	00242597          	auipc	a1,0x242
    80003b44:	1e058593          	addi	a1,a1,480 # 80245d20 <sb>
    80003b48:	854a                	mv	a0,s2
    80003b4a:	00001097          	auipc	ra,0x1
    80003b4e:	b40080e7          	jalr	-1216(ra) # 8000468a <initlog>
}
    80003b52:	70a2                	ld	ra,40(sp)
    80003b54:	7402                	ld	s0,32(sp)
    80003b56:	64e2                	ld	s1,24(sp)
    80003b58:	6942                	ld	s2,16(sp)
    80003b5a:	69a2                	ld	s3,8(sp)
    80003b5c:	6145                	addi	sp,sp,48
    80003b5e:	8082                	ret
    panic("invalid file system");
    80003b60:	00005517          	auipc	a0,0x5
    80003b64:	cc050513          	addi	a0,a0,-832 # 80008820 <syscall_list+0x1a8>
    80003b68:	ffffd097          	auipc	ra,0xffffd
    80003b6c:	9dc080e7          	jalr	-1572(ra) # 80000544 <panic>

0000000080003b70 <iinit>:
{
    80003b70:	7179                	addi	sp,sp,-48
    80003b72:	f406                	sd	ra,40(sp)
    80003b74:	f022                	sd	s0,32(sp)
    80003b76:	ec26                	sd	s1,24(sp)
    80003b78:	e84a                	sd	s2,16(sp)
    80003b7a:	e44e                	sd	s3,8(sp)
    80003b7c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003b7e:	00005597          	auipc	a1,0x5
    80003b82:	cba58593          	addi	a1,a1,-838 # 80008838 <syscall_list+0x1c0>
    80003b86:	00242517          	auipc	a0,0x242
    80003b8a:	1ba50513          	addi	a0,a0,442 # 80245d40 <itable>
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	102080e7          	jalr	258(ra) # 80000c90 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b96:	00242497          	auipc	s1,0x242
    80003b9a:	1d248493          	addi	s1,s1,466 # 80245d68 <itable+0x28>
    80003b9e:	00244997          	auipc	s3,0x244
    80003ba2:	c5a98993          	addi	s3,s3,-934 # 802477f8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003ba6:	00005917          	auipc	s2,0x5
    80003baa:	c9a90913          	addi	s2,s2,-870 # 80008840 <syscall_list+0x1c8>
    80003bae:	85ca                	mv	a1,s2
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	00001097          	auipc	ra,0x1
    80003bb6:	e3a080e7          	jalr	-454(ra) # 800049ec <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003bba:	08848493          	addi	s1,s1,136
    80003bbe:	ff3498e3          	bne	s1,s3,80003bae <iinit+0x3e>
}
    80003bc2:	70a2                	ld	ra,40(sp)
    80003bc4:	7402                	ld	s0,32(sp)
    80003bc6:	64e2                	ld	s1,24(sp)
    80003bc8:	6942                	ld	s2,16(sp)
    80003bca:	69a2                	ld	s3,8(sp)
    80003bcc:	6145                	addi	sp,sp,48
    80003bce:	8082                	ret

0000000080003bd0 <ialloc>:
{
    80003bd0:	715d                	addi	sp,sp,-80
    80003bd2:	e486                	sd	ra,72(sp)
    80003bd4:	e0a2                	sd	s0,64(sp)
    80003bd6:	fc26                	sd	s1,56(sp)
    80003bd8:	f84a                	sd	s2,48(sp)
    80003bda:	f44e                	sd	s3,40(sp)
    80003bdc:	f052                	sd	s4,32(sp)
    80003bde:	ec56                	sd	s5,24(sp)
    80003be0:	e85a                	sd	s6,16(sp)
    80003be2:	e45e                	sd	s7,8(sp)
    80003be4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003be6:	00242717          	auipc	a4,0x242
    80003bea:	14672703          	lw	a4,326(a4) # 80245d2c <sb+0xc>
    80003bee:	4785                	li	a5,1
    80003bf0:	04e7fa63          	bgeu	a5,a4,80003c44 <ialloc+0x74>
    80003bf4:	8aaa                	mv	s5,a0
    80003bf6:	8bae                	mv	s7,a1
    80003bf8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003bfa:	00242a17          	auipc	s4,0x242
    80003bfe:	126a0a13          	addi	s4,s4,294 # 80245d20 <sb>
    80003c02:	00048b1b          	sext.w	s6,s1
    80003c06:	0044d593          	srli	a1,s1,0x4
    80003c0a:	018a2783          	lw	a5,24(s4)
    80003c0e:	9dbd                	addw	a1,a1,a5
    80003c10:	8556                	mv	a0,s5
    80003c12:	00000097          	auipc	ra,0x0
    80003c16:	940080e7          	jalr	-1728(ra) # 80003552 <bread>
    80003c1a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003c1c:	05850993          	addi	s3,a0,88
    80003c20:	00f4f793          	andi	a5,s1,15
    80003c24:	079a                	slli	a5,a5,0x6
    80003c26:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003c28:	00099783          	lh	a5,0(s3)
    80003c2c:	c3a1                	beqz	a5,80003c6c <ialloc+0x9c>
    brelse(bp);
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	a54080e7          	jalr	-1452(ra) # 80003682 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c36:	0485                	addi	s1,s1,1
    80003c38:	00ca2703          	lw	a4,12(s4)
    80003c3c:	0004879b          	sext.w	a5,s1
    80003c40:	fce7e1e3          	bltu	a5,a4,80003c02 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003c44:	00005517          	auipc	a0,0x5
    80003c48:	c0450513          	addi	a0,a0,-1020 # 80008848 <syscall_list+0x1d0>
    80003c4c:	ffffd097          	auipc	ra,0xffffd
    80003c50:	942080e7          	jalr	-1726(ra) # 8000058e <printf>
  return 0;
    80003c54:	4501                	li	a0,0
}
    80003c56:	60a6                	ld	ra,72(sp)
    80003c58:	6406                	ld	s0,64(sp)
    80003c5a:	74e2                	ld	s1,56(sp)
    80003c5c:	7942                	ld	s2,48(sp)
    80003c5e:	79a2                	ld	s3,40(sp)
    80003c60:	7a02                	ld	s4,32(sp)
    80003c62:	6ae2                	ld	s5,24(sp)
    80003c64:	6b42                	ld	s6,16(sp)
    80003c66:	6ba2                	ld	s7,8(sp)
    80003c68:	6161                	addi	sp,sp,80
    80003c6a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003c6c:	04000613          	li	a2,64
    80003c70:	4581                	li	a1,0
    80003c72:	854e                	mv	a0,s3
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	1a8080e7          	jalr	424(ra) # 80000e1c <memset>
      dip->type = type;
    80003c7c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c80:	854a                	mv	a0,s2
    80003c82:	00001097          	auipc	ra,0x1
    80003c86:	c84080e7          	jalr	-892(ra) # 80004906 <log_write>
      brelse(bp);
    80003c8a:	854a                	mv	a0,s2
    80003c8c:	00000097          	auipc	ra,0x0
    80003c90:	9f6080e7          	jalr	-1546(ra) # 80003682 <brelse>
      return iget(dev, inum);
    80003c94:	85da                	mv	a1,s6
    80003c96:	8556                	mv	a0,s5
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	d9c080e7          	jalr	-612(ra) # 80003a34 <iget>
    80003ca0:	bf5d                	j	80003c56 <ialloc+0x86>

0000000080003ca2 <iupdate>:
{
    80003ca2:	1101                	addi	sp,sp,-32
    80003ca4:	ec06                	sd	ra,24(sp)
    80003ca6:	e822                	sd	s0,16(sp)
    80003ca8:	e426                	sd	s1,8(sp)
    80003caa:	e04a                	sd	s2,0(sp)
    80003cac:	1000                	addi	s0,sp,32
    80003cae:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cb0:	415c                	lw	a5,4(a0)
    80003cb2:	0047d79b          	srliw	a5,a5,0x4
    80003cb6:	00242597          	auipc	a1,0x242
    80003cba:	0825a583          	lw	a1,130(a1) # 80245d38 <sb+0x18>
    80003cbe:	9dbd                	addw	a1,a1,a5
    80003cc0:	4108                	lw	a0,0(a0)
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	890080e7          	jalr	-1904(ra) # 80003552 <bread>
    80003cca:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ccc:	05850793          	addi	a5,a0,88
    80003cd0:	40c8                	lw	a0,4(s1)
    80003cd2:	893d                	andi	a0,a0,15
    80003cd4:	051a                	slli	a0,a0,0x6
    80003cd6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003cd8:	04449703          	lh	a4,68(s1)
    80003cdc:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003ce0:	04649703          	lh	a4,70(s1)
    80003ce4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003ce8:	04849703          	lh	a4,72(s1)
    80003cec:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003cf0:	04a49703          	lh	a4,74(s1)
    80003cf4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003cf8:	44f8                	lw	a4,76(s1)
    80003cfa:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003cfc:	03400613          	li	a2,52
    80003d00:	05048593          	addi	a1,s1,80
    80003d04:	0531                	addi	a0,a0,12
    80003d06:	ffffd097          	auipc	ra,0xffffd
    80003d0a:	176080e7          	jalr	374(ra) # 80000e7c <memmove>
  log_write(bp);
    80003d0e:	854a                	mv	a0,s2
    80003d10:	00001097          	auipc	ra,0x1
    80003d14:	bf6080e7          	jalr	-1034(ra) # 80004906 <log_write>
  brelse(bp);
    80003d18:	854a                	mv	a0,s2
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	968080e7          	jalr	-1688(ra) # 80003682 <brelse>
}
    80003d22:	60e2                	ld	ra,24(sp)
    80003d24:	6442                	ld	s0,16(sp)
    80003d26:	64a2                	ld	s1,8(sp)
    80003d28:	6902                	ld	s2,0(sp)
    80003d2a:	6105                	addi	sp,sp,32
    80003d2c:	8082                	ret

0000000080003d2e <idup>:
{
    80003d2e:	1101                	addi	sp,sp,-32
    80003d30:	ec06                	sd	ra,24(sp)
    80003d32:	e822                	sd	s0,16(sp)
    80003d34:	e426                	sd	s1,8(sp)
    80003d36:	1000                	addi	s0,sp,32
    80003d38:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d3a:	00242517          	auipc	a0,0x242
    80003d3e:	00650513          	addi	a0,a0,6 # 80245d40 <itable>
    80003d42:	ffffd097          	auipc	ra,0xffffd
    80003d46:	fde080e7          	jalr	-34(ra) # 80000d20 <acquire>
  ip->ref++;
    80003d4a:	449c                	lw	a5,8(s1)
    80003d4c:	2785                	addiw	a5,a5,1
    80003d4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d50:	00242517          	auipc	a0,0x242
    80003d54:	ff050513          	addi	a0,a0,-16 # 80245d40 <itable>
    80003d58:	ffffd097          	auipc	ra,0xffffd
    80003d5c:	07c080e7          	jalr	124(ra) # 80000dd4 <release>
}
    80003d60:	8526                	mv	a0,s1
    80003d62:	60e2                	ld	ra,24(sp)
    80003d64:	6442                	ld	s0,16(sp)
    80003d66:	64a2                	ld	s1,8(sp)
    80003d68:	6105                	addi	sp,sp,32
    80003d6a:	8082                	ret

0000000080003d6c <ilock>:
{
    80003d6c:	1101                	addi	sp,sp,-32
    80003d6e:	ec06                	sd	ra,24(sp)
    80003d70:	e822                	sd	s0,16(sp)
    80003d72:	e426                	sd	s1,8(sp)
    80003d74:	e04a                	sd	s2,0(sp)
    80003d76:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d78:	c115                	beqz	a0,80003d9c <ilock+0x30>
    80003d7a:	84aa                	mv	s1,a0
    80003d7c:	451c                	lw	a5,8(a0)
    80003d7e:	00f05f63          	blez	a5,80003d9c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003d82:	0541                	addi	a0,a0,16
    80003d84:	00001097          	auipc	ra,0x1
    80003d88:	ca2080e7          	jalr	-862(ra) # 80004a26 <acquiresleep>
  if(ip->valid == 0){
    80003d8c:	40bc                	lw	a5,64(s1)
    80003d8e:	cf99                	beqz	a5,80003dac <ilock+0x40>
}
    80003d90:	60e2                	ld	ra,24(sp)
    80003d92:	6442                	ld	s0,16(sp)
    80003d94:	64a2                	ld	s1,8(sp)
    80003d96:	6902                	ld	s2,0(sp)
    80003d98:	6105                	addi	sp,sp,32
    80003d9a:	8082                	ret
    panic("ilock");
    80003d9c:	00005517          	auipc	a0,0x5
    80003da0:	ac450513          	addi	a0,a0,-1340 # 80008860 <syscall_list+0x1e8>
    80003da4:	ffffc097          	auipc	ra,0xffffc
    80003da8:	7a0080e7          	jalr	1952(ra) # 80000544 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003dac:	40dc                	lw	a5,4(s1)
    80003dae:	0047d79b          	srliw	a5,a5,0x4
    80003db2:	00242597          	auipc	a1,0x242
    80003db6:	f865a583          	lw	a1,-122(a1) # 80245d38 <sb+0x18>
    80003dba:	9dbd                	addw	a1,a1,a5
    80003dbc:	4088                	lw	a0,0(s1)
    80003dbe:	fffff097          	auipc	ra,0xfffff
    80003dc2:	794080e7          	jalr	1940(ra) # 80003552 <bread>
    80003dc6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003dc8:	05850593          	addi	a1,a0,88
    80003dcc:	40dc                	lw	a5,4(s1)
    80003dce:	8bbd                	andi	a5,a5,15
    80003dd0:	079a                	slli	a5,a5,0x6
    80003dd2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003dd4:	00059783          	lh	a5,0(a1)
    80003dd8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003ddc:	00259783          	lh	a5,2(a1)
    80003de0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003de4:	00459783          	lh	a5,4(a1)
    80003de8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003dec:	00659783          	lh	a5,6(a1)
    80003df0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003df4:	459c                	lw	a5,8(a1)
    80003df6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003df8:	03400613          	li	a2,52
    80003dfc:	05b1                	addi	a1,a1,12
    80003dfe:	05048513          	addi	a0,s1,80
    80003e02:	ffffd097          	auipc	ra,0xffffd
    80003e06:	07a080e7          	jalr	122(ra) # 80000e7c <memmove>
    brelse(bp);
    80003e0a:	854a                	mv	a0,s2
    80003e0c:	00000097          	auipc	ra,0x0
    80003e10:	876080e7          	jalr	-1930(ra) # 80003682 <brelse>
    ip->valid = 1;
    80003e14:	4785                	li	a5,1
    80003e16:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003e18:	04449783          	lh	a5,68(s1)
    80003e1c:	fbb5                	bnez	a5,80003d90 <ilock+0x24>
      panic("ilock: no type");
    80003e1e:	00005517          	auipc	a0,0x5
    80003e22:	a4a50513          	addi	a0,a0,-1462 # 80008868 <syscall_list+0x1f0>
    80003e26:	ffffc097          	auipc	ra,0xffffc
    80003e2a:	71e080e7          	jalr	1822(ra) # 80000544 <panic>

0000000080003e2e <iunlock>:
{
    80003e2e:	1101                	addi	sp,sp,-32
    80003e30:	ec06                	sd	ra,24(sp)
    80003e32:	e822                	sd	s0,16(sp)
    80003e34:	e426                	sd	s1,8(sp)
    80003e36:	e04a                	sd	s2,0(sp)
    80003e38:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e3a:	c905                	beqz	a0,80003e6a <iunlock+0x3c>
    80003e3c:	84aa                	mv	s1,a0
    80003e3e:	01050913          	addi	s2,a0,16
    80003e42:	854a                	mv	a0,s2
    80003e44:	00001097          	auipc	ra,0x1
    80003e48:	c7c080e7          	jalr	-900(ra) # 80004ac0 <holdingsleep>
    80003e4c:	cd19                	beqz	a0,80003e6a <iunlock+0x3c>
    80003e4e:	449c                	lw	a5,8(s1)
    80003e50:	00f05d63          	blez	a5,80003e6a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003e54:	854a                	mv	a0,s2
    80003e56:	00001097          	auipc	ra,0x1
    80003e5a:	c26080e7          	jalr	-986(ra) # 80004a7c <releasesleep>
}
    80003e5e:	60e2                	ld	ra,24(sp)
    80003e60:	6442                	ld	s0,16(sp)
    80003e62:	64a2                	ld	s1,8(sp)
    80003e64:	6902                	ld	s2,0(sp)
    80003e66:	6105                	addi	sp,sp,32
    80003e68:	8082                	ret
    panic("iunlock");
    80003e6a:	00005517          	auipc	a0,0x5
    80003e6e:	a0e50513          	addi	a0,a0,-1522 # 80008878 <syscall_list+0x200>
    80003e72:	ffffc097          	auipc	ra,0xffffc
    80003e76:	6d2080e7          	jalr	1746(ra) # 80000544 <panic>

0000000080003e7a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e7a:	7179                	addi	sp,sp,-48
    80003e7c:	f406                	sd	ra,40(sp)
    80003e7e:	f022                	sd	s0,32(sp)
    80003e80:	ec26                	sd	s1,24(sp)
    80003e82:	e84a                	sd	s2,16(sp)
    80003e84:	e44e                	sd	s3,8(sp)
    80003e86:	e052                	sd	s4,0(sp)
    80003e88:	1800                	addi	s0,sp,48
    80003e8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e8c:	05050493          	addi	s1,a0,80
    80003e90:	08050913          	addi	s2,a0,128
    80003e94:	a021                	j	80003e9c <itrunc+0x22>
    80003e96:	0491                	addi	s1,s1,4
    80003e98:	01248d63          	beq	s1,s2,80003eb2 <itrunc+0x38>
    if(ip->addrs[i]){
    80003e9c:	408c                	lw	a1,0(s1)
    80003e9e:	dde5                	beqz	a1,80003e96 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003ea0:	0009a503          	lw	a0,0(s3)
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	8f4080e7          	jalr	-1804(ra) # 80003798 <bfree>
      ip->addrs[i] = 0;
    80003eac:	0004a023          	sw	zero,0(s1)
    80003eb0:	b7dd                	j	80003e96 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003eb2:	0809a583          	lw	a1,128(s3)
    80003eb6:	e185                	bnez	a1,80003ed6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003eb8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003ebc:	854e                	mv	a0,s3
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	de4080e7          	jalr	-540(ra) # 80003ca2 <iupdate>
}
    80003ec6:	70a2                	ld	ra,40(sp)
    80003ec8:	7402                	ld	s0,32(sp)
    80003eca:	64e2                	ld	s1,24(sp)
    80003ecc:	6942                	ld	s2,16(sp)
    80003ece:	69a2                	ld	s3,8(sp)
    80003ed0:	6a02                	ld	s4,0(sp)
    80003ed2:	6145                	addi	sp,sp,48
    80003ed4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ed6:	0009a503          	lw	a0,0(s3)
    80003eda:	fffff097          	auipc	ra,0xfffff
    80003ede:	678080e7          	jalr	1656(ra) # 80003552 <bread>
    80003ee2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003ee4:	05850493          	addi	s1,a0,88
    80003ee8:	45850913          	addi	s2,a0,1112
    80003eec:	a811                	j	80003f00 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003eee:	0009a503          	lw	a0,0(s3)
    80003ef2:	00000097          	auipc	ra,0x0
    80003ef6:	8a6080e7          	jalr	-1882(ra) # 80003798 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003efa:	0491                	addi	s1,s1,4
    80003efc:	01248563          	beq	s1,s2,80003f06 <itrunc+0x8c>
      if(a[j])
    80003f00:	408c                	lw	a1,0(s1)
    80003f02:	dde5                	beqz	a1,80003efa <itrunc+0x80>
    80003f04:	b7ed                	j	80003eee <itrunc+0x74>
    brelse(bp);
    80003f06:	8552                	mv	a0,s4
    80003f08:	fffff097          	auipc	ra,0xfffff
    80003f0c:	77a080e7          	jalr	1914(ra) # 80003682 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003f10:	0809a583          	lw	a1,128(s3)
    80003f14:	0009a503          	lw	a0,0(s3)
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	880080e7          	jalr	-1920(ra) # 80003798 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003f20:	0809a023          	sw	zero,128(s3)
    80003f24:	bf51                	j	80003eb8 <itrunc+0x3e>

0000000080003f26 <iput>:
{
    80003f26:	1101                	addi	sp,sp,-32
    80003f28:	ec06                	sd	ra,24(sp)
    80003f2a:	e822                	sd	s0,16(sp)
    80003f2c:	e426                	sd	s1,8(sp)
    80003f2e:	e04a                	sd	s2,0(sp)
    80003f30:	1000                	addi	s0,sp,32
    80003f32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f34:	00242517          	auipc	a0,0x242
    80003f38:	e0c50513          	addi	a0,a0,-500 # 80245d40 <itable>
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	de4080e7          	jalr	-540(ra) # 80000d20 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f44:	4498                	lw	a4,8(s1)
    80003f46:	4785                	li	a5,1
    80003f48:	02f70363          	beq	a4,a5,80003f6e <iput+0x48>
  ip->ref--;
    80003f4c:	449c                	lw	a5,8(s1)
    80003f4e:	37fd                	addiw	a5,a5,-1
    80003f50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f52:	00242517          	auipc	a0,0x242
    80003f56:	dee50513          	addi	a0,a0,-530 # 80245d40 <itable>
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	e7a080e7          	jalr	-390(ra) # 80000dd4 <release>
}
    80003f62:	60e2                	ld	ra,24(sp)
    80003f64:	6442                	ld	s0,16(sp)
    80003f66:	64a2                	ld	s1,8(sp)
    80003f68:	6902                	ld	s2,0(sp)
    80003f6a:	6105                	addi	sp,sp,32
    80003f6c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f6e:	40bc                	lw	a5,64(s1)
    80003f70:	dff1                	beqz	a5,80003f4c <iput+0x26>
    80003f72:	04a49783          	lh	a5,74(s1)
    80003f76:	fbf9                	bnez	a5,80003f4c <iput+0x26>
    acquiresleep(&ip->lock);
    80003f78:	01048913          	addi	s2,s1,16
    80003f7c:	854a                	mv	a0,s2
    80003f7e:	00001097          	auipc	ra,0x1
    80003f82:	aa8080e7          	jalr	-1368(ra) # 80004a26 <acquiresleep>
    release(&itable.lock);
    80003f86:	00242517          	auipc	a0,0x242
    80003f8a:	dba50513          	addi	a0,a0,-582 # 80245d40 <itable>
    80003f8e:	ffffd097          	auipc	ra,0xffffd
    80003f92:	e46080e7          	jalr	-442(ra) # 80000dd4 <release>
    itrunc(ip);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00000097          	auipc	ra,0x0
    80003f9c:	ee2080e7          	jalr	-286(ra) # 80003e7a <itrunc>
    ip->type = 0;
    80003fa0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	00000097          	auipc	ra,0x0
    80003faa:	cfc080e7          	jalr	-772(ra) # 80003ca2 <iupdate>
    ip->valid = 0;
    80003fae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003fb2:	854a                	mv	a0,s2
    80003fb4:	00001097          	auipc	ra,0x1
    80003fb8:	ac8080e7          	jalr	-1336(ra) # 80004a7c <releasesleep>
    acquire(&itable.lock);
    80003fbc:	00242517          	auipc	a0,0x242
    80003fc0:	d8450513          	addi	a0,a0,-636 # 80245d40 <itable>
    80003fc4:	ffffd097          	auipc	ra,0xffffd
    80003fc8:	d5c080e7          	jalr	-676(ra) # 80000d20 <acquire>
    80003fcc:	b741                	j	80003f4c <iput+0x26>

0000000080003fce <iunlockput>:
{
    80003fce:	1101                	addi	sp,sp,-32
    80003fd0:	ec06                	sd	ra,24(sp)
    80003fd2:	e822                	sd	s0,16(sp)
    80003fd4:	e426                	sd	s1,8(sp)
    80003fd6:	1000                	addi	s0,sp,32
    80003fd8:	84aa                	mv	s1,a0
  iunlock(ip);
    80003fda:	00000097          	auipc	ra,0x0
    80003fde:	e54080e7          	jalr	-428(ra) # 80003e2e <iunlock>
  iput(ip);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	00000097          	auipc	ra,0x0
    80003fe8:	f42080e7          	jalr	-190(ra) # 80003f26 <iput>
}
    80003fec:	60e2                	ld	ra,24(sp)
    80003fee:	6442                	ld	s0,16(sp)
    80003ff0:	64a2                	ld	s1,8(sp)
    80003ff2:	6105                	addi	sp,sp,32
    80003ff4:	8082                	ret

0000000080003ff6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003ff6:	1141                	addi	sp,sp,-16
    80003ff8:	e422                	sd	s0,8(sp)
    80003ffa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ffc:	411c                	lw	a5,0(a0)
    80003ffe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004000:	415c                	lw	a5,4(a0)
    80004002:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004004:	04451783          	lh	a5,68(a0)
    80004008:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000400c:	04a51783          	lh	a5,74(a0)
    80004010:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004014:	04c56783          	lwu	a5,76(a0)
    80004018:	e99c                	sd	a5,16(a1)
}
    8000401a:	6422                	ld	s0,8(sp)
    8000401c:	0141                	addi	sp,sp,16
    8000401e:	8082                	ret

0000000080004020 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004020:	457c                	lw	a5,76(a0)
    80004022:	0ed7e963          	bltu	a5,a3,80004114 <readi+0xf4>
{
    80004026:	7159                	addi	sp,sp,-112
    80004028:	f486                	sd	ra,104(sp)
    8000402a:	f0a2                	sd	s0,96(sp)
    8000402c:	eca6                	sd	s1,88(sp)
    8000402e:	e8ca                	sd	s2,80(sp)
    80004030:	e4ce                	sd	s3,72(sp)
    80004032:	e0d2                	sd	s4,64(sp)
    80004034:	fc56                	sd	s5,56(sp)
    80004036:	f85a                	sd	s6,48(sp)
    80004038:	f45e                	sd	s7,40(sp)
    8000403a:	f062                	sd	s8,32(sp)
    8000403c:	ec66                	sd	s9,24(sp)
    8000403e:	e86a                	sd	s10,16(sp)
    80004040:	e46e                	sd	s11,8(sp)
    80004042:	1880                	addi	s0,sp,112
    80004044:	8b2a                	mv	s6,a0
    80004046:	8bae                	mv	s7,a1
    80004048:	8a32                	mv	s4,a2
    8000404a:	84b6                	mv	s1,a3
    8000404c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000404e:	9f35                	addw	a4,a4,a3
    return 0;
    80004050:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004052:	0ad76063          	bltu	a4,a3,800040f2 <readi+0xd2>
  if(off + n > ip->size)
    80004056:	00e7f463          	bgeu	a5,a4,8000405e <readi+0x3e>
    n = ip->size - off;
    8000405a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000405e:	0a0a8963          	beqz	s5,80004110 <readi+0xf0>
    80004062:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004064:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004068:	5c7d                	li	s8,-1
    8000406a:	a82d                	j	800040a4 <readi+0x84>
    8000406c:	020d1d93          	slli	s11,s10,0x20
    80004070:	020ddd93          	srli	s11,s11,0x20
    80004074:	05890613          	addi	a2,s2,88
    80004078:	86ee                	mv	a3,s11
    8000407a:	963a                	add	a2,a2,a4
    8000407c:	85d2                	mv	a1,s4
    8000407e:	855e                	mv	a0,s7
    80004080:	ffffe097          	auipc	ra,0xffffe
    80004084:	7c6080e7          	jalr	1990(ra) # 80002846 <either_copyout>
    80004088:	05850d63          	beq	a0,s8,800040e2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000408c:	854a                	mv	a0,s2
    8000408e:	fffff097          	auipc	ra,0xfffff
    80004092:	5f4080e7          	jalr	1524(ra) # 80003682 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004096:	013d09bb          	addw	s3,s10,s3
    8000409a:	009d04bb          	addw	s1,s10,s1
    8000409e:	9a6e                	add	s4,s4,s11
    800040a0:	0559f763          	bgeu	s3,s5,800040ee <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800040a4:	00a4d59b          	srliw	a1,s1,0xa
    800040a8:	855a                	mv	a0,s6
    800040aa:	00000097          	auipc	ra,0x0
    800040ae:	8a2080e7          	jalr	-1886(ra) # 8000394c <bmap>
    800040b2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800040b6:	cd85                	beqz	a1,800040ee <readi+0xce>
    bp = bread(ip->dev, addr);
    800040b8:	000b2503          	lw	a0,0(s6)
    800040bc:	fffff097          	auipc	ra,0xfffff
    800040c0:	496080e7          	jalr	1174(ra) # 80003552 <bread>
    800040c4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040c6:	3ff4f713          	andi	a4,s1,1023
    800040ca:	40ec87bb          	subw	a5,s9,a4
    800040ce:	413a86bb          	subw	a3,s5,s3
    800040d2:	8d3e                	mv	s10,a5
    800040d4:	2781                	sext.w	a5,a5
    800040d6:	0006861b          	sext.w	a2,a3
    800040da:	f8f679e3          	bgeu	a2,a5,8000406c <readi+0x4c>
    800040de:	8d36                	mv	s10,a3
    800040e0:	b771                	j	8000406c <readi+0x4c>
      brelse(bp);
    800040e2:	854a                	mv	a0,s2
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	59e080e7          	jalr	1438(ra) # 80003682 <brelse>
      tot = -1;
    800040ec:	59fd                	li	s3,-1
  }
  return tot;
    800040ee:	0009851b          	sext.w	a0,s3
}
    800040f2:	70a6                	ld	ra,104(sp)
    800040f4:	7406                	ld	s0,96(sp)
    800040f6:	64e6                	ld	s1,88(sp)
    800040f8:	6946                	ld	s2,80(sp)
    800040fa:	69a6                	ld	s3,72(sp)
    800040fc:	6a06                	ld	s4,64(sp)
    800040fe:	7ae2                	ld	s5,56(sp)
    80004100:	7b42                	ld	s6,48(sp)
    80004102:	7ba2                	ld	s7,40(sp)
    80004104:	7c02                	ld	s8,32(sp)
    80004106:	6ce2                	ld	s9,24(sp)
    80004108:	6d42                	ld	s10,16(sp)
    8000410a:	6da2                	ld	s11,8(sp)
    8000410c:	6165                	addi	sp,sp,112
    8000410e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004110:	89d6                	mv	s3,s5
    80004112:	bff1                	j	800040ee <readi+0xce>
    return 0;
    80004114:	4501                	li	a0,0
}
    80004116:	8082                	ret

0000000080004118 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004118:	457c                	lw	a5,76(a0)
    8000411a:	10d7e863          	bltu	a5,a3,8000422a <writei+0x112>
{
    8000411e:	7159                	addi	sp,sp,-112
    80004120:	f486                	sd	ra,104(sp)
    80004122:	f0a2                	sd	s0,96(sp)
    80004124:	eca6                	sd	s1,88(sp)
    80004126:	e8ca                	sd	s2,80(sp)
    80004128:	e4ce                	sd	s3,72(sp)
    8000412a:	e0d2                	sd	s4,64(sp)
    8000412c:	fc56                	sd	s5,56(sp)
    8000412e:	f85a                	sd	s6,48(sp)
    80004130:	f45e                	sd	s7,40(sp)
    80004132:	f062                	sd	s8,32(sp)
    80004134:	ec66                	sd	s9,24(sp)
    80004136:	e86a                	sd	s10,16(sp)
    80004138:	e46e                	sd	s11,8(sp)
    8000413a:	1880                	addi	s0,sp,112
    8000413c:	8aaa                	mv	s5,a0
    8000413e:	8bae                	mv	s7,a1
    80004140:	8a32                	mv	s4,a2
    80004142:	8936                	mv	s2,a3
    80004144:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004146:	00e687bb          	addw	a5,a3,a4
    8000414a:	0ed7e263          	bltu	a5,a3,8000422e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000414e:	00043737          	lui	a4,0x43
    80004152:	0ef76063          	bltu	a4,a5,80004232 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004156:	0c0b0863          	beqz	s6,80004226 <writei+0x10e>
    8000415a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000415c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004160:	5c7d                	li	s8,-1
    80004162:	a091                	j	800041a6 <writei+0x8e>
    80004164:	020d1d93          	slli	s11,s10,0x20
    80004168:	020ddd93          	srli	s11,s11,0x20
    8000416c:	05848513          	addi	a0,s1,88
    80004170:	86ee                	mv	a3,s11
    80004172:	8652                	mv	a2,s4
    80004174:	85de                	mv	a1,s7
    80004176:	953a                	add	a0,a0,a4
    80004178:	ffffe097          	auipc	ra,0xffffe
    8000417c:	724080e7          	jalr	1828(ra) # 8000289c <either_copyin>
    80004180:	07850263          	beq	a0,s8,800041e4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004184:	8526                	mv	a0,s1
    80004186:	00000097          	auipc	ra,0x0
    8000418a:	780080e7          	jalr	1920(ra) # 80004906 <log_write>
    brelse(bp);
    8000418e:	8526                	mv	a0,s1
    80004190:	fffff097          	auipc	ra,0xfffff
    80004194:	4f2080e7          	jalr	1266(ra) # 80003682 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004198:	013d09bb          	addw	s3,s10,s3
    8000419c:	012d093b          	addw	s2,s10,s2
    800041a0:	9a6e                	add	s4,s4,s11
    800041a2:	0569f663          	bgeu	s3,s6,800041ee <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800041a6:	00a9559b          	srliw	a1,s2,0xa
    800041aa:	8556                	mv	a0,s5
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	7a0080e7          	jalr	1952(ra) # 8000394c <bmap>
    800041b4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800041b8:	c99d                	beqz	a1,800041ee <writei+0xd6>
    bp = bread(ip->dev, addr);
    800041ba:	000aa503          	lw	a0,0(s5)
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	394080e7          	jalr	916(ra) # 80003552 <bread>
    800041c6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800041c8:	3ff97713          	andi	a4,s2,1023
    800041cc:	40ec87bb          	subw	a5,s9,a4
    800041d0:	413b06bb          	subw	a3,s6,s3
    800041d4:	8d3e                	mv	s10,a5
    800041d6:	2781                	sext.w	a5,a5
    800041d8:	0006861b          	sext.w	a2,a3
    800041dc:	f8f674e3          	bgeu	a2,a5,80004164 <writei+0x4c>
    800041e0:	8d36                	mv	s10,a3
    800041e2:	b749                	j	80004164 <writei+0x4c>
      brelse(bp);
    800041e4:	8526                	mv	a0,s1
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	49c080e7          	jalr	1180(ra) # 80003682 <brelse>
  }

  if(off > ip->size)
    800041ee:	04caa783          	lw	a5,76(s5)
    800041f2:	0127f463          	bgeu	a5,s2,800041fa <writei+0xe2>
    ip->size = off;
    800041f6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800041fa:	8556                	mv	a0,s5
    800041fc:	00000097          	auipc	ra,0x0
    80004200:	aa6080e7          	jalr	-1370(ra) # 80003ca2 <iupdate>

  return tot;
    80004204:	0009851b          	sext.w	a0,s3
}
    80004208:	70a6                	ld	ra,104(sp)
    8000420a:	7406                	ld	s0,96(sp)
    8000420c:	64e6                	ld	s1,88(sp)
    8000420e:	6946                	ld	s2,80(sp)
    80004210:	69a6                	ld	s3,72(sp)
    80004212:	6a06                	ld	s4,64(sp)
    80004214:	7ae2                	ld	s5,56(sp)
    80004216:	7b42                	ld	s6,48(sp)
    80004218:	7ba2                	ld	s7,40(sp)
    8000421a:	7c02                	ld	s8,32(sp)
    8000421c:	6ce2                	ld	s9,24(sp)
    8000421e:	6d42                	ld	s10,16(sp)
    80004220:	6da2                	ld	s11,8(sp)
    80004222:	6165                	addi	sp,sp,112
    80004224:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004226:	89da                	mv	s3,s6
    80004228:	bfc9                	j	800041fa <writei+0xe2>
    return -1;
    8000422a:	557d                	li	a0,-1
}
    8000422c:	8082                	ret
    return -1;
    8000422e:	557d                	li	a0,-1
    80004230:	bfe1                	j	80004208 <writei+0xf0>
    return -1;
    80004232:	557d                	li	a0,-1
    80004234:	bfd1                	j	80004208 <writei+0xf0>

0000000080004236 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004236:	1141                	addi	sp,sp,-16
    80004238:	e406                	sd	ra,8(sp)
    8000423a:	e022                	sd	s0,0(sp)
    8000423c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000423e:	4639                	li	a2,14
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	cb4080e7          	jalr	-844(ra) # 80000ef4 <strncmp>
}
    80004248:	60a2                	ld	ra,8(sp)
    8000424a:	6402                	ld	s0,0(sp)
    8000424c:	0141                	addi	sp,sp,16
    8000424e:	8082                	ret

0000000080004250 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004250:	7139                	addi	sp,sp,-64
    80004252:	fc06                	sd	ra,56(sp)
    80004254:	f822                	sd	s0,48(sp)
    80004256:	f426                	sd	s1,40(sp)
    80004258:	f04a                	sd	s2,32(sp)
    8000425a:	ec4e                	sd	s3,24(sp)
    8000425c:	e852                	sd	s4,16(sp)
    8000425e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004260:	04451703          	lh	a4,68(a0)
    80004264:	4785                	li	a5,1
    80004266:	00f71a63          	bne	a4,a5,8000427a <dirlookup+0x2a>
    8000426a:	892a                	mv	s2,a0
    8000426c:	89ae                	mv	s3,a1
    8000426e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004270:	457c                	lw	a5,76(a0)
    80004272:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004274:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004276:	e79d                	bnez	a5,800042a4 <dirlookup+0x54>
    80004278:	a8a5                	j	800042f0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000427a:	00004517          	auipc	a0,0x4
    8000427e:	60650513          	addi	a0,a0,1542 # 80008880 <syscall_list+0x208>
    80004282:	ffffc097          	auipc	ra,0xffffc
    80004286:	2c2080e7          	jalr	706(ra) # 80000544 <panic>
      panic("dirlookup read");
    8000428a:	00004517          	auipc	a0,0x4
    8000428e:	60e50513          	addi	a0,a0,1550 # 80008898 <syscall_list+0x220>
    80004292:	ffffc097          	auipc	ra,0xffffc
    80004296:	2b2080e7          	jalr	690(ra) # 80000544 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000429a:	24c1                	addiw	s1,s1,16
    8000429c:	04c92783          	lw	a5,76(s2)
    800042a0:	04f4f763          	bgeu	s1,a5,800042ee <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042a4:	4741                	li	a4,16
    800042a6:	86a6                	mv	a3,s1
    800042a8:	fc040613          	addi	a2,s0,-64
    800042ac:	4581                	li	a1,0
    800042ae:	854a                	mv	a0,s2
    800042b0:	00000097          	auipc	ra,0x0
    800042b4:	d70080e7          	jalr	-656(ra) # 80004020 <readi>
    800042b8:	47c1                	li	a5,16
    800042ba:	fcf518e3          	bne	a0,a5,8000428a <dirlookup+0x3a>
    if(de.inum == 0)
    800042be:	fc045783          	lhu	a5,-64(s0)
    800042c2:	dfe1                	beqz	a5,8000429a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800042c4:	fc240593          	addi	a1,s0,-62
    800042c8:	854e                	mv	a0,s3
    800042ca:	00000097          	auipc	ra,0x0
    800042ce:	f6c080e7          	jalr	-148(ra) # 80004236 <namecmp>
    800042d2:	f561                	bnez	a0,8000429a <dirlookup+0x4a>
      if(poff)
    800042d4:	000a0463          	beqz	s4,800042dc <dirlookup+0x8c>
        *poff = off;
    800042d8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800042dc:	fc045583          	lhu	a1,-64(s0)
    800042e0:	00092503          	lw	a0,0(s2)
    800042e4:	fffff097          	auipc	ra,0xfffff
    800042e8:	750080e7          	jalr	1872(ra) # 80003a34 <iget>
    800042ec:	a011                	j	800042f0 <dirlookup+0xa0>
  return 0;
    800042ee:	4501                	li	a0,0
}
    800042f0:	70e2                	ld	ra,56(sp)
    800042f2:	7442                	ld	s0,48(sp)
    800042f4:	74a2                	ld	s1,40(sp)
    800042f6:	7902                	ld	s2,32(sp)
    800042f8:	69e2                	ld	s3,24(sp)
    800042fa:	6a42                	ld	s4,16(sp)
    800042fc:	6121                	addi	sp,sp,64
    800042fe:	8082                	ret

0000000080004300 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004300:	711d                	addi	sp,sp,-96
    80004302:	ec86                	sd	ra,88(sp)
    80004304:	e8a2                	sd	s0,80(sp)
    80004306:	e4a6                	sd	s1,72(sp)
    80004308:	e0ca                	sd	s2,64(sp)
    8000430a:	fc4e                	sd	s3,56(sp)
    8000430c:	f852                	sd	s4,48(sp)
    8000430e:	f456                	sd	s5,40(sp)
    80004310:	f05a                	sd	s6,32(sp)
    80004312:	ec5e                	sd	s7,24(sp)
    80004314:	e862                	sd	s8,16(sp)
    80004316:	e466                	sd	s9,8(sp)
    80004318:	1080                	addi	s0,sp,96
    8000431a:	84aa                	mv	s1,a0
    8000431c:	8b2e                	mv	s6,a1
    8000431e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004320:	00054703          	lbu	a4,0(a0)
    80004324:	02f00793          	li	a5,47
    80004328:	02f70363          	beq	a4,a5,8000434e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000432c:	ffffe097          	auipc	ra,0xffffe
    80004330:	824080e7          	jalr	-2012(ra) # 80001b50 <myproc>
    80004334:	16053503          	ld	a0,352(a0)
    80004338:	00000097          	auipc	ra,0x0
    8000433c:	9f6080e7          	jalr	-1546(ra) # 80003d2e <idup>
    80004340:	89aa                	mv	s3,a0
  while(*path == '/')
    80004342:	02f00913          	li	s2,47
  len = path - s;
    80004346:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80004348:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000434a:	4c05                	li	s8,1
    8000434c:	a865                	j	80004404 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000434e:	4585                	li	a1,1
    80004350:	4505                	li	a0,1
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	6e2080e7          	jalr	1762(ra) # 80003a34 <iget>
    8000435a:	89aa                	mv	s3,a0
    8000435c:	b7dd                	j	80004342 <namex+0x42>
      iunlockput(ip);
    8000435e:	854e                	mv	a0,s3
    80004360:	00000097          	auipc	ra,0x0
    80004364:	c6e080e7          	jalr	-914(ra) # 80003fce <iunlockput>
      return 0;
    80004368:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000436a:	854e                	mv	a0,s3
    8000436c:	60e6                	ld	ra,88(sp)
    8000436e:	6446                	ld	s0,80(sp)
    80004370:	64a6                	ld	s1,72(sp)
    80004372:	6906                	ld	s2,64(sp)
    80004374:	79e2                	ld	s3,56(sp)
    80004376:	7a42                	ld	s4,48(sp)
    80004378:	7aa2                	ld	s5,40(sp)
    8000437a:	7b02                	ld	s6,32(sp)
    8000437c:	6be2                	ld	s7,24(sp)
    8000437e:	6c42                	ld	s8,16(sp)
    80004380:	6ca2                	ld	s9,8(sp)
    80004382:	6125                	addi	sp,sp,96
    80004384:	8082                	ret
      iunlock(ip);
    80004386:	854e                	mv	a0,s3
    80004388:	00000097          	auipc	ra,0x0
    8000438c:	aa6080e7          	jalr	-1370(ra) # 80003e2e <iunlock>
      return ip;
    80004390:	bfe9                	j	8000436a <namex+0x6a>
      iunlockput(ip);
    80004392:	854e                	mv	a0,s3
    80004394:	00000097          	auipc	ra,0x0
    80004398:	c3a080e7          	jalr	-966(ra) # 80003fce <iunlockput>
      return 0;
    8000439c:	89d2                	mv	s3,s4
    8000439e:	b7f1                	j	8000436a <namex+0x6a>
  len = path - s;
    800043a0:	40b48633          	sub	a2,s1,a1
    800043a4:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800043a8:	094cd463          	bge	s9,s4,80004430 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800043ac:	4639                	li	a2,14
    800043ae:	8556                	mv	a0,s5
    800043b0:	ffffd097          	auipc	ra,0xffffd
    800043b4:	acc080e7          	jalr	-1332(ra) # 80000e7c <memmove>
  while(*path == '/')
    800043b8:	0004c783          	lbu	a5,0(s1)
    800043bc:	01279763          	bne	a5,s2,800043ca <namex+0xca>
    path++;
    800043c0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043c2:	0004c783          	lbu	a5,0(s1)
    800043c6:	ff278de3          	beq	a5,s2,800043c0 <namex+0xc0>
    ilock(ip);
    800043ca:	854e                	mv	a0,s3
    800043cc:	00000097          	auipc	ra,0x0
    800043d0:	9a0080e7          	jalr	-1632(ra) # 80003d6c <ilock>
    if(ip->type != T_DIR){
    800043d4:	04499783          	lh	a5,68(s3)
    800043d8:	f98793e3          	bne	a5,s8,8000435e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800043dc:	000b0563          	beqz	s6,800043e6 <namex+0xe6>
    800043e0:	0004c783          	lbu	a5,0(s1)
    800043e4:	d3cd                	beqz	a5,80004386 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800043e6:	865e                	mv	a2,s7
    800043e8:	85d6                	mv	a1,s5
    800043ea:	854e                	mv	a0,s3
    800043ec:	00000097          	auipc	ra,0x0
    800043f0:	e64080e7          	jalr	-412(ra) # 80004250 <dirlookup>
    800043f4:	8a2a                	mv	s4,a0
    800043f6:	dd51                	beqz	a0,80004392 <namex+0x92>
    iunlockput(ip);
    800043f8:	854e                	mv	a0,s3
    800043fa:	00000097          	auipc	ra,0x0
    800043fe:	bd4080e7          	jalr	-1068(ra) # 80003fce <iunlockput>
    ip = next;
    80004402:	89d2                	mv	s3,s4
  while(*path == '/')
    80004404:	0004c783          	lbu	a5,0(s1)
    80004408:	05279763          	bne	a5,s2,80004456 <namex+0x156>
    path++;
    8000440c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000440e:	0004c783          	lbu	a5,0(s1)
    80004412:	ff278de3          	beq	a5,s2,8000440c <namex+0x10c>
  if(*path == 0)
    80004416:	c79d                	beqz	a5,80004444 <namex+0x144>
    path++;
    80004418:	85a6                	mv	a1,s1
  len = path - s;
    8000441a:	8a5e                	mv	s4,s7
    8000441c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000441e:	01278963          	beq	a5,s2,80004430 <namex+0x130>
    80004422:	dfbd                	beqz	a5,800043a0 <namex+0xa0>
    path++;
    80004424:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004426:	0004c783          	lbu	a5,0(s1)
    8000442a:	ff279ce3          	bne	a5,s2,80004422 <namex+0x122>
    8000442e:	bf8d                	j	800043a0 <namex+0xa0>
    memmove(name, s, len);
    80004430:	2601                	sext.w	a2,a2
    80004432:	8556                	mv	a0,s5
    80004434:	ffffd097          	auipc	ra,0xffffd
    80004438:	a48080e7          	jalr	-1464(ra) # 80000e7c <memmove>
    name[len] = 0;
    8000443c:	9a56                	add	s4,s4,s5
    8000443e:	000a0023          	sb	zero,0(s4)
    80004442:	bf9d                	j	800043b8 <namex+0xb8>
  if(nameiparent){
    80004444:	f20b03e3          	beqz	s6,8000436a <namex+0x6a>
    iput(ip);
    80004448:	854e                	mv	a0,s3
    8000444a:	00000097          	auipc	ra,0x0
    8000444e:	adc080e7          	jalr	-1316(ra) # 80003f26 <iput>
    return 0;
    80004452:	4981                	li	s3,0
    80004454:	bf19                	j	8000436a <namex+0x6a>
  if(*path == 0)
    80004456:	d7fd                	beqz	a5,80004444 <namex+0x144>
  while(*path != '/' && *path != 0)
    80004458:	0004c783          	lbu	a5,0(s1)
    8000445c:	85a6                	mv	a1,s1
    8000445e:	b7d1                	j	80004422 <namex+0x122>

0000000080004460 <dirlink>:
{
    80004460:	7139                	addi	sp,sp,-64
    80004462:	fc06                	sd	ra,56(sp)
    80004464:	f822                	sd	s0,48(sp)
    80004466:	f426                	sd	s1,40(sp)
    80004468:	f04a                	sd	s2,32(sp)
    8000446a:	ec4e                	sd	s3,24(sp)
    8000446c:	e852                	sd	s4,16(sp)
    8000446e:	0080                	addi	s0,sp,64
    80004470:	892a                	mv	s2,a0
    80004472:	8a2e                	mv	s4,a1
    80004474:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004476:	4601                	li	a2,0
    80004478:	00000097          	auipc	ra,0x0
    8000447c:	dd8080e7          	jalr	-552(ra) # 80004250 <dirlookup>
    80004480:	e93d                	bnez	a0,800044f6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004482:	04c92483          	lw	s1,76(s2)
    80004486:	c49d                	beqz	s1,800044b4 <dirlink+0x54>
    80004488:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000448a:	4741                	li	a4,16
    8000448c:	86a6                	mv	a3,s1
    8000448e:	fc040613          	addi	a2,s0,-64
    80004492:	4581                	li	a1,0
    80004494:	854a                	mv	a0,s2
    80004496:	00000097          	auipc	ra,0x0
    8000449a:	b8a080e7          	jalr	-1142(ra) # 80004020 <readi>
    8000449e:	47c1                	li	a5,16
    800044a0:	06f51163          	bne	a0,a5,80004502 <dirlink+0xa2>
    if(de.inum == 0)
    800044a4:	fc045783          	lhu	a5,-64(s0)
    800044a8:	c791                	beqz	a5,800044b4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044aa:	24c1                	addiw	s1,s1,16
    800044ac:	04c92783          	lw	a5,76(s2)
    800044b0:	fcf4ede3          	bltu	s1,a5,8000448a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800044b4:	4639                	li	a2,14
    800044b6:	85d2                	mv	a1,s4
    800044b8:	fc240513          	addi	a0,s0,-62
    800044bc:	ffffd097          	auipc	ra,0xffffd
    800044c0:	a74080e7          	jalr	-1420(ra) # 80000f30 <strncpy>
  de.inum = inum;
    800044c4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044c8:	4741                	li	a4,16
    800044ca:	86a6                	mv	a3,s1
    800044cc:	fc040613          	addi	a2,s0,-64
    800044d0:	4581                	li	a1,0
    800044d2:	854a                	mv	a0,s2
    800044d4:	00000097          	auipc	ra,0x0
    800044d8:	c44080e7          	jalr	-956(ra) # 80004118 <writei>
    800044dc:	1541                	addi	a0,a0,-16
    800044de:	00a03533          	snez	a0,a0
    800044e2:	40a00533          	neg	a0,a0
}
    800044e6:	70e2                	ld	ra,56(sp)
    800044e8:	7442                	ld	s0,48(sp)
    800044ea:	74a2                	ld	s1,40(sp)
    800044ec:	7902                	ld	s2,32(sp)
    800044ee:	69e2                	ld	s3,24(sp)
    800044f0:	6a42                	ld	s4,16(sp)
    800044f2:	6121                	addi	sp,sp,64
    800044f4:	8082                	ret
    iput(ip);
    800044f6:	00000097          	auipc	ra,0x0
    800044fa:	a30080e7          	jalr	-1488(ra) # 80003f26 <iput>
    return -1;
    800044fe:	557d                	li	a0,-1
    80004500:	b7dd                	j	800044e6 <dirlink+0x86>
      panic("dirlink read");
    80004502:	00004517          	auipc	a0,0x4
    80004506:	3a650513          	addi	a0,a0,934 # 800088a8 <syscall_list+0x230>
    8000450a:	ffffc097          	auipc	ra,0xffffc
    8000450e:	03a080e7          	jalr	58(ra) # 80000544 <panic>

0000000080004512 <namei>:

struct inode*
namei(char *path)
{
    80004512:	1101                	addi	sp,sp,-32
    80004514:	ec06                	sd	ra,24(sp)
    80004516:	e822                	sd	s0,16(sp)
    80004518:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000451a:	fe040613          	addi	a2,s0,-32
    8000451e:	4581                	li	a1,0
    80004520:	00000097          	auipc	ra,0x0
    80004524:	de0080e7          	jalr	-544(ra) # 80004300 <namex>
}
    80004528:	60e2                	ld	ra,24(sp)
    8000452a:	6442                	ld	s0,16(sp)
    8000452c:	6105                	addi	sp,sp,32
    8000452e:	8082                	ret

0000000080004530 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004530:	1141                	addi	sp,sp,-16
    80004532:	e406                	sd	ra,8(sp)
    80004534:	e022                	sd	s0,0(sp)
    80004536:	0800                	addi	s0,sp,16
    80004538:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000453a:	4585                	li	a1,1
    8000453c:	00000097          	auipc	ra,0x0
    80004540:	dc4080e7          	jalr	-572(ra) # 80004300 <namex>
}
    80004544:	60a2                	ld	ra,8(sp)
    80004546:	6402                	ld	s0,0(sp)
    80004548:	0141                	addi	sp,sp,16
    8000454a:	8082                	ret

000000008000454c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000454c:	1101                	addi	sp,sp,-32
    8000454e:	ec06                	sd	ra,24(sp)
    80004550:	e822                	sd	s0,16(sp)
    80004552:	e426                	sd	s1,8(sp)
    80004554:	e04a                	sd	s2,0(sp)
    80004556:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004558:	00243917          	auipc	s2,0x243
    8000455c:	29090913          	addi	s2,s2,656 # 802477e8 <log>
    80004560:	01892583          	lw	a1,24(s2)
    80004564:	02892503          	lw	a0,40(s2)
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	fea080e7          	jalr	-22(ra) # 80003552 <bread>
    80004570:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004572:	02c92683          	lw	a3,44(s2)
    80004576:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004578:	02d05763          	blez	a3,800045a6 <write_head+0x5a>
    8000457c:	00243797          	auipc	a5,0x243
    80004580:	29c78793          	addi	a5,a5,668 # 80247818 <log+0x30>
    80004584:	05c50713          	addi	a4,a0,92
    80004588:	36fd                	addiw	a3,a3,-1
    8000458a:	1682                	slli	a3,a3,0x20
    8000458c:	9281                	srli	a3,a3,0x20
    8000458e:	068a                	slli	a3,a3,0x2
    80004590:	00243617          	auipc	a2,0x243
    80004594:	28c60613          	addi	a2,a2,652 # 8024781c <log+0x34>
    80004598:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000459a:	4390                	lw	a2,0(a5)
    8000459c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000459e:	0791                	addi	a5,a5,4
    800045a0:	0711                	addi	a4,a4,4
    800045a2:	fed79ce3          	bne	a5,a3,8000459a <write_head+0x4e>
  }
  bwrite(buf);
    800045a6:	8526                	mv	a0,s1
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	09c080e7          	jalr	156(ra) # 80003644 <bwrite>
  brelse(buf);
    800045b0:	8526                	mv	a0,s1
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	0d0080e7          	jalr	208(ra) # 80003682 <brelse>
}
    800045ba:	60e2                	ld	ra,24(sp)
    800045bc:	6442                	ld	s0,16(sp)
    800045be:	64a2                	ld	s1,8(sp)
    800045c0:	6902                	ld	s2,0(sp)
    800045c2:	6105                	addi	sp,sp,32
    800045c4:	8082                	ret

00000000800045c6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800045c6:	00243797          	auipc	a5,0x243
    800045ca:	24e7a783          	lw	a5,590(a5) # 80247814 <log+0x2c>
    800045ce:	0af05d63          	blez	a5,80004688 <install_trans+0xc2>
{
    800045d2:	7139                	addi	sp,sp,-64
    800045d4:	fc06                	sd	ra,56(sp)
    800045d6:	f822                	sd	s0,48(sp)
    800045d8:	f426                	sd	s1,40(sp)
    800045da:	f04a                	sd	s2,32(sp)
    800045dc:	ec4e                	sd	s3,24(sp)
    800045de:	e852                	sd	s4,16(sp)
    800045e0:	e456                	sd	s5,8(sp)
    800045e2:	e05a                	sd	s6,0(sp)
    800045e4:	0080                	addi	s0,sp,64
    800045e6:	8b2a                	mv	s6,a0
    800045e8:	00243a97          	auipc	s5,0x243
    800045ec:	230a8a93          	addi	s5,s5,560 # 80247818 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045f0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045f2:	00243997          	auipc	s3,0x243
    800045f6:	1f698993          	addi	s3,s3,502 # 802477e8 <log>
    800045fa:	a035                	j	80004626 <install_trans+0x60>
      bunpin(dbuf);
    800045fc:	8526                	mv	a0,s1
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	15e080e7          	jalr	350(ra) # 8000375c <bunpin>
    brelse(lbuf);
    80004606:	854a                	mv	a0,s2
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	07a080e7          	jalr	122(ra) # 80003682 <brelse>
    brelse(dbuf);
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	070080e7          	jalr	112(ra) # 80003682 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000461a:	2a05                	addiw	s4,s4,1
    8000461c:	0a91                	addi	s5,s5,4
    8000461e:	02c9a783          	lw	a5,44(s3)
    80004622:	04fa5963          	bge	s4,a5,80004674 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004626:	0189a583          	lw	a1,24(s3)
    8000462a:	014585bb          	addw	a1,a1,s4
    8000462e:	2585                	addiw	a1,a1,1
    80004630:	0289a503          	lw	a0,40(s3)
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	f1e080e7          	jalr	-226(ra) # 80003552 <bread>
    8000463c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000463e:	000aa583          	lw	a1,0(s5)
    80004642:	0289a503          	lw	a0,40(s3)
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	f0c080e7          	jalr	-244(ra) # 80003552 <bread>
    8000464e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004650:	40000613          	li	a2,1024
    80004654:	05890593          	addi	a1,s2,88
    80004658:	05850513          	addi	a0,a0,88
    8000465c:	ffffd097          	auipc	ra,0xffffd
    80004660:	820080e7          	jalr	-2016(ra) # 80000e7c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004664:	8526                	mv	a0,s1
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	fde080e7          	jalr	-34(ra) # 80003644 <bwrite>
    if(recovering == 0)
    8000466e:	f80b1ce3          	bnez	s6,80004606 <install_trans+0x40>
    80004672:	b769                	j	800045fc <install_trans+0x36>
}
    80004674:	70e2                	ld	ra,56(sp)
    80004676:	7442                	ld	s0,48(sp)
    80004678:	74a2                	ld	s1,40(sp)
    8000467a:	7902                	ld	s2,32(sp)
    8000467c:	69e2                	ld	s3,24(sp)
    8000467e:	6a42                	ld	s4,16(sp)
    80004680:	6aa2                	ld	s5,8(sp)
    80004682:	6b02                	ld	s6,0(sp)
    80004684:	6121                	addi	sp,sp,64
    80004686:	8082                	ret
    80004688:	8082                	ret

000000008000468a <initlog>:
{
    8000468a:	7179                	addi	sp,sp,-48
    8000468c:	f406                	sd	ra,40(sp)
    8000468e:	f022                	sd	s0,32(sp)
    80004690:	ec26                	sd	s1,24(sp)
    80004692:	e84a                	sd	s2,16(sp)
    80004694:	e44e                	sd	s3,8(sp)
    80004696:	1800                	addi	s0,sp,48
    80004698:	892a                	mv	s2,a0
    8000469a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000469c:	00243497          	auipc	s1,0x243
    800046a0:	14c48493          	addi	s1,s1,332 # 802477e8 <log>
    800046a4:	00004597          	auipc	a1,0x4
    800046a8:	21458593          	addi	a1,a1,532 # 800088b8 <syscall_list+0x240>
    800046ac:	8526                	mv	a0,s1
    800046ae:	ffffc097          	auipc	ra,0xffffc
    800046b2:	5e2080e7          	jalr	1506(ra) # 80000c90 <initlock>
  log.start = sb->logstart;
    800046b6:	0149a583          	lw	a1,20(s3)
    800046ba:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800046bc:	0109a783          	lw	a5,16(s3)
    800046c0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800046c2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800046c6:	854a                	mv	a0,s2
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	e8a080e7          	jalr	-374(ra) # 80003552 <bread>
  log.lh.n = lh->n;
    800046d0:	4d3c                	lw	a5,88(a0)
    800046d2:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800046d4:	02f05563          	blez	a5,800046fe <initlog+0x74>
    800046d8:	05c50713          	addi	a4,a0,92
    800046dc:	00243697          	auipc	a3,0x243
    800046e0:	13c68693          	addi	a3,a3,316 # 80247818 <log+0x30>
    800046e4:	37fd                	addiw	a5,a5,-1
    800046e6:	1782                	slli	a5,a5,0x20
    800046e8:	9381                	srli	a5,a5,0x20
    800046ea:	078a                	slli	a5,a5,0x2
    800046ec:	06050613          	addi	a2,a0,96
    800046f0:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800046f2:	4310                	lw	a2,0(a4)
    800046f4:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800046f6:	0711                	addi	a4,a4,4
    800046f8:	0691                	addi	a3,a3,4
    800046fa:	fef71ce3          	bne	a4,a5,800046f2 <initlog+0x68>
  brelse(buf);
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	f84080e7          	jalr	-124(ra) # 80003682 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004706:	4505                	li	a0,1
    80004708:	00000097          	auipc	ra,0x0
    8000470c:	ebe080e7          	jalr	-322(ra) # 800045c6 <install_trans>
  log.lh.n = 0;
    80004710:	00243797          	auipc	a5,0x243
    80004714:	1007a223          	sw	zero,260(a5) # 80247814 <log+0x2c>
  write_head(); // clear the log
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	e34080e7          	jalr	-460(ra) # 8000454c <write_head>
}
    80004720:	70a2                	ld	ra,40(sp)
    80004722:	7402                	ld	s0,32(sp)
    80004724:	64e2                	ld	s1,24(sp)
    80004726:	6942                	ld	s2,16(sp)
    80004728:	69a2                	ld	s3,8(sp)
    8000472a:	6145                	addi	sp,sp,48
    8000472c:	8082                	ret

000000008000472e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000472e:	1101                	addi	sp,sp,-32
    80004730:	ec06                	sd	ra,24(sp)
    80004732:	e822                	sd	s0,16(sp)
    80004734:	e426                	sd	s1,8(sp)
    80004736:	e04a                	sd	s2,0(sp)
    80004738:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000473a:	00243517          	auipc	a0,0x243
    8000473e:	0ae50513          	addi	a0,a0,174 # 802477e8 <log>
    80004742:	ffffc097          	auipc	ra,0xffffc
    80004746:	5de080e7          	jalr	1502(ra) # 80000d20 <acquire>
  while(1){
    if(log.committing){
    8000474a:	00243497          	auipc	s1,0x243
    8000474e:	09e48493          	addi	s1,s1,158 # 802477e8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004752:	4979                	li	s2,30
    80004754:	a039                	j	80004762 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004756:	85a6                	mv	a1,s1
    80004758:	8526                	mv	a0,s1
    8000475a:	ffffe097          	auipc	ra,0xffffe
    8000475e:	d3e080e7          	jalr	-706(ra) # 80002498 <sleep>
    if(log.committing){
    80004762:	50dc                	lw	a5,36(s1)
    80004764:	fbed                	bnez	a5,80004756 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004766:	509c                	lw	a5,32(s1)
    80004768:	0017871b          	addiw	a4,a5,1
    8000476c:	0007069b          	sext.w	a3,a4
    80004770:	0027179b          	slliw	a5,a4,0x2
    80004774:	9fb9                	addw	a5,a5,a4
    80004776:	0017979b          	slliw	a5,a5,0x1
    8000477a:	54d8                	lw	a4,44(s1)
    8000477c:	9fb9                	addw	a5,a5,a4
    8000477e:	00f95963          	bge	s2,a5,80004790 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004782:	85a6                	mv	a1,s1
    80004784:	8526                	mv	a0,s1
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	d12080e7          	jalr	-750(ra) # 80002498 <sleep>
    8000478e:	bfd1                	j	80004762 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004790:	00243517          	auipc	a0,0x243
    80004794:	05850513          	addi	a0,a0,88 # 802477e8 <log>
    80004798:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000479a:	ffffc097          	auipc	ra,0xffffc
    8000479e:	63a080e7          	jalr	1594(ra) # 80000dd4 <release>
      break;
    }
  }
}
    800047a2:	60e2                	ld	ra,24(sp)
    800047a4:	6442                	ld	s0,16(sp)
    800047a6:	64a2                	ld	s1,8(sp)
    800047a8:	6902                	ld	s2,0(sp)
    800047aa:	6105                	addi	sp,sp,32
    800047ac:	8082                	ret

00000000800047ae <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800047ae:	7139                	addi	sp,sp,-64
    800047b0:	fc06                	sd	ra,56(sp)
    800047b2:	f822                	sd	s0,48(sp)
    800047b4:	f426                	sd	s1,40(sp)
    800047b6:	f04a                	sd	s2,32(sp)
    800047b8:	ec4e                	sd	s3,24(sp)
    800047ba:	e852                	sd	s4,16(sp)
    800047bc:	e456                	sd	s5,8(sp)
    800047be:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800047c0:	00243497          	auipc	s1,0x243
    800047c4:	02848493          	addi	s1,s1,40 # 802477e8 <log>
    800047c8:	8526                	mv	a0,s1
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	556080e7          	jalr	1366(ra) # 80000d20 <acquire>
  log.outstanding -= 1;
    800047d2:	509c                	lw	a5,32(s1)
    800047d4:	37fd                	addiw	a5,a5,-1
    800047d6:	0007891b          	sext.w	s2,a5
    800047da:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800047dc:	50dc                	lw	a5,36(s1)
    800047de:	efb9                	bnez	a5,8000483c <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800047e0:	06091663          	bnez	s2,8000484c <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800047e4:	00243497          	auipc	s1,0x243
    800047e8:	00448493          	addi	s1,s1,4 # 802477e8 <log>
    800047ec:	4785                	li	a5,1
    800047ee:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800047f0:	8526                	mv	a0,s1
    800047f2:	ffffc097          	auipc	ra,0xffffc
    800047f6:	5e2080e7          	jalr	1506(ra) # 80000dd4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800047fa:	54dc                	lw	a5,44(s1)
    800047fc:	06f04763          	bgtz	a5,8000486a <end_op+0xbc>
    acquire(&log.lock);
    80004800:	00243497          	auipc	s1,0x243
    80004804:	fe848493          	addi	s1,s1,-24 # 802477e8 <log>
    80004808:	8526                	mv	a0,s1
    8000480a:	ffffc097          	auipc	ra,0xffffc
    8000480e:	516080e7          	jalr	1302(ra) # 80000d20 <acquire>
    log.committing = 0;
    80004812:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004816:	8526                	mv	a0,s1
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	8fe080e7          	jalr	-1794(ra) # 80002116 <wakeup>
    release(&log.lock);
    80004820:	8526                	mv	a0,s1
    80004822:	ffffc097          	auipc	ra,0xffffc
    80004826:	5b2080e7          	jalr	1458(ra) # 80000dd4 <release>
}
    8000482a:	70e2                	ld	ra,56(sp)
    8000482c:	7442                	ld	s0,48(sp)
    8000482e:	74a2                	ld	s1,40(sp)
    80004830:	7902                	ld	s2,32(sp)
    80004832:	69e2                	ld	s3,24(sp)
    80004834:	6a42                	ld	s4,16(sp)
    80004836:	6aa2                	ld	s5,8(sp)
    80004838:	6121                	addi	sp,sp,64
    8000483a:	8082                	ret
    panic("log.committing");
    8000483c:	00004517          	auipc	a0,0x4
    80004840:	08450513          	addi	a0,a0,132 # 800088c0 <syscall_list+0x248>
    80004844:	ffffc097          	auipc	ra,0xffffc
    80004848:	d00080e7          	jalr	-768(ra) # 80000544 <panic>
    wakeup(&log);
    8000484c:	00243497          	auipc	s1,0x243
    80004850:	f9c48493          	addi	s1,s1,-100 # 802477e8 <log>
    80004854:	8526                	mv	a0,s1
    80004856:	ffffe097          	auipc	ra,0xffffe
    8000485a:	8c0080e7          	jalr	-1856(ra) # 80002116 <wakeup>
  release(&log.lock);
    8000485e:	8526                	mv	a0,s1
    80004860:	ffffc097          	auipc	ra,0xffffc
    80004864:	574080e7          	jalr	1396(ra) # 80000dd4 <release>
  if(do_commit){
    80004868:	b7c9                	j	8000482a <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000486a:	00243a97          	auipc	s5,0x243
    8000486e:	faea8a93          	addi	s5,s5,-82 # 80247818 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004872:	00243a17          	auipc	s4,0x243
    80004876:	f76a0a13          	addi	s4,s4,-138 # 802477e8 <log>
    8000487a:	018a2583          	lw	a1,24(s4)
    8000487e:	012585bb          	addw	a1,a1,s2
    80004882:	2585                	addiw	a1,a1,1
    80004884:	028a2503          	lw	a0,40(s4)
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	cca080e7          	jalr	-822(ra) # 80003552 <bread>
    80004890:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004892:	000aa583          	lw	a1,0(s5)
    80004896:	028a2503          	lw	a0,40(s4)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	cb8080e7          	jalr	-840(ra) # 80003552 <bread>
    800048a2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800048a4:	40000613          	li	a2,1024
    800048a8:	05850593          	addi	a1,a0,88
    800048ac:	05848513          	addi	a0,s1,88
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	5cc080e7          	jalr	1484(ra) # 80000e7c <memmove>
    bwrite(to);  // write the log
    800048b8:	8526                	mv	a0,s1
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	d8a080e7          	jalr	-630(ra) # 80003644 <bwrite>
    brelse(from);
    800048c2:	854e                	mv	a0,s3
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	dbe080e7          	jalr	-578(ra) # 80003682 <brelse>
    brelse(to);
    800048cc:	8526                	mv	a0,s1
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	db4080e7          	jalr	-588(ra) # 80003682 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800048d6:	2905                	addiw	s2,s2,1
    800048d8:	0a91                	addi	s5,s5,4
    800048da:	02ca2783          	lw	a5,44(s4)
    800048de:	f8f94ee3          	blt	s2,a5,8000487a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800048e2:	00000097          	auipc	ra,0x0
    800048e6:	c6a080e7          	jalr	-918(ra) # 8000454c <write_head>
    install_trans(0); // Now install writes to home locations
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	cda080e7          	jalr	-806(ra) # 800045c6 <install_trans>
    log.lh.n = 0;
    800048f4:	00243797          	auipc	a5,0x243
    800048f8:	f207a023          	sw	zero,-224(a5) # 80247814 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800048fc:	00000097          	auipc	ra,0x0
    80004900:	c50080e7          	jalr	-944(ra) # 8000454c <write_head>
    80004904:	bdf5                	j	80004800 <end_op+0x52>

0000000080004906 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004906:	1101                	addi	sp,sp,-32
    80004908:	ec06                	sd	ra,24(sp)
    8000490a:	e822                	sd	s0,16(sp)
    8000490c:	e426                	sd	s1,8(sp)
    8000490e:	e04a                	sd	s2,0(sp)
    80004910:	1000                	addi	s0,sp,32
    80004912:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004914:	00243917          	auipc	s2,0x243
    80004918:	ed490913          	addi	s2,s2,-300 # 802477e8 <log>
    8000491c:	854a                	mv	a0,s2
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	402080e7          	jalr	1026(ra) # 80000d20 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004926:	02c92603          	lw	a2,44(s2)
    8000492a:	47f5                	li	a5,29
    8000492c:	06c7c563          	blt	a5,a2,80004996 <log_write+0x90>
    80004930:	00243797          	auipc	a5,0x243
    80004934:	ed47a783          	lw	a5,-300(a5) # 80247804 <log+0x1c>
    80004938:	37fd                	addiw	a5,a5,-1
    8000493a:	04f65e63          	bge	a2,a5,80004996 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000493e:	00243797          	auipc	a5,0x243
    80004942:	eca7a783          	lw	a5,-310(a5) # 80247808 <log+0x20>
    80004946:	06f05063          	blez	a5,800049a6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000494a:	4781                	li	a5,0
    8000494c:	06c05563          	blez	a2,800049b6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004950:	44cc                	lw	a1,12(s1)
    80004952:	00243717          	auipc	a4,0x243
    80004956:	ec670713          	addi	a4,a4,-314 # 80247818 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000495a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000495c:	4314                	lw	a3,0(a4)
    8000495e:	04b68c63          	beq	a3,a1,800049b6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004962:	2785                	addiw	a5,a5,1
    80004964:	0711                	addi	a4,a4,4
    80004966:	fef61be3          	bne	a2,a5,8000495c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000496a:	0621                	addi	a2,a2,8
    8000496c:	060a                	slli	a2,a2,0x2
    8000496e:	00243797          	auipc	a5,0x243
    80004972:	e7a78793          	addi	a5,a5,-390 # 802477e8 <log>
    80004976:	963e                	add	a2,a2,a5
    80004978:	44dc                	lw	a5,12(s1)
    8000497a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000497c:	8526                	mv	a0,s1
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	da2080e7          	jalr	-606(ra) # 80003720 <bpin>
    log.lh.n++;
    80004986:	00243717          	auipc	a4,0x243
    8000498a:	e6270713          	addi	a4,a4,-414 # 802477e8 <log>
    8000498e:	575c                	lw	a5,44(a4)
    80004990:	2785                	addiw	a5,a5,1
    80004992:	d75c                	sw	a5,44(a4)
    80004994:	a835                	j	800049d0 <log_write+0xca>
    panic("too big a transaction");
    80004996:	00004517          	auipc	a0,0x4
    8000499a:	f3a50513          	addi	a0,a0,-198 # 800088d0 <syscall_list+0x258>
    8000499e:	ffffc097          	auipc	ra,0xffffc
    800049a2:	ba6080e7          	jalr	-1114(ra) # 80000544 <panic>
    panic("log_write outside of trans");
    800049a6:	00004517          	auipc	a0,0x4
    800049aa:	f4250513          	addi	a0,a0,-190 # 800088e8 <syscall_list+0x270>
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	b96080e7          	jalr	-1130(ra) # 80000544 <panic>
  log.lh.block[i] = b->blockno;
    800049b6:	00878713          	addi	a4,a5,8
    800049ba:	00271693          	slli	a3,a4,0x2
    800049be:	00243717          	auipc	a4,0x243
    800049c2:	e2a70713          	addi	a4,a4,-470 # 802477e8 <log>
    800049c6:	9736                	add	a4,a4,a3
    800049c8:	44d4                	lw	a3,12(s1)
    800049ca:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800049cc:	faf608e3          	beq	a2,a5,8000497c <log_write+0x76>
  }
  release(&log.lock);
    800049d0:	00243517          	auipc	a0,0x243
    800049d4:	e1850513          	addi	a0,a0,-488 # 802477e8 <log>
    800049d8:	ffffc097          	auipc	ra,0xffffc
    800049dc:	3fc080e7          	jalr	1020(ra) # 80000dd4 <release>
}
    800049e0:	60e2                	ld	ra,24(sp)
    800049e2:	6442                	ld	s0,16(sp)
    800049e4:	64a2                	ld	s1,8(sp)
    800049e6:	6902                	ld	s2,0(sp)
    800049e8:	6105                	addi	sp,sp,32
    800049ea:	8082                	ret

00000000800049ec <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800049ec:	1101                	addi	sp,sp,-32
    800049ee:	ec06                	sd	ra,24(sp)
    800049f0:	e822                	sd	s0,16(sp)
    800049f2:	e426                	sd	s1,8(sp)
    800049f4:	e04a                	sd	s2,0(sp)
    800049f6:	1000                	addi	s0,sp,32
    800049f8:	84aa                	mv	s1,a0
    800049fa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800049fc:	00004597          	auipc	a1,0x4
    80004a00:	f0c58593          	addi	a1,a1,-244 # 80008908 <syscall_list+0x290>
    80004a04:	0521                	addi	a0,a0,8
    80004a06:	ffffc097          	auipc	ra,0xffffc
    80004a0a:	28a080e7          	jalr	650(ra) # 80000c90 <initlock>
  lk->name = name;
    80004a0e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004a12:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a16:	0204a423          	sw	zero,40(s1)
}
    80004a1a:	60e2                	ld	ra,24(sp)
    80004a1c:	6442                	ld	s0,16(sp)
    80004a1e:	64a2                	ld	s1,8(sp)
    80004a20:	6902                	ld	s2,0(sp)
    80004a22:	6105                	addi	sp,sp,32
    80004a24:	8082                	ret

0000000080004a26 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004a26:	1101                	addi	sp,sp,-32
    80004a28:	ec06                	sd	ra,24(sp)
    80004a2a:	e822                	sd	s0,16(sp)
    80004a2c:	e426                	sd	s1,8(sp)
    80004a2e:	e04a                	sd	s2,0(sp)
    80004a30:	1000                	addi	s0,sp,32
    80004a32:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a34:	00850913          	addi	s2,a0,8
    80004a38:	854a                	mv	a0,s2
    80004a3a:	ffffc097          	auipc	ra,0xffffc
    80004a3e:	2e6080e7          	jalr	742(ra) # 80000d20 <acquire>
  while (lk->locked) {
    80004a42:	409c                	lw	a5,0(s1)
    80004a44:	cb89                	beqz	a5,80004a56 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004a46:	85ca                	mv	a1,s2
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	a4e080e7          	jalr	-1458(ra) # 80002498 <sleep>
  while (lk->locked) {
    80004a52:	409c                	lw	a5,0(s1)
    80004a54:	fbed                	bnez	a5,80004a46 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004a56:	4785                	li	a5,1
    80004a58:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004a5a:	ffffd097          	auipc	ra,0xffffd
    80004a5e:	0f6080e7          	jalr	246(ra) # 80001b50 <myproc>
    80004a62:	591c                	lw	a5,48(a0)
    80004a64:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004a66:	854a                	mv	a0,s2
    80004a68:	ffffc097          	auipc	ra,0xffffc
    80004a6c:	36c080e7          	jalr	876(ra) # 80000dd4 <release>
}
    80004a70:	60e2                	ld	ra,24(sp)
    80004a72:	6442                	ld	s0,16(sp)
    80004a74:	64a2                	ld	s1,8(sp)
    80004a76:	6902                	ld	s2,0(sp)
    80004a78:	6105                	addi	sp,sp,32
    80004a7a:	8082                	ret

0000000080004a7c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a7c:	1101                	addi	sp,sp,-32
    80004a7e:	ec06                	sd	ra,24(sp)
    80004a80:	e822                	sd	s0,16(sp)
    80004a82:	e426                	sd	s1,8(sp)
    80004a84:	e04a                	sd	s2,0(sp)
    80004a86:	1000                	addi	s0,sp,32
    80004a88:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a8a:	00850913          	addi	s2,a0,8
    80004a8e:	854a                	mv	a0,s2
    80004a90:	ffffc097          	auipc	ra,0xffffc
    80004a94:	290080e7          	jalr	656(ra) # 80000d20 <acquire>
  lk->locked = 0;
    80004a98:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a9c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	674080e7          	jalr	1652(ra) # 80002116 <wakeup>
  release(&lk->lk);
    80004aaa:	854a                	mv	a0,s2
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	328080e7          	jalr	808(ra) # 80000dd4 <release>
}
    80004ab4:	60e2                	ld	ra,24(sp)
    80004ab6:	6442                	ld	s0,16(sp)
    80004ab8:	64a2                	ld	s1,8(sp)
    80004aba:	6902                	ld	s2,0(sp)
    80004abc:	6105                	addi	sp,sp,32
    80004abe:	8082                	ret

0000000080004ac0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004ac0:	7179                	addi	sp,sp,-48
    80004ac2:	f406                	sd	ra,40(sp)
    80004ac4:	f022                	sd	s0,32(sp)
    80004ac6:	ec26                	sd	s1,24(sp)
    80004ac8:	e84a                	sd	s2,16(sp)
    80004aca:	e44e                	sd	s3,8(sp)
    80004acc:	1800                	addi	s0,sp,48
    80004ace:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004ad0:	00850913          	addi	s2,a0,8
    80004ad4:	854a                	mv	a0,s2
    80004ad6:	ffffc097          	auipc	ra,0xffffc
    80004ada:	24a080e7          	jalr	586(ra) # 80000d20 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ade:	409c                	lw	a5,0(s1)
    80004ae0:	ef99                	bnez	a5,80004afe <holdingsleep+0x3e>
    80004ae2:	4481                	li	s1,0
  release(&lk->lk);
    80004ae4:	854a                	mv	a0,s2
    80004ae6:	ffffc097          	auipc	ra,0xffffc
    80004aea:	2ee080e7          	jalr	750(ra) # 80000dd4 <release>
  return r;
}
    80004aee:	8526                	mv	a0,s1
    80004af0:	70a2                	ld	ra,40(sp)
    80004af2:	7402                	ld	s0,32(sp)
    80004af4:	64e2                	ld	s1,24(sp)
    80004af6:	6942                	ld	s2,16(sp)
    80004af8:	69a2                	ld	s3,8(sp)
    80004afa:	6145                	addi	sp,sp,48
    80004afc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004afe:	0284a983          	lw	s3,40(s1)
    80004b02:	ffffd097          	auipc	ra,0xffffd
    80004b06:	04e080e7          	jalr	78(ra) # 80001b50 <myproc>
    80004b0a:	5904                	lw	s1,48(a0)
    80004b0c:	413484b3          	sub	s1,s1,s3
    80004b10:	0014b493          	seqz	s1,s1
    80004b14:	bfc1                	j	80004ae4 <holdingsleep+0x24>

0000000080004b16 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004b16:	1141                	addi	sp,sp,-16
    80004b18:	e406                	sd	ra,8(sp)
    80004b1a:	e022                	sd	s0,0(sp)
    80004b1c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004b1e:	00004597          	auipc	a1,0x4
    80004b22:	dfa58593          	addi	a1,a1,-518 # 80008918 <syscall_list+0x2a0>
    80004b26:	00243517          	auipc	a0,0x243
    80004b2a:	e0a50513          	addi	a0,a0,-502 # 80247930 <ftable>
    80004b2e:	ffffc097          	auipc	ra,0xffffc
    80004b32:	162080e7          	jalr	354(ra) # 80000c90 <initlock>
}
    80004b36:	60a2                	ld	ra,8(sp)
    80004b38:	6402                	ld	s0,0(sp)
    80004b3a:	0141                	addi	sp,sp,16
    80004b3c:	8082                	ret

0000000080004b3e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004b3e:	1101                	addi	sp,sp,-32
    80004b40:	ec06                	sd	ra,24(sp)
    80004b42:	e822                	sd	s0,16(sp)
    80004b44:	e426                	sd	s1,8(sp)
    80004b46:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004b48:	00243517          	auipc	a0,0x243
    80004b4c:	de850513          	addi	a0,a0,-536 # 80247930 <ftable>
    80004b50:	ffffc097          	auipc	ra,0xffffc
    80004b54:	1d0080e7          	jalr	464(ra) # 80000d20 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b58:	00243497          	auipc	s1,0x243
    80004b5c:	df048493          	addi	s1,s1,-528 # 80247948 <ftable+0x18>
    80004b60:	00244717          	auipc	a4,0x244
    80004b64:	d8870713          	addi	a4,a4,-632 # 802488e8 <disk>
    if(f->ref == 0){
    80004b68:	40dc                	lw	a5,4(s1)
    80004b6a:	cf99                	beqz	a5,80004b88 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b6c:	02848493          	addi	s1,s1,40
    80004b70:	fee49ce3          	bne	s1,a4,80004b68 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b74:	00243517          	auipc	a0,0x243
    80004b78:	dbc50513          	addi	a0,a0,-580 # 80247930 <ftable>
    80004b7c:	ffffc097          	auipc	ra,0xffffc
    80004b80:	258080e7          	jalr	600(ra) # 80000dd4 <release>
  return 0;
    80004b84:	4481                	li	s1,0
    80004b86:	a819                	j	80004b9c <filealloc+0x5e>
      f->ref = 1;
    80004b88:	4785                	li	a5,1
    80004b8a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b8c:	00243517          	auipc	a0,0x243
    80004b90:	da450513          	addi	a0,a0,-604 # 80247930 <ftable>
    80004b94:	ffffc097          	auipc	ra,0xffffc
    80004b98:	240080e7          	jalr	576(ra) # 80000dd4 <release>
}
    80004b9c:	8526                	mv	a0,s1
    80004b9e:	60e2                	ld	ra,24(sp)
    80004ba0:	6442                	ld	s0,16(sp)
    80004ba2:	64a2                	ld	s1,8(sp)
    80004ba4:	6105                	addi	sp,sp,32
    80004ba6:	8082                	ret

0000000080004ba8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004ba8:	1101                	addi	sp,sp,-32
    80004baa:	ec06                	sd	ra,24(sp)
    80004bac:	e822                	sd	s0,16(sp)
    80004bae:	e426                	sd	s1,8(sp)
    80004bb0:	1000                	addi	s0,sp,32
    80004bb2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004bb4:	00243517          	auipc	a0,0x243
    80004bb8:	d7c50513          	addi	a0,a0,-644 # 80247930 <ftable>
    80004bbc:	ffffc097          	auipc	ra,0xffffc
    80004bc0:	164080e7          	jalr	356(ra) # 80000d20 <acquire>
  if(f->ref < 1)
    80004bc4:	40dc                	lw	a5,4(s1)
    80004bc6:	02f05263          	blez	a5,80004bea <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004bca:	2785                	addiw	a5,a5,1
    80004bcc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004bce:	00243517          	auipc	a0,0x243
    80004bd2:	d6250513          	addi	a0,a0,-670 # 80247930 <ftable>
    80004bd6:	ffffc097          	auipc	ra,0xffffc
    80004bda:	1fe080e7          	jalr	510(ra) # 80000dd4 <release>
  return f;
}
    80004bde:	8526                	mv	a0,s1
    80004be0:	60e2                	ld	ra,24(sp)
    80004be2:	6442                	ld	s0,16(sp)
    80004be4:	64a2                	ld	s1,8(sp)
    80004be6:	6105                	addi	sp,sp,32
    80004be8:	8082                	ret
    panic("filedup");
    80004bea:	00004517          	auipc	a0,0x4
    80004bee:	d3650513          	addi	a0,a0,-714 # 80008920 <syscall_list+0x2a8>
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	952080e7          	jalr	-1710(ra) # 80000544 <panic>

0000000080004bfa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004bfa:	7139                	addi	sp,sp,-64
    80004bfc:	fc06                	sd	ra,56(sp)
    80004bfe:	f822                	sd	s0,48(sp)
    80004c00:	f426                	sd	s1,40(sp)
    80004c02:	f04a                	sd	s2,32(sp)
    80004c04:	ec4e                	sd	s3,24(sp)
    80004c06:	e852                	sd	s4,16(sp)
    80004c08:	e456                	sd	s5,8(sp)
    80004c0a:	0080                	addi	s0,sp,64
    80004c0c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004c0e:	00243517          	auipc	a0,0x243
    80004c12:	d2250513          	addi	a0,a0,-734 # 80247930 <ftable>
    80004c16:	ffffc097          	auipc	ra,0xffffc
    80004c1a:	10a080e7          	jalr	266(ra) # 80000d20 <acquire>
  if(f->ref < 1)
    80004c1e:	40dc                	lw	a5,4(s1)
    80004c20:	06f05163          	blez	a5,80004c82 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004c24:	37fd                	addiw	a5,a5,-1
    80004c26:	0007871b          	sext.w	a4,a5
    80004c2a:	c0dc                	sw	a5,4(s1)
    80004c2c:	06e04363          	bgtz	a4,80004c92 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004c30:	0004a903          	lw	s2,0(s1)
    80004c34:	0094ca83          	lbu	s5,9(s1)
    80004c38:	0104ba03          	ld	s4,16(s1)
    80004c3c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004c40:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004c44:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004c48:	00243517          	auipc	a0,0x243
    80004c4c:	ce850513          	addi	a0,a0,-792 # 80247930 <ftable>
    80004c50:	ffffc097          	auipc	ra,0xffffc
    80004c54:	184080e7          	jalr	388(ra) # 80000dd4 <release>

  if(ff.type == FD_PIPE){
    80004c58:	4785                	li	a5,1
    80004c5a:	04f90d63          	beq	s2,a5,80004cb4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004c5e:	3979                	addiw	s2,s2,-2
    80004c60:	4785                	li	a5,1
    80004c62:	0527e063          	bltu	a5,s2,80004ca2 <fileclose+0xa8>
    begin_op();
    80004c66:	00000097          	auipc	ra,0x0
    80004c6a:	ac8080e7          	jalr	-1336(ra) # 8000472e <begin_op>
    iput(ff.ip);
    80004c6e:	854e                	mv	a0,s3
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	2b6080e7          	jalr	694(ra) # 80003f26 <iput>
    end_op();
    80004c78:	00000097          	auipc	ra,0x0
    80004c7c:	b36080e7          	jalr	-1226(ra) # 800047ae <end_op>
    80004c80:	a00d                	j	80004ca2 <fileclose+0xa8>
    panic("fileclose");
    80004c82:	00004517          	auipc	a0,0x4
    80004c86:	ca650513          	addi	a0,a0,-858 # 80008928 <syscall_list+0x2b0>
    80004c8a:	ffffc097          	auipc	ra,0xffffc
    80004c8e:	8ba080e7          	jalr	-1862(ra) # 80000544 <panic>
    release(&ftable.lock);
    80004c92:	00243517          	auipc	a0,0x243
    80004c96:	c9e50513          	addi	a0,a0,-866 # 80247930 <ftable>
    80004c9a:	ffffc097          	auipc	ra,0xffffc
    80004c9e:	13a080e7          	jalr	314(ra) # 80000dd4 <release>
  }
}
    80004ca2:	70e2                	ld	ra,56(sp)
    80004ca4:	7442                	ld	s0,48(sp)
    80004ca6:	74a2                	ld	s1,40(sp)
    80004ca8:	7902                	ld	s2,32(sp)
    80004caa:	69e2                	ld	s3,24(sp)
    80004cac:	6a42                	ld	s4,16(sp)
    80004cae:	6aa2                	ld	s5,8(sp)
    80004cb0:	6121                	addi	sp,sp,64
    80004cb2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004cb4:	85d6                	mv	a1,s5
    80004cb6:	8552                	mv	a0,s4
    80004cb8:	00000097          	auipc	ra,0x0
    80004cbc:	34c080e7          	jalr	844(ra) # 80005004 <pipeclose>
    80004cc0:	b7cd                	j	80004ca2 <fileclose+0xa8>

0000000080004cc2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004cc2:	715d                	addi	sp,sp,-80
    80004cc4:	e486                	sd	ra,72(sp)
    80004cc6:	e0a2                	sd	s0,64(sp)
    80004cc8:	fc26                	sd	s1,56(sp)
    80004cca:	f84a                	sd	s2,48(sp)
    80004ccc:	f44e                	sd	s3,40(sp)
    80004cce:	0880                	addi	s0,sp,80
    80004cd0:	84aa                	mv	s1,a0
    80004cd2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004cd4:	ffffd097          	auipc	ra,0xffffd
    80004cd8:	e7c080e7          	jalr	-388(ra) # 80001b50 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004cdc:	409c                	lw	a5,0(s1)
    80004cde:	37f9                	addiw	a5,a5,-2
    80004ce0:	4705                	li	a4,1
    80004ce2:	04f76763          	bltu	a4,a5,80004d30 <filestat+0x6e>
    80004ce6:	892a                	mv	s2,a0
    ilock(f->ip);
    80004ce8:	6c88                	ld	a0,24(s1)
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	082080e7          	jalr	130(ra) # 80003d6c <ilock>
    stati(f->ip, &st);
    80004cf2:	fb840593          	addi	a1,s0,-72
    80004cf6:	6c88                	ld	a0,24(s1)
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	2fe080e7          	jalr	766(ra) # 80003ff6 <stati>
    iunlock(f->ip);
    80004d00:	6c88                	ld	a0,24(s1)
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	12c080e7          	jalr	300(ra) # 80003e2e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004d0a:	46e1                	li	a3,24
    80004d0c:	fb840613          	addi	a2,s0,-72
    80004d10:	85ce                	mv	a1,s3
    80004d12:	06093503          	ld	a0,96(s2)
    80004d16:	ffffd097          	auipc	ra,0xffffd
    80004d1a:	a8a080e7          	jalr	-1398(ra) # 800017a0 <copyout>
    80004d1e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004d22:	60a6                	ld	ra,72(sp)
    80004d24:	6406                	ld	s0,64(sp)
    80004d26:	74e2                	ld	s1,56(sp)
    80004d28:	7942                	ld	s2,48(sp)
    80004d2a:	79a2                	ld	s3,40(sp)
    80004d2c:	6161                	addi	sp,sp,80
    80004d2e:	8082                	ret
  return -1;
    80004d30:	557d                	li	a0,-1
    80004d32:	bfc5                	j	80004d22 <filestat+0x60>

0000000080004d34 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004d34:	7179                	addi	sp,sp,-48
    80004d36:	f406                	sd	ra,40(sp)
    80004d38:	f022                	sd	s0,32(sp)
    80004d3a:	ec26                	sd	s1,24(sp)
    80004d3c:	e84a                	sd	s2,16(sp)
    80004d3e:	e44e                	sd	s3,8(sp)
    80004d40:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004d42:	00854783          	lbu	a5,8(a0)
    80004d46:	c3d5                	beqz	a5,80004dea <fileread+0xb6>
    80004d48:	84aa                	mv	s1,a0
    80004d4a:	89ae                	mv	s3,a1
    80004d4c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d4e:	411c                	lw	a5,0(a0)
    80004d50:	4705                	li	a4,1
    80004d52:	04e78963          	beq	a5,a4,80004da4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d56:	470d                	li	a4,3
    80004d58:	04e78d63          	beq	a5,a4,80004db2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d5c:	4709                	li	a4,2
    80004d5e:	06e79e63          	bne	a5,a4,80004dda <fileread+0xa6>
    ilock(f->ip);
    80004d62:	6d08                	ld	a0,24(a0)
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	008080e7          	jalr	8(ra) # 80003d6c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d6c:	874a                	mv	a4,s2
    80004d6e:	5094                	lw	a3,32(s1)
    80004d70:	864e                	mv	a2,s3
    80004d72:	4585                	li	a1,1
    80004d74:	6c88                	ld	a0,24(s1)
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	2aa080e7          	jalr	682(ra) # 80004020 <readi>
    80004d7e:	892a                	mv	s2,a0
    80004d80:	00a05563          	blez	a0,80004d8a <fileread+0x56>
      f->off += r;
    80004d84:	509c                	lw	a5,32(s1)
    80004d86:	9fa9                	addw	a5,a5,a0
    80004d88:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d8a:	6c88                	ld	a0,24(s1)
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	0a2080e7          	jalr	162(ra) # 80003e2e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004d94:	854a                	mv	a0,s2
    80004d96:	70a2                	ld	ra,40(sp)
    80004d98:	7402                	ld	s0,32(sp)
    80004d9a:	64e2                	ld	s1,24(sp)
    80004d9c:	6942                	ld	s2,16(sp)
    80004d9e:	69a2                	ld	s3,8(sp)
    80004da0:	6145                	addi	sp,sp,48
    80004da2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004da4:	6908                	ld	a0,16(a0)
    80004da6:	00000097          	auipc	ra,0x0
    80004daa:	3ce080e7          	jalr	974(ra) # 80005174 <piperead>
    80004dae:	892a                	mv	s2,a0
    80004db0:	b7d5                	j	80004d94 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004db2:	02451783          	lh	a5,36(a0)
    80004db6:	03079693          	slli	a3,a5,0x30
    80004dba:	92c1                	srli	a3,a3,0x30
    80004dbc:	4725                	li	a4,9
    80004dbe:	02d76863          	bltu	a4,a3,80004dee <fileread+0xba>
    80004dc2:	0792                	slli	a5,a5,0x4
    80004dc4:	00243717          	auipc	a4,0x243
    80004dc8:	acc70713          	addi	a4,a4,-1332 # 80247890 <devsw>
    80004dcc:	97ba                	add	a5,a5,a4
    80004dce:	639c                	ld	a5,0(a5)
    80004dd0:	c38d                	beqz	a5,80004df2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004dd2:	4505                	li	a0,1
    80004dd4:	9782                	jalr	a5
    80004dd6:	892a                	mv	s2,a0
    80004dd8:	bf75                	j	80004d94 <fileread+0x60>
    panic("fileread");
    80004dda:	00004517          	auipc	a0,0x4
    80004dde:	b5e50513          	addi	a0,a0,-1186 # 80008938 <syscall_list+0x2c0>
    80004de2:	ffffb097          	auipc	ra,0xffffb
    80004de6:	762080e7          	jalr	1890(ra) # 80000544 <panic>
    return -1;
    80004dea:	597d                	li	s2,-1
    80004dec:	b765                	j	80004d94 <fileread+0x60>
      return -1;
    80004dee:	597d                	li	s2,-1
    80004df0:	b755                	j	80004d94 <fileread+0x60>
    80004df2:	597d                	li	s2,-1
    80004df4:	b745                	j	80004d94 <fileread+0x60>

0000000080004df6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004df6:	715d                	addi	sp,sp,-80
    80004df8:	e486                	sd	ra,72(sp)
    80004dfa:	e0a2                	sd	s0,64(sp)
    80004dfc:	fc26                	sd	s1,56(sp)
    80004dfe:	f84a                	sd	s2,48(sp)
    80004e00:	f44e                	sd	s3,40(sp)
    80004e02:	f052                	sd	s4,32(sp)
    80004e04:	ec56                	sd	s5,24(sp)
    80004e06:	e85a                	sd	s6,16(sp)
    80004e08:	e45e                	sd	s7,8(sp)
    80004e0a:	e062                	sd	s8,0(sp)
    80004e0c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004e0e:	00954783          	lbu	a5,9(a0)
    80004e12:	10078663          	beqz	a5,80004f1e <filewrite+0x128>
    80004e16:	892a                	mv	s2,a0
    80004e18:	8aae                	mv	s5,a1
    80004e1a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e1c:	411c                	lw	a5,0(a0)
    80004e1e:	4705                	li	a4,1
    80004e20:	02e78263          	beq	a5,a4,80004e44 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e24:	470d                	li	a4,3
    80004e26:	02e78663          	beq	a5,a4,80004e52 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e2a:	4709                	li	a4,2
    80004e2c:	0ee79163          	bne	a5,a4,80004f0e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004e30:	0ac05d63          	blez	a2,80004eea <filewrite+0xf4>
    int i = 0;
    80004e34:	4981                	li	s3,0
    80004e36:	6b05                	lui	s6,0x1
    80004e38:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004e3c:	6b85                	lui	s7,0x1
    80004e3e:	c00b8b9b          	addiw	s7,s7,-1024
    80004e42:	a861                	j	80004eda <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004e44:	6908                	ld	a0,16(a0)
    80004e46:	00000097          	auipc	ra,0x0
    80004e4a:	22e080e7          	jalr	558(ra) # 80005074 <pipewrite>
    80004e4e:	8a2a                	mv	s4,a0
    80004e50:	a045                	j	80004ef0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e52:	02451783          	lh	a5,36(a0)
    80004e56:	03079693          	slli	a3,a5,0x30
    80004e5a:	92c1                	srli	a3,a3,0x30
    80004e5c:	4725                	li	a4,9
    80004e5e:	0cd76263          	bltu	a4,a3,80004f22 <filewrite+0x12c>
    80004e62:	0792                	slli	a5,a5,0x4
    80004e64:	00243717          	auipc	a4,0x243
    80004e68:	a2c70713          	addi	a4,a4,-1492 # 80247890 <devsw>
    80004e6c:	97ba                	add	a5,a5,a4
    80004e6e:	679c                	ld	a5,8(a5)
    80004e70:	cbdd                	beqz	a5,80004f26 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004e72:	4505                	li	a0,1
    80004e74:	9782                	jalr	a5
    80004e76:	8a2a                	mv	s4,a0
    80004e78:	a8a5                	j	80004ef0 <filewrite+0xfa>
    80004e7a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004e7e:	00000097          	auipc	ra,0x0
    80004e82:	8b0080e7          	jalr	-1872(ra) # 8000472e <begin_op>
      ilock(f->ip);
    80004e86:	01893503          	ld	a0,24(s2)
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	ee2080e7          	jalr	-286(ra) # 80003d6c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e92:	8762                	mv	a4,s8
    80004e94:	02092683          	lw	a3,32(s2)
    80004e98:	01598633          	add	a2,s3,s5
    80004e9c:	4585                	li	a1,1
    80004e9e:	01893503          	ld	a0,24(s2)
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	276080e7          	jalr	630(ra) # 80004118 <writei>
    80004eaa:	84aa                	mv	s1,a0
    80004eac:	00a05763          	blez	a0,80004eba <filewrite+0xc4>
        f->off += r;
    80004eb0:	02092783          	lw	a5,32(s2)
    80004eb4:	9fa9                	addw	a5,a5,a0
    80004eb6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004eba:	01893503          	ld	a0,24(s2)
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	f70080e7          	jalr	-144(ra) # 80003e2e <iunlock>
      end_op();
    80004ec6:	00000097          	auipc	ra,0x0
    80004eca:	8e8080e7          	jalr	-1816(ra) # 800047ae <end_op>

      if(r != n1){
    80004ece:	009c1f63          	bne	s8,s1,80004eec <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004ed2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004ed6:	0149db63          	bge	s3,s4,80004eec <filewrite+0xf6>
      int n1 = n - i;
    80004eda:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004ede:	84be                	mv	s1,a5
    80004ee0:	2781                	sext.w	a5,a5
    80004ee2:	f8fb5ce3          	bge	s6,a5,80004e7a <filewrite+0x84>
    80004ee6:	84de                	mv	s1,s7
    80004ee8:	bf49                	j	80004e7a <filewrite+0x84>
    int i = 0;
    80004eea:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004eec:	013a1f63          	bne	s4,s3,80004f0a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004ef0:	8552                	mv	a0,s4
    80004ef2:	60a6                	ld	ra,72(sp)
    80004ef4:	6406                	ld	s0,64(sp)
    80004ef6:	74e2                	ld	s1,56(sp)
    80004ef8:	7942                	ld	s2,48(sp)
    80004efa:	79a2                	ld	s3,40(sp)
    80004efc:	7a02                	ld	s4,32(sp)
    80004efe:	6ae2                	ld	s5,24(sp)
    80004f00:	6b42                	ld	s6,16(sp)
    80004f02:	6ba2                	ld	s7,8(sp)
    80004f04:	6c02                	ld	s8,0(sp)
    80004f06:	6161                	addi	sp,sp,80
    80004f08:	8082                	ret
    ret = (i == n ? n : -1);
    80004f0a:	5a7d                	li	s4,-1
    80004f0c:	b7d5                	j	80004ef0 <filewrite+0xfa>
    panic("filewrite");
    80004f0e:	00004517          	auipc	a0,0x4
    80004f12:	a3a50513          	addi	a0,a0,-1478 # 80008948 <syscall_list+0x2d0>
    80004f16:	ffffb097          	auipc	ra,0xffffb
    80004f1a:	62e080e7          	jalr	1582(ra) # 80000544 <panic>
    return -1;
    80004f1e:	5a7d                	li	s4,-1
    80004f20:	bfc1                	j	80004ef0 <filewrite+0xfa>
      return -1;
    80004f22:	5a7d                	li	s4,-1
    80004f24:	b7f1                	j	80004ef0 <filewrite+0xfa>
    80004f26:	5a7d                	li	s4,-1
    80004f28:	b7e1                	j	80004ef0 <filewrite+0xfa>

0000000080004f2a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f2a:	7179                	addi	sp,sp,-48
    80004f2c:	f406                	sd	ra,40(sp)
    80004f2e:	f022                	sd	s0,32(sp)
    80004f30:	ec26                	sd	s1,24(sp)
    80004f32:	e84a                	sd	s2,16(sp)
    80004f34:	e44e                	sd	s3,8(sp)
    80004f36:	e052                	sd	s4,0(sp)
    80004f38:	1800                	addi	s0,sp,48
    80004f3a:	84aa                	mv	s1,a0
    80004f3c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f3e:	0005b023          	sd	zero,0(a1)
    80004f42:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f46:	00000097          	auipc	ra,0x0
    80004f4a:	bf8080e7          	jalr	-1032(ra) # 80004b3e <filealloc>
    80004f4e:	e088                	sd	a0,0(s1)
    80004f50:	c551                	beqz	a0,80004fdc <pipealloc+0xb2>
    80004f52:	00000097          	auipc	ra,0x0
    80004f56:	bec080e7          	jalr	-1044(ra) # 80004b3e <filealloc>
    80004f5a:	00aa3023          	sd	a0,0(s4)
    80004f5e:	c92d                	beqz	a0,80004fd0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f60:	ffffc097          	auipc	ra,0xffffc
    80004f64:	c98080e7          	jalr	-872(ra) # 80000bf8 <kalloc>
    80004f68:	892a                	mv	s2,a0
    80004f6a:	c125                	beqz	a0,80004fca <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004f6c:	4985                	li	s3,1
    80004f6e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f72:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f76:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f7a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f7e:	00003597          	auipc	a1,0x3
    80004f82:	52a58593          	addi	a1,a1,1322 # 800084a8 <states.1983+0x1a8>
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	d0a080e7          	jalr	-758(ra) # 80000c90 <initlock>
  (*f0)->type = FD_PIPE;
    80004f8e:	609c                	ld	a5,0(s1)
    80004f90:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f94:	609c                	ld	a5,0(s1)
    80004f96:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f9a:	609c                	ld	a5,0(s1)
    80004f9c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004fa0:	609c                	ld	a5,0(s1)
    80004fa2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004fa6:	000a3783          	ld	a5,0(s4)
    80004faa:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004fae:	000a3783          	ld	a5,0(s4)
    80004fb2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004fb6:	000a3783          	ld	a5,0(s4)
    80004fba:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004fbe:	000a3783          	ld	a5,0(s4)
    80004fc2:	0127b823          	sd	s2,16(a5)
  return 0;
    80004fc6:	4501                	li	a0,0
    80004fc8:	a025                	j	80004ff0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fca:	6088                	ld	a0,0(s1)
    80004fcc:	e501                	bnez	a0,80004fd4 <pipealloc+0xaa>
    80004fce:	a039                	j	80004fdc <pipealloc+0xb2>
    80004fd0:	6088                	ld	a0,0(s1)
    80004fd2:	c51d                	beqz	a0,80005000 <pipealloc+0xd6>
    fileclose(*f0);
    80004fd4:	00000097          	auipc	ra,0x0
    80004fd8:	c26080e7          	jalr	-986(ra) # 80004bfa <fileclose>
  if(*f1)
    80004fdc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fe0:	557d                	li	a0,-1
  if(*f1)
    80004fe2:	c799                	beqz	a5,80004ff0 <pipealloc+0xc6>
    fileclose(*f1);
    80004fe4:	853e                	mv	a0,a5
    80004fe6:	00000097          	auipc	ra,0x0
    80004fea:	c14080e7          	jalr	-1004(ra) # 80004bfa <fileclose>
  return -1;
    80004fee:	557d                	li	a0,-1
}
    80004ff0:	70a2                	ld	ra,40(sp)
    80004ff2:	7402                	ld	s0,32(sp)
    80004ff4:	64e2                	ld	s1,24(sp)
    80004ff6:	6942                	ld	s2,16(sp)
    80004ff8:	69a2                	ld	s3,8(sp)
    80004ffa:	6a02                	ld	s4,0(sp)
    80004ffc:	6145                	addi	sp,sp,48
    80004ffe:	8082                	ret
  return -1;
    80005000:	557d                	li	a0,-1
    80005002:	b7fd                	j	80004ff0 <pipealloc+0xc6>

0000000080005004 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005004:	1101                	addi	sp,sp,-32
    80005006:	ec06                	sd	ra,24(sp)
    80005008:	e822                	sd	s0,16(sp)
    8000500a:	e426                	sd	s1,8(sp)
    8000500c:	e04a                	sd	s2,0(sp)
    8000500e:	1000                	addi	s0,sp,32
    80005010:	84aa                	mv	s1,a0
    80005012:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	d0c080e7          	jalr	-756(ra) # 80000d20 <acquire>
  if(writable){
    8000501c:	02090d63          	beqz	s2,80005056 <pipeclose+0x52>
    pi->writeopen = 0;
    80005020:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005024:	21848513          	addi	a0,s1,536
    80005028:	ffffd097          	auipc	ra,0xffffd
    8000502c:	0ee080e7          	jalr	238(ra) # 80002116 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005030:	2204b783          	ld	a5,544(s1)
    80005034:	eb95                	bnez	a5,80005068 <pipeclose+0x64>
    release(&pi->lock);
    80005036:	8526                	mv	a0,s1
    80005038:	ffffc097          	auipc	ra,0xffffc
    8000503c:	d9c080e7          	jalr	-612(ra) # 80000dd4 <release>
    kfree((char*)pi);
    80005040:	8526                	mv	a0,s1
    80005042:	ffffc097          	auipc	ra,0xffffc
    80005046:	a34080e7          	jalr	-1484(ra) # 80000a76 <kfree>
  } else
    release(&pi->lock);
}
    8000504a:	60e2                	ld	ra,24(sp)
    8000504c:	6442                	ld	s0,16(sp)
    8000504e:	64a2                	ld	s1,8(sp)
    80005050:	6902                	ld	s2,0(sp)
    80005052:	6105                	addi	sp,sp,32
    80005054:	8082                	ret
    pi->readopen = 0;
    80005056:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000505a:	21c48513          	addi	a0,s1,540
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	0b8080e7          	jalr	184(ra) # 80002116 <wakeup>
    80005066:	b7e9                	j	80005030 <pipeclose+0x2c>
    release(&pi->lock);
    80005068:	8526                	mv	a0,s1
    8000506a:	ffffc097          	auipc	ra,0xffffc
    8000506e:	d6a080e7          	jalr	-662(ra) # 80000dd4 <release>
}
    80005072:	bfe1                	j	8000504a <pipeclose+0x46>

0000000080005074 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005074:	7159                	addi	sp,sp,-112
    80005076:	f486                	sd	ra,104(sp)
    80005078:	f0a2                	sd	s0,96(sp)
    8000507a:	eca6                	sd	s1,88(sp)
    8000507c:	e8ca                	sd	s2,80(sp)
    8000507e:	e4ce                	sd	s3,72(sp)
    80005080:	e0d2                	sd	s4,64(sp)
    80005082:	fc56                	sd	s5,56(sp)
    80005084:	f85a                	sd	s6,48(sp)
    80005086:	f45e                	sd	s7,40(sp)
    80005088:	f062                	sd	s8,32(sp)
    8000508a:	ec66                	sd	s9,24(sp)
    8000508c:	1880                	addi	s0,sp,112
    8000508e:	84aa                	mv	s1,a0
    80005090:	8aae                	mv	s5,a1
    80005092:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005094:	ffffd097          	auipc	ra,0xffffd
    80005098:	abc080e7          	jalr	-1348(ra) # 80001b50 <myproc>
    8000509c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000509e:	8526                	mv	a0,s1
    800050a0:	ffffc097          	auipc	ra,0xffffc
    800050a4:	c80080e7          	jalr	-896(ra) # 80000d20 <acquire>
  while(i < n){
    800050a8:	0d405463          	blez	s4,80005170 <pipewrite+0xfc>
    800050ac:	8ba6                	mv	s7,s1
  int i = 0;
    800050ae:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050b0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800050b2:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800050b6:	21c48c13          	addi	s8,s1,540
    800050ba:	a08d                	j	8000511c <pipewrite+0xa8>
      release(&pi->lock);
    800050bc:	8526                	mv	a0,s1
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	d16080e7          	jalr	-746(ra) # 80000dd4 <release>
      return -1;
    800050c6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800050c8:	854a                	mv	a0,s2
    800050ca:	70a6                	ld	ra,104(sp)
    800050cc:	7406                	ld	s0,96(sp)
    800050ce:	64e6                	ld	s1,88(sp)
    800050d0:	6946                	ld	s2,80(sp)
    800050d2:	69a6                	ld	s3,72(sp)
    800050d4:	6a06                	ld	s4,64(sp)
    800050d6:	7ae2                	ld	s5,56(sp)
    800050d8:	7b42                	ld	s6,48(sp)
    800050da:	7ba2                	ld	s7,40(sp)
    800050dc:	7c02                	ld	s8,32(sp)
    800050de:	6ce2                	ld	s9,24(sp)
    800050e0:	6165                	addi	sp,sp,112
    800050e2:	8082                	ret
      wakeup(&pi->nread);
    800050e4:	8566                	mv	a0,s9
    800050e6:	ffffd097          	auipc	ra,0xffffd
    800050ea:	030080e7          	jalr	48(ra) # 80002116 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050ee:	85de                	mv	a1,s7
    800050f0:	8562                	mv	a0,s8
    800050f2:	ffffd097          	auipc	ra,0xffffd
    800050f6:	3a6080e7          	jalr	934(ra) # 80002498 <sleep>
    800050fa:	a839                	j	80005118 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800050fc:	21c4a783          	lw	a5,540(s1)
    80005100:	0017871b          	addiw	a4,a5,1
    80005104:	20e4ae23          	sw	a4,540(s1)
    80005108:	1ff7f793          	andi	a5,a5,511
    8000510c:	97a6                	add	a5,a5,s1
    8000510e:	f9f44703          	lbu	a4,-97(s0)
    80005112:	00e78c23          	sb	a4,24(a5)
      i++;
    80005116:	2905                	addiw	s2,s2,1
  while(i < n){
    80005118:	05495063          	bge	s2,s4,80005158 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    8000511c:	2204a783          	lw	a5,544(s1)
    80005120:	dfd1                	beqz	a5,800050bc <pipewrite+0x48>
    80005122:	854e                	mv	a0,s3
    80005124:	ffffd097          	auipc	ra,0xffffd
    80005128:	5c2080e7          	jalr	1474(ra) # 800026e6 <killed>
    8000512c:	f941                	bnez	a0,800050bc <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000512e:	2184a783          	lw	a5,536(s1)
    80005132:	21c4a703          	lw	a4,540(s1)
    80005136:	2007879b          	addiw	a5,a5,512
    8000513a:	faf705e3          	beq	a4,a5,800050e4 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000513e:	4685                	li	a3,1
    80005140:	01590633          	add	a2,s2,s5
    80005144:	f9f40593          	addi	a1,s0,-97
    80005148:	0609b503          	ld	a0,96(s3)
    8000514c:	ffffc097          	auipc	ra,0xffffc
    80005150:	714080e7          	jalr	1812(ra) # 80001860 <copyin>
    80005154:	fb6514e3          	bne	a0,s6,800050fc <pipewrite+0x88>
  wakeup(&pi->nread);
    80005158:	21848513          	addi	a0,s1,536
    8000515c:	ffffd097          	auipc	ra,0xffffd
    80005160:	fba080e7          	jalr	-70(ra) # 80002116 <wakeup>
  release(&pi->lock);
    80005164:	8526                	mv	a0,s1
    80005166:	ffffc097          	auipc	ra,0xffffc
    8000516a:	c6e080e7          	jalr	-914(ra) # 80000dd4 <release>
  return i;
    8000516e:	bfa9                	j	800050c8 <pipewrite+0x54>
  int i = 0;
    80005170:	4901                	li	s2,0
    80005172:	b7dd                	j	80005158 <pipewrite+0xe4>

0000000080005174 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005174:	715d                	addi	sp,sp,-80
    80005176:	e486                	sd	ra,72(sp)
    80005178:	e0a2                	sd	s0,64(sp)
    8000517a:	fc26                	sd	s1,56(sp)
    8000517c:	f84a                	sd	s2,48(sp)
    8000517e:	f44e                	sd	s3,40(sp)
    80005180:	f052                	sd	s4,32(sp)
    80005182:	ec56                	sd	s5,24(sp)
    80005184:	e85a                	sd	s6,16(sp)
    80005186:	0880                	addi	s0,sp,80
    80005188:	84aa                	mv	s1,a0
    8000518a:	892e                	mv	s2,a1
    8000518c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000518e:	ffffd097          	auipc	ra,0xffffd
    80005192:	9c2080e7          	jalr	-1598(ra) # 80001b50 <myproc>
    80005196:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005198:	8b26                	mv	s6,s1
    8000519a:	8526                	mv	a0,s1
    8000519c:	ffffc097          	auipc	ra,0xffffc
    800051a0:	b84080e7          	jalr	-1148(ra) # 80000d20 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051a4:	2184a703          	lw	a4,536(s1)
    800051a8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051ac:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051b0:	02f71763          	bne	a4,a5,800051de <piperead+0x6a>
    800051b4:	2244a783          	lw	a5,548(s1)
    800051b8:	c39d                	beqz	a5,800051de <piperead+0x6a>
    if(killed(pr)){
    800051ba:	8552                	mv	a0,s4
    800051bc:	ffffd097          	auipc	ra,0xffffd
    800051c0:	52a080e7          	jalr	1322(ra) # 800026e6 <killed>
    800051c4:	e941                	bnez	a0,80005254 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051c6:	85da                	mv	a1,s6
    800051c8:	854e                	mv	a0,s3
    800051ca:	ffffd097          	auipc	ra,0xffffd
    800051ce:	2ce080e7          	jalr	718(ra) # 80002498 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051d2:	2184a703          	lw	a4,536(s1)
    800051d6:	21c4a783          	lw	a5,540(s1)
    800051da:	fcf70de3          	beq	a4,a5,800051b4 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051de:	09505263          	blez	s5,80005262 <piperead+0xee>
    800051e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051e4:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800051e6:	2184a783          	lw	a5,536(s1)
    800051ea:	21c4a703          	lw	a4,540(s1)
    800051ee:	02f70d63          	beq	a4,a5,80005228 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051f2:	0017871b          	addiw	a4,a5,1
    800051f6:	20e4ac23          	sw	a4,536(s1)
    800051fa:	1ff7f793          	andi	a5,a5,511
    800051fe:	97a6                	add	a5,a5,s1
    80005200:	0187c783          	lbu	a5,24(a5)
    80005204:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005208:	4685                	li	a3,1
    8000520a:	fbf40613          	addi	a2,s0,-65
    8000520e:	85ca                	mv	a1,s2
    80005210:	060a3503          	ld	a0,96(s4)
    80005214:	ffffc097          	auipc	ra,0xffffc
    80005218:	58c080e7          	jalr	1420(ra) # 800017a0 <copyout>
    8000521c:	01650663          	beq	a0,s6,80005228 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005220:	2985                	addiw	s3,s3,1
    80005222:	0905                	addi	s2,s2,1
    80005224:	fd3a91e3          	bne	s5,s3,800051e6 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005228:	21c48513          	addi	a0,s1,540
    8000522c:	ffffd097          	auipc	ra,0xffffd
    80005230:	eea080e7          	jalr	-278(ra) # 80002116 <wakeup>
  release(&pi->lock);
    80005234:	8526                	mv	a0,s1
    80005236:	ffffc097          	auipc	ra,0xffffc
    8000523a:	b9e080e7          	jalr	-1122(ra) # 80000dd4 <release>
  return i;
}
    8000523e:	854e                	mv	a0,s3
    80005240:	60a6                	ld	ra,72(sp)
    80005242:	6406                	ld	s0,64(sp)
    80005244:	74e2                	ld	s1,56(sp)
    80005246:	7942                	ld	s2,48(sp)
    80005248:	79a2                	ld	s3,40(sp)
    8000524a:	7a02                	ld	s4,32(sp)
    8000524c:	6ae2                	ld	s5,24(sp)
    8000524e:	6b42                	ld	s6,16(sp)
    80005250:	6161                	addi	sp,sp,80
    80005252:	8082                	ret
      release(&pi->lock);
    80005254:	8526                	mv	a0,s1
    80005256:	ffffc097          	auipc	ra,0xffffc
    8000525a:	b7e080e7          	jalr	-1154(ra) # 80000dd4 <release>
      return -1;
    8000525e:	59fd                	li	s3,-1
    80005260:	bff9                	j	8000523e <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005262:	4981                	li	s3,0
    80005264:	b7d1                	j	80005228 <piperead+0xb4>

0000000080005266 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005266:	1141                	addi	sp,sp,-16
    80005268:	e422                	sd	s0,8(sp)
    8000526a:	0800                	addi	s0,sp,16
    8000526c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000526e:	8905                	andi	a0,a0,1
    80005270:	c111                	beqz	a0,80005274 <flags2perm+0xe>
      perm = PTE_X;
    80005272:	4521                	li	a0,8
    if(flags & 0x2)
    80005274:	8b89                	andi	a5,a5,2
    80005276:	c399                	beqz	a5,8000527c <flags2perm+0x16>
      perm |= PTE_W;
    80005278:	00456513          	ori	a0,a0,4
    return perm;
}
    8000527c:	6422                	ld	s0,8(sp)
    8000527e:	0141                	addi	sp,sp,16
    80005280:	8082                	ret

0000000080005282 <exec>:

int
exec(char *path, char **argv)
{
    80005282:	df010113          	addi	sp,sp,-528
    80005286:	20113423          	sd	ra,520(sp)
    8000528a:	20813023          	sd	s0,512(sp)
    8000528e:	ffa6                	sd	s1,504(sp)
    80005290:	fbca                	sd	s2,496(sp)
    80005292:	f7ce                	sd	s3,488(sp)
    80005294:	f3d2                	sd	s4,480(sp)
    80005296:	efd6                	sd	s5,472(sp)
    80005298:	ebda                	sd	s6,464(sp)
    8000529a:	e7de                	sd	s7,456(sp)
    8000529c:	e3e2                	sd	s8,448(sp)
    8000529e:	ff66                	sd	s9,440(sp)
    800052a0:	fb6a                	sd	s10,432(sp)
    800052a2:	f76e                	sd	s11,424(sp)
    800052a4:	0c00                	addi	s0,sp,528
    800052a6:	84aa                	mv	s1,a0
    800052a8:	dea43c23          	sd	a0,-520(s0)
    800052ac:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800052b0:	ffffd097          	auipc	ra,0xffffd
    800052b4:	8a0080e7          	jalr	-1888(ra) # 80001b50 <myproc>
    800052b8:	892a                	mv	s2,a0

  begin_op();
    800052ba:	fffff097          	auipc	ra,0xfffff
    800052be:	474080e7          	jalr	1140(ra) # 8000472e <begin_op>

  if((ip = namei(path)) == 0){
    800052c2:	8526                	mv	a0,s1
    800052c4:	fffff097          	auipc	ra,0xfffff
    800052c8:	24e080e7          	jalr	590(ra) # 80004512 <namei>
    800052cc:	c92d                	beqz	a0,8000533e <exec+0xbc>
    800052ce:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800052d0:	fffff097          	auipc	ra,0xfffff
    800052d4:	a9c080e7          	jalr	-1380(ra) # 80003d6c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800052d8:	04000713          	li	a4,64
    800052dc:	4681                	li	a3,0
    800052de:	e5040613          	addi	a2,s0,-432
    800052e2:	4581                	li	a1,0
    800052e4:	8526                	mv	a0,s1
    800052e6:	fffff097          	auipc	ra,0xfffff
    800052ea:	d3a080e7          	jalr	-710(ra) # 80004020 <readi>
    800052ee:	04000793          	li	a5,64
    800052f2:	00f51a63          	bne	a0,a5,80005306 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800052f6:	e5042703          	lw	a4,-432(s0)
    800052fa:	464c47b7          	lui	a5,0x464c4
    800052fe:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005302:	04f70463          	beq	a4,a5,8000534a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005306:	8526                	mv	a0,s1
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	cc6080e7          	jalr	-826(ra) # 80003fce <iunlockput>
    end_op();
    80005310:	fffff097          	auipc	ra,0xfffff
    80005314:	49e080e7          	jalr	1182(ra) # 800047ae <end_op>
  }
  return -1;
    80005318:	557d                	li	a0,-1
}
    8000531a:	20813083          	ld	ra,520(sp)
    8000531e:	20013403          	ld	s0,512(sp)
    80005322:	74fe                	ld	s1,504(sp)
    80005324:	795e                	ld	s2,496(sp)
    80005326:	79be                	ld	s3,488(sp)
    80005328:	7a1e                	ld	s4,480(sp)
    8000532a:	6afe                	ld	s5,472(sp)
    8000532c:	6b5e                	ld	s6,464(sp)
    8000532e:	6bbe                	ld	s7,456(sp)
    80005330:	6c1e                	ld	s8,448(sp)
    80005332:	7cfa                	ld	s9,440(sp)
    80005334:	7d5a                	ld	s10,432(sp)
    80005336:	7dba                	ld	s11,424(sp)
    80005338:	21010113          	addi	sp,sp,528
    8000533c:	8082                	ret
    end_op();
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	470080e7          	jalr	1136(ra) # 800047ae <end_op>
    return -1;
    80005346:	557d                	li	a0,-1
    80005348:	bfc9                	j	8000531a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000534a:	854a                	mv	a0,s2
    8000534c:	ffffd097          	auipc	ra,0xffffd
    80005350:	8c8080e7          	jalr	-1848(ra) # 80001c14 <proc_pagetable>
    80005354:	8baa                	mv	s7,a0
    80005356:	d945                	beqz	a0,80005306 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005358:	e7042983          	lw	s3,-400(s0)
    8000535c:	e8845783          	lhu	a5,-376(s0)
    80005360:	c7ad                	beqz	a5,800053ca <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005362:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005364:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80005366:	6c85                	lui	s9,0x1
    80005368:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000536c:	def43823          	sd	a5,-528(s0)
    80005370:	ac0d                	j	800055a2 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	5e650513          	addi	a0,a0,1510 # 80008958 <syscall_list+0x2e0>
    8000537a:	ffffb097          	auipc	ra,0xffffb
    8000537e:	1ca080e7          	jalr	458(ra) # 80000544 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005382:	8756                	mv	a4,s5
    80005384:	012d86bb          	addw	a3,s11,s2
    80005388:	4581                	li	a1,0
    8000538a:	8526                	mv	a0,s1
    8000538c:	fffff097          	auipc	ra,0xfffff
    80005390:	c94080e7          	jalr	-876(ra) # 80004020 <readi>
    80005394:	2501                	sext.w	a0,a0
    80005396:	1aaa9a63          	bne	s5,a0,8000554a <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000539a:	6785                	lui	a5,0x1
    8000539c:	0127893b          	addw	s2,a5,s2
    800053a0:	77fd                	lui	a5,0xfffff
    800053a2:	01478a3b          	addw	s4,a5,s4
    800053a6:	1f897563          	bgeu	s2,s8,80005590 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800053aa:	02091593          	slli	a1,s2,0x20
    800053ae:	9181                	srli	a1,a1,0x20
    800053b0:	95ea                	add	a1,a1,s10
    800053b2:	855e                	mv	a0,s7
    800053b4:	ffffc097          	auipc	ra,0xffffc
    800053b8:	dfa080e7          	jalr	-518(ra) # 800011ae <walkaddr>
    800053bc:	862a                	mv	a2,a0
    if(pa == 0)
    800053be:	d955                	beqz	a0,80005372 <exec+0xf0>
      n = PGSIZE;
    800053c0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800053c2:	fd9a70e3          	bgeu	s4,s9,80005382 <exec+0x100>
      n = sz - i;
    800053c6:	8ad2                	mv	s5,s4
    800053c8:	bf6d                	j	80005382 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800053ca:	4a01                	li	s4,0
  iunlockput(ip);
    800053cc:	8526                	mv	a0,s1
    800053ce:	fffff097          	auipc	ra,0xfffff
    800053d2:	c00080e7          	jalr	-1024(ra) # 80003fce <iunlockput>
  end_op();
    800053d6:	fffff097          	auipc	ra,0xfffff
    800053da:	3d8080e7          	jalr	984(ra) # 800047ae <end_op>
  p = myproc();
    800053de:	ffffc097          	auipc	ra,0xffffc
    800053e2:	772080e7          	jalr	1906(ra) # 80001b50 <myproc>
    800053e6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800053e8:	05853d03          	ld	s10,88(a0)
  sz = PGROUNDUP(sz);
    800053ec:	6785                	lui	a5,0x1
    800053ee:	17fd                	addi	a5,a5,-1
    800053f0:	9a3e                	add	s4,s4,a5
    800053f2:	757d                	lui	a0,0xfffff
    800053f4:	00aa77b3          	and	a5,s4,a0
    800053f8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800053fc:	4691                	li	a3,4
    800053fe:	6609                	lui	a2,0x2
    80005400:	963e                	add	a2,a2,a5
    80005402:	85be                	mv	a1,a5
    80005404:	855e                	mv	a0,s7
    80005406:	ffffc097          	auipc	ra,0xffffc
    8000540a:	15c080e7          	jalr	348(ra) # 80001562 <uvmalloc>
    8000540e:	8b2a                	mv	s6,a0
  ip = 0;
    80005410:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005412:	12050c63          	beqz	a0,8000554a <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005416:	75f9                	lui	a1,0xffffe
    80005418:	95aa                	add	a1,a1,a0
    8000541a:	855e                	mv	a0,s7
    8000541c:	ffffc097          	auipc	ra,0xffffc
    80005420:	352080e7          	jalr	850(ra) # 8000176e <uvmclear>
  stackbase = sp - PGSIZE;
    80005424:	7c7d                	lui	s8,0xfffff
    80005426:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80005428:	e0043783          	ld	a5,-512(s0)
    8000542c:	6388                	ld	a0,0(a5)
    8000542e:	c535                	beqz	a0,8000549a <exec+0x218>
    80005430:	e9040993          	addi	s3,s0,-368
    80005434:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80005438:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000543a:	ffffc097          	auipc	ra,0xffffc
    8000543e:	b66080e7          	jalr	-1178(ra) # 80000fa0 <strlen>
    80005442:	2505                	addiw	a0,a0,1
    80005444:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005448:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000544c:	13896663          	bltu	s2,s8,80005578 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005450:	e0043d83          	ld	s11,-512(s0)
    80005454:	000dba03          	ld	s4,0(s11)
    80005458:	8552                	mv	a0,s4
    8000545a:	ffffc097          	auipc	ra,0xffffc
    8000545e:	b46080e7          	jalr	-1210(ra) # 80000fa0 <strlen>
    80005462:	0015069b          	addiw	a3,a0,1
    80005466:	8652                	mv	a2,s4
    80005468:	85ca                	mv	a1,s2
    8000546a:	855e                	mv	a0,s7
    8000546c:	ffffc097          	auipc	ra,0xffffc
    80005470:	334080e7          	jalr	820(ra) # 800017a0 <copyout>
    80005474:	10054663          	bltz	a0,80005580 <exec+0x2fe>
    ustack[argc] = sp;
    80005478:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000547c:	0485                	addi	s1,s1,1
    8000547e:	008d8793          	addi	a5,s11,8
    80005482:	e0f43023          	sd	a5,-512(s0)
    80005486:	008db503          	ld	a0,8(s11)
    8000548a:	c911                	beqz	a0,8000549e <exec+0x21c>
    if(argc >= MAXARG)
    8000548c:	09a1                	addi	s3,s3,8
    8000548e:	fb3c96e3          	bne	s9,s3,8000543a <exec+0x1b8>
  sz = sz1;
    80005492:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80005496:	4481                	li	s1,0
    80005498:	a84d                	j	8000554a <exec+0x2c8>
  sp = sz;
    8000549a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000549c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000549e:	00349793          	slli	a5,s1,0x3
    800054a2:	f9040713          	addi	a4,s0,-112
    800054a6:	97ba                	add	a5,a5,a4
    800054a8:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800054ac:	00148693          	addi	a3,s1,1
    800054b0:	068e                	slli	a3,a3,0x3
    800054b2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800054b6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800054ba:	01897663          	bgeu	s2,s8,800054c6 <exec+0x244>
  sz = sz1;
    800054be:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800054c2:	4481                	li	s1,0
    800054c4:	a059                	j	8000554a <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800054c6:	e9040613          	addi	a2,s0,-368
    800054ca:	85ca                	mv	a1,s2
    800054cc:	855e                	mv	a0,s7
    800054ce:	ffffc097          	auipc	ra,0xffffc
    800054d2:	2d2080e7          	jalr	722(ra) # 800017a0 <copyout>
    800054d6:	0a054963          	bltz	a0,80005588 <exec+0x306>
  p->trapframe->a1 = sp;
    800054da:	068ab783          	ld	a5,104(s5)
    800054de:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800054e2:	df843783          	ld	a5,-520(s0)
    800054e6:	0007c703          	lbu	a4,0(a5)
    800054ea:	cf11                	beqz	a4,80005506 <exec+0x284>
    800054ec:	0785                	addi	a5,a5,1
    if(*s == '/')
    800054ee:	02f00693          	li	a3,47
    800054f2:	a039                	j	80005500 <exec+0x27e>
      last = s+1;
    800054f4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800054f8:	0785                	addi	a5,a5,1
    800054fa:	fff7c703          	lbu	a4,-1(a5)
    800054fe:	c701                	beqz	a4,80005506 <exec+0x284>
    if(*s == '/')
    80005500:	fed71ce3          	bne	a4,a3,800054f8 <exec+0x276>
    80005504:	bfc5                	j	800054f4 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80005506:	4641                	li	a2,16
    80005508:	df843583          	ld	a1,-520(s0)
    8000550c:	168a8513          	addi	a0,s5,360
    80005510:	ffffc097          	auipc	ra,0xffffc
    80005514:	a5e080e7          	jalr	-1442(ra) # 80000f6e <safestrcpy>
  oldpagetable = p->pagetable;
    80005518:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    8000551c:	077ab023          	sd	s7,96(s5)
  p->sz = sz;
    80005520:	056abc23          	sd	s6,88(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005524:	068ab783          	ld	a5,104(s5)
    80005528:	e6843703          	ld	a4,-408(s0)
    8000552c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000552e:	068ab783          	ld	a5,104(s5)
    80005532:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005536:	85ea                	mv	a1,s10
    80005538:	ffffc097          	auipc	ra,0xffffc
    8000553c:	778080e7          	jalr	1912(ra) # 80001cb0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005540:	0004851b          	sext.w	a0,s1
    80005544:	bbd9                	j	8000531a <exec+0x98>
    80005546:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000554a:	e0843583          	ld	a1,-504(s0)
    8000554e:	855e                	mv	a0,s7
    80005550:	ffffc097          	auipc	ra,0xffffc
    80005554:	760080e7          	jalr	1888(ra) # 80001cb0 <proc_freepagetable>
  if(ip){
    80005558:	da0497e3          	bnez	s1,80005306 <exec+0x84>
  return -1;
    8000555c:	557d                	li	a0,-1
    8000555e:	bb75                	j	8000531a <exec+0x98>
    80005560:	e1443423          	sd	s4,-504(s0)
    80005564:	b7dd                	j	8000554a <exec+0x2c8>
    80005566:	e1443423          	sd	s4,-504(s0)
    8000556a:	b7c5                	j	8000554a <exec+0x2c8>
    8000556c:	e1443423          	sd	s4,-504(s0)
    80005570:	bfe9                	j	8000554a <exec+0x2c8>
    80005572:	e1443423          	sd	s4,-504(s0)
    80005576:	bfd1                	j	8000554a <exec+0x2c8>
  sz = sz1;
    80005578:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000557c:	4481                	li	s1,0
    8000557e:	b7f1                	j	8000554a <exec+0x2c8>
  sz = sz1;
    80005580:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80005584:	4481                	li	s1,0
    80005586:	b7d1                	j	8000554a <exec+0x2c8>
  sz = sz1;
    80005588:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000558c:	4481                	li	s1,0
    8000558e:	bf75                	j	8000554a <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005590:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005594:	2b05                	addiw	s6,s6,1
    80005596:	0389899b          	addiw	s3,s3,56
    8000559a:	e8845783          	lhu	a5,-376(s0)
    8000559e:	e2fb57e3          	bge	s6,a5,800053cc <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800055a2:	2981                	sext.w	s3,s3
    800055a4:	03800713          	li	a4,56
    800055a8:	86ce                	mv	a3,s3
    800055aa:	e1840613          	addi	a2,s0,-488
    800055ae:	4581                	li	a1,0
    800055b0:	8526                	mv	a0,s1
    800055b2:	fffff097          	auipc	ra,0xfffff
    800055b6:	a6e080e7          	jalr	-1426(ra) # 80004020 <readi>
    800055ba:	03800793          	li	a5,56
    800055be:	f8f514e3          	bne	a0,a5,80005546 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800055c2:	e1842783          	lw	a5,-488(s0)
    800055c6:	4705                	li	a4,1
    800055c8:	fce796e3          	bne	a5,a4,80005594 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800055cc:	e4043903          	ld	s2,-448(s0)
    800055d0:	e3843783          	ld	a5,-456(s0)
    800055d4:	f8f966e3          	bltu	s2,a5,80005560 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800055d8:	e2843783          	ld	a5,-472(s0)
    800055dc:	993e                	add	s2,s2,a5
    800055de:	f8f964e3          	bltu	s2,a5,80005566 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800055e2:	df043703          	ld	a4,-528(s0)
    800055e6:	8ff9                	and	a5,a5,a4
    800055e8:	f3d1                	bnez	a5,8000556c <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800055ea:	e1c42503          	lw	a0,-484(s0)
    800055ee:	00000097          	auipc	ra,0x0
    800055f2:	c78080e7          	jalr	-904(ra) # 80005266 <flags2perm>
    800055f6:	86aa                	mv	a3,a0
    800055f8:	864a                	mv	a2,s2
    800055fa:	85d2                	mv	a1,s4
    800055fc:	855e                	mv	a0,s7
    800055fe:	ffffc097          	auipc	ra,0xffffc
    80005602:	f64080e7          	jalr	-156(ra) # 80001562 <uvmalloc>
    80005606:	e0a43423          	sd	a0,-504(s0)
    8000560a:	d525                	beqz	a0,80005572 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000560c:	e2843d03          	ld	s10,-472(s0)
    80005610:	e2042d83          	lw	s11,-480(s0)
    80005614:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005618:	f60c0ce3          	beqz	s8,80005590 <exec+0x30e>
    8000561c:	8a62                	mv	s4,s8
    8000561e:	4901                	li	s2,0
    80005620:	b369                	j	800053aa <exec+0x128>

0000000080005622 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005622:	7179                	addi	sp,sp,-48
    80005624:	f406                	sd	ra,40(sp)
    80005626:	f022                	sd	s0,32(sp)
    80005628:	ec26                	sd	s1,24(sp)
    8000562a:	e84a                	sd	s2,16(sp)
    8000562c:	1800                	addi	s0,sp,48
    8000562e:	892e                	mv	s2,a1
    80005630:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005632:	fdc40593          	addi	a1,s0,-36
    80005636:	ffffe097          	auipc	ra,0xffffe
    8000563a:	9e0080e7          	jalr	-1568(ra) # 80003016 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000563e:	fdc42703          	lw	a4,-36(s0)
    80005642:	47bd                	li	a5,15
    80005644:	02e7eb63          	bltu	a5,a4,8000567a <argfd+0x58>
    80005648:	ffffc097          	auipc	ra,0xffffc
    8000564c:	508080e7          	jalr	1288(ra) # 80001b50 <myproc>
    80005650:	fdc42703          	lw	a4,-36(s0)
    80005654:	01c70793          	addi	a5,a4,28
    80005658:	078e                	slli	a5,a5,0x3
    8000565a:	953e                	add	a0,a0,a5
    8000565c:	611c                	ld	a5,0(a0)
    8000565e:	c385                	beqz	a5,8000567e <argfd+0x5c>
    return -1;
  if(pfd)
    80005660:	00090463          	beqz	s2,80005668 <argfd+0x46>
    *pfd = fd;
    80005664:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005668:	4501                	li	a0,0
  if(pf)
    8000566a:	c091                	beqz	s1,8000566e <argfd+0x4c>
    *pf = f;
    8000566c:	e09c                	sd	a5,0(s1)
}
    8000566e:	70a2                	ld	ra,40(sp)
    80005670:	7402                	ld	s0,32(sp)
    80005672:	64e2                	ld	s1,24(sp)
    80005674:	6942                	ld	s2,16(sp)
    80005676:	6145                	addi	sp,sp,48
    80005678:	8082                	ret
    return -1;
    8000567a:	557d                	li	a0,-1
    8000567c:	bfcd                	j	8000566e <argfd+0x4c>
    8000567e:	557d                	li	a0,-1
    80005680:	b7fd                	j	8000566e <argfd+0x4c>

0000000080005682 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005682:	1101                	addi	sp,sp,-32
    80005684:	ec06                	sd	ra,24(sp)
    80005686:	e822                	sd	s0,16(sp)
    80005688:	e426                	sd	s1,8(sp)
    8000568a:	1000                	addi	s0,sp,32
    8000568c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000568e:	ffffc097          	auipc	ra,0xffffc
    80005692:	4c2080e7          	jalr	1218(ra) # 80001b50 <myproc>
    80005696:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005698:	0e050793          	addi	a5,a0,224 # fffffffffffff0e0 <end+0xffffffff7fdb5338>
    8000569c:	4501                	li	a0,0
    8000569e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800056a0:	6398                	ld	a4,0(a5)
    800056a2:	cb19                	beqz	a4,800056b8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800056a4:	2505                	addiw	a0,a0,1
    800056a6:	07a1                	addi	a5,a5,8
    800056a8:	fed51ce3          	bne	a0,a3,800056a0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056ac:	557d                	li	a0,-1
}
    800056ae:	60e2                	ld	ra,24(sp)
    800056b0:	6442                	ld	s0,16(sp)
    800056b2:	64a2                	ld	s1,8(sp)
    800056b4:	6105                	addi	sp,sp,32
    800056b6:	8082                	ret
      p->ofile[fd] = f;
    800056b8:	01c50793          	addi	a5,a0,28
    800056bc:	078e                	slli	a5,a5,0x3
    800056be:	963e                	add	a2,a2,a5
    800056c0:	e204                	sd	s1,0(a2)
      return fd;
    800056c2:	b7f5                	j	800056ae <fdalloc+0x2c>

00000000800056c4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800056c4:	715d                	addi	sp,sp,-80
    800056c6:	e486                	sd	ra,72(sp)
    800056c8:	e0a2                	sd	s0,64(sp)
    800056ca:	fc26                	sd	s1,56(sp)
    800056cc:	f84a                	sd	s2,48(sp)
    800056ce:	f44e                	sd	s3,40(sp)
    800056d0:	f052                	sd	s4,32(sp)
    800056d2:	ec56                	sd	s5,24(sp)
    800056d4:	e85a                	sd	s6,16(sp)
    800056d6:	0880                	addi	s0,sp,80
    800056d8:	8b2e                	mv	s6,a1
    800056da:	89b2                	mv	s3,a2
    800056dc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800056de:	fb040593          	addi	a1,s0,-80
    800056e2:	fffff097          	auipc	ra,0xfffff
    800056e6:	e4e080e7          	jalr	-434(ra) # 80004530 <nameiparent>
    800056ea:	84aa                	mv	s1,a0
    800056ec:	16050063          	beqz	a0,8000584c <create+0x188>
    return 0;

  ilock(dp);
    800056f0:	ffffe097          	auipc	ra,0xffffe
    800056f4:	67c080e7          	jalr	1660(ra) # 80003d6c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800056f8:	4601                	li	a2,0
    800056fa:	fb040593          	addi	a1,s0,-80
    800056fe:	8526                	mv	a0,s1
    80005700:	fffff097          	auipc	ra,0xfffff
    80005704:	b50080e7          	jalr	-1200(ra) # 80004250 <dirlookup>
    80005708:	8aaa                	mv	s5,a0
    8000570a:	c931                	beqz	a0,8000575e <create+0x9a>
    iunlockput(dp);
    8000570c:	8526                	mv	a0,s1
    8000570e:	fffff097          	auipc	ra,0xfffff
    80005712:	8c0080e7          	jalr	-1856(ra) # 80003fce <iunlockput>
    ilock(ip);
    80005716:	8556                	mv	a0,s5
    80005718:	ffffe097          	auipc	ra,0xffffe
    8000571c:	654080e7          	jalr	1620(ra) # 80003d6c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005720:	000b059b          	sext.w	a1,s6
    80005724:	4789                	li	a5,2
    80005726:	02f59563          	bne	a1,a5,80005750 <create+0x8c>
    8000572a:	044ad783          	lhu	a5,68(s5)
    8000572e:	37f9                	addiw	a5,a5,-2
    80005730:	17c2                	slli	a5,a5,0x30
    80005732:	93c1                	srli	a5,a5,0x30
    80005734:	4705                	li	a4,1
    80005736:	00f76d63          	bltu	a4,a5,80005750 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000573a:	8556                	mv	a0,s5
    8000573c:	60a6                	ld	ra,72(sp)
    8000573e:	6406                	ld	s0,64(sp)
    80005740:	74e2                	ld	s1,56(sp)
    80005742:	7942                	ld	s2,48(sp)
    80005744:	79a2                	ld	s3,40(sp)
    80005746:	7a02                	ld	s4,32(sp)
    80005748:	6ae2                	ld	s5,24(sp)
    8000574a:	6b42                	ld	s6,16(sp)
    8000574c:	6161                	addi	sp,sp,80
    8000574e:	8082                	ret
    iunlockput(ip);
    80005750:	8556                	mv	a0,s5
    80005752:	fffff097          	auipc	ra,0xfffff
    80005756:	87c080e7          	jalr	-1924(ra) # 80003fce <iunlockput>
    return 0;
    8000575a:	4a81                	li	s5,0
    8000575c:	bff9                	j	8000573a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000575e:	85da                	mv	a1,s6
    80005760:	4088                	lw	a0,0(s1)
    80005762:	ffffe097          	auipc	ra,0xffffe
    80005766:	46e080e7          	jalr	1134(ra) # 80003bd0 <ialloc>
    8000576a:	8a2a                	mv	s4,a0
    8000576c:	c921                	beqz	a0,800057bc <create+0xf8>
  ilock(ip);
    8000576e:	ffffe097          	auipc	ra,0xffffe
    80005772:	5fe080e7          	jalr	1534(ra) # 80003d6c <ilock>
  ip->major = major;
    80005776:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000577a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000577e:	4785                	li	a5,1
    80005780:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80005784:	8552                	mv	a0,s4
    80005786:	ffffe097          	auipc	ra,0xffffe
    8000578a:	51c080e7          	jalr	1308(ra) # 80003ca2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000578e:	000b059b          	sext.w	a1,s6
    80005792:	4785                	li	a5,1
    80005794:	02f58b63          	beq	a1,a5,800057ca <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80005798:	004a2603          	lw	a2,4(s4)
    8000579c:	fb040593          	addi	a1,s0,-80
    800057a0:	8526                	mv	a0,s1
    800057a2:	fffff097          	auipc	ra,0xfffff
    800057a6:	cbe080e7          	jalr	-834(ra) # 80004460 <dirlink>
    800057aa:	06054f63          	bltz	a0,80005828 <create+0x164>
  iunlockput(dp);
    800057ae:	8526                	mv	a0,s1
    800057b0:	fffff097          	auipc	ra,0xfffff
    800057b4:	81e080e7          	jalr	-2018(ra) # 80003fce <iunlockput>
  return ip;
    800057b8:	8ad2                	mv	s5,s4
    800057ba:	b741                	j	8000573a <create+0x76>
    iunlockput(dp);
    800057bc:	8526                	mv	a0,s1
    800057be:	fffff097          	auipc	ra,0xfffff
    800057c2:	810080e7          	jalr	-2032(ra) # 80003fce <iunlockput>
    return 0;
    800057c6:	8ad2                	mv	s5,s4
    800057c8:	bf8d                	j	8000573a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057ca:	004a2603          	lw	a2,4(s4)
    800057ce:	00003597          	auipc	a1,0x3
    800057d2:	1aa58593          	addi	a1,a1,426 # 80008978 <syscall_list+0x300>
    800057d6:	8552                	mv	a0,s4
    800057d8:	fffff097          	auipc	ra,0xfffff
    800057dc:	c88080e7          	jalr	-888(ra) # 80004460 <dirlink>
    800057e0:	04054463          	bltz	a0,80005828 <create+0x164>
    800057e4:	40d0                	lw	a2,4(s1)
    800057e6:	00003597          	auipc	a1,0x3
    800057ea:	19a58593          	addi	a1,a1,410 # 80008980 <syscall_list+0x308>
    800057ee:	8552                	mv	a0,s4
    800057f0:	fffff097          	auipc	ra,0xfffff
    800057f4:	c70080e7          	jalr	-912(ra) # 80004460 <dirlink>
    800057f8:	02054863          	bltz	a0,80005828 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800057fc:	004a2603          	lw	a2,4(s4)
    80005800:	fb040593          	addi	a1,s0,-80
    80005804:	8526                	mv	a0,s1
    80005806:	fffff097          	auipc	ra,0xfffff
    8000580a:	c5a080e7          	jalr	-934(ra) # 80004460 <dirlink>
    8000580e:	00054d63          	bltz	a0,80005828 <create+0x164>
    dp->nlink++;  // for ".."
    80005812:	04a4d783          	lhu	a5,74(s1)
    80005816:	2785                	addiw	a5,a5,1
    80005818:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000581c:	8526                	mv	a0,s1
    8000581e:	ffffe097          	auipc	ra,0xffffe
    80005822:	484080e7          	jalr	1156(ra) # 80003ca2 <iupdate>
    80005826:	b761                	j	800057ae <create+0xea>
  ip->nlink = 0;
    80005828:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000582c:	8552                	mv	a0,s4
    8000582e:	ffffe097          	auipc	ra,0xffffe
    80005832:	474080e7          	jalr	1140(ra) # 80003ca2 <iupdate>
  iunlockput(ip);
    80005836:	8552                	mv	a0,s4
    80005838:	ffffe097          	auipc	ra,0xffffe
    8000583c:	796080e7          	jalr	1942(ra) # 80003fce <iunlockput>
  iunlockput(dp);
    80005840:	8526                	mv	a0,s1
    80005842:	ffffe097          	auipc	ra,0xffffe
    80005846:	78c080e7          	jalr	1932(ra) # 80003fce <iunlockput>
  return 0;
    8000584a:	bdc5                	j	8000573a <create+0x76>
    return 0;
    8000584c:	8aaa                	mv	s5,a0
    8000584e:	b5f5                	j	8000573a <create+0x76>

0000000080005850 <sys_dup>:
{
    80005850:	7179                	addi	sp,sp,-48
    80005852:	f406                	sd	ra,40(sp)
    80005854:	f022                	sd	s0,32(sp)
    80005856:	ec26                	sd	s1,24(sp)
    80005858:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000585a:	fd840613          	addi	a2,s0,-40
    8000585e:	4581                	li	a1,0
    80005860:	4501                	li	a0,0
    80005862:	00000097          	auipc	ra,0x0
    80005866:	dc0080e7          	jalr	-576(ra) # 80005622 <argfd>
    return -1;
    8000586a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000586c:	02054363          	bltz	a0,80005892 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005870:	fd843503          	ld	a0,-40(s0)
    80005874:	00000097          	auipc	ra,0x0
    80005878:	e0e080e7          	jalr	-498(ra) # 80005682 <fdalloc>
    8000587c:	84aa                	mv	s1,a0
    return -1;
    8000587e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005880:	00054963          	bltz	a0,80005892 <sys_dup+0x42>
  filedup(f);
    80005884:	fd843503          	ld	a0,-40(s0)
    80005888:	fffff097          	auipc	ra,0xfffff
    8000588c:	320080e7          	jalr	800(ra) # 80004ba8 <filedup>
  return fd;
    80005890:	87a6                	mv	a5,s1
}
    80005892:	853e                	mv	a0,a5
    80005894:	70a2                	ld	ra,40(sp)
    80005896:	7402                	ld	s0,32(sp)
    80005898:	64e2                	ld	s1,24(sp)
    8000589a:	6145                	addi	sp,sp,48
    8000589c:	8082                	ret

000000008000589e <sys_read>:
{
    8000589e:	7179                	addi	sp,sp,-48
    800058a0:	f406                	sd	ra,40(sp)
    800058a2:	f022                	sd	s0,32(sp)
    800058a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058a6:	fd840593          	addi	a1,s0,-40
    800058aa:	4505                	li	a0,1
    800058ac:	ffffd097          	auipc	ra,0xffffd
    800058b0:	78a080e7          	jalr	1930(ra) # 80003036 <argaddr>
  argint(2, &n);
    800058b4:	fe440593          	addi	a1,s0,-28
    800058b8:	4509                	li	a0,2
    800058ba:	ffffd097          	auipc	ra,0xffffd
    800058be:	75c080e7          	jalr	1884(ra) # 80003016 <argint>
  if(argfd(0, 0, &f) < 0)
    800058c2:	fe840613          	addi	a2,s0,-24
    800058c6:	4581                	li	a1,0
    800058c8:	4501                	li	a0,0
    800058ca:	00000097          	auipc	ra,0x0
    800058ce:	d58080e7          	jalr	-680(ra) # 80005622 <argfd>
    800058d2:	87aa                	mv	a5,a0
    return -1;
    800058d4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058d6:	0007cc63          	bltz	a5,800058ee <sys_read+0x50>
  return fileread(f, p, n);
    800058da:	fe442603          	lw	a2,-28(s0)
    800058de:	fd843583          	ld	a1,-40(s0)
    800058e2:	fe843503          	ld	a0,-24(s0)
    800058e6:	fffff097          	auipc	ra,0xfffff
    800058ea:	44e080e7          	jalr	1102(ra) # 80004d34 <fileread>
}
    800058ee:	70a2                	ld	ra,40(sp)
    800058f0:	7402                	ld	s0,32(sp)
    800058f2:	6145                	addi	sp,sp,48
    800058f4:	8082                	ret

00000000800058f6 <sys_write>:
{
    800058f6:	7179                	addi	sp,sp,-48
    800058f8:	f406                	sd	ra,40(sp)
    800058fa:	f022                	sd	s0,32(sp)
    800058fc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058fe:	fd840593          	addi	a1,s0,-40
    80005902:	4505                	li	a0,1
    80005904:	ffffd097          	auipc	ra,0xffffd
    80005908:	732080e7          	jalr	1842(ra) # 80003036 <argaddr>
  argint(2, &n);
    8000590c:	fe440593          	addi	a1,s0,-28
    80005910:	4509                	li	a0,2
    80005912:	ffffd097          	auipc	ra,0xffffd
    80005916:	704080e7          	jalr	1796(ra) # 80003016 <argint>
  if(argfd(0, 0, &f) < 0)
    8000591a:	fe840613          	addi	a2,s0,-24
    8000591e:	4581                	li	a1,0
    80005920:	4501                	li	a0,0
    80005922:	00000097          	auipc	ra,0x0
    80005926:	d00080e7          	jalr	-768(ra) # 80005622 <argfd>
    8000592a:	87aa                	mv	a5,a0
    return -1;
    8000592c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000592e:	0007cc63          	bltz	a5,80005946 <sys_write+0x50>
  return filewrite(f, p, n);
    80005932:	fe442603          	lw	a2,-28(s0)
    80005936:	fd843583          	ld	a1,-40(s0)
    8000593a:	fe843503          	ld	a0,-24(s0)
    8000593e:	fffff097          	auipc	ra,0xfffff
    80005942:	4b8080e7          	jalr	1208(ra) # 80004df6 <filewrite>
}
    80005946:	70a2                	ld	ra,40(sp)
    80005948:	7402                	ld	s0,32(sp)
    8000594a:	6145                	addi	sp,sp,48
    8000594c:	8082                	ret

000000008000594e <sys_close>:
{
    8000594e:	1101                	addi	sp,sp,-32
    80005950:	ec06                	sd	ra,24(sp)
    80005952:	e822                	sd	s0,16(sp)
    80005954:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005956:	fe040613          	addi	a2,s0,-32
    8000595a:	fec40593          	addi	a1,s0,-20
    8000595e:	4501                	li	a0,0
    80005960:	00000097          	auipc	ra,0x0
    80005964:	cc2080e7          	jalr	-830(ra) # 80005622 <argfd>
    return -1;
    80005968:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000596a:	02054463          	bltz	a0,80005992 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000596e:	ffffc097          	auipc	ra,0xffffc
    80005972:	1e2080e7          	jalr	482(ra) # 80001b50 <myproc>
    80005976:	fec42783          	lw	a5,-20(s0)
    8000597a:	07f1                	addi	a5,a5,28
    8000597c:	078e                	slli	a5,a5,0x3
    8000597e:	97aa                	add	a5,a5,a0
    80005980:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005984:	fe043503          	ld	a0,-32(s0)
    80005988:	fffff097          	auipc	ra,0xfffff
    8000598c:	272080e7          	jalr	626(ra) # 80004bfa <fileclose>
  return 0;
    80005990:	4781                	li	a5,0
}
    80005992:	853e                	mv	a0,a5
    80005994:	60e2                	ld	ra,24(sp)
    80005996:	6442                	ld	s0,16(sp)
    80005998:	6105                	addi	sp,sp,32
    8000599a:	8082                	ret

000000008000599c <sys_fstat>:
{
    8000599c:	1101                	addi	sp,sp,-32
    8000599e:	ec06                	sd	ra,24(sp)
    800059a0:	e822                	sd	s0,16(sp)
    800059a2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800059a4:	fe040593          	addi	a1,s0,-32
    800059a8:	4505                	li	a0,1
    800059aa:	ffffd097          	auipc	ra,0xffffd
    800059ae:	68c080e7          	jalr	1676(ra) # 80003036 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800059b2:	fe840613          	addi	a2,s0,-24
    800059b6:	4581                	li	a1,0
    800059b8:	4501                	li	a0,0
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	c68080e7          	jalr	-920(ra) # 80005622 <argfd>
    800059c2:	87aa                	mv	a5,a0
    return -1;
    800059c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800059c6:	0007ca63          	bltz	a5,800059da <sys_fstat+0x3e>
  return filestat(f, st);
    800059ca:	fe043583          	ld	a1,-32(s0)
    800059ce:	fe843503          	ld	a0,-24(s0)
    800059d2:	fffff097          	auipc	ra,0xfffff
    800059d6:	2f0080e7          	jalr	752(ra) # 80004cc2 <filestat>
}
    800059da:	60e2                	ld	ra,24(sp)
    800059dc:	6442                	ld	s0,16(sp)
    800059de:	6105                	addi	sp,sp,32
    800059e0:	8082                	ret

00000000800059e2 <sys_link>:
{
    800059e2:	7169                	addi	sp,sp,-304
    800059e4:	f606                	sd	ra,296(sp)
    800059e6:	f222                	sd	s0,288(sp)
    800059e8:	ee26                	sd	s1,280(sp)
    800059ea:	ea4a                	sd	s2,272(sp)
    800059ec:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059ee:	08000613          	li	a2,128
    800059f2:	ed040593          	addi	a1,s0,-304
    800059f6:	4501                	li	a0,0
    800059f8:	ffffd097          	auipc	ra,0xffffd
    800059fc:	65e080e7          	jalr	1630(ra) # 80003056 <argstr>
    return -1;
    80005a00:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a02:	10054e63          	bltz	a0,80005b1e <sys_link+0x13c>
    80005a06:	08000613          	li	a2,128
    80005a0a:	f5040593          	addi	a1,s0,-176
    80005a0e:	4505                	li	a0,1
    80005a10:	ffffd097          	auipc	ra,0xffffd
    80005a14:	646080e7          	jalr	1606(ra) # 80003056 <argstr>
    return -1;
    80005a18:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a1a:	10054263          	bltz	a0,80005b1e <sys_link+0x13c>
  begin_op();
    80005a1e:	fffff097          	auipc	ra,0xfffff
    80005a22:	d10080e7          	jalr	-752(ra) # 8000472e <begin_op>
  if((ip = namei(old)) == 0){
    80005a26:	ed040513          	addi	a0,s0,-304
    80005a2a:	fffff097          	auipc	ra,0xfffff
    80005a2e:	ae8080e7          	jalr	-1304(ra) # 80004512 <namei>
    80005a32:	84aa                	mv	s1,a0
    80005a34:	c551                	beqz	a0,80005ac0 <sys_link+0xde>
  ilock(ip);
    80005a36:	ffffe097          	auipc	ra,0xffffe
    80005a3a:	336080e7          	jalr	822(ra) # 80003d6c <ilock>
  if(ip->type == T_DIR){
    80005a3e:	04449703          	lh	a4,68(s1)
    80005a42:	4785                	li	a5,1
    80005a44:	08f70463          	beq	a4,a5,80005acc <sys_link+0xea>
  ip->nlink++;
    80005a48:	04a4d783          	lhu	a5,74(s1)
    80005a4c:	2785                	addiw	a5,a5,1
    80005a4e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a52:	8526                	mv	a0,s1
    80005a54:	ffffe097          	auipc	ra,0xffffe
    80005a58:	24e080e7          	jalr	590(ra) # 80003ca2 <iupdate>
  iunlock(ip);
    80005a5c:	8526                	mv	a0,s1
    80005a5e:	ffffe097          	auipc	ra,0xffffe
    80005a62:	3d0080e7          	jalr	976(ra) # 80003e2e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005a66:	fd040593          	addi	a1,s0,-48
    80005a6a:	f5040513          	addi	a0,s0,-176
    80005a6e:	fffff097          	auipc	ra,0xfffff
    80005a72:	ac2080e7          	jalr	-1342(ra) # 80004530 <nameiparent>
    80005a76:	892a                	mv	s2,a0
    80005a78:	c935                	beqz	a0,80005aec <sys_link+0x10a>
  ilock(dp);
    80005a7a:	ffffe097          	auipc	ra,0xffffe
    80005a7e:	2f2080e7          	jalr	754(ra) # 80003d6c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a82:	00092703          	lw	a4,0(s2)
    80005a86:	409c                	lw	a5,0(s1)
    80005a88:	04f71d63          	bne	a4,a5,80005ae2 <sys_link+0x100>
    80005a8c:	40d0                	lw	a2,4(s1)
    80005a8e:	fd040593          	addi	a1,s0,-48
    80005a92:	854a                	mv	a0,s2
    80005a94:	fffff097          	auipc	ra,0xfffff
    80005a98:	9cc080e7          	jalr	-1588(ra) # 80004460 <dirlink>
    80005a9c:	04054363          	bltz	a0,80005ae2 <sys_link+0x100>
  iunlockput(dp);
    80005aa0:	854a                	mv	a0,s2
    80005aa2:	ffffe097          	auipc	ra,0xffffe
    80005aa6:	52c080e7          	jalr	1324(ra) # 80003fce <iunlockput>
  iput(ip);
    80005aaa:	8526                	mv	a0,s1
    80005aac:	ffffe097          	auipc	ra,0xffffe
    80005ab0:	47a080e7          	jalr	1146(ra) # 80003f26 <iput>
  end_op();
    80005ab4:	fffff097          	auipc	ra,0xfffff
    80005ab8:	cfa080e7          	jalr	-774(ra) # 800047ae <end_op>
  return 0;
    80005abc:	4781                	li	a5,0
    80005abe:	a085                	j	80005b1e <sys_link+0x13c>
    end_op();
    80005ac0:	fffff097          	auipc	ra,0xfffff
    80005ac4:	cee080e7          	jalr	-786(ra) # 800047ae <end_op>
    return -1;
    80005ac8:	57fd                	li	a5,-1
    80005aca:	a891                	j	80005b1e <sys_link+0x13c>
    iunlockput(ip);
    80005acc:	8526                	mv	a0,s1
    80005ace:	ffffe097          	auipc	ra,0xffffe
    80005ad2:	500080e7          	jalr	1280(ra) # 80003fce <iunlockput>
    end_op();
    80005ad6:	fffff097          	auipc	ra,0xfffff
    80005ada:	cd8080e7          	jalr	-808(ra) # 800047ae <end_op>
    return -1;
    80005ade:	57fd                	li	a5,-1
    80005ae0:	a83d                	j	80005b1e <sys_link+0x13c>
    iunlockput(dp);
    80005ae2:	854a                	mv	a0,s2
    80005ae4:	ffffe097          	auipc	ra,0xffffe
    80005ae8:	4ea080e7          	jalr	1258(ra) # 80003fce <iunlockput>
  ilock(ip);
    80005aec:	8526                	mv	a0,s1
    80005aee:	ffffe097          	auipc	ra,0xffffe
    80005af2:	27e080e7          	jalr	638(ra) # 80003d6c <ilock>
  ip->nlink--;
    80005af6:	04a4d783          	lhu	a5,74(s1)
    80005afa:	37fd                	addiw	a5,a5,-1
    80005afc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b00:	8526                	mv	a0,s1
    80005b02:	ffffe097          	auipc	ra,0xffffe
    80005b06:	1a0080e7          	jalr	416(ra) # 80003ca2 <iupdate>
  iunlockput(ip);
    80005b0a:	8526                	mv	a0,s1
    80005b0c:	ffffe097          	auipc	ra,0xffffe
    80005b10:	4c2080e7          	jalr	1218(ra) # 80003fce <iunlockput>
  end_op();
    80005b14:	fffff097          	auipc	ra,0xfffff
    80005b18:	c9a080e7          	jalr	-870(ra) # 800047ae <end_op>
  return -1;
    80005b1c:	57fd                	li	a5,-1
}
    80005b1e:	853e                	mv	a0,a5
    80005b20:	70b2                	ld	ra,296(sp)
    80005b22:	7412                	ld	s0,288(sp)
    80005b24:	64f2                	ld	s1,280(sp)
    80005b26:	6952                	ld	s2,272(sp)
    80005b28:	6155                	addi	sp,sp,304
    80005b2a:	8082                	ret

0000000080005b2c <sys_unlink>:
{
    80005b2c:	7151                	addi	sp,sp,-240
    80005b2e:	f586                	sd	ra,232(sp)
    80005b30:	f1a2                	sd	s0,224(sp)
    80005b32:	eda6                	sd	s1,216(sp)
    80005b34:	e9ca                	sd	s2,208(sp)
    80005b36:	e5ce                	sd	s3,200(sp)
    80005b38:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005b3a:	08000613          	li	a2,128
    80005b3e:	f3040593          	addi	a1,s0,-208
    80005b42:	4501                	li	a0,0
    80005b44:	ffffd097          	auipc	ra,0xffffd
    80005b48:	512080e7          	jalr	1298(ra) # 80003056 <argstr>
    80005b4c:	18054163          	bltz	a0,80005cce <sys_unlink+0x1a2>
  begin_op();
    80005b50:	fffff097          	auipc	ra,0xfffff
    80005b54:	bde080e7          	jalr	-1058(ra) # 8000472e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b58:	fb040593          	addi	a1,s0,-80
    80005b5c:	f3040513          	addi	a0,s0,-208
    80005b60:	fffff097          	auipc	ra,0xfffff
    80005b64:	9d0080e7          	jalr	-1584(ra) # 80004530 <nameiparent>
    80005b68:	84aa                	mv	s1,a0
    80005b6a:	c979                	beqz	a0,80005c40 <sys_unlink+0x114>
  ilock(dp);
    80005b6c:	ffffe097          	auipc	ra,0xffffe
    80005b70:	200080e7          	jalr	512(ra) # 80003d6c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b74:	00003597          	auipc	a1,0x3
    80005b78:	e0458593          	addi	a1,a1,-508 # 80008978 <syscall_list+0x300>
    80005b7c:	fb040513          	addi	a0,s0,-80
    80005b80:	ffffe097          	auipc	ra,0xffffe
    80005b84:	6b6080e7          	jalr	1718(ra) # 80004236 <namecmp>
    80005b88:	14050a63          	beqz	a0,80005cdc <sys_unlink+0x1b0>
    80005b8c:	00003597          	auipc	a1,0x3
    80005b90:	df458593          	addi	a1,a1,-524 # 80008980 <syscall_list+0x308>
    80005b94:	fb040513          	addi	a0,s0,-80
    80005b98:	ffffe097          	auipc	ra,0xffffe
    80005b9c:	69e080e7          	jalr	1694(ra) # 80004236 <namecmp>
    80005ba0:	12050e63          	beqz	a0,80005cdc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ba4:	f2c40613          	addi	a2,s0,-212
    80005ba8:	fb040593          	addi	a1,s0,-80
    80005bac:	8526                	mv	a0,s1
    80005bae:	ffffe097          	auipc	ra,0xffffe
    80005bb2:	6a2080e7          	jalr	1698(ra) # 80004250 <dirlookup>
    80005bb6:	892a                	mv	s2,a0
    80005bb8:	12050263          	beqz	a0,80005cdc <sys_unlink+0x1b0>
  ilock(ip);
    80005bbc:	ffffe097          	auipc	ra,0xffffe
    80005bc0:	1b0080e7          	jalr	432(ra) # 80003d6c <ilock>
  if(ip->nlink < 1)
    80005bc4:	04a91783          	lh	a5,74(s2)
    80005bc8:	08f05263          	blez	a5,80005c4c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005bcc:	04491703          	lh	a4,68(s2)
    80005bd0:	4785                	li	a5,1
    80005bd2:	08f70563          	beq	a4,a5,80005c5c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005bd6:	4641                	li	a2,16
    80005bd8:	4581                	li	a1,0
    80005bda:	fc040513          	addi	a0,s0,-64
    80005bde:	ffffb097          	auipc	ra,0xffffb
    80005be2:	23e080e7          	jalr	574(ra) # 80000e1c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005be6:	4741                	li	a4,16
    80005be8:	f2c42683          	lw	a3,-212(s0)
    80005bec:	fc040613          	addi	a2,s0,-64
    80005bf0:	4581                	li	a1,0
    80005bf2:	8526                	mv	a0,s1
    80005bf4:	ffffe097          	auipc	ra,0xffffe
    80005bf8:	524080e7          	jalr	1316(ra) # 80004118 <writei>
    80005bfc:	47c1                	li	a5,16
    80005bfe:	0af51563          	bne	a0,a5,80005ca8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005c02:	04491703          	lh	a4,68(s2)
    80005c06:	4785                	li	a5,1
    80005c08:	0af70863          	beq	a4,a5,80005cb8 <sys_unlink+0x18c>
  iunlockput(dp);
    80005c0c:	8526                	mv	a0,s1
    80005c0e:	ffffe097          	auipc	ra,0xffffe
    80005c12:	3c0080e7          	jalr	960(ra) # 80003fce <iunlockput>
  ip->nlink--;
    80005c16:	04a95783          	lhu	a5,74(s2)
    80005c1a:	37fd                	addiw	a5,a5,-1
    80005c1c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c20:	854a                	mv	a0,s2
    80005c22:	ffffe097          	auipc	ra,0xffffe
    80005c26:	080080e7          	jalr	128(ra) # 80003ca2 <iupdate>
  iunlockput(ip);
    80005c2a:	854a                	mv	a0,s2
    80005c2c:	ffffe097          	auipc	ra,0xffffe
    80005c30:	3a2080e7          	jalr	930(ra) # 80003fce <iunlockput>
  end_op();
    80005c34:	fffff097          	auipc	ra,0xfffff
    80005c38:	b7a080e7          	jalr	-1158(ra) # 800047ae <end_op>
  return 0;
    80005c3c:	4501                	li	a0,0
    80005c3e:	a84d                	j	80005cf0 <sys_unlink+0x1c4>
    end_op();
    80005c40:	fffff097          	auipc	ra,0xfffff
    80005c44:	b6e080e7          	jalr	-1170(ra) # 800047ae <end_op>
    return -1;
    80005c48:	557d                	li	a0,-1
    80005c4a:	a05d                	j	80005cf0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005c4c:	00003517          	auipc	a0,0x3
    80005c50:	d3c50513          	addi	a0,a0,-708 # 80008988 <syscall_list+0x310>
    80005c54:	ffffb097          	auipc	ra,0xffffb
    80005c58:	8f0080e7          	jalr	-1808(ra) # 80000544 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c5c:	04c92703          	lw	a4,76(s2)
    80005c60:	02000793          	li	a5,32
    80005c64:	f6e7f9e3          	bgeu	a5,a4,80005bd6 <sys_unlink+0xaa>
    80005c68:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c6c:	4741                	li	a4,16
    80005c6e:	86ce                	mv	a3,s3
    80005c70:	f1840613          	addi	a2,s0,-232
    80005c74:	4581                	li	a1,0
    80005c76:	854a                	mv	a0,s2
    80005c78:	ffffe097          	auipc	ra,0xffffe
    80005c7c:	3a8080e7          	jalr	936(ra) # 80004020 <readi>
    80005c80:	47c1                	li	a5,16
    80005c82:	00f51b63          	bne	a0,a5,80005c98 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005c86:	f1845783          	lhu	a5,-232(s0)
    80005c8a:	e7a1                	bnez	a5,80005cd2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c8c:	29c1                	addiw	s3,s3,16
    80005c8e:	04c92783          	lw	a5,76(s2)
    80005c92:	fcf9ede3          	bltu	s3,a5,80005c6c <sys_unlink+0x140>
    80005c96:	b781                	j	80005bd6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005c98:	00003517          	auipc	a0,0x3
    80005c9c:	d0850513          	addi	a0,a0,-760 # 800089a0 <syscall_list+0x328>
    80005ca0:	ffffb097          	auipc	ra,0xffffb
    80005ca4:	8a4080e7          	jalr	-1884(ra) # 80000544 <panic>
    panic("unlink: writei");
    80005ca8:	00003517          	auipc	a0,0x3
    80005cac:	d1050513          	addi	a0,a0,-752 # 800089b8 <syscall_list+0x340>
    80005cb0:	ffffb097          	auipc	ra,0xffffb
    80005cb4:	894080e7          	jalr	-1900(ra) # 80000544 <panic>
    dp->nlink--;
    80005cb8:	04a4d783          	lhu	a5,74(s1)
    80005cbc:	37fd                	addiw	a5,a5,-1
    80005cbe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005cc2:	8526                	mv	a0,s1
    80005cc4:	ffffe097          	auipc	ra,0xffffe
    80005cc8:	fde080e7          	jalr	-34(ra) # 80003ca2 <iupdate>
    80005ccc:	b781                	j	80005c0c <sys_unlink+0xe0>
    return -1;
    80005cce:	557d                	li	a0,-1
    80005cd0:	a005                	j	80005cf0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005cd2:	854a                	mv	a0,s2
    80005cd4:	ffffe097          	auipc	ra,0xffffe
    80005cd8:	2fa080e7          	jalr	762(ra) # 80003fce <iunlockput>
  iunlockput(dp);
    80005cdc:	8526                	mv	a0,s1
    80005cde:	ffffe097          	auipc	ra,0xffffe
    80005ce2:	2f0080e7          	jalr	752(ra) # 80003fce <iunlockput>
  end_op();
    80005ce6:	fffff097          	auipc	ra,0xfffff
    80005cea:	ac8080e7          	jalr	-1336(ra) # 800047ae <end_op>
  return -1;
    80005cee:	557d                	li	a0,-1
}
    80005cf0:	70ae                	ld	ra,232(sp)
    80005cf2:	740e                	ld	s0,224(sp)
    80005cf4:	64ee                	ld	s1,216(sp)
    80005cf6:	694e                	ld	s2,208(sp)
    80005cf8:	69ae                	ld	s3,200(sp)
    80005cfa:	616d                	addi	sp,sp,240
    80005cfc:	8082                	ret

0000000080005cfe <sys_open>:

uint64
sys_open(void)
{
    80005cfe:	7131                	addi	sp,sp,-192
    80005d00:	fd06                	sd	ra,184(sp)
    80005d02:	f922                	sd	s0,176(sp)
    80005d04:	f526                	sd	s1,168(sp)
    80005d06:	f14a                	sd	s2,160(sp)
    80005d08:	ed4e                	sd	s3,152(sp)
    80005d0a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d0c:	f4c40593          	addi	a1,s0,-180
    80005d10:	4505                	li	a0,1
    80005d12:	ffffd097          	auipc	ra,0xffffd
    80005d16:	304080e7          	jalr	772(ra) # 80003016 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d1a:	08000613          	li	a2,128
    80005d1e:	f5040593          	addi	a1,s0,-176
    80005d22:	4501                	li	a0,0
    80005d24:	ffffd097          	auipc	ra,0xffffd
    80005d28:	332080e7          	jalr	818(ra) # 80003056 <argstr>
    80005d2c:	87aa                	mv	a5,a0
    return -1;
    80005d2e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d30:	0a07c963          	bltz	a5,80005de2 <sys_open+0xe4>

  begin_op();
    80005d34:	fffff097          	auipc	ra,0xfffff
    80005d38:	9fa080e7          	jalr	-1542(ra) # 8000472e <begin_op>

  if(omode & O_CREATE){
    80005d3c:	f4c42783          	lw	a5,-180(s0)
    80005d40:	2007f793          	andi	a5,a5,512
    80005d44:	cfc5                	beqz	a5,80005dfc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005d46:	4681                	li	a3,0
    80005d48:	4601                	li	a2,0
    80005d4a:	4589                	li	a1,2
    80005d4c:	f5040513          	addi	a0,s0,-176
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	974080e7          	jalr	-1676(ra) # 800056c4 <create>
    80005d58:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d5a:	c959                	beqz	a0,80005df0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d5c:	04449703          	lh	a4,68(s1)
    80005d60:	478d                	li	a5,3
    80005d62:	00f71763          	bne	a4,a5,80005d70 <sys_open+0x72>
    80005d66:	0464d703          	lhu	a4,70(s1)
    80005d6a:	47a5                	li	a5,9
    80005d6c:	0ce7ed63          	bltu	a5,a4,80005e46 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005d70:	fffff097          	auipc	ra,0xfffff
    80005d74:	dce080e7          	jalr	-562(ra) # 80004b3e <filealloc>
    80005d78:	89aa                	mv	s3,a0
    80005d7a:	10050363          	beqz	a0,80005e80 <sys_open+0x182>
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	904080e7          	jalr	-1788(ra) # 80005682 <fdalloc>
    80005d86:	892a                	mv	s2,a0
    80005d88:	0e054763          	bltz	a0,80005e76 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005d8c:	04449703          	lh	a4,68(s1)
    80005d90:	478d                	li	a5,3
    80005d92:	0cf70563          	beq	a4,a5,80005e5c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005d96:	4789                	li	a5,2
    80005d98:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005d9c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005da0:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005da4:	f4c42783          	lw	a5,-180(s0)
    80005da8:	0017c713          	xori	a4,a5,1
    80005dac:	8b05                	andi	a4,a4,1
    80005dae:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005db2:	0037f713          	andi	a4,a5,3
    80005db6:	00e03733          	snez	a4,a4
    80005dba:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005dbe:	4007f793          	andi	a5,a5,1024
    80005dc2:	c791                	beqz	a5,80005dce <sys_open+0xd0>
    80005dc4:	04449703          	lh	a4,68(s1)
    80005dc8:	4789                	li	a5,2
    80005dca:	0af70063          	beq	a4,a5,80005e6a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005dce:	8526                	mv	a0,s1
    80005dd0:	ffffe097          	auipc	ra,0xffffe
    80005dd4:	05e080e7          	jalr	94(ra) # 80003e2e <iunlock>
  end_op();
    80005dd8:	fffff097          	auipc	ra,0xfffff
    80005ddc:	9d6080e7          	jalr	-1578(ra) # 800047ae <end_op>

  return fd;
    80005de0:	854a                	mv	a0,s2
}
    80005de2:	70ea                	ld	ra,184(sp)
    80005de4:	744a                	ld	s0,176(sp)
    80005de6:	74aa                	ld	s1,168(sp)
    80005de8:	790a                	ld	s2,160(sp)
    80005dea:	69ea                	ld	s3,152(sp)
    80005dec:	6129                	addi	sp,sp,192
    80005dee:	8082                	ret
      end_op();
    80005df0:	fffff097          	auipc	ra,0xfffff
    80005df4:	9be080e7          	jalr	-1602(ra) # 800047ae <end_op>
      return -1;
    80005df8:	557d                	li	a0,-1
    80005dfa:	b7e5                	j	80005de2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005dfc:	f5040513          	addi	a0,s0,-176
    80005e00:	ffffe097          	auipc	ra,0xffffe
    80005e04:	712080e7          	jalr	1810(ra) # 80004512 <namei>
    80005e08:	84aa                	mv	s1,a0
    80005e0a:	c905                	beqz	a0,80005e3a <sys_open+0x13c>
    ilock(ip);
    80005e0c:	ffffe097          	auipc	ra,0xffffe
    80005e10:	f60080e7          	jalr	-160(ra) # 80003d6c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e14:	04449703          	lh	a4,68(s1)
    80005e18:	4785                	li	a5,1
    80005e1a:	f4f711e3          	bne	a4,a5,80005d5c <sys_open+0x5e>
    80005e1e:	f4c42783          	lw	a5,-180(s0)
    80005e22:	d7b9                	beqz	a5,80005d70 <sys_open+0x72>
      iunlockput(ip);
    80005e24:	8526                	mv	a0,s1
    80005e26:	ffffe097          	auipc	ra,0xffffe
    80005e2a:	1a8080e7          	jalr	424(ra) # 80003fce <iunlockput>
      end_op();
    80005e2e:	fffff097          	auipc	ra,0xfffff
    80005e32:	980080e7          	jalr	-1664(ra) # 800047ae <end_op>
      return -1;
    80005e36:	557d                	li	a0,-1
    80005e38:	b76d                	j	80005de2 <sys_open+0xe4>
      end_op();
    80005e3a:	fffff097          	auipc	ra,0xfffff
    80005e3e:	974080e7          	jalr	-1676(ra) # 800047ae <end_op>
      return -1;
    80005e42:	557d                	li	a0,-1
    80005e44:	bf79                	j	80005de2 <sys_open+0xe4>
    iunlockput(ip);
    80005e46:	8526                	mv	a0,s1
    80005e48:	ffffe097          	auipc	ra,0xffffe
    80005e4c:	186080e7          	jalr	390(ra) # 80003fce <iunlockput>
    end_op();
    80005e50:	fffff097          	auipc	ra,0xfffff
    80005e54:	95e080e7          	jalr	-1698(ra) # 800047ae <end_op>
    return -1;
    80005e58:	557d                	li	a0,-1
    80005e5a:	b761                	j	80005de2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005e5c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005e60:	04649783          	lh	a5,70(s1)
    80005e64:	02f99223          	sh	a5,36(s3)
    80005e68:	bf25                	j	80005da0 <sys_open+0xa2>
    itrunc(ip);
    80005e6a:	8526                	mv	a0,s1
    80005e6c:	ffffe097          	auipc	ra,0xffffe
    80005e70:	00e080e7          	jalr	14(ra) # 80003e7a <itrunc>
    80005e74:	bfa9                	j	80005dce <sys_open+0xd0>
      fileclose(f);
    80005e76:	854e                	mv	a0,s3
    80005e78:	fffff097          	auipc	ra,0xfffff
    80005e7c:	d82080e7          	jalr	-638(ra) # 80004bfa <fileclose>
    iunlockput(ip);
    80005e80:	8526                	mv	a0,s1
    80005e82:	ffffe097          	auipc	ra,0xffffe
    80005e86:	14c080e7          	jalr	332(ra) # 80003fce <iunlockput>
    end_op();
    80005e8a:	fffff097          	auipc	ra,0xfffff
    80005e8e:	924080e7          	jalr	-1756(ra) # 800047ae <end_op>
    return -1;
    80005e92:	557d                	li	a0,-1
    80005e94:	b7b9                	j	80005de2 <sys_open+0xe4>

0000000080005e96 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005e96:	7175                	addi	sp,sp,-144
    80005e98:	e506                	sd	ra,136(sp)
    80005e9a:	e122                	sd	s0,128(sp)
    80005e9c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e9e:	fffff097          	auipc	ra,0xfffff
    80005ea2:	890080e7          	jalr	-1904(ra) # 8000472e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ea6:	08000613          	li	a2,128
    80005eaa:	f7040593          	addi	a1,s0,-144
    80005eae:	4501                	li	a0,0
    80005eb0:	ffffd097          	auipc	ra,0xffffd
    80005eb4:	1a6080e7          	jalr	422(ra) # 80003056 <argstr>
    80005eb8:	02054963          	bltz	a0,80005eea <sys_mkdir+0x54>
    80005ebc:	4681                	li	a3,0
    80005ebe:	4601                	li	a2,0
    80005ec0:	4585                	li	a1,1
    80005ec2:	f7040513          	addi	a0,s0,-144
    80005ec6:	fffff097          	auipc	ra,0xfffff
    80005eca:	7fe080e7          	jalr	2046(ra) # 800056c4 <create>
    80005ece:	cd11                	beqz	a0,80005eea <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ed0:	ffffe097          	auipc	ra,0xffffe
    80005ed4:	0fe080e7          	jalr	254(ra) # 80003fce <iunlockput>
  end_op();
    80005ed8:	fffff097          	auipc	ra,0xfffff
    80005edc:	8d6080e7          	jalr	-1834(ra) # 800047ae <end_op>
  return 0;
    80005ee0:	4501                	li	a0,0
}
    80005ee2:	60aa                	ld	ra,136(sp)
    80005ee4:	640a                	ld	s0,128(sp)
    80005ee6:	6149                	addi	sp,sp,144
    80005ee8:	8082                	ret
    end_op();
    80005eea:	fffff097          	auipc	ra,0xfffff
    80005eee:	8c4080e7          	jalr	-1852(ra) # 800047ae <end_op>
    return -1;
    80005ef2:	557d                	li	a0,-1
    80005ef4:	b7fd                	j	80005ee2 <sys_mkdir+0x4c>

0000000080005ef6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005ef6:	7135                	addi	sp,sp,-160
    80005ef8:	ed06                	sd	ra,152(sp)
    80005efa:	e922                	sd	s0,144(sp)
    80005efc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005efe:	fffff097          	auipc	ra,0xfffff
    80005f02:	830080e7          	jalr	-2000(ra) # 8000472e <begin_op>
  argint(1, &major);
    80005f06:	f6c40593          	addi	a1,s0,-148
    80005f0a:	4505                	li	a0,1
    80005f0c:	ffffd097          	auipc	ra,0xffffd
    80005f10:	10a080e7          	jalr	266(ra) # 80003016 <argint>
  argint(2, &minor);
    80005f14:	f6840593          	addi	a1,s0,-152
    80005f18:	4509                	li	a0,2
    80005f1a:	ffffd097          	auipc	ra,0xffffd
    80005f1e:	0fc080e7          	jalr	252(ra) # 80003016 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f22:	08000613          	li	a2,128
    80005f26:	f7040593          	addi	a1,s0,-144
    80005f2a:	4501                	li	a0,0
    80005f2c:	ffffd097          	auipc	ra,0xffffd
    80005f30:	12a080e7          	jalr	298(ra) # 80003056 <argstr>
    80005f34:	02054b63          	bltz	a0,80005f6a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f38:	f6841683          	lh	a3,-152(s0)
    80005f3c:	f6c41603          	lh	a2,-148(s0)
    80005f40:	458d                	li	a1,3
    80005f42:	f7040513          	addi	a0,s0,-144
    80005f46:	fffff097          	auipc	ra,0xfffff
    80005f4a:	77e080e7          	jalr	1918(ra) # 800056c4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f4e:	cd11                	beqz	a0,80005f6a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f50:	ffffe097          	auipc	ra,0xffffe
    80005f54:	07e080e7          	jalr	126(ra) # 80003fce <iunlockput>
  end_op();
    80005f58:	fffff097          	auipc	ra,0xfffff
    80005f5c:	856080e7          	jalr	-1962(ra) # 800047ae <end_op>
  return 0;
    80005f60:	4501                	li	a0,0
}
    80005f62:	60ea                	ld	ra,152(sp)
    80005f64:	644a                	ld	s0,144(sp)
    80005f66:	610d                	addi	sp,sp,160
    80005f68:	8082                	ret
    end_op();
    80005f6a:	fffff097          	auipc	ra,0xfffff
    80005f6e:	844080e7          	jalr	-1980(ra) # 800047ae <end_op>
    return -1;
    80005f72:	557d                	li	a0,-1
    80005f74:	b7fd                	j	80005f62 <sys_mknod+0x6c>

0000000080005f76 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005f76:	7135                	addi	sp,sp,-160
    80005f78:	ed06                	sd	ra,152(sp)
    80005f7a:	e922                	sd	s0,144(sp)
    80005f7c:	e526                	sd	s1,136(sp)
    80005f7e:	e14a                	sd	s2,128(sp)
    80005f80:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005f82:	ffffc097          	auipc	ra,0xffffc
    80005f86:	bce080e7          	jalr	-1074(ra) # 80001b50 <myproc>
    80005f8a:	892a                	mv	s2,a0
  
  begin_op();
    80005f8c:	ffffe097          	auipc	ra,0xffffe
    80005f90:	7a2080e7          	jalr	1954(ra) # 8000472e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005f94:	08000613          	li	a2,128
    80005f98:	f6040593          	addi	a1,s0,-160
    80005f9c:	4501                	li	a0,0
    80005f9e:	ffffd097          	auipc	ra,0xffffd
    80005fa2:	0b8080e7          	jalr	184(ra) # 80003056 <argstr>
    80005fa6:	04054b63          	bltz	a0,80005ffc <sys_chdir+0x86>
    80005faa:	f6040513          	addi	a0,s0,-160
    80005fae:	ffffe097          	auipc	ra,0xffffe
    80005fb2:	564080e7          	jalr	1380(ra) # 80004512 <namei>
    80005fb6:	84aa                	mv	s1,a0
    80005fb8:	c131                	beqz	a0,80005ffc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005fba:	ffffe097          	auipc	ra,0xffffe
    80005fbe:	db2080e7          	jalr	-590(ra) # 80003d6c <ilock>
  if(ip->type != T_DIR){
    80005fc2:	04449703          	lh	a4,68(s1)
    80005fc6:	4785                	li	a5,1
    80005fc8:	04f71063          	bne	a4,a5,80006008 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005fcc:	8526                	mv	a0,s1
    80005fce:	ffffe097          	auipc	ra,0xffffe
    80005fd2:	e60080e7          	jalr	-416(ra) # 80003e2e <iunlock>
  iput(p->cwd);
    80005fd6:	16093503          	ld	a0,352(s2)
    80005fda:	ffffe097          	auipc	ra,0xffffe
    80005fde:	f4c080e7          	jalr	-180(ra) # 80003f26 <iput>
  end_op();
    80005fe2:	ffffe097          	auipc	ra,0xffffe
    80005fe6:	7cc080e7          	jalr	1996(ra) # 800047ae <end_op>
  p->cwd = ip;
    80005fea:	16993023          	sd	s1,352(s2)
  return 0;
    80005fee:	4501                	li	a0,0
}
    80005ff0:	60ea                	ld	ra,152(sp)
    80005ff2:	644a                	ld	s0,144(sp)
    80005ff4:	64aa                	ld	s1,136(sp)
    80005ff6:	690a                	ld	s2,128(sp)
    80005ff8:	610d                	addi	sp,sp,160
    80005ffa:	8082                	ret
    end_op();
    80005ffc:	ffffe097          	auipc	ra,0xffffe
    80006000:	7b2080e7          	jalr	1970(ra) # 800047ae <end_op>
    return -1;
    80006004:	557d                	li	a0,-1
    80006006:	b7ed                	j	80005ff0 <sys_chdir+0x7a>
    iunlockput(ip);
    80006008:	8526                	mv	a0,s1
    8000600a:	ffffe097          	auipc	ra,0xffffe
    8000600e:	fc4080e7          	jalr	-60(ra) # 80003fce <iunlockput>
    end_op();
    80006012:	ffffe097          	auipc	ra,0xffffe
    80006016:	79c080e7          	jalr	1948(ra) # 800047ae <end_op>
    return -1;
    8000601a:	557d                	li	a0,-1
    8000601c:	bfd1                	j	80005ff0 <sys_chdir+0x7a>

000000008000601e <sys_exec>:

uint64
sys_exec(void)
{
    8000601e:	7145                	addi	sp,sp,-464
    80006020:	e786                	sd	ra,456(sp)
    80006022:	e3a2                	sd	s0,448(sp)
    80006024:	ff26                	sd	s1,440(sp)
    80006026:	fb4a                	sd	s2,432(sp)
    80006028:	f74e                	sd	s3,424(sp)
    8000602a:	f352                	sd	s4,416(sp)
    8000602c:	ef56                	sd	s5,408(sp)
    8000602e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006030:	e3840593          	addi	a1,s0,-456
    80006034:	4505                	li	a0,1
    80006036:	ffffd097          	auipc	ra,0xffffd
    8000603a:	000080e7          	jalr	ra # 80003036 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000603e:	08000613          	li	a2,128
    80006042:	f4040593          	addi	a1,s0,-192
    80006046:	4501                	li	a0,0
    80006048:	ffffd097          	auipc	ra,0xffffd
    8000604c:	00e080e7          	jalr	14(ra) # 80003056 <argstr>
    80006050:	87aa                	mv	a5,a0
    return -1;
    80006052:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006054:	0c07c263          	bltz	a5,80006118 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006058:	10000613          	li	a2,256
    8000605c:	4581                	li	a1,0
    8000605e:	e4040513          	addi	a0,s0,-448
    80006062:	ffffb097          	auipc	ra,0xffffb
    80006066:	dba080e7          	jalr	-582(ra) # 80000e1c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000606a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000606e:	89a6                	mv	s3,s1
    80006070:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006072:	02000a13          	li	s4,32
    80006076:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000607a:	00391513          	slli	a0,s2,0x3
    8000607e:	e3040593          	addi	a1,s0,-464
    80006082:	e3843783          	ld	a5,-456(s0)
    80006086:	953e                	add	a0,a0,a5
    80006088:	ffffd097          	auipc	ra,0xffffd
    8000608c:	ef0080e7          	jalr	-272(ra) # 80002f78 <fetchaddr>
    80006090:	02054a63          	bltz	a0,800060c4 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80006094:	e3043783          	ld	a5,-464(s0)
    80006098:	c3b9                	beqz	a5,800060de <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000609a:	ffffb097          	auipc	ra,0xffffb
    8000609e:	b5e080e7          	jalr	-1186(ra) # 80000bf8 <kalloc>
    800060a2:	85aa                	mv	a1,a0
    800060a4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800060a8:	cd11                	beqz	a0,800060c4 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060aa:	6605                	lui	a2,0x1
    800060ac:	e3043503          	ld	a0,-464(s0)
    800060b0:	ffffd097          	auipc	ra,0xffffd
    800060b4:	f1a080e7          	jalr	-230(ra) # 80002fca <fetchstr>
    800060b8:	00054663          	bltz	a0,800060c4 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800060bc:	0905                	addi	s2,s2,1
    800060be:	09a1                	addi	s3,s3,8
    800060c0:	fb491be3          	bne	s2,s4,80006076 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060c4:	10048913          	addi	s2,s1,256
    800060c8:	6088                	ld	a0,0(s1)
    800060ca:	c531                	beqz	a0,80006116 <sys_exec+0xf8>
    kfree(argv[i]);
    800060cc:	ffffb097          	auipc	ra,0xffffb
    800060d0:	9aa080e7          	jalr	-1622(ra) # 80000a76 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060d4:	04a1                	addi	s1,s1,8
    800060d6:	ff2499e3          	bne	s1,s2,800060c8 <sys_exec+0xaa>
  return -1;
    800060da:	557d                	li	a0,-1
    800060dc:	a835                	j	80006118 <sys_exec+0xfa>
      argv[i] = 0;
    800060de:	0a8e                	slli	s5,s5,0x3
    800060e0:	fc040793          	addi	a5,s0,-64
    800060e4:	9abe                	add	s5,s5,a5
    800060e6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800060ea:	e4040593          	addi	a1,s0,-448
    800060ee:	f4040513          	addi	a0,s0,-192
    800060f2:	fffff097          	auipc	ra,0xfffff
    800060f6:	190080e7          	jalr	400(ra) # 80005282 <exec>
    800060fa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060fc:	10048993          	addi	s3,s1,256
    80006100:	6088                	ld	a0,0(s1)
    80006102:	c901                	beqz	a0,80006112 <sys_exec+0xf4>
    kfree(argv[i]);
    80006104:	ffffb097          	auipc	ra,0xffffb
    80006108:	972080e7          	jalr	-1678(ra) # 80000a76 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000610c:	04a1                	addi	s1,s1,8
    8000610e:	ff3499e3          	bne	s1,s3,80006100 <sys_exec+0xe2>
  return ret;
    80006112:	854a                	mv	a0,s2
    80006114:	a011                	j	80006118 <sys_exec+0xfa>
  return -1;
    80006116:	557d                	li	a0,-1
}
    80006118:	60be                	ld	ra,456(sp)
    8000611a:	641e                	ld	s0,448(sp)
    8000611c:	74fa                	ld	s1,440(sp)
    8000611e:	795a                	ld	s2,432(sp)
    80006120:	79ba                	ld	s3,424(sp)
    80006122:	7a1a                	ld	s4,416(sp)
    80006124:	6afa                	ld	s5,408(sp)
    80006126:	6179                	addi	sp,sp,464
    80006128:	8082                	ret

000000008000612a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000612a:	7139                	addi	sp,sp,-64
    8000612c:	fc06                	sd	ra,56(sp)
    8000612e:	f822                	sd	s0,48(sp)
    80006130:	f426                	sd	s1,40(sp)
    80006132:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006134:	ffffc097          	auipc	ra,0xffffc
    80006138:	a1c080e7          	jalr	-1508(ra) # 80001b50 <myproc>
    8000613c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000613e:	fd840593          	addi	a1,s0,-40
    80006142:	4501                	li	a0,0
    80006144:	ffffd097          	auipc	ra,0xffffd
    80006148:	ef2080e7          	jalr	-270(ra) # 80003036 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000614c:	fc840593          	addi	a1,s0,-56
    80006150:	fd040513          	addi	a0,s0,-48
    80006154:	fffff097          	auipc	ra,0xfffff
    80006158:	dd6080e7          	jalr	-554(ra) # 80004f2a <pipealloc>
    return -1;
    8000615c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000615e:	0c054463          	bltz	a0,80006226 <sys_pipe+0xfc>
  fd0 = -1;
    80006162:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006166:	fd043503          	ld	a0,-48(s0)
    8000616a:	fffff097          	auipc	ra,0xfffff
    8000616e:	518080e7          	jalr	1304(ra) # 80005682 <fdalloc>
    80006172:	fca42223          	sw	a0,-60(s0)
    80006176:	08054b63          	bltz	a0,8000620c <sys_pipe+0xe2>
    8000617a:	fc843503          	ld	a0,-56(s0)
    8000617e:	fffff097          	auipc	ra,0xfffff
    80006182:	504080e7          	jalr	1284(ra) # 80005682 <fdalloc>
    80006186:	fca42023          	sw	a0,-64(s0)
    8000618a:	06054863          	bltz	a0,800061fa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000618e:	4691                	li	a3,4
    80006190:	fc440613          	addi	a2,s0,-60
    80006194:	fd843583          	ld	a1,-40(s0)
    80006198:	70a8                	ld	a0,96(s1)
    8000619a:	ffffb097          	auipc	ra,0xffffb
    8000619e:	606080e7          	jalr	1542(ra) # 800017a0 <copyout>
    800061a2:	02054063          	bltz	a0,800061c2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800061a6:	4691                	li	a3,4
    800061a8:	fc040613          	addi	a2,s0,-64
    800061ac:	fd843583          	ld	a1,-40(s0)
    800061b0:	0591                	addi	a1,a1,4
    800061b2:	70a8                	ld	a0,96(s1)
    800061b4:	ffffb097          	auipc	ra,0xffffb
    800061b8:	5ec080e7          	jalr	1516(ra) # 800017a0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800061bc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061be:	06055463          	bgez	a0,80006226 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800061c2:	fc442783          	lw	a5,-60(s0)
    800061c6:	07f1                	addi	a5,a5,28
    800061c8:	078e                	slli	a5,a5,0x3
    800061ca:	97a6                	add	a5,a5,s1
    800061cc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800061d0:	fc042503          	lw	a0,-64(s0)
    800061d4:	0571                	addi	a0,a0,28
    800061d6:	050e                	slli	a0,a0,0x3
    800061d8:	94aa                	add	s1,s1,a0
    800061da:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800061de:	fd043503          	ld	a0,-48(s0)
    800061e2:	fffff097          	auipc	ra,0xfffff
    800061e6:	a18080e7          	jalr	-1512(ra) # 80004bfa <fileclose>
    fileclose(wf);
    800061ea:	fc843503          	ld	a0,-56(s0)
    800061ee:	fffff097          	auipc	ra,0xfffff
    800061f2:	a0c080e7          	jalr	-1524(ra) # 80004bfa <fileclose>
    return -1;
    800061f6:	57fd                	li	a5,-1
    800061f8:	a03d                	j	80006226 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800061fa:	fc442783          	lw	a5,-60(s0)
    800061fe:	0007c763          	bltz	a5,8000620c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006202:	07f1                	addi	a5,a5,28
    80006204:	078e                	slli	a5,a5,0x3
    80006206:	94be                	add	s1,s1,a5
    80006208:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000620c:	fd043503          	ld	a0,-48(s0)
    80006210:	fffff097          	auipc	ra,0xfffff
    80006214:	9ea080e7          	jalr	-1558(ra) # 80004bfa <fileclose>
    fileclose(wf);
    80006218:	fc843503          	ld	a0,-56(s0)
    8000621c:	fffff097          	auipc	ra,0xfffff
    80006220:	9de080e7          	jalr	-1570(ra) # 80004bfa <fileclose>
    return -1;
    80006224:	57fd                	li	a5,-1
}
    80006226:	853e                	mv	a0,a5
    80006228:	70e2                	ld	ra,56(sp)
    8000622a:	7442                	ld	s0,48(sp)
    8000622c:	74a2                	ld	s1,40(sp)
    8000622e:	6121                	addi	sp,sp,64
    80006230:	8082                	ret
	...

0000000080006240 <kernelvec>:
    80006240:	7111                	addi	sp,sp,-256
    80006242:	e006                	sd	ra,0(sp)
    80006244:	e40a                	sd	sp,8(sp)
    80006246:	e80e                	sd	gp,16(sp)
    80006248:	ec12                	sd	tp,24(sp)
    8000624a:	f016                	sd	t0,32(sp)
    8000624c:	f41a                	sd	t1,40(sp)
    8000624e:	f81e                	sd	t2,48(sp)
    80006250:	fc22                	sd	s0,56(sp)
    80006252:	e0a6                	sd	s1,64(sp)
    80006254:	e4aa                	sd	a0,72(sp)
    80006256:	e8ae                	sd	a1,80(sp)
    80006258:	ecb2                	sd	a2,88(sp)
    8000625a:	f0b6                	sd	a3,96(sp)
    8000625c:	f4ba                	sd	a4,104(sp)
    8000625e:	f8be                	sd	a5,112(sp)
    80006260:	fcc2                	sd	a6,120(sp)
    80006262:	e146                	sd	a7,128(sp)
    80006264:	e54a                	sd	s2,136(sp)
    80006266:	e94e                	sd	s3,144(sp)
    80006268:	ed52                	sd	s4,152(sp)
    8000626a:	f156                	sd	s5,160(sp)
    8000626c:	f55a                	sd	s6,168(sp)
    8000626e:	f95e                	sd	s7,176(sp)
    80006270:	fd62                	sd	s8,184(sp)
    80006272:	e1e6                	sd	s9,192(sp)
    80006274:	e5ea                	sd	s10,200(sp)
    80006276:	e9ee                	sd	s11,208(sp)
    80006278:	edf2                	sd	t3,216(sp)
    8000627a:	f1f6                	sd	t4,224(sp)
    8000627c:	f5fa                	sd	t5,232(sp)
    8000627e:	f9fe                	sd	t6,240(sp)
    80006280:	bc5fc0ef          	jal	ra,80002e44 <kerneltrap>
    80006284:	6082                	ld	ra,0(sp)
    80006286:	6122                	ld	sp,8(sp)
    80006288:	61c2                	ld	gp,16(sp)
    8000628a:	7282                	ld	t0,32(sp)
    8000628c:	7322                	ld	t1,40(sp)
    8000628e:	73c2                	ld	t2,48(sp)
    80006290:	7462                	ld	s0,56(sp)
    80006292:	6486                	ld	s1,64(sp)
    80006294:	6526                	ld	a0,72(sp)
    80006296:	65c6                	ld	a1,80(sp)
    80006298:	6666                	ld	a2,88(sp)
    8000629a:	7686                	ld	a3,96(sp)
    8000629c:	7726                	ld	a4,104(sp)
    8000629e:	77c6                	ld	a5,112(sp)
    800062a0:	7866                	ld	a6,120(sp)
    800062a2:	688a                	ld	a7,128(sp)
    800062a4:	692a                	ld	s2,136(sp)
    800062a6:	69ca                	ld	s3,144(sp)
    800062a8:	6a6a                	ld	s4,152(sp)
    800062aa:	7a8a                	ld	s5,160(sp)
    800062ac:	7b2a                	ld	s6,168(sp)
    800062ae:	7bca                	ld	s7,176(sp)
    800062b0:	7c6a                	ld	s8,184(sp)
    800062b2:	6c8e                	ld	s9,192(sp)
    800062b4:	6d2e                	ld	s10,200(sp)
    800062b6:	6dce                	ld	s11,208(sp)
    800062b8:	6e6e                	ld	t3,216(sp)
    800062ba:	7e8e                	ld	t4,224(sp)
    800062bc:	7f2e                	ld	t5,232(sp)
    800062be:	7fce                	ld	t6,240(sp)
    800062c0:	6111                	addi	sp,sp,256
    800062c2:	10200073          	sret
    800062c6:	00000013          	nop
    800062ca:	00000013          	nop
    800062ce:	0001                	nop

00000000800062d0 <timervec>:
    800062d0:	34051573          	csrrw	a0,mscratch,a0
    800062d4:	e10c                	sd	a1,0(a0)
    800062d6:	e510                	sd	a2,8(a0)
    800062d8:	e914                	sd	a3,16(a0)
    800062da:	6d0c                	ld	a1,24(a0)
    800062dc:	7110                	ld	a2,32(a0)
    800062de:	6194                	ld	a3,0(a1)
    800062e0:	96b2                	add	a3,a3,a2
    800062e2:	e194                	sd	a3,0(a1)
    800062e4:	4589                	li	a1,2
    800062e6:	14459073          	csrw	sip,a1
    800062ea:	6914                	ld	a3,16(a0)
    800062ec:	6510                	ld	a2,8(a0)
    800062ee:	610c                	ld	a1,0(a0)
    800062f0:	34051573          	csrrw	a0,mscratch,a0
    800062f4:	30200073          	mret
	...

00000000800062fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800062fa:	1141                	addi	sp,sp,-16
    800062fc:	e422                	sd	s0,8(sp)
    800062fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006300:	0c0007b7          	lui	a5,0xc000
    80006304:	4705                	li	a4,1
    80006306:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006308:	c3d8                	sw	a4,4(a5)
}
    8000630a:	6422                	ld	s0,8(sp)
    8000630c:	0141                	addi	sp,sp,16
    8000630e:	8082                	ret

0000000080006310 <plicinithart>:

void
plicinithart(void)
{
    80006310:	1141                	addi	sp,sp,-16
    80006312:	e406                	sd	ra,8(sp)
    80006314:	e022                	sd	s0,0(sp)
    80006316:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006318:	ffffc097          	auipc	ra,0xffffc
    8000631c:	80c080e7          	jalr	-2036(ra) # 80001b24 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006320:	0085171b          	slliw	a4,a0,0x8
    80006324:	0c0027b7          	lui	a5,0xc002
    80006328:	97ba                	add	a5,a5,a4
    8000632a:	40200713          	li	a4,1026
    8000632e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006332:	00d5151b          	slliw	a0,a0,0xd
    80006336:	0c2017b7          	lui	a5,0xc201
    8000633a:	953e                	add	a0,a0,a5
    8000633c:	00052023          	sw	zero,0(a0)
}
    80006340:	60a2                	ld	ra,8(sp)
    80006342:	6402                	ld	s0,0(sp)
    80006344:	0141                	addi	sp,sp,16
    80006346:	8082                	ret

0000000080006348 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006348:	1141                	addi	sp,sp,-16
    8000634a:	e406                	sd	ra,8(sp)
    8000634c:	e022                	sd	s0,0(sp)
    8000634e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006350:	ffffb097          	auipc	ra,0xffffb
    80006354:	7d4080e7          	jalr	2004(ra) # 80001b24 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006358:	00d5179b          	slliw	a5,a0,0xd
    8000635c:	0c201537          	lui	a0,0xc201
    80006360:	953e                	add	a0,a0,a5
  return irq;
}
    80006362:	4148                	lw	a0,4(a0)
    80006364:	60a2                	ld	ra,8(sp)
    80006366:	6402                	ld	s0,0(sp)
    80006368:	0141                	addi	sp,sp,16
    8000636a:	8082                	ret

000000008000636c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000636c:	1101                	addi	sp,sp,-32
    8000636e:	ec06                	sd	ra,24(sp)
    80006370:	e822                	sd	s0,16(sp)
    80006372:	e426                	sd	s1,8(sp)
    80006374:	1000                	addi	s0,sp,32
    80006376:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006378:	ffffb097          	auipc	ra,0xffffb
    8000637c:	7ac080e7          	jalr	1964(ra) # 80001b24 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006380:	00d5151b          	slliw	a0,a0,0xd
    80006384:	0c2017b7          	lui	a5,0xc201
    80006388:	97aa                	add	a5,a5,a0
    8000638a:	c3c4                	sw	s1,4(a5)
}
    8000638c:	60e2                	ld	ra,24(sp)
    8000638e:	6442                	ld	s0,16(sp)
    80006390:	64a2                	ld	s1,8(sp)
    80006392:	6105                	addi	sp,sp,32
    80006394:	8082                	ret

0000000080006396 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006396:	1141                	addi	sp,sp,-16
    80006398:	e406                	sd	ra,8(sp)
    8000639a:	e022                	sd	s0,0(sp)
    8000639c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000639e:	479d                	li	a5,7
    800063a0:	04a7cc63          	blt	a5,a0,800063f8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800063a4:	00242797          	auipc	a5,0x242
    800063a8:	54478793          	addi	a5,a5,1348 # 802488e8 <disk>
    800063ac:	97aa                	add	a5,a5,a0
    800063ae:	0187c783          	lbu	a5,24(a5)
    800063b2:	ebb9                	bnez	a5,80006408 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800063b4:	00451613          	slli	a2,a0,0x4
    800063b8:	00242797          	auipc	a5,0x242
    800063bc:	53078793          	addi	a5,a5,1328 # 802488e8 <disk>
    800063c0:	6394                	ld	a3,0(a5)
    800063c2:	96b2                	add	a3,a3,a2
    800063c4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800063c8:	6398                	ld	a4,0(a5)
    800063ca:	9732                	add	a4,a4,a2
    800063cc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800063d0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800063d4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800063d8:	953e                	add	a0,a0,a5
    800063da:	4785                	li	a5,1
    800063dc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800063e0:	00242517          	auipc	a0,0x242
    800063e4:	52050513          	addi	a0,a0,1312 # 80248900 <disk+0x18>
    800063e8:	ffffc097          	auipc	ra,0xffffc
    800063ec:	d2e080e7          	jalr	-722(ra) # 80002116 <wakeup>
}
    800063f0:	60a2                	ld	ra,8(sp)
    800063f2:	6402                	ld	s0,0(sp)
    800063f4:	0141                	addi	sp,sp,16
    800063f6:	8082                	ret
    panic("free_desc 1");
    800063f8:	00002517          	auipc	a0,0x2
    800063fc:	5d050513          	addi	a0,a0,1488 # 800089c8 <syscall_list+0x350>
    80006400:	ffffa097          	auipc	ra,0xffffa
    80006404:	144080e7          	jalr	324(ra) # 80000544 <panic>
    panic("free_desc 2");
    80006408:	00002517          	auipc	a0,0x2
    8000640c:	5d050513          	addi	a0,a0,1488 # 800089d8 <syscall_list+0x360>
    80006410:	ffffa097          	auipc	ra,0xffffa
    80006414:	134080e7          	jalr	308(ra) # 80000544 <panic>

0000000080006418 <virtio_disk_init>:
{
    80006418:	1101                	addi	sp,sp,-32
    8000641a:	ec06                	sd	ra,24(sp)
    8000641c:	e822                	sd	s0,16(sp)
    8000641e:	e426                	sd	s1,8(sp)
    80006420:	e04a                	sd	s2,0(sp)
    80006422:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006424:	00002597          	auipc	a1,0x2
    80006428:	5c458593          	addi	a1,a1,1476 # 800089e8 <syscall_list+0x370>
    8000642c:	00242517          	auipc	a0,0x242
    80006430:	5e450513          	addi	a0,a0,1508 # 80248a10 <disk+0x128>
    80006434:	ffffb097          	auipc	ra,0xffffb
    80006438:	85c080e7          	jalr	-1956(ra) # 80000c90 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000643c:	100017b7          	lui	a5,0x10001
    80006440:	4398                	lw	a4,0(a5)
    80006442:	2701                	sext.w	a4,a4
    80006444:	747277b7          	lui	a5,0x74727
    80006448:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000644c:	14f71e63          	bne	a4,a5,800065a8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006450:	100017b7          	lui	a5,0x10001
    80006454:	43dc                	lw	a5,4(a5)
    80006456:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006458:	4709                	li	a4,2
    8000645a:	14e79763          	bne	a5,a4,800065a8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000645e:	100017b7          	lui	a5,0x10001
    80006462:	479c                	lw	a5,8(a5)
    80006464:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006466:	14e79163          	bne	a5,a4,800065a8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000646a:	100017b7          	lui	a5,0x10001
    8000646e:	47d8                	lw	a4,12(a5)
    80006470:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006472:	554d47b7          	lui	a5,0x554d4
    80006476:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000647a:	12f71763          	bne	a4,a5,800065a8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000647e:	100017b7          	lui	a5,0x10001
    80006482:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006486:	4705                	li	a4,1
    80006488:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000648a:	470d                	li	a4,3
    8000648c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000648e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006490:	c7ffe737          	lui	a4,0xc7ffe
    80006494:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db49b7>
    80006498:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000649a:	2701                	sext.w	a4,a4
    8000649c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000649e:	472d                	li	a4,11
    800064a0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800064a2:	0707a903          	lw	s2,112(a5)
    800064a6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800064a8:	00897793          	andi	a5,s2,8
    800064ac:	10078663          	beqz	a5,800065b8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800064b0:	100017b7          	lui	a5,0x10001
    800064b4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800064b8:	43fc                	lw	a5,68(a5)
    800064ba:	2781                	sext.w	a5,a5
    800064bc:	10079663          	bnez	a5,800065c8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800064c0:	100017b7          	lui	a5,0x10001
    800064c4:	5bdc                	lw	a5,52(a5)
    800064c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800064c8:	10078863          	beqz	a5,800065d8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800064cc:	471d                	li	a4,7
    800064ce:	10f77d63          	bgeu	a4,a5,800065e8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800064d2:	ffffa097          	auipc	ra,0xffffa
    800064d6:	726080e7          	jalr	1830(ra) # 80000bf8 <kalloc>
    800064da:	00242497          	auipc	s1,0x242
    800064de:	40e48493          	addi	s1,s1,1038 # 802488e8 <disk>
    800064e2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800064e4:	ffffa097          	auipc	ra,0xffffa
    800064e8:	714080e7          	jalr	1812(ra) # 80000bf8 <kalloc>
    800064ec:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800064ee:	ffffa097          	auipc	ra,0xffffa
    800064f2:	70a080e7          	jalr	1802(ra) # 80000bf8 <kalloc>
    800064f6:	87aa                	mv	a5,a0
    800064f8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800064fa:	6088                	ld	a0,0(s1)
    800064fc:	cd75                	beqz	a0,800065f8 <virtio_disk_init+0x1e0>
    800064fe:	00242717          	auipc	a4,0x242
    80006502:	3f273703          	ld	a4,1010(a4) # 802488f0 <disk+0x8>
    80006506:	cb6d                	beqz	a4,800065f8 <virtio_disk_init+0x1e0>
    80006508:	cbe5                	beqz	a5,800065f8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000650a:	6605                	lui	a2,0x1
    8000650c:	4581                	li	a1,0
    8000650e:	ffffb097          	auipc	ra,0xffffb
    80006512:	90e080e7          	jalr	-1778(ra) # 80000e1c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006516:	00242497          	auipc	s1,0x242
    8000651a:	3d248493          	addi	s1,s1,978 # 802488e8 <disk>
    8000651e:	6605                	lui	a2,0x1
    80006520:	4581                	li	a1,0
    80006522:	6488                	ld	a0,8(s1)
    80006524:	ffffb097          	auipc	ra,0xffffb
    80006528:	8f8080e7          	jalr	-1800(ra) # 80000e1c <memset>
  memset(disk.used, 0, PGSIZE);
    8000652c:	6605                	lui	a2,0x1
    8000652e:	4581                	li	a1,0
    80006530:	6888                	ld	a0,16(s1)
    80006532:	ffffb097          	auipc	ra,0xffffb
    80006536:	8ea080e7          	jalr	-1814(ra) # 80000e1c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000653a:	100017b7          	lui	a5,0x10001
    8000653e:	4721                	li	a4,8
    80006540:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006542:	4098                	lw	a4,0(s1)
    80006544:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006548:	40d8                	lw	a4,4(s1)
    8000654a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000654e:	6498                	ld	a4,8(s1)
    80006550:	0007069b          	sext.w	a3,a4
    80006554:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006558:	9701                	srai	a4,a4,0x20
    8000655a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000655e:	6898                	ld	a4,16(s1)
    80006560:	0007069b          	sext.w	a3,a4
    80006564:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006568:	9701                	srai	a4,a4,0x20
    8000656a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000656e:	4685                	li	a3,1
    80006570:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80006572:	4705                	li	a4,1
    80006574:	00d48c23          	sb	a3,24(s1)
    80006578:	00e48ca3          	sb	a4,25(s1)
    8000657c:	00e48d23          	sb	a4,26(s1)
    80006580:	00e48da3          	sb	a4,27(s1)
    80006584:	00e48e23          	sb	a4,28(s1)
    80006588:	00e48ea3          	sb	a4,29(s1)
    8000658c:	00e48f23          	sb	a4,30(s1)
    80006590:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006594:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006598:	0727a823          	sw	s2,112(a5)
}
    8000659c:	60e2                	ld	ra,24(sp)
    8000659e:	6442                	ld	s0,16(sp)
    800065a0:	64a2                	ld	s1,8(sp)
    800065a2:	6902                	ld	s2,0(sp)
    800065a4:	6105                	addi	sp,sp,32
    800065a6:	8082                	ret
    panic("could not find virtio disk");
    800065a8:	00002517          	auipc	a0,0x2
    800065ac:	45050513          	addi	a0,a0,1104 # 800089f8 <syscall_list+0x380>
    800065b0:	ffffa097          	auipc	ra,0xffffa
    800065b4:	f94080e7          	jalr	-108(ra) # 80000544 <panic>
    panic("virtio disk FEATURES_OK unset");
    800065b8:	00002517          	auipc	a0,0x2
    800065bc:	46050513          	addi	a0,a0,1120 # 80008a18 <syscall_list+0x3a0>
    800065c0:	ffffa097          	auipc	ra,0xffffa
    800065c4:	f84080e7          	jalr	-124(ra) # 80000544 <panic>
    panic("virtio disk should not be ready");
    800065c8:	00002517          	auipc	a0,0x2
    800065cc:	47050513          	addi	a0,a0,1136 # 80008a38 <syscall_list+0x3c0>
    800065d0:	ffffa097          	auipc	ra,0xffffa
    800065d4:	f74080e7          	jalr	-140(ra) # 80000544 <panic>
    panic("virtio disk has no queue 0");
    800065d8:	00002517          	auipc	a0,0x2
    800065dc:	48050513          	addi	a0,a0,1152 # 80008a58 <syscall_list+0x3e0>
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	f64080e7          	jalr	-156(ra) # 80000544 <panic>
    panic("virtio disk max queue too short");
    800065e8:	00002517          	auipc	a0,0x2
    800065ec:	49050513          	addi	a0,a0,1168 # 80008a78 <syscall_list+0x400>
    800065f0:	ffffa097          	auipc	ra,0xffffa
    800065f4:	f54080e7          	jalr	-172(ra) # 80000544 <panic>
    panic("virtio disk kalloc");
    800065f8:	00002517          	auipc	a0,0x2
    800065fc:	4a050513          	addi	a0,a0,1184 # 80008a98 <syscall_list+0x420>
    80006600:	ffffa097          	auipc	ra,0xffffa
    80006604:	f44080e7          	jalr	-188(ra) # 80000544 <panic>

0000000080006608 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006608:	7159                	addi	sp,sp,-112
    8000660a:	f486                	sd	ra,104(sp)
    8000660c:	f0a2                	sd	s0,96(sp)
    8000660e:	eca6                	sd	s1,88(sp)
    80006610:	e8ca                	sd	s2,80(sp)
    80006612:	e4ce                	sd	s3,72(sp)
    80006614:	e0d2                	sd	s4,64(sp)
    80006616:	fc56                	sd	s5,56(sp)
    80006618:	f85a                	sd	s6,48(sp)
    8000661a:	f45e                	sd	s7,40(sp)
    8000661c:	f062                	sd	s8,32(sp)
    8000661e:	ec66                	sd	s9,24(sp)
    80006620:	e86a                	sd	s10,16(sp)
    80006622:	1880                	addi	s0,sp,112
    80006624:	892a                	mv	s2,a0
    80006626:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006628:	00c52c83          	lw	s9,12(a0)
    8000662c:	001c9c9b          	slliw	s9,s9,0x1
    80006630:	1c82                	slli	s9,s9,0x20
    80006632:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006636:	00242517          	auipc	a0,0x242
    8000663a:	3da50513          	addi	a0,a0,986 # 80248a10 <disk+0x128>
    8000663e:	ffffa097          	auipc	ra,0xffffa
    80006642:	6e2080e7          	jalr	1762(ra) # 80000d20 <acquire>
  for(int i = 0; i < 3; i++){
    80006646:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006648:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000664a:	00242b17          	auipc	s6,0x242
    8000664e:	29eb0b13          	addi	s6,s6,670 # 802488e8 <disk>
  for(int i = 0; i < 3; i++){
    80006652:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80006654:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006656:	00242c17          	auipc	s8,0x242
    8000665a:	3bac0c13          	addi	s8,s8,954 # 80248a10 <disk+0x128>
    8000665e:	a8b5                	j	800066da <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80006660:	00fb06b3          	add	a3,s6,a5
    80006664:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80006668:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000666a:	0207c563          	bltz	a5,80006694 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000666e:	2485                	addiw	s1,s1,1
    80006670:	0711                	addi	a4,a4,4
    80006672:	1f548a63          	beq	s1,s5,80006866 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80006676:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80006678:	00242697          	auipc	a3,0x242
    8000667c:	27068693          	addi	a3,a3,624 # 802488e8 <disk>
    80006680:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80006682:	0186c583          	lbu	a1,24(a3)
    80006686:	fde9                	bnez	a1,80006660 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006688:	2785                	addiw	a5,a5,1
    8000668a:	0685                	addi	a3,a3,1
    8000668c:	ff779be3          	bne	a5,s7,80006682 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80006690:	57fd                	li	a5,-1
    80006692:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80006694:	02905a63          	blez	s1,800066c8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80006698:	f9042503          	lw	a0,-112(s0)
    8000669c:	00000097          	auipc	ra,0x0
    800066a0:	cfa080e7          	jalr	-774(ra) # 80006396 <free_desc>
      for(int j = 0; j < i; j++)
    800066a4:	4785                	li	a5,1
    800066a6:	0297d163          	bge	a5,s1,800066c8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800066aa:	f9442503          	lw	a0,-108(s0)
    800066ae:	00000097          	auipc	ra,0x0
    800066b2:	ce8080e7          	jalr	-792(ra) # 80006396 <free_desc>
      for(int j = 0; j < i; j++)
    800066b6:	4789                	li	a5,2
    800066b8:	0097d863          	bge	a5,s1,800066c8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800066bc:	f9842503          	lw	a0,-104(s0)
    800066c0:	00000097          	auipc	ra,0x0
    800066c4:	cd6080e7          	jalr	-810(ra) # 80006396 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066c8:	85e2                	mv	a1,s8
    800066ca:	00242517          	auipc	a0,0x242
    800066ce:	23650513          	addi	a0,a0,566 # 80248900 <disk+0x18>
    800066d2:	ffffc097          	auipc	ra,0xffffc
    800066d6:	dc6080e7          	jalr	-570(ra) # 80002498 <sleep>
  for(int i = 0; i < 3; i++){
    800066da:	f9040713          	addi	a4,s0,-112
    800066de:	84ce                	mv	s1,s3
    800066e0:	bf59                	j	80006676 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800066e2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800066e6:	00479693          	slli	a3,a5,0x4
    800066ea:	00242797          	auipc	a5,0x242
    800066ee:	1fe78793          	addi	a5,a5,510 # 802488e8 <disk>
    800066f2:	97b6                	add	a5,a5,a3
    800066f4:	4685                	li	a3,1
    800066f6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800066f8:	00242597          	auipc	a1,0x242
    800066fc:	1f058593          	addi	a1,a1,496 # 802488e8 <disk>
    80006700:	00a60793          	addi	a5,a2,10
    80006704:	0792                	slli	a5,a5,0x4
    80006706:	97ae                	add	a5,a5,a1
    80006708:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000670c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006710:	f6070693          	addi	a3,a4,-160
    80006714:	619c                	ld	a5,0(a1)
    80006716:	97b6                	add	a5,a5,a3
    80006718:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000671a:	6188                	ld	a0,0(a1)
    8000671c:	96aa                	add	a3,a3,a0
    8000671e:	47c1                	li	a5,16
    80006720:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006722:	4785                	li	a5,1
    80006724:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006728:	f9442783          	lw	a5,-108(s0)
    8000672c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006730:	0792                	slli	a5,a5,0x4
    80006732:	953e                	add	a0,a0,a5
    80006734:	05890693          	addi	a3,s2,88
    80006738:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000673a:	6188                	ld	a0,0(a1)
    8000673c:	97aa                	add	a5,a5,a0
    8000673e:	40000693          	li	a3,1024
    80006742:	c794                	sw	a3,8(a5)
  if(write)
    80006744:	100d0d63          	beqz	s10,8000685e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006748:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000674c:	00c7d683          	lhu	a3,12(a5)
    80006750:	0016e693          	ori	a3,a3,1
    80006754:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80006758:	f9842583          	lw	a1,-104(s0)
    8000675c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006760:	00242697          	auipc	a3,0x242
    80006764:	18868693          	addi	a3,a3,392 # 802488e8 <disk>
    80006768:	00260793          	addi	a5,a2,2
    8000676c:	0792                	slli	a5,a5,0x4
    8000676e:	97b6                	add	a5,a5,a3
    80006770:	587d                	li	a6,-1
    80006772:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006776:	0592                	slli	a1,a1,0x4
    80006778:	952e                	add	a0,a0,a1
    8000677a:	f9070713          	addi	a4,a4,-112
    8000677e:	9736                	add	a4,a4,a3
    80006780:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80006782:	6298                	ld	a4,0(a3)
    80006784:	972e                	add	a4,a4,a1
    80006786:	4585                	li	a1,1
    80006788:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000678a:	4509                	li	a0,2
    8000678c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80006790:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006794:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006798:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000679c:	6698                	ld	a4,8(a3)
    8000679e:	00275783          	lhu	a5,2(a4)
    800067a2:	8b9d                	andi	a5,a5,7
    800067a4:	0786                	slli	a5,a5,0x1
    800067a6:	97ba                	add	a5,a5,a4
    800067a8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800067ac:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800067b0:	6698                	ld	a4,8(a3)
    800067b2:	00275783          	lhu	a5,2(a4)
    800067b6:	2785                	addiw	a5,a5,1
    800067b8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800067bc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800067c0:	100017b7          	lui	a5,0x10001
    800067c4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800067c8:	00492703          	lw	a4,4(s2)
    800067cc:	4785                	li	a5,1
    800067ce:	02f71163          	bne	a4,a5,800067f0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800067d2:	00242997          	auipc	s3,0x242
    800067d6:	23e98993          	addi	s3,s3,574 # 80248a10 <disk+0x128>
  while(b->disk == 1) {
    800067da:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800067dc:	85ce                	mv	a1,s3
    800067de:	854a                	mv	a0,s2
    800067e0:	ffffc097          	auipc	ra,0xffffc
    800067e4:	cb8080e7          	jalr	-840(ra) # 80002498 <sleep>
  while(b->disk == 1) {
    800067e8:	00492783          	lw	a5,4(s2)
    800067ec:	fe9788e3          	beq	a5,s1,800067dc <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800067f0:	f9042903          	lw	s2,-112(s0)
    800067f4:	00290793          	addi	a5,s2,2
    800067f8:	00479713          	slli	a4,a5,0x4
    800067fc:	00242797          	auipc	a5,0x242
    80006800:	0ec78793          	addi	a5,a5,236 # 802488e8 <disk>
    80006804:	97ba                	add	a5,a5,a4
    80006806:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000680a:	00242997          	auipc	s3,0x242
    8000680e:	0de98993          	addi	s3,s3,222 # 802488e8 <disk>
    80006812:	00491713          	slli	a4,s2,0x4
    80006816:	0009b783          	ld	a5,0(s3)
    8000681a:	97ba                	add	a5,a5,a4
    8000681c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006820:	854a                	mv	a0,s2
    80006822:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006826:	00000097          	auipc	ra,0x0
    8000682a:	b70080e7          	jalr	-1168(ra) # 80006396 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000682e:	8885                	andi	s1,s1,1
    80006830:	f0ed                	bnez	s1,80006812 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006832:	00242517          	auipc	a0,0x242
    80006836:	1de50513          	addi	a0,a0,478 # 80248a10 <disk+0x128>
    8000683a:	ffffa097          	auipc	ra,0xffffa
    8000683e:	59a080e7          	jalr	1434(ra) # 80000dd4 <release>
}
    80006842:	70a6                	ld	ra,104(sp)
    80006844:	7406                	ld	s0,96(sp)
    80006846:	64e6                	ld	s1,88(sp)
    80006848:	6946                	ld	s2,80(sp)
    8000684a:	69a6                	ld	s3,72(sp)
    8000684c:	6a06                	ld	s4,64(sp)
    8000684e:	7ae2                	ld	s5,56(sp)
    80006850:	7b42                	ld	s6,48(sp)
    80006852:	7ba2                	ld	s7,40(sp)
    80006854:	7c02                	ld	s8,32(sp)
    80006856:	6ce2                	ld	s9,24(sp)
    80006858:	6d42                	ld	s10,16(sp)
    8000685a:	6165                	addi	sp,sp,112
    8000685c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000685e:	4689                	li	a3,2
    80006860:	00d79623          	sh	a3,12(a5)
    80006864:	b5e5                	j	8000674c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006866:	f9042603          	lw	a2,-112(s0)
    8000686a:	00a60713          	addi	a4,a2,10
    8000686e:	0712                	slli	a4,a4,0x4
    80006870:	00242517          	auipc	a0,0x242
    80006874:	08050513          	addi	a0,a0,128 # 802488f0 <disk+0x8>
    80006878:	953a                	add	a0,a0,a4
  if(write)
    8000687a:	e60d14e3          	bnez	s10,800066e2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000687e:	00a60793          	addi	a5,a2,10
    80006882:	00479693          	slli	a3,a5,0x4
    80006886:	00242797          	auipc	a5,0x242
    8000688a:	06278793          	addi	a5,a5,98 # 802488e8 <disk>
    8000688e:	97b6                	add	a5,a5,a3
    80006890:	0007a423          	sw	zero,8(a5)
    80006894:	b595                	j	800066f8 <virtio_disk_rw+0xf0>

0000000080006896 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006896:	1101                	addi	sp,sp,-32
    80006898:	ec06                	sd	ra,24(sp)
    8000689a:	e822                	sd	s0,16(sp)
    8000689c:	e426                	sd	s1,8(sp)
    8000689e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800068a0:	00242497          	auipc	s1,0x242
    800068a4:	04848493          	addi	s1,s1,72 # 802488e8 <disk>
    800068a8:	00242517          	auipc	a0,0x242
    800068ac:	16850513          	addi	a0,a0,360 # 80248a10 <disk+0x128>
    800068b0:	ffffa097          	auipc	ra,0xffffa
    800068b4:	470080e7          	jalr	1136(ra) # 80000d20 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800068b8:	10001737          	lui	a4,0x10001
    800068bc:	533c                	lw	a5,96(a4)
    800068be:	8b8d                	andi	a5,a5,3
    800068c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800068c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800068c6:	689c                	ld	a5,16(s1)
    800068c8:	0204d703          	lhu	a4,32(s1)
    800068cc:	0027d783          	lhu	a5,2(a5)
    800068d0:	04f70863          	beq	a4,a5,80006920 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800068d4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800068d8:	6898                	ld	a4,16(s1)
    800068da:	0204d783          	lhu	a5,32(s1)
    800068de:	8b9d                	andi	a5,a5,7
    800068e0:	078e                	slli	a5,a5,0x3
    800068e2:	97ba                	add	a5,a5,a4
    800068e4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800068e6:	00278713          	addi	a4,a5,2
    800068ea:	0712                	slli	a4,a4,0x4
    800068ec:	9726                	add	a4,a4,s1
    800068ee:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800068f2:	e721                	bnez	a4,8000693a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800068f4:	0789                	addi	a5,a5,2
    800068f6:	0792                	slli	a5,a5,0x4
    800068f8:	97a6                	add	a5,a5,s1
    800068fa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800068fc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006900:	ffffc097          	auipc	ra,0xffffc
    80006904:	816080e7          	jalr	-2026(ra) # 80002116 <wakeup>

    disk.used_idx += 1;
    80006908:	0204d783          	lhu	a5,32(s1)
    8000690c:	2785                	addiw	a5,a5,1
    8000690e:	17c2                	slli	a5,a5,0x30
    80006910:	93c1                	srli	a5,a5,0x30
    80006912:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006916:	6898                	ld	a4,16(s1)
    80006918:	00275703          	lhu	a4,2(a4)
    8000691c:	faf71ce3          	bne	a4,a5,800068d4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006920:	00242517          	auipc	a0,0x242
    80006924:	0f050513          	addi	a0,a0,240 # 80248a10 <disk+0x128>
    80006928:	ffffa097          	auipc	ra,0xffffa
    8000692c:	4ac080e7          	jalr	1196(ra) # 80000dd4 <release>
}
    80006930:	60e2                	ld	ra,24(sp)
    80006932:	6442                	ld	s0,16(sp)
    80006934:	64a2                	ld	s1,8(sp)
    80006936:	6105                	addi	sp,sp,32
    80006938:	8082                	ret
      panic("virtio_disk_intr status");
    8000693a:	00002517          	auipc	a0,0x2
    8000693e:	17650513          	addi	a0,a0,374 # 80008ab0 <syscall_list+0x438>
    80006942:	ffffa097          	auipc	ra,0xffffa
    80006946:	c02080e7          	jalr	-1022(ra) # 80000544 <panic>

000000008000694a <sgenrand>:
static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void
sgenrand(unsigned long seed)
{
    8000694a:	1141                	addi	sp,sp,-16
    8000694c:	e422                	sd	s0,8(sp)
    8000694e:	0800                	addi	s0,sp,16
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
    80006950:	00242717          	auipc	a4,0x242
    80006954:	0d870713          	addi	a4,a4,216 # 80248a28 <mt>
    80006958:	1502                	slli	a0,a0,0x20
    8000695a:	9101                	srli	a0,a0,0x20
    8000695c:	e308                	sd	a0,0(a4)
    for (mti=1; mti<N; mti++)
    8000695e:	00243597          	auipc	a1,0x243
    80006962:	44258593          	addi	a1,a1,1090 # 80249da0 <mt+0x1378>
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
    80006966:	6645                	lui	a2,0x11
    80006968:	dcd60613          	addi	a2,a2,-563 # 10dcd <_entry-0x7ffef233>
    8000696c:	56fd                	li	a3,-1
    8000696e:	9281                	srli	a3,a3,0x20
    80006970:	631c                	ld	a5,0(a4)
    80006972:	02c787b3          	mul	a5,a5,a2
    80006976:	8ff5                	and	a5,a5,a3
    80006978:	e71c                	sd	a5,8(a4)
    for (mti=1; mti<N; mti++)
    8000697a:	0721                	addi	a4,a4,8
    8000697c:	feb71ae3          	bne	a4,a1,80006970 <sgenrand+0x26>
    80006980:	27000793          	li	a5,624
    80006984:	00002717          	auipc	a4,0x2
    80006988:	16f72223          	sw	a5,356(a4) # 80008ae8 <mti>
}
    8000698c:	6422                	ld	s0,8(sp)
    8000698e:	0141                	addi	sp,sp,16
    80006990:	8082                	ret

0000000080006992 <genrand>:

long /* for integer generation */
genrand()
{
    80006992:	1141                	addi	sp,sp,-16
    80006994:	e406                	sd	ra,8(sp)
    80006996:	e022                	sd	s0,0(sp)
    80006998:	0800                	addi	s0,sp,16
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
    8000699a:	00002797          	auipc	a5,0x2
    8000699e:	14e7a783          	lw	a5,334(a5) # 80008ae8 <mti>
    800069a2:	26f00713          	li	a4,623
    800069a6:	0ef75963          	bge	a4,a5,80006a98 <genrand+0x106>
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
    800069aa:	27100713          	li	a4,625
    800069ae:	12e78f63          	beq	a5,a4,80006aec <genrand+0x15a>
            sgenrand(4357); /* a default initial seed is used   */

        for (kk=0;kk<N-M;kk++) {
    800069b2:	00242817          	auipc	a6,0x242
    800069b6:	07680813          	addi	a6,a6,118 # 80248a28 <mt>
    800069ba:	00242e17          	auipc	t3,0x242
    800069be:	786e0e13          	addi	t3,t3,1926 # 80249140 <mt+0x718>
{
    800069c2:	8742                	mv	a4,a6
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    800069c4:	4885                	li	a7,1
    800069c6:	08fe                	slli	a7,a7,0x1f
    800069c8:	80000537          	lui	a0,0x80000
    800069cc:	fff54513          	not	a0,a0
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
    800069d0:	6585                	lui	a1,0x1
    800069d2:	c6858593          	addi	a1,a1,-920 # c68 <_entry-0x7ffff398>
    800069d6:	00002317          	auipc	t1,0x2
    800069da:	0f230313          	addi	t1,t1,242 # 80008ac8 <mag01.985>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    800069de:	631c                	ld	a5,0(a4)
    800069e0:	0117f7b3          	and	a5,a5,a7
    800069e4:	6714                	ld	a3,8(a4)
    800069e6:	8ee9                	and	a3,a3,a0
    800069e8:	8fd5                	or	a5,a5,a3
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
    800069ea:	00b70633          	add	a2,a4,a1
    800069ee:	0017d693          	srli	a3,a5,0x1
    800069f2:	6210                	ld	a2,0(a2)
    800069f4:	8eb1                	xor	a3,a3,a2
    800069f6:	8b85                	andi	a5,a5,1
    800069f8:	078e                	slli	a5,a5,0x3
    800069fa:	979a                	add	a5,a5,t1
    800069fc:	639c                	ld	a5,0(a5)
    800069fe:	8fb5                	xor	a5,a5,a3
    80006a00:	e31c                	sd	a5,0(a4)
        for (kk=0;kk<N-M;kk++) {
    80006a02:	0721                	addi	a4,a4,8
    80006a04:	fdc71de3          	bne	a4,t3,800069de <genrand+0x4c>
        }
        for (;kk<N-1;kk++) {
    80006a08:	6605                	lui	a2,0x1
    80006a0a:	c6060613          	addi	a2,a2,-928 # c60 <_entry-0x7ffff3a0>
    80006a0e:	9642                	add	a2,a2,a6
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    80006a10:	4505                	li	a0,1
    80006a12:	057e                	slli	a0,a0,0x1f
    80006a14:	800005b7          	lui	a1,0x80000
    80006a18:	fff5c593          	not	a1,a1
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
    80006a1c:	00002897          	auipc	a7,0x2
    80006a20:	0ac88893          	addi	a7,a7,172 # 80008ac8 <mag01.985>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    80006a24:	71883783          	ld	a5,1816(a6)
    80006a28:	8fe9                	and	a5,a5,a0
    80006a2a:	72083703          	ld	a4,1824(a6)
    80006a2e:	8f6d                	and	a4,a4,a1
    80006a30:	8fd9                	or	a5,a5,a4
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
    80006a32:	0017d713          	srli	a4,a5,0x1
    80006a36:	00083683          	ld	a3,0(a6)
    80006a3a:	8f35                	xor	a4,a4,a3
    80006a3c:	8b85                	andi	a5,a5,1
    80006a3e:	078e                	slli	a5,a5,0x3
    80006a40:	97c6                	add	a5,a5,a7
    80006a42:	639c                	ld	a5,0(a5)
    80006a44:	8fb9                	xor	a5,a5,a4
    80006a46:	70f83c23          	sd	a5,1816(a6)
        for (;kk<N-1;kk++) {
    80006a4a:	0821                	addi	a6,a6,8
    80006a4c:	fcc81ce3          	bne	a6,a2,80006a24 <genrand+0x92>
        }
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
    80006a50:	00243697          	auipc	a3,0x243
    80006a54:	fd868693          	addi	a3,a3,-40 # 80249a28 <mt+0x1000>
    80006a58:	3786b783          	ld	a5,888(a3)
    80006a5c:	4705                	li	a4,1
    80006a5e:	077e                	slli	a4,a4,0x1f
    80006a60:	8ff9                	and	a5,a5,a4
    80006a62:	00242717          	auipc	a4,0x242
    80006a66:	fc673703          	ld	a4,-58(a4) # 80248a28 <mt>
    80006a6a:	1706                	slli	a4,a4,0x21
    80006a6c:	9305                	srli	a4,a4,0x21
    80006a6e:	8fd9                	or	a5,a5,a4
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
    80006a70:	0017d713          	srli	a4,a5,0x1
    80006a74:	c606b603          	ld	a2,-928(a3)
    80006a78:	8f31                	xor	a4,a4,a2
    80006a7a:	8b85                	andi	a5,a5,1
    80006a7c:	078e                	slli	a5,a5,0x3
    80006a7e:	00002617          	auipc	a2,0x2
    80006a82:	04a60613          	addi	a2,a2,74 # 80008ac8 <mag01.985>
    80006a86:	97b2                	add	a5,a5,a2
    80006a88:	639c                	ld	a5,0(a5)
    80006a8a:	8fb9                	xor	a5,a5,a4
    80006a8c:	36f6bc23          	sd	a5,888(a3)

        mti = 0;
    80006a90:	00002797          	auipc	a5,0x2
    80006a94:	0407ac23          	sw	zero,88(a5) # 80008ae8 <mti>
    }
  
    y = mt[mti++];
    80006a98:	00002717          	auipc	a4,0x2
    80006a9c:	05070713          	addi	a4,a4,80 # 80008ae8 <mti>
    80006aa0:	431c                	lw	a5,0(a4)
    80006aa2:	0017869b          	addiw	a3,a5,1
    80006aa6:	c314                	sw	a3,0(a4)
    80006aa8:	078e                	slli	a5,a5,0x3
    80006aaa:	00242717          	auipc	a4,0x242
    80006aae:	f7e70713          	addi	a4,a4,-130 # 80248a28 <mt>
    80006ab2:	97ba                	add	a5,a5,a4
    80006ab4:	6398                	ld	a4,0(a5)
    y ^= TEMPERING_SHIFT_U(y);
    80006ab6:	00b75793          	srli	a5,a4,0xb
    80006aba:	8f3d                	xor	a4,a4,a5
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
    80006abc:	013a67b7          	lui	a5,0x13a6
    80006ac0:	8ad78793          	addi	a5,a5,-1875 # 13a58ad <_entry-0x7ec5a753>
    80006ac4:	8ff9                	and	a5,a5,a4
    80006ac6:	079e                	slli	a5,a5,0x7
    80006ac8:	8fb9                	xor	a5,a5,a4
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
    80006aca:	00f79713          	slli	a4,a5,0xf
    80006ace:	077e36b7          	lui	a3,0x77e3
    80006ad2:	0696                	slli	a3,a3,0x5
    80006ad4:	8f75                	and	a4,a4,a3
    80006ad6:	8fb9                	xor	a5,a5,a4
    y ^= TEMPERING_SHIFT_L(y);
    80006ad8:	0127d513          	srli	a0,a5,0x12
    80006adc:	8fa9                	xor	a5,a5,a0

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
    80006ade:	02179513          	slli	a0,a5,0x21
}
    80006ae2:	9105                	srli	a0,a0,0x21
    80006ae4:	60a2                	ld	ra,8(sp)
    80006ae6:	6402                	ld	s0,0(sp)
    80006ae8:	0141                	addi	sp,sp,16
    80006aea:	8082                	ret
            sgenrand(4357); /* a default initial seed is used   */
    80006aec:	6505                	lui	a0,0x1
    80006aee:	10550513          	addi	a0,a0,261 # 1105 <_entry-0x7fffeefb>
    80006af2:	00000097          	auipc	ra,0x0
    80006af6:	e58080e7          	jalr	-424(ra) # 8000694a <sgenrand>
    80006afa:	bd65                	j	800069b2 <genrand+0x20>

0000000080006afc <random_at_most>:

// Assumes 0 <= max <= RAND_MAX
// Returns in the half-open interval [0, max]
long random_at_most(long max) {
    80006afc:	1101                	addi	sp,sp,-32
    80006afe:	ec06                	sd	ra,24(sp)
    80006b00:	e822                	sd	s0,16(sp)
    80006b02:	e426                	sd	s1,8(sp)
    80006b04:	e04a                	sd	s2,0(sp)
    80006b06:	1000                	addi	s0,sp,32
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
    80006b08:	0505                	addi	a0,a0,1
    num_rand = (unsigned long) RAND_MAX + 1,
    bin_size = num_rand / num_bins,
    80006b0a:	4485                	li	s1,1
    80006b0c:	04fe                	slli	s1,s1,0x1f
    80006b0e:	02a4d933          	divu	s2,s1,a0
    defect   = num_rand % num_bins;
    80006b12:	02a4f533          	remu	a0,s1,a0
  long x;
  do {
   x = genrand();
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
    80006b16:	4485                	li	s1,1
    80006b18:	04fe                	slli	s1,s1,0x1f
    80006b1a:	8c89                	sub	s1,s1,a0
   x = genrand();
    80006b1c:	00000097          	auipc	ra,0x0
    80006b20:	e76080e7          	jalr	-394(ra) # 80006992 <genrand>
  while (num_rand - defect <= (unsigned long)x);
    80006b24:	fe957ce3          	bgeu	a0,s1,80006b1c <random_at_most+0x20>

  // Truncated division is intentional
  return x/bin_size;
    80006b28:	03255533          	divu	a0,a0,s2
    80006b2c:	60e2                	ld	ra,24(sp)
    80006b2e:	6442                	ld	s0,16(sp)
    80006b30:	64a2                	ld	s1,8(sp)
    80006b32:	6902                	ld	s2,0(sp)
    80006b34:	6105                	addi	sp,sp,32
    80006b36:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
