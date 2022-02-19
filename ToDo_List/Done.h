//
//  Done.h
//  ToDo_List
//
//  Created by Mohamed Kamal on 29/01/2022.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
NS_ASSUME_NONNULL_BEGIN

@interface Done : UITableViewController
{
    
    NSFileManager * fm;
    NSString * filePath;
    sqlite3 * db;
    char * errorMsg;
    sqlite3_stmt * allRecord;

}
@end

NS_ASSUME_NONNULL_END
