//
//  User.h
//  Yokara
//
//  Created by Rain Nguyen on 10/8/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
#define Unknown 0
#define Male 1
#define Female 2
@class Setting;
@class Family;
@interface User : JSONModel
- (id)initWithDict:(NSDictionary *)dict;
@property (strong, nonatomic) NSString*  userId;
@property (strong, nonatomic) NSString* name;//Chứa tên User
@property (strong, nonatomic) NSString<Ignore>* nameKoDau;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSNumber* totalLike;
@property (strong, nonatomic) NSNumber* totalComment;
@property (strong, nonatomic) NSNumber* totalView;
@property(assign, nonatomic) long  totalScore;
@property(assign, nonatomic) long  totalIcoin;
@property (strong, nonatomic) NSNumber* level;
@property (strong, nonatomic) NSString* levelColor;
@property (strong, nonatomic) NSString* facebookId;//facebook id này có thể lấy được avatar theo định dạng
//http://graph.facebook.com/(facebookid)/picture?type=square
@property (strong, nonatomic) NSString* facebookLink;
@property (strong, nonatomic) NSString* profileImageLink;
@property (strong, nonatomic) NSString* coverImageLink;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSNumber* age;
@property (strong, nonatomic) NSString* gender;        //0 : Unknown 1: Male 2:Female
@property (strong, nonatomic) NSNumber<Optional>* type;// 1: facebook user, 0 mobile user, mobile user không có link avatar, có thể không có name
@property (strong, nonatomic) NSString* friendStatus;
@property (strong, nonatomic) NSNumber<Optional>*  distance;
@property (strong, nonatomic) NSNumber<Optional>*  relationshipScore;
@property (strong, nonatomic) NSNumber<Optional>*  followingNo;
@property (strong, nonatomic) NSNumber<Optional>*  followedNo;
@property (strong, nonatomic) NSNumber<Optional>*  uid;
@property (strong, nonatomic) NSString<Optional>* frameUrl;
@property (strong, nonatomic) NSString<Optional>*  signature;
@property (strong, nonatomic) NSString<Optional>* phoneNumber;
@property (strong, nonatomic) NSString<Optional>*  authenticationMethod; //FACEBOOK, GOOGLE, ZALO, ACCOUNTKIT
@property (strong, nonatomic) NSString<Optional>* password;
@property (strong, nonatomic) Setting<Optional>* setting;
@property (assign, nonatomic) BOOL isFirstLogin;
@property (assign, nonatomic) BOOL isFirstRegisterPhoneNumber;
@property(strong, nonatomic) NSString<Optional>* firebaseToken;
@property(strong, nonatomic) NSString<Optional>* jid;

@property(strong, nonatomic) NSString<Optional>* roomUserType;
@property(assign, nonatomic) long dateTimeOnline;
@property(assign, nonatomic) long dateTime;

@property(strong, nonatomic) NSString<Optional>* roomId;
@property(strong, nonatomic) NSString<Optional>* userActionId;
@property(strong, nonatomic) NSString<Optional>* roomUserActionType;
@property(assign, nonatomic) BOOL isCandidates;
@property(assign, nonatomic) long roundContest;
@property(assign, nonatomic) long  minScoreOfNextLevel;

@property(assign, nonatomic) long   minScoreOfCurrentLevel;

@property(strong, nonatomic) NSString<Optional>*familyStatus; // PENDING APPROVED
@property(strong, nonatomic) Family *family;

@property(strong, nonatomic) NSString<Optional>* typeInFamily; //MEMBER //LEADER, SUBLEADER

@property(assign, nonatomic) long   dedicationScore; // Điểm cống hiến
@property(assign, nonatomic) long   dynamicScore; // Điểm năng động
@end
