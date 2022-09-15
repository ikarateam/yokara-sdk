//
//  UploadToServerYokara.h
//  Yokara
//
//  Created by Rain Nguyen on 1/9/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface UploadToServerYokara : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSString *stringReply;
    BOOL testingPing;
    BOOL pingSVSussecc;
}
-(NSString *)multipartUpload:(NSString*)dataToUpload forKey:(NSString*)key andServer:(int) noServer;
-(NSString *)multipartUploadImage:(NSData*)dataToUpload filePath:(NSString *)filePath forKey:(NSString*)fileName ;
@end
