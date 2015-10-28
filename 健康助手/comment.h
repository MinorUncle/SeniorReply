
#ifndef COMMENT_H
#define COMMENT_H
// 1.判断是否为iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

// 2.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)
#endif
#define kAccountFile @"account.data"

#define kDockHeight 44
// 3.设置cell的边框宽度
#define kCellBorderWidth 10
// 设置tableView的边框宽度
#define kTableBorderWidth 8
// 设置每个cell之间的间距
#define kCellMargin 8
// 设置数据dock的高度
#define kStatusDockHeight 35

#define kRetweetedDockHeight 35

#define kStatusHight 64

// 4.cell内部子控件的字体设置
#define kScreenNameFont [UIFont systemFontOfSize:17]
#define kTimeFont [UIFont systemFontOfSize:13]
#define kSourceFont kTimeFont
#define kTextFont [UIFont systemFontOfSize:15]
#define kRetweetedTextFont [UIFont systemFontOfSize:16]
#define kRetweetedScreenNameFont [UIFont systemFontOfSize:16]

// 5.获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

// 全局的背景色
#define kGlobalBg kColor(230, 230, 230)

// 6.cell内部子控件的颜色设置
// 会员昵称颜色
#define kMBScreenNameColor kColor(243, 101, 18)
// 非会员昵称颜色
#define kScreenNameColor kColor(93, 93, 93);
// 被转发数据昵称颜色
#define kRetweetedScreenNameColor kColor(63, 104, 161)

// 7.图片
// 会员皇冠图标
#define kMBIconW 14
#define kMBIconH 14

// 头像
#define kIconSmallW 34
#define kIconSmallH 34

#define kIconDefaultW 50
#define kIconDefaultH 50

#define kIconBigW 85
#define kIconBigH 85

// 认证加V图标
#define kVertifyW 18
#define kVertifyH 18
//浏览模式
//网络通知名称
#define kConnectChangeNotification @"kConnectChangeNotification"

//数据库文件
#define SqliteData [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"my.db"]

//饮食归档文件
#define kFoodCollectFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"CollectFood.data"]
#define kFoodClassFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"FoodClass.plist"]

//检查归档文件
#define kCheckCollectFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"CollectCheck.data"]
#define kCheckClassFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"CheckClass.data"]

//药物归档文件
#define kMedicineCollectFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"CollectMedicine.data"]
#define kMedicineClassFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"MedicineClass.data"]

//查找疾病归档文件
#define kDiseaseCollectFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"CollectDisease.data"]
#define kDiseaseClassFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"DiseaseClass.data"]

//查找商店归档文件
#define kStoreCollectFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"CollectStore.data"]
#define kStoreClassFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"StoreClass.data"]


#endif
