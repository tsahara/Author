//
//  AuthorHelper.h
//  Author
//
//  Created by Tomoyuki Sahara on 11/1/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

#ifndef Author_AuthorHelper_h
#define Author_AuthorHelper_h


@protocol AuthorHelperProtocol

@required

- (void)getVersionWithReply:(void(^)(NSString * version))reply;

@end


@interface AuthorHelper : NSObject

- (id)init;

- (void)run;

@end

#endif
