//
//  DBHeper.h
//  Yokara
//
//  Created by Rain Nguyen on 6/28/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SQLDBYokaraSDK.h"
@class GetSongResponse;
@class Lyric;
@interface DBHelperYokaraSDK : NSObject
- (BOOL) removeAllRecordIntoSong;
- (BOOL) insertRecordIntoSong:(NSString *) tableName
                   withField1:(NSString *) field1
                  fieldValue1:(NSString *) fieldValue1
                   withField2:(NSString *) field2
                  fieldValue2:(NSString *) fieldValue2
                   withField3:(NSString *) field3
                  fieldValue3:(NSString *) fieldValue3
                   withField4:(NSString *) field4
                  fieldValue4:(NSString *) fieldValue4
                   withField5:(NSString *) field5
                  fieldValue5:(NSString *) fieldValue5
                   withField6:(NSString *) field6
                  fieldValue6:(NSString *) fieldValue6
                   withField7:(NSString *) field7
                  fieldValue7:(NSString *) fieldValue7
                   withField8:(NSString *) field8
                  fieldValue8:(NSString *) fieldValue8
                   withField9:(NSString *) field9
                  fieldValue9:(NSString *) fieldValue9;
- (BOOL) updateTable: (NSString *) tableName
          withField1:(NSString *) field1
         fieldValue1:(NSString *) fieldValue1
          withField2:(NSString *) field2
         fieldValue2:(NSString *) fieldValue2
          withField3:(NSString *) field3
         fieldValue3:(NSString *) fieldValue3
          withField4:(NSString *) field4
         fieldValue4:(NSString *) fieldValue4
          withField5:(NSString *) field5
         fieldValue5:(NSString *) fieldValue5
       withCondition:(NSString *) cont
      conditionValue:(NSString *) contValue;
- (BOOL) updateTable: (NSString *) tableName
          withField1:(NSString *) field1
         fieldValue1:(NSString *) fieldValue1
       withCondition:(NSString *) cont
      conditionValue:(NSString *) contValue;
- (BOOL) insertRecordIntoRecord:(NSString *) tableName
                     withField1:(NSString *) field1
                    fieldValue1:(NSString *) fieldValue1
                     withField2:(NSString *) field2
                    fieldValue2:(NSString *) fieldValue2
                     withField3:(NSString *) field3
                    fieldValue3:(NSString *) fieldValue3
                     withField4:(NSString *) field4
                    fieldValue4:(NSString *) fieldValue4
                     withField5:(NSString *) field5
                    fieldValue5:(NSString *) fieldValue5
                     withField6:(NSString *) field6
                    fieldValue6:(NSString *) fieldValue6
                     withField7:(NSString *) field7
                    fieldValue7:(NSString *) fieldValue7
                     withField8:(NSString *) field8
                    fieldValue8:(NSString *) fieldValue8
                     withField9:(NSString *) field9
                    fieldValue9:(NSString *) fieldValue9
                    withField10:(NSString *) field10
                   fieldValue10:(NSString *) fieldValue10
                    withField11:(NSString *) field11
                   fieldValue11:(NSString *) fieldValue11
                    withField12:(NSString *) field12
                   fieldValue12:(NSString *) fieldValue12;
- (Lyric *) loadLyric:(NSString*)key;
- (BOOL) removeRecordIntoLyricSong:(NSString *) songId;
- (BOOL) insertLyric:(Lyric*)lyric andSongID:(NSString *) ids;
- (BOOL) insertRecordIntoLyric:(GetSongResponse *) sRes;
- (BOOL) removeRecordIntoSong:(NSNumber *) ids;
- (NSMutableArray *) loadFavorSong;
- (BOOL) removeRecordIntoRecord:(NSString *) date;
- (NSMutableArray *) loadRecordSong;
- (BOOL) addColum;
-(BOOL)checkColumnExists;
- (BOOL) removeRecordIntoSongYokara:(NSString *) videoId;

@end
