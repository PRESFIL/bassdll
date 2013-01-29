/* 
 * Copyright (c) 2010 Drew Crawford
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#include <bassdll.h>
#include <debug.h>

mixer m;
channel pin12 (10,1);
channel pin11 (11,1);
channel pin10 (13,1);

#define EIGHTH 10
#define KICK_LEN 9
#define SNARE_LEN 7

//pt 3
#define kick  note(KICK, KICK_LEN), note(REST, EIGHTH-KICK_LEN),
#define snare note(SNARE, SNARE_LEN), note(REST, EIGHTH-SNARE_LEN),
#define rest  note(REST, EIGHTH),

note drum_loop[] = {
  kick rest rest kick
  rest rest kick rest
  rest rest kick rest
  snare rest kick rest 

  kick rest rest kick
  rest rest kick rest
  rest rest kick kick
  snare rest kick rest

  kick rest rest kick
  rest rest kick rest
  rest rest kick rest
  snare rest kick rest

  kick rest rest kick
  rest rest kick rest
  rest rest kick kick
  snare rest snare rest
};

#define gsharp      note(-13, EIGHTH),
#define gsharp4     note(-13, 4*EIGHTH),
#define gsharp2low  note(-25, 2*EIGHTH),
#define gsharp2high note(-13, 2*EIGHTH),
#define transpose   note(TRANSPOSEUP, 0),
#define transposed  note(TRANSPOSEDOWN, 0),  
#define g2          note(-14, 2*EIGHTH),
#define c           note(-9, EIGHTH),
#define c4          note(-9, 4*EIGHTH),
#define c2          note(-9, 2*EIGHTH),
#define lowc        note(-21, EIGHTH),
#define lowc4       note(-21, 4*EIGHTH),

note part3_bassline[] = {
  gsharp rest rest gsharp rest rest
  gsharp4 gsharp2low gsharp2high gsharp2low
  transpose transpose
  gsharp rest rest gsharp rest rest
  gsharp4 gsharp2low gsharp2high gsharp2low
  transposed transposed
  c rest rest c rest rest
  c4 g2 c2 g2
  lowc rest rest lowc rest rest
  lowc4 g2 c2 g2
};

//sky notes

#define sc       note(3,  EIGHTH),
#define sgsharp  note(-1, EIGHTH),
#define sf       note(-4, EIGHTH),
#define sasharp  note(1,  EIGHTH),
#define sg       note(-2, EIGHTH),
#define se       note(-5, EIGHTH),
#define sdu      note(5,  EIGHTH),
#define seu      note(7,  EIGHTH),
#define sfu      note(8,  EIGHTH),
#define scd      note(-9, EIGHTH),
#define sgu      note(10, EIGHTH),
#define scu      note(15, EIGHTH),
#define sbu      note(14, EIGHTH),
#define sd       note(-7, EIGHTH),
#define stop     note(STOP, 0),
#define sgsharpu note(11, EIGHTH),
#define sasharpu note(13, EIGHTH),
#define sduu     note(17, EIGHTH),
#define seuu     note(19, EIGHTH),
#define sguu     note(22, EIGHTH),
#define nulln    note(REST, EIGHTH * 16),
#define scuu     note(27, EIGHTH * 16),

note part3_sky[] = {
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  
  sc sasharp sf sgsharp
  sc sasharp sf sgsharp
  sc sasharp sf sgsharp
  sc sasharp sf sgsharp

  sc sg se sg
  sc sg se sg
  sc sg se sg
  sdu sg se sg
  
  seu sg se sg
  sfu sg se sg
  seu sg se sg
  sdu sg se sg

  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sdu sgsharp sf sgsharp
  seu sgsharp sf sgsharp
  
  sc sasharp sf sgsharp
  sc sasharp sf sgsharp
  sdu sasharp sf sgsharp
  seu sasharp sf sgsharp

  //SLIDE TIME
  seu sc sg se
  scd se sg sc
  ///
  seu sgu seu sc
  sg se sg sc
  
  seu sc sgu sc
  scu sbu sgu seu
  sc sg se sg
  sc sg sc sd
  // old stop
 
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sc sdu sc sgsharp
  sf sgsharp sc sg
  ///
  sc sasharp sf sasharp
  sc sfu sc sasharp
  sf sasharp sc sfu
  sgsharpu sfu sc sfu 
  //now measure 35
  sc sg se sg
  sc seu sgu scu
  sgu seu sc sg
  se scd se sg
  //36
  sc seu sgu scu
  sgu seu sc sg
  sc sgu sc scu
  sgu sc scu sc
  //37
  scu sgsharpu sfu sgsharpu
  scu sgsharpu sfu sgsharpu
  scu sgsharpu sfu sgsharpu
  scu sgsharpu sfu sgsharpu
  //38
  sduu sasharpu sfu sasharpu
  sduu sasharpu sfu sasharpu
  sduu sasharpu sfu sasharpu
  sduu sasharpu sfu sasharpu
  
  seuu scu sgu seu
  sc seu sgu scu
  seuu sguu seuu scu
  sgu scu seuu scu
  stop
};

note part3_null[] = {
  nulln
};
note part3_end[] = {
  scuu stop
};

void pt3(channel &drums, channel &bassline, channel& sky)
{
  drums.notes = drum_loop;
  drums.insert_at = NELEMENTS(drum_loop);
  bassline.notes = part3_bassline;
  bassline.insert_at = NELEMENTS(part3_bassline);
  sky.notes = part3_sky;
  sky.insert_at = NELEMENTS(part3_sky);  
  m.play();

  drums.notes = part3_null;
  drums.insert_at = NELEMENTS(part3_null);
  bassline.notes = part3_null;
  bassline.insert_at = NELEMENTS(part3_null);
  sky.notes = part3_end;
  sky.insert_at = NELEMENTS(part3_end);
  m.play();
}

#define sc note(27, EIGHTH),
#define sg note(22, EIGHTH),
#define se note(19, EIGHTH),
#define sgsharp note(23, EIGHTH),
#define sf note(20, EIGHTH),
#define sd note(29, EIGHTH),
#define sasharp note(25, EIGHTH),
#define mclong note(3, EIGHTH * 10),
#define melong note(7, EIGHTH * 10),
#define mg note(-2, EIGHTH * 2),
#define hg note(10, EIGHTH*2),
#define mc note(3, EIGHTH * 2),
#define me note(7, EIGHTH * 2),
#define mf note(8, EIGHTH * 4),
#define md4 note(5, EIGHTH * 4),
#define me4 note(7, EIGHTH * 4),
#define mc4 note(3, EIGHTH * 4),
#define mchold note(3, EIGHTH * 24),
#define mchold2 note(3, EIGHTH*10),
#define mghold note(10, EIGHTH * 24),
#define mghold2 note(10, EIGHTH*10),
#define ma4 note(12, EIGHTH * 4),
#define mg4 note(10, EIGHTH * 4),
#define mgsharphold note(11, EIGHTH * 18), 
#define masharphold note(13, EIGHTH * 16),
#define mfhold note(8, EIGHTH * 16), 

note part1_skyline[] = {
  sc sg se sg
  sc sg se sg
  sc sg se sg
  sc sg se sg

  sc sg se sg
  sc sg se sg
  sc sg se sg
  sc sg se sg

  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp

  sc sasharp sf sasharp 
  sc sasharp sf sasharp 
  sc sasharp sf sasharp 
  sc sasharp sf sasharp 

  sc sg se sg
  sc sg se sg
  sc sg se sg
  sc sg se sg

  sc sg se sg
  sc sg se sg
  sc sg se sg
  sc sg se sg

  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp
  sc sgsharp sf sgsharp

  sd sasharp sf sasharp
  sd sasharp sf sasharp
  sd sasharp sf sasharp
  sd sasharp sf sasharp
  sc
};


note part1_melody[] = {
  mclong
  mg
  mc
  me
  mf
  me
  md4
  me4
  mchold
  mchold2

  mclong
  mg
  mc
  me
  mf
  me
  md4
  mc4
  mghold
  mghold2
  
  stop
};


note part1_harmony[] = {
  transposed transposed transposed transposed transposed transposed
  transposed transposed transposed transposed transposed transposed

  melong
  mc
  me
  hg
  ma4
  hg
  mf

  mg4
  mgsharphold
  mfhold

  melong
  mc
  me
  hg
  ma4
  hg
  mf

  me4
  mgsharphold
  masharphold
};

void pt1(channel& melody, channel& harmony, channel& skyline)
{
  melody.notes = part1_melody;
  melody.insert_at = NELEMENTS(part1_melody);
  harmony.notes = part1_harmony;
  harmony.insert_at = NELEMENTS(part1_harmony);
  skyline.notes = part1_skyline;
  skyline.insert_at = NELEMENTS(part1_skyline);
  m.play();
}

#define bc note(-21, EIGHTH),
#define bc2 note(-21, EIGHTH * 2),
#define bchigh note(-9, EIGHTH * 2),
#define bgsharp note(-13, EIGHTH * 2),
#define basharp note(-11, EIGHTH * 2),

note part2_bassline[] = {
  bc2 rest
  bc2 rest 
  bc2 rest
  rest bc2
  
  bchigh bc2

  bc2 rest
  bc2 rest
  bc2 rest
  rest bc2

  bchigh bc2
  
  bgsharp rest
  bgsharp rest
  bgsharp rest
  rest bgsharp

  bchigh bgsharp
  
  basharp rest
  basharp rest
  basharp rest
  rest basharp
  
  bchigh bgsharp  
};

#define mch note(-9, EIGHTH*10),
#define mg note(-14, EIGHTH*2),
#define mg4 note(-14, EIGHTH*4),
#define mg1 note(-14, EIGHTH*1),
#define mgold note(-2, EIGHTH * 12),
#define mc note(-9, EIGHTH * 2),
#define mcsharp1 note(-8, EIGHTH),
#define mc1 note(-9, EIGHTH * 1),
#define mcl note(-21, EIGHTH * 2),
#define mc4 note(-9, EIGHTH * 4),
#define me note(-5, EIGHTH * 2),
#define me1 note(-5, EIGHTH * 1),
#define mel8 note(-17, EIGHTH * 8),
#define mf4 note(-4, EIGHTH * 4),
#define mfl1 note(-16, EIGHTH),
#define mf note(-4, EIGHTH * 2),
#define mf1 note(-4, EIGHTH),
#define md1 note(-7, EIGHTH),
#define mdl note(-19, EIGHTH * 2),
#define md4 note(-7, EIGHTH * 4),
#define me4 note(-5, EIGHTH * 4),
#define mchh note(-9, EIGHTH * 14),
#define mcsecondhh note(-9, EIGHTH * 8),
#define soloON note(SUPERSOLO, 1),
#define soloOFF note(SUPERSOLO, 0),
#define mgsharp note(-13, 2 * EIGHTH),
#define mgsharp10 note(-13, 10 * EIGHTH),
#define frest note(REST, EIGHTH / 2),
#define moreSOLO note(SUPERSOLO, 1),
#define stop note(STOP, 0),

note part2_melody[] = {
  mch mg mc me mf4 me md4
  me soloON me soloOFF mchh
  rest rest rest rest
  //m12
  mc4 mgsharp mc4 md4 mc  
  mch mg mc me
  //m13
  mf4 me md4 mc4 mc
  //m14
  mgold mf me
  //m15
  mf1 me1 mc1 mg1 mg4 mg4
  ///
  mf1 me1 moreSOLO mc1 mg1 soloOFF
  //again
  mch mg mc me mf4 me md4
  me
  moreSOLO me1 me1 md1 mcsharp1 soloOFF
  mcsecondhh
  mc mg mc mg mgsharp10 mfl1 mfl1 mgsharp mc
  mg4 mg mc4
  mg mc me mf4 me md4 mc4 rest mc1
  mgold mf me
  mf1 me1 mc1 mfl1 mel8 mdl mcl
  stop
};

void pt2(channel& melody, channel& bassline, channel& drums)
{
  drums.notes = drum_loop;
  drums.insert_at = NELEMENTS(drum_loop);
  bassline.notes = part2_bassline;
  bassline.insert_at = NELEMENTS(part2_bassline);
  melody.notes = part2_melody;
  melody.insert_at = NELEMENTS(part2_melody);
  m.play();
}

void setup(){
  m.add_channel(&pin10);
  m.add_channel(&pin11);
  m.add_channel(&pin12); //LOUD PIN
}

void loop() {
  pt1(pin10,pin11,pin12);
  pt2(pin12,pin11,pin10);
  pt3(pin12,pin11,pin10);
}
