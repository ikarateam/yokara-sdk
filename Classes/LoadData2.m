//
//  LoadData2.m
//  YokaraKaraoke
//
//  Created by Admin on 23/05/2022.
//  Copyright © 2022 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "LoadData2.h"
#include <sys/xattr.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <sys/utsname.h>
#import <GZIP/GZIP.h>
@implementation NSNull (IntValue)
-(int)intValue { return 0 ; }
-(int)integerValue { return 0 ; }
@end
@implementation LoadData2
int demShowAlertRate;
NSInteger selectedMenuIndex;

CGFloat percentUploadImage;
BOOL HasConnectTVYokara;
NSInteger tabSelected;
BOOL getLinkFromYoutube;
NSString *regularExpression;
NSString * YoutubeGetVideo;
NSString * userAgent;
NSString * locationNow;
NSString * videoQuality;
double timeAudioRecord;
Song *songPlay;
Recording *songRec;
BOOL VipMember;
AVAudioPlayer *audioPlayRecorder;
BOOL finishTopSong;
NSMutableArray *dataTopRecordDay;

BOOL isIphone5s;
BOOL uploadToServer;


int timeChangeBackground;
BOOL autoChangeBackground;
int reverbVolume;
long serverTimeOffset;

BOOL isShowingADVN;
int demQuangCao;
BOOL hasLogin;
GetAccountInfoResponse *AccountVIPInfo;
BOOL userOtherServer;
BOOL isPlayYoutubeVideo;
BOOL hasLoadYoutubePlayer;
BOOL youtubePlayerIsPlay;
BOOL  isExitPlayRecord;
BOOL pauseFromControl;
BOOL useBackCamera;
BOOL isFinalLoadRecord;
GetMyRecordingsResponse *recordSVList;
BOOL pushToInit;
BOOL didEnterBackground;
UIBackgroundTaskIdentifier bgTask2;
User * currentFbUser;
BOOL enableSendLogFirebase;
GetLastestVersionResponse * responeLastest;
NSMutableArray <YTPatternRequest> * YTpatternRequest;
NSString * getYTDirectLink;
NSString *regularExpression;
NSString * YoutubeGetVideo;
NSString * userAgent;
BOOL isLastestVersion;
BOOL isReviewing;
BOOL showAdmobFirst;
BOOL showAllPaymentMethods;
BOOL showCardPayment;
BOOL showSmsPayment;
NSString * SearchApiKeyYT;
NSData *dataHomeShop;
NSMutableArray * dataRecord;
 NSMutableArray *dataRecordAskDuet;
 NSMutableArray * dataRecordUpload;
NSMutableArray * dataKara;
NSMutableArray * dataFavoriteDownloaded;
NSMutableArray *listSongMyAskDuet;
ContestRules *contestRules;
NSInteger menuSelected;
-(NSString *)normalizeVietnameseString:(NSString *)str {
    if (str==nil) str=@"";
    NSMutableString *originStr = [NSMutableString stringWithString:str];
    CFStringNormalize((CFMutableStringRef)originStr, kCFStringNormalizationFormD);
    
    CFStringFold((CFMutableStringRef)originStr, kCFCompareDiacriticInsensitive, NULL);
    
    NSString *finalString1 = [originStr stringByReplacingOccurrencesOfString:@"u0111"withString:@"d"];
    
    NSString *finalString2 = [finalString1 stringByReplacingOccurrencesOfString:@"u0110"withString:@"D"];
    NSString *finalString3 = [finalString2 stringByReplacingOccurrencesOfString:@"Đ"withString:@"D"];
    NSString *finalString4 = [finalString3 stringByReplacingOccurrencesOfString:@"đ"withString:@"d"];
    NSString *finalString5 = [finalString4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return finalString5;
}
#pragma mark time
- (NSString *) prettyTimeContest:(NSString *)timeCmt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmtZone];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSDate *datetime= [dateFormatter dateFromString:timeCmt];
    if (datetime==nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        datetime= [dateFormatter dateFromString:timeCmt];
    }
    [timeFormatter setDateFormat:@"HH:mm 'ngày' dd/MM/yyyy"];
    //[dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *result;
    result=[timeFormatter stringFromDate:datetime];
    //result=[NSString stringWithFormat:@"%@ ngày %@",[timeFormatter stringFromDate:datetime],[dateFormatter stringFromDate:datetime]];
    // double secondsInAnHour = 3600;
    // double secondsInAnMinute = 60;
    
    return result;
}
- (NSString *) prettyTimeVIPDate:(NSString *)timeCmt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmtZone];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSDate *datetime= [dateFormatter dateFromString:timeCmt];
    if (datetime==nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        datetime= [dateFormatter dateFromString:timeCmt];
    }
    [timeFormatter setDateFormat:@"dd/MM/yyyy"];
    //[dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *result;
    result=[timeFormatter stringFromDate:datetime];
    //result=[NSString stringWithFormat:@"%@ ngày %@",[timeFormatter stringFromDate:datetime],[dateFormatter stringFromDate:datetime]];
    // double secondsInAnHour = 3600;
    // double secondsInAnMinute = 60;
    
    return result;
}
- (NSString *) formatNumber:(long) number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    
    NSString* str = [NSString stringWithFormat:@"%@",
                     [numberFormatter stringForObjectValue:[NSNumber numberWithLong:number]]];
    return str;
}


- (NSString *)parseDuration:(NSString *)duration {
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    NSRange timeRange = [duration rangeOfString:@"T"];
    duration = [duration substringFromIndex:timeRange.location];
    
    while (duration.length > 1) {
        duration = [duration substringFromIndex:1];
        
        NSScanner *scanner = [NSScanner.alloc initWithString:duration];
        NSString *part = [NSString.alloc init];
        [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&part];
        
        NSRange partRange = [duration rangeOfString:part];
        
        duration = [duration substringFromIndex:partRange.location + partRange.length];
        
        NSString *timeUnit = [duration substringToIndex:1];
        if ([timeUnit isEqualToString:@"H"])
            hours = [part integerValue];
        else if ([timeUnit isEqualToString:@"M"])
            minutes = [part integerValue];
        else if ([timeUnit isEqualToString:@"S"])
            seconds = [part integerValue];
    }
    if (hours>0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    
}
- (double )parseDurationToSecond:(NSString *)duration {
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    NSRange timeRange = [duration rangeOfString:@"T"];
    duration = [duration substringFromIndex:timeRange.location];
    
    while (duration.length > 1) {
        duration = [duration substringFromIndex:1];
        
        NSScanner *scanner = [NSScanner.alloc initWithString:duration];
        NSString *part = [NSString.alloc init];
        [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&part];
        
        NSRange partRange = [duration rangeOfString:part];
        
        duration = [duration substringFromIndex:partRange.location + partRange.length];
        
        NSString *timeUnit = [duration substringToIndex:1];
        if ([timeUnit isEqualToString:@"H"])
            hours = [part integerValue];
        else if ([timeUnit isEqualToString:@"M"])
            minutes = [part integerValue];
        else if ([timeUnit isEqualToString:@"S"])
            seconds = [part integerValue];
    }
    
    return hours*3600+minutes*60+seconds;
}
- (NSString *) thoigian:(NSString *)timeCmt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmtZone];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSDate *datetime= [dateFormatter dateFromString:timeCmt];
    if (datetime==nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [dateFormatter setTimeZone:gmtZone];
        [dateFormatter setLocale:[NSLocale systemLocale]];
        datetime= [dateFormatter dateFromString:timeCmt];
    }
    NSDate *dateNow= [NSDate date];
    NSString *result;
    NSTimeInterval distanceBetweenDates = [dateNow timeIntervalSinceDate:datetime];
    double secondsInAnHour = 3600;
    double secondsInAnMinute = 60;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    NSInteger minuteBetweenDates = distanceBetweenDates / secondsInAnMinute;
    if (minuteBetweenDates==0){
        result=[NSString stringWithFormat:AMLocalizedString(@"vài giây trước",nil)];
    }else if (minuteBetweenDates<60){
        result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),minuteBetweenDates,AMLocalizedString(@"phút trước",nil)];
    }else
        if (hoursBetweenDates<24) {
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates,AMLocalizedString(@"giờ trước",nil)];
        }else if (hoursBetweenDates>=24 && hoursBetweenDates<24*30){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/24,AMLocalizedString(@"ngày trước",nil)];
        }else if (hoursBetweenDates>=24*30 && hoursBetweenDates<24*30*12){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30),AMLocalizedString(@"tháng trước",nil)];
        }else{
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30*12),AMLocalizedString(@"năm trước",nil)];
        }
    return result;
}
- (NSString *) thoigianFir:(long )serverTimestamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    // [dateFormatter setTimeZone:gmtZone];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    double timeL = serverTimestamp/1000;
    NSDate *datetime= [NSDate dateWithTimeIntervalSince1970:timeL];
    
    NSString *result = [dateFormatter stringFromDate:datetime];;
    
    return result;
}
- (NSString *) thoigianHourFir:(long )serverTimestamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH : mm\ndd/MM"];
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+7"];
    // [dateFormatter setTimeZone:gmtZone];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    double timeL = serverTimestamp/1000;
    NSDate *datetime= [NSDate dateWithTimeIntervalSince1970:timeL];
    
    NSString *result = [dateFormatter stringFromDate:datetime];;
    
    return result;
}
- (NSString *) thoigian3:(NSDate *)datetime{
    
    NSDate *dateNow= [NSDate date];
    NSString *result;
    NSTimeInterval distanceBetweenDates = [dateNow timeIntervalSinceDate:datetime];
    double secondsInAnHour = 3600;
    double secondsInAnMinute = 60;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    NSInteger minuteBetweenDates = distanceBetweenDates / secondsInAnMinute;
    if (minuteBetweenDates==0){
        result=[NSString stringWithFormat:AMLocalizedString(@"vài giây trước",nil)];
    }else if (minuteBetweenDates<60){
        result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),minuteBetweenDates,AMLocalizedString(@"phút trước",nil)];
    }else
        if (hoursBetweenDates<24) {
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates,AMLocalizedString(@"giờ trước",nil)];
        }else if (hoursBetweenDates>=24 && hoursBetweenDates<24*30){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/24,AMLocalizedString(@"ngày trước",nil)];
        }else if (hoursBetweenDates>=24*30 && hoursBetweenDates<24*30*12){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30),AMLocalizedString(@"tháng trước",nil)];
        }else{
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30*12),AMLocalizedString(@"năm trước",nil)];
        }
    return result;
}
- (NSString *) thoigian4:(NSDate *)datetime{
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    NSDateComponents *components2 = [calendar components:units fromDate:datetime];
    
    
    NSString *result;
    
    if ([components year]>[components2 year]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd/MM/yy"];
        result=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datetime] ];
    } else if ([components month]>[components2 month]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM dd"];
        result=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datetime] ];
    } else if ([components day]>[components2 day]+7){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM dd"];
        result=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datetime] ];
    }else if ([components day]>[components2 day]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"E"];
        result=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datetime] ];
    }else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm a"];
        result=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datetime] ];
    }
    return result;
}
- (NSString *) thoigianNoGMT:(NSString *)timeCmt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSDate *datetime= [dateFormatter dateFromString:timeCmt];
    if (datetime==nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        datetime= [dateFormatter dateFromString:timeCmt];
    }
    NSDate *dateNow= [NSDate date];
    NSString *result;
    NSTimeInterval distanceBetweenDates = [dateNow timeIntervalSinceDate:datetime];
    double secondsInAnHour = 3600;
    double secondsInAnMinute = 60;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    NSInteger minuteBetweenDates = distanceBetweenDates / secondsInAnMinute;
    if (minuteBetweenDates==0){
        result=[NSString stringWithFormat:AMLocalizedString(@"vài giây trước",nil)];
    }else if (minuteBetweenDates<60){
        result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),minuteBetweenDates,AMLocalizedString(@"phút trước",nil)];
    }else
        if (hoursBetweenDates<24) {
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates,AMLocalizedString(@"giờ trước",nil)];
        }else if (hoursBetweenDates>=24 && hoursBetweenDates<24*30){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/24,AMLocalizedString(@"ngày trước",nil)];
        }else if (hoursBetweenDates>=24*30 && hoursBetweenDates<24*30*12){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30),AMLocalizedString(@"tháng trước",nil)];
        }else{
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30*12),AMLocalizedString(@"năm trước",nil)];
        }
    return result;
}
- (NSString *) thoigian2:(NSString *)timeCmt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmtZone];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *datetime= [dateFormatter dateFromString:timeCmt];
    NSDate *dateNow= [NSDate date];
    NSString *result;
    NSTimeInterval distanceBetweenDates = [dateNow timeIntervalSinceDate:datetime];
    double secondsInAnHour = 3600;
    double secondsInAnMinute = 60;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    NSInteger minuteBetweenDates = distanceBetweenDates / secondsInAnMinute;
    if (minuteBetweenDates==0){
        result=[NSString stringWithFormat:AMLocalizedString(@"vài giây trước",nil)];
    }else if (minuteBetweenDates<60){
        result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),minuteBetweenDates,AMLocalizedString(@"phút trước",nil)];
    }else
        if (hoursBetweenDates<24) {
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates,AMLocalizedString(@"giờ trước",nil)];
        }else if (hoursBetweenDates>=24 && hoursBetweenDates<24*30){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/24,AMLocalizedString(@"ngày trước",nil)];
        }else if (hoursBetweenDates>=24*30 && hoursBetweenDates<24*30*12){
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30),AMLocalizedString(@"tháng trước",nil)];
        }else{
            result=[NSString stringWithFormat:@"%@%d%@",AMLocalizedString(@"thêm",@" "),hoursBetweenDates/(24*30*12),AMLocalizedString(@"năm trước",nil)];
        }
    
    return result;
}
#pragma mark Family
- (PromotedResponse *) AcceptInviteJoinFamily:(NSString *) fbId{
    NSError* error;
    NSHTTPURLResponse *response;
    PromotedRequest *getSongRequest = [[PromotedRequest alloc] init];
    getSongRequest.userId =[self idForDevice];
    getSongRequest.language=Language;
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.facebookId=fbId;
    
    NSString *parameters = [getSongRequest toJSONString];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_AcceptInviteJoinFamily]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]  initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    PromotedResponse *getSongResponse = [[PromotedResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    NSLog(@"reply from server:AcceptInviteJoinFamily= %@",stringReply);
    
    return getSongResponse;
}
- (PromotedResponse *) familyPromoted:(NSString *) fbId{
    NSError* error;
    NSHTTPURLResponse *response;
    PromotedRequest *getSongRequest = [[PromotedRequest alloc] init];
    getSongRequest.userId =[self idForDevice];
    getSongRequest.language=Language;
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.facebookId=fbId;
    
    NSString *parameters = [getSongRequest toJSONString];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_FamilyPromoted]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]  initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    PromotedResponse *getSongResponse = [[PromotedResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    NSLog(@"reply from server:PromotedResponse= %@",stringReply);
    
    return getSongResponse;
}
- (DegradedResponse *) familyDegraded:(NSString *) fbId{
    NSError* error;
    NSHTTPURLResponse *response;
    DegradedRequest *getSongRequest = [[DegradedRequest alloc] init];
    getSongRequest.userId =[self idForDevice];
    getSongRequest.language=Language;
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.facebookId=fbId;
    
    NSString *parameters = [getSongRequest toJSONString];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_FamilyDegraded]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]  initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    DegradedResponse *getSongResponse = [[DegradedResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    NSLog(@"reply from server:DegradedResponse= %@",stringReply);
    
    return getSongResponse;
}
- (ExpelFromFamilyResponse *) familyExpelFromFamily:(NSString *) fbId{
    NSError* error;
    NSHTTPURLResponse *response;
    ExpelFromFamilyRequest *getSongRequest = [[ExpelFromFamilyRequest alloc] init];
    getSongRequest.userId =[self idForDevice];
    getSongRequest.language=Language;
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.facebookId=fbId;
    
    NSString *parameters = [getSongRequest toJSONString];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_FamilyExpel]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]  initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    ExpelFromFamilyResponse *getSongResponse = [[ExpelFromFamilyResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    NSLog(@"reply from server:ExpelFromFamilyResponse= %@",stringReply);
    
    return getSongResponse;
}
- (UpdateFacebookNoForRecordingResponse *) updateRecording:(Recording *) record{
    NSError* error;
    NSHTTPURLResponse *response;
    UpdateRecordingRequest *getSongRequest = [[UpdateRecordingRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.recording=record;
    /*
     getSongRequest.recording.sex=record.sex;
     
     NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
     if (gender.length>0) {
     if ([gender isEqualToString:@"female"]) {
     getSongRequest.recording.sex=@"f";
     }else{
     getSongRequest.recording.sex=@"m";
     }
     }*/
    getSongRequest.recording.song.lyrics=nil;
    NSString *parameters = [getSongRequest toJSONString];
    parameters= [parameters stringByReplacingOccurrencesOfString:@"effectsNew" withString:@"newEffects"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_updateRecording]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"reply::///////////////////////////////////////////////////////////////////// %@",stringReply);
    UpdateFacebookNoForRecordingResponse *getSongResponse = [[UpdateFacebookNoForRecordingResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (DeleteRecordingResponse*) deleteRecording:(NSString *) recordId{
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    DeleteRecordingRequest *getSongRequest = [[DeleteRecordingRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.recordingId=recordId;
    getSongRequest.facebookId=[prefs objectForKey:@"facebookId"];
    getSongRequest.password=[prefs objectForKey:@"password"];
    getSongRequest.language=Language;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_deleteRecording]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"delete record online%@",stringReply);
    DeleteRecordingResponse *getSongResponse = [[DeleteRecordingResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
NSMutableArray *allFollowingUsers;
- (void) getAllFollowUser{
    @autoreleasepool {
        GetAllFollowingUsersResponse *AllFollowRespone = [self GetAllFollowingUsers];
        allFollowingUsers = [NSMutableArray new];
        for (User * us in AllFollowRespone.users) {
            us.nameKoDau = [self normalizeVietnameseString:us.name];
            [allFollowingUsers addObject:us];
        }
    }
}
- (GetAllFollowingUsersResponse* ) GetAllFollowingUsers {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetAllFollowingUsersRequest *getSongRequest = [[GetAllFollowingUsersRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetAllFollowingUsers]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetAllFollowingUsersResponse *getSongResponse = [[GetAllFollowingUsersResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (AddFriendResponse *) AddFriend:(NSString *)toFacebookId{
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    AddFriendRequest *getSongRequest = [[AddFriendRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.platform=@"IOS";
    getSongRequest.toFacebookId=toFacebookId;
    getSongRequest.language=Language;
    getSongRequest.fromFacebookId=[prefs objectForKey:@"facebookId"];
    
    getSongRequest.password=[prefs objectForKey:@"password"];
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_AddFriend]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@reply::///////////////////////////////////////////////////////////////////// %@",parameters,stringReply);
    AddFriendResponse *getSongResponse = [[AddFriendResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    
    return getSongResponse;
}
- (RemoveFriendResponse *) RemoveFriend:(NSString *)toFacebookId{
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    RemoveFriendRequest *getSongRequest = [[RemoveFriendRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.platform=@"IOS";
    getSongRequest.toFacebookId=toFacebookId;
    getSongRequest.language=Language;
    getSongRequest.fromFacebookId=[prefs objectForKey:@"facebookId"];
    getSongRequest.password=[prefs objectForKey:@"password"];
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_RemoveFriend]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"RemoveFriend %@: %@",parameters, stringReply);
    RemoveFriendResponse *getSongResponse = [[RemoveFriendResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (GetLastestVersionResponse *) getLastestVersion{
    NSError* error;
    NSHTTPURLResponse *response;
    GetLastestVersionRequest *getSongRequest = [[GetLastestVersionRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *modelDevice=machineName2();
    UIDevice *device=[UIDevice currentDevice];
    getSongRequest.device=modelDevice ;
    getSongRequest.model=[[UIDevice currentDevice] model] ;
    getSongRequest.product=modelDevice ;
    getSongRequest.versionSdk=[[UIDevice currentDevice] systemVersion] ;
    getSongRequest.brand=@"Apple";
    getSongRequest.firebaseAppInstanceId = [FIRAnalytics appInstanceID];
    //getSongRequest.localIp = [self getIPAddress:YES];
    viewedBanners=[[[NSUserDefaults standardUserDefaults] objectForKey:@"viewedBanners"] mutableCopy];
    if (viewedBanners.count>0) {
        getSongRequest.viewedBanner=viewedBanners;
    }else{
        viewedBanners=[NSMutableArray new];
    }
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetLastestVersion]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA           returningResponse:&response error:&error]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"reply::///////////////////////////////////////////////////////////////////// %@",stringReply);
    GetLastestVersionResponse *getSongResponse = [[GetLastestVersionResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    if (getSongResponse.banners.count>0) {
        listBanners=[NSMutableArray new];
        listBanners=[NSMutableArray arrayWithArray: getSongResponse.banners];
        [[NSUserDefaults standardUserDefaults] setObject:stringReply forKey:@"GetLastestVersionResponse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (getSongResponse.copyrightedSong.count>0) {
        listCopyrightedSong = [NSMutableArray new];
        listCopyrightedSong = [NSMutableArray arrayWithArray:getSongResponse.copyrightedSong];
    }
    if ([getSongResponse.topRecordingsRules isKindOfClass:[ContestRules class]]) {
        
        contestRules = getSongResponse.topRecordingsRules;
    }
    return getSongResponse;
}
- (UploadRecordingResponse *) uploadRecordToServer:(Recording *) record andSong: (Song *) songss andName: (NSString *) name andMessage: (NSString *) message andUrl:(NSString *) urlUpload{ //andLyric: (NSString *) selectLyric {
    NSError* error;
    NSHTTPURLResponse *response;
    Recording * recording=[Recording new];
    recording.song=[Song new];
    //recording.effects=[EffectsR new];
    recording.ownerId=[self idForDevice];
    recording.songId = record.songId;
    recording._id=record.songId;
    recording.song = songss;
    recording.effectsNew=record.effectsNew;
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    //NSLog(@"%@",dateString);
    recording.playWithMusic =[NSNumber numberWithInt: 1];
    recording.recordingTime = record.recordingTime;
    recording.vocalUrl = record.vocalUrl;
    recording.onlineVocalUrl= record.onlineVocalUrl;
    recording.mixedRecordingVideoUrl= record.mixedRecordingVideoUrl;
    recording.onlineMp3Recording= record.onlineMp3Recording;
    recording.totalRating =0;
    recording.ratingCount =0;
    recording.avgRating = 0;
    recording.bitRate =[NSNumber numberWithLong:44100];
    recording.delay=[NSNumber numberWithDouble:[ record.delay floatValue]];
    recording.yourRating =0;
    recording.noChannels =[NSNumber numberWithInt: 1];
    recording.yourName = name;
    recording.message = message;
    
    recording.effects=record.effects;
    recording.selectedLyric = record.selectedLyric;
    recording.deviceName=record.deviceName;
    if (recording.deviceName.length==0) {
        recording.deviceName= [[LoadData2 alloc] getDeviceName];
    }
    recording.effects.toneShift=[NSNumber numberWithInteger:[record.effects.toneShift integerValue]];
    recording.recordDevice=record.recordDevice;
    recording.privacyLevel=record.privacyLevel;
    recording.performanceType=record.performanceType;
    recording.originalRecording=record.originalRecording;
    recording.sex=record.sex;
    
    NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    if (gender.length>0) {
        if ([gender isEqualToString:@"female"]) {
            recording.sex=@"f";
        }else{
            recording.sex=@"m";
        }
    }
    if (![recording.sex isKindOfClass:[NSString class]]) {
        recording.sex=@"m";
    }
    //if (![record.performanceType isEqualToString:@"DUET"]) {
    recording.lyric=record.lyric;
    //}
    if ([record.performanceType isEqualToString:@"ASK4DUET"]) {
        if (![recording.lyric isKindOfClass:[Lyric class]]) {
            recording.lyric=[Lyric new];
            recording.lyric.key=songRec.selectedLyric;
            if (recording.lyric.key.length>0) {
                recording.lyric.type=[NSNumber numberWithInt:XML];
                NSString* lyricJson=[[NSUserDefaults standardUserDefaults] objectForKey:recording.lyric.key];
                if (lyricJson.length>4) {
                    recording.lyric.content=lyricJson;
                    
                }
                
                
            }
            
            
            
        }
        
    }
    
    UploadRecordingRequest *getSongRequest = [[UploadRecordingRequest alloc] init];
    getSongRequest.userId =[self idForDevice];
    getSongRequest.yourName= name;
    getSongRequest.message = message;
    getSongRequest.recording = recording;
    getSongRequest.language=Language;
    
    NSString *parameters = [getSongRequest toJSONString];
    parameters= [parameters stringByReplacingOccurrencesOfString:@"effectsNew" withString:@"newEffects"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_uploadRecordToServer]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    // parameters=(NSMutableString*) [parameters stringByReplacingOccurrencesOfString:@"\"owner\":null," withString:@""];
    // NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    // NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",stringReply);
    stringReply= [stringReply stringByReplacingOccurrencesOfString:@"newEffects" withString:@"effectsNew"];
    UploadRecordingResponse *getSongResponse = [[UploadRecordingResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    NSLog(@"uploadRecordToServer %@: %@",parameters, stringReply);
    
    if (getSongResponse.recording.onlineRecordingUrl!=nil) {
        if ([getSongResponse.recording._id longValue]>0) {
            if ([[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:R_IDR fieldValue1:[NSString stringWithFormat:@"%@",getSongResponse.recording._id] withCondition:R_DATE conditionValue:record.recordingTime]) {
                NSLog(@"update record id" );
            }
        }
        
        if ([[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:R_CONVERT fieldValue1:@"YES" withField2:R_ONLINERECORDURL fieldValue2:getSongResponse.recording.onlineRecordingUrl withField3:R_YOURNAME fieldValue3:name withField4:R_YOURMESSAGE fieldValue4:message withField5:R_PRIVATEID fieldValue5:getSongResponse.recording.recordingId withCondition:R_DATE conditionValue:record.recordingTime]) NSLog(@"update record" );
    }
    return getSongResponse;
}
- (NSString *) getAllSongDB {
    NSMutableArray<Song> * dataFavoriteS = [NSMutableArray<Song> new];
    NSMutableArray *favoriteSong = [[DBHelperYokaraSDK alloc] loadFavorSong];
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath;
    BOOL haveS=NO;
    AllSongDB * dbr = [AllSongDB new];
    dbr.songs = [NSMutableArray<Song>  new];
    for (int j=0; j< favoriteSong.count; j++){
        
        Song *song=[Song new];
        song._id =[[favoriteSong objectAtIndex:j] objectAtIndex:0];
        song.songName =[[favoriteSong objectAtIndex:j] objectAtIndex:1];
        song.singerName = [[favoriteSong objectAtIndex:j] objectAtIndex:2];
        song.songUrl =[[favoriteSong objectAtIndex:j] objectAtIndex:3];
        //song.approvedLyric =[[favoriteSong objectAtIndex:j] objectAtIndex:4];
        //song.status = [[favoriteSong objectAtIndex:j] objectAtIndex:5];
        song.viewCounter =[[favoriteSong objectAtIndex:j] objectAtIndex:6];
        song.selectedLyric=[[favoriteSong objectAtIndex:j] objectAtIndex:7];
       
        song.videoId=[NSString stringWithFormat:@"%@", [[favoriteSong objectAtIndex:j] objectAtIndex:10]];
        song.likeCounter=[[favoriteSong objectAtIndex:j] objectAtIndex:11];
        song.dislikeCounter=[[favoriteSong objectAtIndex:j] objectAtIndex:12];
        song.duration=[[favoriteSong objectAtIndex:j] objectAtIndex:14];
        song.thumbnailUrl=[[favoriteSong objectAtIndex:j] objectAtIndex:13];
       // song.owner=[[favoriteSong objectAtIndex:j] objectAtIndex:16];
        //song.mp4link =[[favoriteSong objectAtIndex:j] objectAtIndex:18];
        song.dateTime=[[favoriteSong objectAtIndex:j] objectAtIndex:19];
        if (song.owner==nil || [song.owner isKindOfClass:[NSNull class]]){
            song.owner=nil;
        }
        if (![song.viewCounter isKindOfClass:[NSNumber class]]) {
            song.viewCounter=@0;
        }
        if (![song.selectedLyric isKindOfClass:[NSString class]]) {
            song.selectedLyric=nil;
        }
        if (![song.approvedLyric isKindOfClass:[NSString class]]) {
            song.approvedLyric=nil;
        }
        
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",song._id]];
        if ([song.videoId isKindOfClass:[NSString class]]){
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",song.videoId]];
            
        }else if ([song.songUrl isKindOfClass:[NSString class]]){
            if ([song.songUrl hasSuffix:@"m4a"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",song._id]];
            }
        }
        haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (haveS) {
            song.status = 2;
            
        }else {
            song.status = 1;
        }
        if (![song.videoId isEqualToString:@"<null>"]) {
            [dbr.songs addObject:song];
        }
    }
   
    NSLog(@"dbr %@",[dbr toJSONString]);
    return [dbr toJSONString];
}
- (NSString *) getAllRecordDB{
    NSMutableArray<Recording> * dataRecord2 = [NSMutableArray<Recording> new];
    NSMutableArray *recordList= [[DBHelperYokaraSDK alloc] loadRecordSong];
    for (int j=0; j< recordList.count; j++){
        Recording *rec=[Recording new];
        rec.song=[Song new];
        rec.effects=[EffectsR new];
        if ([Language hasSuffix:@"kara"]){
            rec.song.thumbnailUrl = [[recordList objectAtIndex:j] objectAtIndex:2];
            rec.song.videoId= [[recordList objectAtIndex:j] objectAtIndex:0];
            rec.song.duration= [[recordList objectAtIndex:j] objectAtIndex:23];
            rec.song.singerName=@"";
            rec._id= [[recordList objectAtIndex:j] objectAtIndex:31];
        }else{
            rec._id= [[recordList objectAtIndex:j] objectAtIndex:0];
            rec.songId=[[recordList objectAtIndex:j] objectAtIndex:0];
            rec.song.singerName = [[recordList objectAtIndex:j] objectAtIndex:2];
            rec.song._id= [[recordList objectAtIndex:j] objectAtIndex:0];
        }
        rec.song.songName = [[recordList objectAtIndex:j] objectAtIndex:1];
        rec.recordingTime = [[recordList objectAtIndex:j] objectAtIndex:3];
        
        //rec.size = [[recordList objectAtIndex:j] objectAtIndex:4];
        rec.vocalUrl=[[recordList objectAtIndex:j] objectAtIndex:8];
        rec.song.songUrl =[[recordList objectAtIndex:j] objectAtIndex:6];
        if (rec.song.songUrl.length>0) {
            if ([rec.song.songUrl hasSuffix:@".mp4"]) {
                rec.mixedRecordingVideoUrl=rec.song.songUrl;
            }
        }
        
        rec.performanceType =[[recordList objectAtIndex:j] objectAtIndex:7];
        if (![rec.performanceType isKindOfClass:[NSString class]]) {
            rec.performanceType=@"SOLO";
        }
        rec->hasUpload =[[recordList objectAtIndex:j] objectAtIndex:5];
        rec.onlineRecordingUrl=[[recordList objectAtIndex:j] objectAtIndex:9];
        rec.yourName =[[recordList objectAtIndex:j] objectAtIndex:10];
        rec.message = [[recordList objectAtIndex:j] objectAtIndex:11];
        rec.recordingId = [[recordList objectAtIndex:j] objectAtIndex:12];
        rec.onlineVocalUrl =[[recordList objectAtIndex:j] objectAtIndex:13];
        rec.delay =(NSNumber *)[[recordList objectAtIndex:j] objectAtIndex:14];
        rec.selectedLyric=[[recordList objectAtIndex:j] objectAtIndex:15];
        rec.noComment=[[recordList objectAtIndex:j] objectAtIndex:18];
        rec.noLike=[[recordList objectAtIndex:j] objectAtIndex:16];
        rec.viewCounter=[[recordList objectAtIndex:j] objectAtIndex:17];
        rec.effects.musicVolume=(NSNumber *)[[recordList objectAtIndex:j] objectAtIndex:19];
        rec.effects.vocalVolume=(NSNumber *)[[recordList objectAtIndex:j] objectAtIndex:20];
        rec.effects.echo =(NSNumber *)[[recordList objectAtIndex:j] objectAtIndex:21];
        rec.effects.treble =(NSNumber *)[[recordList objectAtIndex:j] objectAtIndex:22];
        //rec.song.mp4link =[[recordList objectAtIndex:j] objectAtIndex:24];
        rec.effects.bass =(NSNumber *)[[recordList objectAtIndex:j] objectAtIndex:25];
        rec.originalRecording = [[recordList objectAtIndex:j] objectAtIndex:26];
        rec.thumbnailImageUrl= [[recordList objectAtIndex:j] objectAtIndex:27];
        rec.recordDevice= [[recordList objectAtIndex:j] objectAtIndex:28];
        rec.onlineVoiceUrl= [[recordList objectAtIndex:j] objectAtIndex:29];
        if (![rec.viewCounter isKindOfClass:[NSNumber class]]) {
            rec.viewCounter=@0;
        }
        if (![rec.onlineVoiceUrl isKindOfClass:[NSString class]]) {
            rec.onlineVoiceUrl=nil;
        }
        if (![rec.recordingId isKindOfClass:[NSString class]]) {
            rec.recordingId=nil;
        }
        if (![rec.onlineVocalUrl isKindOfClass:[NSString class]]) {
            rec.onlineVocalUrl=nil;
        }
        if (![rec.onlineRecordingUrl isKindOfClass:[NSString class]]) {
            rec.onlineRecordingUrl=nil;
        }
        if (![rec.selectedLyric isKindOfClass:[NSString class]]) {
            rec.selectedLyric=nil;
        }
        if (![rec.originalRecording isKindOfClass:[NSString class]]) {
            rec.originalRecording=nil;
        }
        NSString *newEffectString= [[recordList objectAtIndex:j] objectAtIndex:30];
        if ([newEffectString isKindOfClass:[NSString class]]) {
            rec.effectsNew= [[NewEffects alloc] initWithString:newEffectString error:nil];
        }
        rec.recordingType= [[recordList objectAtIndex:j] objectAtIndex:32];
        if (![rec.recordingType isKindOfClass:[NSString class]]) {
            rec.recordingType=nil;
        }
        if ([rec.thumbnailImageUrl isKindOfClass:[NSNull class]]) {
            rec.thumbnailImageUrl=@"";
        }
        
        [dataRecord2 addObject:rec];
        
        
    }
    AllRecordingDB * dbr = [AllRecordingDB new];
    dbr.recordings = dataRecord2;
    return [dbr toJSONString];
}
- (GetLyricResponse *) getLyricData:(NSString *) idS {
    NSError* error;
    NSHTTPURLResponse *response;
    GetLyricRequest *getSongRequest = [[GetLyricRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.lyricKey=idS;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_getLyricData]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"reply::///////////////////////////////////////////////////////////////////// %@",stringReply);
    GetLyricResponse *getSongResponse = [[GetLyricResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
NSMutableArray *dataFavorite;
- (void) addFavorite:(NSNumber *) idsong{
    
 
    
}
- (void) addFavoriteKara:(NSString *) videoId{
    
  
    
}
- (void) addRecord:(Recording *) songss{
    
    
    Recording *rec=songss;
    
    
    
}
- (void) removeRecord:(NSString *) date{
  
    
}
- (void) removeFavorite:(NSNumber *) idsong{
   
    
    
}
- (void) removeFavoriteKara:(NSString *) idsong{
   
    
    
}
- (void) addDownloadSong:(NSNumber *) idsong{
  
    
}

+ (void)openSettings
{
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}
+(BOOL)isHaveRegistrationForNotification{
    
    //For ios >= 8.0
    if  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    
    //For ios < 8
    else{
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        BOOL deviceEnabled = !(types == UIRemoteNotificationTypeNone);
        return deviceEnabled;
    }
}
- (void) LoadlastestVersion{
    @autoreleasepool {
        
        [NSThread detachNewThreadSelector:@selector(getAllFollowUser) toTarget:self withObject:nil];
        if ([Language hasSuffix:@"kara"]){
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            BOOL LastestVersion=[prefs boolForKey:@"isLastestVersion"];
            isReviewing=[prefs boolForKey:@"Reviewing"];
            
            responeLastest=[[LoadData2 alloc] getLastestVersion];
            
            isLastestVersion=!LastestVersion;
            if (responeLastest) {
                SearchApiKeyYT = [responeLastest.properties objectForKey:@"YTApiKey" ];
                NSString * getLink=[responeLastest.properties objectForKey:@"useServerParser" ];
                YoutubeGetVideo=[responeLastest.properties objectForKey:@"urlTemplate" ];
                NSString * version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                //float verCurrent=[version doubleValue];
                //float verLastest=[responeLastest.lastestVersionName doubleValue];
                
                NSString * isReview=[responeLastest.properties objectForKey:@"isReviewing" ];
                YTpatternRequest = responeLastest.YTPatternRequests;
                getYTDirectLink = [responeLastest.properties objectForKey:@"GETYTDIRECTLINK" ];
                
                if (isReview.length>0){
                    if ([isReview isEqualToString:@"TRUE"]){
                        isReviewing=NO;
                        LastestVersion=NO;
                        //NSString * lan=LocalizationGetLanguage;
                        // Language = @"lo.okara";
                        // LocalizationSetLanguage(@"lo");
                        [prefs setBool:NO forKey:@"isLastestVersion"];
                    }else {
                        //
                        
                        // LocalizationSetLanguage(@"vi");
                        isReviewing=YES;
                        LastestVersion=YES;
                        [prefs setBool:YES forKey:@"isLastestVersion"];
                        //[NSThread sleepForTimeInterval:10];
                    }
                    
                    
                    [prefs synchronize];
                    isLastestVersion=!LastestVersion;
                    [prefs setBool:isReviewing forKey:@"Reviewing"];
                    [prefs synchronize];
                }else {
                    isReviewing=NO;
                    
                }
                if (!isReviewing) {
                    listBanners =[NSMutableArray new];
                }
                //LocalizationSetLanguage(@"lo");
                NSString * showAdmobFirs=[responeLastest.properties objectForKey:@"showAdmobFirst" ];
                if (showAdmobFirs.length>0){
                    if ([showAdmobFirs isEqualToString:@"TRUE"]){
                        showAdmobFirst=YES;
                    }else {
                        showAdmobFirst=NO;
                    }
                    [prefs setBool:showAdmobFirst forKey:@"showAdmobFirst"];
                    [prefs synchronize];
                }else {
                    showAdmobFirst=YES;
                }
                NSString * showAllPayment=[responeLastest.properties objectForKey:@"showExtraPayment" ];
                if (showAllPayment.length>0){
                    if ([showAllPayment isEqualToString:@"TRUE"]){
                        showAllPaymentMethods=YES;
                    }else {
                        showAllPaymentMethods=NO;
                    }
                    [prefs setBool:showAllPaymentMethods forKey:@"showAllPaymentMethods"];
                    [prefs synchronize];
                }else {
                    showAllPaymentMethods=NO;
                }
                NSString * showCardPaymentS=[responeLastest.properties objectForKey:@"showCardPayment" ];
                if (showCardPaymentS.length>0){
                    if ([showCardPaymentS isEqualToString:@"TRUE"]){
                        showCardPayment=YES;
                    }else {
                        showCardPayment=NO;
                    }
                    [prefs setBool:showCardPayment forKey:@"showCardPayment"];
                    [prefs synchronize];
                }else {
                    showCardPayment=NO;
                }
                
                NSString * showSmsPaymentS=[responeLastest.properties objectForKey:@"showSmsPayment" ];
                if (showSmsPaymentS.length>0){
                    if ([showSmsPaymentS isEqualToString:@"TRUE"]){
                        showSmsPayment=YES;
                    }else {
                        showSmsPayment=NO;
                    }
                    [prefs setBool:showSmsPayment forKey:@"showSmsPayment"];
                    [prefs synchronize];
                }else {
                    showSmsPayment=NO;
                }
                
                /* if  ([version compare:responeLastest.lastestVersionName options:NSNumericSearch]==NSOrderedDescending){
                 LastestVersion=NO;
                 //NSString * lan=LocalizationGetLanguage;
                 
                 LocalizationSetLanguage(@"vi");
                 [prefs setBool:NO forKey:@"isLastestVersion"];
                 [NSThread sleepForTimeInterval:2];
                 
                 }
                 else {
                 LastestVersion=YES;
                 [prefs setBool:YES forKey:@"isLastestVersion"];
                 }
                 [prefs synchronize];
                 isLastestVersion=!LastestVersion;
                 userAgent=[responeLastest.properties objectForKey:@"userAgent" ];
                 regularExpression=[responeLastest.properties objectForKey:@"regularExpression" ];
                 if (regularExpression==nil) regularExpression=@"(stream_map\": \"(.*?)?\")";
                 if (YoutubeGetVideo==nil) YoutubeGetVideo=@"http://www.youtube.com/watch?v=";
                 if (userAgent==nil) userAgent=@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0.1)";
                 if (getLink) {
                 if ([getLink isEqualToString:@"TRUE"])
                 getLinkFromYoutube=YES;
                 else  getLinkFromYoutube=NO;
                 }*/
                
            }
        }else {
            responeLastest=[[LoadData2 alloc] getLastestVersion];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            //   isLastestVersion=[prefs boolForKey:@"isLastestVersion"];
            if (responeLastest) {
                NSString * version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                
                //float verCurrent=[version doubleValue];
                //float verLastest=[responeLastest.lastestVersionName doubleValue];
                NSString * isReview=[responeLastest.properties objectForKey:@"isReviewing" ];
                if (isReview.length>0){
                    if ([isReview isEqualToString:@"TRUE"]){
                        isReviewing=NO;
                    }else {
                        isReviewing=YES;
                    }
                    [prefs setBool:isReviewing forKey:@"Reviewing"];
                    [prefs synchronize];
                }else {
                    isReviewing=NO;
                }
            }else {
                // showAllPaymentMethods=[prefs boolForKey:@"showAllPaymentMethods"];
                isReviewing=[prefs boolForKey:@"Reviewing"];
                
                
            }
        }
    }
}
NSString *machineName2()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *iOSDeviceModelsPath = [[NSBundle mainBundle] pathForResource:@"iOSDeviceModelMapping" ofType:@"plist"];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:iOSDeviceModelsPath];
    
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    return [iOSDevices valueForKey:deviceModel];
}
- (NSString *) getDeviceName{
    return machineName2();
}

NSMutableArray * viewedBanners;
NSMutableArray * listBanners;
NSMutableArray * listCopyrightedSong;
BOOL alwayPostToFacebook;
- (NSString *) getUrlWithYoutubeVideoId:(NSString * )youtubeID {
    if (youtubeID){
        NSURL *url = [NSURL URLWithString:[YoutubeGetVideo stringByReplacingOccurrencesOfString:@"<YOUTUBEID>" withString:youtubeID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [self sendSynchronousRequestLog:request returningResponse:&response error:&error];
        
        if (!error) {
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            return responseString;
            
        }
    }
    return @"";
}
- (GetSongResponse *) getDataSong:(NSNumber *) idS {
    NSError* error;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSHTTPURLResponse *response;
    GetSongRequest *getSongRequest = [[GetSongRequest alloc] init];
    getSongRequest.userId =[self idForDevice];;
    getSongRequest.songId=  [NSString stringWithFormat:@"%@",idS];
    // getSongRequest.isVIP=[NSNumber numberWithBool:VipMember];
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_getDataSong]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    GetSongResponse *getSongResponse = [[GetSongResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    /*
     if  ([getSongResponse.vipProblem intValue]>0){
     AccountVIPInfo.accountType=@"NORMAL";
     dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
     dispatch_async(queue, ^{
     dispatch_async(dispatch_get_main_queue(), ^{
     [[[[iToast makeText:getSongResponse.message]
     setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
     });
     });
     [prefs setObject:AccountVIPInfo.accountType forKey:@"accountType"];
     //VipMember=NO;
     [prefs synchronize];
     }*/
    return getSongResponse;
}
- (GetYoutubeVideoLinksResponse *) getYoutubeVideoLinks:(NSString *) videoId andContent:(NSString *) content{
    @autoreleasepool {
        
        if (videoId){
            NSError* error;
            NSHTTPURLResponse *response;
            GetYoutubeVideoLinksRequest *getSongRequest = [[GetYoutubeVideoLinksRequest alloc] init];
            getSongRequest.userId = [self idForDevice];
            getSongRequest.platform=@"IOS";
            getSongRequest.language=Language;
            getSongRequest.content=content;
            getSongRequest.videoId=videoId;
            NSString *parameters = [getSongRequest toJSONString];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetYoutubeVideoLinks]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
            NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                             initWithURL:[request URL]];
            [requestA setHTTPMethod:@"POST"];
            
            NSMutableString *postString = [[NSMutableString alloc] init];
            
            //NSLog(@"%@",parameters);
            [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryption:parameters]];
            postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA
                                                              returningResponse:&response error:&error]];
            // NSLog(@"error %@",error);
            NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // NSLog(@"reply::///////////////////////////////////////////////////////////////////// %@",stringReply);
            GetYoutubeVideoLinksResponse *getSongResponse = [[GetYoutubeVideoLinksResponse alloc] initWithString:stringReply error:&error];
            // Some debug code, etc.
            //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
            return getSongResponse;
        }
        return nil;
    }
}
- (NSMutableArray* ) GetYoutubeResponeLink:(NSString *) videoId{
    @autoreleasepool {
        
        
        NSError* error;
        NSHTTPURLResponse *response;
        if (YTpatternRequest==nil){
            [self LoadlastestVersion];
        }
        if (YTpatternRequest.count==0 || [videoId hasPrefix:@"VIDEOSONG"] || ![videoId isKindOfClass:[NSString class]]) {
            
            return nil;
        }
        
        
        NSMutableArray *result = [NSMutableArray new];
        
        //  [self eraseCredentials];
        for (int i=0; i<YTpatternRequest.count; i++) {
            YTPatternRequest *ytrequest=[YTpatternRequest objectAtIndex:i];
            NSMutableString *postString = [[NSMutableString alloc] init];
            for (NSString * key in ytrequest.params.allKeys) {
                [postString appendFormat:( @"%@=%@&"), key, [ytrequest.params objectForKey:key]];
            }
            // postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"hl=en" withString:@"hl=vi"];
            // postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"gl=US" withString:@"hl=VN"];
            if (postString.length>0)
                postString = (NSMutableString*)  [postString substringToIndex:postString.length-1];
            postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            
            postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"<YOUTUBEID>" withString:videoId];
            // postString =(NSMutableString*) [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // NSLog(@"GetYoutubeResponeLink postString  %@",postString);
            NSString *urlString = [NSString stringWithFormat:@"%@?%@",ytrequest.url,postString];
            double timeCall = CACurrentMediaTime();
            
            
            //ytrequest.method = @"POST";
            if ([ytrequest.method isEqualToString:@"POST"]) {
                urlString = [NSString stringWithFormat:@"%@",ytrequest.url];
                
            }
            
            NSURL *url = [NSURL URLWithString:urlString];
            //[self clearCookiesForURL:ytrequest.url];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                             initWithURL:[request URL] ];
            [requestA setHTTPMethod:ytrequest.method];
            [requestA setHTTPShouldHandleCookies:NO];
            [requestA setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
            [requestA setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            
            // [requestA addValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.67 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
            for (NSString * key in ytrequest.headers.allKeys) {
                [requestA setValue:[ytrequest.headers objectForKey:key] forHTTPHeaderField:key];
            }
            //[requestA setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1" forHTTPHeaderField:@"User-Agent"];
            
            if ([ytrequest.method isEqualToString:@"POST"]) {
                [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            // NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]]; //
            NSError __block *err = NULL;
            NSData __block *data;
            BOOL __block reqProcessed = false;
            NSURLResponse __block *resp;
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 30.0;
            sessionConfig.timeoutIntervalForResource = 15.0;
            sessionConfig.HTTPShouldSetCookies = NO;
            sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyNever;
            
            NSURLSession * session=[NSURLSession sessionWithConfiguration:sessionConfig];
            [[session dataTaskWithRequest:requestA completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
                resp = _response;
                err = _error;
                if (err) {
                    NSLog(@"error api %@ %@",request.URL.absoluteString,err.description);
                }
                data = _data;
                reqProcessed = true;
            }] resume];
            
            while (!reqProcessed) {
                [NSThread sleepForTimeInterval:0.1];
            }
            // NSLog(@"GZIP Time Get  - %.4f",CACurrentMediaTime()-timeCall);
            
            //  NSString *stringReply= [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            [ [NSURLCache sharedURLCache] removeCachedResponseForRequest:requestA];
            // NSLog(@" GetYoutubeResponeLink content %d size %d",i+1,data.length/1024);
            //NSString *stringReply= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // NSLog(@"GZIP Time Get 1 - %.4f",CACurrentMediaTime()-timeCall);
            
            data = [data gzippedDataWithCompressionLevel:1.0f];
            
            NSString *stringReply2=[[NSString alloc] initWithData: [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength] encoding:NSUTF8StringEncoding];
            // NSLog(@"GZIP Time Get 2 - %.4f",CACurrentMediaTime()-timeCall);
            [result addObject:stringReply2];
            // NSLog(@"header %@",response.allHeaderFields);
            // break;
        }
        
        
        
        // Some debug code, etc.
        //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
        return result;
        // Some debug code, etc.
        //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    }
}
- (void)clearCookiesForURL:(NSString *)url {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];// cookiesForURL:[NSURL URLWithString:url] ];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Deleting cookie for domain: %@", [cookie domain]);
        [cookieStorage deleteCookie:cookie];
    }
}
- (void) eraseCredentials{
    NSURLCredentialStorage *credentialsStorage = [NSURLCredentialStorage sharedCredentialStorage];
    NSDictionary *allCredentials = [credentialsStorage allCredentials];
    
    //iterate through all credentials to find the twitter host
    for (NSURLProtectionSpace *protectionSpace in allCredentials)
        if ([[protectionSpace host] isEqualToString:@"youtube.com"]){
            //to get the twitter's credentials
            NSDictionary *credentials = [credentialsStorage credentialsForProtectionSpace:protectionSpace];
            //iterate through twitter's credentials, and erase them all
            for (NSString *credentialKey in credentials)
                [credentialsStorage removeCredential:[credentials objectForKey:credentialKey] forProtectionSpace:protectionSpace];
        }
}
- (BOOL) checkVideoDeleted:(NSString *) videoId {
    NSError* error;
    NSHTTPURLResponse *response;
    NSString *urlString = [NSString stringWithFormat:@"https://img.youtube.com/vi/%@/default.jpg",videoId];
    NSURL *url = [NSURL URLWithString:urlString];
    //[self clearCookiesForURL:ytrequest.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL] ];
    [requestA setHTTPMethod:@"GET"];
    [requestA setHTTPShouldHandleCookies:NO];
    // [requestA setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [requestA setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    
    
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    if (response.statusCode!=200) {
        return  YES;
    }
    return  NO;
}
- (BOOL) checkLinkError:(NSString *) linkUrl{
    
    NSError* error;
    NSHTTPURLResponse *response;
    NSURL *url = [NSURL URLWithString:linkUrl];
    //[self clearCookiesForURL:ytrequest.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL] ];
    [requestA setHTTPMethod:@"GET"];
    [requestA setHTTPShouldHandleCookies:NO];
    // [requestA setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [requestA setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    
    [NSURLConnection sendSynchronousRequest:requestA returningResponse:&response error:&error];
    // NSData *data =  [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    if (error){
        return YES;
    }
    if (response.statusCode==200 ){
        return NO;
    }else if (response.statusCode>=300 && response.statusCode<=399) {
        linkUrl = [response.allHeaderFields objectForKey:@"Location"];
        if (linkUrl.length==0) {
            return YES;
        }
        return  [self checkLinkError:linkUrl];
    }
    return  YES;
}
- (NSString *) convertTimeToString:(double ) timeplay{
    NSString *result;
    int second=[[NSNumber numberWithDouble:timeplay] intValue]%60;
    NSString *secondstring=(second>9)?[NSString stringWithFormat:@"%d",second]:[NSString stringWithFormat:@"0%d",second];
    int minute=timeplay/60;
    NSString *minutestring=(minute>9)?[NSString stringWithFormat:@"%d",minute]:[NSString stringWithFormat:@"0%d",minute];
    result = [NSString stringWithFormat:@"%@:%@",minutestring,secondstring];
    return result;
}

- (NSData *)sendSynchronousRequestLog:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error
{
    if (enableSendLogFirebase) {
        NSString *msg=[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendLogFirebaseInfo" object: msg];
        
    }
    NSError __block *err = NULL;
    NSData __block *data;
    BOOL __block reqProcessed = false;
    NSURLResponse __block *resp;
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 30.0;
    //sessionConfig.HTTPShouldSetCookies = NO;
    // sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyNever;
    // NSLog(@"%@",sessionConfig.HTTPAdditionalHeaders);
    NSURLSession * session=[NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        resp = _response;
        err = _error;
        if (err) {
            NSLog(@"error api %@ %@",request.URL.absoluteString,err.description);
        }
        data = _data;
        reqProcessed = true;
    }] resume];
    
    while (!reqProcessed) {
        [NSThread sleepForTimeInterval:0.1];
    }
    if (enableSendLogFirebase) {
        NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendLogFirebaseInfo" object: stringReply];
    }
    *response = resp;
    *error = err;
    if (enableSendLogFirebase && err) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendLogFirebaseInfo" object: err.localizedDescription];
    }
    return data;
}
- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
- (NSString *) pretty: (long) d{
    double prettyD=d;
    int count=0;
    while (prettyD>=1000){
        prettyD/=1000;
        count++;
    }
    NSString * result;
    if (count==0){
        result=[NSString stringWithFormat:@"%.0f",prettyD];
    }else
        result=[NSString stringWithFormat:@"%.1f%@",prettyD,[self  getUnit:count]];
    return result;
}
- (NSString *) getUnit:(int) count{
    switch (count) {
        case 0:
            return @"";
            break;
        case 1: return @"K";
        case 2: return @"M";
        case 3: return @"G";
        case 4: return @"T";
        case 5: return @"P";
        case 6: return @"E";
        default: return @"Z";
    }
}
- (NSString *) idForDevice
{
    
    // NSUUID *myID1 = [BPXLUUIDHandler UUID];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * result = [defaults objectForKey: @"userID"];
    if (result.length==0)
    {
        NSUUID *myID = [[ASIdentifierManager alloc] advertisingIdentifier];
        if (!myID) {
            @try {
                myID = [[UIDevice currentDevice] identifierForVendor];
            }
            @catch (NSException *exception) {
                myID=nil;
            }
            
            
        }
        if (myID) {
            result = [myID UUIDString];
        }else{
            result =[self GetUUID];
        }
        if ([@"00000000-0000-0000-0000-000000000000" isEqualToString:result]) {
            // myID = [[UIDevice currentDevice] identifierForVendor];
            result =[[NSProcessInfo processInfo] globallyUniqueString];
        }
        [defaults setObject:result forKey:@"userID"];
    }
    
    return result;
}
- (NSString *) checkLinkMp4:(NSString *)videoId {
    NSString *urlMp4Local = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-mp4",videoId]];
    if (urlMp4Local.length>10) {
        timeDownload = CACurrentMediaTime();
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        //  NSURL *URL = [NSURL URLWithString:fileURL];
        NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:urlMp4Local]];
        //[self tapPing:mp4Link];
        isTestingPing = YES;
        double timeCall = CACurrentMediaTime();
        
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            // NSLog(@"Thoi gian nhan test download %.2f - %.4f",downloadProgress.fractionCompleted,CACurrentMediaTime()-timeCall);
            /*if (downloadProgress.fractionCompleted>0.1) {
             isTestingPing = NO;
             [self.downloadTask cancel];
             }*/
        }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return nil;
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                
            }
        }];
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            
            NSLog(@"Thoi gian nhan test download %lld - %.4f s",totalBytesWritten,(CACurrentMediaTime()-timeCall));
            
            timeDownload = CACurrentMediaTime();
            if (totalBytesWritten>5000){
                isTestingPing = NO;
                [self.downloadTask cancel];
            }
        }];
        [self.downloadTask resume];
        
        while (isTestingPing && CACurrentMediaTime()-timeCall<12) {
            [NSThread sleepForTimeInterval:0.05];
        }
        if (self.downloadTask.state == NSURLSessionTaskStateRunning)
            [self.downloadTask cancel];
        
        if (isTestingPing==NO) {
            NSLog(@"Link MP4  %@",urlMp4Local);
            return  urlMp4Local;
        }
    }
    return nil;
}
- (YoutubeMp4Respone* ) GetYoutubeMp4Link:(NSString *) videoId{
    NSError* error;
    NSHTTPURLResponse *response;
    double timeCall = CACurrentMediaTime();
    
    //test link luu san
   
    GetYtDirectLinksRequest *getSongRequest = [[GetYtDirectLinksRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.videoId=videoId;
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    getSongRequest.contents = [self GetYoutubeResponeLink:videoId];
    NSLog(@"Thoi gian lay content - %.4f",CACurrentMediaTime()-timeCall);
    timeCall = CACurrentMediaTime();
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data3.ikara.co:8080/ikaraweb/cgi-bin/V3_GetYtDirectLinks.py"]];
    if ([getYTDirectLink isKindOfClass:[NSString class]]){
        url = [NSURL URLWithString:getYTDirectLink];
    }
    if (!url){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://data3.ikara.co:8080/ikaraweb/cgi-bin/V3_GetYtDirectLinks.py"]];
    }
    // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetYtDirectLinks]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA addValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    [requestA addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    NSData *data;
    NSString *stringReply;
    YoutubeMp4Respone *getSongResponse ;
    [postString appendFormat:( @"%@=%@"), @"parameters",parameters];//[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Thoi gian tao request truoc khi gui - %.4f",CACurrentMediaTime()-timeCall);
    timeCall = CACurrentMediaTime();
    //[requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    stringReply= [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    stringReply=[stringReply stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    getSongResponse = [[YoutubeMp4Respone alloc] initWithString:stringReply error:&error];
    NSLog(@"Thoi gian nhan Request - %.4f",CACurrentMediaTime()-timeCall);
    timeDownload = CACurrentMediaTime();
    NSString *mp4Link = @"";
    if (getSongResponse.videos.count>0) {
        if ([getSongResponse isKindOfClass:[YoutubeMp4Respone class]]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality like %@", @"480"];
            NSArray *filteredArray = [getSongResponse.videos filteredArrayUsingPredicate:predicate];
            if (filteredArray.count>0) {
                YoutubeMp4* linkMp4=filteredArray[0];
                mp4Link=linkMp4.url;
            }else{
                predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"360"];
                filteredArray = [getSongResponse.videos filteredArrayUsingPredicate:predicate];
                if (filteredArray.count>0) {
                    YoutubeMp4* linkMp4=filteredArray[0];
                    mp4Link=linkMp4.url;
                }else{
                    predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"720"];
                    filteredArray = [getSongResponse.videos filteredArrayUsingPredicate:predicate];
                    if (filteredArray.count>0) {
                        YoutubeMp4* linkMp4=filteredArray[0];
                        mp4Link=linkMp4.url;
                    }
                }
            }
            if (@available(iOS 15.0, *)) {
                NSLog(@"Link MP4  %@",mp4Link);
                [[NSUserDefaults standardUserDefaults] setObject:mp4Link forKey:[NSString stringWithFormat:@"%@-mp4",videoId]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return  getSongResponse;
            }
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            //  NSURL *URL = [NSURL URLWithString:fileURL];
            NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:mp4Link]];
            //[self tapPing:mp4Link];
            isTestingPing = YES;
            timeCall = CACurrentMediaTime();
            
            self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                // NSLog(@"Thoi gian nhan test download %.2f - %.4f",downloadProgress.fractionCompleted,CACurrentMediaTime()-timeCall);
                /*if (downloadProgress.fractionCompleted>0.1) {
                 isTestingPing = NO;
                 [self.downloadTask cancel];
                 }*/
            }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                return nil;
                
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                if (error) {
                    
                }
            }];
            [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                
                NSLog(@"Thoi gian nhan test download %d - %.4f s",totalBytesWritten,(CACurrentMediaTime()-timeCall));
                
                timeDownload = CACurrentMediaTime();
                if (totalBytesWritten>50000){
                    isTestingPing = NO;
                    [self.downloadTask cancel];
                }
            }];
            [self.downloadTask resume];
            
            while (isTestingPing && CACurrentMediaTime()-timeCall<12) {
                [NSThread sleepForTimeInterval:0.05];
            }
            if (self.downloadTask.state == NSURLSessionTaskStateRunning)
                [self.downloadTask cancel];
            
            if (isTestingPing==NO) {
                NSLog(@"Link MP4  %@",mp4Link);
                [[NSUserDefaults standardUserDefaults] setObject:mp4Link forKey:[NSString stringWithFormat:@"%@-mp4",videoId]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return  getSongResponse;
            }
            NSLog(@"Link MP4 Fail %@",mp4Link);
        }
        
        
    }
    
    getSongRequest.contents = [self GetYoutubeResponeLink:videoId];
    parameters = [getSongRequest toJSONString];
    
    
    postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters",parameters];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //[requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    stringReply= [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    getSongResponse = [[YoutubeMp4Respone alloc] initWithString:stringReply error:&error];
    NSLog(@"GetYoutubeMp4Link Time Get Respone SV 2 - %.2f",CACurrentMediaTime()-timeCall);
    // Some debug code, etc.
    //NSLog(@"GetYoutubeMp4Link: %@", stringReply);
    if (getSongResponse.videos.count>0) {
        if ([getSongResponse isKindOfClass:[YoutubeMp4Respone class]]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality like %@", @"480"];
            NSArray *filteredArray = [getSongResponse.videos filteredArrayUsingPredicate:predicate];
            if (filteredArray.count>0) {
                YoutubeMp4* linkMp4=filteredArray[0];
                mp4Link=linkMp4.url;
            }else{
                predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"360"];
                filteredArray = [getSongResponse.videos filteredArrayUsingPredicate:predicate];
                if (filteredArray.count>0) {
                    YoutubeMp4* linkMp4=filteredArray[0];
                    mp4Link=linkMp4.url;
                }else{
                    predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"720"];
                    filteredArray = [getSongResponse.videos filteredArrayUsingPredicate:predicate];
                    if (filteredArray.count>0) {
                        YoutubeMp4* linkMp4=filteredArray[0];
                        mp4Link=linkMp4.url;
                    }
                }
            }
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            //  NSURL *URL = [NSURL URLWithString:fileURL];
            NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:mp4Link]];
            //[self tapPing:mp4Link];
            isTestingPing = YES;
            timeCall = CACurrentMediaTime();
            
            self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                // NSLog(@"Thoi gian nhan test download %.2f - %.4f",downloadProgress.fractionCompleted,CACurrentMediaTime()-timeCall);
                /*if (downloadProgress.fractionCompleted>0.1) {
                 isTestingPing = NO;
                 [self.downloadTask cancel];
                 }*/
            }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                return nil;
                
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                if (error) {
                    
                }
            }];
            [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                NSLog(@"Thoi gian nhan test download 2 - %d - %.4f",totalBytesWritten,CACurrentMediaTime()-timeCall);
                if (totalBytesWritten>40000){
                    isTestingPing = NO;
                    [self.downloadTask cancel];
                }
            }];
            [self.downloadTask resume];
            
            while (isTestingPing && CACurrentMediaTime()-timeCall<2) {
                [NSThread sleepForTimeInterval:0.05];
            }
            if (self.downloadTask.state == NSURLSessionTaskStateRunning)
                [self.downloadTask cancel];
            if (isTestingPing==NO) {
                [[NSUserDefaults standardUserDefaults] setObject:mp4Link forKey:[NSString stringWithFormat:@"%@-mp4",videoId]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return  getSongResponse;
            }
            NSLog(@"Link MP4 Fail  2 - %@",mp4Link);
        }
        
        
    }
    return nil;
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    
}
- (void) getYTMp4Link:(NSString *)videoId {
    @autoreleasepool {
        [self GetYoutubeMp4Link:videoId];
    }
   
}
- (BOOL )downloadSong:(Song *) songD{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@:10",songD.videoId]];
    [NSThread detachNewThreadSelector:@selector(getYTMp4Link:) toTarget:self withObject:songD.videoId];
    if (songD.songUrl.length<10) {
        GetYoutubeMp3LinkRespone *res= [[LoadData2 alloc] GetYoutubeMp3Link:songD];
        if ([res.url isKindOfClass:[NSString class]]) {
            songD.songUrl=res.url;
        }else {
        return  NO;
        }
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //  NSURL *URL = [NSURL URLWithString:fileURL];
    NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:songD.songUrl]];
    //[self tapPing:mp4Link];
    self.isDownloadSong = YES;
    
    self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
         NSLog(@"Download song %.2f %%",downloadProgress.fractionCompleted);
        if (downloadProgress.fractionCompleted*100>10)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@:%.f",songD.videoId,downloadProgress.fractionCompleted*100]];
    }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songD._id]];
        if ([songD.songUrl isKindOfClass:[NSString class]])
            if ([songD.songUrl hasSuffix:@"m4a"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songD._id]];
            }
        if (songD.videoId.length>2){
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songD.videoId]];
            
        }
        
        return [NSURL fileURLWithPath: filePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@:-1",songD.videoId]];
           
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@:100",songD.videoId]];
           
        }
        self.isDownloadSong = NO;
    }];
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        NSLog(@"Thoi gian nhan test download %d ",totalBytesWritten);
        
        
    }];
    [self.downloadTask resume];
    while (self.isDownloadSong ) {
        [NSThread sleepForTimeInterval:0.05];
    }
    return YES;
}
- (BOOL )downloadRecord:(Recording *) recordD{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@-10",recordD.recordingId]];
    [NSThread detachNewThreadSelector:@selector(getYTMp4Link:) toTarget:self withObject:recordD.song.videoId];
    if (recordD.onlineMp3Recording.length<10) {
        return  NO;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //  NSURL *URL = [NSURL URLWithString:fileURL];
    NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:recordD.onlineMp3Recording]];
    //[self tapPing:mp4Link];
    self.isDownloadSong = YES;
    
    self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Download song %.2f %%",downloadProgress.fractionCompleted);
        if (downloadProgress.fractionCompleted*100>10)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@:%.f",recordD.recordingId,downloadProgress.fractionCompleted*100]];
    }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",recordD.recordingId]];
       
        
        return [NSURL fileURLWithPath: filePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@:-1",recordD.recordingId]];
            
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDownloadProgress" object: [NSString stringWithFormat:@"%@:100",recordD.recordingId]];
            
        }
        self.isDownloadSong = NO;
    }];
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        NSLog(@"Thoi gian nhan test download %d ",totalBytesWritten);
        
        
    }];
    [self.downloadTask resume];
    while (self.isDownloadSong ) {
        [NSThread sleepForTimeInterval:0.05];
    }
    return YES;
}
- (NSString *) getLinkWeb{
    if (userOtherServer) {
        return linkWebReplace;
    }else return linkWebiKara;
}
+(BOOL) fileExistsInProject:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileInResourcesFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return [fileManager fileExistsAtPath:fileInResourcesFolder];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL resutl=[emailTest evaluateWithObject:checkString];
    if (resutl==NO){
        dispatch_async( dispatch_get_main_queue(),
                       ^{
            
            [[[[iToast makeText:@"Email does not exist" ]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            
        });
    }
    return resutl;
}
- (GetYoutubeMp3LinkRespone* ) GetYoutubeMp3Link:(Song *) song{
    NSError* error;
    NSHTTPURLResponse *response;
    NSLog(@"GetYoutubeMp3Link song: %@",song);
    GetYoutubeMp3LinkRequest *getSongRequest = [[GetYoutubeMp3LinkRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.songName=song.songName;
    getSongRequest.pitchShift = @0;
    getSongRequest.videoId = song.videoId;
    getSongRequest.language=Language;
    getSongRequest.contents = [self GetYoutubeResponeLink:song.videoId];
    NSString *parameters = [getSongRequest toJSONString];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetYoutubeMp3Link]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"mp3 Youtube reply: %@",stringReply);
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    GetYoutubeMp3LinkRespone *getSongResponse = [[GetYoutubeMp3LinkRespone alloc] initWithString:stringReply error:&error];
    if ([getSongResponse.url isKindOfClass:[NSString class]]) {
        return getSongResponse;
    }
    getSongRequest.contents = [self GetYoutubeResponeLink:song.videoId];
    parameters = [getSongRequest toJSONString];
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetYoutubeMp3Link]];
    request = [NSURLRequest requestWithURL:url];
    requestA = [[NSMutableURLRequest alloc]
                initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //[requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    stringReply= [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    NSLog(@"mp3 Youtube reply 2: %@",stringReply);
    getSongResponse = [[GetYoutubeMp3LinkRespone alloc] initWithString:stringReply error:&error];
    
    return getSongResponse;
}

// Get the INTERNAL ip address
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
        address = addresses[key];
        if(address) *stop = YES;
    } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
- (BOOL) check3G{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == ReachableViaWWAN) {
        
        return YES;
    } else {
        return NO;
        
        
    }
}
- (long) getMinScoreFromLevel:(int) level{
    switch (level) {
        case 1:
            return 0;
        case 2:
            return 100;
        case 3:
            return 200;
        case 4:
            return 300;
        case 5:
            return 400;
        case 6:
            return 600;
        case 7:
            return 800;
        case 8:
            return 1200;
        case 9:
            return 1800;
        case 10:
            return 2600;
        case 11:
            return 3900;
        case 12:
            return 5800;
        case 13:
            return 8700;
        case 14:
            return 13000;
        case 15:
            return 19500;
        case 16:
            return 29200;
        case 17:
            return 43800;
        case 18:
            return 65700;
        case 19:
            return 98600;
        case 20:
            return 147800;
        case 21:
            return 221700;
        case 22:
            return 332600;
        case 23:
            return 498800;
        case 24:
            return 748200;
        case 25:
            return 1122300;
        case 26:
            return 1683500;
        case 27:
            return 2525200;
        case 28:
            return 3787700;
        case 29:
            return 5681600;
        case 30:
            return 8522300;
        case 31:
            return 12783500;
        case 32:
            return 19175200;
        case 33:
            return 28762700;
        case 34:
            return 43144000;
        case 35:
            return 64716000;
        case 36:
            return 97074000;
        case 37:
            return 145611000;
        case 38:
            return 218416500;
        case 39:
            return 327624700;
        case 40:
            return 491437000;
        case 41:
            return 737155500;
        case 42:
            return 1105733300;
        default:
            return LONG_MAX;
    }
    
}
BOOL show;
- (BOOL) checkNetwork{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        if (!show) {
            show=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[[iToast makeText:AMLocalizedString(@"Vui lòng kiểm tra kết nối Internet của bạn", nil)]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            });
            //[self performSelectorOnMainThread:@selector(showArlert) withObject:nil waitUntilDone:YES];
        }
        show=NO;
        return NO;
    } else {
        show= NO;
        return YES;
        
        
    }
}
- (BOOL) checkUrlAvailable:(NSString *) url{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        if (!show) {
            show=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[[iToast makeText:AMLocalizedString(@"Vui lòng kiểm tra kết nối Internet của bạn", nil)]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            });
            //[self performSelectorOnMainThread:@selector(showArlert) withObject:nil waitUntilDone:YES];
        }
        show=NO;
        return NO;
    } else {
        show= NO;
        NSURL *url2 = [NSURL URLWithString:url];
        NSError *errr = nil;
        NSStringEncoding enc;
        NSString *serverValue = [[NSString alloc] initWithContentsOfURL:url2 usedEncoding:&enc error:&errr];
        if(serverValue)return YES;
        else return NO;
        return YES;
        
        
    }
}
- (GetPitchShiftedSongLinkResponse *) GetPitchShiftedSongLink:(NSNumber *)songId withPitchShift:(NSNumber *) pitchShift{
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetPitchShiftedSongLinkRequest *getSongRequest = [[GetPitchShiftedSongLinkRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.songId=songId;
    getSongRequest.language=Language;
    getSongRequest.facebookId=[prefs objectForKey:@"facebookId"];
    getSongRequest.password=[prefs objectForKey:@"password"];
    getSongRequest.pitchShift=pitchShift;
    // NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetPitchShiftedSongLink]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::///////////////////////////////////////////////////////////////////// %@",stringReply);
    GetPitchShiftedSongLinkResponse *getSongResponse = [[GetPitchShiftedSongLinkResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    NSLog(@"reply from server link Tone: %@", getSongResponse.link);
    return getSongResponse;
}
double intervalRender;
 BOOL streamPlay;
#pragma MARK STREAM
- (NSString *)getLinkStream:(NSString *)streamName andSV:(NSString *)sv{
    NSString *url=[NSString stringWithFormat:@"rtsp://%@/live/m4a:%@",sv, streamName];
    NSLog(@"urlstream %@",url);
    return url;
}
- (Response *) updateStream:(NSString *)streamName andPosition:(double)position andRecord:(Recording *)record andSV:(NSString *)sv{
    NSError* error;
    NSHTTPURLResponse *response;
    UpdateStreamRequest *streamRequest = [[UpdateStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    streamRequest.position=[NSNumber numberWithDouble:position*44100];
    NSString *parameters = [streamRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"UPDATE",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::/updateStream///////// %@",parameters);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (Response *) seekStream:(NSString *)streamName andPossition:(long long )post andSV:(NSString *)sv{
    NSError* error;
    NSHTTPURLResponse *response;
    SeekStreamRequest *streamRequest = [[SeekStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    if (post<0) {
        post=0;
    }
    streamRequest.position=[NSNumber numberWithLongLong:post];
    NSString *parameters = [streamRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"SEEK",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::///////////////// %@",postString);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    //[self updateTimeCodeStream:streamName andPossition:post andSV:streamServer];
    return getSongResponse;
}
- (Response *) updateTimeCodeStream:(NSString *)streamName andPossition:(long long)time andSV:(NSString *)sv{
    NSError* error;
    NSHTTPURLResponse *response;
    UpdateTimeCodeRequest *streamRequest = [[UpdateTimeCodeRequest alloc] init];
    streamRequest.streamName = streamName;
    if (time<0) {
        time=0;
    }
    streamRequest.clientTimeCode=[NSNumber numberWithLongLong:time];
    NSString *parameters = [streamRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"UPDATETIMECODE",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::///////////////////////////////////////////////////////////////////// %@",stringReply);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (Response *) playStream:(NSString *)streamName andRecord:(Recording *)record andSV:(NSString *)sv{
    NSError* error ;
    NSHTTPURLResponse *response;
    PlayStreamRequest *streamRequest = [[PlayStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    NSString *parameters = [streamRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"PLAY",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"playStream::////////////////// %@",postString);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    
    return getSongResponse;
}
- (Response *) pauseStream:(NSString *)streamName andRecord:(Recording *)record andSV:(NSString *)sv{
    NSError* error;
    NSHTTPURLResponse *response;
    PauseStreamRequest *streamRequest = [[PauseStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    NSString *parameters = [streamRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"PAUSE",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::///////////////// %@",postString);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (Response *) DoNoThingStream:(NSString *)streamName andSV:(NSString *)sv{
    NSError* error;
    NSHTTPURLResponse *response;
    DoNothingStreamRequest *streamRequest = [[DoNothingStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    NSString *parameters = [streamRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"DONOTHING",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::///////////////////////////////////////////////////////////////////// %@",stringReply);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (Response *) destroyStream:(NSString *)streamName andEffect:(Recording *)record andSV:(NSString *)sv{
    NSError* error;
    NSHTTPURLResponse *response;
    DestroyStreamRequest *streamRequest = [[DestroyStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    NSString *parameters = [streamRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"DESTROY",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::///////////////// %@",postString);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (NSString *) getParaUpdateStream:(NSString *)streamName andPosition:(double)position andRecord:(Recording *)record{
    NSError* error;
    NSHTTPURLResponse *response;
    UpdateStreamRequest *streamRequest = [[UpdateStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    if (position<0) {
        streamRequest.position=[NSNumber numberWithLong:-1];
    }else
        streamRequest.position=[NSNumber numberWithLong:position*44100];
    
    NSString *parameters = [streamRequest toJSONString];
    
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),@"UPDATE",streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}
- (NSString *) getParaUpdateStream2:(NSString *)streamName andPosition:(long)position andRecord:(Recording *)record{
    NSError* error;
    NSHTTPURLResponse *response;
    UpdateStreamRequest *streamRequest = [[UpdateStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    if (position<0) {
        streamRequest.position=[NSNumber numberWithLong:-1];
    }else
        streamRequest.position=[NSNumber numberWithLong:position];
    
    NSString *parameters = [streamRequest toJSONString];
    
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),@"UPDATE",streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}

- (NSString *) getParaDoNoThingStream:(NSString *)streamName {
    NSError* error;
    NSHTTPURLResponse *response;
    DoNothingStreamRequest *streamRequest = [[DoNothingStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),@"DONOTHING",streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}
- (NSString *) getParaDestroyStream:(NSString *)streamName andEffect:(Recording *)record{
    NSError* error;
    NSHTTPURLResponse *response;
    DestroyStreamRequest *streamRequest = [[DestroyStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),@"DESTROY",streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}
- (NSString *) getParaPauseStream:(NSString *)streamName andRecord:(Recording *)record{
    NSError* error;
    NSHTTPURLResponse *response;
    PauseStreamRequest *streamRequest = [[PauseStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    streamRequest.effects=record.effectsNew;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),@"PAUSE",streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}
- (NSString *) getParaCreateStream:(NSString *)streamName andParameter:(Recording *)record{
    NSError* error;
    NSHTTPURLResponse *response;
    CreateStreamRequest *streamRequest = [[CreateStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    if ([record.performanceType isEqualToString:@"DUET"]) {
        streamRequest.beatId=record.originalRecording;
        streamRequest.beatType=@"RECORDING";
    }else{
        streamRequest.beatId=record.song.videoId;
        streamRequest.beatType=@"YOUTUBE";
    }
    streamRequest.recordingType=record.recordingType;
    if (streamRequest.recordingType.length<=0) {
        streamRequest.recordingType=@"AUDIO";
    }
    if (record.onlineVoiceUrl.length<15) {
        streamRequest.vocalUrl=record.onlineVocalUrl;
    }else streamRequest.vocalUrl=record.onlineVoiceUrl;
    
    streamRequest.key=record.song.key;
    streamRequest.bpm=record.song.bpm;
    
    streamRequest.beatUrl=record.song.songUrl;
    if (streamRequest.vocalUrl.length==0) {
        NSLog(@"khong co vocal stream");
    }
    if (streamRequest.beatUrl.length<5) {
        GetYoutubeMp3LinkRespone*res= [self GetYoutubeMp3Link:record.song];
        if (![record.performanceType isEqualToString:@"DUET"]) {
            streamRequest.beatUrl=res.url;
            
        }
    }
    streamRequest.effects=record.effectsNew;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),@"CREATE",streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    
    return postString;
}
- (Response *) createStream:(NSString *)streamName andParameter:(Recording *)record andSV:(NSString *)sv{
    NSError* error;
    NSHTTPURLResponse *response;
    CreateStreamRequest *streamRequest = [[CreateStreamRequest alloc] init];
    streamRequest.streamName = streamName;
    if ([record.performanceType isEqualToString:@"DUET"]) {
        streamRequest.beatId=record.originalRecording;
        streamRequest.beatType=@"RECORDING";
    }else{
        streamRequest.beatId=record.song.videoId;
        streamRequest.beatType=@"YOUTUBE";
    }
    streamRequest.recordingType=record.recordingType;
    if (streamRequest.recordingType.length<=0) {
        streamRequest.recordingType=@"AUDIO";
    }
    if (record.onlineVoiceUrl.length<15) {
        streamRequest.vocalUrl=record.onlineVocalUrl;
    }else streamRequest.vocalUrl=record.onlineVoiceUrl;
    
    streamRequest.key=record.song.key;
    streamRequest.bpm=record.song.bpm;
    
    streamRequest.beatUrl=record.song.songUrl;
    if (streamRequest.vocalUrl.length==0) {
        NSLog(@"khong co vocal stream");
    }
    if (streamRequest.beatUrl.length<5) {
        GetYoutubeMp3LinkRespone*res= [self GetYoutubeMp3Link:record.song];
        if (![record.performanceType isEqualToString:@"DUET"]) {
            streamRequest.beatUrl=res.url;
            
        }
    }
    streamRequest.effects=record.effectsNew;
    NSString *parameters = [streamRequest toJSONString];
    // NSLog(@"parameters %@",parameters);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8086/IkaraV1HttpProvider", sv]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"action=%@&streamName=%@&%@=%@"),@"CREATE",streamName, @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"url %@   %@",url.absoluteString,postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"create stream reply::///////////////////////////////////////////////////////////////////// %@",postString);
    Response *getSongResponse = [[Response alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
TopUsersInLiveRoomResponse * topUsersInLiveRoomResponse;
- (TopUsersInLiveRoomResponse *) TopUsersInLiveRoom:(NSString *) cursor liveRoom:(long )roomId andType:(int) type{
    NSError* error;
    NSHTTPURLResponse *response;
    TopUsersInLiveRoomRequest *getSongRequest = [[TopUsersInLiveRoomRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.cursor=cursor;
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName = [[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.type = type;
    getSongRequest.liveRoomId = roomId;
    
    NSString *parameters = [getSongRequest toJSONString];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_TopUsersInLiveRoom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //stringReply = [stringReply stringByReplacingOccurrencesOfString:@"\"id\"" withString:@"\"_id\""];
    TopUsersInLiveRoomResponse *getSongResponse = [[TopUsersInLiveRoomResponse alloc] initWithString:stringReply error:&error];
    if (cursor==nil && getSongResponse.users.count>0) {
        [[NSUserDefaults standardUserDefaults ] setObject:stringReply forKey:@"TopUsersInLiveRoomResponse"];
        [[NSUserDefaults standardUserDefaults ] synchronize];
    }
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return getSongResponse;
}
- (GetMyProfileResponse* ) GetMyProfile {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetMyProfileRequest *getSongRequest = [[GetMyProfileRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetMyProfile]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::GetMyProfile ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetMyProfileResponse *getSongResponse = [[GetMyProfileResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    if ([getSongResponse.user.userId isKindOfClass:[NSString class]]) {
        currentFbUser=getSongResponse.user;
       
        
        currentFbUser.facebookId = [currentFbUser.facebookId stringByReplacingOccurrencesOfString:@"." withString:@""];
       
    }
    return getSongResponse;
}
- (GetFriendsStatusResponse *) GetFriendsStatus:(NSMutableArray *) friends {
    NSError* error;
    NSHTTPURLResponse *response;
    GetFriendsStatusRequest *getSongRequest = [[GetFriendsStatusRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.friends=friends;
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName = [[NSBundle mainBundle] bundleIdentifier];
    NSString *parameters = [getSongRequest toJSONString];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetFriendsStatus]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    GetFriendsStatusResponse *getSongResponse = [[GetFriendsStatusResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    
    return getSongResponse;
}
- (GetUserProfileResponse* ) GetUserProfile:(NSString *) userKey andOwnFacebookId:(NSString *) ownerFacebookId {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetUserProfileRequest *getSongRequest = [[GetUserProfileRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    
    getSongRequest.language=Language;
    getSongRequest.ownerFacebookId= ownerFacebookId;
    getSongRequest.ownerKey = userKey;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetUserProfile]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::GetUserProfile ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetUserProfileResponse *getSongResponse = [[GetUserProfileResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (SendGiftInLiveRoomResponse* ) SendGiftInLiveRoom:(SendGiftInLiveRoomRequest *)getSongRequest{
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_SendGiftInLiveRoom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::SendGiftInLiveRoomResponse /////////////////////////////// %@",stringReply);
    SendGiftInLiveRoomResponse *getSongResponse = [[SendGiftInLiveRoomResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (SendLuckyGiftResponse* ) SendLuckyGift:(SendLuckyGiftRequest *)getSongRequest{
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_SendLuckyGift]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::SendGiftInLiveRoomResponse /////////////////////////////// %@",stringReply);
    SendLuckyGiftResponse *getSongResponse = [[SendLuckyGiftResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
#pragma mark PK Live Api
- (void)getAllGift{
    @autoreleasepool{
        allGiftRespone=[self GetAllGifts];
        allLuckyGiftRespone = [ self GetAllLuckyGifts];
    }
}
- (GetAllGiftsResponse* ) GetAllGifts {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetAllGiftsRequest *getSongRequest = [[GetAllGiftsRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetGiftsForLiveRoom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetAllGiftsResponse *getSongResponse = [[GetAllGiftsResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    if (getSongResponse.gifts.count>0){
        Gift * luckyGift = [Gift new];
        luckyGift.name = @"Lì xì";
        luckyGift.type = @"LG";
        luckyGift.giftId = @"LG";
        [getSongResponse.gifts insertObject:luckyGift atIndex:0];
    }
    return getSongResponse;
}

- (GetAllGiftsResponse* ) GetGiftsForLiveRoom {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetAllGiftsRequest *getSongRequest = [[GetAllGiftsRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetGiftsForLiveRoom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetAllGiftsResponse *getSongResponse = [[GetAllGiftsResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (GetAllGiftsResponse* ) GetGiftsForRecording {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetAllGiftsRequest *getSongRequest = [[GetAllGiftsRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetGiftsForRecording]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetAllGiftsResponse *getSongResponse = [[GetAllGiftsResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (GetAllLuckyGiftsGaveResponse* ) GetAllLuckyGiftsGave:(NSString *)liveRoomID {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetAllLuckyGiftsGaveRequest *getSongRequest = [[GetAllLuckyGiftsGaveRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    getSongRequest.targetId = liveRoomID;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetAllLuckyGiftsGave]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetAllLuckyGiftsGaveResponse *getSongResponse = [[GetAllLuckyGiftsGaveResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (TakeLuckyGiftResponse* ) TakeLuckyGift:(long ) luckyGiftGaveId {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    TakeLuckyGiftRequest *getSongRequest = [[TakeLuckyGiftRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    getSongRequest.luckyGiftGaveId = luckyGiftGaveId;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_TakeLuckyGift]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    TakeLuckyGiftResponse *getSongResponse = [[TakeLuckyGiftResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (GetLuckyGiftsHistoryResponse* ) GetLuckyGiftsHistory:(long ) luckyGiftGaveId {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetLuckyGiftsHistoryRequest *getSongRequest = [[GetLuckyGiftsHistoryRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    getSongRequest.luckyGiftGaveId = luckyGiftGaveId;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetLuckyGiftsHistory]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetLuckyGiftsHistoryResponse *getSongResponse = [[GetLuckyGiftsHistoryResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (GetAllLuckyGiftsResponse* ) GetAllLuckyGifts {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetAllLuckyGiftsRequest *getSongRequest = [[GetAllLuckyGiftsRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetAllLuckyGifts]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"reply::GetAllGiftsRespone ///////////// %@ ////////////////// %@",parameters,stringReply);
    GetAllLuckyGiftsResponse *getSongResponse = [[GetAllLuckyGiftsResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (GetAllGiftsResponse* ) GetAllUserGifts:(NSString *)facebookId {
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    GetAllUserGiftsRequest *getSongRequest = [[GetAllUserGiftsRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.language=Language;
    getSongRequest.facebookId=facebookId;
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetAllUserGifts]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::GetAllUserGifts /////////// %@ //////////////////// %@",parameters,stringReply);
    GetAllGiftsResponse *getSongResponse = [[GetAllGiftsResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (RenewLiveRoomResponse *  ) RenewLiveRoom:(long) roomId{
    NSError* error;
    NSHTTPURLResponse *response;
    RenewLiveRoomRequest *getSongRequest = [[RenewLiveRoomRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.liveRoomId=roomId;
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName = [[NSBundle mainBundle] bundleIdentifier];
    NSString *parameters = [getSongRequest toJSONString];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_RenewLiveRoom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestA setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestA setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"%@=%@"), @"parameters", [[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //NSLog(@"%@",postString);
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    RenewLiveRoomResponse *getSongResponse = [[RenewLiveRoomResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    
    return getSongResponse;
}
- (SendGiftInLiveRoomResponse* ) SendGiftInPKRoom:(SendGiftInLiveRoomRequest *)getSongRequest{
    NSError* error;
    NSHTTPURLResponse *response;
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_SendGiftInPKRoom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::SendGiftInLiveRoomResponse /////////////////////////////// %@",stringReply);
    SendGiftInLiveRoomResponse *getSongResponse = [[SendGiftInLiveRoomResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
- (BOOL ) CreateLiveRoomContest:(LiveRoomContest *) liveroom {
    NSError* error;
    NSHTTPURLResponse *response;
    CreateLiveRoomContestRequest *getSongRequest = [[CreateLiveRoomContestRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.liveRoomContest=liveroom;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_CreateLiveRoomContest]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameterẽs);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryptionV19:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::CreateLiveRoomContest /////////////////////////////// %@",stringReply);
    //CheckPairingCodeResponse *getSongResponse = [[CheckPairingCodeResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return YES;
}

- (GetAllLiveRoomContestsResponse* ) GetAllLiveRoomContests:(NSString *) cursor {
    NSError* error;
    NSHTTPURLResponse *response;
    GetAllLiveRoomContestsRequest *getSongRequest = [[GetAllLiveRoomContestsRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.cursor=cursor;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetAllLiveRoomContests]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::GetAllLiveRoomContests /////////////////////////////// %@",stringReply);
    GetAllLiveRoomContestsResponse *getSongResponse = [[GetAllLiveRoomContestsResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}

- (GetAllContestsOfLiveRoomResponse* ) GetAllContestsOfLiveRoom:(long) roomId andCursor:(NSString *) cursor {
    NSError* error;
    NSHTTPURLResponse *response;
    GetAllContestsOfLiveRoomRequest *getSongRequest = [[GetAllContestsOfLiveRoomRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.cursor=cursor;
    getSongRequest.liveRoomId = roomId;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_GetAllContestsOfLiveRoom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::GetAllContestsOfLiveRoom /////////////////////////////// %@",stringReply);
    GetAllContestsOfLiveRoomResponse *getSongResponse = [[GetAllContestsOfLiveRoomResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}

- (JoinLiveRoomContestResponse* ) JoinLiveRoomContest:(long ) roomId {
    NSError* error;
    NSHTTPURLResponse *response;
    JoinLiveRoomContestRequest *getSongRequest = [[JoinLiveRoomContestRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.liveRoomContestId=roomId;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_JoinLiveRoomContest]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::JoinLiveRoomContest /////////////////////////////// %@",stringReply);
    JoinLiveRoomContestResponse *getSongResponse = [[JoinLiveRoomContestResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}

- (UnjoinLiveRoomContestResponse* ) UnjoinLiveRoomContest:(long ) roomId {
    NSError* error;
    NSHTTPURLResponse *response;
    UnjoinLiveRoomContestRequest *getSongRequest = [[UnjoinLiveRoomContestRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.liveRoomContestId=roomId;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_UnjoinLiveRoomContest]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::UnjoinLiveRoomContest /////////////////////////////// %@",stringReply);
    UnjoinLiveRoomContestResponse *getSongResponse = [[UnjoinLiveRoomContestResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}

- (DeleteLiveRoomContestResponse* ) DeleteLiveRoomContest:(long ) roomId {
    NSError* error;
    NSHTTPURLResponse *response;
    DeleteLiveRoomContestRequest *getSongRequest = [[DeleteLiveRoomContestRequest alloc] init];
    getSongRequest.userId = [self idForDevice];
    getSongRequest.platform=@"IOS";
    getSongRequest.language=Language;
    getSongRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    getSongRequest.liveRoomContestId=roomId;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_DeleteLiveRoomContest]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::DeleteLiveRoomContest /////////////////////////////// %@",stringReply);
    DeleteLiveRoomContestResponse *getSongResponse = [[DeleteLiveRoomContestResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}

- (EndLiveRoomContestResponse* ) EndLiveRoomContest:(long ) roomId firstId:(NSString *)firstId secondId:(NSString *)secondId thirdId:(NSString *) thirdId {
    NSError* error;
    NSHTTPURLResponse *response;
    EndLiveRoomContestRequest *getSongRequest = [[EndLiveRoomContestRequest alloc] init];
    getSongRequest.firstPrizeFacebookId = firstId;
    getSongRequest.secondPrizeFacebookId= secondId;
    getSongRequest.thirdPrizeFacebookId= thirdId;
    getSongRequest.liveRoomContestId=roomId;
    
    NSString *parameters = [getSongRequest toJSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self  getLinkWeb], L_EndLiveRoomContest]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *requestA = [[NSMutableURLRequest alloc]
                                     initWithURL:[request URL]];
    [requestA setHTTPMethod:@"POST"];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    //NSLog(@"%@",parameters);
    [postString appendFormat:( @"%@=%@"), @"parameters",[[iosDigitalSignature alloc] encryption:parameters]];
    postString=(NSMutableString*) [postString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [requestA setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithData:[self sendSynchronousRequestLog:requestA returningResponse:&response error:&error]];
    NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reply::EndLiveRoomContest /////////////////////////////// %@",stringReply);
    EndLiveRoomContestResponse *getSongResponse = [[EndLiveRoomContestResponse alloc] initWithString:stringReply error:&error];
    // Some debug code, etc.
    
    return getSongResponse;
}
#pragma mark Firebase Function
- (FirebaseFuntionResponse *) AddCommentFir:(RoomComment *)comment {
    AddCommentRequest *firRequest = [AddCommentRequest new];
    firRequest.message = comment.message;
    firRequest.roomId = comment.roomId;
    firRequest.commentId = comment.commentId;
    /*firRequest.userProfile = comment.userProfile;
     firRequest.userName = comment.userName;
     firRequest.userId = comment.userId;
     firRequest.userUid = comment.userUid;
     firRequest.userType = comment.userType;
     firRequest.commentId = comment.commentId;*/
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_AddComment] callWithObject:@{@"parameters":requestString}
                                                           completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
        
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
+ (CAShapeLayer *) creatHexagon:(CGRect ) viewFrame {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.frame = viewFrame;
    
    CGFloat width =viewFrame.size.width;
    CGFloat height = viewFrame.size.height;
    CGFloat hPadding = width * 1 / 8 / 2;
    
    UIGraphicsBeginImageContext(viewFrame.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
    [path closePath];
    [path closePath];
    [path fill];
    [path stroke];
    
    maskLayer.path = path.CGPath;
    UIGraphicsEndImageContext();
    // Add border
    
    
    return maskLayer;
}
+ (CAShapeLayer *) creatHexagon:(CGRect ) viewFrame withBoder:(int) boderWidth boderColor:(UIColor *)boderColor{
    CAShapeLayer* borderLayer = [CAShapeLayer layer];
    
    CGFloat width =viewFrame.size.width;
    CGFloat height = viewFrame.size.height;
    CGFloat hPadding = width * 1 / 8 / 2;
    
    UIGraphicsBeginImageContext(viewFrame.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
    [path closePath];
    [path closePath];
    [path fill];
    [path stroke];
    
    UIGraphicsEndImageContext();
    // Add border
    
    if (boderWidth>0 ){
        
        borderLayer.path = path.CGPath;; // Reuse the Bezier path
        borderLayer.fillColor = [[UIColor clearColor] CGColor];
        borderLayer.strokeColor = [boderColor CGColor];
        borderLayer.lineWidth = boderWidth;
        borderLayer.frame = viewFrame;
        
    }
    return borderLayer;
}
- (AddUserOnlineResponse *) AddUserOnLineFir:(LiveRoom *)room{
    AddUserOnLineRequest *firRequest = [AddUserOnLineRequest new];
    //firRequest.minutesOnline = 0;
    firRequest.userId = [self idForDevice];
    firRequest.platform=@"IOS";
    firRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
    firRequest.language=Language;
    NSString * version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    firRequest.version=version;
    firRequest.liveRoom = room;
    firRequest.user = currentFbUser;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block AddUserOnlineResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_AddUserOnline] callWithObject:@{@"parameters":requestString}
                                                              completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[AddUserOnlineResponse alloc] initWithString:stringReply error:&error];
        NSLog(@"Add user online %@ respone %@",[firRequest toJSONString],stringReply);
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (FirebaseFuntionResponse *) RemoveUserOnLineFir:(NSString *)roomId{
    RemoveUserOnLineRequest *firRequest = [RemoveUserOnLineRequest new];
    firRequest.roomId = roomId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_RemoveUserOnline] callWithObject:@{@"parameters":requestString}
                                                                 completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

//cam phat ngon
- (FirebaseFuntionResponse *) BlockCommentFir:(NSString *)roomId andUserBlock:(User *)userB {
    BlockCommentRequest *firRequest = [BlockCommentRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_BlockComment] callWithObject:@{@"parameters":requestString}
                                                             completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) UnblockCommentFir:(NSString *)roomId andUserBlock:(User *)userB {
    UnblockCommentRequest *firRequest = [UnblockCommentRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_UnblockComment] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) BlockUserFir:(NSString *)roomId andUserBlock:(User *)userB{
    BlockUserRequest *firRequest = [BlockUserRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_BlockUser] callWithObject:@{@"parameters":requestString}
                                                          completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) UnblockUserFir:(NSString *)roomId andUserBlock:(User *)userB{
    UnblockUserRequest *firRequest = [UnblockUserRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_UnblockUser] callWithObject:@{@"parameters":requestString}
                                                            completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) CancelAdminForUserFir:(NSString *)roomId andUser:(User *)userB{
    CancelAdminForUserRequest *firRequest = [CancelAdminForUserRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_CancelAdminForUser] callWithObject:@{@"parameters":requestString}
                                                                   completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (FirebaseFuntionResponse *) SetAdminForUserFir:(NSString *)roomId andUser:(User *)userB{
    SetAdminForUserRequest *firRequest = [SetAdminForUserRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_SetAdminForUser] callWithObject:@{@"parameters":requestString}
                                                                completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) CancelVipForUserFir:(NSString *)roomId andUser:(User *)userB{
    CancelVipForUserRequest *firRequest = [CancelVipForUserRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_CancelVipForUser] callWithObject:@{@"parameters":requestString}
                                                                 completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) SetVipForUserFir:(NSString *)roomId andUser:(User *)userB{
    SetVipForUserRequest *firRequest = [SetVipForUserRequest new];
    firRequest.userActionId = currentFbUser.facebookId;
    firRequest.roomId = roomId;
    firRequest.profileImageLink = userB.profileImageLink;
    firRequest.name = userB.name;
    firRequest.facebookId = userB.facebookId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_SetVipForUser] callWithObject:@{@"parameters":requestString}
                                                              completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (FirebaseFuntionResponse *) CreateLiveRoomFir:(LiveRoom *)room{
    CreateLiveRoomFirRequest *firRequest = [CreateLiveRoomFirRequest new];
    firRequest.liveroom = room;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_CreateLiveRoom] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) DeleteLiveRoomFir:(NSString *)roomId {
    DeleteLiveRoomFirRequest *firRequest = [DeleteLiveRoomFirRequest new];
    firRequest.roomId = roomId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_DeleteLiveRoom] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) UpdateLiveRoomPropertyFir:(LiveRoom *)room{
    UpdateLiveRoomPropertyFirRequest *firRequest = [UpdateLiveRoomPropertyFirRequest new];
    firRequest.liveRoom = room;
    NSString * requestString = [[room toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_UpdateLiveRoomProperty] callWithObject:@{@"parameters":requestString}
                                                                       completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (GetInfoUserOnlineResponse *) GetInfoUserFir:(NSString *)roomId andUserId:(NSString *)userId{
    GetInfoUserRequest *firRequest = [GetInfoUserRequest new];
    firRequest.roomId = roomId;
    firRequest.userId = userId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block GetInfoUserOnlineResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_GetInfoUser] callWithObject:@{@"parameters":requestString}
                                                            completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[GetInfoUserOnlineResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) AddSongFir:(NSString *)roomId withSong:(Song *)song {
    AddSongRequest *firRequest = [AddSongRequest new];
    firRequest.roomId = roomId;
    firRequest.song = song;
    
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_AddSong] callWithObject:@{@"parameters":requestString}
                                                        completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        NSLog(@"AddSongFir %@",stringReply);
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}

- (FirebaseFuntionResponse *) RemoveSongFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId {
    Song *newSong = [Song new];
    newSong.songName = song.songName;
    newSong.firebaseId = song.firebaseId;
    newSong._id = song._id;
    newSong.videoId = song.videoId;
    
    
    newSong.owner = song.owner;
    newSong.status = song.status;
    RemoveSongRequest *firRequest = [RemoveSongRequest new];
    firRequest.roomId = roomId;
    firRequest.song = newSong;
    if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
        NSLog(@"RemoveSongFir firebaseId nil");
    }else {
        NSLog(@"RemoveSongFir firebaseId %@",firRequest.song.firebaseId);
    }
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    
    [[_functions HTTPSCallableWithName:Fir_RemoveSong] callWithObject:@{@"parameters":requestString}
                                                           completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        NSLog(@"RemoveSongFir %@",stringReply);
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        if ([getResponse.message isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[[[iToast makeText:getResponse.message]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            });
        }
    }];
    
    return getResponse;
}

- (FirebaseFuntionResponse *) ClearAllSongOfUserInQueueFir:(NSString *)roomId  andUserId:(NSString *)userId {
    ClearAllSongOfUserInQueueRequest *firRequest = [ClearAllSongOfUserInQueueRequest new];
    firRequest.roomId = roomId;
    firRequest.userId = userId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_RemoveSong] callWithObject:@{@"parameters":requestString}
                                                           completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (FirebaseFuntionResponse *) DoneSongFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId {
    Song *newSong = [Song new];
    newSong.songName = song.songName;
    newSong.firebaseId = song.firebaseId;
    newSong._id = song._id;
    newSong.videoId = song.videoId;
    
    
    newSong.owner = song.owner;
    newSong.status = 5;
    
    DoneSongRequest *firRequest = [DoneSongRequest new];
    firRequest.roomId = roomId;
    firRequest.song = newSong;
    if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
        NSLog(@"DoneSongFir firebaseId nil");
    }
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_DoneSong] callWithObject:@{@"parameters":requestString}
                                                         completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        NSLog(@"done song %@",stringReply);
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (FirebaseFuntionResponse *) AddGiftFir:(AddGiftRequest *)firRequest {
    
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_RemoveSong] callWithObject:@{@"parameters":requestString}
                                                           completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (FirebaseFuntionResponse *) UpdateSongFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId {
    Song *newSong = [Song new];
    newSong.songName = song.songName;
    newSong.firebaseId = song.firebaseId;
    newSong._id = song._id;
    newSong.videoId = song.videoId;
    
    newSong.owner = [User new];
    newSong.owner.facebookId = currentFbUser.facebookId;
    newSong.owner.profileImageLink = currentFbUser.profileImageLink;
    newSong.owner.name = currentFbUser.name;
    newSong.owner.roomUserType = currentFbUser.roomUserType;
    newSong.owner.uid = currentFbUser.uid;
    newSong.status = 5;
    AddSongRequest *firRequest = [AddSongRequest new];
    firRequest.roomId = roomId;
    firRequest.song = newSong;
    
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[self.functions HTTPSCallableWithName:Fir_UpdateSong] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        NSLog(@"UpdateSongFir %@",stringReply);
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (SetTopSongInQueueResponse *) SetTopSongInQueueFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId {
    SetTopSongInQueueRequest *firRequest = [SetTopSongInQueueRequest new];
    firRequest.roomId = roomId;
    firRequest.song = song;
    firRequest.userActionId = userId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block SetTopSongInQueueResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_SetTopSongInQueue] callWithObject:@{@"parameters":requestString}
                                                                  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[SetTopSongInQueueResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        if ([getResponse.message isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[[[iToast makeText:getResponse.message]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            });
        }
    }];
    
    return getResponse;
}

- (FirebaseFuntionResponse *) RemoveStatusFir:(NSString *)roomId {
    RemoveStatusRequest *firRequest = [RemoveStatusRequest new];
    firRequest.roomId = roomId;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    __block BOOL isLoadFir = NO;
    __block FirebaseFuntionResponse *getResponse=nil;
    [[_functions HTTPSCallableWithName:Fir_RemoveStatus] callWithObject:@{@"parameters":requestString}
                                                             completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
        NSString *stringReply = (NSString *)result.data;
        
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        // Some debug code, etc.
        isLoadFir = YES;
        
    }];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!isLoadFir);
    return getResponse;
}
- (NSString *) getMCStreamRequest:(NSString *)streamID andFacebookID:(NSString *)facebookID  {
    NSError* error;
    NSHTTPURLResponse *response;
    McRequest *streamRequest = [[McRequest alloc] init];
    streamRequest.streamId = streamID;
    streamRequest.facebookId = facebookID;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"POST\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"MC\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),streamID,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}

- (NSString *) getSendDataStream:(NSString *)streamName andDevice:(NSString *)deviceId andAction:(NSString *)action  {
    NSError* error;
    NSHTTPURLResponse *response;
    SendDataRequest *streamRequest = [[SendDataRequest alloc] init];
    streamRequest.streamId = streamName;
    streamRequest.timestamp= [[NSDate date] timeIntervalSince1970];
    streamRequest.facebookId = deviceId;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"POST\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),action,streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}
- (NSString *) getSendDoNothingLiveStream:(NSString *)streamName andDevice:(NSString *)deviceId {
    NSError* error;
    NSHTTPURLResponse *response;
    DoNothingLiveStreamRequest *streamRequest = [[DoNothingLiveStreamRequest alloc] init];
    streamRequest.streamId = streamName;
    streamRequest.facebookId = deviceId;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"%@\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),@"DONOTHING",streamName,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", getSongResponse.songs.songName);
    return postString;
}

@end

