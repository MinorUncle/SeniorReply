//
//  Status.m
//  健康助手
//
//  Created by apple on 13-10-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "Status.h"
#import "User.h"

@implementation Status
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.picUrls = dict[@"pic_urls"];
        
        NSDictionary *retweet = dict[@"retweeted_status"];
        if (retweet) {
            self.retweetedStatus = [[Status alloc] initWithDict:retweet];
        }
        self.source = dict[@"source"];
        
        self.repostsCount = [dict[@"reposts_count"] intValue];
        self.commentsCount = [dict[@"comments_count"] intValue];
        self.attitudesCount = [dict[@"attitudes_count"] intValue];
    }
    return self;
}

//- (NSString *)source
//{
//    MyLog(@"source00000000");
//    
//    int begin = [_source rangeOfString:@">"].location + 1;
//    int end = [_source rangeOfString:@"</"].location;
//    
//    return [NSString stringWithFormat:@"来自%@", [_source substringWithRange:NSMakeRange(begin, end - begin)]];
//}

- (void)setSource:(NSString *)source
{
//    MyLog(@"setSource");
    // <a href="http://app.weibo.com/t/feed/2qiXeb" rel="nofollow">好保姆</a>
//    MyLog(@"%@", _source);
    if (![source containsString:@">"]) {
        return;
    }
    
    NSInteger begin = [source rangeOfString:@">"].location + 1;
    NSInteger end = [source rangeOfString:@"</"].location;
    
    _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:NSMakeRange(begin, end - begin)]];
}
@end
