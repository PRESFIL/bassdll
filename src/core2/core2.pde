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
channel pin12 (12,1);
channel pin11 (11,1);
channel pin10 (10,1);

#define EIGHTH 10
#define KICK_LEN 9
#define SNARE_LEN 7

//pt 3
#define kick  NOTE(KICK, KICK_LEN), NOTE(REST, EIGHTH-KICK_LEN),
#define snare NOTE(SNARE, SNARE_LEN), NOTE(REST, EIGHTH-SNARE_LEN),
#define rest  NOTE(REST, EIGHTH),

PATTERN(drum_loop) = {
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

#define gsharp      NOTE(-13, EIGHTH),
#define gsharp4     NOTE(-13, 4*EIGHTH),
#define gsharp2low  NOTE(-25, 2*EIGHTH),
#define gsharp2high NOTE(-13, 2*EIGHTH),
#define transpose   NOTE(TRANSPOSEUP, 0),
#define transposed  NOTE(TRANSPOSEDOWN, 0),  
#define g2          NOTE(-14, 2*EIGHTH),
#define c           NOTE(-9, EIGHTH),
#define c4          NOTE(-9, 4*EIGHTH),
#define c2          NOTE(-9, 2*EIGHTH),
#define lowc        NOTE(-21, EIGHTH),
#define lowc4       NOTE(-21, 4*EIGHTH),

PATTERN(part3_bassline) = {
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

#define sc       NOTE(3,  EIGHTH),
#define sgsharp  NOTE(-1, EIGHTH),
#define sf       NOTE(-4, EIGHTH),
#define sasharp  NOTE(1,  EIGHTH),
#define sg       NOTE(-2, EIGHTH),
#define se       NOTE(-5, EIGHTH),
#define sdu      NOTE(5,  EIGHTH),
#define seu      NOTE(7,  EIGHTH),
#define sfu      NOTE(8,  EIGHTH),
#define scd      NOTE(-9, EIGHTH),
#define sgu      NOTE(10, EIGHTH),
#define scu      NOTE(15, EIGHTH),
#define sbu      NOTE(14, EIGHTH),
#define sd       NOTE(-7, EIGHTH),
#define stop     NOTE(STOP, 0),
#define sgsharpu NOTE(11, EIGHTH),
#define sasharpu NOTE(13, EIGHTH),
#define sduu     NOTE(17, EIGHTH),
#define seuu     NOTE(19, EIGHTH),
#define sguu     NOTE(22, EIGHTH),
#define nulln    NOTE(REST, EIGHTH * 16),
#define scuu     NOTE(27, EIGHTH * 16),

PATTERN(part3_sky) = {
  NOTE(1,2), NOTE(3,4), NOTE(5,6),
  NOTE(-1,2), NOTE(-3,4), NOTE(-5,6),
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

PATTERN(part3_null) = {
  nulln
};

PATTERN(part3_end) = {
  scuu stop
};

void pt3(channel &drums, channel &bassline, channel& sky)
{
  SET_PATTERN(drums, drum_loop);
  SET_PATTERN(bassline, part3_bassline);
  SET_PATTERN(sky, part3_sky);
  m.play();

  SET_PATTERN(drums, part3_null);
  SET_PATTERN(bassline, part3_null);
  SET_PATTERN(sky, part3_end);
  m.play();
}

#define p1_sc          NOTE(27, EIGHTH),
#define p1_sg          NOTE(22, EIGHTH),
#define p1_se          NOTE(19, EIGHTH),
#define p1_sgsharp     NOTE(23, EIGHTH),
#define p1_sf          NOTE(20, EIGHTH),
#define p1_sd          NOTE(29, EIGHTH),
#define p1_sasharp     NOTE(25, EIGHTH),
#define mclong      NOTE( 3, EIGHTH * 10),
#define melong      NOTE( 7, EIGHTH * 10),
#define mg          NOTE(-2, EIGHTH * 2),
#define hg          NOTE(10, EIGHTH * 2),
#define mc          NOTE( 3, EIGHTH * 2),
#define me          NOTE( 7, EIGHTH * 2),
#define mf          NOTE( 8, EIGHTH * 4),
#define md4         NOTE( 5, EIGHTH * 4),
#define me4         NOTE( 7, EIGHTH * 4),
#define mc4         NOTE( 3, EIGHTH * 4),
#define mchold      NOTE( 3, EIGHTH * 24),
#define mchold2     NOTE( 3, EIGHTH * 10),
#define mghold      NOTE(10, EIGHTH * 24),
#define mghold2     NOTE(10, EIGHTH * 10),
#define ma4         NOTE(12, EIGHTH * 4),
#define mg4         NOTE(10, EIGHTH * 4),
#define mgsharphold NOTE(11, EIGHTH * 18), 
#define masharphold NOTE(13, EIGHTH * 16),
#define mfhold      NOTE( 8, EIGHTH * 16), 

PATTERN(part1_skyline) = {
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg

  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg

  p1_sc p1_sgsharp sf p1_sgsharp
  p1_sc p1_sgsharp sf p1_sgsharp
  p1_sc p1_sgsharp sf p1_sgsharp
  p1_sc p1_sgsharp sf p1_sgsharp

  p1_sc p1_sasharp sf p1_sasharp 
  p1_sc p1_sasharp sf p1_sasharp 
  p1_sc p1_sasharp sf p1_sasharp 
  p1_sc p1_sasharp sf p1_sasharp 

  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg

  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg
  p1_sc p1_sg p1_se p1_sg

  p1_sc p1_sgsharp p1_sf p1_sgsharp
  p1_sc p1_sgsharp p1_sf p1_sgsharp
  p1_sc p1_sgsharp p1_sf p1_sgsharp
  p1_sc p1_sgsharp p1_sf p1_sgsharp

  p1_sd p1_sasharp p1_sf p1_sasharp
  p1_sd p1_sasharp p1_sf p1_sasharp
  p1_sd p1_sasharp p1_sf p1_sasharp
  p1_sd p1_sasharp p1_sf p1_sasharp
  p1_sc
};

PATTERN(part1_melody) = {
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


PATTERN(part1_harmony) = {
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
  SET_PATTERN(melody, part1_melody);
  SET_PATTERN(harmony, part1_harmony);
  SET_PATTERN(skyline, part1_skyline);  
  m.play();
}

#define bc      NOTE(-21, EIGHTH),
#define bc2     NOTE(-21, EIGHTH * 2),
#define bchigh  NOTE(-9, EIGHTH * 2),
#define bgsharp NOTE(-13, EIGHTH * 2),
#define basharp NOTE(-11, EIGHTH * 2),

PATTERN(part2_bassline) = {
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

#define p2_mch        NOTE(-9, EIGHTH*10),
#define p2_mg         NOTE(-14, EIGHTH*2),
#define p2_mg4        NOTE(-14, EIGHTH*4),
#define p2_mg1        NOTE(-14, EIGHTH*1),
#define p2_mgold      NOTE(-2, EIGHTH * 12),
#define p2_mc         NOTE(-9, EIGHTH * 2),
#define p2_mcsharp1   NOTE(-8, EIGHTH),
#define p2_mc1        NOTE(-9, EIGHTH * 1),
#define p2_mcl        NOTE(-21, EIGHTH * 2),
#define p2_mc4        NOTE(-9, EIGHTH * 4),
#define p2_me         NOTE(-5, EIGHTH * 2),
#define p2_me1        NOTE(-5, EIGHTH * 1),
#define p2_mel8       NOTE(-17, EIGHTH * 8),
#define p2_mf4        NOTE(-4, EIGHTH * 4),
#define p2_mfl1       NOTE(-16, EIGHTH),
#define p2_mf         NOTE(-4, EIGHTH * 2),
#define p2_mf1        NOTE(-4, EIGHTH),
#define p2_md1        NOTE(-7, EIGHTH),
#define p2_mdl        NOTE(-19, EIGHTH * 2),
#define p2_md4        NOTE(-7, EIGHTH * 4),
#define p2_me4        NOTE(-5, EIGHTH * 4),
#define p2_mchh       NOTE(-9, EIGHTH * 14),
#define p2_mcsecondhh NOTE(-9, EIGHTH * 8),
#define p2_mgsharp    NOTE(-13, 2 * EIGHTH),
#define p2_mgsharp10  NOTE(-13, 10 * EIGHTH),
#define p2_moreSOLO   NOTE(SUPERSOLO, 1),
#define soloON     NOTE(SUPERSOLO, 1),
#define soloOFF    NOTE(SUPERSOLO, 0),
#define frest      NOTE(REST, EIGHTH / 2),
#define stop       NOTE(STOP, 0),

PATTERN(part2_melody) = {
  p2_mch p2_mg p2_mc p2_me p2_mf4 p2_me p2_md4
  p2_me soloON p2_me soloOFF p2_mchh
  rest rest rest rest
  //m12
  p2_mc4 p2_mgsharp p2_mc4 p2_md4 p2_mc  
  p2_mch p2_mg p2_mc p2_me
  //m13
  p2_mf4 p2_me p2_md4 p2_mc4 p2_mc
  //m14
  p2_mgold p2_mf p2_me
  //m15
  p2_mf1 p2_me1 p2_mc1 p2_mg1 p2_mg4 p2_mg4
  ///
  p2_mf1 p2_me1 p2_moreSOLO p2_mc1 p2_mg1 soloOFF
  //again
  p2_mch p2_mg p2_mc p2_me p2_mf4 p2_me p2_md4
  p2_me
  p2_moreSOLO p2_me1 p2_me1 p2_md1 p2_mcsharp1 soloOFF
  p2_mcsecondhh
  p2_mc p2_mg p2_mc p2_mg p2_mgsharp10 p2_mfl1 p2_mfl1 p2_mgsharp p2_mc
  p2_mg4 p2_mg p2_mc4
  p2_mg p2_mc p2_me p2_mf4 p2_me p2_md4 p2_mc4 rest p2_mc1
  p2_mgold p2_mf p2_me
  p2_mf1 p2_me1 p2_mc1 p2_mfl1 p2_mel8 p2_mdl p2_mcl
  stop
};

void pt2(channel& melody, channel& bassline, channel& drums)
{
  SET_PATTERN(drums, drum_loop);
  SET_PATTERN(bassline, part2_bassline);
  SET_PATTERN(melody, part2_melody);
  m.play();
}

void setup(){
  Serial.begin(115200);
  m.add_channel(&pin10);
  m.add_channel(&pin11);
  m.add_channel(&pin12); //LOUD PIN
}

void loop() {
  pt1(pin10,pin11,pin12);
  pt2(pin10,pin11,pin12);
  pt3(pin10,pin11,pin12);
}
