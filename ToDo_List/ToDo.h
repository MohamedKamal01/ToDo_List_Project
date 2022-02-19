//
//  ToDo.h
//  ToDo_List
//
//  Created by Mohamed Kamal on 27/01/2022.
//

#import <UIKit/UIKit.h>
#import "AddToList.h"
#import <sqlite3.h>
#import "MyP.h"
NS_ASSUME_NONNULL_BEGIN

@interface ToDo : UITableViewController<MyP,UISearchBarDelegate>
{
    NSFileManager * fm;
    NSString * filePath;
    sqlite3 * db;
    char * errorMsg;
    sqlite3_stmt * allRecord;
    AddToList * addview;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchPar;
@end
NS_ASSUME_NONNULL_END
