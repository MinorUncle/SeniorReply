#import "MessageController.h"
#import "AccountTool.h"
#import "FriendshipTool.h"
@implementation MessageController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    long long ID = [[AccountTool sharedAccountTool].account.uid longLongValue];
    [FriendshipTool followersWithId:ID success:^(NSArray *followers) {
        [_data addObjectsFromArray:followers];
        
        [self.tableView reloadData];
    } failure:nil];
}
@end