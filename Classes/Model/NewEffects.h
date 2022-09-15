//
//  NewEffects.h
//  Yokara
//
//  Created by APPLE on 1/4/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class NewEffect;
@interface NewEffects : JSONModel
 @property(strong, nonatomic) NSNumber * vocalVolume; //0 -> 150 100
 @property(strong, nonatomic) NSNumber * beatVolume ;  //0 -> 150
 @property(strong, nonatomic) NSNumber * masterVolume;//0 -> 150
 @property(strong, nonatomic) NSNumber * delay ; //ms 0
 @property(strong, nonatomic) NSNumber * toneShift; //-6 -4 -2 2 4 6
 @property(strong, nonatomic)  NSMutableDictionary *effects ;
@property(strong, nonatomic) NSNumber * hashCode ;

@end
