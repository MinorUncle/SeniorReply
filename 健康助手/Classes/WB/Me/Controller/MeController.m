#import "MeController.h"
#import "AccountTool.h"
#import "FriendshipTool.h"

@implementation MeController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    long long ID = [[AccountTool sharedAccountTool].account.uid longLongValue];
    [FriendshipTool friendsWithId:ID success:^(NSArray *followers) {
        [_data addObjectsFromArray:followers];
        
        [self.tableView reloadData];
    } failure:nil];
}
@end