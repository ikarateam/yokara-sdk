//
//  SQLDBYokaraSDK.m
//  Yokara
//
//  Created by Rain Nguyen on 6/28/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "SQLDBYokaraSDK.h"

@implementation SQLDBYokaraSDK

- (id)initWithPath:(NSString *)path {
    if (self = [super init]) {
        sqlite3 *dbConnection;
        NSFileManager *filM = [NSFileManager defaultManager];
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentsPaths objectAtIndex:0];
        databasePath = [documentDir stringByAppendingPathComponent:path];
        bool susecc = [filM fileExistsAtPath:databasePath];
        if (!susecc) {
            NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
            [filM copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        }
        if (sqlite3_open([databasePath UTF8String], &dbConnection) != SQLITE_OK) {
            
            NSLog(@"[SQLITE] Unable to open database!");
            return nil; // if it fails, return nil obj
        }
        database = dbConnection;
    }
    return self;
}
- (NSMutableArray *)performQuery:(NSString *)query {
    sqlite3_stmt *statement = nil;
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"[SQLITE] Error when preparing query!");
    } else {
        NSMutableArray *result = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *row = [NSMutableArray array];
            for (int i=0; i<sqlite3_column_count(statement); i++) {
                int colType = sqlite3_column_type(statement, i);
                id value;
                if (colType == SQLITE_TEXT) {
                    const unsigned char *col = sqlite3_column_text(statement, i);
                    value = [NSString stringWithUTF8String:col];
                    //value = [NSString stringWithFormat:@"%s", col];
                } else if (colType == SQLITE_INTEGER) {
                   sqlite3_int64  col = sqlite3_column_int64(statement, i);
                    value = [NSNumber numberWithUnsignedLongLong:col];
                } else if (colType == SQLITE_FLOAT) {
                    double col = sqlite3_column_double(statement, i);
                    value = [NSNumber numberWithDouble:col];
                } else if (colType == SQLITE_NULL) {
                    value = [NSNull null];
                } else {
                    NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                }
                
                [row addObject:value];
            }
            [result addObject:row];
        }
        return result;
    }
    return nil;
}
- (BOOL) insertRecord:(NSString *) sqlStr {
    //---the above SQL statement to be typed in a single line---
    const char *sql = [sqlStr UTF8String];
    char *err;
    if (sqlite3_exec(database, sql, NULL, NULL, &err) != SQLITE_OK) {
        return NO;
    }
    return YES;
}

@end
