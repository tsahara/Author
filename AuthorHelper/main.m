//
//  main.m
//  AuthorHelper
//
//  Created by Tomoyuki Sahara on 10/25/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AuthorHelper.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Helper Start!");
        [[[AuthorHelper alloc] init] run];
    }
    return EXIT_FAILURE;
}
