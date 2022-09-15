//
//  iosDigitalSignature.h
//  rc4
//
//  Created by Rain Nguyen on 9/18/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>

@interface iosDigitalSignature : NSObject
-(NSString *) encryption:(NSString *) dataInString;
-(NSString *) encryptionV19:(NSString *) dataInString;
-(NSString *) encryptionV28:(NSString *) dataInString;
- (NSString *) decryption:(NSString*) dataInString ;
- (NSString *) decryptionV19:(NSString*) dataInString ;
-(NSMutableString *) getKeyV28:(NSString *) data;
@end
