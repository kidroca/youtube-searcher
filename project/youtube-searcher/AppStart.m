//
//  AppStart.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "AppStart.h"
#import "DataHandler.h"
#import "HttpRequester.h"

@implementation AppStart

+(void) configureApp{
    [AppStart dataConfig];
}

+(void) dataConfig{
    DataHandler *instance = [DataHandler sharedHandler];
    
    [instance setApiKey:[[[NSBundle mainBundle] infoDictionary]
                         valueForKeyPath:@"AppConfig.ApiCredentialsKey"]];
    
    [instance setBaseUrl:[[[NSBundle mainBundle] infoDictionary]
                          valueForKeyPath:@"AppConfig.YoutubeApiUrl"]];
    
    [instance setHttpRequester: [[HttpRequester alloc] init]];
}

@end
