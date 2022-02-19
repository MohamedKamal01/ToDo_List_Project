//
//  AddToList.h
//  ToDo_List
//
//  Created by Mohamed Kamal on 27/01/2022.
//

#import <UIKit/UIKit.h>
#import<MobileCoreServices/MobileCoreServices.h>
#import "MyP.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddToList : UIViewController <UIDocumentPickerDelegate>
{
    UIDatePicker * datepicker;
    NSString * string;
    
}
@property NSURL *fileUrl;

@property (weak, nonatomic) IBOutlet UITextField *dateSelection;
@property const char * dataOfAttachFile;
@property const char * dataOfPriority;
@property const char * dataofdecription;
@property const char * dataOfName;
@property const char * dataOfDate;
@property (weak, nonatomic) IBOutlet UITextView *fileContent;

@property (weak, nonatomic) IBOutlet UITextField *nameOfToDo;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOfToDo;
@property id <MyP> p;

@end

NS_ASSUME_NONNULL_END
