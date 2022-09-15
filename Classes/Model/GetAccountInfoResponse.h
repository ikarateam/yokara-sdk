//
//  GetAccountInfoResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 11/6/19.
//  Copyright © 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetAccountInfoResponse : JSONModel
@property(strong, nonatomic) NSString* accountType; //NORMAL VIP
@property(strong, nonatomic) NSString*   expiredDate;
@property(strong, nonatomic) NSString* message;
@property(strong, nonatomic) NSNumber*   totalIcoin;
@property(assign, nonatomic) BOOL autoRenew;
@property(strong, nonatomic) NSString* lastSku;

@end
