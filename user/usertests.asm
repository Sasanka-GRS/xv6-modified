
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c02080e7          	jalr	-1022(ra) # 5c12 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bf0080e7          	jalr	-1040(ra) # 5c12 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	10250513          	addi	a0,a0,258 # 6140 <malloc+0x110>
      46:	00006097          	auipc	ra,0x6
      4a:	f2c080e7          	jalr	-212(ra) # 5f72 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b82080e7          	jalr	-1150(ra) # 5bd2 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0e050513          	addi	a0,a0,224 # 6160 <malloc+0x130>
      88:	00006097          	auipc	ra,0x6
      8c:	eea080e7          	jalr	-278(ra) # 5f72 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b40080e7          	jalr	-1216(ra) # 5bd2 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0d050513          	addi	a0,a0,208 # 6178 <malloc+0x148>
      b0:	00006097          	auipc	ra,0x6
      b4:	b62080e7          	jalr	-1182(ra) # 5c12 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b3e080e7          	jalr	-1218(ra) # 5bfa <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0d250513          	addi	a0,a0,210 # 6198 <malloc+0x168>
      ce:	00006097          	auipc	ra,0x6
      d2:	b44080e7          	jalr	-1212(ra) # 5c12 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	09a50513          	addi	a0,a0,154 # 6180 <malloc+0x150>
      ee:	00006097          	auipc	ra,0x6
      f2:	e84080e7          	jalr	-380(ra) # 5f72 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	ada080e7          	jalr	-1318(ra) # 5bd2 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0a650513          	addi	a0,a0,166 # 61a8 <malloc+0x178>
     10a:	00006097          	auipc	ra,0x6
     10e:	e68080e7          	jalr	-408(ra) # 5f72 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	abe080e7          	jalr	-1346(ra) # 5bd2 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0a450513          	addi	a0,a0,164 # 61d0 <malloc+0x1a0>
     134:	00006097          	auipc	ra,0x6
     138:	aee080e7          	jalr	-1298(ra) # 5c22 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	09050513          	addi	a0,a0,144 # 61d0 <malloc+0x1a0>
     148:	00006097          	auipc	ra,0x6
     14c:	aca080e7          	jalr	-1334(ra) # 5c12 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	08c58593          	addi	a1,a1,140 # 61e0 <malloc+0x1b0>
     15c:	00006097          	auipc	ra,0x6
     160:	a96080e7          	jalr	-1386(ra) # 5bf2 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	06850513          	addi	a0,a0,104 # 61d0 <malloc+0x1a0>
     170:	00006097          	auipc	ra,0x6
     174:	aa2080e7          	jalr	-1374(ra) # 5c12 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	06c58593          	addi	a1,a1,108 # 61e8 <malloc+0x1b8>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a6c080e7          	jalr	-1428(ra) # 5bf2 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	03c50513          	addi	a0,a0,60 # 61d0 <malloc+0x1a0>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a86080e7          	jalr	-1402(ra) # 5c22 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a54080e7          	jalr	-1452(ra) # 5bfa <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a4a080e7          	jalr	-1462(ra) # 5bfa <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	02650513          	addi	a0,a0,38 # 61f0 <malloc+0x1c0>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	da0080e7          	jalr	-608(ra) # 5f72 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9f6080e7          	jalr	-1546(ra) # 5bd2 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a02080e7          	jalr	-1534(ra) # 5c12 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9e2080e7          	jalr	-1566(ra) # 5bfa <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9dc080e7          	jalr	-1572(ra) # 5c22 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f9c50513          	addi	a0,a0,-100 # 6218 <malloc+0x1e8>
     284:	00006097          	auipc	ra,0x6
     288:	99e080e7          	jalr	-1634(ra) # 5c22 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f88a8a93          	addi	s5,s5,-120 # 6218 <malloc+0x1e8>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x1a1>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	966080e7          	jalr	-1690(ra) # 5c12 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	934080e7          	jalr	-1740(ra) # 5bf2 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	920080e7          	jalr	-1760(ra) # 5bf2 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	91a080e7          	jalr	-1766(ra) # 5bfa <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	938080e7          	jalr	-1736(ra) # 5c22 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f1650513          	addi	a0,a0,-234 # 6228 <malloc+0x1f8>
     31a:	00006097          	auipc	ra,0x6
     31e:	c58080e7          	jalr	-936(ra) # 5f72 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8ae080e7          	jalr	-1874(ra) # 5bd2 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	f1250513          	addi	a0,a0,-238 # 6248 <malloc+0x218>
     33e:	00006097          	auipc	ra,0x6
     342:	c34080e7          	jalr	-972(ra) # 5f72 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00006097          	auipc	ra,0x6
     34c:	88a080e7          	jalr	-1910(ra) # 5bd2 <exit>

0000000000000350 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	e052                	sd	s4,0(sp)
     35e:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     360:	00006517          	auipc	a0,0x6
     364:	f0050513          	addi	a0,a0,-256 # 6260 <malloc+0x230>
     368:	00006097          	auipc	ra,0x6
     36c:	8ba080e7          	jalr	-1862(ra) # 5c22 <unlink>
     370:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     374:	00006997          	auipc	s3,0x6
     378:	eec98993          	addi	s3,s3,-276 # 6260 <malloc+0x230>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37c:	5a7d                	li	s4,-1
     37e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     382:	20100593          	li	a1,513
     386:	854e                	mv	a0,s3
     388:	00006097          	auipc	ra,0x6
     38c:	88a080e7          	jalr	-1910(ra) # 5c12 <open>
     390:	84aa                	mv	s1,a0
    if(fd < 0){
     392:	06054b63          	bltz	a0,408 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     396:	4605                	li	a2,1
     398:	85d2                	mv	a1,s4
     39a:	00006097          	auipc	ra,0x6
     39e:	858080e7          	jalr	-1960(ra) # 5bf2 <write>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00006097          	auipc	ra,0x6
     3a8:	856080e7          	jalr	-1962(ra) # 5bfa <close>
    unlink("junk");
     3ac:	854e                	mv	a0,s3
     3ae:	00006097          	auipc	ra,0x6
     3b2:	874080e7          	jalr	-1932(ra) # 5c22 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b6:	397d                	addiw	s2,s2,-1
     3b8:	fc0915e3          	bnez	s2,382 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100593          	li	a1,513
     3c0:	00006517          	auipc	a0,0x6
     3c4:	ea050513          	addi	a0,a0,-352 # 6260 <malloc+0x230>
     3c8:	00006097          	auipc	ra,0x6
     3cc:	84a080e7          	jalr	-1974(ra) # 5c12 <open>
     3d0:	84aa                	mv	s1,a0
  if(fd < 0){
     3d2:	04054863          	bltz	a0,422 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d6:	4605                	li	a2,1
     3d8:	00006597          	auipc	a1,0x6
     3dc:	e1058593          	addi	a1,a1,-496 # 61e8 <malloc+0x1b8>
     3e0:	00006097          	auipc	ra,0x6
     3e4:	812080e7          	jalr	-2030(ra) # 5bf2 <write>
     3e8:	4785                	li	a5,1
     3ea:	04f50963          	beq	a0,a5,43c <badwrite+0xec>
    printf("write failed\n");
     3ee:	00006517          	auipc	a0,0x6
     3f2:	e9250513          	addi	a0,a0,-366 # 6280 <malloc+0x250>
     3f6:	00006097          	auipc	ra,0x6
     3fa:	b7c080e7          	jalr	-1156(ra) # 5f72 <printf>
    exit(1);
     3fe:	4505                	li	a0,1
     400:	00005097          	auipc	ra,0x5
     404:	7d2080e7          	jalr	2002(ra) # 5bd2 <exit>
      printf("open junk failed\n");
     408:	00006517          	auipc	a0,0x6
     40c:	e6050513          	addi	a0,a0,-416 # 6268 <malloc+0x238>
     410:	00006097          	auipc	ra,0x6
     414:	b62080e7          	jalr	-1182(ra) # 5f72 <printf>
      exit(1);
     418:	4505                	li	a0,1
     41a:	00005097          	auipc	ra,0x5
     41e:	7b8080e7          	jalr	1976(ra) # 5bd2 <exit>
    printf("open junk failed\n");
     422:	00006517          	auipc	a0,0x6
     426:	e4650513          	addi	a0,a0,-442 # 6268 <malloc+0x238>
     42a:	00006097          	auipc	ra,0x6
     42e:	b48080e7          	jalr	-1208(ra) # 5f72 <printf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00005097          	auipc	ra,0x5
     438:	79e080e7          	jalr	1950(ra) # 5bd2 <exit>
  }
  close(fd);
     43c:	8526                	mv	a0,s1
     43e:	00005097          	auipc	ra,0x5
     442:	7bc080e7          	jalr	1980(ra) # 5bfa <close>
  unlink("junk");
     446:	00006517          	auipc	a0,0x6
     44a:	e1a50513          	addi	a0,a0,-486 # 6260 <malloc+0x230>
     44e:	00005097          	auipc	ra,0x5
     452:	7d4080e7          	jalr	2004(ra) # 5c22 <unlink>

  exit(0);
     456:	4501                	li	a0,0
     458:	00005097          	auipc	ra,0x5
     45c:	77a080e7          	jalr	1914(ra) # 5bd2 <exit>

0000000000000460 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     460:	715d                	addi	sp,sp,-80
     462:	e486                	sd	ra,72(sp)
     464:	e0a2                	sd	s0,64(sp)
     466:	fc26                	sd	s1,56(sp)
     468:	f84a                	sd	s2,48(sp)
     46a:	f44e                	sd	s3,40(sp)
     46c:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     470:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d79b          	sraiw	a5,s1,0x1f
     484:	01b7d71b          	srliw	a4,a5,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a4:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a8:	fb040513          	addi	a0,s0,-80
     4ac:	00005097          	auipc	ra,0x5
     4b0:	776080e7          	jalr	1910(ra) # 5c22 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b4:	60200593          	li	a1,1538
     4b8:	fb040513          	addi	a0,s0,-80
     4bc:	00005097          	auipc	ra,0x5
     4c0:	756080e7          	jalr	1878(ra) # 5c12 <open>
    if(fd < 0){
     4c4:	00054963          	bltz	a0,4d6 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c8:	00005097          	auipc	ra,0x5
     4cc:	732080e7          	jalr	1842(ra) # 5bfa <close>
  for(int i = 0; i < nzz; i++){
     4d0:	2485                	addiw	s1,s1,1
     4d2:	fb3493e3          	bne	s1,s3,478 <outofinodes+0x18>
     4d6:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4dc:	40000993          	li	s3,1024
    name[0] = 'z';
     4e0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e8:	41f4d79b          	sraiw	a5,s1,0x1f
     4ec:	01b7d71b          	srliw	a4,a5,0x1b
     4f0:	009707bb          	addw	a5,a4,s1
     4f4:	4057d69b          	sraiw	a3,a5,0x5
     4f8:	0306869b          	addiw	a3,a3,48
     4fc:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     500:	8bfd                	andi	a5,a5,31
     502:	9f99                	subw	a5,a5,a4
     504:	0307879b          	addiw	a5,a5,48
     508:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     510:	fb040513          	addi	a0,s0,-80
     514:	00005097          	auipc	ra,0x5
     518:	70e080e7          	jalr	1806(ra) # 5c22 <unlink>
  for(int i = 0; i < nzz; i++){
     51c:	2485                	addiw	s1,s1,1
     51e:	fd3491e3          	bne	s1,s3,4e0 <outofinodes+0x80>
  }
}
     522:	60a6                	ld	ra,72(sp)
     524:	6406                	ld	s0,64(sp)
     526:	74e2                	ld	s1,56(sp)
     528:	7942                	ld	s2,48(sp)
     52a:	79a2                	ld	s3,40(sp)
     52c:	6161                	addi	sp,sp,80
     52e:	8082                	ret

0000000000000530 <copyin>:
{
     530:	715d                	addi	sp,sp,-80
     532:	e486                	sd	ra,72(sp)
     534:	e0a2                	sd	s0,64(sp)
     536:	fc26                	sd	s1,56(sp)
     538:	f84a                	sd	s2,48(sp)
     53a:	f44e                	sd	s3,40(sp)
     53c:	f052                	sd	s4,32(sp)
     53e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     540:	4785                	li	a5,1
     542:	07fe                	slli	a5,a5,0x1f
     544:	fcf43023          	sd	a5,-64(s0)
     548:	57fd                	li	a5,-1
     54a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     552:	00006a17          	auipc	s4,0x6
     556:	d3ea0a13          	addi	s4,s4,-706 # 6290 <malloc+0x260>
    uint64 addr = addrs[ai];
     55a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55e:	20100593          	li	a1,513
     562:	8552                	mv	a0,s4
     564:	00005097          	auipc	ra,0x5
     568:	6ae080e7          	jalr	1710(ra) # 5c12 <open>
     56c:	84aa                	mv	s1,a0
    if(fd < 0){
     56e:	08054863          	bltz	a0,5fe <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     572:	6609                	lui	a2,0x2
     574:	85ce                	mv	a1,s3
     576:	00005097          	auipc	ra,0x5
     57a:	67c080e7          	jalr	1660(ra) # 5bf2 <write>
    if(n >= 0){
     57e:	08055d63          	bgez	a0,618 <copyin+0xe8>
    close(fd);
     582:	8526                	mv	a0,s1
     584:	00005097          	auipc	ra,0x5
     588:	676080e7          	jalr	1654(ra) # 5bfa <close>
    unlink("copyin1");
     58c:	8552                	mv	a0,s4
     58e:	00005097          	auipc	ra,0x5
     592:	694080e7          	jalr	1684(ra) # 5c22 <unlink>
    n = write(1, (char*)addr, 8192);
     596:	6609                	lui	a2,0x2
     598:	85ce                	mv	a1,s3
     59a:	4505                	li	a0,1
     59c:	00005097          	auipc	ra,0x5
     5a0:	656080e7          	jalr	1622(ra) # 5bf2 <write>
    if(n > 0){
     5a4:	08a04963          	bgtz	a0,636 <copyin+0x106>
    if(pipe(fds) < 0){
     5a8:	fb840513          	addi	a0,s0,-72
     5ac:	00005097          	auipc	ra,0x5
     5b0:	636080e7          	jalr	1590(ra) # 5be2 <pipe>
     5b4:	0a054063          	bltz	a0,654 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b8:	6609                	lui	a2,0x2
     5ba:	85ce                	mv	a1,s3
     5bc:	fbc42503          	lw	a0,-68(s0)
     5c0:	00005097          	auipc	ra,0x5
     5c4:	632080e7          	jalr	1586(ra) # 5bf2 <write>
    if(n > 0){
     5c8:	0aa04363          	bgtz	a0,66e <copyin+0x13e>
    close(fds[0]);
     5cc:	fb842503          	lw	a0,-72(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	62a080e7          	jalr	1578(ra) # 5bfa <close>
    close(fds[1]);
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	61e080e7          	jalr	1566(ra) # 5bfa <close>
  for(int ai = 0; ai < 2; ai++){
     5e4:	0921                	addi	s2,s2,8
     5e6:	fd040793          	addi	a5,s0,-48
     5ea:	f6f918e3          	bne	s2,a5,55a <copyin+0x2a>
}
     5ee:	60a6                	ld	ra,72(sp)
     5f0:	6406                	ld	s0,64(sp)
     5f2:	74e2                	ld	s1,56(sp)
     5f4:	7942                	ld	s2,48(sp)
     5f6:	79a2                	ld	s3,40(sp)
     5f8:	7a02                	ld	s4,32(sp)
     5fa:	6161                	addi	sp,sp,80
     5fc:	8082                	ret
      printf("open(copyin1) failed\n");
     5fe:	00006517          	auipc	a0,0x6
     602:	c9a50513          	addi	a0,a0,-870 # 6298 <malloc+0x268>
     606:	00006097          	auipc	ra,0x6
     60a:	96c080e7          	jalr	-1684(ra) # 5f72 <printf>
      exit(1);
     60e:	4505                	li	a0,1
     610:	00005097          	auipc	ra,0x5
     614:	5c2080e7          	jalr	1474(ra) # 5bd2 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     618:	862a                	mv	a2,a0
     61a:	85ce                	mv	a1,s3
     61c:	00006517          	auipc	a0,0x6
     620:	c9450513          	addi	a0,a0,-876 # 62b0 <malloc+0x280>
     624:	00006097          	auipc	ra,0x6
     628:	94e080e7          	jalr	-1714(ra) # 5f72 <printf>
      exit(1);
     62c:	4505                	li	a0,1
     62e:	00005097          	auipc	ra,0x5
     632:	5a4080e7          	jalr	1444(ra) # 5bd2 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     636:	862a                	mv	a2,a0
     638:	85ce                	mv	a1,s3
     63a:	00006517          	auipc	a0,0x6
     63e:	ca650513          	addi	a0,a0,-858 # 62e0 <malloc+0x2b0>
     642:	00006097          	auipc	ra,0x6
     646:	930080e7          	jalr	-1744(ra) # 5f72 <printf>
      exit(1);
     64a:	4505                	li	a0,1
     64c:	00005097          	auipc	ra,0x5
     650:	586080e7          	jalr	1414(ra) # 5bd2 <exit>
      printf("pipe() failed\n");
     654:	00006517          	auipc	a0,0x6
     658:	cbc50513          	addi	a0,a0,-836 # 6310 <malloc+0x2e0>
     65c:	00006097          	auipc	ra,0x6
     660:	916080e7          	jalr	-1770(ra) # 5f72 <printf>
      exit(1);
     664:	4505                	li	a0,1
     666:	00005097          	auipc	ra,0x5
     66a:	56c080e7          	jalr	1388(ra) # 5bd2 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66e:	862a                	mv	a2,a0
     670:	85ce                	mv	a1,s3
     672:	00006517          	auipc	a0,0x6
     676:	cae50513          	addi	a0,a0,-850 # 6320 <malloc+0x2f0>
     67a:	00006097          	auipc	ra,0x6
     67e:	8f8080e7          	jalr	-1800(ra) # 5f72 <printf>
      exit(1);
     682:	4505                	li	a0,1
     684:	00005097          	auipc	ra,0x5
     688:	54e080e7          	jalr	1358(ra) # 5bd2 <exit>

000000000000068c <copyout>:
{
     68c:	711d                	addi	sp,sp,-96
     68e:	ec86                	sd	ra,88(sp)
     690:	e8a2                	sd	s0,80(sp)
     692:	e4a6                	sd	s1,72(sp)
     694:	e0ca                	sd	s2,64(sp)
     696:	fc4e                	sd	s3,56(sp)
     698:	f852                	sd	s4,48(sp)
     69a:	f456                	sd	s5,40(sp)
     69c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69e:	4785                	li	a5,1
     6a0:	07fe                	slli	a5,a5,0x1f
     6a2:	faf43823          	sd	a5,-80(s0)
     6a6:	57fd                	li	a5,-1
     6a8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6ac:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6b0:	00006a17          	auipc	s4,0x6
     6b4:	ca0a0a13          	addi	s4,s4,-864 # 6350 <malloc+0x320>
    n = write(fds[1], "x", 1);
     6b8:	00006a97          	auipc	s5,0x6
     6bc:	b30a8a93          	addi	s5,s5,-1232 # 61e8 <malloc+0x1b8>
    uint64 addr = addrs[ai];
     6c0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c4:	4581                	li	a1,0
     6c6:	8552                	mv	a0,s4
     6c8:	00005097          	auipc	ra,0x5
     6cc:	54a080e7          	jalr	1354(ra) # 5c12 <open>
     6d0:	84aa                	mv	s1,a0
    if(fd < 0){
     6d2:	08054663          	bltz	a0,75e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d6:	6609                	lui	a2,0x2
     6d8:	85ce                	mv	a1,s3
     6da:	00005097          	auipc	ra,0x5
     6de:	510080e7          	jalr	1296(ra) # 5bea <read>
    if(n > 0){
     6e2:	08a04b63          	bgtz	a0,778 <copyout+0xec>
    close(fd);
     6e6:	8526                	mv	a0,s1
     6e8:	00005097          	auipc	ra,0x5
     6ec:	512080e7          	jalr	1298(ra) # 5bfa <close>
    if(pipe(fds) < 0){
     6f0:	fa840513          	addi	a0,s0,-88
     6f4:	00005097          	auipc	ra,0x5
     6f8:	4ee080e7          	jalr	1262(ra) # 5be2 <pipe>
     6fc:	08054d63          	bltz	a0,796 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     700:	4605                	li	a2,1
     702:	85d6                	mv	a1,s5
     704:	fac42503          	lw	a0,-84(s0)
     708:	00005097          	auipc	ra,0x5
     70c:	4ea080e7          	jalr	1258(ra) # 5bf2 <write>
    if(n != 1){
     710:	4785                	li	a5,1
     712:	08f51f63          	bne	a0,a5,7b0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     716:	6609                	lui	a2,0x2
     718:	85ce                	mv	a1,s3
     71a:	fa842503          	lw	a0,-88(s0)
     71e:	00005097          	auipc	ra,0x5
     722:	4cc080e7          	jalr	1228(ra) # 5bea <read>
    if(n > 0){
     726:	0aa04263          	bgtz	a0,7ca <copyout+0x13e>
    close(fds[0]);
     72a:	fa842503          	lw	a0,-88(s0)
     72e:	00005097          	auipc	ra,0x5
     732:	4cc080e7          	jalr	1228(ra) # 5bfa <close>
    close(fds[1]);
     736:	fac42503          	lw	a0,-84(s0)
     73a:	00005097          	auipc	ra,0x5
     73e:	4c0080e7          	jalr	1216(ra) # 5bfa <close>
  for(int ai = 0; ai < 2; ai++){
     742:	0921                	addi	s2,s2,8
     744:	fc040793          	addi	a5,s0,-64
     748:	f6f91ce3          	bne	s2,a5,6c0 <copyout+0x34>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
      printf("open(README) failed\n");
     75e:	00006517          	auipc	a0,0x6
     762:	bfa50513          	addi	a0,a0,-1030 # 6358 <malloc+0x328>
     766:	00006097          	auipc	ra,0x6
     76a:	80c080e7          	jalr	-2036(ra) # 5f72 <printf>
      exit(1);
     76e:	4505                	li	a0,1
     770:	00005097          	auipc	ra,0x5
     774:	462080e7          	jalr	1122(ra) # 5bd2 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     778:	862a                	mv	a2,a0
     77a:	85ce                	mv	a1,s3
     77c:	00006517          	auipc	a0,0x6
     780:	bf450513          	addi	a0,a0,-1036 # 6370 <malloc+0x340>
     784:	00005097          	auipc	ra,0x5
     788:	7ee080e7          	jalr	2030(ra) # 5f72 <printf>
      exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	444080e7          	jalr	1092(ra) # 5bd2 <exit>
      printf("pipe() failed\n");
     796:	00006517          	auipc	a0,0x6
     79a:	b7a50513          	addi	a0,a0,-1158 # 6310 <malloc+0x2e0>
     79e:	00005097          	auipc	ra,0x5
     7a2:	7d4080e7          	jalr	2004(ra) # 5f72 <printf>
      exit(1);
     7a6:	4505                	li	a0,1
     7a8:	00005097          	auipc	ra,0x5
     7ac:	42a080e7          	jalr	1066(ra) # 5bd2 <exit>
      printf("pipe write failed\n");
     7b0:	00006517          	auipc	a0,0x6
     7b4:	bf050513          	addi	a0,a0,-1040 # 63a0 <malloc+0x370>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	7ba080e7          	jalr	1978(ra) # 5f72 <printf>
      exit(1);
     7c0:	4505                	li	a0,1
     7c2:	00005097          	auipc	ra,0x5
     7c6:	410080e7          	jalr	1040(ra) # 5bd2 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7ca:	862a                	mv	a2,a0
     7cc:	85ce                	mv	a1,s3
     7ce:	00006517          	auipc	a0,0x6
     7d2:	bea50513          	addi	a0,a0,-1046 # 63b8 <malloc+0x388>
     7d6:	00005097          	auipc	ra,0x5
     7da:	79c080e7          	jalr	1948(ra) # 5f72 <printf>
      exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	3f2080e7          	jalr	1010(ra) # 5bd2 <exit>

00000000000007e8 <truncate1>:
{
     7e8:	711d                	addi	sp,sp,-96
     7ea:	ec86                	sd	ra,88(sp)
     7ec:	e8a2                	sd	s0,80(sp)
     7ee:	e4a6                	sd	s1,72(sp)
     7f0:	e0ca                	sd	s2,64(sp)
     7f2:	fc4e                	sd	s3,56(sp)
     7f4:	f852                	sd	s4,48(sp)
     7f6:	f456                	sd	s5,40(sp)
     7f8:	1080                	addi	s0,sp,96
     7fa:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fc:	00006517          	auipc	a0,0x6
     800:	9d450513          	addi	a0,a0,-1580 # 61d0 <malloc+0x1a0>
     804:	00005097          	auipc	ra,0x5
     808:	41e080e7          	jalr	1054(ra) # 5c22 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80c:	60100593          	li	a1,1537
     810:	00006517          	auipc	a0,0x6
     814:	9c050513          	addi	a0,a0,-1600 # 61d0 <malloc+0x1a0>
     818:	00005097          	auipc	ra,0x5
     81c:	3fa080e7          	jalr	1018(ra) # 5c12 <open>
     820:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     822:	4611                	li	a2,4
     824:	00006597          	auipc	a1,0x6
     828:	9bc58593          	addi	a1,a1,-1604 # 61e0 <malloc+0x1b0>
     82c:	00005097          	auipc	ra,0x5
     830:	3c6080e7          	jalr	966(ra) # 5bf2 <write>
  close(fd1);
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	3c4080e7          	jalr	964(ra) # 5bfa <close>
  int fd2 = open("truncfile", O_RDONLY);
     83e:	4581                	li	a1,0
     840:	00006517          	auipc	a0,0x6
     844:	99050513          	addi	a0,a0,-1648 # 61d0 <malloc+0x1a0>
     848:	00005097          	auipc	ra,0x5
     84c:	3ca080e7          	jalr	970(ra) # 5c12 <open>
     850:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     852:	02000613          	li	a2,32
     856:	fa040593          	addi	a1,s0,-96
     85a:	00005097          	auipc	ra,0x5
     85e:	390080e7          	jalr	912(ra) # 5bea <read>
  if(n != 4){
     862:	4791                	li	a5,4
     864:	0cf51e63          	bne	a0,a5,940 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     868:	40100593          	li	a1,1025
     86c:	00006517          	auipc	a0,0x6
     870:	96450513          	addi	a0,a0,-1692 # 61d0 <malloc+0x1a0>
     874:	00005097          	auipc	ra,0x5
     878:	39e080e7          	jalr	926(ra) # 5c12 <open>
     87c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87e:	4581                	li	a1,0
     880:	00006517          	auipc	a0,0x6
     884:	95050513          	addi	a0,a0,-1712 # 61d0 <malloc+0x1a0>
     888:	00005097          	auipc	ra,0x5
     88c:	38a080e7          	jalr	906(ra) # 5c12 <open>
     890:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     892:	02000613          	li	a2,32
     896:	fa040593          	addi	a1,s0,-96
     89a:	00005097          	auipc	ra,0x5
     89e:	350080e7          	jalr	848(ra) # 5bea <read>
     8a2:	8a2a                	mv	s4,a0
  if(n != 0){
     8a4:	ed4d                	bnez	a0,95e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a6:	02000613          	li	a2,32
     8aa:	fa040593          	addi	a1,s0,-96
     8ae:	8526                	mv	a0,s1
     8b0:	00005097          	auipc	ra,0x5
     8b4:	33a080e7          	jalr	826(ra) # 5bea <read>
     8b8:	8a2a                	mv	s4,a0
  if(n != 0){
     8ba:	e971                	bnez	a0,98e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8bc:	4619                	li	a2,6
     8be:	00006597          	auipc	a1,0x6
     8c2:	b8a58593          	addi	a1,a1,-1142 # 6448 <malloc+0x418>
     8c6:	854e                	mv	a0,s3
     8c8:	00005097          	auipc	ra,0x5
     8cc:	32a080e7          	jalr	810(ra) # 5bf2 <write>
  n = read(fd3, buf, sizeof(buf));
     8d0:	02000613          	li	a2,32
     8d4:	fa040593          	addi	a1,s0,-96
     8d8:	854a                	mv	a0,s2
     8da:	00005097          	auipc	ra,0x5
     8de:	310080e7          	jalr	784(ra) # 5bea <read>
  if(n != 6){
     8e2:	4799                	li	a5,6
     8e4:	0cf51d63          	bne	a0,a5,9be <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e8:	02000613          	li	a2,32
     8ec:	fa040593          	addi	a1,s0,-96
     8f0:	8526                	mv	a0,s1
     8f2:	00005097          	auipc	ra,0x5
     8f6:	2f8080e7          	jalr	760(ra) # 5bea <read>
  if(n != 2){
     8fa:	4789                	li	a5,2
     8fc:	0ef51063          	bne	a0,a5,9dc <truncate1+0x1f4>
  unlink("truncfile");
     900:	00006517          	auipc	a0,0x6
     904:	8d050513          	addi	a0,a0,-1840 # 61d0 <malloc+0x1a0>
     908:	00005097          	auipc	ra,0x5
     90c:	31a080e7          	jalr	794(ra) # 5c22 <unlink>
  close(fd1);
     910:	854e                	mv	a0,s3
     912:	00005097          	auipc	ra,0x5
     916:	2e8080e7          	jalr	744(ra) # 5bfa <close>
  close(fd2);
     91a:	8526                	mv	a0,s1
     91c:	00005097          	auipc	ra,0x5
     920:	2de080e7          	jalr	734(ra) # 5bfa <close>
  close(fd3);
     924:	854a                	mv	a0,s2
     926:	00005097          	auipc	ra,0x5
     92a:	2d4080e7          	jalr	724(ra) # 5bfa <close>
}
     92e:	60e6                	ld	ra,88(sp)
     930:	6446                	ld	s0,80(sp)
     932:	64a6                	ld	s1,72(sp)
     934:	6906                	ld	s2,64(sp)
     936:	79e2                	ld	s3,56(sp)
     938:	7a42                	ld	s4,48(sp)
     93a:	7aa2                	ld	s5,40(sp)
     93c:	6125                	addi	sp,sp,96
     93e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     940:	862a                	mv	a2,a0
     942:	85d6                	mv	a1,s5
     944:	00006517          	auipc	a0,0x6
     948:	aa450513          	addi	a0,a0,-1372 # 63e8 <malloc+0x3b8>
     94c:	00005097          	auipc	ra,0x5
     950:	626080e7          	jalr	1574(ra) # 5f72 <printf>
    exit(1);
     954:	4505                	li	a0,1
     956:	00005097          	auipc	ra,0x5
     95a:	27c080e7          	jalr	636(ra) # 5bd2 <exit>
    printf("aaa fd3=%d\n", fd3);
     95e:	85ca                	mv	a1,s2
     960:	00006517          	auipc	a0,0x6
     964:	aa850513          	addi	a0,a0,-1368 # 6408 <malloc+0x3d8>
     968:	00005097          	auipc	ra,0x5
     96c:	60a080e7          	jalr	1546(ra) # 5f72 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     970:	8652                	mv	a2,s4
     972:	85d6                	mv	a1,s5
     974:	00006517          	auipc	a0,0x6
     978:	aa450513          	addi	a0,a0,-1372 # 6418 <malloc+0x3e8>
     97c:	00005097          	auipc	ra,0x5
     980:	5f6080e7          	jalr	1526(ra) # 5f72 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	24c080e7          	jalr	588(ra) # 5bd2 <exit>
    printf("bbb fd2=%d\n", fd2);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	aa850513          	addi	a0,a0,-1368 # 6438 <malloc+0x408>
     998:	00005097          	auipc	ra,0x5
     99c:	5da080e7          	jalr	1498(ra) # 5f72 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a0:	8652                	mv	a2,s4
     9a2:	85d6                	mv	a1,s5
     9a4:	00006517          	auipc	a0,0x6
     9a8:	a7450513          	addi	a0,a0,-1420 # 6418 <malloc+0x3e8>
     9ac:	00005097          	auipc	ra,0x5
     9b0:	5c6080e7          	jalr	1478(ra) # 5f72 <printf>
    exit(1);
     9b4:	4505                	li	a0,1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	21c080e7          	jalr	540(ra) # 5bd2 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9be:	862a                	mv	a2,a0
     9c0:	85d6                	mv	a1,s5
     9c2:	00006517          	auipc	a0,0x6
     9c6:	a8e50513          	addi	a0,a0,-1394 # 6450 <malloc+0x420>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	5a8080e7          	jalr	1448(ra) # 5f72 <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	1fe080e7          	jalr	510(ra) # 5bd2 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9dc:	862a                	mv	a2,a0
     9de:	85d6                	mv	a1,s5
     9e0:	00006517          	auipc	a0,0x6
     9e4:	a9050513          	addi	a0,a0,-1392 # 6470 <malloc+0x440>
     9e8:	00005097          	auipc	ra,0x5
     9ec:	58a080e7          	jalr	1418(ra) # 5f72 <printf>
    exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	1e0080e7          	jalr	480(ra) # 5bd2 <exit>

00000000000009fa <writetest>:
{
     9fa:	7139                	addi	sp,sp,-64
     9fc:	fc06                	sd	ra,56(sp)
     9fe:	f822                	sd	s0,48(sp)
     a00:	f426                	sd	s1,40(sp)
     a02:	f04a                	sd	s2,32(sp)
     a04:	ec4e                	sd	s3,24(sp)
     a06:	e852                	sd	s4,16(sp)
     a08:	e456                	sd	s5,8(sp)
     a0a:	e05a                	sd	s6,0(sp)
     a0c:	0080                	addi	s0,sp,64
     a0e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a10:	20200593          	li	a1,514
     a14:	00006517          	auipc	a0,0x6
     a18:	a7c50513          	addi	a0,a0,-1412 # 6490 <malloc+0x460>
     a1c:	00005097          	auipc	ra,0x5
     a20:	1f6080e7          	jalr	502(ra) # 5c12 <open>
  if(fd < 0){
     a24:	0a054d63          	bltz	a0,ade <writetest+0xe4>
     a28:	892a                	mv	s2,a0
     a2a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2c:	00006997          	auipc	s3,0x6
     a30:	a8c98993          	addi	s3,s3,-1396 # 64b8 <malloc+0x488>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a34:	00006a97          	auipc	s5,0x6
     a38:	abca8a93          	addi	s5,s5,-1348 # 64f0 <malloc+0x4c0>
  for(i = 0; i < N; i++){
     a3c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a40:	4629                	li	a2,10
     a42:	85ce                	mv	a1,s3
     a44:	854a                	mv	a0,s2
     a46:	00005097          	auipc	ra,0x5
     a4a:	1ac080e7          	jalr	428(ra) # 5bf2 <write>
     a4e:	47a9                	li	a5,10
     a50:	0af51563          	bne	a0,a5,afa <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a54:	4629                	li	a2,10
     a56:	85d6                	mv	a1,s5
     a58:	854a                	mv	a0,s2
     a5a:	00005097          	auipc	ra,0x5
     a5e:	198080e7          	jalr	408(ra) # 5bf2 <write>
     a62:	47a9                	li	a5,10
     a64:	0af51a63          	bne	a0,a5,b18 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	fd449be3          	bne	s1,s4,a40 <writetest+0x46>
  close(fd);
     a6e:	854a                	mv	a0,s2
     a70:	00005097          	auipc	ra,0x5
     a74:	18a080e7          	jalr	394(ra) # 5bfa <close>
  fd = open("small", O_RDONLY);
     a78:	4581                	li	a1,0
     a7a:	00006517          	auipc	a0,0x6
     a7e:	a1650513          	addi	a0,a0,-1514 # 6490 <malloc+0x460>
     a82:	00005097          	auipc	ra,0x5
     a86:	190080e7          	jalr	400(ra) # 5c12 <open>
     a8a:	84aa                	mv	s1,a0
  if(fd < 0){
     a8c:	0a054563          	bltz	a0,b36 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a90:	7d000613          	li	a2,2000
     a94:	0000c597          	auipc	a1,0xc
     a98:	1e458593          	addi	a1,a1,484 # cc78 <buf>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	14e080e7          	jalr	334(ra) # 5bea <read>
  if(i != N*SZ*2){
     aa4:	7d000793          	li	a5,2000
     aa8:	0af51563          	bne	a0,a5,b52 <writetest+0x158>
  close(fd);
     aac:	8526                	mv	a0,s1
     aae:	00005097          	auipc	ra,0x5
     ab2:	14c080e7          	jalr	332(ra) # 5bfa <close>
  if(unlink("small") < 0){
     ab6:	00006517          	auipc	a0,0x6
     aba:	9da50513          	addi	a0,a0,-1574 # 6490 <malloc+0x460>
     abe:	00005097          	auipc	ra,0x5
     ac2:	164080e7          	jalr	356(ra) # 5c22 <unlink>
     ac6:	0a054463          	bltz	a0,b6e <writetest+0x174>
}
     aca:	70e2                	ld	ra,56(sp)
     acc:	7442                	ld	s0,48(sp)
     ace:	74a2                	ld	s1,40(sp)
     ad0:	7902                	ld	s2,32(sp)
     ad2:	69e2                	ld	s3,24(sp)
     ad4:	6a42                	ld	s4,16(sp)
     ad6:	6aa2                	ld	s5,8(sp)
     ad8:	6b02                	ld	s6,0(sp)
     ada:	6121                	addi	sp,sp,64
     adc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ade:	85da                	mv	a1,s6
     ae0:	00006517          	auipc	a0,0x6
     ae4:	9b850513          	addi	a0,a0,-1608 # 6498 <malloc+0x468>
     ae8:	00005097          	auipc	ra,0x5
     aec:	48a080e7          	jalr	1162(ra) # 5f72 <printf>
    exit(1);
     af0:	4505                	li	a0,1
     af2:	00005097          	auipc	ra,0x5
     af6:	0e0080e7          	jalr	224(ra) # 5bd2 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     afa:	8626                	mv	a2,s1
     afc:	85da                	mv	a1,s6
     afe:	00006517          	auipc	a0,0x6
     b02:	9ca50513          	addi	a0,a0,-1590 # 64c8 <malloc+0x498>
     b06:	00005097          	auipc	ra,0x5
     b0a:	46c080e7          	jalr	1132(ra) # 5f72 <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	00005097          	auipc	ra,0x5
     b14:	0c2080e7          	jalr	194(ra) # 5bd2 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b18:	8626                	mv	a2,s1
     b1a:	85da                	mv	a1,s6
     b1c:	00006517          	auipc	a0,0x6
     b20:	9e450513          	addi	a0,a0,-1564 # 6500 <malloc+0x4d0>
     b24:	00005097          	auipc	ra,0x5
     b28:	44e080e7          	jalr	1102(ra) # 5f72 <printf>
      exit(1);
     b2c:	4505                	li	a0,1
     b2e:	00005097          	auipc	ra,0x5
     b32:	0a4080e7          	jalr	164(ra) # 5bd2 <exit>
    printf("%s: error: open small failed!\n", s);
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	9f050513          	addi	a0,a0,-1552 # 6528 <malloc+0x4f8>
     b40:	00005097          	auipc	ra,0x5
     b44:	432080e7          	jalr	1074(ra) # 5f72 <printf>
    exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	088080e7          	jalr	136(ra) # 5bd2 <exit>
    printf("%s: read failed\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00006517          	auipc	a0,0x6
     b58:	9f450513          	addi	a0,a0,-1548 # 6548 <malloc+0x518>
     b5c:	00005097          	auipc	ra,0x5
     b60:	416080e7          	jalr	1046(ra) # 5f72 <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	06c080e7          	jalr	108(ra) # 5bd2 <exit>
    printf("%s: unlink small failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00006517          	auipc	a0,0x6
     b74:	9f050513          	addi	a0,a0,-1552 # 6560 <malloc+0x530>
     b78:	00005097          	auipc	ra,0x5
     b7c:	3fa080e7          	jalr	1018(ra) # 5f72 <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	050080e7          	jalr	80(ra) # 5bd2 <exit>

0000000000000b8a <writebig>:
{
     b8a:	7139                	addi	sp,sp,-64
     b8c:	fc06                	sd	ra,56(sp)
     b8e:	f822                	sd	s0,48(sp)
     b90:	f426                	sd	s1,40(sp)
     b92:	f04a                	sd	s2,32(sp)
     b94:	ec4e                	sd	s3,24(sp)
     b96:	e852                	sd	s4,16(sp)
     b98:	e456                	sd	s5,8(sp)
     b9a:	0080                	addi	s0,sp,64
     b9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9e:	20200593          	li	a1,514
     ba2:	00006517          	auipc	a0,0x6
     ba6:	9de50513          	addi	a0,a0,-1570 # 6580 <malloc+0x550>
     baa:	00005097          	auipc	ra,0x5
     bae:	068080e7          	jalr	104(ra) # 5c12 <open>
     bb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb6:	0000c917          	auipc	s2,0xc
     bba:	0c290913          	addi	s2,s2,194 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbe:	10c00a13          	li	s4,268
  if(fd < 0){
     bc2:	06054c63          	bltz	a0,c3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	020080e7          	jalr	32(ra) # 5bf2 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3c>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	010080e7          	jalr	16(ra) # 5bfa <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	98c50513          	addi	a0,a0,-1652 # 6580 <malloc+0x550>
     bfc:	00005097          	auipc	ra,0x5
     c00:	016080e7          	jalr	22(ra) # 5c12 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000c917          	auipc	s2,0xc
     c0c:	07090913          	addi	s2,s2,112 # cc78 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	fce080e7          	jalr	-50(ra) # 5bea <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x106>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17c>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	94c50513          	addi	a0,a0,-1716 # 6588 <malloc+0x558>
     c44:	00005097          	auipc	ra,0x5
     c48:	32e080e7          	jalr	814(ra) # 5f72 <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	f84080e7          	jalr	-124(ra) # 5bd2 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	94e50513          	addi	a0,a0,-1714 # 65a8 <malloc+0x578>
     c62:	00005097          	auipc	ra,0x5
     c66:	310080e7          	jalr	784(ra) # 5f72 <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	f66080e7          	jalr	-154(ra) # 5bd2 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	95a50513          	addi	a0,a0,-1702 # 65d0 <malloc+0x5a0>
     c7e:	00005097          	auipc	ra,0x5
     c82:	2f4080e7          	jalr	756(ra) # 5f72 <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	f4a080e7          	jalr	-182(ra) # 5bd2 <exit>
      if(n == MAXFILE - 1){
     c90:	10b00793          	li	a5,267
     c94:	02f48a63          	beq	s1,a5,cc8 <writebig+0x13e>
  close(fd);
     c98:	854e                	mv	a0,s3
     c9a:	00005097          	auipc	ra,0x5
     c9e:	f60080e7          	jalr	-160(ra) # 5bfa <close>
  if(unlink("big") < 0){
     ca2:	00006517          	auipc	a0,0x6
     ca6:	8de50513          	addi	a0,a0,-1826 # 6580 <malloc+0x550>
     caa:	00005097          	auipc	ra,0x5
     cae:	f78080e7          	jalr	-136(ra) # 5c22 <unlink>
     cb2:	06054963          	bltz	a0,d24 <writebig+0x19a>
}
     cb6:	70e2                	ld	ra,56(sp)
     cb8:	7442                	ld	s0,48(sp)
     cba:	74a2                	ld	s1,40(sp)
     cbc:	7902                	ld	s2,32(sp)
     cbe:	69e2                	ld	s3,24(sp)
     cc0:	6a42                	ld	s4,16(sp)
     cc2:	6aa2                	ld	s5,8(sp)
     cc4:	6121                	addi	sp,sp,64
     cc6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc8:	10b00613          	li	a2,267
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	92250513          	addi	a0,a0,-1758 # 65f0 <malloc+0x5c0>
     cd6:	00005097          	auipc	ra,0x5
     cda:	29c080e7          	jalr	668(ra) # 5f72 <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	ef2080e7          	jalr	-270(ra) # 5bd2 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	92c50513          	addi	a0,a0,-1748 # 6618 <malloc+0x5e8>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	27e080e7          	jalr	638(ra) # 5f72 <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	ed4080e7          	jalr	-300(ra) # 5bd2 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	92650513          	addi	a0,a0,-1754 # 6630 <malloc+0x600>
     d12:	00005097          	auipc	ra,0x5
     d16:	260080e7          	jalr	608(ra) # 5f72 <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	eb6080e7          	jalr	-330(ra) # 5bd2 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	93250513          	addi	a0,a0,-1742 # 6658 <malloc+0x628>
     d2e:	00005097          	auipc	ra,0x5
     d32:	244080e7          	jalr	580(ra) # 5f72 <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	e9a080e7          	jalr	-358(ra) # 5bd2 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	91c50513          	addi	a0,a0,-1764 # 6670 <malloc+0x640>
     d5c:	00005097          	auipc	ra,0x5
     d60:	eb6080e7          	jalr	-330(ra) # 5c12 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	93458593          	addi	a1,a1,-1740 # 66a0 <malloc+0x670>
     d74:	00005097          	auipc	ra,0x5
     d78:	e7e080e7          	jalr	-386(ra) # 5bf2 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	e7c080e7          	jalr	-388(ra) # 5bfa <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	8e850513          	addi	a0,a0,-1816 # 6670 <malloc+0x640>
     d90:	00005097          	auipc	ra,0x5
     d94:	e82080e7          	jalr	-382(ra) # 5c12 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	8d250513          	addi	a0,a0,-1838 # 6670 <malloc+0x640>
     da6:	00005097          	auipc	ra,0x5
     daa:	e7c080e7          	jalr	-388(ra) # 5c22 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	8bc50513          	addi	a0,a0,-1860 # 6670 <malloc+0x640>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	e56080e7          	jalr	-426(ra) # 5c12 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	92058593          	addi	a1,a1,-1760 # 66e8 <malloc+0x6b8>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e22080e7          	jalr	-478(ra) # 5bf2 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e20080e7          	jalr	-480(ra) # 5bfa <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000c597          	auipc	a1,0xc
     de8:	e9458593          	addi	a1,a1,-364 # cc78 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	dfc080e7          	jalr	-516(ra) # 5bea <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000c717          	auipc	a4,0xc
     e00:	e7c74703          	lbu	a4,-388(a4) # cc78 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000c597          	auipc	a1,0xc
     e12:	e6a58593          	addi	a1,a1,-406 # cc78 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	dda080e7          	jalr	-550(ra) # 5bf2 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	dd2080e7          	jalr	-558(ra) # 5bfa <close>
  unlink("unlinkread");
     e30:	00006517          	auipc	a0,0x6
     e34:	84050513          	addi	a0,a0,-1984 # 6670 <malloc+0x640>
     e38:	00005097          	auipc	ra,0x5
     e3c:	dea080e7          	jalr	-534(ra) # 5c22 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00006517          	auipc	a0,0x6
     e54:	83050513          	addi	a0,a0,-2000 # 6680 <malloc+0x650>
     e58:	00005097          	auipc	ra,0x5
     e5c:	11a080e7          	jalr	282(ra) # 5f72 <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	d70080e7          	jalr	-656(ra) # 5bd2 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00006517          	auipc	a0,0x6
     e70:	83c50513          	addi	a0,a0,-1988 # 66a8 <malloc+0x678>
     e74:	00005097          	auipc	ra,0x5
     e78:	0fe080e7          	jalr	254(ra) # 5f72 <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	d54080e7          	jalr	-684(ra) # 5bd2 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00006517          	auipc	a0,0x6
     e8c:	84050513          	addi	a0,a0,-1984 # 66c8 <malloc+0x698>
     e90:	00005097          	auipc	ra,0x5
     e94:	0e2080e7          	jalr	226(ra) # 5f72 <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	d38080e7          	jalr	-712(ra) # 5bd2 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00006517          	auipc	a0,0x6
     ea8:	84c50513          	addi	a0,a0,-1972 # 66f0 <malloc+0x6c0>
     eac:	00005097          	auipc	ra,0x5
     eb0:	0c6080e7          	jalr	198(ra) # 5f72 <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d1c080e7          	jalr	-740(ra) # 5bd2 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	85050513          	addi	a0,a0,-1968 # 6710 <malloc+0x6e0>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	0aa080e7          	jalr	170(ra) # 5f72 <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	d00080e7          	jalr	-768(ra) # 5bd2 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	85450513          	addi	a0,a0,-1964 # 6730 <malloc+0x700>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	08e080e7          	jalr	142(ra) # 5f72 <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	ce4080e7          	jalr	-796(ra) # 5bd2 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00006517          	auipc	a0,0x6
     f08:	84c50513          	addi	a0,a0,-1972 # 6750 <malloc+0x720>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d16080e7          	jalr	-746(ra) # 5c22 <unlink>
  unlink("lf2");
     f14:	00006517          	auipc	a0,0x6
     f18:	84450513          	addi	a0,a0,-1980 # 6758 <malloc+0x728>
     f1c:	00005097          	auipc	ra,0x5
     f20:	d06080e7          	jalr	-762(ra) # 5c22 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00006517          	auipc	a0,0x6
     f2c:	82850513          	addi	a0,a0,-2008 # 6750 <malloc+0x720>
     f30:	00005097          	auipc	ra,0x5
     f34:	ce2080e7          	jalr	-798(ra) # 5c12 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	76058593          	addi	a1,a1,1888 # 66a0 <malloc+0x670>
     f48:	00005097          	auipc	ra,0x5
     f4c:	caa080e7          	jalr	-854(ra) # 5bf2 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	ca2080e7          	jalr	-862(ra) # 5bfa <close>
  if(link("lf1", "lf2") < 0){
     f60:	00005597          	auipc	a1,0x5
     f64:	7f858593          	addi	a1,a1,2040 # 6758 <malloc+0x728>
     f68:	00005517          	auipc	a0,0x5
     f6c:	7e850513          	addi	a0,a0,2024 # 6750 <malloc+0x720>
     f70:	00005097          	auipc	ra,0x5
     f74:	cc2080e7          	jalr	-830(ra) # 5c32 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	7d450513          	addi	a0,a0,2004 # 6750 <malloc+0x720>
     f84:	00005097          	auipc	ra,0x5
     f88:	c9e080e7          	jalr	-866(ra) # 5c22 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	7c250513          	addi	a0,a0,1986 # 6750 <malloc+0x720>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c7c080e7          	jalr	-900(ra) # 5c12 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	7b450513          	addi	a0,a0,1972 # 6758 <malloc+0x728>
     fac:	00005097          	auipc	ra,0x5
     fb0:	c66080e7          	jalr	-922(ra) # 5c12 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000c597          	auipc	a1,0xc
     fc0:	cbc58593          	addi	a1,a1,-836 # cc78 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c26080e7          	jalr	-986(ra) # 5bea <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c26080e7          	jalr	-986(ra) # 5bfa <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	77c58593          	addi	a1,a1,1916 # 6758 <malloc+0x728>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c4c080e7          	jalr	-948(ra) # 5c32 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	76650513          	addi	a0,a0,1894 # 6758 <malloc+0x728>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c28080e7          	jalr	-984(ra) # 5c22 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	74e58593          	addi	a1,a1,1870 # 6750 <malloc+0x720>
    100a:	00005517          	auipc	a0,0x5
    100e:	74e50513          	addi	a0,a0,1870 # 6758 <malloc+0x728>
    1012:	00005097          	auipc	ra,0x5
    1016:	c20080e7          	jalr	-992(ra) # 5c32 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	73258593          	addi	a1,a1,1842 # 6750 <malloc+0x720>
    1026:	00006517          	auipc	a0,0x6
    102a:	83a50513          	addi	a0,a0,-1990 # 6860 <malloc+0x830>
    102e:	00005097          	auipc	ra,0x5
    1032:	c04080e7          	jalr	-1020(ra) # 5c32 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	71850513          	addi	a0,a0,1816 # 6760 <malloc+0x730>
    1050:	00005097          	auipc	ra,0x5
    1054:	f22080e7          	jalr	-222(ra) # 5f72 <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	b78080e7          	jalr	-1160(ra) # 5bd2 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	71450513          	addi	a0,a0,1812 # 6778 <malloc+0x748>
    106c:	00005097          	auipc	ra,0x5
    1070:	f06080e7          	jalr	-250(ra) # 5f72 <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	b5c080e7          	jalr	-1188(ra) # 5bd2 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	71050513          	addi	a0,a0,1808 # 6790 <malloc+0x760>
    1088:	00005097          	auipc	ra,0x5
    108c:	eea080e7          	jalr	-278(ra) # 5f72 <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b40080e7          	jalr	-1216(ra) # 5bd2 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	71450513          	addi	a0,a0,1812 # 67b0 <malloc+0x780>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	ece080e7          	jalr	-306(ra) # 5f72 <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b24080e7          	jalr	-1244(ra) # 5bd2 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	72850513          	addi	a0,a0,1832 # 67e0 <malloc+0x7b0>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	eb2080e7          	jalr	-334(ra) # 5f72 <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	b08080e7          	jalr	-1272(ra) # 5bd2 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	72450513          	addi	a0,a0,1828 # 67f8 <malloc+0x7c8>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	e96080e7          	jalr	-362(ra) # 5f72 <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	aec080e7          	jalr	-1300(ra) # 5bd2 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	72050513          	addi	a0,a0,1824 # 6810 <malloc+0x7e0>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	e7a080e7          	jalr	-390(ra) # 5f72 <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	ad0080e7          	jalr	-1328(ra) # 5bd2 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	72c50513          	addi	a0,a0,1836 # 6838 <malloc+0x808>
    1114:	00005097          	auipc	ra,0x5
    1118:	e5e080e7          	jalr	-418(ra) # 5f72 <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	ab4080e7          	jalr	-1356(ra) # 5bd2 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	74050513          	addi	a0,a0,1856 # 6868 <malloc+0x838>
    1130:	00005097          	auipc	ra,0x5
    1134:	e42080e7          	jalr	-446(ra) # 5f72 <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	a98080e7          	jalr	-1384(ra) # 5bd2 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	72e98993          	addi	s3,s3,1838 # 6888 <malloc+0x858>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	ac4080e7          	jalr	-1340(ra) # 5c32 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	70250513          	addi	a0,a0,1794 # 6898 <malloc+0x868>
    119e:	00005097          	auipc	ra,0x5
    11a2:	dd4080e7          	jalr	-556(ra) # 5f72 <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a2a080e7          	jalr	-1494(ra) # 5bd2 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	6f250513          	addi	a0,a0,1778 # 68b8 <malloc+0x888>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a54080e7          	jalr	-1452(ra) # 5c22 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	6de50513          	addi	a0,a0,1758 # 68b8 <malloc+0x888>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	a30080e7          	jalr	-1488(ra) # 5c12 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	a0c080e7          	jalr	-1524(ra) # 5bfa <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	6bca0a13          	addi	s4,s4,1724 # 68b8 <malloc+0x888>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9579b          	sraiw	a5,s2,0x1f
    1210:	01a7d71b          	srliw	a4,a5,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	9f6080e7          	jalr	-1546(ra) # 5c32 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	66a50513          	addi	a0,a0,1642 # 68b8 <malloc+0x888>
    1256:	00005097          	auipc	ra,0x5
    125a:	9cc080e7          	jalr	-1588(ra) # 5c22 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d79b          	sraiw	a5,s1,0x1f
    126e:	01a7d71b          	srliw	a4,a5,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	98a080e7          	jalr	-1654(ra) # 5c22 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	60250513          	addi	a0,a0,1538 # 68c0 <malloc+0x890>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	cac080e7          	jalr	-852(ra) # 5f72 <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	902080e7          	jalr	-1790(ra) # 5bd2 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	60250513          	addi	a0,a0,1538 # 68e0 <malloc+0x8b0>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	c8c080e7          	jalr	-884(ra) # 5f72 <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	8e2080e7          	jalr	-1822(ra) # 5bd2 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	60650513          	addi	a0,a0,1542 # 6900 <malloc+0x8d0>
    1302:	00005097          	auipc	ra,0x5
    1306:	c70080e7          	jalr	-912(ra) # 5f72 <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	8c6080e7          	jalr	-1850(ra) # 5bd2 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00008497          	auipc	s1,0x8
    1326:	cde48493          	addi	s1,s1,-802 # 9000 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	8da080e7          	jalr	-1830(ra) # 5c0a <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	8a8080e7          	jalr	-1880(ra) # 5be2 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	88e080e7          	jalr	-1906(ra) # 5bd2 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	e1298993          	addi	s3,s3,-494 # 6178 <malloc+0x148>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	88e080e7          	jalr	-1906(ra) # 5c0a <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	848080e7          	jalr	-1976(ra) # 5bd2 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	86a080e7          	jalr	-1942(ra) # 5c22 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	844080e7          	jalr	-1980(ra) # 5c12 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	850080e7          	jalr	-1968(ra) # 5c32 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	76878793          	addi	a5,a5,1896 # 7b58 <malloc+0x1b28>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00005097          	auipc	ra,0x5
    140c:	802080e7          	jalr	-2046(ra) # 5c0a <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00004097          	auipc	ra,0x4
    141a:	7b4080e7          	jalr	1972(ra) # 5bca <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00008797          	auipc	a5,0x8
    142a:	13a78793          	addi	a5,a5,314 # 9560 <big.1282>
    142e:	00009697          	auipc	a3,0x9
    1432:	13268693          	addi	a3,a3,306 # a560 <big.1282+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	00009797          	auipc	a5,0x9
    1448:	10078e23          	sb	zero,284(a5) # a560 <big.1282+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	12c78793          	addi	a5,a5,300 # 8578 <malloc+0x2548>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	d0850513          	addi	a0,a0,-760 # 6178 <malloc+0x148>
    1478:	00004097          	auipc	ra,0x4
    147c:	792080e7          	jalr	1938(ra) # 5c0a <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	52050513          	addi	a0,a0,1312 # 69a8 <malloc+0x978>
    1490:	00005097          	auipc	ra,0x5
    1494:	ae2080e7          	jalr	-1310(ra) # 5f72 <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	738080e7          	jalr	1848(ra) # 5bd2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	47850513          	addi	a0,a0,1144 # 6920 <malloc+0x8f0>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	ac2080e7          	jalr	-1342(ra) # 5f72 <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	718080e7          	jalr	1816(ra) # 5bd2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	47850513          	addi	a0,a0,1144 # 6940 <malloc+0x910>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	aa2080e7          	jalr	-1374(ra) # 5f72 <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	6f8080e7          	jalr	1784(ra) # 5bd2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	47650513          	addi	a0,a0,1142 # 6960 <malloc+0x930>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	a80080e7          	jalr	-1408(ra) # 5f72 <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	6d6080e7          	jalr	1750(ra) # 5bd2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	47e50513          	addi	a0,a0,1150 # 6988 <malloc+0x958>
    1512:	00005097          	auipc	ra,0x5
    1516:	a60080e7          	jalr	-1440(ra) # 5f72 <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	6b6080e7          	jalr	1718(ra) # 5bd2 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	8e450513          	addi	a0,a0,-1820 # 6e08 <malloc+0xdd8>
    152c:	00005097          	auipc	ra,0x5
    1530:	a46080e7          	jalr	-1466(ra) # 5f72 <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	69c080e7          	jalr	1692(ra) # 5bd2 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	690080e7          	jalr	1680(ra) # 5bd2 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	688080e7          	jalr	1672(ra) # 5bda <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	46250513          	addi	a0,a0,1122 # 69d0 <malloc+0x9a0>
    1576:	00005097          	auipc	ra,0x5
    157a:	9fc080e7          	jalr	-1540(ra) # 5f72 <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	652080e7          	jalr	1618(ra) # 5bd2 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e8ca                	sd	s2,80(sp)
    1592:	e4ce                	sd	s3,72(sp)
    1594:	e0d2                	sd	s4,64(sp)
    1596:	fc56                	sd	s5,56(sp)
    1598:	1880                	addi	s0,sp,112
    159a:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159c:	60100593          	li	a1,1537
    15a0:	00005517          	auipc	a0,0x5
    15a4:	c3050513          	addi	a0,a0,-976 # 61d0 <malloc+0x1a0>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	66a080e7          	jalr	1642(ra) # 5c12 <open>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	64a080e7          	jalr	1610(ra) # 5bfa <close>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	612080e7          	jalr	1554(ra) # 5bca <fork>
  if(pid < 0){
    15c0:	08054063          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15c4:	e969                	bnez	a0,1696 <truncate3+0x10e>
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	c06a0a13          	addi	s4,s4,-1018 # 61d0 <malloc+0x1a0>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	45ea8a93          	addi	s5,s5,1118 # 6a30 <malloc+0xa00>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	634080e7          	jalr	1588(ra) # 5c12 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054a63          	bltz	a0,165c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	602080e7          	jalr	1538(ra) # 5bf2 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	06f51f63          	bne	a0,a5,1678 <truncate3+0xf0>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	5fa080e7          	jalr	1530(ra) # 5bfa <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	606080e7          	jalr	1542(ra) # 5c12 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	5cc080e7          	jalr	1484(ra) # 5bea <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	5d2080e7          	jalr	1490(ra) # 5bfa <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	59a080e7          	jalr	1434(ra) # 5bd2 <exit>
    printf("%s: fork failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	3be50513          	addi	a0,a0,958 # 6a00 <malloc+0x9d0>
    164a:	00005097          	auipc	ra,0x5
    164e:	928080e7          	jalr	-1752(ra) # 5f72 <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	57e080e7          	jalr	1406(ra) # 5bd2 <exit>
        printf("%s: open failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	3ba50513          	addi	a0,a0,954 # 6a18 <malloc+0x9e8>
    1666:	00005097          	auipc	ra,0x5
    166a:	90c080e7          	jalr	-1780(ra) # 5f72 <printf>
        exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	562080e7          	jalr	1378(ra) # 5bd2 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1678:	862a                	mv	a2,a0
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	3c450513          	addi	a0,a0,964 # 6a40 <malloc+0xa10>
    1684:	00005097          	auipc	ra,0x5
    1688:	8ee080e7          	jalr	-1810(ra) # 5f72 <printf>
        exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	544080e7          	jalr	1348(ra) # 5bd2 <exit>
    1696:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    169a:	00005a17          	auipc	s4,0x5
    169e:	b36a0a13          	addi	s4,s4,-1226 # 61d0 <malloc+0x1a0>
    int n = write(fd, "xxx", 3);
    16a2:	00005a97          	auipc	s5,0x5
    16a6:	3bea8a93          	addi	s5,s5,958 # 6a60 <malloc+0xa30>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	60100593          	li	a1,1537
    16ae:	8552                	mv	a0,s4
    16b0:	00004097          	auipc	ra,0x4
    16b4:	562080e7          	jalr	1378(ra) # 5c12 <open>
    16b8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ba:	04054763          	bltz	a0,1708 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16be:	460d                	li	a2,3
    16c0:	85d6                	mv	a1,s5
    16c2:	00004097          	auipc	ra,0x4
    16c6:	530080e7          	jalr	1328(ra) # 5bf2 <write>
    if(n != 3){
    16ca:	478d                	li	a5,3
    16cc:	04f51c63          	bne	a0,a5,1724 <truncate3+0x19c>
    close(fd);
    16d0:	8526                	mv	a0,s1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	528080e7          	jalr	1320(ra) # 5bfa <close>
  for(int i = 0; i < 150; i++){
    16da:	39fd                	addiw	s3,s3,-1
    16dc:	fc0997e3          	bnez	s3,16aa <truncate3+0x122>
  wait(&xstatus);
    16e0:	fbc40513          	addi	a0,s0,-68
    16e4:	00004097          	auipc	ra,0x4
    16e8:	4f6080e7          	jalr	1270(ra) # 5bda <wait>
  unlink("truncfile");
    16ec:	00005517          	auipc	a0,0x5
    16f0:	ae450513          	addi	a0,a0,-1308 # 61d0 <malloc+0x1a0>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	52e080e7          	jalr	1326(ra) # 5c22 <unlink>
  exit(xstatus);
    16fc:	fbc42503          	lw	a0,-68(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	4d2080e7          	jalr	1234(ra) # 5bd2 <exit>
      printf("%s: open failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	30e50513          	addi	a0,a0,782 # 6a18 <malloc+0x9e8>
    1712:	00005097          	auipc	ra,0x5
    1716:	860080e7          	jalr	-1952(ra) # 5f72 <printf>
      exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	4b6080e7          	jalr	1206(ra) # 5bd2 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1724:	862a                	mv	a2,a0
    1726:	85ca                	mv	a1,s2
    1728:	00005517          	auipc	a0,0x5
    172c:	34050513          	addi	a0,a0,832 # 6a68 <malloc+0xa38>
    1730:	00005097          	auipc	ra,0x5
    1734:	842080e7          	jalr	-1982(ra) # 5f72 <printf>
      exit(1);
    1738:	4505                	li	a0,1
    173a:	00004097          	auipc	ra,0x4
    173e:	498080e7          	jalr	1176(ra) # 5bd2 <exit>

0000000000001742 <exectest>:
{
    1742:	715d                	addi	sp,sp,-80
    1744:	e486                	sd	ra,72(sp)
    1746:	e0a2                	sd	s0,64(sp)
    1748:	fc26                	sd	s1,56(sp)
    174a:	f84a                	sd	s2,48(sp)
    174c:	0880                	addi	s0,sp,80
    174e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1750:	00005797          	auipc	a5,0x5
    1754:	a2878793          	addi	a5,a5,-1496 # 6178 <malloc+0x148>
    1758:	fcf43023          	sd	a5,-64(s0)
    175c:	00005797          	auipc	a5,0x5
    1760:	32c78793          	addi	a5,a5,812 # 6a88 <malloc+0xa58>
    1764:	fcf43423          	sd	a5,-56(s0)
    1768:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176c:	00005517          	auipc	a0,0x5
    1770:	32450513          	addi	a0,a0,804 # 6a90 <malloc+0xa60>
    1774:	00004097          	auipc	ra,0x4
    1778:	4ae080e7          	jalr	1198(ra) # 5c22 <unlink>
  pid = fork();
    177c:	00004097          	auipc	ra,0x4
    1780:	44e080e7          	jalr	1102(ra) # 5bca <fork>
  if(pid < 0) {
    1784:	04054663          	bltz	a0,17d0 <exectest+0x8e>
    1788:	84aa                	mv	s1,a0
  if(pid == 0) {
    178a:	e959                	bnez	a0,1820 <exectest+0xde>
    close(1);
    178c:	4505                	li	a0,1
    178e:	00004097          	auipc	ra,0x4
    1792:	46c080e7          	jalr	1132(ra) # 5bfa <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1796:	20100593          	li	a1,513
    179a:	00005517          	auipc	a0,0x5
    179e:	2f650513          	addi	a0,a0,758 # 6a90 <malloc+0xa60>
    17a2:	00004097          	auipc	ra,0x4
    17a6:	470080e7          	jalr	1136(ra) # 5c12 <open>
    if(fd < 0) {
    17aa:	04054163          	bltz	a0,17ec <exectest+0xaa>
    if(fd != 1) {
    17ae:	4785                	li	a5,1
    17b0:	04f50c63          	beq	a0,a5,1808 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b4:	85ca                	mv	a1,s2
    17b6:	00005517          	auipc	a0,0x5
    17ba:	2fa50513          	addi	a0,a0,762 # 6ab0 <malloc+0xa80>
    17be:	00004097          	auipc	ra,0x4
    17c2:	7b4080e7          	jalr	1972(ra) # 5f72 <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	00004097          	auipc	ra,0x4
    17cc:	40a080e7          	jalr	1034(ra) # 5bd2 <exit>
     printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	22e50513          	addi	a0,a0,558 # 6a00 <malloc+0x9d0>
    17da:	00004097          	auipc	ra,0x4
    17de:	798080e7          	jalr	1944(ra) # 5f72 <printf>
     exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	3ee080e7          	jalr	1006(ra) # 5bd2 <exit>
      printf("%s: create failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	2aa50513          	addi	a0,a0,682 # 6a98 <malloc+0xa68>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	77c080e7          	jalr	1916(ra) # 5f72 <printf>
      exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	3d2080e7          	jalr	978(ra) # 5bd2 <exit>
    if(exec("echo", echoargv) < 0){
    1808:	fc040593          	addi	a1,s0,-64
    180c:	00005517          	auipc	a0,0x5
    1810:	96c50513          	addi	a0,a0,-1684 # 6178 <malloc+0x148>
    1814:	00004097          	auipc	ra,0x4
    1818:	3f6080e7          	jalr	1014(ra) # 5c0a <exec>
    181c:	02054163          	bltz	a0,183e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1820:	fdc40513          	addi	a0,s0,-36
    1824:	00004097          	auipc	ra,0x4
    1828:	3b6080e7          	jalr	950(ra) # 5bda <wait>
    182c:	02951763          	bne	a0,s1,185a <exectest+0x118>
  if(xstatus != 0)
    1830:	fdc42503          	lw	a0,-36(s0)
    1834:	cd0d                	beqz	a0,186e <exectest+0x12c>
    exit(xstatus);
    1836:	00004097          	auipc	ra,0x4
    183a:	39c080e7          	jalr	924(ra) # 5bd2 <exit>
      printf("%s: exec echo failed\n", s);
    183e:	85ca                	mv	a1,s2
    1840:	00005517          	auipc	a0,0x5
    1844:	28050513          	addi	a0,a0,640 # 6ac0 <malloc+0xa90>
    1848:	00004097          	auipc	ra,0x4
    184c:	72a080e7          	jalr	1834(ra) # 5f72 <printf>
      exit(1);
    1850:	4505                	li	a0,1
    1852:	00004097          	auipc	ra,0x4
    1856:	380080e7          	jalr	896(ra) # 5bd2 <exit>
    printf("%s: wait failed!\n", s);
    185a:	85ca                	mv	a1,s2
    185c:	00005517          	auipc	a0,0x5
    1860:	27c50513          	addi	a0,a0,636 # 6ad8 <malloc+0xaa8>
    1864:	00004097          	auipc	ra,0x4
    1868:	70e080e7          	jalr	1806(ra) # 5f72 <printf>
    186c:	b7d1                	j	1830 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186e:	4581                	li	a1,0
    1870:	00005517          	auipc	a0,0x5
    1874:	22050513          	addi	a0,a0,544 # 6a90 <malloc+0xa60>
    1878:	00004097          	auipc	ra,0x4
    187c:	39a080e7          	jalr	922(ra) # 5c12 <open>
  if(fd < 0) {
    1880:	02054a63          	bltz	a0,18b4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1884:	4609                	li	a2,2
    1886:	fb840593          	addi	a1,s0,-72
    188a:	00004097          	auipc	ra,0x4
    188e:	360080e7          	jalr	864(ra) # 5bea <read>
    1892:	4789                	li	a5,2
    1894:	02f50e63          	beq	a0,a5,18d0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1898:	85ca                	mv	a1,s2
    189a:	00005517          	auipc	a0,0x5
    189e:	cae50513          	addi	a0,a0,-850 # 6548 <malloc+0x518>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	6d0080e7          	jalr	1744(ra) # 5f72 <printf>
    exit(1);
    18aa:	4505                	li	a0,1
    18ac:	00004097          	auipc	ra,0x4
    18b0:	326080e7          	jalr	806(ra) # 5bd2 <exit>
    printf("%s: open failed\n", s);
    18b4:	85ca                	mv	a1,s2
    18b6:	00005517          	auipc	a0,0x5
    18ba:	16250513          	addi	a0,a0,354 # 6a18 <malloc+0x9e8>
    18be:	00004097          	auipc	ra,0x4
    18c2:	6b4080e7          	jalr	1716(ra) # 5f72 <printf>
    exit(1);
    18c6:	4505                	li	a0,1
    18c8:	00004097          	auipc	ra,0x4
    18cc:	30a080e7          	jalr	778(ra) # 5bd2 <exit>
  unlink("echo-ok");
    18d0:	00005517          	auipc	a0,0x5
    18d4:	1c050513          	addi	a0,a0,448 # 6a90 <malloc+0xa60>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	34a080e7          	jalr	842(ra) # 5c22 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e0:	fb844703          	lbu	a4,-72(s0)
    18e4:	04f00793          	li	a5,79
    18e8:	00f71863          	bne	a4,a5,18f8 <exectest+0x1b6>
    18ec:	fb944703          	lbu	a4,-71(s0)
    18f0:	04b00793          	li	a5,75
    18f4:	02f70063          	beq	a4,a5,1914 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f8:	85ca                	mv	a1,s2
    18fa:	00005517          	auipc	a0,0x5
    18fe:	1f650513          	addi	a0,a0,502 # 6af0 <malloc+0xac0>
    1902:	00004097          	auipc	ra,0x4
    1906:	670080e7          	jalr	1648(ra) # 5f72 <printf>
    exit(1);
    190a:	4505                	li	a0,1
    190c:	00004097          	auipc	ra,0x4
    1910:	2c6080e7          	jalr	710(ra) # 5bd2 <exit>
    exit(0);
    1914:	4501                	li	a0,0
    1916:	00004097          	auipc	ra,0x4
    191a:	2bc080e7          	jalr	700(ra) # 5bd2 <exit>

000000000000191e <pipe1>:
{
    191e:	711d                	addi	sp,sp,-96
    1920:	ec86                	sd	ra,88(sp)
    1922:	e8a2                	sd	s0,80(sp)
    1924:	e4a6                	sd	s1,72(sp)
    1926:	e0ca                	sd	s2,64(sp)
    1928:	fc4e                	sd	s3,56(sp)
    192a:	f852                	sd	s4,48(sp)
    192c:	f456                	sd	s5,40(sp)
    192e:	f05a                	sd	s6,32(sp)
    1930:	ec5e                	sd	s7,24(sp)
    1932:	1080                	addi	s0,sp,96
    1934:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1936:	fa840513          	addi	a0,s0,-88
    193a:	00004097          	auipc	ra,0x4
    193e:	2a8080e7          	jalr	680(ra) # 5be2 <pipe>
    1942:	ed25                	bnez	a0,19ba <pipe1+0x9c>
    1944:	84aa                	mv	s1,a0
  pid = fork();
    1946:	00004097          	auipc	ra,0x4
    194a:	284080e7          	jalr	644(ra) # 5bca <fork>
    194e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1950:	c159                	beqz	a0,19d6 <pipe1+0xb8>
  } else if(pid > 0){
    1952:	16a05e63          	blez	a0,1ace <pipe1+0x1b0>
    close(fds[1]);
    1956:	fac42503          	lw	a0,-84(s0)
    195a:	00004097          	auipc	ra,0x4
    195e:	2a0080e7          	jalr	672(ra) # 5bfa <close>
    total = 0;
    1962:	8a26                	mv	s4,s1
    cc = 1;
    1964:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1966:	0000ba97          	auipc	s5,0xb
    196a:	312a8a93          	addi	s5,s5,786 # cc78 <buf>
      if(cc > sizeof(buf))
    196e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1970:	864e                	mv	a2,s3
    1972:	85d6                	mv	a1,s5
    1974:	fa842503          	lw	a0,-88(s0)
    1978:	00004097          	auipc	ra,0x4
    197c:	272080e7          	jalr	626(ra) # 5bea <read>
    1980:	10a05263          	blez	a0,1a84 <pipe1+0x166>
      for(i = 0; i < n; i++){
    1984:	0000b717          	auipc	a4,0xb
    1988:	2f470713          	addi	a4,a4,756 # cc78 <buf>
    198c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1990:	00074683          	lbu	a3,0(a4)
    1994:	0ff4f793          	andi	a5,s1,255
    1998:	2485                	addiw	s1,s1,1
    199a:	0cf69163          	bne	a3,a5,1a5c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    199e:	0705                	addi	a4,a4,1
    19a0:	fec498e3          	bne	s1,a2,1990 <pipe1+0x72>
      total += n;
    19a4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a8:	0019979b          	slliw	a5,s3,0x1
    19ac:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b0:	013b7363          	bgeu	s6,s3,19b6 <pipe1+0x98>
        cc = sizeof(buf);
    19b4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19b6:	84b2                	mv	s1,a2
    19b8:	bf65                	j	1970 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19ba:	85ca                	mv	a1,s2
    19bc:	00005517          	auipc	a0,0x5
    19c0:	14c50513          	addi	a0,a0,332 # 6b08 <malloc+0xad8>
    19c4:	00004097          	auipc	ra,0x4
    19c8:	5ae080e7          	jalr	1454(ra) # 5f72 <printf>
    exit(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	204080e7          	jalr	516(ra) # 5bd2 <exit>
    close(fds[0]);
    19d6:	fa842503          	lw	a0,-88(s0)
    19da:	00004097          	auipc	ra,0x4
    19de:	220080e7          	jalr	544(ra) # 5bfa <close>
    for(n = 0; n < N; n++){
    19e2:	0000bb17          	auipc	s6,0xb
    19e6:	296b0b13          	addi	s6,s6,662 # cc78 <buf>
    19ea:	416004bb          	negw	s1,s6
    19ee:	0ff4f493          	andi	s1,s1,255
    19f2:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f6:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f8:	6a85                	lui	s5,0x1
    19fa:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    19fe:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a00:	0097873b          	addw	a4,a5,s1
    1a04:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a08:	0785                	addi	a5,a5,1
    1a0a:	fef99be3          	bne	s3,a5,1a00 <pipe1+0xe2>
    1a0e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a12:	40900613          	li	a2,1033
    1a16:	85de                	mv	a1,s7
    1a18:	fac42503          	lw	a0,-84(s0)
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	1d6080e7          	jalr	470(ra) # 5bf2 <write>
    1a24:	40900793          	li	a5,1033
    1a28:	00f51c63          	bne	a0,a5,1a40 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a2c:	24a5                	addiw	s1,s1,9
    1a2e:	0ff4f493          	andi	s1,s1,255
    1a32:	fd5a16e3          	bne	s4,s5,19fe <pipe1+0xe0>
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	00004097          	auipc	ra,0x4
    1a3c:	19a080e7          	jalr	410(ra) # 5bd2 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a40:	85ca                	mv	a1,s2
    1a42:	00005517          	auipc	a0,0x5
    1a46:	0de50513          	addi	a0,a0,222 # 6b20 <malloc+0xaf0>
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	528080e7          	jalr	1320(ra) # 5f72 <printf>
        exit(1);
    1a52:	4505                	li	a0,1
    1a54:	00004097          	auipc	ra,0x4
    1a58:	17e080e7          	jalr	382(ra) # 5bd2 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a5c:	85ca                	mv	a1,s2
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	0da50513          	addi	a0,a0,218 # 6b38 <malloc+0xb08>
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	50c080e7          	jalr	1292(ra) # 5f72 <printf>
}
    1a6e:	60e6                	ld	ra,88(sp)
    1a70:	6446                	ld	s0,80(sp)
    1a72:	64a6                	ld	s1,72(sp)
    1a74:	6906                	ld	s2,64(sp)
    1a76:	79e2                	ld	s3,56(sp)
    1a78:	7a42                	ld	s4,48(sp)
    1a7a:	7aa2                	ld	s5,40(sp)
    1a7c:	7b02                	ld	s6,32(sp)
    1a7e:	6be2                	ld	s7,24(sp)
    1a80:	6125                	addi	sp,sp,96
    1a82:	8082                	ret
    if(total != N * SZ){
    1a84:	6785                	lui	a5,0x1
    1a86:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1a8a:	02fa0063          	beq	s4,a5,1aaa <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8e:	85d2                	mv	a1,s4
    1a90:	00005517          	auipc	a0,0x5
    1a94:	0c050513          	addi	a0,a0,192 # 6b50 <malloc+0xb20>
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	4da080e7          	jalr	1242(ra) # 5f72 <printf>
      exit(1);
    1aa0:	4505                	li	a0,1
    1aa2:	00004097          	auipc	ra,0x4
    1aa6:	130080e7          	jalr	304(ra) # 5bd2 <exit>
    close(fds[0]);
    1aaa:	fa842503          	lw	a0,-88(s0)
    1aae:	00004097          	auipc	ra,0x4
    1ab2:	14c080e7          	jalr	332(ra) # 5bfa <close>
    wait(&xstatus);
    1ab6:	fa440513          	addi	a0,s0,-92
    1aba:	00004097          	auipc	ra,0x4
    1abe:	120080e7          	jalr	288(ra) # 5bda <wait>
    exit(xstatus);
    1ac2:	fa442503          	lw	a0,-92(s0)
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	10c080e7          	jalr	268(ra) # 5bd2 <exit>
    printf("%s: fork() failed\n", s);
    1ace:	85ca                	mv	a1,s2
    1ad0:	00005517          	auipc	a0,0x5
    1ad4:	0a050513          	addi	a0,a0,160 # 6b70 <malloc+0xb40>
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	49a080e7          	jalr	1178(ra) # 5f72 <printf>
    exit(1);
    1ae0:	4505                	li	a0,1
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	0f0080e7          	jalr	240(ra) # 5bd2 <exit>

0000000000001aea <exitwait>:
{
    1aea:	7139                	addi	sp,sp,-64
    1aec:	fc06                	sd	ra,56(sp)
    1aee:	f822                	sd	s0,48(sp)
    1af0:	f426                	sd	s1,40(sp)
    1af2:	f04a                	sd	s2,32(sp)
    1af4:	ec4e                	sd	s3,24(sp)
    1af6:	e852                	sd	s4,16(sp)
    1af8:	0080                	addi	s0,sp,64
    1afa:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1afc:	4901                	li	s2,0
    1afe:	06400993          	li	s3,100
    pid = fork();
    1b02:	00004097          	auipc	ra,0x4
    1b06:	0c8080e7          	jalr	200(ra) # 5bca <fork>
    1b0a:	84aa                	mv	s1,a0
    if(pid < 0){
    1b0c:	02054a63          	bltz	a0,1b40 <exitwait+0x56>
    if(pid){
    1b10:	c151                	beqz	a0,1b94 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b12:	fcc40513          	addi	a0,s0,-52
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	0c4080e7          	jalr	196(ra) # 5bda <wait>
    1b1e:	02951f63          	bne	a0,s1,1b5c <exitwait+0x72>
      if(i != xstate) {
    1b22:	fcc42783          	lw	a5,-52(s0)
    1b26:	05279963          	bne	a5,s2,1b78 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b2a:	2905                	addiw	s2,s2,1
    1b2c:	fd391be3          	bne	s2,s3,1b02 <exitwait+0x18>
}
    1b30:	70e2                	ld	ra,56(sp)
    1b32:	7442                	ld	s0,48(sp)
    1b34:	74a2                	ld	s1,40(sp)
    1b36:	7902                	ld	s2,32(sp)
    1b38:	69e2                	ld	s3,24(sp)
    1b3a:	6a42                	ld	s4,16(sp)
    1b3c:	6121                	addi	sp,sp,64
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85d2                	mv	a1,s4
    1b42:	00005517          	auipc	a0,0x5
    1b46:	ebe50513          	addi	a0,a0,-322 # 6a00 <malloc+0x9d0>
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	428080e7          	jalr	1064(ra) # 5f72 <printf>
      exit(1);
    1b52:	4505                	li	a0,1
    1b54:	00004097          	auipc	ra,0x4
    1b58:	07e080e7          	jalr	126(ra) # 5bd2 <exit>
        printf("%s: wait wrong pid\n", s);
    1b5c:	85d2                	mv	a1,s4
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	02a50513          	addi	a0,a0,42 # 6b88 <malloc+0xb58>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	40c080e7          	jalr	1036(ra) # 5f72 <printf>
        exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	062080e7          	jalr	98(ra) # 5bd2 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b78:	85d2                	mv	a1,s4
    1b7a:	00005517          	auipc	a0,0x5
    1b7e:	02650513          	addi	a0,a0,38 # 6ba0 <malloc+0xb70>
    1b82:	00004097          	auipc	ra,0x4
    1b86:	3f0080e7          	jalr	1008(ra) # 5f72 <printf>
        exit(1);
    1b8a:	4505                	li	a0,1
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	046080e7          	jalr	70(ra) # 5bd2 <exit>
      exit(i);
    1b94:	854a                	mv	a0,s2
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	03c080e7          	jalr	60(ra) # 5bd2 <exit>

0000000000001b9e <twochildren>:
{
    1b9e:	1101                	addi	sp,sp,-32
    1ba0:	ec06                	sd	ra,24(sp)
    1ba2:	e822                	sd	s0,16(sp)
    1ba4:	e426                	sd	s1,8(sp)
    1ba6:	e04a                	sd	s2,0(sp)
    1ba8:	1000                	addi	s0,sp,32
    1baa:	892a                	mv	s2,a0
    1bac:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	01a080e7          	jalr	26(ra) # 5bca <fork>
    if(pid1 < 0){
    1bb8:	02054c63          	bltz	a0,1bf0 <twochildren+0x52>
    if(pid1 == 0){
    1bbc:	c921                	beqz	a0,1c0c <twochildren+0x6e>
      int pid2 = fork();
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	00c080e7          	jalr	12(ra) # 5bca <fork>
      if(pid2 < 0){
    1bc6:	04054763          	bltz	a0,1c14 <twochildren+0x76>
      if(pid2 == 0){
    1bca:	c13d                	beqz	a0,1c30 <twochildren+0x92>
        wait(0);
    1bcc:	4501                	li	a0,0
    1bce:	00004097          	auipc	ra,0x4
    1bd2:	00c080e7          	jalr	12(ra) # 5bda <wait>
        wait(0);
    1bd6:	4501                	li	a0,0
    1bd8:	00004097          	auipc	ra,0x4
    1bdc:	002080e7          	jalr	2(ra) # 5bda <wait>
  for(int i = 0; i < 1000; i++){
    1be0:	34fd                	addiw	s1,s1,-1
    1be2:	f4f9                	bnez	s1,1bb0 <twochildren+0x12>
}
    1be4:	60e2                	ld	ra,24(sp)
    1be6:	6442                	ld	s0,16(sp)
    1be8:	64a2                	ld	s1,8(sp)
    1bea:	6902                	ld	s2,0(sp)
    1bec:	6105                	addi	sp,sp,32
    1bee:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf0:	85ca                	mv	a1,s2
    1bf2:	00005517          	auipc	a0,0x5
    1bf6:	e0e50513          	addi	a0,a0,-498 # 6a00 <malloc+0x9d0>
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	378080e7          	jalr	888(ra) # 5f72 <printf>
      exit(1);
    1c02:	4505                	li	a0,1
    1c04:	00004097          	auipc	ra,0x4
    1c08:	fce080e7          	jalr	-50(ra) # 5bd2 <exit>
      exit(0);
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	fc6080e7          	jalr	-58(ra) # 5bd2 <exit>
        printf("%s: fork failed\n", s);
    1c14:	85ca                	mv	a1,s2
    1c16:	00005517          	auipc	a0,0x5
    1c1a:	dea50513          	addi	a0,a0,-534 # 6a00 <malloc+0x9d0>
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	354080e7          	jalr	852(ra) # 5f72 <printf>
        exit(1);
    1c26:	4505                	li	a0,1
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	faa080e7          	jalr	-86(ra) # 5bd2 <exit>
        exit(0);
    1c30:	00004097          	auipc	ra,0x4
    1c34:	fa2080e7          	jalr	-94(ra) # 5bd2 <exit>

0000000000001c38 <forkfork>:
{
    1c38:	7179                	addi	sp,sp,-48
    1c3a:	f406                	sd	ra,40(sp)
    1c3c:	f022                	sd	s0,32(sp)
    1c3e:	ec26                	sd	s1,24(sp)
    1c40:	1800                	addi	s0,sp,48
    1c42:	84aa                	mv	s1,a0
    int pid = fork();
    1c44:	00004097          	auipc	ra,0x4
    1c48:	f86080e7          	jalr	-122(ra) # 5bca <fork>
    if(pid < 0){
    1c4c:	04054163          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c50:	cd29                	beqz	a0,1caa <forkfork+0x72>
    int pid = fork();
    1c52:	00004097          	auipc	ra,0x4
    1c56:	f78080e7          	jalr	-136(ra) # 5bca <fork>
    if(pid < 0){
    1c5a:	02054a63          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c5e:	c531                	beqz	a0,1caa <forkfork+0x72>
    wait(&xstatus);
    1c60:	fdc40513          	addi	a0,s0,-36
    1c64:	00004097          	auipc	ra,0x4
    1c68:	f76080e7          	jalr	-138(ra) # 5bda <wait>
    if(xstatus != 0) {
    1c6c:	fdc42783          	lw	a5,-36(s0)
    1c70:	ebbd                	bnez	a5,1ce6 <forkfork+0xae>
    wait(&xstatus);
    1c72:	fdc40513          	addi	a0,s0,-36
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	f64080e7          	jalr	-156(ra) # 5bda <wait>
    if(xstatus != 0) {
    1c7e:	fdc42783          	lw	a5,-36(s0)
    1c82:	e3b5                	bnez	a5,1ce6 <forkfork+0xae>
}
    1c84:	70a2                	ld	ra,40(sp)
    1c86:	7402                	ld	s0,32(sp)
    1c88:	64e2                	ld	s1,24(sp)
    1c8a:	6145                	addi	sp,sp,48
    1c8c:	8082                	ret
      printf("%s: fork failed", s);
    1c8e:	85a6                	mv	a1,s1
    1c90:	00005517          	auipc	a0,0x5
    1c94:	f3050513          	addi	a0,a0,-208 # 6bc0 <malloc+0xb90>
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	2da080e7          	jalr	730(ra) # 5f72 <printf>
      exit(1);
    1ca0:	4505                	li	a0,1
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	f30080e7          	jalr	-208(ra) # 5bd2 <exit>
{
    1caa:	0c800493          	li	s1,200
        int pid1 = fork();
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	f1c080e7          	jalr	-228(ra) # 5bca <fork>
        if(pid1 < 0){
    1cb6:	00054f63          	bltz	a0,1cd4 <forkfork+0x9c>
        if(pid1 == 0){
    1cba:	c115                	beqz	a0,1cde <forkfork+0xa6>
        wait(0);
    1cbc:	4501                	li	a0,0
    1cbe:	00004097          	auipc	ra,0x4
    1cc2:	f1c080e7          	jalr	-228(ra) # 5bda <wait>
      for(int j = 0; j < 200; j++){
    1cc6:	34fd                	addiw	s1,s1,-1
    1cc8:	f0fd                	bnez	s1,1cae <forkfork+0x76>
      exit(0);
    1cca:	4501                	li	a0,0
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	f06080e7          	jalr	-250(ra) # 5bd2 <exit>
          exit(1);
    1cd4:	4505                	li	a0,1
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	efc080e7          	jalr	-260(ra) # 5bd2 <exit>
          exit(0);
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	ef4080e7          	jalr	-268(ra) # 5bd2 <exit>
      printf("%s: fork in child failed", s);
    1ce6:	85a6                	mv	a1,s1
    1ce8:	00005517          	auipc	a0,0x5
    1cec:	ee850513          	addi	a0,a0,-280 # 6bd0 <malloc+0xba0>
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	282080e7          	jalr	642(ra) # 5f72 <printf>
      exit(1);
    1cf8:	4505                	li	a0,1
    1cfa:	00004097          	auipc	ra,0x4
    1cfe:	ed8080e7          	jalr	-296(ra) # 5bd2 <exit>

0000000000001d02 <reparent2>:
{
    1d02:	1101                	addi	sp,sp,-32
    1d04:	ec06                	sd	ra,24(sp)
    1d06:	e822                	sd	s0,16(sp)
    1d08:	e426                	sd	s1,8(sp)
    1d0a:	1000                	addi	s0,sp,32
    1d0c:	32000493          	li	s1,800
    int pid1 = fork();
    1d10:	00004097          	auipc	ra,0x4
    1d14:	eba080e7          	jalr	-326(ra) # 5bca <fork>
    if(pid1 < 0){
    1d18:	00054f63          	bltz	a0,1d36 <reparent2+0x34>
    if(pid1 == 0){
    1d1c:	c915                	beqz	a0,1d50 <reparent2+0x4e>
    wait(0);
    1d1e:	4501                	li	a0,0
    1d20:	00004097          	auipc	ra,0x4
    1d24:	eba080e7          	jalr	-326(ra) # 5bda <wait>
  for(int i = 0; i < 800; i++){
    1d28:	34fd                	addiw	s1,s1,-1
    1d2a:	f0fd                	bnez	s1,1d10 <reparent2+0xe>
  exit(0);
    1d2c:	4501                	li	a0,0
    1d2e:	00004097          	auipc	ra,0x4
    1d32:	ea4080e7          	jalr	-348(ra) # 5bd2 <exit>
      printf("fork failed\n");
    1d36:	00005517          	auipc	a0,0x5
    1d3a:	0d250513          	addi	a0,a0,210 # 6e08 <malloc+0xdd8>
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	234080e7          	jalr	564(ra) # 5f72 <printf>
      exit(1);
    1d46:	4505                	li	a0,1
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	e8a080e7          	jalr	-374(ra) # 5bd2 <exit>
      fork();
    1d50:	00004097          	auipc	ra,0x4
    1d54:	e7a080e7          	jalr	-390(ra) # 5bca <fork>
      fork();
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	e72080e7          	jalr	-398(ra) # 5bca <fork>
      exit(0);
    1d60:	4501                	li	a0,0
    1d62:	00004097          	auipc	ra,0x4
    1d66:	e70080e7          	jalr	-400(ra) # 5bd2 <exit>

0000000000001d6a <createdelete>:
{
    1d6a:	7175                	addi	sp,sp,-144
    1d6c:	e506                	sd	ra,136(sp)
    1d6e:	e122                	sd	s0,128(sp)
    1d70:	fca6                	sd	s1,120(sp)
    1d72:	f8ca                	sd	s2,112(sp)
    1d74:	f4ce                	sd	s3,104(sp)
    1d76:	f0d2                	sd	s4,96(sp)
    1d78:	ecd6                	sd	s5,88(sp)
    1d7a:	e8da                	sd	s6,80(sp)
    1d7c:	e4de                	sd	s7,72(sp)
    1d7e:	e0e2                	sd	s8,64(sp)
    1d80:	fc66                	sd	s9,56(sp)
    1d82:	0900                	addi	s0,sp,144
    1d84:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d86:	4901                	li	s2,0
    1d88:	4991                	li	s3,4
    pid = fork();
    1d8a:	00004097          	auipc	ra,0x4
    1d8e:	e40080e7          	jalr	-448(ra) # 5bca <fork>
    1d92:	84aa                	mv	s1,a0
    if(pid < 0){
    1d94:	02054f63          	bltz	a0,1dd2 <createdelete+0x68>
    if(pid == 0){
    1d98:	c939                	beqz	a0,1dee <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d9a:	2905                	addiw	s2,s2,1
    1d9c:	ff3917e3          	bne	s2,s3,1d8a <createdelete+0x20>
    1da0:	4491                	li	s1,4
    wait(&xstatus);
    1da2:	f7c40513          	addi	a0,s0,-132
    1da6:	00004097          	auipc	ra,0x4
    1daa:	e34080e7          	jalr	-460(ra) # 5bda <wait>
    if(xstatus != 0)
    1dae:	f7c42903          	lw	s2,-132(s0)
    1db2:	0e091263          	bnez	s2,1e96 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1db6:	34fd                	addiw	s1,s1,-1
    1db8:	f4ed                	bnez	s1,1da2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dba:	f8040123          	sb	zero,-126(s0)
    1dbe:	03000993          	li	s3,48
    1dc2:	5a7d                	li	s4,-1
    1dc4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dc8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dca:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dcc:	07400a93          	li	s5,116
    1dd0:	a29d                	j	1f36 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd2:	85e6                	mv	a1,s9
    1dd4:	00005517          	auipc	a0,0x5
    1dd8:	03450513          	addi	a0,a0,52 # 6e08 <malloc+0xdd8>
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	196080e7          	jalr	406(ra) # 5f72 <printf>
      exit(1);
    1de4:	4505                	li	a0,1
    1de6:	00004097          	auipc	ra,0x4
    1dea:	dec080e7          	jalr	-532(ra) # 5bd2 <exit>
      name[0] = 'p' + pi;
    1dee:	0709091b          	addiw	s2,s2,112
    1df2:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df6:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1dfa:	4951                	li	s2,20
    1dfc:	a015                	j	1e20 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfe:	85e6                	mv	a1,s9
    1e00:	00005517          	auipc	a0,0x5
    1e04:	c9850513          	addi	a0,a0,-872 # 6a98 <malloc+0xa68>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	16a080e7          	jalr	362(ra) # 5f72 <printf>
          exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00004097          	auipc	ra,0x4
    1e16:	dc0080e7          	jalr	-576(ra) # 5bd2 <exit>
      for(i = 0; i < N; i++){
    1e1a:	2485                	addiw	s1,s1,1
    1e1c:	07248863          	beq	s1,s2,1e8c <createdelete+0x122>
        name[1] = '0' + i;
    1e20:	0304879b          	addiw	a5,s1,48
    1e24:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e28:	20200593          	li	a1,514
    1e2c:	f8040513          	addi	a0,s0,-128
    1e30:	00004097          	auipc	ra,0x4
    1e34:	de2080e7          	jalr	-542(ra) # 5c12 <open>
        if(fd < 0){
    1e38:	fc0543e3          	bltz	a0,1dfe <createdelete+0x94>
        close(fd);
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	dbe080e7          	jalr	-578(ra) # 5bfa <close>
        if(i > 0 && (i % 2 ) == 0){
    1e44:	fc905be3          	blez	s1,1e1a <createdelete+0xb0>
    1e48:	0014f793          	andi	a5,s1,1
    1e4c:	f7f9                	bnez	a5,1e1a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4e:	01f4d79b          	srliw	a5,s1,0x1f
    1e52:	9fa5                	addw	a5,a5,s1
    1e54:	4017d79b          	sraiw	a5,a5,0x1
    1e58:	0307879b          	addiw	a5,a5,48
    1e5c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e60:	f8040513          	addi	a0,s0,-128
    1e64:	00004097          	auipc	ra,0x4
    1e68:	dbe080e7          	jalr	-578(ra) # 5c22 <unlink>
    1e6c:	fa0557e3          	bgez	a0,1e1a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e70:	85e6                	mv	a1,s9
    1e72:	00005517          	auipc	a0,0x5
    1e76:	d7e50513          	addi	a0,a0,-642 # 6bf0 <malloc+0xbc0>
    1e7a:	00004097          	auipc	ra,0x4
    1e7e:	0f8080e7          	jalr	248(ra) # 5f72 <printf>
            exit(1);
    1e82:	4505                	li	a0,1
    1e84:	00004097          	auipc	ra,0x4
    1e88:	d4e080e7          	jalr	-690(ra) # 5bd2 <exit>
      exit(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	d44080e7          	jalr	-700(ra) # 5bd2 <exit>
      exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00004097          	auipc	ra,0x4
    1e9c:	d3a080e7          	jalr	-710(ra) # 5bd2 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea0:	f8040613          	addi	a2,s0,-128
    1ea4:	85e6                	mv	a1,s9
    1ea6:	00005517          	auipc	a0,0x5
    1eaa:	d6250513          	addi	a0,a0,-670 # 6c08 <malloc+0xbd8>
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	0c4080e7          	jalr	196(ra) # 5f72 <printf>
        exit(1);
    1eb6:	4505                	li	a0,1
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	d1a080e7          	jalr	-742(ra) # 5bd2 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ec0:	054b7163          	bgeu	s6,s4,1f02 <createdelete+0x198>
      if(fd >= 0)
    1ec4:	02055a63          	bgez	a0,1ef8 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ec8:	2485                	addiw	s1,s1,1
    1eca:	0ff4f493          	andi	s1,s1,255
    1ece:	05548c63          	beq	s1,s5,1f26 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1eda:	4581                	li	a1,0
    1edc:	f8040513          	addi	a0,s0,-128
    1ee0:	00004097          	auipc	ra,0x4
    1ee4:	d32080e7          	jalr	-718(ra) # 5c12 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ee8:	00090463          	beqz	s2,1ef0 <createdelete+0x186>
    1eec:	fd2bdae3          	bge	s7,s2,1ec0 <createdelete+0x156>
    1ef0:	fa0548e3          	bltz	a0,1ea0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef4:	014b7963          	bgeu	s6,s4,1f06 <createdelete+0x19c>
        close(fd);
    1ef8:	00004097          	auipc	ra,0x4
    1efc:	d02080e7          	jalr	-766(ra) # 5bfa <close>
    1f00:	b7e1                	j	1ec8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f02:	fc0543e3          	bltz	a0,1ec8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f06:	f8040613          	addi	a2,s0,-128
    1f0a:	85e6                	mv	a1,s9
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	d2450513          	addi	a0,a0,-732 # 6c30 <malloc+0xc00>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	05e080e7          	jalr	94(ra) # 5f72 <printf>
        exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	cb4080e7          	jalr	-844(ra) # 5bd2 <exit>
  for(i = 0; i < N; i++){
    1f26:	2905                	addiw	s2,s2,1
    1f28:	2a05                	addiw	s4,s4,1
    1f2a:	2985                	addiw	s3,s3,1
    1f2c:	0ff9f993          	andi	s3,s3,255
    1f30:	47d1                	li	a5,20
    1f32:	02f90a63          	beq	s2,a5,1f66 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f36:	84e2                	mv	s1,s8
    1f38:	bf69                	j	1ed2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f3a:	2905                	addiw	s2,s2,1
    1f3c:	0ff97913          	andi	s2,s2,255
    1f40:	2985                	addiw	s3,s3,1
    1f42:	0ff9f993          	andi	s3,s3,255
    1f46:	03490863          	beq	s2,s4,1f76 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f4a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f4c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f50:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f54:	f8040513          	addi	a0,s0,-128
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	cca080e7          	jalr	-822(ra) # 5c22 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f60:	34fd                	addiw	s1,s1,-1
    1f62:	f4ed                	bnez	s1,1f4c <createdelete+0x1e2>
    1f64:	bfd9                	j	1f3a <createdelete+0x1d0>
    1f66:	03000993          	li	s3,48
    1f6a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f70:	08400a13          	li	s4,132
    1f74:	bfd9                	j	1f4a <createdelete+0x1e0>
}
    1f76:	60aa                	ld	ra,136(sp)
    1f78:	640a                	ld	s0,128(sp)
    1f7a:	74e6                	ld	s1,120(sp)
    1f7c:	7946                	ld	s2,112(sp)
    1f7e:	79a6                	ld	s3,104(sp)
    1f80:	7a06                	ld	s4,96(sp)
    1f82:	6ae6                	ld	s5,88(sp)
    1f84:	6b46                	ld	s6,80(sp)
    1f86:	6ba6                	ld	s7,72(sp)
    1f88:	6c06                	ld	s8,64(sp)
    1f8a:	7ce2                	ld	s9,56(sp)
    1f8c:	6149                	addi	sp,sp,144
    1f8e:	8082                	ret

0000000000001f90 <linkunlink>:
{
    1f90:	711d                	addi	sp,sp,-96
    1f92:	ec86                	sd	ra,88(sp)
    1f94:	e8a2                	sd	s0,80(sp)
    1f96:	e4a6                	sd	s1,72(sp)
    1f98:	e0ca                	sd	s2,64(sp)
    1f9a:	fc4e                	sd	s3,56(sp)
    1f9c:	f852                	sd	s4,48(sp)
    1f9e:	f456                	sd	s5,40(sp)
    1fa0:	f05a                	sd	s6,32(sp)
    1fa2:	ec5e                	sd	s7,24(sp)
    1fa4:	e862                	sd	s8,16(sp)
    1fa6:	e466                	sd	s9,8(sp)
    1fa8:	1080                	addi	s0,sp,96
    1faa:	84aa                	mv	s1,a0
  unlink("x");
    1fac:	00004517          	auipc	a0,0x4
    1fb0:	23c50513          	addi	a0,a0,572 # 61e8 <malloc+0x1b8>
    1fb4:	00004097          	auipc	ra,0x4
    1fb8:	c6e080e7          	jalr	-914(ra) # 5c22 <unlink>
  pid = fork();
    1fbc:	00004097          	auipc	ra,0x4
    1fc0:	c0e080e7          	jalr	-1010(ra) # 5bca <fork>
  if(pid < 0){
    1fc4:	02054b63          	bltz	a0,1ffa <linkunlink+0x6a>
    1fc8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fca:	4c85                	li	s9,1
    1fcc:	e119                	bnez	a0,1fd2 <linkunlink+0x42>
    1fce:	06100c93          	li	s9,97
    1fd2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd6:	41c659b7          	lui	s3,0x41c65
    1fda:	e6d9899b          	addiw	s3,s3,-403
    1fde:	690d                	lui	s2,0x3
    1fe0:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1fe4:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fe6:	4b05                	li	s6,1
      unlink("x");
    1fe8:	00004a97          	auipc	s5,0x4
    1fec:	200a8a93          	addi	s5,s5,512 # 61e8 <malloc+0x1b8>
      link("cat", "x");
    1ff0:	00005b97          	auipc	s7,0x5
    1ff4:	c68b8b93          	addi	s7,s7,-920 # 6c58 <malloc+0xc28>
    1ff8:	a091                	j	203c <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1ffa:	85a6                	mv	a1,s1
    1ffc:	00005517          	auipc	a0,0x5
    2000:	a0450513          	addi	a0,a0,-1532 # 6a00 <malloc+0x9d0>
    2004:	00004097          	auipc	ra,0x4
    2008:	f6e080e7          	jalr	-146(ra) # 5f72 <printf>
    exit(1);
    200c:	4505                	li	a0,1
    200e:	00004097          	auipc	ra,0x4
    2012:	bc4080e7          	jalr	-1084(ra) # 5bd2 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2016:	20200593          	li	a1,514
    201a:	8556                	mv	a0,s5
    201c:	00004097          	auipc	ra,0x4
    2020:	bf6080e7          	jalr	-1034(ra) # 5c12 <open>
    2024:	00004097          	auipc	ra,0x4
    2028:	bd6080e7          	jalr	-1066(ra) # 5bfa <close>
    202c:	a031                	j	2038 <linkunlink+0xa8>
      unlink("x");
    202e:	8556                	mv	a0,s5
    2030:	00004097          	auipc	ra,0x4
    2034:	bf2080e7          	jalr	-1038(ra) # 5c22 <unlink>
  for(i = 0; i < 100; i++){
    2038:	34fd                	addiw	s1,s1,-1
    203a:	c09d                	beqz	s1,2060 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    203c:	033c87bb          	mulw	a5,s9,s3
    2040:	012787bb          	addw	a5,a5,s2
    2044:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2048:	0347f7bb          	remuw	a5,a5,s4
    204c:	d7e9                	beqz	a5,2016 <linkunlink+0x86>
    } else if((x % 3) == 1){
    204e:	ff6790e3          	bne	a5,s6,202e <linkunlink+0x9e>
      link("cat", "x");
    2052:	85d6                	mv	a1,s5
    2054:	855e                	mv	a0,s7
    2056:	00004097          	auipc	ra,0x4
    205a:	bdc080e7          	jalr	-1060(ra) # 5c32 <link>
    205e:	bfe9                	j	2038 <linkunlink+0xa8>
  if(pid)
    2060:	020c0463          	beqz	s8,2088 <linkunlink+0xf8>
    wait(0);
    2064:	4501                	li	a0,0
    2066:	00004097          	auipc	ra,0x4
    206a:	b74080e7          	jalr	-1164(ra) # 5bda <wait>
}
    206e:	60e6                	ld	ra,88(sp)
    2070:	6446                	ld	s0,80(sp)
    2072:	64a6                	ld	s1,72(sp)
    2074:	6906                	ld	s2,64(sp)
    2076:	79e2                	ld	s3,56(sp)
    2078:	7a42                	ld	s4,48(sp)
    207a:	7aa2                	ld	s5,40(sp)
    207c:	7b02                	ld	s6,32(sp)
    207e:	6be2                	ld	s7,24(sp)
    2080:	6c42                	ld	s8,16(sp)
    2082:	6ca2                	ld	s9,8(sp)
    2084:	6125                	addi	sp,sp,96
    2086:	8082                	ret
    exit(0);
    2088:	4501                	li	a0,0
    208a:	00004097          	auipc	ra,0x4
    208e:	b48080e7          	jalr	-1208(ra) # 5bd2 <exit>

0000000000002092 <forktest>:
{
    2092:	7179                	addi	sp,sp,-48
    2094:	f406                	sd	ra,40(sp)
    2096:	f022                	sd	s0,32(sp)
    2098:	ec26                	sd	s1,24(sp)
    209a:	e84a                	sd	s2,16(sp)
    209c:	e44e                	sd	s3,8(sp)
    209e:	1800                	addi	s0,sp,48
    20a0:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20a2:	4481                	li	s1,0
    20a4:	3e800913          	li	s2,1000
    pid = fork();
    20a8:	00004097          	auipc	ra,0x4
    20ac:	b22080e7          	jalr	-1246(ra) # 5bca <fork>
    if(pid < 0)
    20b0:	02054863          	bltz	a0,20e0 <forktest+0x4e>
    if(pid == 0)
    20b4:	c115                	beqz	a0,20d8 <forktest+0x46>
  for(n=0; n<N; n++){
    20b6:	2485                	addiw	s1,s1,1
    20b8:	ff2498e3          	bne	s1,s2,20a8 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00005517          	auipc	a0,0x5
    20c2:	bba50513          	addi	a0,a0,-1094 # 6c78 <malloc+0xc48>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	eac080e7          	jalr	-340(ra) # 5f72 <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00004097          	auipc	ra,0x4
    20d4:	b02080e7          	jalr	-1278(ra) # 5bd2 <exit>
      exit(0);
    20d8:	00004097          	auipc	ra,0x4
    20dc:	afa080e7          	jalr	-1286(ra) # 5bd2 <exit>
  if (n == 0) {
    20e0:	cc9d                	beqz	s1,211e <forktest+0x8c>
  if(n == N){
    20e2:	3e800793          	li	a5,1000
    20e6:	fcf48be3          	beq	s1,a5,20bc <forktest+0x2a>
  for(; n > 0; n--){
    20ea:	00905b63          	blez	s1,2100 <forktest+0x6e>
    if(wait(0) < 0){
    20ee:	4501                	li	a0,0
    20f0:	00004097          	auipc	ra,0x4
    20f4:	aea080e7          	jalr	-1302(ra) # 5bda <wait>
    20f8:	04054163          	bltz	a0,213a <forktest+0xa8>
  for(; n > 0; n--){
    20fc:	34fd                	addiw	s1,s1,-1
    20fe:	f8e5                	bnez	s1,20ee <forktest+0x5c>
  if(wait(0) != -1){
    2100:	4501                	li	a0,0
    2102:	00004097          	auipc	ra,0x4
    2106:	ad8080e7          	jalr	-1320(ra) # 5bda <wait>
    210a:	57fd                	li	a5,-1
    210c:	04f51563          	bne	a0,a5,2156 <forktest+0xc4>
}
    2110:	70a2                	ld	ra,40(sp)
    2112:	7402                	ld	s0,32(sp)
    2114:	64e2                	ld	s1,24(sp)
    2116:	6942                	ld	s2,16(sp)
    2118:	69a2                	ld	s3,8(sp)
    211a:	6145                	addi	sp,sp,48
    211c:	8082                	ret
    printf("%s: no fork at all!\n", s);
    211e:	85ce                	mv	a1,s3
    2120:	00005517          	auipc	a0,0x5
    2124:	b4050513          	addi	a0,a0,-1216 # 6c60 <malloc+0xc30>
    2128:	00004097          	auipc	ra,0x4
    212c:	e4a080e7          	jalr	-438(ra) # 5f72 <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	00004097          	auipc	ra,0x4
    2136:	aa0080e7          	jalr	-1376(ra) # 5bd2 <exit>
      printf("%s: wait stopped early\n", s);
    213a:	85ce                	mv	a1,s3
    213c:	00005517          	auipc	a0,0x5
    2140:	b6450513          	addi	a0,a0,-1180 # 6ca0 <malloc+0xc70>
    2144:	00004097          	auipc	ra,0x4
    2148:	e2e080e7          	jalr	-466(ra) # 5f72 <printf>
      exit(1);
    214c:	4505                	li	a0,1
    214e:	00004097          	auipc	ra,0x4
    2152:	a84080e7          	jalr	-1404(ra) # 5bd2 <exit>
    printf("%s: wait got too many\n", s);
    2156:	85ce                	mv	a1,s3
    2158:	00005517          	auipc	a0,0x5
    215c:	b6050513          	addi	a0,a0,-1184 # 6cb8 <malloc+0xc88>
    2160:	00004097          	auipc	ra,0x4
    2164:	e12080e7          	jalr	-494(ra) # 5f72 <printf>
    exit(1);
    2168:	4505                	li	a0,1
    216a:	00004097          	auipc	ra,0x4
    216e:	a68080e7          	jalr	-1432(ra) # 5bd2 <exit>

0000000000002172 <kernmem>:
{
    2172:	715d                	addi	sp,sp,-80
    2174:	e486                	sd	ra,72(sp)
    2176:	e0a2                	sd	s0,64(sp)
    2178:	fc26                	sd	s1,56(sp)
    217a:	f84a                	sd	s2,48(sp)
    217c:	f44e                	sd	s3,40(sp)
    217e:	f052                	sd	s4,32(sp)
    2180:	ec56                	sd	s5,24(sp)
    2182:	0880                	addi	s0,sp,80
    2184:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2186:	4485                	li	s1,1
    2188:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    218a:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218c:	69b1                	lui	s3,0xc
    218e:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    2192:	1003d937          	lui	s2,0x1003d
    2196:	090e                	slli	s2,s2,0x3
    2198:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    219c:	00004097          	auipc	ra,0x4
    21a0:	a2e080e7          	jalr	-1490(ra) # 5bca <fork>
    if(pid < 0){
    21a4:	02054963          	bltz	a0,21d6 <kernmem+0x64>
    if(pid == 0){
    21a8:	c529                	beqz	a0,21f2 <kernmem+0x80>
    wait(&xstatus);
    21aa:	fbc40513          	addi	a0,s0,-68
    21ae:	00004097          	auipc	ra,0x4
    21b2:	a2c080e7          	jalr	-1492(ra) # 5bda <wait>
    if(xstatus != -1)  // did kernel kill child?
    21b6:	fbc42783          	lw	a5,-68(s0)
    21ba:	05579d63          	bne	a5,s5,2214 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21be:	94ce                	add	s1,s1,s3
    21c0:	fd249ee3          	bne	s1,s2,219c <kernmem+0x2a>
}
    21c4:	60a6                	ld	ra,72(sp)
    21c6:	6406                	ld	s0,64(sp)
    21c8:	74e2                	ld	s1,56(sp)
    21ca:	7942                	ld	s2,48(sp)
    21cc:	79a2                	ld	s3,40(sp)
    21ce:	7a02                	ld	s4,32(sp)
    21d0:	6ae2                	ld	s5,24(sp)
    21d2:	6161                	addi	sp,sp,80
    21d4:	8082                	ret
      printf("%s: fork failed\n", s);
    21d6:	85d2                	mv	a1,s4
    21d8:	00005517          	auipc	a0,0x5
    21dc:	82850513          	addi	a0,a0,-2008 # 6a00 <malloc+0x9d0>
    21e0:	00004097          	auipc	ra,0x4
    21e4:	d92080e7          	jalr	-622(ra) # 5f72 <printf>
      exit(1);
    21e8:	4505                	li	a0,1
    21ea:	00004097          	auipc	ra,0x4
    21ee:	9e8080e7          	jalr	-1560(ra) # 5bd2 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f2:	0004c683          	lbu	a3,0(s1)
    21f6:	8626                	mv	a2,s1
    21f8:	85d2                	mv	a1,s4
    21fa:	00005517          	auipc	a0,0x5
    21fe:	ad650513          	addi	a0,a0,-1322 # 6cd0 <malloc+0xca0>
    2202:	00004097          	auipc	ra,0x4
    2206:	d70080e7          	jalr	-656(ra) # 5f72 <printf>
      exit(1);
    220a:	4505                	li	a0,1
    220c:	00004097          	auipc	ra,0x4
    2210:	9c6080e7          	jalr	-1594(ra) # 5bd2 <exit>
      exit(1);
    2214:	4505                	li	a0,1
    2216:	00004097          	auipc	ra,0x4
    221a:	9bc080e7          	jalr	-1604(ra) # 5bd2 <exit>

000000000000221e <MAXVAplus>:
{
    221e:	7179                	addi	sp,sp,-48
    2220:	f406                	sd	ra,40(sp)
    2222:	f022                	sd	s0,32(sp)
    2224:	ec26                	sd	s1,24(sp)
    2226:	e84a                	sd	s2,16(sp)
    2228:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    222a:	4785                	li	a5,1
    222c:	179a                	slli	a5,a5,0x26
    222e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2232:	fd843783          	ld	a5,-40(s0)
    2236:	cf85                	beqz	a5,226e <MAXVAplus+0x50>
    2238:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    223a:	54fd                	li	s1,-1
    pid = fork();
    223c:	00004097          	auipc	ra,0x4
    2240:	98e080e7          	jalr	-1650(ra) # 5bca <fork>
    if(pid < 0){
    2244:	02054b63          	bltz	a0,227a <MAXVAplus+0x5c>
    if(pid == 0){
    2248:	c539                	beqz	a0,2296 <MAXVAplus+0x78>
    wait(&xstatus);
    224a:	fd440513          	addi	a0,s0,-44
    224e:	00004097          	auipc	ra,0x4
    2252:	98c080e7          	jalr	-1652(ra) # 5bda <wait>
    if(xstatus != -1)  // did kernel kill child?
    2256:	fd442783          	lw	a5,-44(s0)
    225a:	06979463          	bne	a5,s1,22c2 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    225e:	fd843783          	ld	a5,-40(s0)
    2262:	0786                	slli	a5,a5,0x1
    2264:	fcf43c23          	sd	a5,-40(s0)
    2268:	fd843783          	ld	a5,-40(s0)
    226c:	fbe1                	bnez	a5,223c <MAXVAplus+0x1e>
}
    226e:	70a2                	ld	ra,40(sp)
    2270:	7402                	ld	s0,32(sp)
    2272:	64e2                	ld	s1,24(sp)
    2274:	6942                	ld	s2,16(sp)
    2276:	6145                	addi	sp,sp,48
    2278:	8082                	ret
      printf("%s: fork failed\n", s);
    227a:	85ca                	mv	a1,s2
    227c:	00004517          	auipc	a0,0x4
    2280:	78450513          	addi	a0,a0,1924 # 6a00 <malloc+0x9d0>
    2284:	00004097          	auipc	ra,0x4
    2288:	cee080e7          	jalr	-786(ra) # 5f72 <printf>
      exit(1);
    228c:	4505                	li	a0,1
    228e:	00004097          	auipc	ra,0x4
    2292:	944080e7          	jalr	-1724(ra) # 5bd2 <exit>
      *(char*)a = 99;
    2296:	fd843783          	ld	a5,-40(s0)
    229a:	06300713          	li	a4,99
    229e:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22a2:	fd843603          	ld	a2,-40(s0)
    22a6:	85ca                	mv	a1,s2
    22a8:	00005517          	auipc	a0,0x5
    22ac:	a4850513          	addi	a0,a0,-1464 # 6cf0 <malloc+0xcc0>
    22b0:	00004097          	auipc	ra,0x4
    22b4:	cc2080e7          	jalr	-830(ra) # 5f72 <printf>
      exit(1);
    22b8:	4505                	li	a0,1
    22ba:	00004097          	auipc	ra,0x4
    22be:	918080e7          	jalr	-1768(ra) # 5bd2 <exit>
      exit(1);
    22c2:	4505                	li	a0,1
    22c4:	00004097          	auipc	ra,0x4
    22c8:	90e080e7          	jalr	-1778(ra) # 5bd2 <exit>

00000000000022cc <bigargtest>:
{
    22cc:	7179                	addi	sp,sp,-48
    22ce:	f406                	sd	ra,40(sp)
    22d0:	f022                	sd	s0,32(sp)
    22d2:	ec26                	sd	s1,24(sp)
    22d4:	1800                	addi	s0,sp,48
    22d6:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22d8:	00005517          	auipc	a0,0x5
    22dc:	a3050513          	addi	a0,a0,-1488 # 6d08 <malloc+0xcd8>
    22e0:	00004097          	auipc	ra,0x4
    22e4:	942080e7          	jalr	-1726(ra) # 5c22 <unlink>
  pid = fork();
    22e8:	00004097          	auipc	ra,0x4
    22ec:	8e2080e7          	jalr	-1822(ra) # 5bca <fork>
  if(pid == 0){
    22f0:	c121                	beqz	a0,2330 <bigargtest+0x64>
  } else if(pid < 0){
    22f2:	0a054063          	bltz	a0,2392 <bigargtest+0xc6>
  wait(&xstatus);
    22f6:	fdc40513          	addi	a0,s0,-36
    22fa:	00004097          	auipc	ra,0x4
    22fe:	8e0080e7          	jalr	-1824(ra) # 5bda <wait>
  if(xstatus != 0)
    2302:	fdc42503          	lw	a0,-36(s0)
    2306:	e545                	bnez	a0,23ae <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2308:	4581                	li	a1,0
    230a:	00005517          	auipc	a0,0x5
    230e:	9fe50513          	addi	a0,a0,-1538 # 6d08 <malloc+0xcd8>
    2312:	00004097          	auipc	ra,0x4
    2316:	900080e7          	jalr	-1792(ra) # 5c12 <open>
  if(fd < 0){
    231a:	08054e63          	bltz	a0,23b6 <bigargtest+0xea>
  close(fd);
    231e:	00004097          	auipc	ra,0x4
    2322:	8dc080e7          	jalr	-1828(ra) # 5bfa <close>
}
    2326:	70a2                	ld	ra,40(sp)
    2328:	7402                	ld	s0,32(sp)
    232a:	64e2                	ld	s1,24(sp)
    232c:	6145                	addi	sp,sp,48
    232e:	8082                	ret
    2330:	00007797          	auipc	a5,0x7
    2334:	13078793          	addi	a5,a5,304 # 9460 <args.1830>
    2338:	00007697          	auipc	a3,0x7
    233c:	22068693          	addi	a3,a3,544 # 9558 <args.1830+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2340:	00005717          	auipc	a4,0x5
    2344:	9d870713          	addi	a4,a4,-1576 # 6d18 <malloc+0xce8>
    2348:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    234a:	07a1                	addi	a5,a5,8
    234c:	fed79ee3          	bne	a5,a3,2348 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2350:	00007597          	auipc	a1,0x7
    2354:	11058593          	addi	a1,a1,272 # 9460 <args.1830>
    2358:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    235c:	00004517          	auipc	a0,0x4
    2360:	e1c50513          	addi	a0,a0,-484 # 6178 <malloc+0x148>
    2364:	00004097          	auipc	ra,0x4
    2368:	8a6080e7          	jalr	-1882(ra) # 5c0a <exec>
    fd = open("bigarg-ok", O_CREATE);
    236c:	20000593          	li	a1,512
    2370:	00005517          	auipc	a0,0x5
    2374:	99850513          	addi	a0,a0,-1640 # 6d08 <malloc+0xcd8>
    2378:	00004097          	auipc	ra,0x4
    237c:	89a080e7          	jalr	-1894(ra) # 5c12 <open>
    close(fd);
    2380:	00004097          	auipc	ra,0x4
    2384:	87a080e7          	jalr	-1926(ra) # 5bfa <close>
    exit(0);
    2388:	4501                	li	a0,0
    238a:	00004097          	auipc	ra,0x4
    238e:	848080e7          	jalr	-1976(ra) # 5bd2 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2392:	85a6                	mv	a1,s1
    2394:	00005517          	auipc	a0,0x5
    2398:	a6450513          	addi	a0,a0,-1436 # 6df8 <malloc+0xdc8>
    239c:	00004097          	auipc	ra,0x4
    23a0:	bd6080e7          	jalr	-1066(ra) # 5f72 <printf>
    exit(1);
    23a4:	4505                	li	a0,1
    23a6:	00004097          	auipc	ra,0x4
    23aa:	82c080e7          	jalr	-2004(ra) # 5bd2 <exit>
    exit(xstatus);
    23ae:	00004097          	auipc	ra,0x4
    23b2:	824080e7          	jalr	-2012(ra) # 5bd2 <exit>
    printf("%s: bigarg test failed!\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	a6050513          	addi	a0,a0,-1440 # 6e18 <malloc+0xde8>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	bb2080e7          	jalr	-1102(ra) # 5f72 <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00004097          	auipc	ra,0x4
    23ce:	808080e7          	jalr	-2040(ra) # 5bd2 <exit>

00000000000023d2 <stacktest>:
{
    23d2:	7179                	addi	sp,sp,-48
    23d4:	f406                	sd	ra,40(sp)
    23d6:	f022                	sd	s0,32(sp)
    23d8:	ec26                	sd	s1,24(sp)
    23da:	1800                	addi	s0,sp,48
    23dc:	84aa                	mv	s1,a0
  pid = fork();
    23de:	00003097          	auipc	ra,0x3
    23e2:	7ec080e7          	jalr	2028(ra) # 5bca <fork>
  if(pid == 0) {
    23e6:	c115                	beqz	a0,240a <stacktest+0x38>
  } else if(pid < 0){
    23e8:	04054463          	bltz	a0,2430 <stacktest+0x5e>
  wait(&xstatus);
    23ec:	fdc40513          	addi	a0,s0,-36
    23f0:	00003097          	auipc	ra,0x3
    23f4:	7ea080e7          	jalr	2026(ra) # 5bda <wait>
  if(xstatus == -1)  // kernel killed child?
    23f8:	fdc42503          	lw	a0,-36(s0)
    23fc:	57fd                	li	a5,-1
    23fe:	04f50763          	beq	a0,a5,244c <stacktest+0x7a>
    exit(xstatus);
    2402:	00003097          	auipc	ra,0x3
    2406:	7d0080e7          	jalr	2000(ra) # 5bd2 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    240a:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    240c:	77fd                	lui	a5,0xfffff
    240e:	97ba                	add	a5,a5,a4
    2410:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2414:	85a6                	mv	a1,s1
    2416:	00005517          	auipc	a0,0x5
    241a:	a2250513          	addi	a0,a0,-1502 # 6e38 <malloc+0xe08>
    241e:	00004097          	auipc	ra,0x4
    2422:	b54080e7          	jalr	-1196(ra) # 5f72 <printf>
    exit(1);
    2426:	4505                	li	a0,1
    2428:	00003097          	auipc	ra,0x3
    242c:	7aa080e7          	jalr	1962(ra) # 5bd2 <exit>
    printf("%s: fork failed\n", s);
    2430:	85a6                	mv	a1,s1
    2432:	00004517          	auipc	a0,0x4
    2436:	5ce50513          	addi	a0,a0,1486 # 6a00 <malloc+0x9d0>
    243a:	00004097          	auipc	ra,0x4
    243e:	b38080e7          	jalr	-1224(ra) # 5f72 <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	00003097          	auipc	ra,0x3
    2448:	78e080e7          	jalr	1934(ra) # 5bd2 <exit>
    exit(0);
    244c:	4501                	li	a0,0
    244e:	00003097          	auipc	ra,0x3
    2452:	784080e7          	jalr	1924(ra) # 5bd2 <exit>

0000000000002456 <textwrite>:
{
    2456:	7179                	addi	sp,sp,-48
    2458:	f406                	sd	ra,40(sp)
    245a:	f022                	sd	s0,32(sp)
    245c:	ec26                	sd	s1,24(sp)
    245e:	1800                	addi	s0,sp,48
    2460:	84aa                	mv	s1,a0
  pid = fork();
    2462:	00003097          	auipc	ra,0x3
    2466:	768080e7          	jalr	1896(ra) # 5bca <fork>
  if(pid == 0) {
    246a:	c11d                	beqz	a0,2490 <textwrite+0x3a>
  } else if(pid < 0){
    246c:	02054a63          	bltz	a0,24a0 <textwrite+0x4a>
  wait(&xstatus);
    2470:	fdc40513          	addi	a0,s0,-36
    2474:	00003097          	auipc	ra,0x3
    2478:	766080e7          	jalr	1894(ra) # 5bda <wait>
  if(xstatus == -1)  // kernel killed child?
    247c:	fdc42703          	lw	a4,-36(s0)
    2480:	57fd                	li	a5,-1
    2482:	02f70d63          	beq	a4,a5,24bc <textwrite+0x66>
    exit(0);
    2486:	4501                	li	a0,0
    2488:	00003097          	auipc	ra,0x3
    248c:	74a080e7          	jalr	1866(ra) # 5bd2 <exit>
    *addr = 10;
    2490:	47a9                	li	a5,10
    2492:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2496:	4505                	li	a0,1
    2498:	00003097          	auipc	ra,0x3
    249c:	73a080e7          	jalr	1850(ra) # 5bd2 <exit>
    printf("%s: fork failed\n", s);
    24a0:	85a6                	mv	a1,s1
    24a2:	00004517          	auipc	a0,0x4
    24a6:	55e50513          	addi	a0,a0,1374 # 6a00 <malloc+0x9d0>
    24aa:	00004097          	auipc	ra,0x4
    24ae:	ac8080e7          	jalr	-1336(ra) # 5f72 <printf>
    exit(1);
    24b2:	4505                	li	a0,1
    24b4:	00003097          	auipc	ra,0x3
    24b8:	71e080e7          	jalr	1822(ra) # 5bd2 <exit>
    exit(xstatus);
    24bc:	557d                	li	a0,-1
    24be:	00003097          	auipc	ra,0x3
    24c2:	714080e7          	jalr	1812(ra) # 5bd2 <exit>

00000000000024c6 <manywrites>:
{
    24c6:	711d                	addi	sp,sp,-96
    24c8:	ec86                	sd	ra,88(sp)
    24ca:	e8a2                	sd	s0,80(sp)
    24cc:	e4a6                	sd	s1,72(sp)
    24ce:	e0ca                	sd	s2,64(sp)
    24d0:	fc4e                	sd	s3,56(sp)
    24d2:	f852                	sd	s4,48(sp)
    24d4:	f456                	sd	s5,40(sp)
    24d6:	f05a                	sd	s6,32(sp)
    24d8:	ec5e                	sd	s7,24(sp)
    24da:	1080                	addi	s0,sp,96
    24dc:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24de:	4901                	li	s2,0
    24e0:	4991                	li	s3,4
    int pid = fork();
    24e2:	00003097          	auipc	ra,0x3
    24e6:	6e8080e7          	jalr	1768(ra) # 5bca <fork>
    24ea:	84aa                	mv	s1,a0
    if(pid < 0){
    24ec:	02054963          	bltz	a0,251e <manywrites+0x58>
    if(pid == 0){
    24f0:	c521                	beqz	a0,2538 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24f2:	2905                	addiw	s2,s2,1
    24f4:	ff3917e3          	bne	s2,s3,24e2 <manywrites+0x1c>
    24f8:	4491                	li	s1,4
    int st = 0;
    24fa:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24fe:	fa840513          	addi	a0,s0,-88
    2502:	00003097          	auipc	ra,0x3
    2506:	6d8080e7          	jalr	1752(ra) # 5bda <wait>
    if(st != 0)
    250a:	fa842503          	lw	a0,-88(s0)
    250e:	ed6d                	bnez	a0,2608 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2510:	34fd                	addiw	s1,s1,-1
    2512:	f4e5                	bnez	s1,24fa <manywrites+0x34>
  exit(0);
    2514:	4501                	li	a0,0
    2516:	00003097          	auipc	ra,0x3
    251a:	6bc080e7          	jalr	1724(ra) # 5bd2 <exit>
      printf("fork failed\n");
    251e:	00005517          	auipc	a0,0x5
    2522:	8ea50513          	addi	a0,a0,-1814 # 6e08 <malloc+0xdd8>
    2526:	00004097          	auipc	ra,0x4
    252a:	a4c080e7          	jalr	-1460(ra) # 5f72 <printf>
      exit(1);
    252e:	4505                	li	a0,1
    2530:	00003097          	auipc	ra,0x3
    2534:	6a2080e7          	jalr	1698(ra) # 5bd2 <exit>
      name[0] = 'b';
    2538:	06200793          	li	a5,98
    253c:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2540:	0619079b          	addiw	a5,s2,97
    2544:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2548:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    254c:	fa840513          	addi	a0,s0,-88
    2550:	00003097          	auipc	ra,0x3
    2554:	6d2080e7          	jalr	1746(ra) # 5c22 <unlink>
    2558:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    255a:	0000ab97          	auipc	s7,0xa
    255e:	71eb8b93          	addi	s7,s7,1822 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2562:	8a26                	mv	s4,s1
    2564:	02094e63          	bltz	s2,25a0 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2568:	20200593          	li	a1,514
    256c:	fa840513          	addi	a0,s0,-88
    2570:	00003097          	auipc	ra,0x3
    2574:	6a2080e7          	jalr	1698(ra) # 5c12 <open>
    2578:	89aa                	mv	s3,a0
          if(fd < 0){
    257a:	04054763          	bltz	a0,25c8 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    257e:	660d                	lui	a2,0x3
    2580:	85de                	mv	a1,s7
    2582:	00003097          	auipc	ra,0x3
    2586:	670080e7          	jalr	1648(ra) # 5bf2 <write>
          if(cc != sz){
    258a:	678d                	lui	a5,0x3
    258c:	04f51e63          	bne	a0,a5,25e8 <manywrites+0x122>
          close(fd);
    2590:	854e                	mv	a0,s3
    2592:	00003097          	auipc	ra,0x3
    2596:	668080e7          	jalr	1640(ra) # 5bfa <close>
        for(int i = 0; i < ci+1; i++){
    259a:	2a05                	addiw	s4,s4,1
    259c:	fd4956e3          	bge	s2,s4,2568 <manywrites+0xa2>
        unlink(name);
    25a0:	fa840513          	addi	a0,s0,-88
    25a4:	00003097          	auipc	ra,0x3
    25a8:	67e080e7          	jalr	1662(ra) # 5c22 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25ac:	3b7d                	addiw	s6,s6,-1
    25ae:	fa0b1ae3          	bnez	s6,2562 <manywrites+0x9c>
      unlink(name);
    25b2:	fa840513          	addi	a0,s0,-88
    25b6:	00003097          	auipc	ra,0x3
    25ba:	66c080e7          	jalr	1644(ra) # 5c22 <unlink>
      exit(0);
    25be:	4501                	li	a0,0
    25c0:	00003097          	auipc	ra,0x3
    25c4:	612080e7          	jalr	1554(ra) # 5bd2 <exit>
            printf("%s: cannot create %s\n", s, name);
    25c8:	fa840613          	addi	a2,s0,-88
    25cc:	85d6                	mv	a1,s5
    25ce:	00005517          	auipc	a0,0x5
    25d2:	89250513          	addi	a0,a0,-1902 # 6e60 <malloc+0xe30>
    25d6:	00004097          	auipc	ra,0x4
    25da:	99c080e7          	jalr	-1636(ra) # 5f72 <printf>
            exit(1);
    25de:	4505                	li	a0,1
    25e0:	00003097          	auipc	ra,0x3
    25e4:	5f2080e7          	jalr	1522(ra) # 5bd2 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25e8:	86aa                	mv	a3,a0
    25ea:	660d                	lui	a2,0x3
    25ec:	85d6                	mv	a1,s5
    25ee:	00004517          	auipc	a0,0x4
    25f2:	c5a50513          	addi	a0,a0,-934 # 6248 <malloc+0x218>
    25f6:	00004097          	auipc	ra,0x4
    25fa:	97c080e7          	jalr	-1668(ra) # 5f72 <printf>
            exit(1);
    25fe:	4505                	li	a0,1
    2600:	00003097          	auipc	ra,0x3
    2604:	5d2080e7          	jalr	1490(ra) # 5bd2 <exit>
      exit(st);
    2608:	00003097          	auipc	ra,0x3
    260c:	5ca080e7          	jalr	1482(ra) # 5bd2 <exit>

0000000000002610 <copyinstr3>:
{
    2610:	7179                	addi	sp,sp,-48
    2612:	f406                	sd	ra,40(sp)
    2614:	f022                	sd	s0,32(sp)
    2616:	ec26                	sd	s1,24(sp)
    2618:	1800                	addi	s0,sp,48
  sbrk(8192);
    261a:	6509                	lui	a0,0x2
    261c:	00003097          	auipc	ra,0x3
    2620:	63e080e7          	jalr	1598(ra) # 5c5a <sbrk>
  uint64 top = (uint64) sbrk(0);
    2624:	4501                	li	a0,0
    2626:	00003097          	auipc	ra,0x3
    262a:	634080e7          	jalr	1588(ra) # 5c5a <sbrk>
  if((top % PGSIZE) != 0){
    262e:	03451793          	slli	a5,a0,0x34
    2632:	e3c9                	bnez	a5,26b4 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2634:	4501                	li	a0,0
    2636:	00003097          	auipc	ra,0x3
    263a:	624080e7          	jalr	1572(ra) # 5c5a <sbrk>
  if(top % PGSIZE){
    263e:	03451793          	slli	a5,a0,0x34
    2642:	e3d9                	bnez	a5,26c8 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2644:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x6f>
  *b = 'x';
    2648:	07800793          	li	a5,120
    264c:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2650:	8526                	mv	a0,s1
    2652:	00003097          	auipc	ra,0x3
    2656:	5d0080e7          	jalr	1488(ra) # 5c22 <unlink>
  if(ret != -1){
    265a:	57fd                	li	a5,-1
    265c:	08f51363          	bne	a0,a5,26e2 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2660:	20100593          	li	a1,513
    2664:	8526                	mv	a0,s1
    2666:	00003097          	auipc	ra,0x3
    266a:	5ac080e7          	jalr	1452(ra) # 5c12 <open>
  if(fd != -1){
    266e:	57fd                	li	a5,-1
    2670:	08f51863          	bne	a0,a5,2700 <copyinstr3+0xf0>
  ret = link(b, b);
    2674:	85a6                	mv	a1,s1
    2676:	8526                	mv	a0,s1
    2678:	00003097          	auipc	ra,0x3
    267c:	5ba080e7          	jalr	1466(ra) # 5c32 <link>
  if(ret != -1){
    2680:	57fd                	li	a5,-1
    2682:	08f51e63          	bne	a0,a5,271e <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2686:	00005797          	auipc	a5,0x5
    268a:	4d278793          	addi	a5,a5,1234 # 7b58 <malloc+0x1b28>
    268e:	fcf43823          	sd	a5,-48(s0)
    2692:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2696:	fd040593          	addi	a1,s0,-48
    269a:	8526                	mv	a0,s1
    269c:	00003097          	auipc	ra,0x3
    26a0:	56e080e7          	jalr	1390(ra) # 5c0a <exec>
  if(ret != -1){
    26a4:	57fd                	li	a5,-1
    26a6:	08f51c63          	bne	a0,a5,273e <copyinstr3+0x12e>
}
    26aa:	70a2                	ld	ra,40(sp)
    26ac:	7402                	ld	s0,32(sp)
    26ae:	64e2                	ld	s1,24(sp)
    26b0:	6145                	addi	sp,sp,48
    26b2:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26b4:	0347d513          	srli	a0,a5,0x34
    26b8:	6785                	lui	a5,0x1
    26ba:	40a7853b          	subw	a0,a5,a0
    26be:	00003097          	auipc	ra,0x3
    26c2:	59c080e7          	jalr	1436(ra) # 5c5a <sbrk>
    26c6:	b7bd                	j	2634 <copyinstr3+0x24>
    printf("oops\n");
    26c8:	00004517          	auipc	a0,0x4
    26cc:	7b050513          	addi	a0,a0,1968 # 6e78 <malloc+0xe48>
    26d0:	00004097          	auipc	ra,0x4
    26d4:	8a2080e7          	jalr	-1886(ra) # 5f72 <printf>
    exit(1);
    26d8:	4505                	li	a0,1
    26da:	00003097          	auipc	ra,0x3
    26de:	4f8080e7          	jalr	1272(ra) # 5bd2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26e2:	862a                	mv	a2,a0
    26e4:	85a6                	mv	a1,s1
    26e6:	00004517          	auipc	a0,0x4
    26ea:	23a50513          	addi	a0,a0,570 # 6920 <malloc+0x8f0>
    26ee:	00004097          	auipc	ra,0x4
    26f2:	884080e7          	jalr	-1916(ra) # 5f72 <printf>
    exit(1);
    26f6:	4505                	li	a0,1
    26f8:	00003097          	auipc	ra,0x3
    26fc:	4da080e7          	jalr	1242(ra) # 5bd2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2700:	862a                	mv	a2,a0
    2702:	85a6                	mv	a1,s1
    2704:	00004517          	auipc	a0,0x4
    2708:	23c50513          	addi	a0,a0,572 # 6940 <malloc+0x910>
    270c:	00004097          	auipc	ra,0x4
    2710:	866080e7          	jalr	-1946(ra) # 5f72 <printf>
    exit(1);
    2714:	4505                	li	a0,1
    2716:	00003097          	auipc	ra,0x3
    271a:	4bc080e7          	jalr	1212(ra) # 5bd2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    271e:	86aa                	mv	a3,a0
    2720:	8626                	mv	a2,s1
    2722:	85a6                	mv	a1,s1
    2724:	00004517          	auipc	a0,0x4
    2728:	23c50513          	addi	a0,a0,572 # 6960 <malloc+0x930>
    272c:	00004097          	auipc	ra,0x4
    2730:	846080e7          	jalr	-1978(ra) # 5f72 <printf>
    exit(1);
    2734:	4505                	li	a0,1
    2736:	00003097          	auipc	ra,0x3
    273a:	49c080e7          	jalr	1180(ra) # 5bd2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    273e:	567d                	li	a2,-1
    2740:	85a6                	mv	a1,s1
    2742:	00004517          	auipc	a0,0x4
    2746:	24650513          	addi	a0,a0,582 # 6988 <malloc+0x958>
    274a:	00004097          	auipc	ra,0x4
    274e:	828080e7          	jalr	-2008(ra) # 5f72 <printf>
    exit(1);
    2752:	4505                	li	a0,1
    2754:	00003097          	auipc	ra,0x3
    2758:	47e080e7          	jalr	1150(ra) # 5bd2 <exit>

000000000000275c <rwsbrk>:
{
    275c:	1101                	addi	sp,sp,-32
    275e:	ec06                	sd	ra,24(sp)
    2760:	e822                	sd	s0,16(sp)
    2762:	e426                	sd	s1,8(sp)
    2764:	e04a                	sd	s2,0(sp)
    2766:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2768:	6509                	lui	a0,0x2
    276a:	00003097          	auipc	ra,0x3
    276e:	4f0080e7          	jalr	1264(ra) # 5c5a <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2772:	57fd                	li	a5,-1
    2774:	06f50363          	beq	a0,a5,27da <rwsbrk+0x7e>
    2778:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    277a:	7579                	lui	a0,0xffffe
    277c:	00003097          	auipc	ra,0x3
    2780:	4de080e7          	jalr	1246(ra) # 5c5a <sbrk>
    2784:	57fd                	li	a5,-1
    2786:	06f50763          	beq	a0,a5,27f4 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    278a:	20100593          	li	a1,513
    278e:	00004517          	auipc	a0,0x4
    2792:	72a50513          	addi	a0,a0,1834 # 6eb8 <malloc+0xe88>
    2796:	00003097          	auipc	ra,0x3
    279a:	47c080e7          	jalr	1148(ra) # 5c12 <open>
    279e:	892a                	mv	s2,a0
  if(fd < 0){
    27a0:	06054763          	bltz	a0,280e <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    27a4:	6505                	lui	a0,0x1
    27a6:	94aa                	add	s1,s1,a0
    27a8:	40000613          	li	a2,1024
    27ac:	85a6                	mv	a1,s1
    27ae:	854a                	mv	a0,s2
    27b0:	00003097          	auipc	ra,0x3
    27b4:	442080e7          	jalr	1090(ra) # 5bf2 <write>
    27b8:	862a                	mv	a2,a0
  if(n >= 0){
    27ba:	06054763          	bltz	a0,2828 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27be:	85a6                	mv	a1,s1
    27c0:	00004517          	auipc	a0,0x4
    27c4:	71850513          	addi	a0,a0,1816 # 6ed8 <malloc+0xea8>
    27c8:	00003097          	auipc	ra,0x3
    27cc:	7aa080e7          	jalr	1962(ra) # 5f72 <printf>
    exit(1);
    27d0:	4505                	li	a0,1
    27d2:	00003097          	auipc	ra,0x3
    27d6:	400080e7          	jalr	1024(ra) # 5bd2 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27da:	00004517          	auipc	a0,0x4
    27de:	6a650513          	addi	a0,a0,1702 # 6e80 <malloc+0xe50>
    27e2:	00003097          	auipc	ra,0x3
    27e6:	790080e7          	jalr	1936(ra) # 5f72 <printf>
    exit(1);
    27ea:	4505                	li	a0,1
    27ec:	00003097          	auipc	ra,0x3
    27f0:	3e6080e7          	jalr	998(ra) # 5bd2 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27f4:	00004517          	auipc	a0,0x4
    27f8:	6a450513          	addi	a0,a0,1700 # 6e98 <malloc+0xe68>
    27fc:	00003097          	auipc	ra,0x3
    2800:	776080e7          	jalr	1910(ra) # 5f72 <printf>
    exit(1);
    2804:	4505                	li	a0,1
    2806:	00003097          	auipc	ra,0x3
    280a:	3cc080e7          	jalr	972(ra) # 5bd2 <exit>
    printf("open(rwsbrk) failed\n");
    280e:	00004517          	auipc	a0,0x4
    2812:	6b250513          	addi	a0,a0,1714 # 6ec0 <malloc+0xe90>
    2816:	00003097          	auipc	ra,0x3
    281a:	75c080e7          	jalr	1884(ra) # 5f72 <printf>
    exit(1);
    281e:	4505                	li	a0,1
    2820:	00003097          	auipc	ra,0x3
    2824:	3b2080e7          	jalr	946(ra) # 5bd2 <exit>
  close(fd);
    2828:	854a                	mv	a0,s2
    282a:	00003097          	auipc	ra,0x3
    282e:	3d0080e7          	jalr	976(ra) # 5bfa <close>
  unlink("rwsbrk");
    2832:	00004517          	auipc	a0,0x4
    2836:	68650513          	addi	a0,a0,1670 # 6eb8 <malloc+0xe88>
    283a:	00003097          	auipc	ra,0x3
    283e:	3e8080e7          	jalr	1000(ra) # 5c22 <unlink>
  fd = open("README", O_RDONLY);
    2842:	4581                	li	a1,0
    2844:	00004517          	auipc	a0,0x4
    2848:	b0c50513          	addi	a0,a0,-1268 # 6350 <malloc+0x320>
    284c:	00003097          	auipc	ra,0x3
    2850:	3c6080e7          	jalr	966(ra) # 5c12 <open>
    2854:	892a                	mv	s2,a0
  if(fd < 0){
    2856:	02054963          	bltz	a0,2888 <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    285a:	4629                	li	a2,10
    285c:	85a6                	mv	a1,s1
    285e:	00003097          	auipc	ra,0x3
    2862:	38c080e7          	jalr	908(ra) # 5bea <read>
    2866:	862a                	mv	a2,a0
  if(n >= 0){
    2868:	02054d63          	bltz	a0,28a2 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    286c:	85a6                	mv	a1,s1
    286e:	00004517          	auipc	a0,0x4
    2872:	69a50513          	addi	a0,a0,1690 # 6f08 <malloc+0xed8>
    2876:	00003097          	auipc	ra,0x3
    287a:	6fc080e7          	jalr	1788(ra) # 5f72 <printf>
    exit(1);
    287e:	4505                	li	a0,1
    2880:	00003097          	auipc	ra,0x3
    2884:	352080e7          	jalr	850(ra) # 5bd2 <exit>
    printf("open(rwsbrk) failed\n");
    2888:	00004517          	auipc	a0,0x4
    288c:	63850513          	addi	a0,a0,1592 # 6ec0 <malloc+0xe90>
    2890:	00003097          	auipc	ra,0x3
    2894:	6e2080e7          	jalr	1762(ra) # 5f72 <printf>
    exit(1);
    2898:	4505                	li	a0,1
    289a:	00003097          	auipc	ra,0x3
    289e:	338080e7          	jalr	824(ra) # 5bd2 <exit>
  close(fd);
    28a2:	854a                	mv	a0,s2
    28a4:	00003097          	auipc	ra,0x3
    28a8:	356080e7          	jalr	854(ra) # 5bfa <close>
  exit(0);
    28ac:	4501                	li	a0,0
    28ae:	00003097          	auipc	ra,0x3
    28b2:	324080e7          	jalr	804(ra) # 5bd2 <exit>

00000000000028b6 <sbrkbasic>:
{
    28b6:	715d                	addi	sp,sp,-80
    28b8:	e486                	sd	ra,72(sp)
    28ba:	e0a2                	sd	s0,64(sp)
    28bc:	fc26                	sd	s1,56(sp)
    28be:	f84a                	sd	s2,48(sp)
    28c0:	f44e                	sd	s3,40(sp)
    28c2:	f052                	sd	s4,32(sp)
    28c4:	ec56                	sd	s5,24(sp)
    28c6:	0880                	addi	s0,sp,80
    28c8:	8a2a                	mv	s4,a0
  pid = fork();
    28ca:	00003097          	auipc	ra,0x3
    28ce:	300080e7          	jalr	768(ra) # 5bca <fork>
  if(pid < 0){
    28d2:	02054c63          	bltz	a0,290a <sbrkbasic+0x54>
  if(pid == 0){
    28d6:	ed21                	bnez	a0,292e <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    28d8:	40000537          	lui	a0,0x40000
    28dc:	00003097          	auipc	ra,0x3
    28e0:	37e080e7          	jalr	894(ra) # 5c5a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28e4:	57fd                	li	a5,-1
    28e6:	02f50f63          	beq	a0,a5,2924 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28ea:	400007b7          	lui	a5,0x40000
    28ee:	97aa                	add	a5,a5,a0
      *b = 99;
    28f0:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f4:	6705                	lui	a4,0x1
      *b = 99;
    28f6:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28fa:	953a                	add	a0,a0,a4
    28fc:	fef51de3          	bne	a0,a5,28f6 <sbrkbasic+0x40>
    exit(1);
    2900:	4505                	li	a0,1
    2902:	00003097          	auipc	ra,0x3
    2906:	2d0080e7          	jalr	720(ra) # 5bd2 <exit>
    printf("fork failed in sbrkbasic\n");
    290a:	00004517          	auipc	a0,0x4
    290e:	62650513          	addi	a0,a0,1574 # 6f30 <malloc+0xf00>
    2912:	00003097          	auipc	ra,0x3
    2916:	660080e7          	jalr	1632(ra) # 5f72 <printf>
    exit(1);
    291a:	4505                	li	a0,1
    291c:	00003097          	auipc	ra,0x3
    2920:	2b6080e7          	jalr	694(ra) # 5bd2 <exit>
      exit(0);
    2924:	4501                	li	a0,0
    2926:	00003097          	auipc	ra,0x3
    292a:	2ac080e7          	jalr	684(ra) # 5bd2 <exit>
  wait(&xstatus);
    292e:	fbc40513          	addi	a0,s0,-68
    2932:	00003097          	auipc	ra,0x3
    2936:	2a8080e7          	jalr	680(ra) # 5bda <wait>
  if(xstatus == 1){
    293a:	fbc42703          	lw	a4,-68(s0)
    293e:	4785                	li	a5,1
    2940:	00f70e63          	beq	a4,a5,295c <sbrkbasic+0xa6>
  a = sbrk(0);
    2944:	4501                	li	a0,0
    2946:	00003097          	auipc	ra,0x3
    294a:	314080e7          	jalr	788(ra) # 5c5a <sbrk>
    294e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2950:	4901                	li	s2,0
    *b = 1;
    2952:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2954:	6985                	lui	s3,0x1
    2956:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3c>
    295a:	a005                	j	297a <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    295c:	85d2                	mv	a1,s4
    295e:	00004517          	auipc	a0,0x4
    2962:	5f250513          	addi	a0,a0,1522 # 6f50 <malloc+0xf20>
    2966:	00003097          	auipc	ra,0x3
    296a:	60c080e7          	jalr	1548(ra) # 5f72 <printf>
    exit(1);
    296e:	4505                	li	a0,1
    2970:	00003097          	auipc	ra,0x3
    2974:	262080e7          	jalr	610(ra) # 5bd2 <exit>
    a = b + 1;
    2978:	84be                	mv	s1,a5
    b = sbrk(1);
    297a:	4505                	li	a0,1
    297c:	00003097          	auipc	ra,0x3
    2980:	2de080e7          	jalr	734(ra) # 5c5a <sbrk>
    if(b != a){
    2984:	04951b63          	bne	a0,s1,29da <sbrkbasic+0x124>
    *b = 1;
    2988:	01548023          	sb	s5,0(s1)
    a = b + 1;
    298c:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2990:	2905                	addiw	s2,s2,1
    2992:	ff3913e3          	bne	s2,s3,2978 <sbrkbasic+0xc2>
  pid = fork();
    2996:	00003097          	auipc	ra,0x3
    299a:	234080e7          	jalr	564(ra) # 5bca <fork>
    299e:	892a                	mv	s2,a0
  if(pid < 0){
    29a0:	04054e63          	bltz	a0,29fc <sbrkbasic+0x146>
  c = sbrk(1);
    29a4:	4505                	li	a0,1
    29a6:	00003097          	auipc	ra,0x3
    29aa:	2b4080e7          	jalr	692(ra) # 5c5a <sbrk>
  c = sbrk(1);
    29ae:	4505                	li	a0,1
    29b0:	00003097          	auipc	ra,0x3
    29b4:	2aa080e7          	jalr	682(ra) # 5c5a <sbrk>
  if(c != a + 1){
    29b8:	0489                	addi	s1,s1,2
    29ba:	04a48f63          	beq	s1,a0,2a18 <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    29be:	85d2                	mv	a1,s4
    29c0:	00004517          	auipc	a0,0x4
    29c4:	5f050513          	addi	a0,a0,1520 # 6fb0 <malloc+0xf80>
    29c8:	00003097          	auipc	ra,0x3
    29cc:	5aa080e7          	jalr	1450(ra) # 5f72 <printf>
    exit(1);
    29d0:	4505                	li	a0,1
    29d2:	00003097          	auipc	ra,0x3
    29d6:	200080e7          	jalr	512(ra) # 5bd2 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29da:	872a                	mv	a4,a0
    29dc:	86a6                	mv	a3,s1
    29de:	864a                	mv	a2,s2
    29e0:	85d2                	mv	a1,s4
    29e2:	00004517          	auipc	a0,0x4
    29e6:	58e50513          	addi	a0,a0,1422 # 6f70 <malloc+0xf40>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	588080e7          	jalr	1416(ra) # 5f72 <printf>
      exit(1);
    29f2:	4505                	li	a0,1
    29f4:	00003097          	auipc	ra,0x3
    29f8:	1de080e7          	jalr	478(ra) # 5bd2 <exit>
    printf("%s: sbrk test fork failed\n", s);
    29fc:	85d2                	mv	a1,s4
    29fe:	00004517          	auipc	a0,0x4
    2a02:	59250513          	addi	a0,a0,1426 # 6f90 <malloc+0xf60>
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	56c080e7          	jalr	1388(ra) # 5f72 <printf>
    exit(1);
    2a0e:	4505                	li	a0,1
    2a10:	00003097          	auipc	ra,0x3
    2a14:	1c2080e7          	jalr	450(ra) # 5bd2 <exit>
  if(pid == 0)
    2a18:	00091763          	bnez	s2,2a26 <sbrkbasic+0x170>
    exit(0);
    2a1c:	4501                	li	a0,0
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	1b4080e7          	jalr	436(ra) # 5bd2 <exit>
  wait(&xstatus);
    2a26:	fbc40513          	addi	a0,s0,-68
    2a2a:	00003097          	auipc	ra,0x3
    2a2e:	1b0080e7          	jalr	432(ra) # 5bda <wait>
  exit(xstatus);
    2a32:	fbc42503          	lw	a0,-68(s0)
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	19c080e7          	jalr	412(ra) # 5bd2 <exit>

0000000000002a3e <sbrkmuch>:
{
    2a3e:	7179                	addi	sp,sp,-48
    2a40:	f406                	sd	ra,40(sp)
    2a42:	f022                	sd	s0,32(sp)
    2a44:	ec26                	sd	s1,24(sp)
    2a46:	e84a                	sd	s2,16(sp)
    2a48:	e44e                	sd	s3,8(sp)
    2a4a:	e052                	sd	s4,0(sp)
    2a4c:	1800                	addi	s0,sp,48
    2a4e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a50:	4501                	li	a0,0
    2a52:	00003097          	auipc	ra,0x3
    2a56:	208080e7          	jalr	520(ra) # 5c5a <sbrk>
    2a5a:	892a                	mv	s2,a0
  a = sbrk(0);
    2a5c:	4501                	li	a0,0
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	1fc080e7          	jalr	508(ra) # 5c5a <sbrk>
    2a66:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a68:	06400537          	lui	a0,0x6400
    2a6c:	9d05                	subw	a0,a0,s1
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	1ec080e7          	jalr	492(ra) # 5c5a <sbrk>
  if (p != a) {
    2a76:	0ca49863          	bne	s1,a0,2b46 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a7a:	4501                	li	a0,0
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	1de080e7          	jalr	478(ra) # 5c5a <sbrk>
    2a84:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a86:	00a4f963          	bgeu	s1,a0,2a98 <sbrkmuch+0x5a>
    *pp = 1;
    2a8a:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a8c:	6705                	lui	a4,0x1
    *pp = 1;
    2a8e:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a92:	94ba                	add	s1,s1,a4
    2a94:	fef4ede3          	bltu	s1,a5,2a8e <sbrkmuch+0x50>
  *lastaddr = 99;
    2a98:	064007b7          	lui	a5,0x6400
    2a9c:	06300713          	li	a4,99
    2aa0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aa4:	4501                	li	a0,0
    2aa6:	00003097          	auipc	ra,0x3
    2aaa:	1b4080e7          	jalr	436(ra) # 5c5a <sbrk>
    2aae:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2ab0:	757d                	lui	a0,0xfffff
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	1a8080e7          	jalr	424(ra) # 5c5a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2aba:	57fd                	li	a5,-1
    2abc:	0af50363          	beq	a0,a5,2b62 <sbrkmuch+0x124>
  c = sbrk(0);
    2ac0:	4501                	li	a0,0
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	198080e7          	jalr	408(ra) # 5c5a <sbrk>
  if(c != a - PGSIZE){
    2aca:	77fd                	lui	a5,0xfffff
    2acc:	97a6                	add	a5,a5,s1
    2ace:	0af51863          	bne	a0,a5,2b7e <sbrkmuch+0x140>
  a = sbrk(0);
    2ad2:	4501                	li	a0,0
    2ad4:	00003097          	auipc	ra,0x3
    2ad8:	186080e7          	jalr	390(ra) # 5c5a <sbrk>
    2adc:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2ade:	6505                	lui	a0,0x1
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	17a080e7          	jalr	378(ra) # 5c5a <sbrk>
    2ae8:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2aea:	0aa49a63          	bne	s1,a0,2b9e <sbrkmuch+0x160>
    2aee:	4501                	li	a0,0
    2af0:	00003097          	auipc	ra,0x3
    2af4:	16a080e7          	jalr	362(ra) # 5c5a <sbrk>
    2af8:	6785                	lui	a5,0x1
    2afa:	97a6                	add	a5,a5,s1
    2afc:	0af51163          	bne	a0,a5,2b9e <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2b00:	064007b7          	lui	a5,0x6400
    2b04:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b08:	06300793          	li	a5,99
    2b0c:	0af70963          	beq	a4,a5,2bbe <sbrkmuch+0x180>
  a = sbrk(0);
    2b10:	4501                	li	a0,0
    2b12:	00003097          	auipc	ra,0x3
    2b16:	148080e7          	jalr	328(ra) # 5c5a <sbrk>
    2b1a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b1c:	4501                	li	a0,0
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	13c080e7          	jalr	316(ra) # 5c5a <sbrk>
    2b26:	40a9053b          	subw	a0,s2,a0
    2b2a:	00003097          	auipc	ra,0x3
    2b2e:	130080e7          	jalr	304(ra) # 5c5a <sbrk>
  if(c != a){
    2b32:	0aa49463          	bne	s1,a0,2bda <sbrkmuch+0x19c>
}
    2b36:	70a2                	ld	ra,40(sp)
    2b38:	7402                	ld	s0,32(sp)
    2b3a:	64e2                	ld	s1,24(sp)
    2b3c:	6942                	ld	s2,16(sp)
    2b3e:	69a2                	ld	s3,8(sp)
    2b40:	6a02                	ld	s4,0(sp)
    2b42:	6145                	addi	sp,sp,48
    2b44:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b46:	85ce                	mv	a1,s3
    2b48:	00004517          	auipc	a0,0x4
    2b4c:	48850513          	addi	a0,a0,1160 # 6fd0 <malloc+0xfa0>
    2b50:	00003097          	auipc	ra,0x3
    2b54:	422080e7          	jalr	1058(ra) # 5f72 <printf>
    exit(1);
    2b58:	4505                	li	a0,1
    2b5a:	00003097          	auipc	ra,0x3
    2b5e:	078080e7          	jalr	120(ra) # 5bd2 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b62:	85ce                	mv	a1,s3
    2b64:	00004517          	auipc	a0,0x4
    2b68:	4b450513          	addi	a0,a0,1204 # 7018 <malloc+0xfe8>
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	406080e7          	jalr	1030(ra) # 5f72 <printf>
    exit(1);
    2b74:	4505                	li	a0,1
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	05c080e7          	jalr	92(ra) # 5bd2 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b7e:	86aa                	mv	a3,a0
    2b80:	8626                	mv	a2,s1
    2b82:	85ce                	mv	a1,s3
    2b84:	00004517          	auipc	a0,0x4
    2b88:	4b450513          	addi	a0,a0,1204 # 7038 <malloc+0x1008>
    2b8c:	00003097          	auipc	ra,0x3
    2b90:	3e6080e7          	jalr	998(ra) # 5f72 <printf>
    exit(1);
    2b94:	4505                	li	a0,1
    2b96:	00003097          	auipc	ra,0x3
    2b9a:	03c080e7          	jalr	60(ra) # 5bd2 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b9e:	86d2                	mv	a3,s4
    2ba0:	8626                	mv	a2,s1
    2ba2:	85ce                	mv	a1,s3
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	4d450513          	addi	a0,a0,1236 # 7078 <malloc+0x1048>
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	3c6080e7          	jalr	966(ra) # 5f72 <printf>
    exit(1);
    2bb4:	4505                	li	a0,1
    2bb6:	00003097          	auipc	ra,0x3
    2bba:	01c080e7          	jalr	28(ra) # 5bd2 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bbe:	85ce                	mv	a1,s3
    2bc0:	00004517          	auipc	a0,0x4
    2bc4:	4e850513          	addi	a0,a0,1256 # 70a8 <malloc+0x1078>
    2bc8:	00003097          	auipc	ra,0x3
    2bcc:	3aa080e7          	jalr	938(ra) # 5f72 <printf>
    exit(1);
    2bd0:	4505                	li	a0,1
    2bd2:	00003097          	auipc	ra,0x3
    2bd6:	000080e7          	jalr	ra # 5bd2 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bda:	86aa                	mv	a3,a0
    2bdc:	8626                	mv	a2,s1
    2bde:	85ce                	mv	a1,s3
    2be0:	00004517          	auipc	a0,0x4
    2be4:	50050513          	addi	a0,a0,1280 # 70e0 <malloc+0x10b0>
    2be8:	00003097          	auipc	ra,0x3
    2bec:	38a080e7          	jalr	906(ra) # 5f72 <printf>
    exit(1);
    2bf0:	4505                	li	a0,1
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	fe0080e7          	jalr	-32(ra) # 5bd2 <exit>

0000000000002bfa <sbrkarg>:
{
    2bfa:	7179                	addi	sp,sp,-48
    2bfc:	f406                	sd	ra,40(sp)
    2bfe:	f022                	sd	s0,32(sp)
    2c00:	ec26                	sd	s1,24(sp)
    2c02:	e84a                	sd	s2,16(sp)
    2c04:	e44e                	sd	s3,8(sp)
    2c06:	1800                	addi	s0,sp,48
    2c08:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c0a:	6505                	lui	a0,0x1
    2c0c:	00003097          	auipc	ra,0x3
    2c10:	04e080e7          	jalr	78(ra) # 5c5a <sbrk>
    2c14:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c16:	20100593          	li	a1,513
    2c1a:	00004517          	auipc	a0,0x4
    2c1e:	4ee50513          	addi	a0,a0,1262 # 7108 <malloc+0x10d8>
    2c22:	00003097          	auipc	ra,0x3
    2c26:	ff0080e7          	jalr	-16(ra) # 5c12 <open>
    2c2a:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	4dc50513          	addi	a0,a0,1244 # 7108 <malloc+0x10d8>
    2c34:	00003097          	auipc	ra,0x3
    2c38:	fee080e7          	jalr	-18(ra) # 5c22 <unlink>
  if(fd < 0)  {
    2c3c:	0404c163          	bltz	s1,2c7e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c40:	6605                	lui	a2,0x1
    2c42:	85ca                	mv	a1,s2
    2c44:	8526                	mv	a0,s1
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	fac080e7          	jalr	-84(ra) # 5bf2 <write>
    2c4e:	04054663          	bltz	a0,2c9a <sbrkarg+0xa0>
  close(fd);
    2c52:	8526                	mv	a0,s1
    2c54:	00003097          	auipc	ra,0x3
    2c58:	fa6080e7          	jalr	-90(ra) # 5bfa <close>
  a = sbrk(PGSIZE);
    2c5c:	6505                	lui	a0,0x1
    2c5e:	00003097          	auipc	ra,0x3
    2c62:	ffc080e7          	jalr	-4(ra) # 5c5a <sbrk>
  if(pipe((int *) a) != 0){
    2c66:	00003097          	auipc	ra,0x3
    2c6a:	f7c080e7          	jalr	-132(ra) # 5be2 <pipe>
    2c6e:	e521                	bnez	a0,2cb6 <sbrkarg+0xbc>
}
    2c70:	70a2                	ld	ra,40(sp)
    2c72:	7402                	ld	s0,32(sp)
    2c74:	64e2                	ld	s1,24(sp)
    2c76:	6942                	ld	s2,16(sp)
    2c78:	69a2                	ld	s3,8(sp)
    2c7a:	6145                	addi	sp,sp,48
    2c7c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c7e:	85ce                	mv	a1,s3
    2c80:	00004517          	auipc	a0,0x4
    2c84:	49050513          	addi	a0,a0,1168 # 7110 <malloc+0x10e0>
    2c88:	00003097          	auipc	ra,0x3
    2c8c:	2ea080e7          	jalr	746(ra) # 5f72 <printf>
    exit(1);
    2c90:	4505                	li	a0,1
    2c92:	00003097          	auipc	ra,0x3
    2c96:	f40080e7          	jalr	-192(ra) # 5bd2 <exit>
    printf("%s: write sbrk failed\n", s);
    2c9a:	85ce                	mv	a1,s3
    2c9c:	00004517          	auipc	a0,0x4
    2ca0:	48c50513          	addi	a0,a0,1164 # 7128 <malloc+0x10f8>
    2ca4:	00003097          	auipc	ra,0x3
    2ca8:	2ce080e7          	jalr	718(ra) # 5f72 <printf>
    exit(1);
    2cac:	4505                	li	a0,1
    2cae:	00003097          	auipc	ra,0x3
    2cb2:	f24080e7          	jalr	-220(ra) # 5bd2 <exit>
    printf("%s: pipe() failed\n", s);
    2cb6:	85ce                	mv	a1,s3
    2cb8:	00004517          	auipc	a0,0x4
    2cbc:	e5050513          	addi	a0,a0,-432 # 6b08 <malloc+0xad8>
    2cc0:	00003097          	auipc	ra,0x3
    2cc4:	2b2080e7          	jalr	690(ra) # 5f72 <printf>
    exit(1);
    2cc8:	4505                	li	a0,1
    2cca:	00003097          	auipc	ra,0x3
    2cce:	f08080e7          	jalr	-248(ra) # 5bd2 <exit>

0000000000002cd2 <argptest>:
{
    2cd2:	1101                	addi	sp,sp,-32
    2cd4:	ec06                	sd	ra,24(sp)
    2cd6:	e822                	sd	s0,16(sp)
    2cd8:	e426                	sd	s1,8(sp)
    2cda:	e04a                	sd	s2,0(sp)
    2cdc:	1000                	addi	s0,sp,32
    2cde:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2ce0:	4581                	li	a1,0
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	45e50513          	addi	a0,a0,1118 # 7140 <malloc+0x1110>
    2cea:	00003097          	auipc	ra,0x3
    2cee:	f28080e7          	jalr	-216(ra) # 5c12 <open>
  if (fd < 0) {
    2cf2:	02054b63          	bltz	a0,2d28 <argptest+0x56>
    2cf6:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cf8:	4501                	li	a0,0
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	f60080e7          	jalr	-160(ra) # 5c5a <sbrk>
    2d02:	567d                	li	a2,-1
    2d04:	fff50593          	addi	a1,a0,-1
    2d08:	8526                	mv	a0,s1
    2d0a:	00003097          	auipc	ra,0x3
    2d0e:	ee0080e7          	jalr	-288(ra) # 5bea <read>
  close(fd);
    2d12:	8526                	mv	a0,s1
    2d14:	00003097          	auipc	ra,0x3
    2d18:	ee6080e7          	jalr	-282(ra) # 5bfa <close>
}
    2d1c:	60e2                	ld	ra,24(sp)
    2d1e:	6442                	ld	s0,16(sp)
    2d20:	64a2                	ld	s1,8(sp)
    2d22:	6902                	ld	s2,0(sp)
    2d24:	6105                	addi	sp,sp,32
    2d26:	8082                	ret
    printf("%s: open failed\n", s);
    2d28:	85ca                	mv	a1,s2
    2d2a:	00004517          	auipc	a0,0x4
    2d2e:	cee50513          	addi	a0,a0,-786 # 6a18 <malloc+0x9e8>
    2d32:	00003097          	auipc	ra,0x3
    2d36:	240080e7          	jalr	576(ra) # 5f72 <printf>
    exit(1);
    2d3a:	4505                	li	a0,1
    2d3c:	00003097          	auipc	ra,0x3
    2d40:	e96080e7          	jalr	-362(ra) # 5bd2 <exit>

0000000000002d44 <sbrkbugs>:
{
    2d44:	1141                	addi	sp,sp,-16
    2d46:	e406                	sd	ra,8(sp)
    2d48:	e022                	sd	s0,0(sp)
    2d4a:	0800                	addi	s0,sp,16
  int pid = fork();
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	e7e080e7          	jalr	-386(ra) # 5bca <fork>
  if(pid < 0){
    2d54:	02054263          	bltz	a0,2d78 <sbrkbugs+0x34>
  if(pid == 0){
    2d58:	ed0d                	bnez	a0,2d92 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d5a:	00003097          	auipc	ra,0x3
    2d5e:	f00080e7          	jalr	-256(ra) # 5c5a <sbrk>
    sbrk(-sz);
    2d62:	40a0053b          	negw	a0,a0
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	ef4080e7          	jalr	-268(ra) # 5c5a <sbrk>
    exit(0);
    2d6e:	4501                	li	a0,0
    2d70:	00003097          	auipc	ra,0x3
    2d74:	e62080e7          	jalr	-414(ra) # 5bd2 <exit>
    printf("fork failed\n");
    2d78:	00004517          	auipc	a0,0x4
    2d7c:	09050513          	addi	a0,a0,144 # 6e08 <malloc+0xdd8>
    2d80:	00003097          	auipc	ra,0x3
    2d84:	1f2080e7          	jalr	498(ra) # 5f72 <printf>
    exit(1);
    2d88:	4505                	li	a0,1
    2d8a:	00003097          	auipc	ra,0x3
    2d8e:	e48080e7          	jalr	-440(ra) # 5bd2 <exit>
  wait(0);
    2d92:	4501                	li	a0,0
    2d94:	00003097          	auipc	ra,0x3
    2d98:	e46080e7          	jalr	-442(ra) # 5bda <wait>
  pid = fork();
    2d9c:	00003097          	auipc	ra,0x3
    2da0:	e2e080e7          	jalr	-466(ra) # 5bca <fork>
  if(pid < 0){
    2da4:	02054563          	bltz	a0,2dce <sbrkbugs+0x8a>
  if(pid == 0){
    2da8:	e121                	bnez	a0,2de8 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2daa:	00003097          	auipc	ra,0x3
    2dae:	eb0080e7          	jalr	-336(ra) # 5c5a <sbrk>
    sbrk(-(sz - 3500));
    2db2:	6785                	lui	a5,0x1
    2db4:	dac7879b          	addiw	a5,a5,-596
    2db8:	40a7853b          	subw	a0,a5,a0
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	e9e080e7          	jalr	-354(ra) # 5c5a <sbrk>
    exit(0);
    2dc4:	4501                	li	a0,0
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	e0c080e7          	jalr	-500(ra) # 5bd2 <exit>
    printf("fork failed\n");
    2dce:	00004517          	auipc	a0,0x4
    2dd2:	03a50513          	addi	a0,a0,58 # 6e08 <malloc+0xdd8>
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	19c080e7          	jalr	412(ra) # 5f72 <printf>
    exit(1);
    2dde:	4505                	li	a0,1
    2de0:	00003097          	auipc	ra,0x3
    2de4:	df2080e7          	jalr	-526(ra) # 5bd2 <exit>
  wait(0);
    2de8:	4501                	li	a0,0
    2dea:	00003097          	auipc	ra,0x3
    2dee:	df0080e7          	jalr	-528(ra) # 5bda <wait>
  pid = fork();
    2df2:	00003097          	auipc	ra,0x3
    2df6:	dd8080e7          	jalr	-552(ra) # 5bca <fork>
  if(pid < 0){
    2dfa:	02054a63          	bltz	a0,2e2e <sbrkbugs+0xea>
  if(pid == 0){
    2dfe:	e529                	bnez	a0,2e48 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e00:	00003097          	auipc	ra,0x3
    2e04:	e5a080e7          	jalr	-422(ra) # 5c5a <sbrk>
    2e08:	67ad                	lui	a5,0xb
    2e0a:	8007879b          	addiw	a5,a5,-2048
    2e0e:	40a7853b          	subw	a0,a5,a0
    2e12:	00003097          	auipc	ra,0x3
    2e16:	e48080e7          	jalr	-440(ra) # 5c5a <sbrk>
    sbrk(-10);
    2e1a:	5559                	li	a0,-10
    2e1c:	00003097          	auipc	ra,0x3
    2e20:	e3e080e7          	jalr	-450(ra) # 5c5a <sbrk>
    exit(0);
    2e24:	4501                	li	a0,0
    2e26:	00003097          	auipc	ra,0x3
    2e2a:	dac080e7          	jalr	-596(ra) # 5bd2 <exit>
    printf("fork failed\n");
    2e2e:	00004517          	auipc	a0,0x4
    2e32:	fda50513          	addi	a0,a0,-38 # 6e08 <malloc+0xdd8>
    2e36:	00003097          	auipc	ra,0x3
    2e3a:	13c080e7          	jalr	316(ra) # 5f72 <printf>
    exit(1);
    2e3e:	4505                	li	a0,1
    2e40:	00003097          	auipc	ra,0x3
    2e44:	d92080e7          	jalr	-622(ra) # 5bd2 <exit>
  wait(0);
    2e48:	4501                	li	a0,0
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	d90080e7          	jalr	-624(ra) # 5bda <wait>
  exit(0);
    2e52:	4501                	li	a0,0
    2e54:	00003097          	auipc	ra,0x3
    2e58:	d7e080e7          	jalr	-642(ra) # 5bd2 <exit>

0000000000002e5c <sbrklast>:
{
    2e5c:	7179                	addi	sp,sp,-48
    2e5e:	f406                	sd	ra,40(sp)
    2e60:	f022                	sd	s0,32(sp)
    2e62:	ec26                	sd	s1,24(sp)
    2e64:	e84a                	sd	s2,16(sp)
    2e66:	e44e                	sd	s3,8(sp)
    2e68:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e6a:	4501                	li	a0,0
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	dee080e7          	jalr	-530(ra) # 5c5a <sbrk>
  if((top % 4096) != 0)
    2e74:	03451793          	slli	a5,a0,0x34
    2e78:	efc1                	bnez	a5,2f10 <sbrklast+0xb4>
  sbrk(4096);
    2e7a:	6505                	lui	a0,0x1
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	dde080e7          	jalr	-546(ra) # 5c5a <sbrk>
  sbrk(10);
    2e84:	4529                	li	a0,10
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	dd4080e7          	jalr	-556(ra) # 5c5a <sbrk>
  sbrk(-20);
    2e8e:	5531                	li	a0,-20
    2e90:	00003097          	auipc	ra,0x3
    2e94:	dca080e7          	jalr	-566(ra) # 5c5a <sbrk>
  top = (uint64) sbrk(0);
    2e98:	4501                	li	a0,0
    2e9a:	00003097          	auipc	ra,0x3
    2e9e:	dc0080e7          	jalr	-576(ra) # 5c5a <sbrk>
    2ea2:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2ea4:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2ea8:	07800793          	li	a5,120
    2eac:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2eb0:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eb4:	20200593          	li	a1,514
    2eb8:	854a                	mv	a0,s2
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	d58080e7          	jalr	-680(ra) # 5c12 <open>
    2ec2:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ec4:	4605                	li	a2,1
    2ec6:	85ca                	mv	a1,s2
    2ec8:	00003097          	auipc	ra,0x3
    2ecc:	d2a080e7          	jalr	-726(ra) # 5bf2 <write>
  close(fd);
    2ed0:	854e                	mv	a0,s3
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	d28080e7          	jalr	-728(ra) # 5bfa <close>
  fd = open(p, O_RDWR);
    2eda:	4589                	li	a1,2
    2edc:	854a                	mv	a0,s2
    2ede:	00003097          	auipc	ra,0x3
    2ee2:	d34080e7          	jalr	-716(ra) # 5c12 <open>
  p[0] = '\0';
    2ee6:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2eea:	4605                	li	a2,1
    2eec:	85ca                	mv	a1,s2
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	cfc080e7          	jalr	-772(ra) # 5bea <read>
  if(p[0] != 'x')
    2ef6:	fc04c703          	lbu	a4,-64(s1)
    2efa:	07800793          	li	a5,120
    2efe:	02f71363          	bne	a4,a5,2f24 <sbrklast+0xc8>
}
    2f02:	70a2                	ld	ra,40(sp)
    2f04:	7402                	ld	s0,32(sp)
    2f06:	64e2                	ld	s1,24(sp)
    2f08:	6942                	ld	s2,16(sp)
    2f0a:	69a2                	ld	s3,8(sp)
    2f0c:	6145                	addi	sp,sp,48
    2f0e:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f10:	0347d513          	srli	a0,a5,0x34
    2f14:	6785                	lui	a5,0x1
    2f16:	40a7853b          	subw	a0,a5,a0
    2f1a:	00003097          	auipc	ra,0x3
    2f1e:	d40080e7          	jalr	-704(ra) # 5c5a <sbrk>
    2f22:	bfa1                	j	2e7a <sbrklast+0x1e>
    exit(1);
    2f24:	4505                	li	a0,1
    2f26:	00003097          	auipc	ra,0x3
    2f2a:	cac080e7          	jalr	-852(ra) # 5bd2 <exit>

0000000000002f2e <sbrk8000>:
{
    2f2e:	1141                	addi	sp,sp,-16
    2f30:	e406                	sd	ra,8(sp)
    2f32:	e022                	sd	s0,0(sp)
    2f34:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f36:	80000537          	lui	a0,0x80000
    2f3a:	0511                	addi	a0,a0,4
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	d1e080e7          	jalr	-738(ra) # 5c5a <sbrk>
  volatile char *top = sbrk(0);
    2f44:	4501                	li	a0,0
    2f46:	00003097          	auipc	ra,0x3
    2f4a:	d14080e7          	jalr	-748(ra) # 5c5a <sbrk>
  *(top-1) = *(top-1) + 1;
    2f4e:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff0387>
    2f52:	0785                	addi	a5,a5,1
    2f54:	0ff7f793          	andi	a5,a5,255
    2f58:	fef50fa3          	sb	a5,-1(a0)
}
    2f5c:	60a2                	ld	ra,8(sp)
    2f5e:	6402                	ld	s0,0(sp)
    2f60:	0141                	addi	sp,sp,16
    2f62:	8082                	ret

0000000000002f64 <execout>:
{
    2f64:	715d                	addi	sp,sp,-80
    2f66:	e486                	sd	ra,72(sp)
    2f68:	e0a2                	sd	s0,64(sp)
    2f6a:	fc26                	sd	s1,56(sp)
    2f6c:	f84a                	sd	s2,48(sp)
    2f6e:	f44e                	sd	s3,40(sp)
    2f70:	f052                	sd	s4,32(sp)
    2f72:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f74:	4901                	li	s2,0
    2f76:	49bd                	li	s3,15
    int pid = fork();
    2f78:	00003097          	auipc	ra,0x3
    2f7c:	c52080e7          	jalr	-942(ra) # 5bca <fork>
    2f80:	84aa                	mv	s1,a0
    if(pid < 0){
    2f82:	02054063          	bltz	a0,2fa2 <execout+0x3e>
    } else if(pid == 0){
    2f86:	c91d                	beqz	a0,2fbc <execout+0x58>
      wait((int*)0);
    2f88:	4501                	li	a0,0
    2f8a:	00003097          	auipc	ra,0x3
    2f8e:	c50080e7          	jalr	-944(ra) # 5bda <wait>
  for(int avail = 0; avail < 15; avail++){
    2f92:	2905                	addiw	s2,s2,1
    2f94:	ff3912e3          	bne	s2,s3,2f78 <execout+0x14>
  exit(0);
    2f98:	4501                	li	a0,0
    2f9a:	00003097          	auipc	ra,0x3
    2f9e:	c38080e7          	jalr	-968(ra) # 5bd2 <exit>
      printf("fork failed\n");
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	e6650513          	addi	a0,a0,-410 # 6e08 <malloc+0xdd8>
    2faa:	00003097          	auipc	ra,0x3
    2fae:	fc8080e7          	jalr	-56(ra) # 5f72 <printf>
      exit(1);
    2fb2:	4505                	li	a0,1
    2fb4:	00003097          	auipc	ra,0x3
    2fb8:	c1e080e7          	jalr	-994(ra) # 5bd2 <exit>
        if(a == 0xffffffffffffffffLL)
    2fbc:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fbe:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fc0:	6505                	lui	a0,0x1
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	c98080e7          	jalr	-872(ra) # 5c5a <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fca:	01350763          	beq	a0,s3,2fd8 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fce:	6785                	lui	a5,0x1
    2fd0:	953e                	add	a0,a0,a5
    2fd2:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0x109>
      while(1){
    2fd6:	b7ed                	j	2fc0 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fd8:	01205a63          	blez	s2,2fec <execout+0x88>
        sbrk(-4096);
    2fdc:	757d                	lui	a0,0xfffff
    2fde:	00003097          	auipc	ra,0x3
    2fe2:	c7c080e7          	jalr	-900(ra) # 5c5a <sbrk>
      for(int i = 0; i < avail; i++)
    2fe6:	2485                	addiw	s1,s1,1
    2fe8:	ff249ae3          	bne	s1,s2,2fdc <execout+0x78>
      close(1);
    2fec:	4505                	li	a0,1
    2fee:	00003097          	auipc	ra,0x3
    2ff2:	c0c080e7          	jalr	-1012(ra) # 5bfa <close>
      char *args[] = { "echo", "x", 0 };
    2ff6:	00003517          	auipc	a0,0x3
    2ffa:	18250513          	addi	a0,a0,386 # 6178 <malloc+0x148>
    2ffe:	faa43c23          	sd	a0,-72(s0)
    3002:	00003797          	auipc	a5,0x3
    3006:	1e678793          	addi	a5,a5,486 # 61e8 <malloc+0x1b8>
    300a:	fcf43023          	sd	a5,-64(s0)
    300e:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3012:	fb840593          	addi	a1,s0,-72
    3016:	00003097          	auipc	ra,0x3
    301a:	bf4080e7          	jalr	-1036(ra) # 5c0a <exec>
      exit(0);
    301e:	4501                	li	a0,0
    3020:	00003097          	auipc	ra,0x3
    3024:	bb2080e7          	jalr	-1102(ra) # 5bd2 <exit>

0000000000003028 <fourteen>:
{
    3028:	1101                	addi	sp,sp,-32
    302a:	ec06                	sd	ra,24(sp)
    302c:	e822                	sd	s0,16(sp)
    302e:	e426                	sd	s1,8(sp)
    3030:	1000                	addi	s0,sp,32
    3032:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3034:	00004517          	auipc	a0,0x4
    3038:	2e450513          	addi	a0,a0,740 # 7318 <malloc+0x12e8>
    303c:	00003097          	auipc	ra,0x3
    3040:	bfe080e7          	jalr	-1026(ra) # 5c3a <mkdir>
    3044:	e165                	bnez	a0,3124 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3046:	00004517          	auipc	a0,0x4
    304a:	12a50513          	addi	a0,a0,298 # 7170 <malloc+0x1140>
    304e:	00003097          	auipc	ra,0x3
    3052:	bec080e7          	jalr	-1044(ra) # 5c3a <mkdir>
    3056:	e56d                	bnez	a0,3140 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3058:	20000593          	li	a1,512
    305c:	00004517          	auipc	a0,0x4
    3060:	16c50513          	addi	a0,a0,364 # 71c8 <malloc+0x1198>
    3064:	00003097          	auipc	ra,0x3
    3068:	bae080e7          	jalr	-1106(ra) # 5c12 <open>
  if(fd < 0){
    306c:	0e054863          	bltz	a0,315c <fourteen+0x134>
  close(fd);
    3070:	00003097          	auipc	ra,0x3
    3074:	b8a080e7          	jalr	-1142(ra) # 5bfa <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3078:	4581                	li	a1,0
    307a:	00004517          	auipc	a0,0x4
    307e:	1c650513          	addi	a0,a0,454 # 7240 <malloc+0x1210>
    3082:	00003097          	auipc	ra,0x3
    3086:	b90080e7          	jalr	-1136(ra) # 5c12 <open>
  if(fd < 0){
    308a:	0e054763          	bltz	a0,3178 <fourteen+0x150>
  close(fd);
    308e:	00003097          	auipc	ra,0x3
    3092:	b6c080e7          	jalr	-1172(ra) # 5bfa <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3096:	00004517          	auipc	a0,0x4
    309a:	21a50513          	addi	a0,a0,538 # 72b0 <malloc+0x1280>
    309e:	00003097          	auipc	ra,0x3
    30a2:	b9c080e7          	jalr	-1124(ra) # 5c3a <mkdir>
    30a6:	c57d                	beqz	a0,3194 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30a8:	00004517          	auipc	a0,0x4
    30ac:	26050513          	addi	a0,a0,608 # 7308 <malloc+0x12d8>
    30b0:	00003097          	auipc	ra,0x3
    30b4:	b8a080e7          	jalr	-1142(ra) # 5c3a <mkdir>
    30b8:	cd65                	beqz	a0,31b0 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30ba:	00004517          	auipc	a0,0x4
    30be:	24e50513          	addi	a0,a0,590 # 7308 <malloc+0x12d8>
    30c2:	00003097          	auipc	ra,0x3
    30c6:	b60080e7          	jalr	-1184(ra) # 5c22 <unlink>
  unlink("12345678901234/12345678901234");
    30ca:	00004517          	auipc	a0,0x4
    30ce:	1e650513          	addi	a0,a0,486 # 72b0 <malloc+0x1280>
    30d2:	00003097          	auipc	ra,0x3
    30d6:	b50080e7          	jalr	-1200(ra) # 5c22 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30da:	00004517          	auipc	a0,0x4
    30de:	16650513          	addi	a0,a0,358 # 7240 <malloc+0x1210>
    30e2:	00003097          	auipc	ra,0x3
    30e6:	b40080e7          	jalr	-1216(ra) # 5c22 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30ea:	00004517          	auipc	a0,0x4
    30ee:	0de50513          	addi	a0,a0,222 # 71c8 <malloc+0x1198>
    30f2:	00003097          	auipc	ra,0x3
    30f6:	b30080e7          	jalr	-1232(ra) # 5c22 <unlink>
  unlink("12345678901234/123456789012345");
    30fa:	00004517          	auipc	a0,0x4
    30fe:	07650513          	addi	a0,a0,118 # 7170 <malloc+0x1140>
    3102:	00003097          	auipc	ra,0x3
    3106:	b20080e7          	jalr	-1248(ra) # 5c22 <unlink>
  unlink("12345678901234");
    310a:	00004517          	auipc	a0,0x4
    310e:	20e50513          	addi	a0,a0,526 # 7318 <malloc+0x12e8>
    3112:	00003097          	auipc	ra,0x3
    3116:	b10080e7          	jalr	-1264(ra) # 5c22 <unlink>
}
    311a:	60e2                	ld	ra,24(sp)
    311c:	6442                	ld	s0,16(sp)
    311e:	64a2                	ld	s1,8(sp)
    3120:	6105                	addi	sp,sp,32
    3122:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3124:	85a6                	mv	a1,s1
    3126:	00004517          	auipc	a0,0x4
    312a:	02250513          	addi	a0,a0,34 # 7148 <malloc+0x1118>
    312e:	00003097          	auipc	ra,0x3
    3132:	e44080e7          	jalr	-444(ra) # 5f72 <printf>
    exit(1);
    3136:	4505                	li	a0,1
    3138:	00003097          	auipc	ra,0x3
    313c:	a9a080e7          	jalr	-1382(ra) # 5bd2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3140:	85a6                	mv	a1,s1
    3142:	00004517          	auipc	a0,0x4
    3146:	04e50513          	addi	a0,a0,78 # 7190 <malloc+0x1160>
    314a:	00003097          	auipc	ra,0x3
    314e:	e28080e7          	jalr	-472(ra) # 5f72 <printf>
    exit(1);
    3152:	4505                	li	a0,1
    3154:	00003097          	auipc	ra,0x3
    3158:	a7e080e7          	jalr	-1410(ra) # 5bd2 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    315c:	85a6                	mv	a1,s1
    315e:	00004517          	auipc	a0,0x4
    3162:	09a50513          	addi	a0,a0,154 # 71f8 <malloc+0x11c8>
    3166:	00003097          	auipc	ra,0x3
    316a:	e0c080e7          	jalr	-500(ra) # 5f72 <printf>
    exit(1);
    316e:	4505                	li	a0,1
    3170:	00003097          	auipc	ra,0x3
    3174:	a62080e7          	jalr	-1438(ra) # 5bd2 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3178:	85a6                	mv	a1,s1
    317a:	00004517          	auipc	a0,0x4
    317e:	0f650513          	addi	a0,a0,246 # 7270 <malloc+0x1240>
    3182:	00003097          	auipc	ra,0x3
    3186:	df0080e7          	jalr	-528(ra) # 5f72 <printf>
    exit(1);
    318a:	4505                	li	a0,1
    318c:	00003097          	auipc	ra,0x3
    3190:	a46080e7          	jalr	-1466(ra) # 5bd2 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3194:	85a6                	mv	a1,s1
    3196:	00004517          	auipc	a0,0x4
    319a:	13a50513          	addi	a0,a0,314 # 72d0 <malloc+0x12a0>
    319e:	00003097          	auipc	ra,0x3
    31a2:	dd4080e7          	jalr	-556(ra) # 5f72 <printf>
    exit(1);
    31a6:	4505                	li	a0,1
    31a8:	00003097          	auipc	ra,0x3
    31ac:	a2a080e7          	jalr	-1494(ra) # 5bd2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31b0:	85a6                	mv	a1,s1
    31b2:	00004517          	auipc	a0,0x4
    31b6:	17650513          	addi	a0,a0,374 # 7328 <malloc+0x12f8>
    31ba:	00003097          	auipc	ra,0x3
    31be:	db8080e7          	jalr	-584(ra) # 5f72 <printf>
    exit(1);
    31c2:	4505                	li	a0,1
    31c4:	00003097          	auipc	ra,0x3
    31c8:	a0e080e7          	jalr	-1522(ra) # 5bd2 <exit>

00000000000031cc <diskfull>:
{
    31cc:	b9010113          	addi	sp,sp,-1136
    31d0:	46113423          	sd	ra,1128(sp)
    31d4:	46813023          	sd	s0,1120(sp)
    31d8:	44913c23          	sd	s1,1112(sp)
    31dc:	45213823          	sd	s2,1104(sp)
    31e0:	45313423          	sd	s3,1096(sp)
    31e4:	45413023          	sd	s4,1088(sp)
    31e8:	43513c23          	sd	s5,1080(sp)
    31ec:	43613823          	sd	s6,1072(sp)
    31f0:	43713423          	sd	s7,1064(sp)
    31f4:	43813023          	sd	s8,1056(sp)
    31f8:	47010413          	addi	s0,sp,1136
    31fc:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    31fe:	00004517          	auipc	a0,0x4
    3202:	16250513          	addi	a0,a0,354 # 7360 <malloc+0x1330>
    3206:	00003097          	auipc	ra,0x3
    320a:	a1c080e7          	jalr	-1508(ra) # 5c22 <unlink>
  for(fi = 0; done == 0; fi++){
    320e:	4a01                	li	s4,0
    name[0] = 'b';
    3210:	06200b13          	li	s6,98
    name[1] = 'i';
    3214:	06900a93          	li	s5,105
    name[2] = 'g';
    3218:	06700993          	li	s3,103
    321c:	10c00b93          	li	s7,268
    3220:	aabd                	j	339e <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3222:	b9040613          	addi	a2,s0,-1136
    3226:	85e2                	mv	a1,s8
    3228:	00004517          	auipc	a0,0x4
    322c:	14850513          	addi	a0,a0,328 # 7370 <malloc+0x1340>
    3230:	00003097          	auipc	ra,0x3
    3234:	d42080e7          	jalr	-702(ra) # 5f72 <printf>
      break;
    3238:	a821                	j	3250 <diskfull+0x84>
        close(fd);
    323a:	854a                	mv	a0,s2
    323c:	00003097          	auipc	ra,0x3
    3240:	9be080e7          	jalr	-1602(ra) # 5bfa <close>
    close(fd);
    3244:	854a                	mv	a0,s2
    3246:	00003097          	auipc	ra,0x3
    324a:	9b4080e7          	jalr	-1612(ra) # 5bfa <close>
  for(fi = 0; done == 0; fi++){
    324e:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    3250:	4481                	li	s1,0
    name[0] = 'z';
    3252:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3256:	08000993          	li	s3,128
    name[0] = 'z';
    325a:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    325e:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3262:	41f4d79b          	sraiw	a5,s1,0x1f
    3266:	01b7d71b          	srliw	a4,a5,0x1b
    326a:	009707bb          	addw	a5,a4,s1
    326e:	4057d69b          	sraiw	a3,a5,0x5
    3272:	0306869b          	addiw	a3,a3,48
    3276:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    327a:	8bfd                	andi	a5,a5,31
    327c:	9f99                	subw	a5,a5,a4
    327e:	0307879b          	addiw	a5,a5,48
    3282:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3286:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    328a:	bb040513          	addi	a0,s0,-1104
    328e:	00003097          	auipc	ra,0x3
    3292:	994080e7          	jalr	-1644(ra) # 5c22 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3296:	60200593          	li	a1,1538
    329a:	bb040513          	addi	a0,s0,-1104
    329e:	00003097          	auipc	ra,0x3
    32a2:	974080e7          	jalr	-1676(ra) # 5c12 <open>
    if(fd < 0)
    32a6:	00054963          	bltz	a0,32b8 <diskfull+0xec>
    close(fd);
    32aa:	00003097          	auipc	ra,0x3
    32ae:	950080e7          	jalr	-1712(ra) # 5bfa <close>
  for(int i = 0; i < nzz; i++){
    32b2:	2485                	addiw	s1,s1,1
    32b4:	fb3493e3          	bne	s1,s3,325a <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    32b8:	00004517          	auipc	a0,0x4
    32bc:	0a850513          	addi	a0,a0,168 # 7360 <malloc+0x1330>
    32c0:	00003097          	auipc	ra,0x3
    32c4:	97a080e7          	jalr	-1670(ra) # 5c3a <mkdir>
    32c8:	12050963          	beqz	a0,33fa <diskfull+0x22e>
  unlink("diskfulldir");
    32cc:	00004517          	auipc	a0,0x4
    32d0:	09450513          	addi	a0,a0,148 # 7360 <malloc+0x1330>
    32d4:	00003097          	auipc	ra,0x3
    32d8:	94e080e7          	jalr	-1714(ra) # 5c22 <unlink>
  for(int i = 0; i < nzz; i++){
    32dc:	4481                	li	s1,0
    name[0] = 'z';
    32de:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32e2:	08000993          	li	s3,128
    name[0] = 'z';
    32e6:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32ea:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32ee:	41f4d79b          	sraiw	a5,s1,0x1f
    32f2:	01b7d71b          	srliw	a4,a5,0x1b
    32f6:	009707bb          	addw	a5,a4,s1
    32fa:	4057d69b          	sraiw	a3,a5,0x5
    32fe:	0306869b          	addiw	a3,a3,48
    3302:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3306:	8bfd                	andi	a5,a5,31
    3308:	9f99                	subw	a5,a5,a4
    330a:	0307879b          	addiw	a5,a5,48
    330e:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3312:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3316:	bb040513          	addi	a0,s0,-1104
    331a:	00003097          	auipc	ra,0x3
    331e:	908080e7          	jalr	-1784(ra) # 5c22 <unlink>
  for(int i = 0; i < nzz; i++){
    3322:	2485                	addiw	s1,s1,1
    3324:	fd3491e3          	bne	s1,s3,32e6 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3328:	03405e63          	blez	s4,3364 <diskfull+0x198>
    332c:	4481                	li	s1,0
    name[0] = 'b';
    332e:	06200a93          	li	s5,98
    name[1] = 'i';
    3332:	06900993          	li	s3,105
    name[2] = 'g';
    3336:	06700913          	li	s2,103
    name[0] = 'b';
    333a:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    333e:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3342:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3346:	0304879b          	addiw	a5,s1,48
    334a:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    334e:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3352:	bb040513          	addi	a0,s0,-1104
    3356:	00003097          	auipc	ra,0x3
    335a:	8cc080e7          	jalr	-1844(ra) # 5c22 <unlink>
  for(int i = 0; i < fi; i++){
    335e:	2485                	addiw	s1,s1,1
    3360:	fd449de3          	bne	s1,s4,333a <diskfull+0x16e>
}
    3364:	46813083          	ld	ra,1128(sp)
    3368:	46013403          	ld	s0,1120(sp)
    336c:	45813483          	ld	s1,1112(sp)
    3370:	45013903          	ld	s2,1104(sp)
    3374:	44813983          	ld	s3,1096(sp)
    3378:	44013a03          	ld	s4,1088(sp)
    337c:	43813a83          	ld	s5,1080(sp)
    3380:	43013b03          	ld	s6,1072(sp)
    3384:	42813b83          	ld	s7,1064(sp)
    3388:	42013c03          	ld	s8,1056(sp)
    338c:	47010113          	addi	sp,sp,1136
    3390:	8082                	ret
    close(fd);
    3392:	854a                	mv	a0,s2
    3394:	00003097          	auipc	ra,0x3
    3398:	866080e7          	jalr	-1946(ra) # 5bfa <close>
  for(fi = 0; done == 0; fi++){
    339c:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    339e:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    33a2:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    33a6:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    33aa:	030a079b          	addiw	a5,s4,48
    33ae:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33b2:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33b6:	b9040513          	addi	a0,s0,-1136
    33ba:	00003097          	auipc	ra,0x3
    33be:	868080e7          	jalr	-1944(ra) # 5c22 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33c2:	60200593          	li	a1,1538
    33c6:	b9040513          	addi	a0,s0,-1136
    33ca:	00003097          	auipc	ra,0x3
    33ce:	848080e7          	jalr	-1976(ra) # 5c12 <open>
    33d2:	892a                	mv	s2,a0
    if(fd < 0){
    33d4:	e40547e3          	bltz	a0,3222 <diskfull+0x56>
    33d8:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33da:	40000613          	li	a2,1024
    33de:	bb040593          	addi	a1,s0,-1104
    33e2:	854a                	mv	a0,s2
    33e4:	00003097          	auipc	ra,0x3
    33e8:	80e080e7          	jalr	-2034(ra) # 5bf2 <write>
    33ec:	40000793          	li	a5,1024
    33f0:	e4f515e3          	bne	a0,a5,323a <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    33f4:	34fd                	addiw	s1,s1,-1
    33f6:	f0f5                	bnez	s1,33da <diskfull+0x20e>
    33f8:	bf69                	j	3392 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33fa:	00004517          	auipc	a0,0x4
    33fe:	f9650513          	addi	a0,a0,-106 # 7390 <malloc+0x1360>
    3402:	00003097          	auipc	ra,0x3
    3406:	b70080e7          	jalr	-1168(ra) # 5f72 <printf>
    340a:	b5c9                	j	32cc <diskfull+0x100>

000000000000340c <iputtest>:
{
    340c:	1101                	addi	sp,sp,-32
    340e:	ec06                	sd	ra,24(sp)
    3410:	e822                	sd	s0,16(sp)
    3412:	e426                	sd	s1,8(sp)
    3414:	1000                	addi	s0,sp,32
    3416:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3418:	00004517          	auipc	a0,0x4
    341c:	fa850513          	addi	a0,a0,-88 # 73c0 <malloc+0x1390>
    3420:	00003097          	auipc	ra,0x3
    3424:	81a080e7          	jalr	-2022(ra) # 5c3a <mkdir>
    3428:	04054563          	bltz	a0,3472 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    342c:	00004517          	auipc	a0,0x4
    3430:	f9450513          	addi	a0,a0,-108 # 73c0 <malloc+0x1390>
    3434:	00003097          	auipc	ra,0x3
    3438:	80e080e7          	jalr	-2034(ra) # 5c42 <chdir>
    343c:	04054963          	bltz	a0,348e <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3440:	00004517          	auipc	a0,0x4
    3444:	fc050513          	addi	a0,a0,-64 # 7400 <malloc+0x13d0>
    3448:	00002097          	auipc	ra,0x2
    344c:	7da080e7          	jalr	2010(ra) # 5c22 <unlink>
    3450:	04054d63          	bltz	a0,34aa <iputtest+0x9e>
  if(chdir("/") < 0){
    3454:	00004517          	auipc	a0,0x4
    3458:	fdc50513          	addi	a0,a0,-36 # 7430 <malloc+0x1400>
    345c:	00002097          	auipc	ra,0x2
    3460:	7e6080e7          	jalr	2022(ra) # 5c42 <chdir>
    3464:	06054163          	bltz	a0,34c6 <iputtest+0xba>
}
    3468:	60e2                	ld	ra,24(sp)
    346a:	6442                	ld	s0,16(sp)
    346c:	64a2                	ld	s1,8(sp)
    346e:	6105                	addi	sp,sp,32
    3470:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3472:	85a6                	mv	a1,s1
    3474:	00004517          	auipc	a0,0x4
    3478:	f5450513          	addi	a0,a0,-172 # 73c8 <malloc+0x1398>
    347c:	00003097          	auipc	ra,0x3
    3480:	af6080e7          	jalr	-1290(ra) # 5f72 <printf>
    exit(1);
    3484:	4505                	li	a0,1
    3486:	00002097          	auipc	ra,0x2
    348a:	74c080e7          	jalr	1868(ra) # 5bd2 <exit>
    printf("%s: chdir iputdir failed\n", s);
    348e:	85a6                	mv	a1,s1
    3490:	00004517          	auipc	a0,0x4
    3494:	f5050513          	addi	a0,a0,-176 # 73e0 <malloc+0x13b0>
    3498:	00003097          	auipc	ra,0x3
    349c:	ada080e7          	jalr	-1318(ra) # 5f72 <printf>
    exit(1);
    34a0:	4505                	li	a0,1
    34a2:	00002097          	auipc	ra,0x2
    34a6:	730080e7          	jalr	1840(ra) # 5bd2 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34aa:	85a6                	mv	a1,s1
    34ac:	00004517          	auipc	a0,0x4
    34b0:	f6450513          	addi	a0,a0,-156 # 7410 <malloc+0x13e0>
    34b4:	00003097          	auipc	ra,0x3
    34b8:	abe080e7          	jalr	-1346(ra) # 5f72 <printf>
    exit(1);
    34bc:	4505                	li	a0,1
    34be:	00002097          	auipc	ra,0x2
    34c2:	714080e7          	jalr	1812(ra) # 5bd2 <exit>
    printf("%s: chdir / failed\n", s);
    34c6:	85a6                	mv	a1,s1
    34c8:	00004517          	auipc	a0,0x4
    34cc:	f7050513          	addi	a0,a0,-144 # 7438 <malloc+0x1408>
    34d0:	00003097          	auipc	ra,0x3
    34d4:	aa2080e7          	jalr	-1374(ra) # 5f72 <printf>
    exit(1);
    34d8:	4505                	li	a0,1
    34da:	00002097          	auipc	ra,0x2
    34de:	6f8080e7          	jalr	1784(ra) # 5bd2 <exit>

00000000000034e2 <exitiputtest>:
{
    34e2:	7179                	addi	sp,sp,-48
    34e4:	f406                	sd	ra,40(sp)
    34e6:	f022                	sd	s0,32(sp)
    34e8:	ec26                	sd	s1,24(sp)
    34ea:	1800                	addi	s0,sp,48
    34ec:	84aa                	mv	s1,a0
  pid = fork();
    34ee:	00002097          	auipc	ra,0x2
    34f2:	6dc080e7          	jalr	1756(ra) # 5bca <fork>
  if(pid < 0){
    34f6:	04054663          	bltz	a0,3542 <exitiputtest+0x60>
  if(pid == 0){
    34fa:	ed45                	bnez	a0,35b2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34fc:	00004517          	auipc	a0,0x4
    3500:	ec450513          	addi	a0,a0,-316 # 73c0 <malloc+0x1390>
    3504:	00002097          	auipc	ra,0x2
    3508:	736080e7          	jalr	1846(ra) # 5c3a <mkdir>
    350c:	04054963          	bltz	a0,355e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3510:	00004517          	auipc	a0,0x4
    3514:	eb050513          	addi	a0,a0,-336 # 73c0 <malloc+0x1390>
    3518:	00002097          	auipc	ra,0x2
    351c:	72a080e7          	jalr	1834(ra) # 5c42 <chdir>
    3520:	04054d63          	bltz	a0,357a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3524:	00004517          	auipc	a0,0x4
    3528:	edc50513          	addi	a0,a0,-292 # 7400 <malloc+0x13d0>
    352c:	00002097          	auipc	ra,0x2
    3530:	6f6080e7          	jalr	1782(ra) # 5c22 <unlink>
    3534:	06054163          	bltz	a0,3596 <exitiputtest+0xb4>
    exit(0);
    3538:	4501                	li	a0,0
    353a:	00002097          	auipc	ra,0x2
    353e:	698080e7          	jalr	1688(ra) # 5bd2 <exit>
    printf("%s: fork failed\n", s);
    3542:	85a6                	mv	a1,s1
    3544:	00003517          	auipc	a0,0x3
    3548:	4bc50513          	addi	a0,a0,1212 # 6a00 <malloc+0x9d0>
    354c:	00003097          	auipc	ra,0x3
    3550:	a26080e7          	jalr	-1498(ra) # 5f72 <printf>
    exit(1);
    3554:	4505                	li	a0,1
    3556:	00002097          	auipc	ra,0x2
    355a:	67c080e7          	jalr	1660(ra) # 5bd2 <exit>
      printf("%s: mkdir failed\n", s);
    355e:	85a6                	mv	a1,s1
    3560:	00004517          	auipc	a0,0x4
    3564:	e6850513          	addi	a0,a0,-408 # 73c8 <malloc+0x1398>
    3568:	00003097          	auipc	ra,0x3
    356c:	a0a080e7          	jalr	-1526(ra) # 5f72 <printf>
      exit(1);
    3570:	4505                	li	a0,1
    3572:	00002097          	auipc	ra,0x2
    3576:	660080e7          	jalr	1632(ra) # 5bd2 <exit>
      printf("%s: child chdir failed\n", s);
    357a:	85a6                	mv	a1,s1
    357c:	00004517          	auipc	a0,0x4
    3580:	ed450513          	addi	a0,a0,-300 # 7450 <malloc+0x1420>
    3584:	00003097          	auipc	ra,0x3
    3588:	9ee080e7          	jalr	-1554(ra) # 5f72 <printf>
      exit(1);
    358c:	4505                	li	a0,1
    358e:	00002097          	auipc	ra,0x2
    3592:	644080e7          	jalr	1604(ra) # 5bd2 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3596:	85a6                	mv	a1,s1
    3598:	00004517          	auipc	a0,0x4
    359c:	e7850513          	addi	a0,a0,-392 # 7410 <malloc+0x13e0>
    35a0:	00003097          	auipc	ra,0x3
    35a4:	9d2080e7          	jalr	-1582(ra) # 5f72 <printf>
      exit(1);
    35a8:	4505                	li	a0,1
    35aa:	00002097          	auipc	ra,0x2
    35ae:	628080e7          	jalr	1576(ra) # 5bd2 <exit>
  wait(&xstatus);
    35b2:	fdc40513          	addi	a0,s0,-36
    35b6:	00002097          	auipc	ra,0x2
    35ba:	624080e7          	jalr	1572(ra) # 5bda <wait>
  exit(xstatus);
    35be:	fdc42503          	lw	a0,-36(s0)
    35c2:	00002097          	auipc	ra,0x2
    35c6:	610080e7          	jalr	1552(ra) # 5bd2 <exit>

00000000000035ca <dirtest>:
{
    35ca:	1101                	addi	sp,sp,-32
    35cc:	ec06                	sd	ra,24(sp)
    35ce:	e822                	sd	s0,16(sp)
    35d0:	e426                	sd	s1,8(sp)
    35d2:	1000                	addi	s0,sp,32
    35d4:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35d6:	00004517          	auipc	a0,0x4
    35da:	e9250513          	addi	a0,a0,-366 # 7468 <malloc+0x1438>
    35de:	00002097          	auipc	ra,0x2
    35e2:	65c080e7          	jalr	1628(ra) # 5c3a <mkdir>
    35e6:	04054563          	bltz	a0,3630 <dirtest+0x66>
  if(chdir("dir0") < 0){
    35ea:	00004517          	auipc	a0,0x4
    35ee:	e7e50513          	addi	a0,a0,-386 # 7468 <malloc+0x1438>
    35f2:	00002097          	auipc	ra,0x2
    35f6:	650080e7          	jalr	1616(ra) # 5c42 <chdir>
    35fa:	04054963          	bltz	a0,364c <dirtest+0x82>
  if(chdir("..") < 0){
    35fe:	00004517          	auipc	a0,0x4
    3602:	e8a50513          	addi	a0,a0,-374 # 7488 <malloc+0x1458>
    3606:	00002097          	auipc	ra,0x2
    360a:	63c080e7          	jalr	1596(ra) # 5c42 <chdir>
    360e:	04054d63          	bltz	a0,3668 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3612:	00004517          	auipc	a0,0x4
    3616:	e5650513          	addi	a0,a0,-426 # 7468 <malloc+0x1438>
    361a:	00002097          	auipc	ra,0x2
    361e:	608080e7          	jalr	1544(ra) # 5c22 <unlink>
    3622:	06054163          	bltz	a0,3684 <dirtest+0xba>
}
    3626:	60e2                	ld	ra,24(sp)
    3628:	6442                	ld	s0,16(sp)
    362a:	64a2                	ld	s1,8(sp)
    362c:	6105                	addi	sp,sp,32
    362e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3630:	85a6                	mv	a1,s1
    3632:	00004517          	auipc	a0,0x4
    3636:	d9650513          	addi	a0,a0,-618 # 73c8 <malloc+0x1398>
    363a:	00003097          	auipc	ra,0x3
    363e:	938080e7          	jalr	-1736(ra) # 5f72 <printf>
    exit(1);
    3642:	4505                	li	a0,1
    3644:	00002097          	auipc	ra,0x2
    3648:	58e080e7          	jalr	1422(ra) # 5bd2 <exit>
    printf("%s: chdir dir0 failed\n", s);
    364c:	85a6                	mv	a1,s1
    364e:	00004517          	auipc	a0,0x4
    3652:	e2250513          	addi	a0,a0,-478 # 7470 <malloc+0x1440>
    3656:	00003097          	auipc	ra,0x3
    365a:	91c080e7          	jalr	-1764(ra) # 5f72 <printf>
    exit(1);
    365e:	4505                	li	a0,1
    3660:	00002097          	auipc	ra,0x2
    3664:	572080e7          	jalr	1394(ra) # 5bd2 <exit>
    printf("%s: chdir .. failed\n", s);
    3668:	85a6                	mv	a1,s1
    366a:	00004517          	auipc	a0,0x4
    366e:	e2650513          	addi	a0,a0,-474 # 7490 <malloc+0x1460>
    3672:	00003097          	auipc	ra,0x3
    3676:	900080e7          	jalr	-1792(ra) # 5f72 <printf>
    exit(1);
    367a:	4505                	li	a0,1
    367c:	00002097          	auipc	ra,0x2
    3680:	556080e7          	jalr	1366(ra) # 5bd2 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3684:	85a6                	mv	a1,s1
    3686:	00004517          	auipc	a0,0x4
    368a:	e2250513          	addi	a0,a0,-478 # 74a8 <malloc+0x1478>
    368e:	00003097          	auipc	ra,0x3
    3692:	8e4080e7          	jalr	-1820(ra) # 5f72 <printf>
    exit(1);
    3696:	4505                	li	a0,1
    3698:	00002097          	auipc	ra,0x2
    369c:	53a080e7          	jalr	1338(ra) # 5bd2 <exit>

00000000000036a0 <subdir>:
{
    36a0:	1101                	addi	sp,sp,-32
    36a2:	ec06                	sd	ra,24(sp)
    36a4:	e822                	sd	s0,16(sp)
    36a6:	e426                	sd	s1,8(sp)
    36a8:	e04a                	sd	s2,0(sp)
    36aa:	1000                	addi	s0,sp,32
    36ac:	892a                	mv	s2,a0
  unlink("ff");
    36ae:	00004517          	auipc	a0,0x4
    36b2:	f4250513          	addi	a0,a0,-190 # 75f0 <malloc+0x15c0>
    36b6:	00002097          	auipc	ra,0x2
    36ba:	56c080e7          	jalr	1388(ra) # 5c22 <unlink>
  if(mkdir("dd") != 0){
    36be:	00004517          	auipc	a0,0x4
    36c2:	e0250513          	addi	a0,a0,-510 # 74c0 <malloc+0x1490>
    36c6:	00002097          	auipc	ra,0x2
    36ca:	574080e7          	jalr	1396(ra) # 5c3a <mkdir>
    36ce:	38051663          	bnez	a0,3a5a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36d2:	20200593          	li	a1,514
    36d6:	00004517          	auipc	a0,0x4
    36da:	e0a50513          	addi	a0,a0,-502 # 74e0 <malloc+0x14b0>
    36de:	00002097          	auipc	ra,0x2
    36e2:	534080e7          	jalr	1332(ra) # 5c12 <open>
    36e6:	84aa                	mv	s1,a0
  if(fd < 0){
    36e8:	38054763          	bltz	a0,3a76 <subdir+0x3d6>
  write(fd, "ff", 2);
    36ec:	4609                	li	a2,2
    36ee:	00004597          	auipc	a1,0x4
    36f2:	f0258593          	addi	a1,a1,-254 # 75f0 <malloc+0x15c0>
    36f6:	00002097          	auipc	ra,0x2
    36fa:	4fc080e7          	jalr	1276(ra) # 5bf2 <write>
  close(fd);
    36fe:	8526                	mv	a0,s1
    3700:	00002097          	auipc	ra,0x2
    3704:	4fa080e7          	jalr	1274(ra) # 5bfa <close>
  if(unlink("dd") >= 0){
    3708:	00004517          	auipc	a0,0x4
    370c:	db850513          	addi	a0,a0,-584 # 74c0 <malloc+0x1490>
    3710:	00002097          	auipc	ra,0x2
    3714:	512080e7          	jalr	1298(ra) # 5c22 <unlink>
    3718:	36055d63          	bgez	a0,3a92 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    371c:	00004517          	auipc	a0,0x4
    3720:	e1c50513          	addi	a0,a0,-484 # 7538 <malloc+0x1508>
    3724:	00002097          	auipc	ra,0x2
    3728:	516080e7          	jalr	1302(ra) # 5c3a <mkdir>
    372c:	38051163          	bnez	a0,3aae <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3730:	20200593          	li	a1,514
    3734:	00004517          	auipc	a0,0x4
    3738:	e2c50513          	addi	a0,a0,-468 # 7560 <malloc+0x1530>
    373c:	00002097          	auipc	ra,0x2
    3740:	4d6080e7          	jalr	1238(ra) # 5c12 <open>
    3744:	84aa                	mv	s1,a0
  if(fd < 0){
    3746:	38054263          	bltz	a0,3aca <subdir+0x42a>
  write(fd, "FF", 2);
    374a:	4609                	li	a2,2
    374c:	00004597          	auipc	a1,0x4
    3750:	e4458593          	addi	a1,a1,-444 # 7590 <malloc+0x1560>
    3754:	00002097          	auipc	ra,0x2
    3758:	49e080e7          	jalr	1182(ra) # 5bf2 <write>
  close(fd);
    375c:	8526                	mv	a0,s1
    375e:	00002097          	auipc	ra,0x2
    3762:	49c080e7          	jalr	1180(ra) # 5bfa <close>
  fd = open("dd/dd/../ff", 0);
    3766:	4581                	li	a1,0
    3768:	00004517          	auipc	a0,0x4
    376c:	e3050513          	addi	a0,a0,-464 # 7598 <malloc+0x1568>
    3770:	00002097          	auipc	ra,0x2
    3774:	4a2080e7          	jalr	1186(ra) # 5c12 <open>
    3778:	84aa                	mv	s1,a0
  if(fd < 0){
    377a:	36054663          	bltz	a0,3ae6 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    377e:	660d                	lui	a2,0x3
    3780:	00009597          	auipc	a1,0x9
    3784:	4f858593          	addi	a1,a1,1272 # cc78 <buf>
    3788:	00002097          	auipc	ra,0x2
    378c:	462080e7          	jalr	1122(ra) # 5bea <read>
  if(cc != 2 || buf[0] != 'f'){
    3790:	4789                	li	a5,2
    3792:	36f51863          	bne	a0,a5,3b02 <subdir+0x462>
    3796:	00009717          	auipc	a4,0x9
    379a:	4e274703          	lbu	a4,1250(a4) # cc78 <buf>
    379e:	06600793          	li	a5,102
    37a2:	36f71063          	bne	a4,a5,3b02 <subdir+0x462>
  close(fd);
    37a6:	8526                	mv	a0,s1
    37a8:	00002097          	auipc	ra,0x2
    37ac:	452080e7          	jalr	1106(ra) # 5bfa <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37b0:	00004597          	auipc	a1,0x4
    37b4:	e3858593          	addi	a1,a1,-456 # 75e8 <malloc+0x15b8>
    37b8:	00004517          	auipc	a0,0x4
    37bc:	da850513          	addi	a0,a0,-600 # 7560 <malloc+0x1530>
    37c0:	00002097          	auipc	ra,0x2
    37c4:	472080e7          	jalr	1138(ra) # 5c32 <link>
    37c8:	34051b63          	bnez	a0,3b1e <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37cc:	00004517          	auipc	a0,0x4
    37d0:	d9450513          	addi	a0,a0,-620 # 7560 <malloc+0x1530>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	44e080e7          	jalr	1102(ra) # 5c22 <unlink>
    37dc:	34051f63          	bnez	a0,3b3a <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37e0:	4581                	li	a1,0
    37e2:	00004517          	auipc	a0,0x4
    37e6:	d7e50513          	addi	a0,a0,-642 # 7560 <malloc+0x1530>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	428080e7          	jalr	1064(ra) # 5c12 <open>
    37f2:	36055263          	bgez	a0,3b56 <subdir+0x4b6>
  if(chdir("dd") != 0){
    37f6:	00004517          	auipc	a0,0x4
    37fa:	cca50513          	addi	a0,a0,-822 # 74c0 <malloc+0x1490>
    37fe:	00002097          	auipc	ra,0x2
    3802:	444080e7          	jalr	1092(ra) # 5c42 <chdir>
    3806:	36051663          	bnez	a0,3b72 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    380a:	00004517          	auipc	a0,0x4
    380e:	e7650513          	addi	a0,a0,-394 # 7680 <malloc+0x1650>
    3812:	00002097          	auipc	ra,0x2
    3816:	430080e7          	jalr	1072(ra) # 5c42 <chdir>
    381a:	36051a63          	bnez	a0,3b8e <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    381e:	00004517          	auipc	a0,0x4
    3822:	e9250513          	addi	a0,a0,-366 # 76b0 <malloc+0x1680>
    3826:	00002097          	auipc	ra,0x2
    382a:	41c080e7          	jalr	1052(ra) # 5c42 <chdir>
    382e:	36051e63          	bnez	a0,3baa <subdir+0x50a>
  if(chdir("./..") != 0){
    3832:	00004517          	auipc	a0,0x4
    3836:	eae50513          	addi	a0,a0,-338 # 76e0 <malloc+0x16b0>
    383a:	00002097          	auipc	ra,0x2
    383e:	408080e7          	jalr	1032(ra) # 5c42 <chdir>
    3842:	38051263          	bnez	a0,3bc6 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3846:	4581                	li	a1,0
    3848:	00004517          	auipc	a0,0x4
    384c:	da050513          	addi	a0,a0,-608 # 75e8 <malloc+0x15b8>
    3850:	00002097          	auipc	ra,0x2
    3854:	3c2080e7          	jalr	962(ra) # 5c12 <open>
    3858:	84aa                	mv	s1,a0
  if(fd < 0){
    385a:	38054463          	bltz	a0,3be2 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    385e:	660d                	lui	a2,0x3
    3860:	00009597          	auipc	a1,0x9
    3864:	41858593          	addi	a1,a1,1048 # cc78 <buf>
    3868:	00002097          	auipc	ra,0x2
    386c:	382080e7          	jalr	898(ra) # 5bea <read>
    3870:	4789                	li	a5,2
    3872:	38f51663          	bne	a0,a5,3bfe <subdir+0x55e>
  close(fd);
    3876:	8526                	mv	a0,s1
    3878:	00002097          	auipc	ra,0x2
    387c:	382080e7          	jalr	898(ra) # 5bfa <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3880:	4581                	li	a1,0
    3882:	00004517          	auipc	a0,0x4
    3886:	cde50513          	addi	a0,a0,-802 # 7560 <malloc+0x1530>
    388a:	00002097          	auipc	ra,0x2
    388e:	388080e7          	jalr	904(ra) # 5c12 <open>
    3892:	38055463          	bgez	a0,3c1a <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3896:	20200593          	li	a1,514
    389a:	00004517          	auipc	a0,0x4
    389e:	ed650513          	addi	a0,a0,-298 # 7770 <malloc+0x1740>
    38a2:	00002097          	auipc	ra,0x2
    38a6:	370080e7          	jalr	880(ra) # 5c12 <open>
    38aa:	38055663          	bgez	a0,3c36 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38ae:	20200593          	li	a1,514
    38b2:	00004517          	auipc	a0,0x4
    38b6:	eee50513          	addi	a0,a0,-274 # 77a0 <malloc+0x1770>
    38ba:	00002097          	auipc	ra,0x2
    38be:	358080e7          	jalr	856(ra) # 5c12 <open>
    38c2:	38055863          	bgez	a0,3c52 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38c6:	20000593          	li	a1,512
    38ca:	00004517          	auipc	a0,0x4
    38ce:	bf650513          	addi	a0,a0,-1034 # 74c0 <malloc+0x1490>
    38d2:	00002097          	auipc	ra,0x2
    38d6:	340080e7          	jalr	832(ra) # 5c12 <open>
    38da:	38055a63          	bgez	a0,3c6e <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38de:	4589                	li	a1,2
    38e0:	00004517          	auipc	a0,0x4
    38e4:	be050513          	addi	a0,a0,-1056 # 74c0 <malloc+0x1490>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	32a080e7          	jalr	810(ra) # 5c12 <open>
    38f0:	38055d63          	bgez	a0,3c8a <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38f4:	4585                	li	a1,1
    38f6:	00004517          	auipc	a0,0x4
    38fa:	bca50513          	addi	a0,a0,-1078 # 74c0 <malloc+0x1490>
    38fe:	00002097          	auipc	ra,0x2
    3902:	314080e7          	jalr	788(ra) # 5c12 <open>
    3906:	3a055063          	bgez	a0,3ca6 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    390a:	00004597          	auipc	a1,0x4
    390e:	f2658593          	addi	a1,a1,-218 # 7830 <malloc+0x1800>
    3912:	00004517          	auipc	a0,0x4
    3916:	e5e50513          	addi	a0,a0,-418 # 7770 <malloc+0x1740>
    391a:	00002097          	auipc	ra,0x2
    391e:	318080e7          	jalr	792(ra) # 5c32 <link>
    3922:	3a050063          	beqz	a0,3cc2 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3926:	00004597          	auipc	a1,0x4
    392a:	f0a58593          	addi	a1,a1,-246 # 7830 <malloc+0x1800>
    392e:	00004517          	auipc	a0,0x4
    3932:	e7250513          	addi	a0,a0,-398 # 77a0 <malloc+0x1770>
    3936:	00002097          	auipc	ra,0x2
    393a:	2fc080e7          	jalr	764(ra) # 5c32 <link>
    393e:	3a050063          	beqz	a0,3cde <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3942:	00004597          	auipc	a1,0x4
    3946:	ca658593          	addi	a1,a1,-858 # 75e8 <malloc+0x15b8>
    394a:	00004517          	auipc	a0,0x4
    394e:	b9650513          	addi	a0,a0,-1130 # 74e0 <malloc+0x14b0>
    3952:	00002097          	auipc	ra,0x2
    3956:	2e0080e7          	jalr	736(ra) # 5c32 <link>
    395a:	3a050063          	beqz	a0,3cfa <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    395e:	00004517          	auipc	a0,0x4
    3962:	e1250513          	addi	a0,a0,-494 # 7770 <malloc+0x1740>
    3966:	00002097          	auipc	ra,0x2
    396a:	2d4080e7          	jalr	724(ra) # 5c3a <mkdir>
    396e:	3a050463          	beqz	a0,3d16 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3972:	00004517          	auipc	a0,0x4
    3976:	e2e50513          	addi	a0,a0,-466 # 77a0 <malloc+0x1770>
    397a:	00002097          	auipc	ra,0x2
    397e:	2c0080e7          	jalr	704(ra) # 5c3a <mkdir>
    3982:	3a050863          	beqz	a0,3d32 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3986:	00004517          	auipc	a0,0x4
    398a:	c6250513          	addi	a0,a0,-926 # 75e8 <malloc+0x15b8>
    398e:	00002097          	auipc	ra,0x2
    3992:	2ac080e7          	jalr	684(ra) # 5c3a <mkdir>
    3996:	3a050c63          	beqz	a0,3d4e <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    399a:	00004517          	auipc	a0,0x4
    399e:	e0650513          	addi	a0,a0,-506 # 77a0 <malloc+0x1770>
    39a2:	00002097          	auipc	ra,0x2
    39a6:	280080e7          	jalr	640(ra) # 5c22 <unlink>
    39aa:	3c050063          	beqz	a0,3d6a <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39ae:	00004517          	auipc	a0,0x4
    39b2:	dc250513          	addi	a0,a0,-574 # 7770 <malloc+0x1740>
    39b6:	00002097          	auipc	ra,0x2
    39ba:	26c080e7          	jalr	620(ra) # 5c22 <unlink>
    39be:	3c050463          	beqz	a0,3d86 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39c2:	00004517          	auipc	a0,0x4
    39c6:	b1e50513          	addi	a0,a0,-1250 # 74e0 <malloc+0x14b0>
    39ca:	00002097          	auipc	ra,0x2
    39ce:	278080e7          	jalr	632(ra) # 5c42 <chdir>
    39d2:	3c050863          	beqz	a0,3da2 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39d6:	00004517          	auipc	a0,0x4
    39da:	faa50513          	addi	a0,a0,-86 # 7980 <malloc+0x1950>
    39de:	00002097          	auipc	ra,0x2
    39e2:	264080e7          	jalr	612(ra) # 5c42 <chdir>
    39e6:	3c050c63          	beqz	a0,3dbe <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39ea:	00004517          	auipc	a0,0x4
    39ee:	bfe50513          	addi	a0,a0,-1026 # 75e8 <malloc+0x15b8>
    39f2:	00002097          	auipc	ra,0x2
    39f6:	230080e7          	jalr	560(ra) # 5c22 <unlink>
    39fa:	3e051063          	bnez	a0,3dda <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39fe:	00004517          	auipc	a0,0x4
    3a02:	ae250513          	addi	a0,a0,-1310 # 74e0 <malloc+0x14b0>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	21c080e7          	jalr	540(ra) # 5c22 <unlink>
    3a0e:	3e051463          	bnez	a0,3df6 <subdir+0x756>
  if(unlink("dd") == 0){
    3a12:	00004517          	auipc	a0,0x4
    3a16:	aae50513          	addi	a0,a0,-1362 # 74c0 <malloc+0x1490>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	208080e7          	jalr	520(ra) # 5c22 <unlink>
    3a22:	3e050863          	beqz	a0,3e12 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a26:	00004517          	auipc	a0,0x4
    3a2a:	fca50513          	addi	a0,a0,-54 # 79f0 <malloc+0x19c0>
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	1f4080e7          	jalr	500(ra) # 5c22 <unlink>
    3a36:	3e054c63          	bltz	a0,3e2e <subdir+0x78e>
  if(unlink("dd") < 0){
    3a3a:	00004517          	auipc	a0,0x4
    3a3e:	a8650513          	addi	a0,a0,-1402 # 74c0 <malloc+0x1490>
    3a42:	00002097          	auipc	ra,0x2
    3a46:	1e0080e7          	jalr	480(ra) # 5c22 <unlink>
    3a4a:	40054063          	bltz	a0,3e4a <subdir+0x7aa>
}
    3a4e:	60e2                	ld	ra,24(sp)
    3a50:	6442                	ld	s0,16(sp)
    3a52:	64a2                	ld	s1,8(sp)
    3a54:	6902                	ld	s2,0(sp)
    3a56:	6105                	addi	sp,sp,32
    3a58:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a5a:	85ca                	mv	a1,s2
    3a5c:	00004517          	auipc	a0,0x4
    3a60:	a6c50513          	addi	a0,a0,-1428 # 74c8 <malloc+0x1498>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	50e080e7          	jalr	1294(ra) # 5f72 <printf>
    exit(1);
    3a6c:	4505                	li	a0,1
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	164080e7          	jalr	356(ra) # 5bd2 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a76:	85ca                	mv	a1,s2
    3a78:	00004517          	auipc	a0,0x4
    3a7c:	a7050513          	addi	a0,a0,-1424 # 74e8 <malloc+0x14b8>
    3a80:	00002097          	auipc	ra,0x2
    3a84:	4f2080e7          	jalr	1266(ra) # 5f72 <printf>
    exit(1);
    3a88:	4505                	li	a0,1
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	148080e7          	jalr	328(ra) # 5bd2 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a92:	85ca                	mv	a1,s2
    3a94:	00004517          	auipc	a0,0x4
    3a98:	a7450513          	addi	a0,a0,-1420 # 7508 <malloc+0x14d8>
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	4d6080e7          	jalr	1238(ra) # 5f72 <printf>
    exit(1);
    3aa4:	4505                	li	a0,1
    3aa6:	00002097          	auipc	ra,0x2
    3aaa:	12c080e7          	jalr	300(ra) # 5bd2 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3aae:	85ca                	mv	a1,s2
    3ab0:	00004517          	auipc	a0,0x4
    3ab4:	a9050513          	addi	a0,a0,-1392 # 7540 <malloc+0x1510>
    3ab8:	00002097          	auipc	ra,0x2
    3abc:	4ba080e7          	jalr	1210(ra) # 5f72 <printf>
    exit(1);
    3ac0:	4505                	li	a0,1
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	110080e7          	jalr	272(ra) # 5bd2 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3aca:	85ca                	mv	a1,s2
    3acc:	00004517          	auipc	a0,0x4
    3ad0:	aa450513          	addi	a0,a0,-1372 # 7570 <malloc+0x1540>
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	49e080e7          	jalr	1182(ra) # 5f72 <printf>
    exit(1);
    3adc:	4505                	li	a0,1
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	0f4080e7          	jalr	244(ra) # 5bd2 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3ae6:	85ca                	mv	a1,s2
    3ae8:	00004517          	auipc	a0,0x4
    3aec:	ac050513          	addi	a0,a0,-1344 # 75a8 <malloc+0x1578>
    3af0:	00002097          	auipc	ra,0x2
    3af4:	482080e7          	jalr	1154(ra) # 5f72 <printf>
    exit(1);
    3af8:	4505                	li	a0,1
    3afa:	00002097          	auipc	ra,0x2
    3afe:	0d8080e7          	jalr	216(ra) # 5bd2 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b02:	85ca                	mv	a1,s2
    3b04:	00004517          	auipc	a0,0x4
    3b08:	ac450513          	addi	a0,a0,-1340 # 75c8 <malloc+0x1598>
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	466080e7          	jalr	1126(ra) # 5f72 <printf>
    exit(1);
    3b14:	4505                	li	a0,1
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	0bc080e7          	jalr	188(ra) # 5bd2 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b1e:	85ca                	mv	a1,s2
    3b20:	00004517          	auipc	a0,0x4
    3b24:	ad850513          	addi	a0,a0,-1320 # 75f8 <malloc+0x15c8>
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	44a080e7          	jalr	1098(ra) # 5f72 <printf>
    exit(1);
    3b30:	4505                	li	a0,1
    3b32:	00002097          	auipc	ra,0x2
    3b36:	0a0080e7          	jalr	160(ra) # 5bd2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b3a:	85ca                	mv	a1,s2
    3b3c:	00004517          	auipc	a0,0x4
    3b40:	ae450513          	addi	a0,a0,-1308 # 7620 <malloc+0x15f0>
    3b44:	00002097          	auipc	ra,0x2
    3b48:	42e080e7          	jalr	1070(ra) # 5f72 <printf>
    exit(1);
    3b4c:	4505                	li	a0,1
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	084080e7          	jalr	132(ra) # 5bd2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b56:	85ca                	mv	a1,s2
    3b58:	00004517          	auipc	a0,0x4
    3b5c:	ae850513          	addi	a0,a0,-1304 # 7640 <malloc+0x1610>
    3b60:	00002097          	auipc	ra,0x2
    3b64:	412080e7          	jalr	1042(ra) # 5f72 <printf>
    exit(1);
    3b68:	4505                	li	a0,1
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	068080e7          	jalr	104(ra) # 5bd2 <exit>
    printf("%s: chdir dd failed\n", s);
    3b72:	85ca                	mv	a1,s2
    3b74:	00004517          	auipc	a0,0x4
    3b78:	af450513          	addi	a0,a0,-1292 # 7668 <malloc+0x1638>
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	3f6080e7          	jalr	1014(ra) # 5f72 <printf>
    exit(1);
    3b84:	4505                	li	a0,1
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	04c080e7          	jalr	76(ra) # 5bd2 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b8e:	85ca                	mv	a1,s2
    3b90:	00004517          	auipc	a0,0x4
    3b94:	b0050513          	addi	a0,a0,-1280 # 7690 <malloc+0x1660>
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	3da080e7          	jalr	986(ra) # 5f72 <printf>
    exit(1);
    3ba0:	4505                	li	a0,1
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	030080e7          	jalr	48(ra) # 5bd2 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3baa:	85ca                	mv	a1,s2
    3bac:	00004517          	auipc	a0,0x4
    3bb0:	b1450513          	addi	a0,a0,-1260 # 76c0 <malloc+0x1690>
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	3be080e7          	jalr	958(ra) # 5f72 <printf>
    exit(1);
    3bbc:	4505                	li	a0,1
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	014080e7          	jalr	20(ra) # 5bd2 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bc6:	85ca                	mv	a1,s2
    3bc8:	00004517          	auipc	a0,0x4
    3bcc:	b2050513          	addi	a0,a0,-1248 # 76e8 <malloc+0x16b8>
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	3a2080e7          	jalr	930(ra) # 5f72 <printf>
    exit(1);
    3bd8:	4505                	li	a0,1
    3bda:	00002097          	auipc	ra,0x2
    3bde:	ff8080e7          	jalr	-8(ra) # 5bd2 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3be2:	85ca                	mv	a1,s2
    3be4:	00004517          	auipc	a0,0x4
    3be8:	b1c50513          	addi	a0,a0,-1252 # 7700 <malloc+0x16d0>
    3bec:	00002097          	auipc	ra,0x2
    3bf0:	386080e7          	jalr	902(ra) # 5f72 <printf>
    exit(1);
    3bf4:	4505                	li	a0,1
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	fdc080e7          	jalr	-36(ra) # 5bd2 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bfe:	85ca                	mv	a1,s2
    3c00:	00004517          	auipc	a0,0x4
    3c04:	b2050513          	addi	a0,a0,-1248 # 7720 <malloc+0x16f0>
    3c08:	00002097          	auipc	ra,0x2
    3c0c:	36a080e7          	jalr	874(ra) # 5f72 <printf>
    exit(1);
    3c10:	4505                	li	a0,1
    3c12:	00002097          	auipc	ra,0x2
    3c16:	fc0080e7          	jalr	-64(ra) # 5bd2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c1a:	85ca                	mv	a1,s2
    3c1c:	00004517          	auipc	a0,0x4
    3c20:	b2450513          	addi	a0,a0,-1244 # 7740 <malloc+0x1710>
    3c24:	00002097          	auipc	ra,0x2
    3c28:	34e080e7          	jalr	846(ra) # 5f72 <printf>
    exit(1);
    3c2c:	4505                	li	a0,1
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	fa4080e7          	jalr	-92(ra) # 5bd2 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c36:	85ca                	mv	a1,s2
    3c38:	00004517          	auipc	a0,0x4
    3c3c:	b4850513          	addi	a0,a0,-1208 # 7780 <malloc+0x1750>
    3c40:	00002097          	auipc	ra,0x2
    3c44:	332080e7          	jalr	818(ra) # 5f72 <printf>
    exit(1);
    3c48:	4505                	li	a0,1
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	f88080e7          	jalr	-120(ra) # 5bd2 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c52:	85ca                	mv	a1,s2
    3c54:	00004517          	auipc	a0,0x4
    3c58:	b5c50513          	addi	a0,a0,-1188 # 77b0 <malloc+0x1780>
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	316080e7          	jalr	790(ra) # 5f72 <printf>
    exit(1);
    3c64:	4505                	li	a0,1
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	f6c080e7          	jalr	-148(ra) # 5bd2 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c6e:	85ca                	mv	a1,s2
    3c70:	00004517          	auipc	a0,0x4
    3c74:	b6050513          	addi	a0,a0,-1184 # 77d0 <malloc+0x17a0>
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	2fa080e7          	jalr	762(ra) # 5f72 <printf>
    exit(1);
    3c80:	4505                	li	a0,1
    3c82:	00002097          	auipc	ra,0x2
    3c86:	f50080e7          	jalr	-176(ra) # 5bd2 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c8a:	85ca                	mv	a1,s2
    3c8c:	00004517          	auipc	a0,0x4
    3c90:	b6450513          	addi	a0,a0,-1180 # 77f0 <malloc+0x17c0>
    3c94:	00002097          	auipc	ra,0x2
    3c98:	2de080e7          	jalr	734(ra) # 5f72 <printf>
    exit(1);
    3c9c:	4505                	li	a0,1
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	f34080e7          	jalr	-204(ra) # 5bd2 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3ca6:	85ca                	mv	a1,s2
    3ca8:	00004517          	auipc	a0,0x4
    3cac:	b6850513          	addi	a0,a0,-1176 # 7810 <malloc+0x17e0>
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	2c2080e7          	jalr	706(ra) # 5f72 <printf>
    exit(1);
    3cb8:	4505                	li	a0,1
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	f18080e7          	jalr	-232(ra) # 5bd2 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cc2:	85ca                	mv	a1,s2
    3cc4:	00004517          	auipc	a0,0x4
    3cc8:	b7c50513          	addi	a0,a0,-1156 # 7840 <malloc+0x1810>
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	2a6080e7          	jalr	678(ra) # 5f72 <printf>
    exit(1);
    3cd4:	4505                	li	a0,1
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	efc080e7          	jalr	-260(ra) # 5bd2 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cde:	85ca                	mv	a1,s2
    3ce0:	00004517          	auipc	a0,0x4
    3ce4:	b8850513          	addi	a0,a0,-1144 # 7868 <malloc+0x1838>
    3ce8:	00002097          	auipc	ra,0x2
    3cec:	28a080e7          	jalr	650(ra) # 5f72 <printf>
    exit(1);
    3cf0:	4505                	li	a0,1
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	ee0080e7          	jalr	-288(ra) # 5bd2 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cfa:	85ca                	mv	a1,s2
    3cfc:	00004517          	auipc	a0,0x4
    3d00:	b9450513          	addi	a0,a0,-1132 # 7890 <malloc+0x1860>
    3d04:	00002097          	auipc	ra,0x2
    3d08:	26e080e7          	jalr	622(ra) # 5f72 <printf>
    exit(1);
    3d0c:	4505                	li	a0,1
    3d0e:	00002097          	auipc	ra,0x2
    3d12:	ec4080e7          	jalr	-316(ra) # 5bd2 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d16:	85ca                	mv	a1,s2
    3d18:	00004517          	auipc	a0,0x4
    3d1c:	ba050513          	addi	a0,a0,-1120 # 78b8 <malloc+0x1888>
    3d20:	00002097          	auipc	ra,0x2
    3d24:	252080e7          	jalr	594(ra) # 5f72 <printf>
    exit(1);
    3d28:	4505                	li	a0,1
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	ea8080e7          	jalr	-344(ra) # 5bd2 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d32:	85ca                	mv	a1,s2
    3d34:	00004517          	auipc	a0,0x4
    3d38:	ba450513          	addi	a0,a0,-1116 # 78d8 <malloc+0x18a8>
    3d3c:	00002097          	auipc	ra,0x2
    3d40:	236080e7          	jalr	566(ra) # 5f72 <printf>
    exit(1);
    3d44:	4505                	li	a0,1
    3d46:	00002097          	auipc	ra,0x2
    3d4a:	e8c080e7          	jalr	-372(ra) # 5bd2 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d4e:	85ca                	mv	a1,s2
    3d50:	00004517          	auipc	a0,0x4
    3d54:	ba850513          	addi	a0,a0,-1112 # 78f8 <malloc+0x18c8>
    3d58:	00002097          	auipc	ra,0x2
    3d5c:	21a080e7          	jalr	538(ra) # 5f72 <printf>
    exit(1);
    3d60:	4505                	li	a0,1
    3d62:	00002097          	auipc	ra,0x2
    3d66:	e70080e7          	jalr	-400(ra) # 5bd2 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d6a:	85ca                	mv	a1,s2
    3d6c:	00004517          	auipc	a0,0x4
    3d70:	bb450513          	addi	a0,a0,-1100 # 7920 <malloc+0x18f0>
    3d74:	00002097          	auipc	ra,0x2
    3d78:	1fe080e7          	jalr	510(ra) # 5f72 <printf>
    exit(1);
    3d7c:	4505                	li	a0,1
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	e54080e7          	jalr	-428(ra) # 5bd2 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d86:	85ca                	mv	a1,s2
    3d88:	00004517          	auipc	a0,0x4
    3d8c:	bb850513          	addi	a0,a0,-1096 # 7940 <malloc+0x1910>
    3d90:	00002097          	auipc	ra,0x2
    3d94:	1e2080e7          	jalr	482(ra) # 5f72 <printf>
    exit(1);
    3d98:	4505                	li	a0,1
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	e38080e7          	jalr	-456(ra) # 5bd2 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3da2:	85ca                	mv	a1,s2
    3da4:	00004517          	auipc	a0,0x4
    3da8:	bbc50513          	addi	a0,a0,-1092 # 7960 <malloc+0x1930>
    3dac:	00002097          	auipc	ra,0x2
    3db0:	1c6080e7          	jalr	454(ra) # 5f72 <printf>
    exit(1);
    3db4:	4505                	li	a0,1
    3db6:	00002097          	auipc	ra,0x2
    3dba:	e1c080e7          	jalr	-484(ra) # 5bd2 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dbe:	85ca                	mv	a1,s2
    3dc0:	00004517          	auipc	a0,0x4
    3dc4:	bc850513          	addi	a0,a0,-1080 # 7988 <malloc+0x1958>
    3dc8:	00002097          	auipc	ra,0x2
    3dcc:	1aa080e7          	jalr	426(ra) # 5f72 <printf>
    exit(1);
    3dd0:	4505                	li	a0,1
    3dd2:	00002097          	auipc	ra,0x2
    3dd6:	e00080e7          	jalr	-512(ra) # 5bd2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dda:	85ca                	mv	a1,s2
    3ddc:	00004517          	auipc	a0,0x4
    3de0:	84450513          	addi	a0,a0,-1980 # 7620 <malloc+0x15f0>
    3de4:	00002097          	auipc	ra,0x2
    3de8:	18e080e7          	jalr	398(ra) # 5f72 <printf>
    exit(1);
    3dec:	4505                	li	a0,1
    3dee:	00002097          	auipc	ra,0x2
    3df2:	de4080e7          	jalr	-540(ra) # 5bd2 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3df6:	85ca                	mv	a1,s2
    3df8:	00004517          	auipc	a0,0x4
    3dfc:	bb050513          	addi	a0,a0,-1104 # 79a8 <malloc+0x1978>
    3e00:	00002097          	auipc	ra,0x2
    3e04:	172080e7          	jalr	370(ra) # 5f72 <printf>
    exit(1);
    3e08:	4505                	li	a0,1
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	dc8080e7          	jalr	-568(ra) # 5bd2 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e12:	85ca                	mv	a1,s2
    3e14:	00004517          	auipc	a0,0x4
    3e18:	bb450513          	addi	a0,a0,-1100 # 79c8 <malloc+0x1998>
    3e1c:	00002097          	auipc	ra,0x2
    3e20:	156080e7          	jalr	342(ra) # 5f72 <printf>
    exit(1);
    3e24:	4505                	li	a0,1
    3e26:	00002097          	auipc	ra,0x2
    3e2a:	dac080e7          	jalr	-596(ra) # 5bd2 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e2e:	85ca                	mv	a1,s2
    3e30:	00004517          	auipc	a0,0x4
    3e34:	bc850513          	addi	a0,a0,-1080 # 79f8 <malloc+0x19c8>
    3e38:	00002097          	auipc	ra,0x2
    3e3c:	13a080e7          	jalr	314(ra) # 5f72 <printf>
    exit(1);
    3e40:	4505                	li	a0,1
    3e42:	00002097          	auipc	ra,0x2
    3e46:	d90080e7          	jalr	-624(ra) # 5bd2 <exit>
    printf("%s: unlink dd failed\n", s);
    3e4a:	85ca                	mv	a1,s2
    3e4c:	00004517          	auipc	a0,0x4
    3e50:	bcc50513          	addi	a0,a0,-1076 # 7a18 <malloc+0x19e8>
    3e54:	00002097          	auipc	ra,0x2
    3e58:	11e080e7          	jalr	286(ra) # 5f72 <printf>
    exit(1);
    3e5c:	4505                	li	a0,1
    3e5e:	00002097          	auipc	ra,0x2
    3e62:	d74080e7          	jalr	-652(ra) # 5bd2 <exit>

0000000000003e66 <rmdot>:
{
    3e66:	1101                	addi	sp,sp,-32
    3e68:	ec06                	sd	ra,24(sp)
    3e6a:	e822                	sd	s0,16(sp)
    3e6c:	e426                	sd	s1,8(sp)
    3e6e:	1000                	addi	s0,sp,32
    3e70:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e72:	00004517          	auipc	a0,0x4
    3e76:	bbe50513          	addi	a0,a0,-1090 # 7a30 <malloc+0x1a00>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	dc0080e7          	jalr	-576(ra) # 5c3a <mkdir>
    3e82:	e549                	bnez	a0,3f0c <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e84:	00004517          	auipc	a0,0x4
    3e88:	bac50513          	addi	a0,a0,-1108 # 7a30 <malloc+0x1a00>
    3e8c:	00002097          	auipc	ra,0x2
    3e90:	db6080e7          	jalr	-586(ra) # 5c42 <chdir>
    3e94:	e951                	bnez	a0,3f28 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e96:	00003517          	auipc	a0,0x3
    3e9a:	9ca50513          	addi	a0,a0,-1590 # 6860 <malloc+0x830>
    3e9e:	00002097          	auipc	ra,0x2
    3ea2:	d84080e7          	jalr	-636(ra) # 5c22 <unlink>
    3ea6:	cd59                	beqz	a0,3f44 <rmdot+0xde>
  if(unlink("..") == 0){
    3ea8:	00003517          	auipc	a0,0x3
    3eac:	5e050513          	addi	a0,a0,1504 # 7488 <malloc+0x1458>
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	d72080e7          	jalr	-654(ra) # 5c22 <unlink>
    3eb8:	c545                	beqz	a0,3f60 <rmdot+0xfa>
  if(chdir("/") != 0){
    3eba:	00003517          	auipc	a0,0x3
    3ebe:	57650513          	addi	a0,a0,1398 # 7430 <malloc+0x1400>
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	d80080e7          	jalr	-640(ra) # 5c42 <chdir>
    3eca:	e94d                	bnez	a0,3f7c <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	bcc50513          	addi	a0,a0,-1076 # 7a98 <malloc+0x1a68>
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	d4e080e7          	jalr	-690(ra) # 5c22 <unlink>
    3edc:	cd55                	beqz	a0,3f98 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3ede:	00004517          	auipc	a0,0x4
    3ee2:	be250513          	addi	a0,a0,-1054 # 7ac0 <malloc+0x1a90>
    3ee6:	00002097          	auipc	ra,0x2
    3eea:	d3c080e7          	jalr	-708(ra) # 5c22 <unlink>
    3eee:	c179                	beqz	a0,3fb4 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3ef0:	00004517          	auipc	a0,0x4
    3ef4:	b4050513          	addi	a0,a0,-1216 # 7a30 <malloc+0x1a00>
    3ef8:	00002097          	auipc	ra,0x2
    3efc:	d2a080e7          	jalr	-726(ra) # 5c22 <unlink>
    3f00:	e961                	bnez	a0,3fd0 <rmdot+0x16a>
}
    3f02:	60e2                	ld	ra,24(sp)
    3f04:	6442                	ld	s0,16(sp)
    3f06:	64a2                	ld	s1,8(sp)
    3f08:	6105                	addi	sp,sp,32
    3f0a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f0c:	85a6                	mv	a1,s1
    3f0e:	00004517          	auipc	a0,0x4
    3f12:	b2a50513          	addi	a0,a0,-1238 # 7a38 <malloc+0x1a08>
    3f16:	00002097          	auipc	ra,0x2
    3f1a:	05c080e7          	jalr	92(ra) # 5f72 <printf>
    exit(1);
    3f1e:	4505                	li	a0,1
    3f20:	00002097          	auipc	ra,0x2
    3f24:	cb2080e7          	jalr	-846(ra) # 5bd2 <exit>
    printf("%s: chdir dots failed\n", s);
    3f28:	85a6                	mv	a1,s1
    3f2a:	00004517          	auipc	a0,0x4
    3f2e:	b2650513          	addi	a0,a0,-1242 # 7a50 <malloc+0x1a20>
    3f32:	00002097          	auipc	ra,0x2
    3f36:	040080e7          	jalr	64(ra) # 5f72 <printf>
    exit(1);
    3f3a:	4505                	li	a0,1
    3f3c:	00002097          	auipc	ra,0x2
    3f40:	c96080e7          	jalr	-874(ra) # 5bd2 <exit>
    printf("%s: rm . worked!\n", s);
    3f44:	85a6                	mv	a1,s1
    3f46:	00004517          	auipc	a0,0x4
    3f4a:	b2250513          	addi	a0,a0,-1246 # 7a68 <malloc+0x1a38>
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	024080e7          	jalr	36(ra) # 5f72 <printf>
    exit(1);
    3f56:	4505                	li	a0,1
    3f58:	00002097          	auipc	ra,0x2
    3f5c:	c7a080e7          	jalr	-902(ra) # 5bd2 <exit>
    printf("%s: rm .. worked!\n", s);
    3f60:	85a6                	mv	a1,s1
    3f62:	00004517          	auipc	a0,0x4
    3f66:	b1e50513          	addi	a0,a0,-1250 # 7a80 <malloc+0x1a50>
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	008080e7          	jalr	8(ra) # 5f72 <printf>
    exit(1);
    3f72:	4505                	li	a0,1
    3f74:	00002097          	auipc	ra,0x2
    3f78:	c5e080e7          	jalr	-930(ra) # 5bd2 <exit>
    printf("%s: chdir / failed\n", s);
    3f7c:	85a6                	mv	a1,s1
    3f7e:	00003517          	auipc	a0,0x3
    3f82:	4ba50513          	addi	a0,a0,1210 # 7438 <malloc+0x1408>
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	fec080e7          	jalr	-20(ra) # 5f72 <printf>
    exit(1);
    3f8e:	4505                	li	a0,1
    3f90:	00002097          	auipc	ra,0x2
    3f94:	c42080e7          	jalr	-958(ra) # 5bd2 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f98:	85a6                	mv	a1,s1
    3f9a:	00004517          	auipc	a0,0x4
    3f9e:	b0650513          	addi	a0,a0,-1274 # 7aa0 <malloc+0x1a70>
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	fd0080e7          	jalr	-48(ra) # 5f72 <printf>
    exit(1);
    3faa:	4505                	li	a0,1
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	c26080e7          	jalr	-986(ra) # 5bd2 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fb4:	85a6                	mv	a1,s1
    3fb6:	00004517          	auipc	a0,0x4
    3fba:	b1250513          	addi	a0,a0,-1262 # 7ac8 <malloc+0x1a98>
    3fbe:	00002097          	auipc	ra,0x2
    3fc2:	fb4080e7          	jalr	-76(ra) # 5f72 <printf>
    exit(1);
    3fc6:	4505                	li	a0,1
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	c0a080e7          	jalr	-1014(ra) # 5bd2 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fd0:	85a6                	mv	a1,s1
    3fd2:	00004517          	auipc	a0,0x4
    3fd6:	b1650513          	addi	a0,a0,-1258 # 7ae8 <malloc+0x1ab8>
    3fda:	00002097          	auipc	ra,0x2
    3fde:	f98080e7          	jalr	-104(ra) # 5f72 <printf>
    exit(1);
    3fe2:	4505                	li	a0,1
    3fe4:	00002097          	auipc	ra,0x2
    3fe8:	bee080e7          	jalr	-1042(ra) # 5bd2 <exit>

0000000000003fec <dirfile>:
{
    3fec:	1101                	addi	sp,sp,-32
    3fee:	ec06                	sd	ra,24(sp)
    3ff0:	e822                	sd	s0,16(sp)
    3ff2:	e426                	sd	s1,8(sp)
    3ff4:	e04a                	sd	s2,0(sp)
    3ff6:	1000                	addi	s0,sp,32
    3ff8:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3ffa:	20000593          	li	a1,512
    3ffe:	00004517          	auipc	a0,0x4
    4002:	b0a50513          	addi	a0,a0,-1270 # 7b08 <malloc+0x1ad8>
    4006:	00002097          	auipc	ra,0x2
    400a:	c0c080e7          	jalr	-1012(ra) # 5c12 <open>
  if(fd < 0){
    400e:	0e054d63          	bltz	a0,4108 <dirfile+0x11c>
  close(fd);
    4012:	00002097          	auipc	ra,0x2
    4016:	be8080e7          	jalr	-1048(ra) # 5bfa <close>
  if(chdir("dirfile") == 0){
    401a:	00004517          	auipc	a0,0x4
    401e:	aee50513          	addi	a0,a0,-1298 # 7b08 <malloc+0x1ad8>
    4022:	00002097          	auipc	ra,0x2
    4026:	c20080e7          	jalr	-992(ra) # 5c42 <chdir>
    402a:	cd6d                	beqz	a0,4124 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    402c:	4581                	li	a1,0
    402e:	00004517          	auipc	a0,0x4
    4032:	b2250513          	addi	a0,a0,-1246 # 7b50 <malloc+0x1b20>
    4036:	00002097          	auipc	ra,0x2
    403a:	bdc080e7          	jalr	-1060(ra) # 5c12 <open>
  if(fd >= 0){
    403e:	10055163          	bgez	a0,4140 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4042:	20000593          	li	a1,512
    4046:	00004517          	auipc	a0,0x4
    404a:	b0a50513          	addi	a0,a0,-1270 # 7b50 <malloc+0x1b20>
    404e:	00002097          	auipc	ra,0x2
    4052:	bc4080e7          	jalr	-1084(ra) # 5c12 <open>
  if(fd >= 0){
    4056:	10055363          	bgez	a0,415c <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    405a:	00004517          	auipc	a0,0x4
    405e:	af650513          	addi	a0,a0,-1290 # 7b50 <malloc+0x1b20>
    4062:	00002097          	auipc	ra,0x2
    4066:	bd8080e7          	jalr	-1064(ra) # 5c3a <mkdir>
    406a:	10050763          	beqz	a0,4178 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    406e:	00004517          	auipc	a0,0x4
    4072:	ae250513          	addi	a0,a0,-1310 # 7b50 <malloc+0x1b20>
    4076:	00002097          	auipc	ra,0x2
    407a:	bac080e7          	jalr	-1108(ra) # 5c22 <unlink>
    407e:	10050b63          	beqz	a0,4194 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4082:	00004597          	auipc	a1,0x4
    4086:	ace58593          	addi	a1,a1,-1330 # 7b50 <malloc+0x1b20>
    408a:	00002517          	auipc	a0,0x2
    408e:	2c650513          	addi	a0,a0,710 # 6350 <malloc+0x320>
    4092:	00002097          	auipc	ra,0x2
    4096:	ba0080e7          	jalr	-1120(ra) # 5c32 <link>
    409a:	10050b63          	beqz	a0,41b0 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    409e:	00004517          	auipc	a0,0x4
    40a2:	a6a50513          	addi	a0,a0,-1430 # 7b08 <malloc+0x1ad8>
    40a6:	00002097          	auipc	ra,0x2
    40aa:	b7c080e7          	jalr	-1156(ra) # 5c22 <unlink>
    40ae:	10051f63          	bnez	a0,41cc <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40b2:	4589                	li	a1,2
    40b4:	00002517          	auipc	a0,0x2
    40b8:	7ac50513          	addi	a0,a0,1964 # 6860 <malloc+0x830>
    40bc:	00002097          	auipc	ra,0x2
    40c0:	b56080e7          	jalr	-1194(ra) # 5c12 <open>
  if(fd >= 0){
    40c4:	12055263          	bgez	a0,41e8 <dirfile+0x1fc>
  fd = open(".", 0);
    40c8:	4581                	li	a1,0
    40ca:	00002517          	auipc	a0,0x2
    40ce:	79650513          	addi	a0,a0,1942 # 6860 <malloc+0x830>
    40d2:	00002097          	auipc	ra,0x2
    40d6:	b40080e7          	jalr	-1216(ra) # 5c12 <open>
    40da:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40dc:	4605                	li	a2,1
    40de:	00002597          	auipc	a1,0x2
    40e2:	10a58593          	addi	a1,a1,266 # 61e8 <malloc+0x1b8>
    40e6:	00002097          	auipc	ra,0x2
    40ea:	b0c080e7          	jalr	-1268(ra) # 5bf2 <write>
    40ee:	10a04b63          	bgtz	a0,4204 <dirfile+0x218>
  close(fd);
    40f2:	8526                	mv	a0,s1
    40f4:	00002097          	auipc	ra,0x2
    40f8:	b06080e7          	jalr	-1274(ra) # 5bfa <close>
}
    40fc:	60e2                	ld	ra,24(sp)
    40fe:	6442                	ld	s0,16(sp)
    4100:	64a2                	ld	s1,8(sp)
    4102:	6902                	ld	s2,0(sp)
    4104:	6105                	addi	sp,sp,32
    4106:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4108:	85ca                	mv	a1,s2
    410a:	00004517          	auipc	a0,0x4
    410e:	a0650513          	addi	a0,a0,-1530 # 7b10 <malloc+0x1ae0>
    4112:	00002097          	auipc	ra,0x2
    4116:	e60080e7          	jalr	-416(ra) # 5f72 <printf>
    exit(1);
    411a:	4505                	li	a0,1
    411c:	00002097          	auipc	ra,0x2
    4120:	ab6080e7          	jalr	-1354(ra) # 5bd2 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4124:	85ca                	mv	a1,s2
    4126:	00004517          	auipc	a0,0x4
    412a:	a0a50513          	addi	a0,a0,-1526 # 7b30 <malloc+0x1b00>
    412e:	00002097          	auipc	ra,0x2
    4132:	e44080e7          	jalr	-444(ra) # 5f72 <printf>
    exit(1);
    4136:	4505                	li	a0,1
    4138:	00002097          	auipc	ra,0x2
    413c:	a9a080e7          	jalr	-1382(ra) # 5bd2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4140:	85ca                	mv	a1,s2
    4142:	00004517          	auipc	a0,0x4
    4146:	a1e50513          	addi	a0,a0,-1506 # 7b60 <malloc+0x1b30>
    414a:	00002097          	auipc	ra,0x2
    414e:	e28080e7          	jalr	-472(ra) # 5f72 <printf>
    exit(1);
    4152:	4505                	li	a0,1
    4154:	00002097          	auipc	ra,0x2
    4158:	a7e080e7          	jalr	-1410(ra) # 5bd2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    415c:	85ca                	mv	a1,s2
    415e:	00004517          	auipc	a0,0x4
    4162:	a0250513          	addi	a0,a0,-1534 # 7b60 <malloc+0x1b30>
    4166:	00002097          	auipc	ra,0x2
    416a:	e0c080e7          	jalr	-500(ra) # 5f72 <printf>
    exit(1);
    416e:	4505                	li	a0,1
    4170:	00002097          	auipc	ra,0x2
    4174:	a62080e7          	jalr	-1438(ra) # 5bd2 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4178:	85ca                	mv	a1,s2
    417a:	00004517          	auipc	a0,0x4
    417e:	a0e50513          	addi	a0,a0,-1522 # 7b88 <malloc+0x1b58>
    4182:	00002097          	auipc	ra,0x2
    4186:	df0080e7          	jalr	-528(ra) # 5f72 <printf>
    exit(1);
    418a:	4505                	li	a0,1
    418c:	00002097          	auipc	ra,0x2
    4190:	a46080e7          	jalr	-1466(ra) # 5bd2 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4194:	85ca                	mv	a1,s2
    4196:	00004517          	auipc	a0,0x4
    419a:	a1a50513          	addi	a0,a0,-1510 # 7bb0 <malloc+0x1b80>
    419e:	00002097          	auipc	ra,0x2
    41a2:	dd4080e7          	jalr	-556(ra) # 5f72 <printf>
    exit(1);
    41a6:	4505                	li	a0,1
    41a8:	00002097          	auipc	ra,0x2
    41ac:	a2a080e7          	jalr	-1494(ra) # 5bd2 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41b0:	85ca                	mv	a1,s2
    41b2:	00004517          	auipc	a0,0x4
    41b6:	a2650513          	addi	a0,a0,-1498 # 7bd8 <malloc+0x1ba8>
    41ba:	00002097          	auipc	ra,0x2
    41be:	db8080e7          	jalr	-584(ra) # 5f72 <printf>
    exit(1);
    41c2:	4505                	li	a0,1
    41c4:	00002097          	auipc	ra,0x2
    41c8:	a0e080e7          	jalr	-1522(ra) # 5bd2 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41cc:	85ca                	mv	a1,s2
    41ce:	00004517          	auipc	a0,0x4
    41d2:	a3250513          	addi	a0,a0,-1486 # 7c00 <malloc+0x1bd0>
    41d6:	00002097          	auipc	ra,0x2
    41da:	d9c080e7          	jalr	-612(ra) # 5f72 <printf>
    exit(1);
    41de:	4505                	li	a0,1
    41e0:	00002097          	auipc	ra,0x2
    41e4:	9f2080e7          	jalr	-1550(ra) # 5bd2 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41e8:	85ca                	mv	a1,s2
    41ea:	00004517          	auipc	a0,0x4
    41ee:	a3650513          	addi	a0,a0,-1482 # 7c20 <malloc+0x1bf0>
    41f2:	00002097          	auipc	ra,0x2
    41f6:	d80080e7          	jalr	-640(ra) # 5f72 <printf>
    exit(1);
    41fa:	4505                	li	a0,1
    41fc:	00002097          	auipc	ra,0x2
    4200:	9d6080e7          	jalr	-1578(ra) # 5bd2 <exit>
    printf("%s: write . succeeded!\n", s);
    4204:	85ca                	mv	a1,s2
    4206:	00004517          	auipc	a0,0x4
    420a:	a4250513          	addi	a0,a0,-1470 # 7c48 <malloc+0x1c18>
    420e:	00002097          	auipc	ra,0x2
    4212:	d64080e7          	jalr	-668(ra) # 5f72 <printf>
    exit(1);
    4216:	4505                	li	a0,1
    4218:	00002097          	auipc	ra,0x2
    421c:	9ba080e7          	jalr	-1606(ra) # 5bd2 <exit>

0000000000004220 <iref>:
{
    4220:	7139                	addi	sp,sp,-64
    4222:	fc06                	sd	ra,56(sp)
    4224:	f822                	sd	s0,48(sp)
    4226:	f426                	sd	s1,40(sp)
    4228:	f04a                	sd	s2,32(sp)
    422a:	ec4e                	sd	s3,24(sp)
    422c:	e852                	sd	s4,16(sp)
    422e:	e456                	sd	s5,8(sp)
    4230:	e05a                	sd	s6,0(sp)
    4232:	0080                	addi	s0,sp,64
    4234:	8b2a                	mv	s6,a0
    4236:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    423a:	00004a17          	auipc	s4,0x4
    423e:	a26a0a13          	addi	s4,s4,-1498 # 7c60 <malloc+0x1c30>
    mkdir("");
    4242:	00003497          	auipc	s1,0x3
    4246:	52648493          	addi	s1,s1,1318 # 7768 <malloc+0x1738>
    link("README", "");
    424a:	00002a97          	auipc	s5,0x2
    424e:	106a8a93          	addi	s5,s5,262 # 6350 <malloc+0x320>
    fd = open("xx", O_CREATE);
    4252:	00004997          	auipc	s3,0x4
    4256:	90698993          	addi	s3,s3,-1786 # 7b58 <malloc+0x1b28>
    425a:	a891                	j	42ae <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    425c:	85da                	mv	a1,s6
    425e:	00004517          	auipc	a0,0x4
    4262:	a0a50513          	addi	a0,a0,-1526 # 7c68 <malloc+0x1c38>
    4266:	00002097          	auipc	ra,0x2
    426a:	d0c080e7          	jalr	-756(ra) # 5f72 <printf>
      exit(1);
    426e:	4505                	li	a0,1
    4270:	00002097          	auipc	ra,0x2
    4274:	962080e7          	jalr	-1694(ra) # 5bd2 <exit>
      printf("%s: chdir irefd failed\n", s);
    4278:	85da                	mv	a1,s6
    427a:	00004517          	auipc	a0,0x4
    427e:	a0650513          	addi	a0,a0,-1530 # 7c80 <malloc+0x1c50>
    4282:	00002097          	auipc	ra,0x2
    4286:	cf0080e7          	jalr	-784(ra) # 5f72 <printf>
      exit(1);
    428a:	4505                	li	a0,1
    428c:	00002097          	auipc	ra,0x2
    4290:	946080e7          	jalr	-1722(ra) # 5bd2 <exit>
      close(fd);
    4294:	00002097          	auipc	ra,0x2
    4298:	966080e7          	jalr	-1690(ra) # 5bfa <close>
    429c:	a889                	j	42ee <iref+0xce>
    unlink("xx");
    429e:	854e                	mv	a0,s3
    42a0:	00002097          	auipc	ra,0x2
    42a4:	982080e7          	jalr	-1662(ra) # 5c22 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42a8:	397d                	addiw	s2,s2,-1
    42aa:	06090063          	beqz	s2,430a <iref+0xea>
    if(mkdir("irefd") != 0){
    42ae:	8552                	mv	a0,s4
    42b0:	00002097          	auipc	ra,0x2
    42b4:	98a080e7          	jalr	-1654(ra) # 5c3a <mkdir>
    42b8:	f155                	bnez	a0,425c <iref+0x3c>
    if(chdir("irefd") != 0){
    42ba:	8552                	mv	a0,s4
    42bc:	00002097          	auipc	ra,0x2
    42c0:	986080e7          	jalr	-1658(ra) # 5c42 <chdir>
    42c4:	f955                	bnez	a0,4278 <iref+0x58>
    mkdir("");
    42c6:	8526                	mv	a0,s1
    42c8:	00002097          	auipc	ra,0x2
    42cc:	972080e7          	jalr	-1678(ra) # 5c3a <mkdir>
    link("README", "");
    42d0:	85a6                	mv	a1,s1
    42d2:	8556                	mv	a0,s5
    42d4:	00002097          	auipc	ra,0x2
    42d8:	95e080e7          	jalr	-1698(ra) # 5c32 <link>
    fd = open("", O_CREATE);
    42dc:	20000593          	li	a1,512
    42e0:	8526                	mv	a0,s1
    42e2:	00002097          	auipc	ra,0x2
    42e6:	930080e7          	jalr	-1744(ra) # 5c12 <open>
    if(fd >= 0)
    42ea:	fa0555e3          	bgez	a0,4294 <iref+0x74>
    fd = open("xx", O_CREATE);
    42ee:	20000593          	li	a1,512
    42f2:	854e                	mv	a0,s3
    42f4:	00002097          	auipc	ra,0x2
    42f8:	91e080e7          	jalr	-1762(ra) # 5c12 <open>
    if(fd >= 0)
    42fc:	fa0541e3          	bltz	a0,429e <iref+0x7e>
      close(fd);
    4300:	00002097          	auipc	ra,0x2
    4304:	8fa080e7          	jalr	-1798(ra) # 5bfa <close>
    4308:	bf59                	j	429e <iref+0x7e>
    430a:	03300493          	li	s1,51
    chdir("..");
    430e:	00003997          	auipc	s3,0x3
    4312:	17a98993          	addi	s3,s3,378 # 7488 <malloc+0x1458>
    unlink("irefd");
    4316:	00004917          	auipc	s2,0x4
    431a:	94a90913          	addi	s2,s2,-1718 # 7c60 <malloc+0x1c30>
    chdir("..");
    431e:	854e                	mv	a0,s3
    4320:	00002097          	auipc	ra,0x2
    4324:	922080e7          	jalr	-1758(ra) # 5c42 <chdir>
    unlink("irefd");
    4328:	854a                	mv	a0,s2
    432a:	00002097          	auipc	ra,0x2
    432e:	8f8080e7          	jalr	-1800(ra) # 5c22 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4332:	34fd                	addiw	s1,s1,-1
    4334:	f4ed                	bnez	s1,431e <iref+0xfe>
  chdir("/");
    4336:	00003517          	auipc	a0,0x3
    433a:	0fa50513          	addi	a0,a0,250 # 7430 <malloc+0x1400>
    433e:	00002097          	auipc	ra,0x2
    4342:	904080e7          	jalr	-1788(ra) # 5c42 <chdir>
}
    4346:	70e2                	ld	ra,56(sp)
    4348:	7442                	ld	s0,48(sp)
    434a:	74a2                	ld	s1,40(sp)
    434c:	7902                	ld	s2,32(sp)
    434e:	69e2                	ld	s3,24(sp)
    4350:	6a42                	ld	s4,16(sp)
    4352:	6aa2                	ld	s5,8(sp)
    4354:	6b02                	ld	s6,0(sp)
    4356:	6121                	addi	sp,sp,64
    4358:	8082                	ret

000000000000435a <openiputtest>:
{
    435a:	7179                	addi	sp,sp,-48
    435c:	f406                	sd	ra,40(sp)
    435e:	f022                	sd	s0,32(sp)
    4360:	ec26                	sd	s1,24(sp)
    4362:	1800                	addi	s0,sp,48
    4364:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4366:	00004517          	auipc	a0,0x4
    436a:	93250513          	addi	a0,a0,-1742 # 7c98 <malloc+0x1c68>
    436e:	00002097          	auipc	ra,0x2
    4372:	8cc080e7          	jalr	-1844(ra) # 5c3a <mkdir>
    4376:	04054263          	bltz	a0,43ba <openiputtest+0x60>
  pid = fork();
    437a:	00002097          	auipc	ra,0x2
    437e:	850080e7          	jalr	-1968(ra) # 5bca <fork>
  if(pid < 0){
    4382:	04054a63          	bltz	a0,43d6 <openiputtest+0x7c>
  if(pid == 0){
    4386:	e93d                	bnez	a0,43fc <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4388:	4589                	li	a1,2
    438a:	00004517          	auipc	a0,0x4
    438e:	90e50513          	addi	a0,a0,-1778 # 7c98 <malloc+0x1c68>
    4392:	00002097          	auipc	ra,0x2
    4396:	880080e7          	jalr	-1920(ra) # 5c12 <open>
    if(fd >= 0){
    439a:	04054c63          	bltz	a0,43f2 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    439e:	85a6                	mv	a1,s1
    43a0:	00004517          	auipc	a0,0x4
    43a4:	91850513          	addi	a0,a0,-1768 # 7cb8 <malloc+0x1c88>
    43a8:	00002097          	auipc	ra,0x2
    43ac:	bca080e7          	jalr	-1078(ra) # 5f72 <printf>
      exit(1);
    43b0:	4505                	li	a0,1
    43b2:	00002097          	auipc	ra,0x2
    43b6:	820080e7          	jalr	-2016(ra) # 5bd2 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43ba:	85a6                	mv	a1,s1
    43bc:	00004517          	auipc	a0,0x4
    43c0:	8e450513          	addi	a0,a0,-1820 # 7ca0 <malloc+0x1c70>
    43c4:	00002097          	auipc	ra,0x2
    43c8:	bae080e7          	jalr	-1106(ra) # 5f72 <printf>
    exit(1);
    43cc:	4505                	li	a0,1
    43ce:	00002097          	auipc	ra,0x2
    43d2:	804080e7          	jalr	-2044(ra) # 5bd2 <exit>
    printf("%s: fork failed\n", s);
    43d6:	85a6                	mv	a1,s1
    43d8:	00002517          	auipc	a0,0x2
    43dc:	62850513          	addi	a0,a0,1576 # 6a00 <malloc+0x9d0>
    43e0:	00002097          	auipc	ra,0x2
    43e4:	b92080e7          	jalr	-1134(ra) # 5f72 <printf>
    exit(1);
    43e8:	4505                	li	a0,1
    43ea:	00001097          	auipc	ra,0x1
    43ee:	7e8080e7          	jalr	2024(ra) # 5bd2 <exit>
    exit(0);
    43f2:	4501                	li	a0,0
    43f4:	00001097          	auipc	ra,0x1
    43f8:	7de080e7          	jalr	2014(ra) # 5bd2 <exit>
  sleep(1);
    43fc:	4505                	li	a0,1
    43fe:	00002097          	auipc	ra,0x2
    4402:	864080e7          	jalr	-1948(ra) # 5c62 <sleep>
  if(unlink("oidir") != 0){
    4406:	00004517          	auipc	a0,0x4
    440a:	89250513          	addi	a0,a0,-1902 # 7c98 <malloc+0x1c68>
    440e:	00002097          	auipc	ra,0x2
    4412:	814080e7          	jalr	-2028(ra) # 5c22 <unlink>
    4416:	cd19                	beqz	a0,4434 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4418:	85a6                	mv	a1,s1
    441a:	00002517          	auipc	a0,0x2
    441e:	7d650513          	addi	a0,a0,2006 # 6bf0 <malloc+0xbc0>
    4422:	00002097          	auipc	ra,0x2
    4426:	b50080e7          	jalr	-1200(ra) # 5f72 <printf>
    exit(1);
    442a:	4505                	li	a0,1
    442c:	00001097          	auipc	ra,0x1
    4430:	7a6080e7          	jalr	1958(ra) # 5bd2 <exit>
  wait(&xstatus);
    4434:	fdc40513          	addi	a0,s0,-36
    4438:	00001097          	auipc	ra,0x1
    443c:	7a2080e7          	jalr	1954(ra) # 5bda <wait>
  exit(xstatus);
    4440:	fdc42503          	lw	a0,-36(s0)
    4444:	00001097          	auipc	ra,0x1
    4448:	78e080e7          	jalr	1934(ra) # 5bd2 <exit>

000000000000444c <forkforkfork>:
{
    444c:	1101                	addi	sp,sp,-32
    444e:	ec06                	sd	ra,24(sp)
    4450:	e822                	sd	s0,16(sp)
    4452:	e426                	sd	s1,8(sp)
    4454:	1000                	addi	s0,sp,32
    4456:	84aa                	mv	s1,a0
  unlink("stopforking");
    4458:	00004517          	auipc	a0,0x4
    445c:	88850513          	addi	a0,a0,-1912 # 7ce0 <malloc+0x1cb0>
    4460:	00001097          	auipc	ra,0x1
    4464:	7c2080e7          	jalr	1986(ra) # 5c22 <unlink>
  int pid = fork();
    4468:	00001097          	auipc	ra,0x1
    446c:	762080e7          	jalr	1890(ra) # 5bca <fork>
  if(pid < 0){
    4470:	04054563          	bltz	a0,44ba <forkforkfork+0x6e>
  if(pid == 0){
    4474:	c12d                	beqz	a0,44d6 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4476:	4551                	li	a0,20
    4478:	00001097          	auipc	ra,0x1
    447c:	7ea080e7          	jalr	2026(ra) # 5c62 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4480:	20200593          	li	a1,514
    4484:	00004517          	auipc	a0,0x4
    4488:	85c50513          	addi	a0,a0,-1956 # 7ce0 <malloc+0x1cb0>
    448c:	00001097          	auipc	ra,0x1
    4490:	786080e7          	jalr	1926(ra) # 5c12 <open>
    4494:	00001097          	auipc	ra,0x1
    4498:	766080e7          	jalr	1894(ra) # 5bfa <close>
  wait(0);
    449c:	4501                	li	a0,0
    449e:	00001097          	auipc	ra,0x1
    44a2:	73c080e7          	jalr	1852(ra) # 5bda <wait>
  sleep(10); // one second
    44a6:	4529                	li	a0,10
    44a8:	00001097          	auipc	ra,0x1
    44ac:	7ba080e7          	jalr	1978(ra) # 5c62 <sleep>
}
    44b0:	60e2                	ld	ra,24(sp)
    44b2:	6442                	ld	s0,16(sp)
    44b4:	64a2                	ld	s1,8(sp)
    44b6:	6105                	addi	sp,sp,32
    44b8:	8082                	ret
    printf("%s: fork failed", s);
    44ba:	85a6                	mv	a1,s1
    44bc:	00002517          	auipc	a0,0x2
    44c0:	70450513          	addi	a0,a0,1796 # 6bc0 <malloc+0xb90>
    44c4:	00002097          	auipc	ra,0x2
    44c8:	aae080e7          	jalr	-1362(ra) # 5f72 <printf>
    exit(1);
    44cc:	4505                	li	a0,1
    44ce:	00001097          	auipc	ra,0x1
    44d2:	704080e7          	jalr	1796(ra) # 5bd2 <exit>
      int fd = open("stopforking", 0);
    44d6:	00004497          	auipc	s1,0x4
    44da:	80a48493          	addi	s1,s1,-2038 # 7ce0 <malloc+0x1cb0>
    44de:	4581                	li	a1,0
    44e0:	8526                	mv	a0,s1
    44e2:	00001097          	auipc	ra,0x1
    44e6:	730080e7          	jalr	1840(ra) # 5c12 <open>
      if(fd >= 0){
    44ea:	02055463          	bgez	a0,4512 <forkforkfork+0xc6>
      if(fork() < 0){
    44ee:	00001097          	auipc	ra,0x1
    44f2:	6dc080e7          	jalr	1756(ra) # 5bca <fork>
    44f6:	fe0554e3          	bgez	a0,44de <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44fa:	20200593          	li	a1,514
    44fe:	8526                	mv	a0,s1
    4500:	00001097          	auipc	ra,0x1
    4504:	712080e7          	jalr	1810(ra) # 5c12 <open>
    4508:	00001097          	auipc	ra,0x1
    450c:	6f2080e7          	jalr	1778(ra) # 5bfa <close>
    4510:	b7f9                	j	44de <forkforkfork+0x92>
        exit(0);
    4512:	4501                	li	a0,0
    4514:	00001097          	auipc	ra,0x1
    4518:	6be080e7          	jalr	1726(ra) # 5bd2 <exit>

000000000000451c <killstatus>:
{
    451c:	7139                	addi	sp,sp,-64
    451e:	fc06                	sd	ra,56(sp)
    4520:	f822                	sd	s0,48(sp)
    4522:	f426                	sd	s1,40(sp)
    4524:	f04a                	sd	s2,32(sp)
    4526:	ec4e                	sd	s3,24(sp)
    4528:	e852                	sd	s4,16(sp)
    452a:	0080                	addi	s0,sp,64
    452c:	8a2a                	mv	s4,a0
    452e:	06400913          	li	s2,100
    if(xst != -1) {
    4532:	59fd                	li	s3,-1
    int pid1 = fork();
    4534:	00001097          	auipc	ra,0x1
    4538:	696080e7          	jalr	1686(ra) # 5bca <fork>
    453c:	84aa                	mv	s1,a0
    if(pid1 < 0){
    453e:	02054f63          	bltz	a0,457c <killstatus+0x60>
    if(pid1 == 0){
    4542:	c939                	beqz	a0,4598 <killstatus+0x7c>
    sleep(1);
    4544:	4505                	li	a0,1
    4546:	00001097          	auipc	ra,0x1
    454a:	71c080e7          	jalr	1820(ra) # 5c62 <sleep>
    kill(pid1);
    454e:	8526                	mv	a0,s1
    4550:	00001097          	auipc	ra,0x1
    4554:	6b2080e7          	jalr	1714(ra) # 5c02 <kill>
    wait(&xst);
    4558:	fcc40513          	addi	a0,s0,-52
    455c:	00001097          	auipc	ra,0x1
    4560:	67e080e7          	jalr	1662(ra) # 5bda <wait>
    if(xst != -1) {
    4564:	fcc42783          	lw	a5,-52(s0)
    4568:	03379d63          	bne	a5,s3,45a2 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    456c:	397d                	addiw	s2,s2,-1
    456e:	fc0913e3          	bnez	s2,4534 <killstatus+0x18>
  exit(0);
    4572:	4501                	li	a0,0
    4574:	00001097          	auipc	ra,0x1
    4578:	65e080e7          	jalr	1630(ra) # 5bd2 <exit>
      printf("%s: fork failed\n", s);
    457c:	85d2                	mv	a1,s4
    457e:	00002517          	auipc	a0,0x2
    4582:	48250513          	addi	a0,a0,1154 # 6a00 <malloc+0x9d0>
    4586:	00002097          	auipc	ra,0x2
    458a:	9ec080e7          	jalr	-1556(ra) # 5f72 <printf>
      exit(1);
    458e:	4505                	li	a0,1
    4590:	00001097          	auipc	ra,0x1
    4594:	642080e7          	jalr	1602(ra) # 5bd2 <exit>
        getpid();
    4598:	00001097          	auipc	ra,0x1
    459c:	6ba080e7          	jalr	1722(ra) # 5c52 <getpid>
      while(1) {
    45a0:	bfe5                	j	4598 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45a2:	85d2                	mv	a1,s4
    45a4:	00003517          	auipc	a0,0x3
    45a8:	74c50513          	addi	a0,a0,1868 # 7cf0 <malloc+0x1cc0>
    45ac:	00002097          	auipc	ra,0x2
    45b0:	9c6080e7          	jalr	-1594(ra) # 5f72 <printf>
       exit(1);
    45b4:	4505                	li	a0,1
    45b6:	00001097          	auipc	ra,0x1
    45ba:	61c080e7          	jalr	1564(ra) # 5bd2 <exit>

00000000000045be <preempt>:
{
    45be:	7139                	addi	sp,sp,-64
    45c0:	fc06                	sd	ra,56(sp)
    45c2:	f822                	sd	s0,48(sp)
    45c4:	f426                	sd	s1,40(sp)
    45c6:	f04a                	sd	s2,32(sp)
    45c8:	ec4e                	sd	s3,24(sp)
    45ca:	e852                	sd	s4,16(sp)
    45cc:	0080                	addi	s0,sp,64
    45ce:	84aa                	mv	s1,a0
  pid1 = fork();
    45d0:	00001097          	auipc	ra,0x1
    45d4:	5fa080e7          	jalr	1530(ra) # 5bca <fork>
  if(pid1 < 0) {
    45d8:	00054563          	bltz	a0,45e2 <preempt+0x24>
    45dc:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    45de:	e105                	bnez	a0,45fe <preempt+0x40>
    for(;;)
    45e0:	a001                	j	45e0 <preempt+0x22>
    printf("%s: fork failed", s);
    45e2:	85a6                	mv	a1,s1
    45e4:	00002517          	auipc	a0,0x2
    45e8:	5dc50513          	addi	a0,a0,1500 # 6bc0 <malloc+0xb90>
    45ec:	00002097          	auipc	ra,0x2
    45f0:	986080e7          	jalr	-1658(ra) # 5f72 <printf>
    exit(1);
    45f4:	4505                	li	a0,1
    45f6:	00001097          	auipc	ra,0x1
    45fa:	5dc080e7          	jalr	1500(ra) # 5bd2 <exit>
  pid2 = fork();
    45fe:	00001097          	auipc	ra,0x1
    4602:	5cc080e7          	jalr	1484(ra) # 5bca <fork>
    4606:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4608:	00054463          	bltz	a0,4610 <preempt+0x52>
  if(pid2 == 0)
    460c:	e105                	bnez	a0,462c <preempt+0x6e>
    for(;;)
    460e:	a001                	j	460e <preempt+0x50>
    printf("%s: fork failed\n", s);
    4610:	85a6                	mv	a1,s1
    4612:	00002517          	auipc	a0,0x2
    4616:	3ee50513          	addi	a0,a0,1006 # 6a00 <malloc+0x9d0>
    461a:	00002097          	auipc	ra,0x2
    461e:	958080e7          	jalr	-1704(ra) # 5f72 <printf>
    exit(1);
    4622:	4505                	li	a0,1
    4624:	00001097          	auipc	ra,0x1
    4628:	5ae080e7          	jalr	1454(ra) # 5bd2 <exit>
  pipe(pfds);
    462c:	fc840513          	addi	a0,s0,-56
    4630:	00001097          	auipc	ra,0x1
    4634:	5b2080e7          	jalr	1458(ra) # 5be2 <pipe>
  pid3 = fork();
    4638:	00001097          	auipc	ra,0x1
    463c:	592080e7          	jalr	1426(ra) # 5bca <fork>
    4640:	892a                	mv	s2,a0
  if(pid3 < 0) {
    4642:	02054e63          	bltz	a0,467e <preempt+0xc0>
  if(pid3 == 0){
    4646:	e525                	bnez	a0,46ae <preempt+0xf0>
    close(pfds[0]);
    4648:	fc842503          	lw	a0,-56(s0)
    464c:	00001097          	auipc	ra,0x1
    4650:	5ae080e7          	jalr	1454(ra) # 5bfa <close>
    if(write(pfds[1], "x", 1) != 1)
    4654:	4605                	li	a2,1
    4656:	00002597          	auipc	a1,0x2
    465a:	b9258593          	addi	a1,a1,-1134 # 61e8 <malloc+0x1b8>
    465e:	fcc42503          	lw	a0,-52(s0)
    4662:	00001097          	auipc	ra,0x1
    4666:	590080e7          	jalr	1424(ra) # 5bf2 <write>
    466a:	4785                	li	a5,1
    466c:	02f51763          	bne	a0,a5,469a <preempt+0xdc>
    close(pfds[1]);
    4670:	fcc42503          	lw	a0,-52(s0)
    4674:	00001097          	auipc	ra,0x1
    4678:	586080e7          	jalr	1414(ra) # 5bfa <close>
    for(;;)
    467c:	a001                	j	467c <preempt+0xbe>
     printf("%s: fork failed\n", s);
    467e:	85a6                	mv	a1,s1
    4680:	00002517          	auipc	a0,0x2
    4684:	38050513          	addi	a0,a0,896 # 6a00 <malloc+0x9d0>
    4688:	00002097          	auipc	ra,0x2
    468c:	8ea080e7          	jalr	-1814(ra) # 5f72 <printf>
     exit(1);
    4690:	4505                	li	a0,1
    4692:	00001097          	auipc	ra,0x1
    4696:	540080e7          	jalr	1344(ra) # 5bd2 <exit>
      printf("%s: preempt write error", s);
    469a:	85a6                	mv	a1,s1
    469c:	00003517          	auipc	a0,0x3
    46a0:	67450513          	addi	a0,a0,1652 # 7d10 <malloc+0x1ce0>
    46a4:	00002097          	auipc	ra,0x2
    46a8:	8ce080e7          	jalr	-1842(ra) # 5f72 <printf>
    46ac:	b7d1                	j	4670 <preempt+0xb2>
  close(pfds[1]);
    46ae:	fcc42503          	lw	a0,-52(s0)
    46b2:	00001097          	auipc	ra,0x1
    46b6:	548080e7          	jalr	1352(ra) # 5bfa <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46ba:	660d                	lui	a2,0x3
    46bc:	00008597          	auipc	a1,0x8
    46c0:	5bc58593          	addi	a1,a1,1468 # cc78 <buf>
    46c4:	fc842503          	lw	a0,-56(s0)
    46c8:	00001097          	auipc	ra,0x1
    46cc:	522080e7          	jalr	1314(ra) # 5bea <read>
    46d0:	4785                	li	a5,1
    46d2:	02f50363          	beq	a0,a5,46f8 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46d6:	85a6                	mv	a1,s1
    46d8:	00003517          	auipc	a0,0x3
    46dc:	65050513          	addi	a0,a0,1616 # 7d28 <malloc+0x1cf8>
    46e0:	00002097          	auipc	ra,0x2
    46e4:	892080e7          	jalr	-1902(ra) # 5f72 <printf>
}
    46e8:	70e2                	ld	ra,56(sp)
    46ea:	7442                	ld	s0,48(sp)
    46ec:	74a2                	ld	s1,40(sp)
    46ee:	7902                	ld	s2,32(sp)
    46f0:	69e2                	ld	s3,24(sp)
    46f2:	6a42                	ld	s4,16(sp)
    46f4:	6121                	addi	sp,sp,64
    46f6:	8082                	ret
  close(pfds[0]);
    46f8:	fc842503          	lw	a0,-56(s0)
    46fc:	00001097          	auipc	ra,0x1
    4700:	4fe080e7          	jalr	1278(ra) # 5bfa <close>
  printf("kill... ");
    4704:	00003517          	auipc	a0,0x3
    4708:	63c50513          	addi	a0,a0,1596 # 7d40 <malloc+0x1d10>
    470c:	00002097          	auipc	ra,0x2
    4710:	866080e7          	jalr	-1946(ra) # 5f72 <printf>
  kill(pid1);
    4714:	8552                	mv	a0,s4
    4716:	00001097          	auipc	ra,0x1
    471a:	4ec080e7          	jalr	1260(ra) # 5c02 <kill>
  kill(pid2);
    471e:	854e                	mv	a0,s3
    4720:	00001097          	auipc	ra,0x1
    4724:	4e2080e7          	jalr	1250(ra) # 5c02 <kill>
  kill(pid3);
    4728:	854a                	mv	a0,s2
    472a:	00001097          	auipc	ra,0x1
    472e:	4d8080e7          	jalr	1240(ra) # 5c02 <kill>
  printf("wait... ");
    4732:	00003517          	auipc	a0,0x3
    4736:	61e50513          	addi	a0,a0,1566 # 7d50 <malloc+0x1d20>
    473a:	00002097          	auipc	ra,0x2
    473e:	838080e7          	jalr	-1992(ra) # 5f72 <printf>
  wait(0);
    4742:	4501                	li	a0,0
    4744:	00001097          	auipc	ra,0x1
    4748:	496080e7          	jalr	1174(ra) # 5bda <wait>
  wait(0);
    474c:	4501                	li	a0,0
    474e:	00001097          	auipc	ra,0x1
    4752:	48c080e7          	jalr	1164(ra) # 5bda <wait>
  wait(0);
    4756:	4501                	li	a0,0
    4758:	00001097          	auipc	ra,0x1
    475c:	482080e7          	jalr	1154(ra) # 5bda <wait>
    4760:	b761                	j	46e8 <preempt+0x12a>

0000000000004762 <reparent>:
{
    4762:	7179                	addi	sp,sp,-48
    4764:	f406                	sd	ra,40(sp)
    4766:	f022                	sd	s0,32(sp)
    4768:	ec26                	sd	s1,24(sp)
    476a:	e84a                	sd	s2,16(sp)
    476c:	e44e                	sd	s3,8(sp)
    476e:	e052                	sd	s4,0(sp)
    4770:	1800                	addi	s0,sp,48
    4772:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4774:	00001097          	auipc	ra,0x1
    4778:	4de080e7          	jalr	1246(ra) # 5c52 <getpid>
    477c:	8a2a                	mv	s4,a0
    477e:	0c800913          	li	s2,200
    int pid = fork();
    4782:	00001097          	auipc	ra,0x1
    4786:	448080e7          	jalr	1096(ra) # 5bca <fork>
    478a:	84aa                	mv	s1,a0
    if(pid < 0){
    478c:	02054263          	bltz	a0,47b0 <reparent+0x4e>
    if(pid){
    4790:	cd21                	beqz	a0,47e8 <reparent+0x86>
      if(wait(0) != pid){
    4792:	4501                	li	a0,0
    4794:	00001097          	auipc	ra,0x1
    4798:	446080e7          	jalr	1094(ra) # 5bda <wait>
    479c:	02951863          	bne	a0,s1,47cc <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47a0:	397d                	addiw	s2,s2,-1
    47a2:	fe0910e3          	bnez	s2,4782 <reparent+0x20>
  exit(0);
    47a6:	4501                	li	a0,0
    47a8:	00001097          	auipc	ra,0x1
    47ac:	42a080e7          	jalr	1066(ra) # 5bd2 <exit>
      printf("%s: fork failed\n", s);
    47b0:	85ce                	mv	a1,s3
    47b2:	00002517          	auipc	a0,0x2
    47b6:	24e50513          	addi	a0,a0,590 # 6a00 <malloc+0x9d0>
    47ba:	00001097          	auipc	ra,0x1
    47be:	7b8080e7          	jalr	1976(ra) # 5f72 <printf>
      exit(1);
    47c2:	4505                	li	a0,1
    47c4:	00001097          	auipc	ra,0x1
    47c8:	40e080e7          	jalr	1038(ra) # 5bd2 <exit>
        printf("%s: wait wrong pid\n", s);
    47cc:	85ce                	mv	a1,s3
    47ce:	00002517          	auipc	a0,0x2
    47d2:	3ba50513          	addi	a0,a0,954 # 6b88 <malloc+0xb58>
    47d6:	00001097          	auipc	ra,0x1
    47da:	79c080e7          	jalr	1948(ra) # 5f72 <printf>
        exit(1);
    47de:	4505                	li	a0,1
    47e0:	00001097          	auipc	ra,0x1
    47e4:	3f2080e7          	jalr	1010(ra) # 5bd2 <exit>
      int pid2 = fork();
    47e8:	00001097          	auipc	ra,0x1
    47ec:	3e2080e7          	jalr	994(ra) # 5bca <fork>
      if(pid2 < 0){
    47f0:	00054763          	bltz	a0,47fe <reparent+0x9c>
      exit(0);
    47f4:	4501                	li	a0,0
    47f6:	00001097          	auipc	ra,0x1
    47fa:	3dc080e7          	jalr	988(ra) # 5bd2 <exit>
        kill(master_pid);
    47fe:	8552                	mv	a0,s4
    4800:	00001097          	auipc	ra,0x1
    4804:	402080e7          	jalr	1026(ra) # 5c02 <kill>
        exit(1);
    4808:	4505                	li	a0,1
    480a:	00001097          	auipc	ra,0x1
    480e:	3c8080e7          	jalr	968(ra) # 5bd2 <exit>

0000000000004812 <sbrkfail>:
{
    4812:	7119                	addi	sp,sp,-128
    4814:	fc86                	sd	ra,120(sp)
    4816:	f8a2                	sd	s0,112(sp)
    4818:	f4a6                	sd	s1,104(sp)
    481a:	f0ca                	sd	s2,96(sp)
    481c:	ecce                	sd	s3,88(sp)
    481e:	e8d2                	sd	s4,80(sp)
    4820:	e4d6                	sd	s5,72(sp)
    4822:	0100                	addi	s0,sp,128
    4824:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    4826:	fb040513          	addi	a0,s0,-80
    482a:	00001097          	auipc	ra,0x1
    482e:	3b8080e7          	jalr	952(ra) # 5be2 <pipe>
    4832:	e901                	bnez	a0,4842 <sbrkfail+0x30>
    4834:	f8040493          	addi	s1,s0,-128
    4838:	fa840a13          	addi	s4,s0,-88
    483c:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    483e:	5afd                	li	s5,-1
    4840:	a08d                	j	48a2 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    4842:	85ca                	mv	a1,s2
    4844:	00002517          	auipc	a0,0x2
    4848:	2c450513          	addi	a0,a0,708 # 6b08 <malloc+0xad8>
    484c:	00001097          	auipc	ra,0x1
    4850:	726080e7          	jalr	1830(ra) # 5f72 <printf>
    exit(1);
    4854:	4505                	li	a0,1
    4856:	00001097          	auipc	ra,0x1
    485a:	37c080e7          	jalr	892(ra) # 5bd2 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    485e:	4501                	li	a0,0
    4860:	00001097          	auipc	ra,0x1
    4864:	3fa080e7          	jalr	1018(ra) # 5c5a <sbrk>
    4868:	064007b7          	lui	a5,0x6400
    486c:	40a7853b          	subw	a0,a5,a0
    4870:	00001097          	auipc	ra,0x1
    4874:	3ea080e7          	jalr	1002(ra) # 5c5a <sbrk>
      write(fds[1], "x", 1);
    4878:	4605                	li	a2,1
    487a:	00002597          	auipc	a1,0x2
    487e:	96e58593          	addi	a1,a1,-1682 # 61e8 <malloc+0x1b8>
    4882:	fb442503          	lw	a0,-76(s0)
    4886:	00001097          	auipc	ra,0x1
    488a:	36c080e7          	jalr	876(ra) # 5bf2 <write>
      for(;;) sleep(1000);
    488e:	3e800513          	li	a0,1000
    4892:	00001097          	auipc	ra,0x1
    4896:	3d0080e7          	jalr	976(ra) # 5c62 <sleep>
    489a:	bfd5                	j	488e <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    489c:	0991                	addi	s3,s3,4
    489e:	03498563          	beq	s3,s4,48c8 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    48a2:	00001097          	auipc	ra,0x1
    48a6:	328080e7          	jalr	808(ra) # 5bca <fork>
    48aa:	00a9a023          	sw	a0,0(s3)
    48ae:	d945                	beqz	a0,485e <sbrkfail+0x4c>
    if(pids[i] != -1)
    48b0:	ff5506e3          	beq	a0,s5,489c <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    48b4:	4605                	li	a2,1
    48b6:	faf40593          	addi	a1,s0,-81
    48ba:	fb042503          	lw	a0,-80(s0)
    48be:	00001097          	auipc	ra,0x1
    48c2:	32c080e7          	jalr	812(ra) # 5bea <read>
    48c6:	bfd9                	j	489c <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    48c8:	6505                	lui	a0,0x1
    48ca:	00001097          	auipc	ra,0x1
    48ce:	390080e7          	jalr	912(ra) # 5c5a <sbrk>
    48d2:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    48d4:	5afd                	li	s5,-1
    48d6:	a021                	j	48de <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48d8:	0491                	addi	s1,s1,4
    48da:	01448f63          	beq	s1,s4,48f8 <sbrkfail+0xe6>
    if(pids[i] == -1)
    48de:	4088                	lw	a0,0(s1)
    48e0:	ff550ce3          	beq	a0,s5,48d8 <sbrkfail+0xc6>
    kill(pids[i]);
    48e4:	00001097          	auipc	ra,0x1
    48e8:	31e080e7          	jalr	798(ra) # 5c02 <kill>
    wait(0);
    48ec:	4501                	li	a0,0
    48ee:	00001097          	auipc	ra,0x1
    48f2:	2ec080e7          	jalr	748(ra) # 5bda <wait>
    48f6:	b7cd                	j	48d8 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    48f8:	57fd                	li	a5,-1
    48fa:	04f98163          	beq	s3,a5,493c <sbrkfail+0x12a>
  pid = fork();
    48fe:	00001097          	auipc	ra,0x1
    4902:	2cc080e7          	jalr	716(ra) # 5bca <fork>
    4906:	84aa                	mv	s1,a0
  if(pid < 0){
    4908:	04054863          	bltz	a0,4958 <sbrkfail+0x146>
  if(pid == 0){
    490c:	c525                	beqz	a0,4974 <sbrkfail+0x162>
  wait(&xstatus);
    490e:	fbc40513          	addi	a0,s0,-68
    4912:	00001097          	auipc	ra,0x1
    4916:	2c8080e7          	jalr	712(ra) # 5bda <wait>
  if(xstatus != -1 && xstatus != 2)
    491a:	fbc42783          	lw	a5,-68(s0)
    491e:	577d                	li	a4,-1
    4920:	00e78563          	beq	a5,a4,492a <sbrkfail+0x118>
    4924:	4709                	li	a4,2
    4926:	08e79d63          	bne	a5,a4,49c0 <sbrkfail+0x1ae>
}
    492a:	70e6                	ld	ra,120(sp)
    492c:	7446                	ld	s0,112(sp)
    492e:	74a6                	ld	s1,104(sp)
    4930:	7906                	ld	s2,96(sp)
    4932:	69e6                	ld	s3,88(sp)
    4934:	6a46                	ld	s4,80(sp)
    4936:	6aa6                	ld	s5,72(sp)
    4938:	6109                	addi	sp,sp,128
    493a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    493c:	85ca                	mv	a1,s2
    493e:	00003517          	auipc	a0,0x3
    4942:	42250513          	addi	a0,a0,1058 # 7d60 <malloc+0x1d30>
    4946:	00001097          	auipc	ra,0x1
    494a:	62c080e7          	jalr	1580(ra) # 5f72 <printf>
    exit(1);
    494e:	4505                	li	a0,1
    4950:	00001097          	auipc	ra,0x1
    4954:	282080e7          	jalr	642(ra) # 5bd2 <exit>
    printf("%s: fork failed\n", s);
    4958:	85ca                	mv	a1,s2
    495a:	00002517          	auipc	a0,0x2
    495e:	0a650513          	addi	a0,a0,166 # 6a00 <malloc+0x9d0>
    4962:	00001097          	auipc	ra,0x1
    4966:	610080e7          	jalr	1552(ra) # 5f72 <printf>
    exit(1);
    496a:	4505                	li	a0,1
    496c:	00001097          	auipc	ra,0x1
    4970:	266080e7          	jalr	614(ra) # 5bd2 <exit>
    a = sbrk(0);
    4974:	4501                	li	a0,0
    4976:	00001097          	auipc	ra,0x1
    497a:	2e4080e7          	jalr	740(ra) # 5c5a <sbrk>
    497e:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    4980:	3e800537          	lui	a0,0x3e800
    4984:	00001097          	auipc	ra,0x1
    4988:	2d6080e7          	jalr	726(ra) # 5c5a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    498c:	874e                	mv	a4,s3
    498e:	3e8007b7          	lui	a5,0x3e800
    4992:	97ce                	add	a5,a5,s3
    4994:	6685                	lui	a3,0x1
      n += *(a+i);
    4996:	00074603          	lbu	a2,0(a4)
    499a:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    499c:	9736                	add	a4,a4,a3
    499e:	fef71ce3          	bne	a4,a5,4996 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49a2:	8626                	mv	a2,s1
    49a4:	85ca                	mv	a1,s2
    49a6:	00003517          	auipc	a0,0x3
    49aa:	3da50513          	addi	a0,a0,986 # 7d80 <malloc+0x1d50>
    49ae:	00001097          	auipc	ra,0x1
    49b2:	5c4080e7          	jalr	1476(ra) # 5f72 <printf>
    exit(1);
    49b6:	4505                	li	a0,1
    49b8:	00001097          	auipc	ra,0x1
    49bc:	21a080e7          	jalr	538(ra) # 5bd2 <exit>
    exit(1);
    49c0:	4505                	li	a0,1
    49c2:	00001097          	auipc	ra,0x1
    49c6:	210080e7          	jalr	528(ra) # 5bd2 <exit>

00000000000049ca <mem>:
{
    49ca:	7139                	addi	sp,sp,-64
    49cc:	fc06                	sd	ra,56(sp)
    49ce:	f822                	sd	s0,48(sp)
    49d0:	f426                	sd	s1,40(sp)
    49d2:	f04a                	sd	s2,32(sp)
    49d4:	ec4e                	sd	s3,24(sp)
    49d6:	0080                	addi	s0,sp,64
    49d8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49da:	00001097          	auipc	ra,0x1
    49de:	1f0080e7          	jalr	496(ra) # 5bca <fork>
    m1 = 0;
    49e2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49e4:	6909                	lui	s2,0x2
    49e6:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x101>
  if((pid = fork()) == 0){
    49ea:	ed39                	bnez	a0,4a48 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    49ec:	854a                	mv	a0,s2
    49ee:	00001097          	auipc	ra,0x1
    49f2:	642080e7          	jalr	1602(ra) # 6030 <malloc>
    49f6:	c501                	beqz	a0,49fe <mem+0x34>
      *(char**)m2 = m1;
    49f8:	e104                	sd	s1,0(a0)
      m1 = m2;
    49fa:	84aa                	mv	s1,a0
    49fc:	bfc5                	j	49ec <mem+0x22>
    while(m1){
    49fe:	c881                	beqz	s1,4a0e <mem+0x44>
      m2 = *(char**)m1;
    4a00:	8526                	mv	a0,s1
    4a02:	6084                	ld	s1,0(s1)
      free(m1);
    4a04:	00001097          	auipc	ra,0x1
    4a08:	5a4080e7          	jalr	1444(ra) # 5fa8 <free>
    while(m1){
    4a0c:	f8f5                	bnez	s1,4a00 <mem+0x36>
    m1 = malloc(1024*20);
    4a0e:	6515                	lui	a0,0x5
    4a10:	00001097          	auipc	ra,0x1
    4a14:	620080e7          	jalr	1568(ra) # 6030 <malloc>
    if(m1 == 0){
    4a18:	c911                	beqz	a0,4a2c <mem+0x62>
    free(m1);
    4a1a:	00001097          	auipc	ra,0x1
    4a1e:	58e080e7          	jalr	1422(ra) # 5fa8 <free>
    exit(0);
    4a22:	4501                	li	a0,0
    4a24:	00001097          	auipc	ra,0x1
    4a28:	1ae080e7          	jalr	430(ra) # 5bd2 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a2c:	85ce                	mv	a1,s3
    4a2e:	00003517          	auipc	a0,0x3
    4a32:	38250513          	addi	a0,a0,898 # 7db0 <malloc+0x1d80>
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	53c080e7          	jalr	1340(ra) # 5f72 <printf>
      exit(1);
    4a3e:	4505                	li	a0,1
    4a40:	00001097          	auipc	ra,0x1
    4a44:	192080e7          	jalr	402(ra) # 5bd2 <exit>
    wait(&xstatus);
    4a48:	fcc40513          	addi	a0,s0,-52
    4a4c:	00001097          	auipc	ra,0x1
    4a50:	18e080e7          	jalr	398(ra) # 5bda <wait>
    if(xstatus == -1){
    4a54:	fcc42503          	lw	a0,-52(s0)
    4a58:	57fd                	li	a5,-1
    4a5a:	00f50663          	beq	a0,a5,4a66 <mem+0x9c>
    exit(xstatus);
    4a5e:	00001097          	auipc	ra,0x1
    4a62:	174080e7          	jalr	372(ra) # 5bd2 <exit>
      exit(0);
    4a66:	4501                	li	a0,0
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	16a080e7          	jalr	362(ra) # 5bd2 <exit>

0000000000004a70 <sharedfd>:
{
    4a70:	7159                	addi	sp,sp,-112
    4a72:	f486                	sd	ra,104(sp)
    4a74:	f0a2                	sd	s0,96(sp)
    4a76:	eca6                	sd	s1,88(sp)
    4a78:	e8ca                	sd	s2,80(sp)
    4a7a:	e4ce                	sd	s3,72(sp)
    4a7c:	e0d2                	sd	s4,64(sp)
    4a7e:	fc56                	sd	s5,56(sp)
    4a80:	f85a                	sd	s6,48(sp)
    4a82:	f45e                	sd	s7,40(sp)
    4a84:	1880                	addi	s0,sp,112
    4a86:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a88:	00003517          	auipc	a0,0x3
    4a8c:	34850513          	addi	a0,a0,840 # 7dd0 <malloc+0x1da0>
    4a90:	00001097          	auipc	ra,0x1
    4a94:	192080e7          	jalr	402(ra) # 5c22 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a98:	20200593          	li	a1,514
    4a9c:	00003517          	auipc	a0,0x3
    4aa0:	33450513          	addi	a0,a0,820 # 7dd0 <malloc+0x1da0>
    4aa4:	00001097          	auipc	ra,0x1
    4aa8:	16e080e7          	jalr	366(ra) # 5c12 <open>
  if(fd < 0){
    4aac:	04054a63          	bltz	a0,4b00 <sharedfd+0x90>
    4ab0:	892a                	mv	s2,a0
  pid = fork();
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	118080e7          	jalr	280(ra) # 5bca <fork>
    4aba:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4abc:	06300593          	li	a1,99
    4ac0:	c119                	beqz	a0,4ac6 <sharedfd+0x56>
    4ac2:	07000593          	li	a1,112
    4ac6:	4629                	li	a2,10
    4ac8:	fa040513          	addi	a0,s0,-96
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	f02080e7          	jalr	-254(ra) # 59ce <memset>
    4ad4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4ad8:	4629                	li	a2,10
    4ada:	fa040593          	addi	a1,s0,-96
    4ade:	854a                	mv	a0,s2
    4ae0:	00001097          	auipc	ra,0x1
    4ae4:	112080e7          	jalr	274(ra) # 5bf2 <write>
    4ae8:	47a9                	li	a5,10
    4aea:	02f51963          	bne	a0,a5,4b1c <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4aee:	34fd                	addiw	s1,s1,-1
    4af0:	f4e5                	bnez	s1,4ad8 <sharedfd+0x68>
  if(pid == 0) {
    4af2:	04099363          	bnez	s3,4b38 <sharedfd+0xc8>
    exit(0);
    4af6:	4501                	li	a0,0
    4af8:	00001097          	auipc	ra,0x1
    4afc:	0da080e7          	jalr	218(ra) # 5bd2 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b00:	85d2                	mv	a1,s4
    4b02:	00003517          	auipc	a0,0x3
    4b06:	2de50513          	addi	a0,a0,734 # 7de0 <malloc+0x1db0>
    4b0a:	00001097          	auipc	ra,0x1
    4b0e:	468080e7          	jalr	1128(ra) # 5f72 <printf>
    exit(1);
    4b12:	4505                	li	a0,1
    4b14:	00001097          	auipc	ra,0x1
    4b18:	0be080e7          	jalr	190(ra) # 5bd2 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b1c:	85d2                	mv	a1,s4
    4b1e:	00003517          	auipc	a0,0x3
    4b22:	2ea50513          	addi	a0,a0,746 # 7e08 <malloc+0x1dd8>
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	44c080e7          	jalr	1100(ra) # 5f72 <printf>
      exit(1);
    4b2e:	4505                	li	a0,1
    4b30:	00001097          	auipc	ra,0x1
    4b34:	0a2080e7          	jalr	162(ra) # 5bd2 <exit>
    wait(&xstatus);
    4b38:	f9c40513          	addi	a0,s0,-100
    4b3c:	00001097          	auipc	ra,0x1
    4b40:	09e080e7          	jalr	158(ra) # 5bda <wait>
    if(xstatus != 0)
    4b44:	f9c42983          	lw	s3,-100(s0)
    4b48:	00098763          	beqz	s3,4b56 <sharedfd+0xe6>
      exit(xstatus);
    4b4c:	854e                	mv	a0,s3
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	084080e7          	jalr	132(ra) # 5bd2 <exit>
  close(fd);
    4b56:	854a                	mv	a0,s2
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	0a2080e7          	jalr	162(ra) # 5bfa <close>
  fd = open("sharedfd", 0);
    4b60:	4581                	li	a1,0
    4b62:	00003517          	auipc	a0,0x3
    4b66:	26e50513          	addi	a0,a0,622 # 7dd0 <malloc+0x1da0>
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	0a8080e7          	jalr	168(ra) # 5c12 <open>
    4b72:	8baa                	mv	s7,a0
  nc = np = 0;
    4b74:	8ace                	mv	s5,s3
  if(fd < 0){
    4b76:	02054563          	bltz	a0,4ba0 <sharedfd+0x130>
    4b7a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b7e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b82:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b86:	4629                	li	a2,10
    4b88:	fa040593          	addi	a1,s0,-96
    4b8c:	855e                	mv	a0,s7
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	05c080e7          	jalr	92(ra) # 5bea <read>
    4b96:	02a05f63          	blez	a0,4bd4 <sharedfd+0x164>
    4b9a:	fa040793          	addi	a5,s0,-96
    4b9e:	a01d                	j	4bc4 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4ba0:	85d2                	mv	a1,s4
    4ba2:	00003517          	auipc	a0,0x3
    4ba6:	28650513          	addi	a0,a0,646 # 7e28 <malloc+0x1df8>
    4baa:	00001097          	auipc	ra,0x1
    4bae:	3c8080e7          	jalr	968(ra) # 5f72 <printf>
    exit(1);
    4bb2:	4505                	li	a0,1
    4bb4:	00001097          	auipc	ra,0x1
    4bb8:	01e080e7          	jalr	30(ra) # 5bd2 <exit>
        nc++;
    4bbc:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bbe:	0785                	addi	a5,a5,1
    4bc0:	fd2783e3          	beq	a5,s2,4b86 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bc4:	0007c703          	lbu	a4,0(a5) # 3e800000 <base+0x3e7f0388>
    4bc8:	fe970ae3          	beq	a4,s1,4bbc <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bcc:	ff6719e3          	bne	a4,s6,4bbe <sharedfd+0x14e>
        np++;
    4bd0:	2a85                	addiw	s5,s5,1
    4bd2:	b7f5                	j	4bbe <sharedfd+0x14e>
  close(fd);
    4bd4:	855e                	mv	a0,s7
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	024080e7          	jalr	36(ra) # 5bfa <close>
  unlink("sharedfd");
    4bde:	00003517          	auipc	a0,0x3
    4be2:	1f250513          	addi	a0,a0,498 # 7dd0 <malloc+0x1da0>
    4be6:	00001097          	auipc	ra,0x1
    4bea:	03c080e7          	jalr	60(ra) # 5c22 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4bee:	6789                	lui	a5,0x2
    4bf0:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x100>
    4bf4:	00f99763          	bne	s3,a5,4c02 <sharedfd+0x192>
    4bf8:	6789                	lui	a5,0x2
    4bfa:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x100>
    4bfe:	02fa8063          	beq	s5,a5,4c1e <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c02:	85d2                	mv	a1,s4
    4c04:	00003517          	auipc	a0,0x3
    4c08:	24c50513          	addi	a0,a0,588 # 7e50 <malloc+0x1e20>
    4c0c:	00001097          	auipc	ra,0x1
    4c10:	366080e7          	jalr	870(ra) # 5f72 <printf>
    exit(1);
    4c14:	4505                	li	a0,1
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	fbc080e7          	jalr	-68(ra) # 5bd2 <exit>
    exit(0);
    4c1e:	4501                	li	a0,0
    4c20:	00001097          	auipc	ra,0x1
    4c24:	fb2080e7          	jalr	-78(ra) # 5bd2 <exit>

0000000000004c28 <fourfiles>:
{
    4c28:	7171                	addi	sp,sp,-176
    4c2a:	f506                	sd	ra,168(sp)
    4c2c:	f122                	sd	s0,160(sp)
    4c2e:	ed26                	sd	s1,152(sp)
    4c30:	e94a                	sd	s2,144(sp)
    4c32:	e54e                	sd	s3,136(sp)
    4c34:	e152                	sd	s4,128(sp)
    4c36:	fcd6                	sd	s5,120(sp)
    4c38:	f8da                	sd	s6,112(sp)
    4c3a:	f4de                	sd	s7,104(sp)
    4c3c:	f0e2                	sd	s8,96(sp)
    4c3e:	ece6                	sd	s9,88(sp)
    4c40:	e8ea                	sd	s10,80(sp)
    4c42:	e4ee                	sd	s11,72(sp)
    4c44:	1900                	addi	s0,sp,176
    4c46:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c48:	00001797          	auipc	a5,0x1
    4c4c:	4d878793          	addi	a5,a5,1240 # 6120 <malloc+0xf0>
    4c50:	f6f43823          	sd	a5,-144(s0)
    4c54:	00001797          	auipc	a5,0x1
    4c58:	4d478793          	addi	a5,a5,1236 # 6128 <malloc+0xf8>
    4c5c:	f6f43c23          	sd	a5,-136(s0)
    4c60:	00001797          	auipc	a5,0x1
    4c64:	4d078793          	addi	a5,a5,1232 # 6130 <malloc+0x100>
    4c68:	f8f43023          	sd	a5,-128(s0)
    4c6c:	00001797          	auipc	a5,0x1
    4c70:	4cc78793          	addi	a5,a5,1228 # 6138 <malloc+0x108>
    4c74:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c78:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c7c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c7e:	4481                	li	s1,0
    4c80:	4a11                	li	s4,4
    fname = names[pi];
    4c82:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c86:	854e                	mv	a0,s3
    4c88:	00001097          	auipc	ra,0x1
    4c8c:	f9a080e7          	jalr	-102(ra) # 5c22 <unlink>
    pid = fork();
    4c90:	00001097          	auipc	ra,0x1
    4c94:	f3a080e7          	jalr	-198(ra) # 5bca <fork>
    if(pid < 0){
    4c98:	04054563          	bltz	a0,4ce2 <fourfiles+0xba>
    if(pid == 0){
    4c9c:	c12d                	beqz	a0,4cfe <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4c9e:	2485                	addiw	s1,s1,1
    4ca0:	0921                	addi	s2,s2,8
    4ca2:	ff4490e3          	bne	s1,s4,4c82 <fourfiles+0x5a>
    4ca6:	4491                	li	s1,4
    wait(&xstatus);
    4ca8:	f6c40513          	addi	a0,s0,-148
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	f2e080e7          	jalr	-210(ra) # 5bda <wait>
    if(xstatus != 0)
    4cb4:	f6c42503          	lw	a0,-148(s0)
    4cb8:	ed69                	bnez	a0,4d92 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    4cba:	34fd                	addiw	s1,s1,-1
    4cbc:	f4f5                	bnez	s1,4ca8 <fourfiles+0x80>
    4cbe:	03000b13          	li	s6,48
    total = 0;
    4cc2:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cc6:	00008a17          	auipc	s4,0x8
    4cca:	fb2a0a13          	addi	s4,s4,-78 # cc78 <buf>
    4cce:	00008a97          	auipc	s5,0x8
    4cd2:	faba8a93          	addi	s5,s5,-85 # cc79 <buf+0x1>
    if(total != N*SZ){
    4cd6:	6d05                	lui	s10,0x1
    4cd8:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x2e>
  for(i = 0; i < NCHILD; i++){
    4cdc:	03400d93          	li	s11,52
    4ce0:	a23d                	j	4e0e <fourfiles+0x1e6>
      printf("fork failed\n", s);
    4ce2:	85e6                	mv	a1,s9
    4ce4:	00002517          	auipc	a0,0x2
    4ce8:	12450513          	addi	a0,a0,292 # 6e08 <malloc+0xdd8>
    4cec:	00001097          	auipc	ra,0x1
    4cf0:	286080e7          	jalr	646(ra) # 5f72 <printf>
      exit(1);
    4cf4:	4505                	li	a0,1
    4cf6:	00001097          	auipc	ra,0x1
    4cfa:	edc080e7          	jalr	-292(ra) # 5bd2 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cfe:	20200593          	li	a1,514
    4d02:	854e                	mv	a0,s3
    4d04:	00001097          	auipc	ra,0x1
    4d08:	f0e080e7          	jalr	-242(ra) # 5c12 <open>
    4d0c:	892a                	mv	s2,a0
      if(fd < 0){
    4d0e:	04054763          	bltz	a0,4d5c <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    4d12:	1f400613          	li	a2,500
    4d16:	0304859b          	addiw	a1,s1,48
    4d1a:	00008517          	auipc	a0,0x8
    4d1e:	f5e50513          	addi	a0,a0,-162 # cc78 <buf>
    4d22:	00001097          	auipc	ra,0x1
    4d26:	cac080e7          	jalr	-852(ra) # 59ce <memset>
    4d2a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d2c:	00008997          	auipc	s3,0x8
    4d30:	f4c98993          	addi	s3,s3,-180 # cc78 <buf>
    4d34:	1f400613          	li	a2,500
    4d38:	85ce                	mv	a1,s3
    4d3a:	854a                	mv	a0,s2
    4d3c:	00001097          	auipc	ra,0x1
    4d40:	eb6080e7          	jalr	-330(ra) # 5bf2 <write>
    4d44:	85aa                	mv	a1,a0
    4d46:	1f400793          	li	a5,500
    4d4a:	02f51763          	bne	a0,a5,4d78 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    4d4e:	34fd                	addiw	s1,s1,-1
    4d50:	f0f5                	bnez	s1,4d34 <fourfiles+0x10c>
      exit(0);
    4d52:	4501                	li	a0,0
    4d54:	00001097          	auipc	ra,0x1
    4d58:	e7e080e7          	jalr	-386(ra) # 5bd2 <exit>
        printf("create failed\n", s);
    4d5c:	85e6                	mv	a1,s9
    4d5e:	00003517          	auipc	a0,0x3
    4d62:	10a50513          	addi	a0,a0,266 # 7e68 <malloc+0x1e38>
    4d66:	00001097          	auipc	ra,0x1
    4d6a:	20c080e7          	jalr	524(ra) # 5f72 <printf>
        exit(1);
    4d6e:	4505                	li	a0,1
    4d70:	00001097          	auipc	ra,0x1
    4d74:	e62080e7          	jalr	-414(ra) # 5bd2 <exit>
          printf("write failed %d\n", n);
    4d78:	00003517          	auipc	a0,0x3
    4d7c:	10050513          	addi	a0,a0,256 # 7e78 <malloc+0x1e48>
    4d80:	00001097          	auipc	ra,0x1
    4d84:	1f2080e7          	jalr	498(ra) # 5f72 <printf>
          exit(1);
    4d88:	4505                	li	a0,1
    4d8a:	00001097          	auipc	ra,0x1
    4d8e:	e48080e7          	jalr	-440(ra) # 5bd2 <exit>
      exit(xstatus);
    4d92:	00001097          	auipc	ra,0x1
    4d96:	e40080e7          	jalr	-448(ra) # 5bd2 <exit>
          printf("wrong char\n", s);
    4d9a:	85e6                	mv	a1,s9
    4d9c:	00003517          	auipc	a0,0x3
    4da0:	0f450513          	addi	a0,a0,244 # 7e90 <malloc+0x1e60>
    4da4:	00001097          	auipc	ra,0x1
    4da8:	1ce080e7          	jalr	462(ra) # 5f72 <printf>
          exit(1);
    4dac:	4505                	li	a0,1
    4dae:	00001097          	auipc	ra,0x1
    4db2:	e24080e7          	jalr	-476(ra) # 5bd2 <exit>
      total += n;
    4db6:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dba:	660d                	lui	a2,0x3
    4dbc:	85d2                	mv	a1,s4
    4dbe:	854e                	mv	a0,s3
    4dc0:	00001097          	auipc	ra,0x1
    4dc4:	e2a080e7          	jalr	-470(ra) # 5bea <read>
    4dc8:	02a05363          	blez	a0,4dee <fourfiles+0x1c6>
    4dcc:	00008797          	auipc	a5,0x8
    4dd0:	eac78793          	addi	a5,a5,-340 # cc78 <buf>
    4dd4:	fff5069b          	addiw	a3,a0,-1
    4dd8:	1682                	slli	a3,a3,0x20
    4dda:	9281                	srli	a3,a3,0x20
    4ddc:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4dde:	0007c703          	lbu	a4,0(a5)
    4de2:	fa971ce3          	bne	a4,s1,4d9a <fourfiles+0x172>
      for(j = 0; j < n; j++){
    4de6:	0785                	addi	a5,a5,1
    4de8:	fed79be3          	bne	a5,a3,4dde <fourfiles+0x1b6>
    4dec:	b7e9                	j	4db6 <fourfiles+0x18e>
    close(fd);
    4dee:	854e                	mv	a0,s3
    4df0:	00001097          	auipc	ra,0x1
    4df4:	e0a080e7          	jalr	-502(ra) # 5bfa <close>
    if(total != N*SZ){
    4df8:	03a91963          	bne	s2,s10,4e2a <fourfiles+0x202>
    unlink(fname);
    4dfc:	8562                	mv	a0,s8
    4dfe:	00001097          	auipc	ra,0x1
    4e02:	e24080e7          	jalr	-476(ra) # 5c22 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e06:	0ba1                	addi	s7,s7,8
    4e08:	2b05                	addiw	s6,s6,1
    4e0a:	03bb0e63          	beq	s6,s11,4e46 <fourfiles+0x21e>
    fname = names[i];
    4e0e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e12:	4581                	li	a1,0
    4e14:	8562                	mv	a0,s8
    4e16:	00001097          	auipc	ra,0x1
    4e1a:	dfc080e7          	jalr	-516(ra) # 5c12 <open>
    4e1e:	89aa                	mv	s3,a0
    total = 0;
    4e20:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    4e24:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e28:	bf49                	j	4dba <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4e2a:	85ca                	mv	a1,s2
    4e2c:	00003517          	auipc	a0,0x3
    4e30:	07450513          	addi	a0,a0,116 # 7ea0 <malloc+0x1e70>
    4e34:	00001097          	auipc	ra,0x1
    4e38:	13e080e7          	jalr	318(ra) # 5f72 <printf>
      exit(1);
    4e3c:	4505                	li	a0,1
    4e3e:	00001097          	auipc	ra,0x1
    4e42:	d94080e7          	jalr	-620(ra) # 5bd2 <exit>
}
    4e46:	70aa                	ld	ra,168(sp)
    4e48:	740a                	ld	s0,160(sp)
    4e4a:	64ea                	ld	s1,152(sp)
    4e4c:	694a                	ld	s2,144(sp)
    4e4e:	69aa                	ld	s3,136(sp)
    4e50:	6a0a                	ld	s4,128(sp)
    4e52:	7ae6                	ld	s5,120(sp)
    4e54:	7b46                	ld	s6,112(sp)
    4e56:	7ba6                	ld	s7,104(sp)
    4e58:	7c06                	ld	s8,96(sp)
    4e5a:	6ce6                	ld	s9,88(sp)
    4e5c:	6d46                	ld	s10,80(sp)
    4e5e:	6da6                	ld	s11,72(sp)
    4e60:	614d                	addi	sp,sp,176
    4e62:	8082                	ret

0000000000004e64 <concreate>:
{
    4e64:	7135                	addi	sp,sp,-160
    4e66:	ed06                	sd	ra,152(sp)
    4e68:	e922                	sd	s0,144(sp)
    4e6a:	e526                	sd	s1,136(sp)
    4e6c:	e14a                	sd	s2,128(sp)
    4e6e:	fcce                	sd	s3,120(sp)
    4e70:	f8d2                	sd	s4,112(sp)
    4e72:	f4d6                	sd	s5,104(sp)
    4e74:	f0da                	sd	s6,96(sp)
    4e76:	ecde                	sd	s7,88(sp)
    4e78:	1100                	addi	s0,sp,160
    4e7a:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e7c:	04300793          	li	a5,67
    4e80:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e84:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e88:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e8a:	4b0d                	li	s6,3
    4e8c:	4a85                	li	s5,1
      link("C0", file);
    4e8e:	00003b97          	auipc	s7,0x3
    4e92:	02ab8b93          	addi	s7,s7,42 # 7eb8 <malloc+0x1e88>
  for(i = 0; i < N; i++){
    4e96:	02800a13          	li	s4,40
    4e9a:	acc1                	j	516a <concreate+0x306>
      link("C0", file);
    4e9c:	fa840593          	addi	a1,s0,-88
    4ea0:	855e                	mv	a0,s7
    4ea2:	00001097          	auipc	ra,0x1
    4ea6:	d90080e7          	jalr	-624(ra) # 5c32 <link>
    if(pid == 0) {
    4eaa:	a45d                	j	5150 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4eac:	4795                	li	a5,5
    4eae:	02f9693b          	remw	s2,s2,a5
    4eb2:	4785                	li	a5,1
    4eb4:	02f90b63          	beq	s2,a5,4eea <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eb8:	20200593          	li	a1,514
    4ebc:	fa840513          	addi	a0,s0,-88
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	d52080e7          	jalr	-686(ra) # 5c12 <open>
      if(fd < 0){
    4ec8:	26055b63          	bgez	a0,513e <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4ecc:	fa840593          	addi	a1,s0,-88
    4ed0:	00003517          	auipc	a0,0x3
    4ed4:	ff050513          	addi	a0,a0,-16 # 7ec0 <malloc+0x1e90>
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	09a080e7          	jalr	154(ra) # 5f72 <printf>
        exit(1);
    4ee0:	4505                	li	a0,1
    4ee2:	00001097          	auipc	ra,0x1
    4ee6:	cf0080e7          	jalr	-784(ra) # 5bd2 <exit>
      link("C0", file);
    4eea:	fa840593          	addi	a1,s0,-88
    4eee:	00003517          	auipc	a0,0x3
    4ef2:	fca50513          	addi	a0,a0,-54 # 7eb8 <malloc+0x1e88>
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	d3c080e7          	jalr	-708(ra) # 5c32 <link>
      exit(0);
    4efe:	4501                	li	a0,0
    4f00:	00001097          	auipc	ra,0x1
    4f04:	cd2080e7          	jalr	-814(ra) # 5bd2 <exit>
        exit(1);
    4f08:	4505                	li	a0,1
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	cc8080e7          	jalr	-824(ra) # 5bd2 <exit>
  memset(fa, 0, sizeof(fa));
    4f12:	02800613          	li	a2,40
    4f16:	4581                	li	a1,0
    4f18:	f8040513          	addi	a0,s0,-128
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	ab2080e7          	jalr	-1358(ra) # 59ce <memset>
  fd = open(".", 0);
    4f24:	4581                	li	a1,0
    4f26:	00002517          	auipc	a0,0x2
    4f2a:	93a50513          	addi	a0,a0,-1734 # 6860 <malloc+0x830>
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	ce4080e7          	jalr	-796(ra) # 5c12 <open>
    4f36:	892a                	mv	s2,a0
  n = 0;
    4f38:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f3a:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f3e:	02700b13          	li	s6,39
      fa[i] = 1;
    4f42:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f44:	a03d                	j	4f72 <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f46:	f7240613          	addi	a2,s0,-142
    4f4a:	85ce                	mv	a1,s3
    4f4c:	00003517          	auipc	a0,0x3
    4f50:	f9450513          	addi	a0,a0,-108 # 7ee0 <malloc+0x1eb0>
    4f54:	00001097          	auipc	ra,0x1
    4f58:	01e080e7          	jalr	30(ra) # 5f72 <printf>
        exit(1);
    4f5c:	4505                	li	a0,1
    4f5e:	00001097          	auipc	ra,0x1
    4f62:	c74080e7          	jalr	-908(ra) # 5bd2 <exit>
      fa[i] = 1;
    4f66:	fb040793          	addi	a5,s0,-80
    4f6a:	973e                	add	a4,a4,a5
    4f6c:	fd770823          	sb	s7,-48(a4)
      n++;
    4f70:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f72:	4641                	li	a2,16
    4f74:	f7040593          	addi	a1,s0,-144
    4f78:	854a                	mv	a0,s2
    4f7a:	00001097          	auipc	ra,0x1
    4f7e:	c70080e7          	jalr	-912(ra) # 5bea <read>
    4f82:	04a05a63          	blez	a0,4fd6 <concreate+0x172>
    if(de.inum == 0)
    4f86:	f7045783          	lhu	a5,-144(s0)
    4f8a:	d7e5                	beqz	a5,4f72 <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f8c:	f7244783          	lbu	a5,-142(s0)
    4f90:	ff4791e3          	bne	a5,s4,4f72 <concreate+0x10e>
    4f94:	f7444783          	lbu	a5,-140(s0)
    4f98:	ffe9                	bnez	a5,4f72 <concreate+0x10e>
      i = de.name[1] - '0';
    4f9a:	f7344783          	lbu	a5,-141(s0)
    4f9e:	fd07879b          	addiw	a5,a5,-48
    4fa2:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4fa6:	faeb60e3          	bltu	s6,a4,4f46 <concreate+0xe2>
      if(fa[i]){
    4faa:	fb040793          	addi	a5,s0,-80
    4fae:	97ba                	add	a5,a5,a4
    4fb0:	fd07c783          	lbu	a5,-48(a5)
    4fb4:	dbcd                	beqz	a5,4f66 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fb6:	f7240613          	addi	a2,s0,-142
    4fba:	85ce                	mv	a1,s3
    4fbc:	00003517          	auipc	a0,0x3
    4fc0:	f4450513          	addi	a0,a0,-188 # 7f00 <malloc+0x1ed0>
    4fc4:	00001097          	auipc	ra,0x1
    4fc8:	fae080e7          	jalr	-82(ra) # 5f72 <printf>
        exit(1);
    4fcc:	4505                	li	a0,1
    4fce:	00001097          	auipc	ra,0x1
    4fd2:	c04080e7          	jalr	-1020(ra) # 5bd2 <exit>
  close(fd);
    4fd6:	854a                	mv	a0,s2
    4fd8:	00001097          	auipc	ra,0x1
    4fdc:	c22080e7          	jalr	-990(ra) # 5bfa <close>
  if(n != N){
    4fe0:	02800793          	li	a5,40
    4fe4:	00fa9763          	bne	s5,a5,4ff2 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4fe8:	4a8d                	li	s5,3
    4fea:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fec:	02800a13          	li	s4,40
    4ff0:	a8c9                	j	50c2 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ff2:	85ce                	mv	a1,s3
    4ff4:	00003517          	auipc	a0,0x3
    4ff8:	f3450513          	addi	a0,a0,-204 # 7f28 <malloc+0x1ef8>
    4ffc:	00001097          	auipc	ra,0x1
    5000:	f76080e7          	jalr	-138(ra) # 5f72 <printf>
    exit(1);
    5004:	4505                	li	a0,1
    5006:	00001097          	auipc	ra,0x1
    500a:	bcc080e7          	jalr	-1076(ra) # 5bd2 <exit>
      printf("%s: fork failed\n", s);
    500e:	85ce                	mv	a1,s3
    5010:	00002517          	auipc	a0,0x2
    5014:	9f050513          	addi	a0,a0,-1552 # 6a00 <malloc+0x9d0>
    5018:	00001097          	auipc	ra,0x1
    501c:	f5a080e7          	jalr	-166(ra) # 5f72 <printf>
      exit(1);
    5020:	4505                	li	a0,1
    5022:	00001097          	auipc	ra,0x1
    5026:	bb0080e7          	jalr	-1104(ra) # 5bd2 <exit>
      close(open(file, 0));
    502a:	4581                	li	a1,0
    502c:	fa840513          	addi	a0,s0,-88
    5030:	00001097          	auipc	ra,0x1
    5034:	be2080e7          	jalr	-1054(ra) # 5c12 <open>
    5038:	00001097          	auipc	ra,0x1
    503c:	bc2080e7          	jalr	-1086(ra) # 5bfa <close>
      close(open(file, 0));
    5040:	4581                	li	a1,0
    5042:	fa840513          	addi	a0,s0,-88
    5046:	00001097          	auipc	ra,0x1
    504a:	bcc080e7          	jalr	-1076(ra) # 5c12 <open>
    504e:	00001097          	auipc	ra,0x1
    5052:	bac080e7          	jalr	-1108(ra) # 5bfa <close>
      close(open(file, 0));
    5056:	4581                	li	a1,0
    5058:	fa840513          	addi	a0,s0,-88
    505c:	00001097          	auipc	ra,0x1
    5060:	bb6080e7          	jalr	-1098(ra) # 5c12 <open>
    5064:	00001097          	auipc	ra,0x1
    5068:	b96080e7          	jalr	-1130(ra) # 5bfa <close>
      close(open(file, 0));
    506c:	4581                	li	a1,0
    506e:	fa840513          	addi	a0,s0,-88
    5072:	00001097          	auipc	ra,0x1
    5076:	ba0080e7          	jalr	-1120(ra) # 5c12 <open>
    507a:	00001097          	auipc	ra,0x1
    507e:	b80080e7          	jalr	-1152(ra) # 5bfa <close>
      close(open(file, 0));
    5082:	4581                	li	a1,0
    5084:	fa840513          	addi	a0,s0,-88
    5088:	00001097          	auipc	ra,0x1
    508c:	b8a080e7          	jalr	-1142(ra) # 5c12 <open>
    5090:	00001097          	auipc	ra,0x1
    5094:	b6a080e7          	jalr	-1174(ra) # 5bfa <close>
      close(open(file, 0));
    5098:	4581                	li	a1,0
    509a:	fa840513          	addi	a0,s0,-88
    509e:	00001097          	auipc	ra,0x1
    50a2:	b74080e7          	jalr	-1164(ra) # 5c12 <open>
    50a6:	00001097          	auipc	ra,0x1
    50aa:	b54080e7          	jalr	-1196(ra) # 5bfa <close>
    if(pid == 0)
    50ae:	08090363          	beqz	s2,5134 <concreate+0x2d0>
      wait(0);
    50b2:	4501                	li	a0,0
    50b4:	00001097          	auipc	ra,0x1
    50b8:	b26080e7          	jalr	-1242(ra) # 5bda <wait>
  for(i = 0; i < N; i++){
    50bc:	2485                	addiw	s1,s1,1
    50be:	0f448563          	beq	s1,s4,51a8 <concreate+0x344>
    file[1] = '0' + i;
    50c2:	0304879b          	addiw	a5,s1,48
    50c6:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50ca:	00001097          	auipc	ra,0x1
    50ce:	b00080e7          	jalr	-1280(ra) # 5bca <fork>
    50d2:	892a                	mv	s2,a0
    if(pid < 0){
    50d4:	f2054de3          	bltz	a0,500e <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    50d8:	0354e73b          	remw	a4,s1,s5
    50dc:	00a767b3          	or	a5,a4,a0
    50e0:	2781                	sext.w	a5,a5
    50e2:	d7a1                	beqz	a5,502a <concreate+0x1c6>
    50e4:	01671363          	bne	a4,s6,50ea <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    50e8:	f129                	bnez	a0,502a <concreate+0x1c6>
      unlink(file);
    50ea:	fa840513          	addi	a0,s0,-88
    50ee:	00001097          	auipc	ra,0x1
    50f2:	b34080e7          	jalr	-1228(ra) # 5c22 <unlink>
      unlink(file);
    50f6:	fa840513          	addi	a0,s0,-88
    50fa:	00001097          	auipc	ra,0x1
    50fe:	b28080e7          	jalr	-1240(ra) # 5c22 <unlink>
      unlink(file);
    5102:	fa840513          	addi	a0,s0,-88
    5106:	00001097          	auipc	ra,0x1
    510a:	b1c080e7          	jalr	-1252(ra) # 5c22 <unlink>
      unlink(file);
    510e:	fa840513          	addi	a0,s0,-88
    5112:	00001097          	auipc	ra,0x1
    5116:	b10080e7          	jalr	-1264(ra) # 5c22 <unlink>
      unlink(file);
    511a:	fa840513          	addi	a0,s0,-88
    511e:	00001097          	auipc	ra,0x1
    5122:	b04080e7          	jalr	-1276(ra) # 5c22 <unlink>
      unlink(file);
    5126:	fa840513          	addi	a0,s0,-88
    512a:	00001097          	auipc	ra,0x1
    512e:	af8080e7          	jalr	-1288(ra) # 5c22 <unlink>
    5132:	bfb5                	j	50ae <concreate+0x24a>
      exit(0);
    5134:	4501                	li	a0,0
    5136:	00001097          	auipc	ra,0x1
    513a:	a9c080e7          	jalr	-1380(ra) # 5bd2 <exit>
      close(fd);
    513e:	00001097          	auipc	ra,0x1
    5142:	abc080e7          	jalr	-1348(ra) # 5bfa <close>
    if(pid == 0) {
    5146:	bb65                	j	4efe <concreate+0x9a>
      close(fd);
    5148:	00001097          	auipc	ra,0x1
    514c:	ab2080e7          	jalr	-1358(ra) # 5bfa <close>
      wait(&xstatus);
    5150:	f6c40513          	addi	a0,s0,-148
    5154:	00001097          	auipc	ra,0x1
    5158:	a86080e7          	jalr	-1402(ra) # 5bda <wait>
      if(xstatus != 0)
    515c:	f6c42483          	lw	s1,-148(s0)
    5160:	da0494e3          	bnez	s1,4f08 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5164:	2905                	addiw	s2,s2,1
    5166:	db4906e3          	beq	s2,s4,4f12 <concreate+0xae>
    file[1] = '0' + i;
    516a:	0309079b          	addiw	a5,s2,48
    516e:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5172:	fa840513          	addi	a0,s0,-88
    5176:	00001097          	auipc	ra,0x1
    517a:	aac080e7          	jalr	-1364(ra) # 5c22 <unlink>
    pid = fork();
    517e:	00001097          	auipc	ra,0x1
    5182:	a4c080e7          	jalr	-1460(ra) # 5bca <fork>
    if(pid && (i % 3) == 1){
    5186:	d20503e3          	beqz	a0,4eac <concreate+0x48>
    518a:	036967bb          	remw	a5,s2,s6
    518e:	d15787e3          	beq	a5,s5,4e9c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5192:	20200593          	li	a1,514
    5196:	fa840513          	addi	a0,s0,-88
    519a:	00001097          	auipc	ra,0x1
    519e:	a78080e7          	jalr	-1416(ra) # 5c12 <open>
      if(fd < 0){
    51a2:	fa0553e3          	bgez	a0,5148 <concreate+0x2e4>
    51a6:	b31d                	j	4ecc <concreate+0x68>
}
    51a8:	60ea                	ld	ra,152(sp)
    51aa:	644a                	ld	s0,144(sp)
    51ac:	64aa                	ld	s1,136(sp)
    51ae:	690a                	ld	s2,128(sp)
    51b0:	79e6                	ld	s3,120(sp)
    51b2:	7a46                	ld	s4,112(sp)
    51b4:	7aa6                	ld	s5,104(sp)
    51b6:	7b06                	ld	s6,96(sp)
    51b8:	6be6                	ld	s7,88(sp)
    51ba:	610d                	addi	sp,sp,160
    51bc:	8082                	ret

00000000000051be <bigfile>:
{
    51be:	7139                	addi	sp,sp,-64
    51c0:	fc06                	sd	ra,56(sp)
    51c2:	f822                	sd	s0,48(sp)
    51c4:	f426                	sd	s1,40(sp)
    51c6:	f04a                	sd	s2,32(sp)
    51c8:	ec4e                	sd	s3,24(sp)
    51ca:	e852                	sd	s4,16(sp)
    51cc:	e456                	sd	s5,8(sp)
    51ce:	0080                	addi	s0,sp,64
    51d0:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51d2:	00003517          	auipc	a0,0x3
    51d6:	d8e50513          	addi	a0,a0,-626 # 7f60 <malloc+0x1f30>
    51da:	00001097          	auipc	ra,0x1
    51de:	a48080e7          	jalr	-1464(ra) # 5c22 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51e2:	20200593          	li	a1,514
    51e6:	00003517          	auipc	a0,0x3
    51ea:	d7a50513          	addi	a0,a0,-646 # 7f60 <malloc+0x1f30>
    51ee:	00001097          	auipc	ra,0x1
    51f2:	a24080e7          	jalr	-1500(ra) # 5c12 <open>
    51f6:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51f8:	4481                	li	s1,0
    memset(buf, i, SZ);
    51fa:	00008917          	auipc	s2,0x8
    51fe:	a7e90913          	addi	s2,s2,-1410 # cc78 <buf>
  for(i = 0; i < N; i++){
    5202:	4a51                	li	s4,20
  if(fd < 0){
    5204:	0a054063          	bltz	a0,52a4 <bigfile+0xe6>
    memset(buf, i, SZ);
    5208:	25800613          	li	a2,600
    520c:	85a6                	mv	a1,s1
    520e:	854a                	mv	a0,s2
    5210:	00000097          	auipc	ra,0x0
    5214:	7be080e7          	jalr	1982(ra) # 59ce <memset>
    if(write(fd, buf, SZ) != SZ){
    5218:	25800613          	li	a2,600
    521c:	85ca                	mv	a1,s2
    521e:	854e                	mv	a0,s3
    5220:	00001097          	auipc	ra,0x1
    5224:	9d2080e7          	jalr	-1582(ra) # 5bf2 <write>
    5228:	25800793          	li	a5,600
    522c:	08f51a63          	bne	a0,a5,52c0 <bigfile+0x102>
  for(i = 0; i < N; i++){
    5230:	2485                	addiw	s1,s1,1
    5232:	fd449be3          	bne	s1,s4,5208 <bigfile+0x4a>
  close(fd);
    5236:	854e                	mv	a0,s3
    5238:	00001097          	auipc	ra,0x1
    523c:	9c2080e7          	jalr	-1598(ra) # 5bfa <close>
  fd = open("bigfile.dat", 0);
    5240:	4581                	li	a1,0
    5242:	00003517          	auipc	a0,0x3
    5246:	d1e50513          	addi	a0,a0,-738 # 7f60 <malloc+0x1f30>
    524a:	00001097          	auipc	ra,0x1
    524e:	9c8080e7          	jalr	-1592(ra) # 5c12 <open>
    5252:	8a2a                	mv	s4,a0
  total = 0;
    5254:	4981                	li	s3,0
  for(i = 0; ; i++){
    5256:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5258:	00008917          	auipc	s2,0x8
    525c:	a2090913          	addi	s2,s2,-1504 # cc78 <buf>
  if(fd < 0){
    5260:	06054e63          	bltz	a0,52dc <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5264:	12c00613          	li	a2,300
    5268:	85ca                	mv	a1,s2
    526a:	8552                	mv	a0,s4
    526c:	00001097          	auipc	ra,0x1
    5270:	97e080e7          	jalr	-1666(ra) # 5bea <read>
    if(cc < 0){
    5274:	08054263          	bltz	a0,52f8 <bigfile+0x13a>
    if(cc == 0)
    5278:	c971                	beqz	a0,534c <bigfile+0x18e>
    if(cc != SZ/2){
    527a:	12c00793          	li	a5,300
    527e:	08f51b63          	bne	a0,a5,5314 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5282:	01f4d79b          	srliw	a5,s1,0x1f
    5286:	9fa5                	addw	a5,a5,s1
    5288:	4017d79b          	sraiw	a5,a5,0x1
    528c:	00094703          	lbu	a4,0(s2)
    5290:	0af71063          	bne	a4,a5,5330 <bigfile+0x172>
    5294:	12b94703          	lbu	a4,299(s2)
    5298:	08f71c63          	bne	a4,a5,5330 <bigfile+0x172>
    total += cc;
    529c:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    52a0:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52a2:	b7c9                	j	5264 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52a4:	85d6                	mv	a1,s5
    52a6:	00003517          	auipc	a0,0x3
    52aa:	cca50513          	addi	a0,a0,-822 # 7f70 <malloc+0x1f40>
    52ae:	00001097          	auipc	ra,0x1
    52b2:	cc4080e7          	jalr	-828(ra) # 5f72 <printf>
    exit(1);
    52b6:	4505                	li	a0,1
    52b8:	00001097          	auipc	ra,0x1
    52bc:	91a080e7          	jalr	-1766(ra) # 5bd2 <exit>
      printf("%s: write bigfile failed\n", s);
    52c0:	85d6                	mv	a1,s5
    52c2:	00003517          	auipc	a0,0x3
    52c6:	cce50513          	addi	a0,a0,-818 # 7f90 <malloc+0x1f60>
    52ca:	00001097          	auipc	ra,0x1
    52ce:	ca8080e7          	jalr	-856(ra) # 5f72 <printf>
      exit(1);
    52d2:	4505                	li	a0,1
    52d4:	00001097          	auipc	ra,0x1
    52d8:	8fe080e7          	jalr	-1794(ra) # 5bd2 <exit>
    printf("%s: cannot open bigfile\n", s);
    52dc:	85d6                	mv	a1,s5
    52de:	00003517          	auipc	a0,0x3
    52e2:	cd250513          	addi	a0,a0,-814 # 7fb0 <malloc+0x1f80>
    52e6:	00001097          	auipc	ra,0x1
    52ea:	c8c080e7          	jalr	-884(ra) # 5f72 <printf>
    exit(1);
    52ee:	4505                	li	a0,1
    52f0:	00001097          	auipc	ra,0x1
    52f4:	8e2080e7          	jalr	-1822(ra) # 5bd2 <exit>
      printf("%s: read bigfile failed\n", s);
    52f8:	85d6                	mv	a1,s5
    52fa:	00003517          	auipc	a0,0x3
    52fe:	cd650513          	addi	a0,a0,-810 # 7fd0 <malloc+0x1fa0>
    5302:	00001097          	auipc	ra,0x1
    5306:	c70080e7          	jalr	-912(ra) # 5f72 <printf>
      exit(1);
    530a:	4505                	li	a0,1
    530c:	00001097          	auipc	ra,0x1
    5310:	8c6080e7          	jalr	-1850(ra) # 5bd2 <exit>
      printf("%s: short read bigfile\n", s);
    5314:	85d6                	mv	a1,s5
    5316:	00003517          	auipc	a0,0x3
    531a:	cda50513          	addi	a0,a0,-806 # 7ff0 <malloc+0x1fc0>
    531e:	00001097          	auipc	ra,0x1
    5322:	c54080e7          	jalr	-940(ra) # 5f72 <printf>
      exit(1);
    5326:	4505                	li	a0,1
    5328:	00001097          	auipc	ra,0x1
    532c:	8aa080e7          	jalr	-1878(ra) # 5bd2 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5330:	85d6                	mv	a1,s5
    5332:	00003517          	auipc	a0,0x3
    5336:	cd650513          	addi	a0,a0,-810 # 8008 <malloc+0x1fd8>
    533a:	00001097          	auipc	ra,0x1
    533e:	c38080e7          	jalr	-968(ra) # 5f72 <printf>
      exit(1);
    5342:	4505                	li	a0,1
    5344:	00001097          	auipc	ra,0x1
    5348:	88e080e7          	jalr	-1906(ra) # 5bd2 <exit>
  close(fd);
    534c:	8552                	mv	a0,s4
    534e:	00001097          	auipc	ra,0x1
    5352:	8ac080e7          	jalr	-1876(ra) # 5bfa <close>
  if(total != N*SZ){
    5356:	678d                	lui	a5,0x3
    5358:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x84>
    535c:	02f99363          	bne	s3,a5,5382 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5360:	00003517          	auipc	a0,0x3
    5364:	c0050513          	addi	a0,a0,-1024 # 7f60 <malloc+0x1f30>
    5368:	00001097          	auipc	ra,0x1
    536c:	8ba080e7          	jalr	-1862(ra) # 5c22 <unlink>
}
    5370:	70e2                	ld	ra,56(sp)
    5372:	7442                	ld	s0,48(sp)
    5374:	74a2                	ld	s1,40(sp)
    5376:	7902                	ld	s2,32(sp)
    5378:	69e2                	ld	s3,24(sp)
    537a:	6a42                	ld	s4,16(sp)
    537c:	6aa2                	ld	s5,8(sp)
    537e:	6121                	addi	sp,sp,64
    5380:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5382:	85d6                	mv	a1,s5
    5384:	00003517          	auipc	a0,0x3
    5388:	ca450513          	addi	a0,a0,-860 # 8028 <malloc+0x1ff8>
    538c:	00001097          	auipc	ra,0x1
    5390:	be6080e7          	jalr	-1050(ra) # 5f72 <printf>
    exit(1);
    5394:	4505                	li	a0,1
    5396:	00001097          	auipc	ra,0x1
    539a:	83c080e7          	jalr	-1988(ra) # 5bd2 <exit>

000000000000539e <fsfull>:
{
    539e:	7171                	addi	sp,sp,-176
    53a0:	f506                	sd	ra,168(sp)
    53a2:	f122                	sd	s0,160(sp)
    53a4:	ed26                	sd	s1,152(sp)
    53a6:	e94a                	sd	s2,144(sp)
    53a8:	e54e                	sd	s3,136(sp)
    53aa:	e152                	sd	s4,128(sp)
    53ac:	fcd6                	sd	s5,120(sp)
    53ae:	f8da                	sd	s6,112(sp)
    53b0:	f4de                	sd	s7,104(sp)
    53b2:	f0e2                	sd	s8,96(sp)
    53b4:	ece6                	sd	s9,88(sp)
    53b6:	e8ea                	sd	s10,80(sp)
    53b8:	e4ee                	sd	s11,72(sp)
    53ba:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53bc:	00003517          	auipc	a0,0x3
    53c0:	c8c50513          	addi	a0,a0,-884 # 8048 <malloc+0x2018>
    53c4:	00001097          	auipc	ra,0x1
    53c8:	bae080e7          	jalr	-1106(ra) # 5f72 <printf>
  for(nfiles = 0; ; nfiles++){
    53cc:	4481                	li	s1,0
    name[0] = 'f';
    53ce:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53d2:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53d6:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53da:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53dc:	00003c97          	auipc	s9,0x3
    53e0:	c7cc8c93          	addi	s9,s9,-900 # 8058 <malloc+0x2028>
    int total = 0;
    53e4:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    53e6:	00008a17          	auipc	s4,0x8
    53ea:	892a0a13          	addi	s4,s4,-1902 # cc78 <buf>
    name[0] = 'f';
    53ee:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    53f2:	0384c7bb          	divw	a5,s1,s8
    53f6:	0307879b          	addiw	a5,a5,48
    53fa:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53fe:	0384e7bb          	remw	a5,s1,s8
    5402:	0377c7bb          	divw	a5,a5,s7
    5406:	0307879b          	addiw	a5,a5,48
    540a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    540e:	0374e7bb          	remw	a5,s1,s7
    5412:	0367c7bb          	divw	a5,a5,s6
    5416:	0307879b          	addiw	a5,a5,48
    541a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    541e:	0364e7bb          	remw	a5,s1,s6
    5422:	0307879b          	addiw	a5,a5,48
    5426:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    542a:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    542e:	f5040593          	addi	a1,s0,-176
    5432:	8566                	mv	a0,s9
    5434:	00001097          	auipc	ra,0x1
    5438:	b3e080e7          	jalr	-1218(ra) # 5f72 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    543c:	20200593          	li	a1,514
    5440:	f5040513          	addi	a0,s0,-176
    5444:	00000097          	auipc	ra,0x0
    5448:	7ce080e7          	jalr	1998(ra) # 5c12 <open>
    544c:	892a                	mv	s2,a0
    if(fd < 0){
    544e:	0a055663          	bgez	a0,54fa <fsfull+0x15c>
      printf("open %s failed\n", name);
    5452:	f5040593          	addi	a1,s0,-176
    5456:	00003517          	auipc	a0,0x3
    545a:	c1250513          	addi	a0,a0,-1006 # 8068 <malloc+0x2038>
    545e:	00001097          	auipc	ra,0x1
    5462:	b14080e7          	jalr	-1260(ra) # 5f72 <printf>
  while(nfiles >= 0){
    5466:	0604c363          	bltz	s1,54cc <fsfull+0x12e>
    name[0] = 'f';
    546a:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    546e:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5472:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5476:	4929                	li	s2,10
  while(nfiles >= 0){
    5478:	5afd                	li	s5,-1
    name[0] = 'f';
    547a:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    547e:	0344c7bb          	divw	a5,s1,s4
    5482:	0307879b          	addiw	a5,a5,48
    5486:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    548a:	0344e7bb          	remw	a5,s1,s4
    548e:	0337c7bb          	divw	a5,a5,s3
    5492:	0307879b          	addiw	a5,a5,48
    5496:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    549a:	0334e7bb          	remw	a5,s1,s3
    549e:	0327c7bb          	divw	a5,a5,s2
    54a2:	0307879b          	addiw	a5,a5,48
    54a6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54aa:	0324e7bb          	remw	a5,s1,s2
    54ae:	0307879b          	addiw	a5,a5,48
    54b2:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54b6:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54ba:	f5040513          	addi	a0,s0,-176
    54be:	00000097          	auipc	ra,0x0
    54c2:	764080e7          	jalr	1892(ra) # 5c22 <unlink>
    nfiles--;
    54c6:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54c8:	fb5499e3          	bne	s1,s5,547a <fsfull+0xdc>
  printf("fsfull test finished\n");
    54cc:	00003517          	auipc	a0,0x3
    54d0:	bbc50513          	addi	a0,a0,-1092 # 8088 <malloc+0x2058>
    54d4:	00001097          	auipc	ra,0x1
    54d8:	a9e080e7          	jalr	-1378(ra) # 5f72 <printf>
}
    54dc:	70aa                	ld	ra,168(sp)
    54de:	740a                	ld	s0,160(sp)
    54e0:	64ea                	ld	s1,152(sp)
    54e2:	694a                	ld	s2,144(sp)
    54e4:	69aa                	ld	s3,136(sp)
    54e6:	6a0a                	ld	s4,128(sp)
    54e8:	7ae6                	ld	s5,120(sp)
    54ea:	7b46                	ld	s6,112(sp)
    54ec:	7ba6                	ld	s7,104(sp)
    54ee:	7c06                	ld	s8,96(sp)
    54f0:	6ce6                	ld	s9,88(sp)
    54f2:	6d46                	ld	s10,80(sp)
    54f4:	6da6                	ld	s11,72(sp)
    54f6:	614d                	addi	sp,sp,176
    54f8:	8082                	ret
    int total = 0;
    54fa:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    54fc:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5500:	40000613          	li	a2,1024
    5504:	85d2                	mv	a1,s4
    5506:	854a                	mv	a0,s2
    5508:	00000097          	auipc	ra,0x0
    550c:	6ea080e7          	jalr	1770(ra) # 5bf2 <write>
      if(cc < BSIZE)
    5510:	00aad563          	bge	s5,a0,551a <fsfull+0x17c>
      total += cc;
    5514:	00a989bb          	addw	s3,s3,a0
    while(1){
    5518:	b7e5                	j	5500 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    551a:	85ce                	mv	a1,s3
    551c:	00003517          	auipc	a0,0x3
    5520:	b5c50513          	addi	a0,a0,-1188 # 8078 <malloc+0x2048>
    5524:	00001097          	auipc	ra,0x1
    5528:	a4e080e7          	jalr	-1458(ra) # 5f72 <printf>
    close(fd);
    552c:	854a                	mv	a0,s2
    552e:	00000097          	auipc	ra,0x0
    5532:	6cc080e7          	jalr	1740(ra) # 5bfa <close>
    if(total == 0)
    5536:	f20988e3          	beqz	s3,5466 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    553a:	2485                	addiw	s1,s1,1
    553c:	bd4d                	j	53ee <fsfull+0x50>

000000000000553e <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    553e:	7179                	addi	sp,sp,-48
    5540:	f406                	sd	ra,40(sp)
    5542:	f022                	sd	s0,32(sp)
    5544:	ec26                	sd	s1,24(sp)
    5546:	e84a                	sd	s2,16(sp)
    5548:	1800                	addi	s0,sp,48
    554a:	84aa                	mv	s1,a0
    554c:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554e:	00003517          	auipc	a0,0x3
    5552:	b5250513          	addi	a0,a0,-1198 # 80a0 <malloc+0x2070>
    5556:	00001097          	auipc	ra,0x1
    555a:	a1c080e7          	jalr	-1508(ra) # 5f72 <printf>
  if((pid = fork()) < 0) {
    555e:	00000097          	auipc	ra,0x0
    5562:	66c080e7          	jalr	1644(ra) # 5bca <fork>
    5566:	02054e63          	bltz	a0,55a2 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    556a:	c929                	beqz	a0,55bc <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    556c:	fdc40513          	addi	a0,s0,-36
    5570:	00000097          	auipc	ra,0x0
    5574:	66a080e7          	jalr	1642(ra) # 5bda <wait>
    if(xstatus != 0) 
    5578:	fdc42783          	lw	a5,-36(s0)
    557c:	c7b9                	beqz	a5,55ca <run+0x8c>
      printf("FAILED\n");
    557e:	00003517          	auipc	a0,0x3
    5582:	b4a50513          	addi	a0,a0,-1206 # 80c8 <malloc+0x2098>
    5586:	00001097          	auipc	ra,0x1
    558a:	9ec080e7          	jalr	-1556(ra) # 5f72 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558e:	fdc42503          	lw	a0,-36(s0)
  }
}
    5592:	00153513          	seqz	a0,a0
    5596:	70a2                	ld	ra,40(sp)
    5598:	7402                	ld	s0,32(sp)
    559a:	64e2                	ld	s1,24(sp)
    559c:	6942                	ld	s2,16(sp)
    559e:	6145                	addi	sp,sp,48
    55a0:	8082                	ret
    printf("runtest: fork error\n");
    55a2:	00003517          	auipc	a0,0x3
    55a6:	b0e50513          	addi	a0,a0,-1266 # 80b0 <malloc+0x2080>
    55aa:	00001097          	auipc	ra,0x1
    55ae:	9c8080e7          	jalr	-1592(ra) # 5f72 <printf>
    exit(1);
    55b2:	4505                	li	a0,1
    55b4:	00000097          	auipc	ra,0x0
    55b8:	61e080e7          	jalr	1566(ra) # 5bd2 <exit>
    f(s);
    55bc:	854a                	mv	a0,s2
    55be:	9482                	jalr	s1
    exit(0);
    55c0:	4501                	li	a0,0
    55c2:	00000097          	auipc	ra,0x0
    55c6:	610080e7          	jalr	1552(ra) # 5bd2 <exit>
      printf("OK\n");
    55ca:	00003517          	auipc	a0,0x3
    55ce:	b0650513          	addi	a0,a0,-1274 # 80d0 <malloc+0x20a0>
    55d2:	00001097          	auipc	ra,0x1
    55d6:	9a0080e7          	jalr	-1632(ra) # 5f72 <printf>
    55da:	bf55                	j	558e <run+0x50>

00000000000055dc <runtests>:

int
runtests(struct test *tests, char *justone) {
    55dc:	1101                	addi	sp,sp,-32
    55de:	ec06                	sd	ra,24(sp)
    55e0:	e822                	sd	s0,16(sp)
    55e2:	e426                	sd	s1,8(sp)
    55e4:	e04a                	sd	s2,0(sp)
    55e6:	1000                	addi	s0,sp,32
    55e8:	84aa                	mv	s1,a0
    55ea:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55ec:	6508                	ld	a0,8(a0)
    55ee:	ed09                	bnez	a0,5608 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55f0:	4501                	li	a0,0
    55f2:	a82d                	j	562c <runtests+0x50>
      if(!run(t->f, t->s)){
    55f4:	648c                	ld	a1,8(s1)
    55f6:	6088                	ld	a0,0(s1)
    55f8:	00000097          	auipc	ra,0x0
    55fc:	f46080e7          	jalr	-186(ra) # 553e <run>
    5600:	cd09                	beqz	a0,561a <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5602:	04c1                	addi	s1,s1,16
    5604:	6488                	ld	a0,8(s1)
    5606:	c11d                	beqz	a0,562c <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5608:	fe0906e3          	beqz	s2,55f4 <runtests+0x18>
    560c:	85ca                	mv	a1,s2
    560e:	00000097          	auipc	ra,0x0
    5612:	36a080e7          	jalr	874(ra) # 5978 <strcmp>
    5616:	f575                	bnez	a0,5602 <runtests+0x26>
    5618:	bff1                	j	55f4 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    561a:	00003517          	auipc	a0,0x3
    561e:	abe50513          	addi	a0,a0,-1346 # 80d8 <malloc+0x20a8>
    5622:	00001097          	auipc	ra,0x1
    5626:	950080e7          	jalr	-1712(ra) # 5f72 <printf>
        return 1;
    562a:	4505                	li	a0,1
}
    562c:	60e2                	ld	ra,24(sp)
    562e:	6442                	ld	s0,16(sp)
    5630:	64a2                	ld	s1,8(sp)
    5632:	6902                	ld	s2,0(sp)
    5634:	6105                	addi	sp,sp,32
    5636:	8082                	ret

0000000000005638 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5638:	7139                	addi	sp,sp,-64
    563a:	fc06                	sd	ra,56(sp)
    563c:	f822                	sd	s0,48(sp)
    563e:	f426                	sd	s1,40(sp)
    5640:	f04a                	sd	s2,32(sp)
    5642:	ec4e                	sd	s3,24(sp)
    5644:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5646:	fc840513          	addi	a0,s0,-56
    564a:	00000097          	auipc	ra,0x0
    564e:	598080e7          	jalr	1432(ra) # 5be2 <pipe>
    5652:	06054863          	bltz	a0,56c2 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5656:	00000097          	auipc	ra,0x0
    565a:	574080e7          	jalr	1396(ra) # 5bca <fork>

  if(pid < 0){
    565e:	06054f63          	bltz	a0,56dc <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5662:	ed59                	bnez	a0,5700 <countfree+0xc8>
    close(fds[0]);
    5664:	fc842503          	lw	a0,-56(s0)
    5668:	00000097          	auipc	ra,0x0
    566c:	592080e7          	jalr	1426(ra) # 5bfa <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5670:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5672:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5674:	00001917          	auipc	s2,0x1
    5678:	b7490913          	addi	s2,s2,-1164 # 61e8 <malloc+0x1b8>
      uint64 a = (uint64) sbrk(4096);
    567c:	6505                	lui	a0,0x1
    567e:	00000097          	auipc	ra,0x0
    5682:	5dc080e7          	jalr	1500(ra) # 5c5a <sbrk>
      if(a == 0xffffffffffffffff){
    5686:	06950863          	beq	a0,s1,56f6 <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    568a:	6785                	lui	a5,0x1
    568c:	953e                	add	a0,a0,a5
    568e:	ff350fa3          	sb	s3,-1(a0) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5692:	4605                	li	a2,1
    5694:	85ca                	mv	a1,s2
    5696:	fcc42503          	lw	a0,-52(s0)
    569a:	00000097          	auipc	ra,0x0
    569e:	558080e7          	jalr	1368(ra) # 5bf2 <write>
    56a2:	4785                	li	a5,1
    56a4:	fcf50ce3          	beq	a0,a5,567c <countfree+0x44>
        printf("write() failed in countfree()\n");
    56a8:	00003517          	auipc	a0,0x3
    56ac:	a8850513          	addi	a0,a0,-1400 # 8130 <malloc+0x2100>
    56b0:	00001097          	auipc	ra,0x1
    56b4:	8c2080e7          	jalr	-1854(ra) # 5f72 <printf>
        exit(1);
    56b8:	4505                	li	a0,1
    56ba:	00000097          	auipc	ra,0x0
    56be:	518080e7          	jalr	1304(ra) # 5bd2 <exit>
    printf("pipe() failed in countfree()\n");
    56c2:	00003517          	auipc	a0,0x3
    56c6:	a2e50513          	addi	a0,a0,-1490 # 80f0 <malloc+0x20c0>
    56ca:	00001097          	auipc	ra,0x1
    56ce:	8a8080e7          	jalr	-1880(ra) # 5f72 <printf>
    exit(1);
    56d2:	4505                	li	a0,1
    56d4:	00000097          	auipc	ra,0x0
    56d8:	4fe080e7          	jalr	1278(ra) # 5bd2 <exit>
    printf("fork failed in countfree()\n");
    56dc:	00003517          	auipc	a0,0x3
    56e0:	a3450513          	addi	a0,a0,-1484 # 8110 <malloc+0x20e0>
    56e4:	00001097          	auipc	ra,0x1
    56e8:	88e080e7          	jalr	-1906(ra) # 5f72 <printf>
    exit(1);
    56ec:	4505                	li	a0,1
    56ee:	00000097          	auipc	ra,0x0
    56f2:	4e4080e7          	jalr	1252(ra) # 5bd2 <exit>
      }
    }

    exit(0);
    56f6:	4501                	li	a0,0
    56f8:	00000097          	auipc	ra,0x0
    56fc:	4da080e7          	jalr	1242(ra) # 5bd2 <exit>
  }

  close(fds[1]);
    5700:	fcc42503          	lw	a0,-52(s0)
    5704:	00000097          	auipc	ra,0x0
    5708:	4f6080e7          	jalr	1270(ra) # 5bfa <close>

  int n = 0;
    570c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    570e:	4605                	li	a2,1
    5710:	fc740593          	addi	a1,s0,-57
    5714:	fc842503          	lw	a0,-56(s0)
    5718:	00000097          	auipc	ra,0x0
    571c:	4d2080e7          	jalr	1234(ra) # 5bea <read>
    if(cc < 0){
    5720:	00054563          	bltz	a0,572a <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5724:	c105                	beqz	a0,5744 <countfree+0x10c>
      break;
    n += 1;
    5726:	2485                	addiw	s1,s1,1
  while(1){
    5728:	b7dd                	j	570e <countfree+0xd6>
      printf("read() failed in countfree()\n");
    572a:	00003517          	auipc	a0,0x3
    572e:	a2650513          	addi	a0,a0,-1498 # 8150 <malloc+0x2120>
    5732:	00001097          	auipc	ra,0x1
    5736:	840080e7          	jalr	-1984(ra) # 5f72 <printf>
      exit(1);
    573a:	4505                	li	a0,1
    573c:	00000097          	auipc	ra,0x0
    5740:	496080e7          	jalr	1174(ra) # 5bd2 <exit>
  }

  close(fds[0]);
    5744:	fc842503          	lw	a0,-56(s0)
    5748:	00000097          	auipc	ra,0x0
    574c:	4b2080e7          	jalr	1202(ra) # 5bfa <close>
  wait((int*)0);
    5750:	4501                	li	a0,0
    5752:	00000097          	auipc	ra,0x0
    5756:	488080e7          	jalr	1160(ra) # 5bda <wait>
  
  return n;
}
    575a:	8526                	mv	a0,s1
    575c:	70e2                	ld	ra,56(sp)
    575e:	7442                	ld	s0,48(sp)
    5760:	74a2                	ld	s1,40(sp)
    5762:	7902                	ld	s2,32(sp)
    5764:	69e2                	ld	s3,24(sp)
    5766:	6121                	addi	sp,sp,64
    5768:	8082                	ret

000000000000576a <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    576a:	711d                	addi	sp,sp,-96
    576c:	ec86                	sd	ra,88(sp)
    576e:	e8a2                	sd	s0,80(sp)
    5770:	e4a6                	sd	s1,72(sp)
    5772:	e0ca                	sd	s2,64(sp)
    5774:	fc4e                	sd	s3,56(sp)
    5776:	f852                	sd	s4,48(sp)
    5778:	f456                	sd	s5,40(sp)
    577a:	f05a                	sd	s6,32(sp)
    577c:	ec5e                	sd	s7,24(sp)
    577e:	e862                	sd	s8,16(sp)
    5780:	e466                	sd	s9,8(sp)
    5782:	e06a                	sd	s10,0(sp)
    5784:	1080                	addi	s0,sp,96
    5786:	8a2a                	mv	s4,a0
    5788:	89ae                	mv	s3,a1
    578a:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    578c:	00003b97          	auipc	s7,0x3
    5790:	9e4b8b93          	addi	s7,s7,-1564 # 8170 <malloc+0x2140>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5794:	00004b17          	auipc	s6,0x4
    5798:	87cb0b13          	addi	s6,s6,-1924 # 9010 <quicktests>
      if(continuous != 2) {
    579c:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    579e:	00003c97          	auipc	s9,0x3
    57a2:	a0ac8c93          	addi	s9,s9,-1526 # 81a8 <malloc+0x2178>
      if (runtests(slowtests, justone)) {
    57a6:	00004c17          	auipc	s8,0x4
    57aa:	c3ac0c13          	addi	s8,s8,-966 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57ae:	00003d17          	auipc	s10,0x3
    57b2:	9dad0d13          	addi	s10,s10,-1574 # 8188 <malloc+0x2158>
    57b6:	a839                	j	57d4 <drivetests+0x6a>
    57b8:	856a                	mv	a0,s10
    57ba:	00000097          	auipc	ra,0x0
    57be:	7b8080e7          	jalr	1976(ra) # 5f72 <printf>
    57c2:	a081                	j	5802 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57c4:	00000097          	auipc	ra,0x0
    57c8:	e74080e7          	jalr	-396(ra) # 5638 <countfree>
    57cc:	06954263          	blt	a0,s1,5830 <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57d0:	06098f63          	beqz	s3,584e <drivetests+0xe4>
    printf("usertests starting\n");
    57d4:	855e                	mv	a0,s7
    57d6:	00000097          	auipc	ra,0x0
    57da:	79c080e7          	jalr	1948(ra) # 5f72 <printf>
    int free0 = countfree();
    57de:	00000097          	auipc	ra,0x0
    57e2:	e5a080e7          	jalr	-422(ra) # 5638 <countfree>
    57e6:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57e8:	85ca                	mv	a1,s2
    57ea:	855a                	mv	a0,s6
    57ec:	00000097          	auipc	ra,0x0
    57f0:	df0080e7          	jalr	-528(ra) # 55dc <runtests>
    57f4:	c119                	beqz	a0,57fa <drivetests+0x90>
      if(continuous != 2) {
    57f6:	05599863          	bne	s3,s5,5846 <drivetests+0xdc>
    if(!quick) {
    57fa:	fc0a15e3          	bnez	s4,57c4 <drivetests+0x5a>
      if (justone == 0)
    57fe:	fa090de3          	beqz	s2,57b8 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    5802:	85ca                	mv	a1,s2
    5804:	8562                	mv	a0,s8
    5806:	00000097          	auipc	ra,0x0
    580a:	dd6080e7          	jalr	-554(ra) # 55dc <runtests>
    580e:	d95d                	beqz	a0,57c4 <drivetests+0x5a>
        if(continuous != 2) {
    5810:	03599d63          	bne	s3,s5,584a <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    5814:	00000097          	auipc	ra,0x0
    5818:	e24080e7          	jalr	-476(ra) # 5638 <countfree>
    581c:	fa955ae3          	bge	a0,s1,57d0 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5820:	8626                	mv	a2,s1
    5822:	85aa                	mv	a1,a0
    5824:	8566                	mv	a0,s9
    5826:	00000097          	auipc	ra,0x0
    582a:	74c080e7          	jalr	1868(ra) # 5f72 <printf>
      if(continuous != 2) {
    582e:	b75d                	j	57d4 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5830:	8626                	mv	a2,s1
    5832:	85aa                	mv	a1,a0
    5834:	8566                	mv	a0,s9
    5836:	00000097          	auipc	ra,0x0
    583a:	73c080e7          	jalr	1852(ra) # 5f72 <printf>
      if(continuous != 2) {
    583e:	f9598be3          	beq	s3,s5,57d4 <drivetests+0x6a>
        return 1;
    5842:	4505                	li	a0,1
    5844:	a031                	j	5850 <drivetests+0xe6>
        return 1;
    5846:	4505                	li	a0,1
    5848:	a021                	j	5850 <drivetests+0xe6>
          return 1;
    584a:	4505                	li	a0,1
    584c:	a011                	j	5850 <drivetests+0xe6>
  return 0;
    584e:	854e                	mv	a0,s3
}
    5850:	60e6                	ld	ra,88(sp)
    5852:	6446                	ld	s0,80(sp)
    5854:	64a6                	ld	s1,72(sp)
    5856:	6906                	ld	s2,64(sp)
    5858:	79e2                	ld	s3,56(sp)
    585a:	7a42                	ld	s4,48(sp)
    585c:	7aa2                	ld	s5,40(sp)
    585e:	7b02                	ld	s6,32(sp)
    5860:	6be2                	ld	s7,24(sp)
    5862:	6c42                	ld	s8,16(sp)
    5864:	6ca2                	ld	s9,8(sp)
    5866:	6d02                	ld	s10,0(sp)
    5868:	6125                	addi	sp,sp,96
    586a:	8082                	ret

000000000000586c <main>:

int
main(int argc, char *argv[])
{
    586c:	1101                	addi	sp,sp,-32
    586e:	ec06                	sd	ra,24(sp)
    5870:	e822                	sd	s0,16(sp)
    5872:	e426                	sd	s1,8(sp)
    5874:	e04a                	sd	s2,0(sp)
    5876:	1000                	addi	s0,sp,32
    5878:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    587a:	4789                	li	a5,2
    587c:	02f50363          	beq	a0,a5,58a2 <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5880:	4785                	li	a5,1
    5882:	06a7cd63          	blt	a5,a0,58fc <main+0x90>
  char *justone = 0;
    5886:	4601                	li	a2,0
  int quick = 0;
    5888:	4501                	li	a0,0
  int continuous = 0;
    588a:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    588c:	85a6                	mv	a1,s1
    588e:	00000097          	auipc	ra,0x0
    5892:	edc080e7          	jalr	-292(ra) # 576a <drivetests>
    5896:	c949                	beqz	a0,5928 <main+0xbc>
    exit(1);
    5898:	4505                	li	a0,1
    589a:	00000097          	auipc	ra,0x0
    589e:	338080e7          	jalr	824(ra) # 5bd2 <exit>
    58a2:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a4:	00003597          	auipc	a1,0x3
    58a8:	93458593          	addi	a1,a1,-1740 # 81d8 <malloc+0x21a8>
    58ac:	00893503          	ld	a0,8(s2)
    58b0:	00000097          	auipc	ra,0x0
    58b4:	0c8080e7          	jalr	200(ra) # 5978 <strcmp>
    58b8:	cd39                	beqz	a0,5916 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58ba:	00003597          	auipc	a1,0x3
    58be:	97658593          	addi	a1,a1,-1674 # 8230 <malloc+0x2200>
    58c2:	00893503          	ld	a0,8(s2)
    58c6:	00000097          	auipc	ra,0x0
    58ca:	0b2080e7          	jalr	178(ra) # 5978 <strcmp>
    58ce:	c931                	beqz	a0,5922 <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58d0:	00003597          	auipc	a1,0x3
    58d4:	95858593          	addi	a1,a1,-1704 # 8228 <malloc+0x21f8>
    58d8:	00893503          	ld	a0,8(s2)
    58dc:	00000097          	auipc	ra,0x0
    58e0:	09c080e7          	jalr	156(ra) # 5978 <strcmp>
    58e4:	cd0d                	beqz	a0,591e <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    58e6:	00893603          	ld	a2,8(s2)
    58ea:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x9c>
    58ee:	02d00793          	li	a5,45
    58f2:	00f70563          	beq	a4,a5,58fc <main+0x90>
  int quick = 0;
    58f6:	4501                	li	a0,0
  int continuous = 0;
    58f8:	4481                	li	s1,0
    58fa:	bf49                	j	588c <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58fc:	00003517          	auipc	a0,0x3
    5900:	8e450513          	addi	a0,a0,-1820 # 81e0 <malloc+0x21b0>
    5904:	00000097          	auipc	ra,0x0
    5908:	66e080e7          	jalr	1646(ra) # 5f72 <printf>
    exit(1);
    590c:	4505                	li	a0,1
    590e:	00000097          	auipc	ra,0x0
    5912:	2c4080e7          	jalr	708(ra) # 5bd2 <exit>
  int continuous = 0;
    5916:	84aa                	mv	s1,a0
  char *justone = 0;
    5918:	4601                	li	a2,0
    quick = 1;
    591a:	4505                	li	a0,1
    591c:	bf85                	j	588c <main+0x20>
  char *justone = 0;
    591e:	4601                	li	a2,0
    5920:	b7b5                	j	588c <main+0x20>
    5922:	4601                	li	a2,0
    continuous = 1;
    5924:	4485                	li	s1,1
    5926:	b79d                	j	588c <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5928:	00003517          	auipc	a0,0x3
    592c:	8e850513          	addi	a0,a0,-1816 # 8210 <malloc+0x21e0>
    5930:	00000097          	auipc	ra,0x0
    5934:	642080e7          	jalr	1602(ra) # 5f72 <printf>
  exit(0);
    5938:	4501                	li	a0,0
    593a:	00000097          	auipc	ra,0x0
    593e:	298080e7          	jalr	664(ra) # 5bd2 <exit>

0000000000005942 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5942:	1141                	addi	sp,sp,-16
    5944:	e406                	sd	ra,8(sp)
    5946:	e022                	sd	s0,0(sp)
    5948:	0800                	addi	s0,sp,16
  extern int main();
  main();
    594a:	00000097          	auipc	ra,0x0
    594e:	f22080e7          	jalr	-222(ra) # 586c <main>
  exit(0);
    5952:	4501                	li	a0,0
    5954:	00000097          	auipc	ra,0x0
    5958:	27e080e7          	jalr	638(ra) # 5bd2 <exit>

000000000000595c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    595c:	1141                	addi	sp,sp,-16
    595e:	e422                	sd	s0,8(sp)
    5960:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5962:	87aa                	mv	a5,a0
    5964:	0585                	addi	a1,a1,1
    5966:	0785                	addi	a5,a5,1
    5968:	fff5c703          	lbu	a4,-1(a1)
    596c:	fee78fa3          	sb	a4,-1(a5) # fff <linktest+0x109>
    5970:	fb75                	bnez	a4,5964 <strcpy+0x8>
    ;
  return os;
}
    5972:	6422                	ld	s0,8(sp)
    5974:	0141                	addi	sp,sp,16
    5976:	8082                	ret

0000000000005978 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5978:	1141                	addi	sp,sp,-16
    597a:	e422                	sd	s0,8(sp)
    597c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    597e:	00054783          	lbu	a5,0(a0)
    5982:	cb91                	beqz	a5,5996 <strcmp+0x1e>
    5984:	0005c703          	lbu	a4,0(a1)
    5988:	00f71763          	bne	a4,a5,5996 <strcmp+0x1e>
    p++, q++;
    598c:	0505                	addi	a0,a0,1
    598e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5990:	00054783          	lbu	a5,0(a0)
    5994:	fbe5                	bnez	a5,5984 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5996:	0005c503          	lbu	a0,0(a1)
}
    599a:	40a7853b          	subw	a0,a5,a0
    599e:	6422                	ld	s0,8(sp)
    59a0:	0141                	addi	sp,sp,16
    59a2:	8082                	ret

00000000000059a4 <strlen>:

uint
strlen(const char *s)
{
    59a4:	1141                	addi	sp,sp,-16
    59a6:	e422                	sd	s0,8(sp)
    59a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59aa:	00054783          	lbu	a5,0(a0)
    59ae:	cf91                	beqz	a5,59ca <strlen+0x26>
    59b0:	0505                	addi	a0,a0,1
    59b2:	87aa                	mv	a5,a0
    59b4:	4685                	li	a3,1
    59b6:	9e89                	subw	a3,a3,a0
    59b8:	00f6853b          	addw	a0,a3,a5
    59bc:	0785                	addi	a5,a5,1
    59be:	fff7c703          	lbu	a4,-1(a5)
    59c2:	fb7d                	bnez	a4,59b8 <strlen+0x14>
    ;
  return n;
}
    59c4:	6422                	ld	s0,8(sp)
    59c6:	0141                	addi	sp,sp,16
    59c8:	8082                	ret
  for(n = 0; s[n]; n++)
    59ca:	4501                	li	a0,0
    59cc:	bfe5                	j	59c4 <strlen+0x20>

00000000000059ce <memset>:

void*
memset(void *dst, int c, uint n)
{
    59ce:	1141                	addi	sp,sp,-16
    59d0:	e422                	sd	s0,8(sp)
    59d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59d4:	ce09                	beqz	a2,59ee <memset+0x20>
    59d6:	87aa                	mv	a5,a0
    59d8:	fff6071b          	addiw	a4,a2,-1
    59dc:	1702                	slli	a4,a4,0x20
    59de:	9301                	srli	a4,a4,0x20
    59e0:	0705                	addi	a4,a4,1
    59e2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    59e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59e8:	0785                	addi	a5,a5,1
    59ea:	fee79de3          	bne	a5,a4,59e4 <memset+0x16>
  }
  return dst;
}
    59ee:	6422                	ld	s0,8(sp)
    59f0:	0141                	addi	sp,sp,16
    59f2:	8082                	ret

00000000000059f4 <strchr>:

char*
strchr(const char *s, char c)
{
    59f4:	1141                	addi	sp,sp,-16
    59f6:	e422                	sd	s0,8(sp)
    59f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59fa:	00054783          	lbu	a5,0(a0)
    59fe:	cb99                	beqz	a5,5a14 <strchr+0x20>
    if(*s == c)
    5a00:	00f58763          	beq	a1,a5,5a0e <strchr+0x1a>
  for(; *s; s++)
    5a04:	0505                	addi	a0,a0,1
    5a06:	00054783          	lbu	a5,0(a0)
    5a0a:	fbfd                	bnez	a5,5a00 <strchr+0xc>
      return (char*)s;
  return 0;
    5a0c:	4501                	li	a0,0
}
    5a0e:	6422                	ld	s0,8(sp)
    5a10:	0141                	addi	sp,sp,16
    5a12:	8082                	ret
  return 0;
    5a14:	4501                	li	a0,0
    5a16:	bfe5                	j	5a0e <strchr+0x1a>

0000000000005a18 <gets>:

char*
gets(char *buf, int max)
{
    5a18:	711d                	addi	sp,sp,-96
    5a1a:	ec86                	sd	ra,88(sp)
    5a1c:	e8a2                	sd	s0,80(sp)
    5a1e:	e4a6                	sd	s1,72(sp)
    5a20:	e0ca                	sd	s2,64(sp)
    5a22:	fc4e                	sd	s3,56(sp)
    5a24:	f852                	sd	s4,48(sp)
    5a26:	f456                	sd	s5,40(sp)
    5a28:	f05a                	sd	s6,32(sp)
    5a2a:	ec5e                	sd	s7,24(sp)
    5a2c:	1080                	addi	s0,sp,96
    5a2e:	8baa                	mv	s7,a0
    5a30:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a32:	892a                	mv	s2,a0
    5a34:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a36:	4aa9                	li	s5,10
    5a38:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a3a:	89a6                	mv	s3,s1
    5a3c:	2485                	addiw	s1,s1,1
    5a3e:	0344d863          	bge	s1,s4,5a6e <gets+0x56>
    cc = read(0, &c, 1);
    5a42:	4605                	li	a2,1
    5a44:	faf40593          	addi	a1,s0,-81
    5a48:	4501                	li	a0,0
    5a4a:	00000097          	auipc	ra,0x0
    5a4e:	1a0080e7          	jalr	416(ra) # 5bea <read>
    if(cc < 1)
    5a52:	00a05e63          	blez	a0,5a6e <gets+0x56>
    buf[i++] = c;
    5a56:	faf44783          	lbu	a5,-81(s0)
    5a5a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a5e:	01578763          	beq	a5,s5,5a6c <gets+0x54>
    5a62:	0905                	addi	s2,s2,1
    5a64:	fd679be3          	bne	a5,s6,5a3a <gets+0x22>
  for(i=0; i+1 < max; ){
    5a68:	89a6                	mv	s3,s1
    5a6a:	a011                	j	5a6e <gets+0x56>
    5a6c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a6e:	99de                	add	s3,s3,s7
    5a70:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a74:	855e                	mv	a0,s7
    5a76:	60e6                	ld	ra,88(sp)
    5a78:	6446                	ld	s0,80(sp)
    5a7a:	64a6                	ld	s1,72(sp)
    5a7c:	6906                	ld	s2,64(sp)
    5a7e:	79e2                	ld	s3,56(sp)
    5a80:	7a42                	ld	s4,48(sp)
    5a82:	7aa2                	ld	s5,40(sp)
    5a84:	7b02                	ld	s6,32(sp)
    5a86:	6be2                	ld	s7,24(sp)
    5a88:	6125                	addi	sp,sp,96
    5a8a:	8082                	ret

0000000000005a8c <stat>:

int
stat(const char *n, struct stat *st)
{
    5a8c:	1101                	addi	sp,sp,-32
    5a8e:	ec06                	sd	ra,24(sp)
    5a90:	e822                	sd	s0,16(sp)
    5a92:	e426                	sd	s1,8(sp)
    5a94:	e04a                	sd	s2,0(sp)
    5a96:	1000                	addi	s0,sp,32
    5a98:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a9a:	4581                	li	a1,0
    5a9c:	00000097          	auipc	ra,0x0
    5aa0:	176080e7          	jalr	374(ra) # 5c12 <open>
  if(fd < 0)
    5aa4:	02054563          	bltz	a0,5ace <stat+0x42>
    5aa8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5aaa:	85ca                	mv	a1,s2
    5aac:	00000097          	auipc	ra,0x0
    5ab0:	17e080e7          	jalr	382(ra) # 5c2a <fstat>
    5ab4:	892a                	mv	s2,a0
  close(fd);
    5ab6:	8526                	mv	a0,s1
    5ab8:	00000097          	auipc	ra,0x0
    5abc:	142080e7          	jalr	322(ra) # 5bfa <close>
  return r;
}
    5ac0:	854a                	mv	a0,s2
    5ac2:	60e2                	ld	ra,24(sp)
    5ac4:	6442                	ld	s0,16(sp)
    5ac6:	64a2                	ld	s1,8(sp)
    5ac8:	6902                	ld	s2,0(sp)
    5aca:	6105                	addi	sp,sp,32
    5acc:	8082                	ret
    return -1;
    5ace:	597d                	li	s2,-1
    5ad0:	bfc5                	j	5ac0 <stat+0x34>

0000000000005ad2 <atoi>:

int
atoi(const char *s)
{
    5ad2:	1141                	addi	sp,sp,-16
    5ad4:	e422                	sd	s0,8(sp)
    5ad6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ad8:	00054603          	lbu	a2,0(a0)
    5adc:	fd06079b          	addiw	a5,a2,-48
    5ae0:	0ff7f793          	andi	a5,a5,255
    5ae4:	4725                	li	a4,9
    5ae6:	02f76963          	bltu	a4,a5,5b18 <atoi+0x46>
    5aea:	86aa                	mv	a3,a0
  n = 0;
    5aec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5aee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5af0:	0685                	addi	a3,a3,1
    5af2:	0025179b          	slliw	a5,a0,0x2
    5af6:	9fa9                	addw	a5,a5,a0
    5af8:	0017979b          	slliw	a5,a5,0x1
    5afc:	9fb1                	addw	a5,a5,a2
    5afe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b02:	0006c603          	lbu	a2,0(a3) # 1000 <linktest+0x10a>
    5b06:	fd06071b          	addiw	a4,a2,-48
    5b0a:	0ff77713          	andi	a4,a4,255
    5b0e:	fee5f1e3          	bgeu	a1,a4,5af0 <atoi+0x1e>
  return n;
}
    5b12:	6422                	ld	s0,8(sp)
    5b14:	0141                	addi	sp,sp,16
    5b16:	8082                	ret
  n = 0;
    5b18:	4501                	li	a0,0
    5b1a:	bfe5                	j	5b12 <atoi+0x40>

0000000000005b1c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b1c:	1141                	addi	sp,sp,-16
    5b1e:	e422                	sd	s0,8(sp)
    5b20:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b22:	02b57663          	bgeu	a0,a1,5b4e <memmove+0x32>
    while(n-- > 0)
    5b26:	02c05163          	blez	a2,5b48 <memmove+0x2c>
    5b2a:	fff6079b          	addiw	a5,a2,-1
    5b2e:	1782                	slli	a5,a5,0x20
    5b30:	9381                	srli	a5,a5,0x20
    5b32:	0785                	addi	a5,a5,1
    5b34:	97aa                	add	a5,a5,a0
  dst = vdst;
    5b36:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b38:	0585                	addi	a1,a1,1
    5b3a:	0705                	addi	a4,a4,1
    5b3c:	fff5c683          	lbu	a3,-1(a1)
    5b40:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b44:	fee79ae3          	bne	a5,a4,5b38 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b48:	6422                	ld	s0,8(sp)
    5b4a:	0141                	addi	sp,sp,16
    5b4c:	8082                	ret
    dst += n;
    5b4e:	00c50733          	add	a4,a0,a2
    src += n;
    5b52:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b54:	fec05ae3          	blez	a2,5b48 <memmove+0x2c>
    5b58:	fff6079b          	addiw	a5,a2,-1
    5b5c:	1782                	slli	a5,a5,0x20
    5b5e:	9381                	srli	a5,a5,0x20
    5b60:	fff7c793          	not	a5,a5
    5b64:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b66:	15fd                	addi	a1,a1,-1
    5b68:	177d                	addi	a4,a4,-1
    5b6a:	0005c683          	lbu	a3,0(a1)
    5b6e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b72:	fee79ae3          	bne	a5,a4,5b66 <memmove+0x4a>
    5b76:	bfc9                	j	5b48 <memmove+0x2c>

0000000000005b78 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b78:	1141                	addi	sp,sp,-16
    5b7a:	e422                	sd	s0,8(sp)
    5b7c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b7e:	ca05                	beqz	a2,5bae <memcmp+0x36>
    5b80:	fff6069b          	addiw	a3,a2,-1
    5b84:	1682                	slli	a3,a3,0x20
    5b86:	9281                	srli	a3,a3,0x20
    5b88:	0685                	addi	a3,a3,1
    5b8a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b8c:	00054783          	lbu	a5,0(a0)
    5b90:	0005c703          	lbu	a4,0(a1)
    5b94:	00e79863          	bne	a5,a4,5ba4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b98:	0505                	addi	a0,a0,1
    p2++;
    5b9a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b9c:	fed518e3          	bne	a0,a3,5b8c <memcmp+0x14>
  }
  return 0;
    5ba0:	4501                	li	a0,0
    5ba2:	a019                	j	5ba8 <memcmp+0x30>
      return *p1 - *p2;
    5ba4:	40e7853b          	subw	a0,a5,a4
}
    5ba8:	6422                	ld	s0,8(sp)
    5baa:	0141                	addi	sp,sp,16
    5bac:	8082                	ret
  return 0;
    5bae:	4501                	li	a0,0
    5bb0:	bfe5                	j	5ba8 <memcmp+0x30>

0000000000005bb2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5bb2:	1141                	addi	sp,sp,-16
    5bb4:	e406                	sd	ra,8(sp)
    5bb6:	e022                	sd	s0,0(sp)
    5bb8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bba:	00000097          	auipc	ra,0x0
    5bbe:	f62080e7          	jalr	-158(ra) # 5b1c <memmove>
}
    5bc2:	60a2                	ld	ra,8(sp)
    5bc4:	6402                	ld	s0,0(sp)
    5bc6:	0141                	addi	sp,sp,16
    5bc8:	8082                	ret

0000000000005bca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bca:	4885                	li	a7,1
 ecall
    5bcc:	00000073          	ecall
 ret
    5bd0:	8082                	ret

0000000000005bd2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bd2:	4889                	li	a7,2
 ecall
    5bd4:	00000073          	ecall
 ret
    5bd8:	8082                	ret

0000000000005bda <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bda:	488d                	li	a7,3
 ecall
    5bdc:	00000073          	ecall
 ret
    5be0:	8082                	ret

0000000000005be2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5be2:	4891                	li	a7,4
 ecall
    5be4:	00000073          	ecall
 ret
    5be8:	8082                	ret

0000000000005bea <read>:
.global read
read:
 li a7, SYS_read
    5bea:	4895                	li	a7,5
 ecall
    5bec:	00000073          	ecall
 ret
    5bf0:	8082                	ret

0000000000005bf2 <write>:
.global write
write:
 li a7, SYS_write
    5bf2:	48c1                	li	a7,16
 ecall
    5bf4:	00000073          	ecall
 ret
    5bf8:	8082                	ret

0000000000005bfa <close>:
.global close
close:
 li a7, SYS_close
    5bfa:	48d5                	li	a7,21
 ecall
    5bfc:	00000073          	ecall
 ret
    5c00:	8082                	ret

0000000000005c02 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c02:	4899                	li	a7,6
 ecall
    5c04:	00000073          	ecall
 ret
    5c08:	8082                	ret

0000000000005c0a <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c0a:	489d                	li	a7,7
 ecall
    5c0c:	00000073          	ecall
 ret
    5c10:	8082                	ret

0000000000005c12 <open>:
.global open
open:
 li a7, SYS_open
    5c12:	48bd                	li	a7,15
 ecall
    5c14:	00000073          	ecall
 ret
    5c18:	8082                	ret

0000000000005c1a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c1a:	48c5                	li	a7,17
 ecall
    5c1c:	00000073          	ecall
 ret
    5c20:	8082                	ret

0000000000005c22 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c22:	48c9                	li	a7,18
 ecall
    5c24:	00000073          	ecall
 ret
    5c28:	8082                	ret

0000000000005c2a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c2a:	48a1                	li	a7,8
 ecall
    5c2c:	00000073          	ecall
 ret
    5c30:	8082                	ret

0000000000005c32 <link>:
.global link
link:
 li a7, SYS_link
    5c32:	48cd                	li	a7,19
 ecall
    5c34:	00000073          	ecall
 ret
    5c38:	8082                	ret

0000000000005c3a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c3a:	48d1                	li	a7,20
 ecall
    5c3c:	00000073          	ecall
 ret
    5c40:	8082                	ret

0000000000005c42 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c42:	48a5                	li	a7,9
 ecall
    5c44:	00000073          	ecall
 ret
    5c48:	8082                	ret

0000000000005c4a <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c4a:	48a9                	li	a7,10
 ecall
    5c4c:	00000073          	ecall
 ret
    5c50:	8082                	ret

0000000000005c52 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c52:	48ad                	li	a7,11
 ecall
    5c54:	00000073          	ecall
 ret
    5c58:	8082                	ret

0000000000005c5a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c5a:	48b1                	li	a7,12
 ecall
    5c5c:	00000073          	ecall
 ret
    5c60:	8082                	ret

0000000000005c62 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c62:	48b5                	li	a7,13
 ecall
    5c64:	00000073          	ecall
 ret
    5c68:	8082                	ret

0000000000005c6a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c6a:	48b9                	li	a7,14
 ecall
    5c6c:	00000073          	ecall
 ret
    5c70:	8082                	ret

0000000000005c72 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
    5c72:	48e9                	li	a7,26
 ecall
    5c74:	00000073          	ecall
 ret
    5c78:	8082                	ret

0000000000005c7a <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c7a:	48e5                	li	a7,25
 ecall
    5c7c:	00000073          	ecall
 ret
    5c80:	8082                	ret

0000000000005c82 <trace>:
.global trace
trace:
 li a7, SYS_trace
    5c82:	48d9                	li	a7,22
 ecall
    5c84:	00000073          	ecall
 ret
    5c88:	8082                	ret

0000000000005c8a <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5c8a:	48dd                	li	a7,23
 ecall
    5c8c:	00000073          	ecall
 ret
    5c90:	8082                	ret

0000000000005c92 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5c92:	48e1                	li	a7,24
 ecall
    5c94:	00000073          	ecall
 ret
    5c98:	8082                	ret

0000000000005c9a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c9a:	1101                	addi	sp,sp,-32
    5c9c:	ec06                	sd	ra,24(sp)
    5c9e:	e822                	sd	s0,16(sp)
    5ca0:	1000                	addi	s0,sp,32
    5ca2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5ca6:	4605                	li	a2,1
    5ca8:	fef40593          	addi	a1,s0,-17
    5cac:	00000097          	auipc	ra,0x0
    5cb0:	f46080e7          	jalr	-186(ra) # 5bf2 <write>
}
    5cb4:	60e2                	ld	ra,24(sp)
    5cb6:	6442                	ld	s0,16(sp)
    5cb8:	6105                	addi	sp,sp,32
    5cba:	8082                	ret

0000000000005cbc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cbc:	7139                	addi	sp,sp,-64
    5cbe:	fc06                	sd	ra,56(sp)
    5cc0:	f822                	sd	s0,48(sp)
    5cc2:	f426                	sd	s1,40(sp)
    5cc4:	f04a                	sd	s2,32(sp)
    5cc6:	ec4e                	sd	s3,24(sp)
    5cc8:	0080                	addi	s0,sp,64
    5cca:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5ccc:	c299                	beqz	a3,5cd2 <printint+0x16>
    5cce:	0805c863          	bltz	a1,5d5e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cd2:	2581                	sext.w	a1,a1
  neg = 0;
    5cd4:	4881                	li	a7,0
    5cd6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cda:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cdc:	2601                	sext.w	a2,a2
    5cde:	00003517          	auipc	a0,0x3
    5ce2:	8c250513          	addi	a0,a0,-1854 # 85a0 <digits>
    5ce6:	883a                	mv	a6,a4
    5ce8:	2705                	addiw	a4,a4,1
    5cea:	02c5f7bb          	remuw	a5,a1,a2
    5cee:	1782                	slli	a5,a5,0x20
    5cf0:	9381                	srli	a5,a5,0x20
    5cf2:	97aa                	add	a5,a5,a0
    5cf4:	0007c783          	lbu	a5,0(a5)
    5cf8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cfc:	0005879b          	sext.w	a5,a1
    5d00:	02c5d5bb          	divuw	a1,a1,a2
    5d04:	0685                	addi	a3,a3,1
    5d06:	fec7f0e3          	bgeu	a5,a2,5ce6 <printint+0x2a>
  if(neg)
    5d0a:	00088b63          	beqz	a7,5d20 <printint+0x64>
    buf[i++] = '-';
    5d0e:	fd040793          	addi	a5,s0,-48
    5d12:	973e                	add	a4,a4,a5
    5d14:	02d00793          	li	a5,45
    5d18:	fef70823          	sb	a5,-16(a4)
    5d1c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d20:	02e05863          	blez	a4,5d50 <printint+0x94>
    5d24:	fc040793          	addi	a5,s0,-64
    5d28:	00e78933          	add	s2,a5,a4
    5d2c:	fff78993          	addi	s3,a5,-1
    5d30:	99ba                	add	s3,s3,a4
    5d32:	377d                	addiw	a4,a4,-1
    5d34:	1702                	slli	a4,a4,0x20
    5d36:	9301                	srli	a4,a4,0x20
    5d38:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d3c:	fff94583          	lbu	a1,-1(s2)
    5d40:	8526                	mv	a0,s1
    5d42:	00000097          	auipc	ra,0x0
    5d46:	f58080e7          	jalr	-168(ra) # 5c9a <putc>
  while(--i >= 0)
    5d4a:	197d                	addi	s2,s2,-1
    5d4c:	ff3918e3          	bne	s2,s3,5d3c <printint+0x80>
}
    5d50:	70e2                	ld	ra,56(sp)
    5d52:	7442                	ld	s0,48(sp)
    5d54:	74a2                	ld	s1,40(sp)
    5d56:	7902                	ld	s2,32(sp)
    5d58:	69e2                	ld	s3,24(sp)
    5d5a:	6121                	addi	sp,sp,64
    5d5c:	8082                	ret
    x = -xx;
    5d5e:	40b005bb          	negw	a1,a1
    neg = 1;
    5d62:	4885                	li	a7,1
    x = -xx;
    5d64:	bf8d                	j	5cd6 <printint+0x1a>

0000000000005d66 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d66:	7119                	addi	sp,sp,-128
    5d68:	fc86                	sd	ra,120(sp)
    5d6a:	f8a2                	sd	s0,112(sp)
    5d6c:	f4a6                	sd	s1,104(sp)
    5d6e:	f0ca                	sd	s2,96(sp)
    5d70:	ecce                	sd	s3,88(sp)
    5d72:	e8d2                	sd	s4,80(sp)
    5d74:	e4d6                	sd	s5,72(sp)
    5d76:	e0da                	sd	s6,64(sp)
    5d78:	fc5e                	sd	s7,56(sp)
    5d7a:	f862                	sd	s8,48(sp)
    5d7c:	f466                	sd	s9,40(sp)
    5d7e:	f06a                	sd	s10,32(sp)
    5d80:	ec6e                	sd	s11,24(sp)
    5d82:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d84:	0005c903          	lbu	s2,0(a1)
    5d88:	18090f63          	beqz	s2,5f26 <vprintf+0x1c0>
    5d8c:	8aaa                	mv	s5,a0
    5d8e:	8b32                	mv	s6,a2
    5d90:	00158493          	addi	s1,a1,1
  state = 0;
    5d94:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d96:	02500a13          	li	s4,37
      if(c == 'd'){
    5d9a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5d9e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5da2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5da6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5daa:	00002b97          	auipc	s7,0x2
    5dae:	7f6b8b93          	addi	s7,s7,2038 # 85a0 <digits>
    5db2:	a839                	j	5dd0 <vprintf+0x6a>
        putc(fd, c);
    5db4:	85ca                	mv	a1,s2
    5db6:	8556                	mv	a0,s5
    5db8:	00000097          	auipc	ra,0x0
    5dbc:	ee2080e7          	jalr	-286(ra) # 5c9a <putc>
    5dc0:	a019                	j	5dc6 <vprintf+0x60>
    } else if(state == '%'){
    5dc2:	01498f63          	beq	s3,s4,5de0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5dc6:	0485                	addi	s1,s1,1
    5dc8:	fff4c903          	lbu	s2,-1(s1)
    5dcc:	14090d63          	beqz	s2,5f26 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5dd0:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5dd4:	fe0997e3          	bnez	s3,5dc2 <vprintf+0x5c>
      if(c == '%'){
    5dd8:	fd479ee3          	bne	a5,s4,5db4 <vprintf+0x4e>
        state = '%';
    5ddc:	89be                	mv	s3,a5
    5dde:	b7e5                	j	5dc6 <vprintf+0x60>
      if(c == 'd'){
    5de0:	05878063          	beq	a5,s8,5e20 <vprintf+0xba>
      } else if(c == 'l') {
    5de4:	05978c63          	beq	a5,s9,5e3c <vprintf+0xd6>
      } else if(c == 'x') {
    5de8:	07a78863          	beq	a5,s10,5e58 <vprintf+0xf2>
      } else if(c == 'p') {
    5dec:	09b78463          	beq	a5,s11,5e74 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5df0:	07300713          	li	a4,115
    5df4:	0ce78663          	beq	a5,a4,5ec0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5df8:	06300713          	li	a4,99
    5dfc:	0ee78e63          	beq	a5,a4,5ef8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5e00:	11478863          	beq	a5,s4,5f10 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5e04:	85d2                	mv	a1,s4
    5e06:	8556                	mv	a0,s5
    5e08:	00000097          	auipc	ra,0x0
    5e0c:	e92080e7          	jalr	-366(ra) # 5c9a <putc>
        putc(fd, c);
    5e10:	85ca                	mv	a1,s2
    5e12:	8556                	mv	a0,s5
    5e14:	00000097          	auipc	ra,0x0
    5e18:	e86080e7          	jalr	-378(ra) # 5c9a <putc>
      }
      state = 0;
    5e1c:	4981                	li	s3,0
    5e1e:	b765                	j	5dc6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5e20:	008b0913          	addi	s2,s6,8
    5e24:	4685                	li	a3,1
    5e26:	4629                	li	a2,10
    5e28:	000b2583          	lw	a1,0(s6)
    5e2c:	8556                	mv	a0,s5
    5e2e:	00000097          	auipc	ra,0x0
    5e32:	e8e080e7          	jalr	-370(ra) # 5cbc <printint>
    5e36:	8b4a                	mv	s6,s2
      state = 0;
    5e38:	4981                	li	s3,0
    5e3a:	b771                	j	5dc6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e3c:	008b0913          	addi	s2,s6,8
    5e40:	4681                	li	a3,0
    5e42:	4629                	li	a2,10
    5e44:	000b2583          	lw	a1,0(s6)
    5e48:	8556                	mv	a0,s5
    5e4a:	00000097          	auipc	ra,0x0
    5e4e:	e72080e7          	jalr	-398(ra) # 5cbc <printint>
    5e52:	8b4a                	mv	s6,s2
      state = 0;
    5e54:	4981                	li	s3,0
    5e56:	bf85                	j	5dc6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e58:	008b0913          	addi	s2,s6,8
    5e5c:	4681                	li	a3,0
    5e5e:	4641                	li	a2,16
    5e60:	000b2583          	lw	a1,0(s6)
    5e64:	8556                	mv	a0,s5
    5e66:	00000097          	auipc	ra,0x0
    5e6a:	e56080e7          	jalr	-426(ra) # 5cbc <printint>
    5e6e:	8b4a                	mv	s6,s2
      state = 0;
    5e70:	4981                	li	s3,0
    5e72:	bf91                	j	5dc6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e74:	008b0793          	addi	a5,s6,8
    5e78:	f8f43423          	sd	a5,-120(s0)
    5e7c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e80:	03000593          	li	a1,48
    5e84:	8556                	mv	a0,s5
    5e86:	00000097          	auipc	ra,0x0
    5e8a:	e14080e7          	jalr	-492(ra) # 5c9a <putc>
  putc(fd, 'x');
    5e8e:	85ea                	mv	a1,s10
    5e90:	8556                	mv	a0,s5
    5e92:	00000097          	auipc	ra,0x0
    5e96:	e08080e7          	jalr	-504(ra) # 5c9a <putc>
    5e9a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e9c:	03c9d793          	srli	a5,s3,0x3c
    5ea0:	97de                	add	a5,a5,s7
    5ea2:	0007c583          	lbu	a1,0(a5)
    5ea6:	8556                	mv	a0,s5
    5ea8:	00000097          	auipc	ra,0x0
    5eac:	df2080e7          	jalr	-526(ra) # 5c9a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5eb0:	0992                	slli	s3,s3,0x4
    5eb2:	397d                	addiw	s2,s2,-1
    5eb4:	fe0914e3          	bnez	s2,5e9c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5eb8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5ebc:	4981                	li	s3,0
    5ebe:	b721                	j	5dc6 <vprintf+0x60>
        s = va_arg(ap, char*);
    5ec0:	008b0993          	addi	s3,s6,8
    5ec4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5ec8:	02090163          	beqz	s2,5eea <vprintf+0x184>
        while(*s != 0){
    5ecc:	00094583          	lbu	a1,0(s2)
    5ed0:	c9a1                	beqz	a1,5f20 <vprintf+0x1ba>
          putc(fd, *s);
    5ed2:	8556                	mv	a0,s5
    5ed4:	00000097          	auipc	ra,0x0
    5ed8:	dc6080e7          	jalr	-570(ra) # 5c9a <putc>
          s++;
    5edc:	0905                	addi	s2,s2,1
        while(*s != 0){
    5ede:	00094583          	lbu	a1,0(s2)
    5ee2:	f9e5                	bnez	a1,5ed2 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5ee4:	8b4e                	mv	s6,s3
      state = 0;
    5ee6:	4981                	li	s3,0
    5ee8:	bdf9                	j	5dc6 <vprintf+0x60>
          s = "(null)";
    5eea:	00002917          	auipc	s2,0x2
    5eee:	6ae90913          	addi	s2,s2,1710 # 8598 <malloc+0x2568>
        while(*s != 0){
    5ef2:	02800593          	li	a1,40
    5ef6:	bff1                	j	5ed2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5ef8:	008b0913          	addi	s2,s6,8
    5efc:	000b4583          	lbu	a1,0(s6)
    5f00:	8556                	mv	a0,s5
    5f02:	00000097          	auipc	ra,0x0
    5f06:	d98080e7          	jalr	-616(ra) # 5c9a <putc>
    5f0a:	8b4a                	mv	s6,s2
      state = 0;
    5f0c:	4981                	li	s3,0
    5f0e:	bd65                	j	5dc6 <vprintf+0x60>
        putc(fd, c);
    5f10:	85d2                	mv	a1,s4
    5f12:	8556                	mv	a0,s5
    5f14:	00000097          	auipc	ra,0x0
    5f18:	d86080e7          	jalr	-634(ra) # 5c9a <putc>
      state = 0;
    5f1c:	4981                	li	s3,0
    5f1e:	b565                	j	5dc6 <vprintf+0x60>
        s = va_arg(ap, char*);
    5f20:	8b4e                	mv	s6,s3
      state = 0;
    5f22:	4981                	li	s3,0
    5f24:	b54d                	j	5dc6 <vprintf+0x60>
    }
  }
}
    5f26:	70e6                	ld	ra,120(sp)
    5f28:	7446                	ld	s0,112(sp)
    5f2a:	74a6                	ld	s1,104(sp)
    5f2c:	7906                	ld	s2,96(sp)
    5f2e:	69e6                	ld	s3,88(sp)
    5f30:	6a46                	ld	s4,80(sp)
    5f32:	6aa6                	ld	s5,72(sp)
    5f34:	6b06                	ld	s6,64(sp)
    5f36:	7be2                	ld	s7,56(sp)
    5f38:	7c42                	ld	s8,48(sp)
    5f3a:	7ca2                	ld	s9,40(sp)
    5f3c:	7d02                	ld	s10,32(sp)
    5f3e:	6de2                	ld	s11,24(sp)
    5f40:	6109                	addi	sp,sp,128
    5f42:	8082                	ret

0000000000005f44 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f44:	715d                	addi	sp,sp,-80
    5f46:	ec06                	sd	ra,24(sp)
    5f48:	e822                	sd	s0,16(sp)
    5f4a:	1000                	addi	s0,sp,32
    5f4c:	e010                	sd	a2,0(s0)
    5f4e:	e414                	sd	a3,8(s0)
    5f50:	e818                	sd	a4,16(s0)
    5f52:	ec1c                	sd	a5,24(s0)
    5f54:	03043023          	sd	a6,32(s0)
    5f58:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f5c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f60:	8622                	mv	a2,s0
    5f62:	00000097          	auipc	ra,0x0
    5f66:	e04080e7          	jalr	-508(ra) # 5d66 <vprintf>
}
    5f6a:	60e2                	ld	ra,24(sp)
    5f6c:	6442                	ld	s0,16(sp)
    5f6e:	6161                	addi	sp,sp,80
    5f70:	8082                	ret

0000000000005f72 <printf>:

void
printf(const char *fmt, ...)
{
    5f72:	711d                	addi	sp,sp,-96
    5f74:	ec06                	sd	ra,24(sp)
    5f76:	e822                	sd	s0,16(sp)
    5f78:	1000                	addi	s0,sp,32
    5f7a:	e40c                	sd	a1,8(s0)
    5f7c:	e810                	sd	a2,16(s0)
    5f7e:	ec14                	sd	a3,24(s0)
    5f80:	f018                	sd	a4,32(s0)
    5f82:	f41c                	sd	a5,40(s0)
    5f84:	03043823          	sd	a6,48(s0)
    5f88:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f8c:	00840613          	addi	a2,s0,8
    5f90:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f94:	85aa                	mv	a1,a0
    5f96:	4505                	li	a0,1
    5f98:	00000097          	auipc	ra,0x0
    5f9c:	dce080e7          	jalr	-562(ra) # 5d66 <vprintf>
}
    5fa0:	60e2                	ld	ra,24(sp)
    5fa2:	6442                	ld	s0,16(sp)
    5fa4:	6125                	addi	sp,sp,96
    5fa6:	8082                	ret

0000000000005fa8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fa8:	1141                	addi	sp,sp,-16
    5faa:	e422                	sd	s0,8(sp)
    5fac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fb2:	00003797          	auipc	a5,0x3
    5fb6:	49e7b783          	ld	a5,1182(a5) # 9450 <freep>
    5fba:	a805                	j	5fea <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fbc:	4618                	lw	a4,8(a2)
    5fbe:	9db9                	addw	a1,a1,a4
    5fc0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fc4:	6398                	ld	a4,0(a5)
    5fc6:	6318                	ld	a4,0(a4)
    5fc8:	fee53823          	sd	a4,-16(a0)
    5fcc:	a091                	j	6010 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fce:	ff852703          	lw	a4,-8(a0)
    5fd2:	9e39                	addw	a2,a2,a4
    5fd4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5fd6:	ff053703          	ld	a4,-16(a0)
    5fda:	e398                	sd	a4,0(a5)
    5fdc:	a099                	j	6022 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fde:	6398                	ld	a4,0(a5)
    5fe0:	00e7e463          	bltu	a5,a4,5fe8 <free+0x40>
    5fe4:	00e6ea63          	bltu	a3,a4,5ff8 <free+0x50>
{
    5fe8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fea:	fed7fae3          	bgeu	a5,a3,5fde <free+0x36>
    5fee:	6398                	ld	a4,0(a5)
    5ff0:	00e6e463          	bltu	a3,a4,5ff8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5ff4:	fee7eae3          	bltu	a5,a4,5fe8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5ff8:	ff852583          	lw	a1,-8(a0)
    5ffc:	6390                	ld	a2,0(a5)
    5ffe:	02059713          	slli	a4,a1,0x20
    6002:	9301                	srli	a4,a4,0x20
    6004:	0712                	slli	a4,a4,0x4
    6006:	9736                	add	a4,a4,a3
    6008:	fae60ae3          	beq	a2,a4,5fbc <free+0x14>
    bp->s.ptr = p->s.ptr;
    600c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6010:	4790                	lw	a2,8(a5)
    6012:	02061713          	slli	a4,a2,0x20
    6016:	9301                	srli	a4,a4,0x20
    6018:	0712                	slli	a4,a4,0x4
    601a:	973e                	add	a4,a4,a5
    601c:	fae689e3          	beq	a3,a4,5fce <free+0x26>
  } else
    p->s.ptr = bp;
    6020:	e394                	sd	a3,0(a5)
  freep = p;
    6022:	00003717          	auipc	a4,0x3
    6026:	42f73723          	sd	a5,1070(a4) # 9450 <freep>
}
    602a:	6422                	ld	s0,8(sp)
    602c:	0141                	addi	sp,sp,16
    602e:	8082                	ret

0000000000006030 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6030:	7139                	addi	sp,sp,-64
    6032:	fc06                	sd	ra,56(sp)
    6034:	f822                	sd	s0,48(sp)
    6036:	f426                	sd	s1,40(sp)
    6038:	f04a                	sd	s2,32(sp)
    603a:	ec4e                	sd	s3,24(sp)
    603c:	e852                	sd	s4,16(sp)
    603e:	e456                	sd	s5,8(sp)
    6040:	e05a                	sd	s6,0(sp)
    6042:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6044:	02051493          	slli	s1,a0,0x20
    6048:	9081                	srli	s1,s1,0x20
    604a:	04bd                	addi	s1,s1,15
    604c:	8091                	srli	s1,s1,0x4
    604e:	0014899b          	addiw	s3,s1,1
    6052:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6054:	00003517          	auipc	a0,0x3
    6058:	3fc53503          	ld	a0,1020(a0) # 9450 <freep>
    605c:	c515                	beqz	a0,6088 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    605e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6060:	4798                	lw	a4,8(a5)
    6062:	02977f63          	bgeu	a4,s1,60a0 <malloc+0x70>
    6066:	8a4e                	mv	s4,s3
    6068:	0009871b          	sext.w	a4,s3
    606c:	6685                	lui	a3,0x1
    606e:	00d77363          	bgeu	a4,a3,6074 <malloc+0x44>
    6072:	6a05                	lui	s4,0x1
    6074:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6078:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    607c:	00003917          	auipc	s2,0x3
    6080:	3d490913          	addi	s2,s2,980 # 9450 <freep>
  if(p == (char*)-1)
    6084:	5afd                	li	s5,-1
    6086:	a88d                	j	60f8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6088:	0000a797          	auipc	a5,0xa
    608c:	bf078793          	addi	a5,a5,-1040 # fc78 <base>
    6090:	00003717          	auipc	a4,0x3
    6094:	3cf73023          	sd	a5,960(a4) # 9450 <freep>
    6098:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    609a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    609e:	b7e1                	j	6066 <malloc+0x36>
      if(p->s.size == nunits)
    60a0:	02e48b63          	beq	s1,a4,60d6 <malloc+0xa6>
        p->s.size -= nunits;
    60a4:	4137073b          	subw	a4,a4,s3
    60a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    60aa:	1702                	slli	a4,a4,0x20
    60ac:	9301                	srli	a4,a4,0x20
    60ae:	0712                	slli	a4,a4,0x4
    60b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60b6:	00003717          	auipc	a4,0x3
    60ba:	38a73d23          	sd	a0,922(a4) # 9450 <freep>
      return (void*)(p + 1);
    60be:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    60c2:	70e2                	ld	ra,56(sp)
    60c4:	7442                	ld	s0,48(sp)
    60c6:	74a2                	ld	s1,40(sp)
    60c8:	7902                	ld	s2,32(sp)
    60ca:	69e2                	ld	s3,24(sp)
    60cc:	6a42                	ld	s4,16(sp)
    60ce:	6aa2                	ld	s5,8(sp)
    60d0:	6b02                	ld	s6,0(sp)
    60d2:	6121                	addi	sp,sp,64
    60d4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60d6:	6398                	ld	a4,0(a5)
    60d8:	e118                	sd	a4,0(a0)
    60da:	bff1                	j	60b6 <malloc+0x86>
  hp->s.size = nu;
    60dc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60e0:	0541                	addi	a0,a0,16
    60e2:	00000097          	auipc	ra,0x0
    60e6:	ec6080e7          	jalr	-314(ra) # 5fa8 <free>
  return freep;
    60ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60ee:	d971                	beqz	a0,60c2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60f2:	4798                	lw	a4,8(a5)
    60f4:	fa9776e3          	bgeu	a4,s1,60a0 <malloc+0x70>
    if(p == freep)
    60f8:	00093703          	ld	a4,0(s2)
    60fc:	853e                	mv	a0,a5
    60fe:	fef719e3          	bne	a4,a5,60f0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    6102:	8552                	mv	a0,s4
    6104:	00000097          	auipc	ra,0x0
    6108:	b56080e7          	jalr	-1194(ra) # 5c5a <sbrk>
  if(p == (char*)-1)
    610c:	fd5518e3          	bne	a0,s5,60dc <malloc+0xac>
        return 0;
    6110:	4501                	li	a0,0
    6112:	bf45                	j	60c2 <malloc+0x92>
