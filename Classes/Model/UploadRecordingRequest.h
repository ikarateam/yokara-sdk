//
//  UploadRecordingRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 8/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class Recording;
@interface UploadRecordingRequest : JSONModel
@property (strong, nonatomic) NSString * facebookId; //Them truong nay phuc vu upload FB
@property (strong, nonatomic) NSString * accessToken; //Them truong nay phuc vu upload FB

@property (strong, nonatomic) NSString* language;
/* đây là id của cái máy mà gửi bài thu âm lên,
 * để có cái này thì search xem trong iOS có hàm nào lấy được một chuỗi string duy nhất
 * cho một thiết bị nào đó không
 */
//@Element(required=true,name="userId")
@property (strong, nonatomic) NSString* userId;

/* đối tượng Recording cần upload lên iKara */

@property (strong, nonatomic) Recording * recording;

/* tên người dùng nhập lúc upload */

@property (strong, nonatomic) NSString* yourName;

/* tin nhắn người dùng nhập lúc upload */

@property (strong, nonatomic) NSString* message;

@end
