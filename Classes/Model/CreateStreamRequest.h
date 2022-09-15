//
//  CreateStreamRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 4/9/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class NewEffects;
@interface CreateStreamRequest : JSONModel

@property(strong, nonatomic) NSString * streamName;
@property(strong, nonatomic) NSString * beatId;
@property(strong, nonatomic) NSString * beatType; //SONG RECORDING YOUTUBE
@property(strong, nonatomic) NSString * beatUrl; // Pitch Shifted Song Url
@property(strong, nonatomic) NSString * vocalUrl;
@property(strong, nonatomic) NSString * key; //key of Original Song
@property(strong, nonatomic)  NSNumber* bpm; //bpm of Original Song
@property(strong, nonatomic)  NewEffects * effects;
@property(strong, nonatomic) NSString * recordingType;//"AUDIO" "VIDEO"

@end
