//
//  iosDigitalSignature.m
//  rc4
//
//  Created by Rain Nguyen on 9/18/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "iosDigitalSignature.h"
#import "Base64.h"
@implementation iosDigitalSignature
 static long long password= 142363; //password này có thể thay đổi
 static long long password2 = 3564; //password này có thể thay đổi
static long long passwordv19= 7123358024; //password này có thể thay đổi
static long long password2v19 = 3564; //password này có thể thay đổi
-(NSString *) encryption:(NSString *) dataInString {
    @try {
        //caculate base64 of data
        NSString *encodedData = [dataInString base64EncodedString];
       // String encodedData = Base64.encodeBytes(dataInString.getBytes("UTF-8"));
        //add key to encoded
        encodedData = [NSString stringWithFormat:@"%@-%@",encodedData,[self getKey:encodedData]];
        return encodedData;
    } @catch (NSException *e) {
        // TODO Auto-generated catch block
        //e.printStackTrace();
        return nil;
    }
}
-(NSString *) encryptionV19:(NSString *) dataInString {
    @try {
        //caculate base64 of data
        NSString *encodedData = [dataInString base64EncodedString];
        // String encodedData = Base64.encodeBytes(dataInString.getBytes("UTF-8"));
        //add key to encoded
        
        
        encodedData = [NSString stringWithFormat:@"%@-%@",encodedData,[self getKeyV28:encodedData]];
        return encodedData;
    } @catch (NSException *e) {
        // TODO Auto-generated catch block
        //e.printStackTrace();
        return nil;
    }
}
-(NSString *) encryptionV28:(NSString *) dataInString {
    @try {
        //caculate base64 of data
        NSString *encodedData = [dataInString base64EncodedString];
        // String encodedData = Base64.encodeBytes(dataInString.getBytes("UTF-8"));
        //add key to encoded
        encodedData = [NSString stringWithFormat:@"%@-%@",encodedData,[self getKeyV28:encodedData]];
        return encodedData;
    } @catch (NSException *e) {
        // TODO Auto-generated catch block
        //e.printStackTrace();
        return nil;
    }
}
- (NSString *) decryption:(NSString*) dataInString {
    @try {
        NSRange searchResult = [dataInString rangeOfString:@"-"];
        NSInteger indexOfSub = searchResult.location;
        //get encoded data
        NSString *encodedData = [dataInString substringToIndex:indexOfSub];
        //get key
        NSString *key = [dataInString substringFromIndex:indexOfSub+1];
        //check key if it's correct
        if ([[self getKey:encodedData] isEqualToString:key]){
            return [encodedData base64DecodedString];
        } else {
            return nil;
        }
    } @catch (NSException * e) {
        // TODO Auto-generated catch block
       // e.printStackTrace();
        return nil;
    }
}
- (NSString *) decryptionV19:(NSString*) dataInString {
    @try {
        NSRange searchResult = [dataInString rangeOfString:@"-"];
        NSInteger indexOfSub = searchResult.location;
        //get encoded data
        NSString *encodedData = [dataInString substringToIndex:indexOfSub];
        //get key
        NSString *key = [dataInString substringFromIndex:indexOfSub+1];
        //check key if it's correct
        if ([[self getKeyV19:encodedData] isEqualToString:key]){
            return [encodedData base64DecodedString];
        } else {
            return nil;
        }
    } @catch (NSException * e) {
        // TODO Auto-generated catch block
        // e.printStackTrace();
        return nil;
    }
}
-(NSString *) getKey:(NSString *) data{
    @try{
        NSString *listOfNumbers = [NSString stringWithFormat:@"%ld",password2];
        //get all numbers in data
        unichar letter;
        for (int i = 0 ; i < [data length]; i++){
            //if current character is number
             letter = [data characterAtIndex:i];
            if (letter >= '0' && letter <= '9'){
                listOfNumbers = [NSString stringWithFormat:@"%c%@",letter,listOfNumbers];
            }
        }
        if ([listOfNumbers length] > 15) listOfNumbers = [listOfNumbers substringToIndex:15];
        int64_t value=[listOfNumbers longLongValue] + password;
        listOfNumbers = [NSString stringWithFormat:@"%lld",value];
        return listOfNumbers;
    } @catch (NSException * e){
        //e.printStackTrace();
        return @"0";
    }
}
-(NSString *) getKeyV19:(NSString *) data{
    @try{
        NSString *listOfNumbers = [NSString stringWithFormat:@"%ld",password2v19];
        //get all numbers in data
        unichar letter;
        for (long i = 0 ; i < [data length]; i++){
            //if current character is number
             letter = [data characterAtIndex:i];
            if (letter >= '0' && letter <= '9'){
                listOfNumbers = [NSString stringWithFormat:@"%c%@",letter,listOfNumbers];
            }
        }
        if ([listOfNumbers length] > 15) listOfNumbers = [listOfNumbers substringToIndex:15];
        int64_t value=[listOfNumbers longLongValue] + passwordv19;
        listOfNumbers = [NSString stringWithFormat:@"%lld",value];
        return listOfNumbers;
    } @catch (NSException * e){
        //e.printStackTrace();
        return @"0";
    }
}

-(NSMutableString *) getKeyV28:(NSString *) data{
    @try{
        NSMutableString *listOfNumbers =[NSMutableString  stringWithFormat:@"%ld",password2v19];
        //get all numbers in data
        unichar letter;
        for (long i = 0 ; i < [data length]; i++){
            //if current character is number
             letter = [data characterAtIndex:i];
            if (letter >= '0' && letter <= '9'){
                [listOfNumbers insertString:[NSString stringWithFormat:@"%c",letter] atIndex:0];
                //listOfNumbers = [NSString stringWithFormat:@"%c%@",letter,listOfNumbers];
            }
        }
        if ([listOfNumbers length] > 15) listOfNumbers =[NSMutableString stringWithString: [listOfNumbers substringToIndex:15]];
        int64_t value=[listOfNumbers longLongValue] + passwordv19;
        listOfNumbers = [NSMutableString stringWithFormat:@"%lld",value];
        return listOfNumbers;
    } @catch (NSException * e){
        //e.printStackTrace();
        return @"0";
    }
}
@end
