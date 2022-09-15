//
//  Utils.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DATE_STRING @"yyyy-MM-dd-HH_mm_ss"
@class InputStream;
@class Context;
@class Lyrics;
@class Activity;
@class Paint;
@protocol Line;
@interface UtilsK : NSObject {
    NSDictionary *myAttrDict;
    NSMutableArray *blockAttrDict;
    NSMutableArray *rowsArray;
    NSMutableString *currentStringValue;
    NSMutableArray *songLyric;
}
+(CGFloat) measureText:(Paint *) paint andText: (NSString *) text;
-(NSString *) convertStreamToString:(InputStream *) is;
-(NSString *)getText:(NSString *)url;
-(NSString *) getXmlFromUrl:(NSString *) url;
-(void ) handleException:(NSException *) ex;
-(void) displayMessage:(Context *) context andMess:( NSString *) message;
-(void) displayMessage:(Context *) context andMessId:( int) messageId;
-(BOOL)   isOnline:(Context *)context;
-(int) getRandomInRange:(int) min andMax:( int) max;
-(BOOL) isExpired;
-(NSString *)  readTextFile:(NSString *) file;
-(NSString *) convertMilisecond2String:(int ) milliseconds;
-(CGFloat) convertTimeFromTextToNumber:(NSString *) timeInText;
-(Lyrics *) convertXmlToObject:(NSString *) xmlLyrics;
-(NSString *) convertObjectToString:(Lyrics *) lyricsInObject;
-(NSString *) convertObjectToXml:(Lyrics *)lyrics;
-(Lyrics *) convertStringToObject:(NSString *) lyrics;
-(Lyrics *) transferData:(Lyrics *) oldData andNew:( Lyrics *) newData;
-(CGSize) getSize;
-(Lyrics *) splitTooLongLine:(Lyrics *) lyrics andMaxLen: (int )maxLength;
-(NSMutableArray<Line> *) convertLyricsInObjectToRKL:(Lyrics *)lyricsInObject;


@end
