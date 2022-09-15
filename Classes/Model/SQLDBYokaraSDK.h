//
//  SQLDBYokaraSDK.h
//  Yokara
//
//  Created by Rain Nguyen on 6/28/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLDBYokaraSDK : NSObject {
    sqlite3 *database;
    NSString *databaseName;
    NSString *databasePath;
}

- (id)initWithPath:(NSString *)path;
- (NSMutableArray *)performQuery:(NSString *)query;
- (BOOL) insertRecord:(NSString *) sqlStr;



@end
