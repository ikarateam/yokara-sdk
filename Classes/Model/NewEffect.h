//
//  NewEffect.h
//  Yokara
//
//  Created by APPLE on 1/4/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
/*
 * KARAOKE version 1 sẽ có các parameters sau: ECHO BASS TREBLE
 *   ECHO: giá trị từ 0 -> 100
 *   BASS: giá trị từ -100 -> 100
 *   TREBLE: giá trị từ -100 -> 100
 * STUDIO version 1 sẽ có các parameters sau: SEX VOICETYPE TEMPOLEVEL
 *   SEX: 2 giá trị MALE và FEMALE
 *   VOICETYPE: 3 giá trị LOW - MID - HIGH
 *   TEMPOLEVEL: 3 giá trị SLOW - MEDIUM - FAST
 * DENOISE version 1 sẽ có các parameters sau: DENOISELEVEL START(ms)
 
 * AUTOTUNE version 1 sẽ  có các parameters sau: AUTOTUNELEVEL KEY
 * PITCHSHIFT version 1 sẽ có các parameters sau: PITCHSHIFT'
 NewEffect newEffect = new NewEffect();
 newEffect.name = NewEffect.LIVE;
 newEffect.type = NewEffect.VOCAL;
 newEffect.preset = NewEffect.DEFAULT;
 newEffect.parameters.put(NewEffect.THICK, "100");
 newEffect.parameters.put(NewEffect.ECHO, "50");
 newEffect.parameters.put(NewEffect.WARM, "50");
 */
#import "JSONModel.h"
//VOICECHANGER type
#define MALE2FEMALE @"MALE2FEMALE"
#define FEMALE2MALE @"FEMALE2MALE"
#define BABY @"BABY"
#define OLDPERSON @"OLDPERSON"
//Live para
#define Live_THICK @"THICK"
#define Live_ECHO @"ECHO"
#define Live_WARM @"WARM"
#define DEFAULT @"DEFAULT"
#define Key_Remix @"REMIX"
#define Key_SuperBass @"SUPERBASS"
#define Key_Bolero @"BOLERO"
#define Key_Remix_FLANGERTYPE @"FLANGERTYPE"
#define Key_Remix_FLANGERTYPE_CLASSIC @"CLASSICFLANGER"
#define Key_Remix_FLANGERTYPE_SOFT @"SOFTLANGER"
#define Key_Remix_FLANGERTYPE_SLOWBASS @"SLOWBASSFLANGER"

@interface NewEffect : JSONModel
 @property(strong, nonatomic) NSString * name; //"KARAOKE" "STUDIO" "DENOISE" "AUTOTUNE" "VOICECHANGER" "LIVE" REMIX SUPERBASS BOLERO
 @property(strong, nonatomic) NSString * type; //"VOCAL" , "BEAT" , "MASTER"
 @property(strong, nonatomic) NSNumber * version;//1
 @property(strong, nonatomic) NSString * preset;
 @property(strong, nonatomic) NSMutableDictionary * parameters ;//VIBRATOLEVEL
 @property(strong, nonatomic) NSNumber <Ignore>* enable ;
- (id)initWithDict:(NSDictionary *)dict ;

@end
