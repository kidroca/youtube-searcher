//
//  youtube_searcherTests.m
//  youtube-searcherTests
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HttpRequester.h"

@interface youtube_searcherTests : XCTestCase

@end

@implementation youtube_searcherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTextHttpRequesterGet {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *key = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"AppConfig.ApiCredentialsKey"];
    NSString *urlString = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"AppConfig.YoutubeApiUrl"];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlString];
    
    NSArray *query = @[[NSURLQueryItem queryItemWithName:@"key" value:key],
                       [NSURLQueryItem queryItemWithName:@"part" value:@"snippet"],
                       [NSURLQueryItem queryItemWithName:@"q" value:@"computers"]];
    
    HttpRequester *reqo = [[HttpRequester alloc] init];
    [reqo httpGetFrom:urlString withQuery:query andCompletionHandler:^(NSDictionary * _Nullable dict) {
        NSLog(@"Request data: %@", dict);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
