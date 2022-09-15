//
//  Effects.h
//  Yokara
//
//  Created by Rain Nguyen on 8/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface EffectsR : JSONModel
// âm lượng của nhạc nền giá trị từ 0 - 100 mặc định là 100

@property (strong,nonatomic) NSNumber * musicVolume;
// âm lượng của giọng hát giá trị từ 0 - 100 mặc định là 100
@property (strong,nonatomic) NSNumber *vocalVolume;
// tiếng vang của giọng hát giá trị từ 0 - 100 mặc định là 40
@property (strong,nonatomic) NSNumber * echo;
// tiếng treble của giọng hát giá trị từ 0 - 100 mặc định là 20
@property (strong,nonatomic) NSNumber * treble;
@property (strong,nonatomic) NSNumber * bass;
@property (strong,nonatomic) NSNumber * toneShift; //+-12 nhớ x2 lên
@property (strong,nonatomic) NSString<Ignore> * effectVideo; //+-12 nhớ x2 lên

@end
