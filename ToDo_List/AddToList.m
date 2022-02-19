//
//  AddToList.m
//  ToDo_List
//
//  Created by Mohamed Kamal on 27/01/2022.
//

#import "AddToList.h"

@interface AddToList ()
{
    NSUserDefaults *defaults;//this will keep track as to whether the notification is on or off
    NSString * stttttUrl;
    
}
@end

@implementation AddToList

- (void)viewDidLoad {
    [super viewDidLoad];

    //Notification
    defaults = [NSUserDefaults standardUserDefaults];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    datepicker=[[UIDatePicker alloc] init];
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker.preferredDatePickerStyle=UIDatePickerStyleWheels;
    [self.dateSelection setInputView:datepicker];
    UIToolbar * toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setTintColor:[UIColor blueColor]];
    UIBarButtonItem * doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(showSelectedDate)];
    UIBarButtonItem * cancelButton =[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(cancel)];
    UIBarButtonItem * space =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton,space,doneButton, nil]];
    [self.dateSelection setInputAccessoryView:toolbar];
    

}
-(void) showSelectedDate
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.dateSelection.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datepicker.date]];
    [self.dateSelection resignFirstResponder];

}
-(void) cancel{
    [self.dateSelection resignFirstResponder];
}
- (IBAction)attachFile:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.image",@"public.rtf"] inMode:UIDocumentPickerModeImport];
        documentPicker.delegate = self;
        documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:documentPicker animated:YES completion:nil];
    
//    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"image" withExtension:@"jpg"] inMode:UIDocumentPickerModeExportToService];
//    documentPicker.delegate = self;
//    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:documentPicker animated:YES completion:nil];
    
}



- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [url lastPathComponent]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Import"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }

    NSLog(@"\n\n\n%@\n\n\n",[NSString stringWithFormat:@"%@",url]);
    NSData *fileData = [[NSData alloc] initWithContentsOfURL:url];
     string= [NSString stringWithUTF8String:[fileData bytes]];
    string =[string substringFromIndex:386];
    string =[string substringToIndex:string.length-1];
    _fileContent.text=string;
//    NSLog(@"\n\n\n%@\n\n\n",string);
}
- (IBAction)addToDo:(id)sender {
    
    _dataofdecription=[self.descriptionOfToDo.text UTF8String];
    _dataOfDate=[_dateSelection.text UTF8String];
    _dataOfAttachFile=[string UTF8String];
    _dataOfName=[_nameOfToDo.text UTF8String];
    if(self.descriptionOfToDo.text!=NULL&&_dateSelection.text!=NULL&&_dataOfPriority!=NULL&&_nameOfToDo.text!=NULL)
    {
        
        [defaults setBool:YES forKey:@"notificationIsActive"];
        [defaults synchronize];
        
        
        NSString *str1 = _dateSelection.text;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *dte1 = [dateFormat dateFromString:str1];
        
        
        
        NSString *str2 = [dateFormat stringFromDate:[NSDate date]];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *dte2 = [dateFormat1 dateFromString:str2];

        NSTimeInterval startTime =[dte1 timeIntervalSinceDate:dte2];

        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:startTime]; //Enter the time here in seconds.
        localNotification.alertBody = self.nameOfToDo.text;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        [_p adddata];
    }
    else
    {
        NSString *alertMessage =@"Please Add Data First";
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Add"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}
- (IBAction)highPriority:(id)sender {
    _dataOfPriority="high";
    NSString *alertMessage =@"Priority Is High";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Priority"
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}
- (IBAction)medPriority:(id)sender {
    _dataOfPriority="normal";
    NSString *alertMessage =@"Priority Is Normal";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Priority"
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}
- (IBAction)lowPriority:(id)sender {
    _dataOfPriority="low1";
    NSString *alertMessage =@"Priority Is Low";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Priority"
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}



@end
