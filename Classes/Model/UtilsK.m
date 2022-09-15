//
//  UtilsK.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "UtilsK.h"
#import "Paint.h"
#import "Line.h"
#import "Lyrics.h"
#import "XmlLine.h"
#import "XmlWord.h"
#import "XMLReader.h"
#import "Word.h"
#import "GetLyricRequest.h"
#import "GetLyricResponse.h"
#import "TheLyrics.h"
#import "RenderOptions.h"
@protocol Word;
@protocol XmlWord;
@protocol XmlLine;
@implementation UtilsK
+(CGFloat) measureText:(Paint *) paint andText: (NSString *) text{
    return [paint measureText:text];
}
-(NSString *) convertStreamToString:(InputStream *) is{
    /*
    BufferedReader reader = new BufferedReader(new InputStreamReader(is,
                                                                     "UTF-8"));
    StringBuilder sb = new StringBuilder();
    NSString line = nil;
    
    try {
        while ((line = reader.readLine()) != nil) {
            sb.append(line + "\n");
        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        try {
            is.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    return sb.toString();
     */
    return @"";
}
-(NSString *)getText:(NSString *)url{
    //NSData* dataK = [NSData dataWithContentsOfURL: [NSURL URLWithString:url] ];
    NSURL *urlD= [NSURL URLWithString:url];
    NSError *error;
    
    
    NSString *content = [NSString  stringWithContentsOfURL:urlD encoding:NSUTF8StringEncoding error:&error];
    if (error) NSLog(@"%@",error);
    return content;
  
}
-(NSString *) getXmlFromUrl:(NSString *) url{
    /*
    InputStream in = nil;
    URLConnection conn = nil;
    
    try {
        conn = new URL(url).openConnection();
        in = conn.getInputStream();
        return UtilsK.convertStreamToString(in);
    } catch (Exception e){
        e.printStackTrace();
        return nil;
    }*/
    return nil;
}
-(void ) handleException:(NSException *) ex{
    /*
    final Writer result = new StringWriter();
    final PrintWriter printWriter = new PrintWriter(result);
    ex.printStackTrace(printWriter);
    String stacktrace = result.toString();
    printWriter.close();
    Log.w(TAG,stacktrace);
     */
}
-(void) displayMessage:(Context *) context andMess:( NSString *) message{
    if(message != nil)
    {
       // Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }
}
-(void) displayMessage:(Context *) context andMessId:( int) messageId{
    //Toast.makeText(context, context.getResources().getString(messageId), Toast.LENGTH_SHORT).show();
}
-(BOOL)   isOnline:(Context *)context{
   /* final ConnectivityManager conMgr =  (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    final NetworkInfo activeNetwork = conMgr.getActiveNetworkInfo();
    if (activeNetwork != nil && activeNetwork.isConnected()) {
        return true;
    }*/
    return false;
}
-(int) getRandomInRange:(int) min andMax:( int) max{
    return min + rand()%(max-min);//(int)(Math.random() * ((max - min) + 1));
}
-(BOOL) isExpired{
    return NO;
}
-(NSString *)  readTextFile:(NSString *) filep{
    NSString *txtFileContents = [NSString stringWithContentsOfFile:filep encoding:NSUTF8StringEncoding error:nil];
    return txtFileContents;
    /*
    StringBuilder text = new StringBuilder();
    BufferedReader br = nil;
    @try {
        br = new BufferedReader(new FileReader(file));
        String line;
        
        while ((line = br.readLine()) != nil) {
            text.append(line);
            text.append(System.getProperty("line.separator"));
        }
        return text.toString();
    }
    @catch (NSException e) {
        //You'll need to add proper error handling here
        return nil;
    } @finally{
        @try {
            if (br != nil)
                br.close();
        } @catch (NSException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }*/
}
-(NSString *) convertMilisecond2String:(int ) milliseconds{
    int seconds = (milliseconds / 1000) % 60;
    int minutes = ((milliseconds / (1000 * 60)) % 60);
    NSString * result;
    if (minutes <10) {
        if (seconds <10)
            result =[NSString stringWithFormat:@"0%d:0%d",minutes,seconds];
        else result =[NSString stringWithFormat:@"0%d:%d",minutes,seconds];
        
    }else{
        if (seconds <10)
            result =[NSString stringWithFormat:@"%d:0%d",minutes,seconds];
        else result =[NSString stringWithFormat:@"%d:%d",minutes,seconds];
    }
  
    return result;
}
-(CGFloat) convertTimeFromTextToNumber:(NSString *) timeInText{
    //@try{
    NSArray *tim=[timeInText componentsSeparatedByString:@":"];
    if ([tim objectAtIndex:1]!=nil){
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        //[f setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        f.decimalSeparator=@".";
        f.usesGroupingSeparator = NO;
        NSNumber * myNumber = [f numberFromString:[NSString stringWithFormat:@"%@",[tim objectAtIndex:0]]];
        return [myNumber floatValue];
    }else {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
       // [f setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        f.decimalSeparator=@".";
        f.usesGroupingSeparator = NO;
        NSNumber * myMinute = [f numberFromString:[NSString stringWithFormat:@"%@",[tim objectAtIndex:0]]];
         NSNumber * mySecond = [f numberFromString:[NSString stringWithFormat:@"%@",[tim objectAtIndex:1]]];
        return [myMinute floatValue]*60+ [mySecond floatValue];
    }
    return 0;
        
}


-(Lyrics *) convertXmlToObject:(NSString *) xmlLyrics{
    NSError *error;
    Lyrics * lyric=[[Lyrics alloc] initWithString:xmlLyrics error:&error];
    return lyric;
    
}
-(NSString *) convertObjectToString:(Lyrics *) lyricsInObject{
    
    if (lyricsInObject == nil || lyricsInObject.lines == nil) return @"";
  
    return nil;
}
-(NSString *) convertObjectToXml:(Lyrics *)lyrics{
    /*
    Serializer serializer = new Persister();
    try {
        Writer writer = new StringWriter();
        serializer.write(lyrics, writer);
        return writer.toString();
    } catch (Exception e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
        return nil;
    }*/
    return nil;
}
-(Lyrics *) convertStringToObject:(NSString *) lyrics{
    /*
    Lyrics lyricsInObject = new Lyrics();
    lyricsInObject.lines = new NSMutableArray<XmlLine>();
    String[] lines = lyrics.split("\n");
    for (int i = 0; i < lines.length; i++){
        XmlLine newXmlLine = new XmlLine();
        newXmlLine.words = new NSMutableArray<XmlWord>();
        String[] words = lines[i].split(" ");
        for (int j = 0; j < words.length; j++){
            String[] partsInAWord = words[j].split("\\\\");
            if (partsInAWord.length == 1){
                XmlWord newXmlWord = new XmlWord();
                if (j != words.length-1)
                    newXmlWord.text = words[j] + " ";
                else
                    newXmlWord.text = words[j];
                newXmlLine.words.add(newXmlWord);
            } else {
                for(int k= 0; k < partsInAWord.length; k++){
                    XmlWord newXmlWord = new XmlWord();
                    if (k != partsInAWord.length - 1){
                        newXmlWord.text = partsInAWord[k];
                    } else {
                        if (j != words.length - 1)
                            newXmlWord.text = partsInAWord[k] + " ";
                        else
                            newXmlWord.text = partsInAWord[k];
                    }
                    newXmlLine.words.add(newXmlWord);
                }
            }
        }
        lyricsInObject.lines.add(newXmlLine);
    }
    return lyricsInObject;*/
    return nil;
}
-(Lyrics *) transferData:(Lyrics *) oldData andNew:( Lyrics *) newData{
    if (oldData == nil ||oldData.lines == nil || oldData.lines.count==0) return newData;
    int currentLine = 0;
    int currentWord = -1;
    int lastMatchLine = 0;
    int lastMatchWord = -1;
    for(int i=0; i < newData.lines.count; i++){
        XmlLine *lin=[newData.lines objectAtIndex:i];
        for(int j=0; j < lin.words.count; j++){
            XmlWord *wor=[lin.words objectAtIndex:j];
            NSString *text = wor.text;// trim();
            currentLine = lastMatchLine;
            currentWord = lastMatchWord;
            XmlLine *lin2;
            XmlWord *wor2;
            do{
                lin2=[oldData.lines objectAtIndex:currentLine];
                if (currentWord < lin2.words.count - 1)
                    currentWord++;
                else{
                    if (currentLine < oldData.lines.count - 1){
                        currentLine++;
                        currentWord = 0;
                    } else {
                        currentLine = - 1;
                    }
                }
                lin2=[oldData.lines objectAtIndex:currentLine];
                wor2=[lin2.words objectAtIndex:currentWord];
            }
            while(currentLine != -1 && ![wor2.text isEqualToString:text]);//chua trim()
            if (currentLine != -1){
                lastMatchLine = currentLine;
                lastMatchWord = currentWord;
                XmlLine *lin=[newData.lines objectAtIndex:i];
                XmlLine *lin2=[oldData.lines objectAtIndex:currentLine];
                if (lin.sex == nil && lin2.sex!= nil){
                    lin.sex =lin2.sex;
                }
                XmlWord *wor=[lin.words objectAtIndex:j];
                 wor2=[lin2.words objectAtIndex:currentWord];
                if ([wor getStartTime1] == nil && [wor2 getStartTime1] != nil){
                    [wor setStartTime:[wor2 getStartTime1]];
                }
            }
        }
    }
    return newData;
}
-(CGSize) getSize{
    /*DisplayMetrics metrics = new DisplayMetrics();
    context.getWindowManager().getDefaultDisplay().getMetrics(metrics);
    return new Point(metrics.widthPixels,metrics.heightPixels);*/
   //CGFloat width = [UIScreen mainScreen].bounds.size;
        return [UIScreen mainScreen].bounds.size;
    
    
   
}
-(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}
-(Lyrics *) splitTooLongLine:(Lyrics *) lyrics andMaxLen: (int )maxLength{
    if (lyrics == nil || lyrics.lines == nil) return nil;
    Lyrics *newLyrics = [[Lyrics alloc] init];
    newLyrics.lines = [NSMutableArray new];
    for (XmlLine *line in lyrics.lines){
        int length = 0;
        for(XmlWord *word in line.words){
            length += word.text.length;
        }
        if (length > maxLength){
            long numberOfPart = lroundf(((float)length)/maxLength + 0.5);
            long lengthOfAPart = lroundf(((float)length)/numberOfPart);
            length = 0;
            XmlLine *newLine = [[XmlLine alloc] init];
            newLine.words = [NSMutableArray new];
            newLine.sex = line.sex;
            for(int j = 0; j < line.words.count;j++){
                XmlWord *word = [line.words objectAtIndex:j];
                XmlWord *word3=[XmlWord new];;
                if (j!= line.words.count - 1)  word3 = [line.words objectAtIndex:j];
                length += word.text.length;
                if (j == line.words.count - 1){
                    [newLine.words addObject:word];
                    [newLyrics.lines addObject:newLine];
                } else if (length >= lengthOfAPart && ([word.text hasSuffix:@" "] || [word3.text hasPrefix:@" "])){
                    [newLine.words addObject:word];
                    [newLyrics.lines addObject:newLine];
                    newLine = [[XmlLine alloc] init];
                    newLine.sex = line.sex;
                    newLine.words = [NSMutableArray new];
                    //newLine.words.add(word);
                    length = 0;
                } else {
                    [newLine.words addObject:word];
                }
            }
        } else {
            [newLyrics.lines addObject:line];
        }
        
    }
    return newLyrics;
}
-(NSMutableArray<Line> *) convertLyricsInObjectToRKL:(Lyrics *)lyricsInObject{
    // TODO Auto-generated method stub
   
    if (lyricsInObject == nil) return nil;
    if (lyricsInObject.lines == nil) return nil;
    NSMutableArray<Line> *simpleRKL = [ NSMutableArray new];
    
    NSMutableArray<XmlWord> *nextWords = nil;
    NSMutableArray<XmlWord> *words = nil;
    for (int j = 0; j < lyricsInObject.lines.count; j++) {
        
            if (nextWords != nil){
                words = nextWords;
            } else {
                XmlLine *tm=[lyricsInObject.lines objectAtIndex:j];
                words =  tm.words;
            }
            if (j < lyricsInObject.lines.count - 1){
                XmlLine *tm2=[lyricsInObject.lines objectAtIndex:j+1];
                nextWords = tm2.words;
            }
            if (words.count == 0) continue;
            Line *simpleRKLinLine = [Line new];
            XmlLine *tm=[lyricsInObject.lines objectAtIndex:j];
            NSString *sex = tm.sex;
            if (sex != nil){
                if ([sex isEqualToString:@"b"]){
                    RenderOptions *renderOptions = [ RenderOptions new];
                    renderOptions.sex =@"both";
                    simpleRKLinLine.renderOptions = renderOptions;
                }
                if ([sex isEqualToString:@"f"]){
                    RenderOptions* renderOptions =[ RenderOptions new];
                   
                    renderOptions.sex = @"female";
                    simpleRKLinLine.renderOptions = renderOptions;
                }
                if ([sex isEqualToString:@"m"]){
                    RenderOptions *renderOptions = [ RenderOptions new];
                    renderOptions.sex = @"male";
                    simpleRKLinLine.renderOptions = renderOptions;
                }
            } else {
                RenderOptions *renderOptions = [ RenderOptions new];
                renderOptions.sex =@"both";
                simpleRKLinLine.renderOptions = renderOptions;
            }
            
            CGFloat lastWordOfCurrentLine = 0;
            CGFloat firstWordOfNextLine = 0;
            XmlWord *tmw= [words objectAtIndex:0];
            XmlWord *tmw2= [words objectAtIndex:words.count - 1];
            simpleRKLinLine.start = [tmw getStartTime1];
            lastWordOfCurrentLine = [[tmw2 getStartTime1] floatValue];
            if (nextWords.count==0) continue;
            firstWordOfNextLine = ([[[nextWords objectAtIndex:0] getStartTime1] floatValue]);
            if (j < lyricsInObject.lines.count - 1){
                if (firstWordOfNextLine - lastWordOfCurrentLine < 2){
                    simpleRKLinLine.end =[NSNumber numberWithFloat: firstWordOfNextLine + 1];
                }
                else {simpleRKLinLine.end = [NSNumber numberWithFloat:lastWordOfCurrentLine + 2];}
            } else {
                simpleRKLinLine.end = [NSNumber numberWithFloat:lastWordOfCurrentLine + 2];
            }
            
            NSMutableArray<Word>* simpleRKLeachLine =  [NSMutableArray new];
            
            for (int i = 0; i < words.count; i++) {
                Word *simpleRKLinWord = [Word new];
                
                if (i == words.count - 1){
                    simpleRKLinWord.end = [NSNumber numberWithFloat:[simpleRKLinLine.end floatValue] - 1 - [simpleRKLinLine.start floatValue]];
                }
	    		
                simpleRKLinWord.start = [NSNumber numberWithFloat:[[[words objectAtIndex:i] getStartTime1 ] floatValue] - [simpleRKLinLine.start floatValue]];
                Word *tmwe= [words objectAtIndex:i];
                simpleRKLinWord.text = tmwe.text;
                simpleRKLinWord.renderOptions=simpleRKLinLine.renderOptions;
                [simpleRKLeachLine addObject:simpleRKLinWord];
            }
            simpleRKLinLine.line = simpleRKLeachLine;
            [simpleRKL addObject:simpleRKLinLine];
        
    }
    return simpleRKL;
    
}


@end
