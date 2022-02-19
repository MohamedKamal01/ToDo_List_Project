//
//  ShowData.h
//  ToDo_List
//
//  Created by Mohamed Kamal on 29/01/2022.
//

#import <UIKit/UIKit.h>
#import<MobileCoreServices/MobileCoreServices.h>
#import <sqlite3.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShowData : UIViewController <UIDocumentPickerDelegate>
{
    NSFileManager * fm;
    NSString * filePath;
    sqlite3 * db;
    char * errorMsg;
    sqlite3_stmt * allRecord;
    UIDatePicker * datepicker;
    NSString * string;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *contentOfFile;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UIImageView *priority;
@property (weak, nonatomic) IBOutlet UITextView *desc;

@property NSString * str_name;
@property NSString * str_desc;
@property NSString * str_contentOfFile;
@property NSString * str_date;
@property NSString * str_priority;
@end

NS_ASSUME_NONNULL_END
