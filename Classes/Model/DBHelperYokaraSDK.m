//
//  DBHeper.m
//  Yokara
//
//  Created by Rain Nguyen on 6/28/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "DBHelperYokaraSDK.h"
#import <Constant.h>
#import "GetSongResponse.h"
@implementation DBHelperYokaraSDK

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
                  fieldValue9:(NSString *) fieldValue9
{
    return YES;
    BOOL complete=NO;
    if ([fieldValue1 isKindOfClass:[NSString class]]) {
        fieldValue1=[fieldValue1 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue1=@"";
    }
    if ([fieldValue2 isKindOfClass:[NSString class]]) {
        fieldValue2=[fieldValue2 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue2=@"";
    }
    if ([fieldValue3 isKindOfClass:[NSString class]]) {
        fieldValue3=[fieldValue3 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue3=@"";
    }
    if ([fieldValue4 isKindOfClass:[NSString class]]) {
        fieldValue4=[fieldValue4 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue4=@"";
    }
    if ([fieldValue5 isKindOfClass:[NSString class]]) {
        fieldValue5=[fieldValue5 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue5=@"";
    }
    if ([fieldValue6 isKindOfClass:[NSString class]]) {
        fieldValue6=[fieldValue6 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue6=@"";
    }
    if ([fieldValue7 isKindOfClass:[NSString class]]) {
        fieldValue7=[fieldValue7 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue7=@"";
    }
    if ([fieldValue8 isKindOfClass:[NSString class]]) {
        fieldValue8=[fieldValue8 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue8=@"";
    }
    if ([fieldValue9 isKindOfClass:[NSString class]]) {
        fieldValue9=[fieldValue9 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue9=@"";
    }
    
    
    NSString *sqlStr = [NSString stringWithFormat:
                        @"INSERT OR REPLACE INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')", tableName,field1,field2,field3,field4,field5,field6,field7,field8,field9,fieldValue1,fieldValue2,fieldValue3,fieldValue4,fieldValue5,fieldValue6,fieldValue7,fieldValue8,fieldValue9];
    //---the above SQL statement to be typed in a single line---
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
       
        complete =  [database insertRecord:sqlStr];
       
    
    return complete;
}
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
                   fieldValue12:(NSString *) fieldValue12

{
    return YES;
    BOOL complete=NO;
  
    if ([fieldValue1 isKindOfClass:[NSString class]]) {
        fieldValue1=[fieldValue1 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue1=@"";
    }
    if ([fieldValue2 isKindOfClass:[NSString class]]) {
        fieldValue2=[fieldValue2 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue2=@"";
    }
    if ([fieldValue3 isKindOfClass:[NSString class]]) {
        fieldValue3=[fieldValue3 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue3=@"";
    }
    if ([fieldValue4 isKindOfClass:[NSString class]]) {
        fieldValue4=[fieldValue4 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue4=@"";
    }
    if ([fieldValue5 isKindOfClass:[NSString class]]) {
        fieldValue5=[fieldValue5 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue5=@"";
    }
    if ([fieldValue6 isKindOfClass:[NSString class]]) {
        fieldValue6=[fieldValue6 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue6=@"";
    }
    if ([fieldValue7 isKindOfClass:[NSString class]]) {
        fieldValue7=[fieldValue7 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue7=@"";
    }
    if ([fieldValue8 isKindOfClass:[NSString class]]) {
        fieldValue8=[fieldValue8 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue8=@"";
    }
    if ([fieldValue9 isKindOfClass:[NSString class]]) {
        fieldValue9=[fieldValue9 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue9=@"";
    }
    if ([fieldValue10 isKindOfClass:[NSString class]]) {
        fieldValue10=[fieldValue10 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue10=@"";
    }
    if ([fieldValue11 isKindOfClass:[NSString class]]) {
        fieldValue11=[fieldValue11 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue11=@"";
    }
    if ([fieldValue12 isKindOfClass:[NSString class]]) {
        fieldValue12=[fieldValue12 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue12=@"";
    }
    NSString *sqlStr = [NSString stringWithFormat:
                        @"INSERT OR REPLACE INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", tableName,field1,field2,field3,field4,field5,field6,field7,R_CONVERT,field8,field9,field10,field11,field12,fieldValue1,fieldValue2,fieldValue3,fieldValue4,fieldValue5,fieldValue6,fieldValue7,@"1",fieldValue8,fieldValue9,fieldValue10,fieldValue11,fieldValue12];
    //---the above SQL statement to be typed in a single line---
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    
    complete =  [database insertRecord:sqlStr];
    
    
    return complete;
}
- (BOOL) insertRecordIntoLyric:(GetSongResponse *) sRes
{
    return YES;
    BOOL complete=NO;
    for (Lyric * lyric in sRes.song.lyrics){
        lyric.ownerId=[lyric.ownerId stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
        lyric.content=[lyric.content stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    NSString *sqlStr = [NSString stringWithFormat:
                        @"INSERT OR REPLACE INTO 'Lyric' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",L_key,L_PrivatedId,L_ownerId,L_url,L_content,L_openningNo,L_totalRating,L_ratingCount,L_date,L_yourRating,L_type,lyric.key,lyric.privatedId,lyric.ownerId,lyric.url,lyric.content,lyric.openningNo,lyric.totalRating,lyric.ratingCount,lyric.date,lyric.yourRating,lyric.type];
    //---the above SQL statement to be typed in a single line---
       
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    
    complete =  [database insertRecord:sqlStr];
    
    }
    
    return complete;
}
- (BOOL) insertLyric:(Lyric*)lyric andSongID:(NSString *) ids{
    return YES;
    BOOL complete=NO;
    lyric.key=[lyric.key stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    lyric.ownerId=[lyric.ownerId stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    lyric.content=[lyric.content stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    [self removeRecordIntoLyricSong:ids];
        NSString *sqlStr = [NSString stringWithFormat:
                            @"INSERT OR REPLACE INTO 'Lyric' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",L_key,L_PrivatedId,L_ownerId,L_url,L_content,L_openningNo,L_totalRating,L_ratingCount,L_date,L_yourRating,L_type,L_SongID,lyric.key,lyric.privatedId,lyric.ownerId,lyric.url,lyric.content,lyric.openningNo,lyric.totalRating,lyric.ratingCount,lyric.date,lyric.yourRating,lyric.type,ids];
        //---the above SQL statement to be typed in a single line---
    
        SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
        
        complete =  [database insertRecord:sqlStr];
        
   
    
    return complete;
}
- (Lyric *) loadLyric:(NSString*)key{
    Lyric * lyric=[Lyric new];
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    NSMutableArray *result=[database performQuery:[NSString stringWithFormat: @"SELECT * FROM Lyric WHERE %@='%@'",L_SongID,key]];
    if (result.count>0){
    lyric.key=[[result objectAtIndex:0]objectAtIndex:0];
    lyric.privatedId=[[result objectAtIndex:0] objectAtIndex:1];
    lyric.ownerId=[[result objectAtIndex:0] objectAtIndex:2];
    lyric.url=[[result objectAtIndex:0] objectAtIndex:3];
    
    lyric.content=[[result objectAtIndex:0] objectAtIndex:4];
    lyric.totalRating=[[result objectAtIndex:0] objectAtIndex:6];
    lyric.ratingCount=[[result objectAtIndex:0] objectAtIndex:7];
    lyric.yourRating=[[result objectAtIndex:0] objectAtIndex:9];
    lyric.type=[[result objectAtIndex:0] objectAtIndex:10];
    }
    return lyric;
}
- (BOOL) updateTable: (NSString *) tableName
          withField1:(NSString *) field1
         fieldValue1:(NSString *) fieldValue1
       withCondition:(NSString *) cont
      conditionValue:(NSString *) contValue
{
    return YES;
    BOOL complete=NO;
    if ([fieldValue1 isKindOfClass:[NSString class]]) {
        fieldValue1=[fieldValue1 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue1=@"";
    }
    contValue=[contValue stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@='%@'",tableName,field1,fieldValue1,cont,contValue];
    //NSLog(@"%@",sqlStr);
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    
    complete =  [database insertRecord:sqlStr];
    
    
    return complete;
}
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
         conditionValue:(NSString *) contValue
{
    return YES;
    BOOL complete=NO;
    if ([fieldValue1 isKindOfClass:[NSString class]]) {
        fieldValue1=[fieldValue1 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue1=@"";
    }
    if ([fieldValue2 isKindOfClass:[NSString class]]) {
        fieldValue2=[fieldValue2 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue2=@"";
    }
    if ([fieldValue3 isKindOfClass:[NSString class]]) {
        fieldValue3=[fieldValue3 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue3=@"";
    }
    if ([fieldValue4 isKindOfClass:[NSString class]]) {
        fieldValue4=[fieldValue4 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue4=@"";
    }
    if ([fieldValue5 isKindOfClass:[NSString class]]) {
        fieldValue5=[fieldValue5 stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    }else{
        fieldValue5=@"";
    }
    contValue=[contValue stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@', %@='%@',%@='%@', %@='%@', %@='%@' WHERE %@='%@'",tableName,field1,fieldValue1,field2,fieldValue2,field3,fieldValue3,field4,fieldValue4,field5,fieldValue5,cont,contValue];
    //NSLog(@"%@",sqlStr);
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    
    complete =  [database insertRecord:sqlStr];
    
    
    return complete;
    
}
-(BOOL)checkColumnExists
{
    return YES;
    BOOL columnExists = NO;
    
    
    NSString *sqlStatement = @"select videoId from Song";
    NSString *sqlStatement2 = @"select duration from Record";
     NSString *sqlStatement3 = @"select nameKoDau from Song";
     NSString *sqlStatement4 = @"select toneShift from Record";
    NSString *sqlStatement5 = @"select bass from Record";
    NSString *sqlStatement6 = @"select originalRecording from Record";
    NSString *sqlStatement7 = @"select thumnailUrl from Record";
     NSString *sqlStatement8 = @"select owner from Song";
     NSString *sqlStatement9 = @"select recordDevice from Record";
    NSString *sqlStatement10 = @"select durationString from Song";
    NSString *sqlStatement11 = @"select songUrlMp4 from Song";
     NSString *sqlStatement12 = @"select timeUpload from Song";
    NSString *sqlStatement13 = @"select onlineVoiceUrl from Record";
    NSString *sqlStatement14 = @"select newEffects from Record";
     NSString *sqlStatement15 = @"select idRec from Record";
    NSString *sqlStatement16 = @"select recordingType from Record";
    NSString *sqlStatement17 = @"select mixedRecordingVideoUrl from Record";
     NSString *sqlStatement18 = @"select onlineMp3Recording from Record";
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    columnExists =  [database insertRecord:sqlStatement18];
    if (columnExists==NO)
        return columnExists;
    columnExists =  [database insertRecord:sqlStatement17];
    if (columnExists==NO)
        return columnExists;
    columnExists =  [database insertRecord:sqlStatement16];
    if (columnExists==NO)
        return columnExists;
    columnExists =  [database insertRecord:sqlStatement15];
    if (columnExists==NO)
        return columnExists;
    columnExists =  [database insertRecord:sqlStatement14];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement13];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement12];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement10];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement11];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement9];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement8];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement4];
    if (columnExists==NO) return columnExists;
    columnExists =  [database insertRecord:sqlStatement3];
    if (columnExists==NO) return columnExists;
        columnExists =  [database insertRecord:sqlStatement];
    if (columnExists==NO) return columnExists;
    
        columnExists =  [database insertRecord:sqlStatement2];
    if (columnExists==NO) return columnExists;
    
    columnExists =  [database insertRecord:sqlStatement5];
    if (columnExists==NO) return columnExists;
    
    columnExists =  [database insertRecord:sqlStatement6];
    if (columnExists==NO) return columnExists;
    
    columnExists =  [database insertRecord:sqlStatement7];
    
    return columnExists;
}
- (BOOL) addColum{
    return YES;
    BOOL complete=NO;
    NSString *sqlStr = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN videoId VARCHAR"];
    NSString *sqlStr2 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN likeCounter INTEGER DEFAULT 0"];
    NSString *sqlStr3 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN dislikeCounter INTEGER DEFAULT 0"];
    NSString *sqlStr4 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN thumbnailUrl VARCHAR"];
    NSString *sqlStr5 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN duration INTEGER DEFAULT 0"];
    NSString *sqlStr6 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN duration INTEGER DEFAULT 0"];
    NSString *sqlStr8 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN toneShift INTEGER DEFAULT 0"];
     NSString *sqlStr9 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN bass INTEGER DEFAULT 0"];
    NSString *sqlStr7 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN nameKoDau VARCHAR"];
     NSString *sqlStr10 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN originalRecording VARCHAR"];
     NSString *sqlStr11 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN thumnailUrl VARCHAR"];
     NSString *sqlStr12 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN owner VARCHAR"];
    NSString *sqlStr14 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN durationString VARCHAR"];
    NSString *sqlStr15 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN songUrlMp4 VARCHAR"];
    //NSLog(@"%@",sqlStr);
     NSString *sqlStr13 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN recordDevice VARCHAR"];
     NSString *sqlStr16 = [NSString stringWithFormat:@"ALTER TABLE Song ADD COLUMN timeUpload VARCHAR"];
     NSString *sqlStr17 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN onlineVoiceUrl VARCHAR"];
    NSString *sqlStr18 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN newEffects VARCHAR"];
    NSString *sqlStr19 =  [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN idRec INTEGER DEFAULT 0"];
    NSString *sqlStr20 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN recordingType VARCHAR"];
    NSString *sqlStr21 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN mixedRecordingVideoUrl VARCHAR"];
    NSString *sqlStr22 = [NSString stringWithFormat:@"ALTER TABLE Record ADD COLUMN onlineMp3Recording VARCHAR"];
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
   
    complete =  [database insertRecord:sqlStr];
    complete =  [database insertRecord:sqlStr2];
    complete =  [database insertRecord:sqlStr3];
    complete =  [database insertRecord:sqlStr4];
    complete =  [database insertRecord:sqlStr5];
    complete =  [database insertRecord:sqlStr6];
    complete =  [database insertRecord:sqlStr7];
    complete =  [database insertRecord:sqlStr8];
    complete =  [database insertRecord:sqlStr9];
     complete =  [database insertRecord:sqlStr10];
    complete =  [database insertRecord:sqlStr11];
    complete =  [database insertRecord:sqlStr12];
    complete =  [database insertRecord:sqlStr13];
    complete =  [database insertRecord:sqlStr14];
    complete =  [database insertRecord:sqlStr15];
    complete =  [database insertRecord:sqlStr16];
      complete =  [database insertRecord:sqlStr17];
    complete =  [database insertRecord:sqlStr18];
    complete =  [database insertRecord:sqlStr19];
    complete =  [database insertRecord:sqlStr20];
    complete =  [database insertRecord:sqlStr21];
    complete =  [database insertRecord:sqlStr22];
    return complete;
}
- (BOOL) removeAllRecordIntoSong{
    return YES;
    BOOL complete=NO;
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE * FROM %@",S_Table];
    complete =  [database insertRecord:sqlStr];
    return complete;
}
- (BOOL) removeRecordIntoSong:(NSNumber *) ids{
    return YES;
    BOOL complete=NO;
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
     NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%@",S_Table,S_IDS,[NSString stringWithFormat:@"%@",ids]];
     complete =  [database insertRecord:sqlStr];
    [self removeRecordIntoLyricSong:[NSString stringWithFormat:@"%@",ids]];
    return complete;
}
- (BOOL) removeRecordIntoSongYokara:(NSString *) videoId{
    return YES;
    BOOL complete=NO;
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'",S_Table,S_videoId,videoId];
    complete =  [database insertRecord:sqlStr];
    return complete;
}
- (BOOL) removeRecordIntoLyricSong:(NSString *) songId{
    return YES;
    BOOL complete=NO;
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM Lyric WHERE %@='%@'",L_SongID,songId];
    complete =  [database insertRecord:sqlStr];
    return complete;
}
- (NSMutableArray *) loadFavorSong {
   
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    NSMutableArray *result=[database performQuery:@"SELECT * FROM Song"];
    
    return result;
}
- (BOOL) removeRecordIntoRecord:(NSString *) date{
    return YES;
    BOOL complete=NO;
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'",R_Table,R_DATE,[NSString stringWithFormat:@"%@",date]];
    complete =  [database insertRecord:sqlStr];
    return complete;
}
- (NSMutableArray *) loadRecordSong {
    SQLDBYokaraSDK *database = [[SQLDBYokaraSDK alloc] initWithPath:@"Yokara.sqlite"];
    NSMutableArray *result=[database performQuery:@"SELECT * FROM Record"];
    
    return result;
}

@end
