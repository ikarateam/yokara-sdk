//
//  UploadToServerYokara.m
//  Yokara
//
//  Created by Rain Nguyen on 1/9/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "UploadToServerYokara.h"
#import <Constant.h>
#import "User.h"
@implementation UploadToServerYokara
BOOL _doneUploadingToIkara;


- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        pingSVSussecc=YES;
    } else {
        pingSVSussecc=NO;
    }
    testingPing=YES;
}
BOOL isUploadingFileToGCS;

-(NSString *)multipartUploadImage:(NSData*)dataToUpload filePath:(NSString *)filePath forKey:(NSString*)fileName {//data2=2,data3=3
    NSError* error;
    NSHTTPURLResponse *response;
    _doneUploadingToIkara=NO;
    percent=0;
    
    NSString* urlString=@"http://data.ikara.co:8080/ikaraweb/FileUploadForIos";
    
    NSString * mineType = @"image/jpeg";
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataToUpload name:@"userfile" fileName:fileName mimeType:mineType];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:dataToUpload] name:@"userfile" fileName:fileName mimeType:mineType error:nil];
        
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [request addValue:filePath forHTTPHeaderField:@"file-path"];
    [request addValue:mineType forHTTPHeaderField:@"file-mime-type"];
    request.timeoutInterval = 300;
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      percent=uploadProgress.fractionCompleted*100.0f;
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          // NSLog(@"Error: %@", error);
                      } else {
                          stringReply = (NSString *)[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                          
                      }
                      _doneUploadingToIkara=YES;
                  }];
    
    [uploadTask resume];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!_doneUploadingToIkara);
    return stringReply;
   
}
-(NSString *)multipartUpload:(NSString*)dataToUpload  forKey:(NSString*)key andServer:(int) noServer{//data2=2,data3=3
    NSError* error;
    NSHTTPURLResponse *response;
    _doneUploadingToIkara=NO;
    percent=0;

    NSString* urlString=@"http://data3.ikara.co/ikaraweb/FileUploadForIos";
    if (noServer==1 ) {
        urlString=@"http://data.ikara.co:8080/ikaraweb/FileUploadForIos";
        if ([key hasSuffix:@"mov"]){
            urlString=@"http://data.ikara.co:8080/ikaraweb/FileUploadForMov";
        }else
        if ([key hasSuffix:@"mp4"]){
            urlString=@"http://data.ikara.co:8080/ikaraweb/FileUploadForMp4";
        }
        else
            if ([key hasSuffix:@"mp3"]){
                urlString=@"http://data.ikara.co:8080/ikaraweb/FileUpload";
            }
    }else
    if (noServer==2){
            urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUploadForIos";
            if ([key hasSuffix:@"mov"]){
                urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUploadForMov";
            }
            else
                if ([key hasSuffix:@"mp4"]){
                    urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUploadForMp4";
                }
                else
                    if ([key hasSuffix:@"mp3"]){
                        urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUpload";
                    }
    }else {
       
            urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUploadForIos";
            if ([key hasSuffix:@"mov"]){
                urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUploadForMov";
            }else
                if ([key hasSuffix:@"mp4"]){
                    urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUploadForMp4";
                }
                else
                    if ([key hasSuffix:@"mp3"]){
                        urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUpload";
                    }
        
    }
    NSString * GUID = [[NSProcessInfo processInfo] globallyUniqueString];
    NSArray *split = [dataToUpload componentsSeparatedByString:@"/"];
    NSString *fileName = [NSString stringWithFormat:@"%@",key];
    NSString *filePath = [NSString stringWithFormat:@"recording/mr/%@", fileName];
    NSString * mineType = @"video/mp4";
    if ([currentFbUser.facebookId isKindOfClass:[NSString class]] ) {
        filePath = [NSString stringWithFormat:@"%@/recording/mr/%@",currentFbUser.facebookId,
                    
                    fileName];
    }
    if ([key hasSuffix:@"mov"]){
        mineType = @"video/mov";
    }else
        if ([key hasSuffix:@"mp4"]){
            mineType = @"video/mp4";
        }
        else
            if ([key hasSuffix:@"mp3"]){
                mineType = @"audio/mpeg";
            }else if ([key hasSuffix:@"jpg"]){
                mineType = @"image/jpeg";
                filePath = [NSString stringWithFormat:@"images/%@", fileName];
                if ([currentFbUser.facebookId isKindOfClass:[NSString class]] ) {
                    filePath = [NSString stringWithFormat:@"%@/images/%@",currentFbUser.facebookId,
                                
                                fileName];
                }
            }
    
    
    /*pingSVSussecc=NO;
    testingPing=NO;
    [self tapPing:urlString];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    while (!testingPing);
    // there will be various HTTP response code (status)
    // you might concern with 404
    if(!pingSVSussecc)
    {
      
        noServer++;
        if (noServer>3) {
            noServer=1;
        }
        NSLog(@"Host is unreachable");
        if (noServer==1 ) {
            urlString=@"http://data.ikara.co:8080/ikaraweb/FileUploadForIos";
            if ([key hasSuffix:@"mov"]){
                urlString=@"http://data.ikara.co:8080/ikaraweb/FileUploadForMov";
            }else
                if ([key hasSuffix:@"mp4"]){
                    urlString=@"http://data.ikara.co:8080/ikaraweb/FileUploadForMp4";
                }
                else
                    if ([key hasSuffix:@"mp3"]){
                        urlString=@"http://data.ikara.co:8080/ikaraweb/FileUpload";
                    }
        }else
            if (noServer==2){
                urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUploadForIos";
                if ([key hasSuffix:@"mov"]){
                    urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUploadForMov";
                }
                else
                    if ([key hasSuffix:@"mp4"]){
                        urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUploadForMp4";
                    }
                    else
                        if ([key hasSuffix:@"mp3"]){
                            urlString=@"http://data2.ikara.co:8080/ikaraweb/FileUpload";
                        }
            }else {
                
                urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUploadForIos";
                if ([key hasSuffix:@"mov"]){
                    urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUploadForMov";
                }else
                    if ([key hasSuffix:@"mp4"]){
                        urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUploadForMp4";
                    }
                    else
                        if ([key hasSuffix:@"mp3"]){
                            urlString=@"http://data3.ikara.co:8080/ikaraweb/FileUpload";
                        }
                
            }
    }*/
  NSLog(@"server %@",urlString);
  
   // NSData *fileContent = [NSData dataWithContentsOfFile:dataToUpload options:0 error:nil];
   
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFileData:fileContent name:@"userfile" fileName:fileName mimeType:@"application/octet-stream" ];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:dataToUpload] name:@"userfile" fileName:fileName mimeType:mineType error:nil];
        
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *seri = [AFHTTPResponseSerializer serializer];
    seri.acceptableContentTypes = [seri.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = seri;
    [request addValue:filePath forHTTPHeaderField:@"file-path"];
    [request addValue:mineType forHTTPHeaderField:@"file-mime-type"];
    request.timeoutInterval = 320;
    NSURLSessionUploadTask *uploadTask;
  
	__block double timeSVNotResponeLink = 0;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      percent=uploadProgress.fractionCompleted*100.0f;
		 if (percent>98 ) {
			  timeSVNotResponeLink = CACurrentMediaTime();
		 }
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                         // NSLog(@"Error: %@", error);
                      } else {
                         // NSLog(@"%@ %@", response, responseObject);
                           stringReply = (NSString *)[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                          
                      }
                      _doneUploadingToIkara=YES;
                  }];
   
    [uploadTask resume];
    /*
    NSURLRequest *urlRequest = [self postRequestWithURL:urlString
                                                   data:fileContent
                                               fileName:key];
    NSURLConnection* uploadConnection =[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [uploadConnection start];*/
    
   // NSData *data = [NSData dataWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error]];
    //NSString *stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   // NSLog(@"Upload reply: %@",stringReply);
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		 if (timeSVNotResponeLink>0) {
			  double timeOut= CACurrentMediaTime()- timeSVNotResponeLink;
			  if (timeOut>15000) {
				   break;
			  }
		 }
    }
    while (!_doneUploadingToIkara);
  //  [uploadConnection cancel];
   // uploadConnection = nil;
    return stringReply;
    /*
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    NSData *reqResults = [NSURLConnection sendSynchronousRequest:urlRequest
                                               returningResponse:&theResponse
                                                           error:&theError];
    if (theError) {
        NSLog(@"Connection error for URL: %@",[theError localizedDescription]);
        
    }*/
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _doneUploadingToIkara=YES;
    stringReply = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"url upload %@",stringReply);
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    _doneUploadingToIkara=YES;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
     NSLog(@"error upload %@",error.description);
    _doneUploadingToIkara=YES;
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    percent=((float)totalBytesWritten / (float)totalBytesExpectedToWrite) * 100.0f;
   // NSLog(@"connection %@ bytes sent %d/%d (%f%%)", connection, totalBytesWritten, totalBytesExpectedToWrite,percent );
}
-(NSURLRequest *)postRequestWithURL: (NSString *)url

                               data: (NSData *)data
                           fileName: (NSString*)fileName
{
    
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload
    
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:url]];
    //[urlRequest setURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //[urlRequest addValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:data]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
  //  [urlRequest setHTTPBodyStream:[NSInputStream inputStreamWithData:postData]];
    [urlRequest setHTTPBody:postData];
    return urlRequest;
}

@end
