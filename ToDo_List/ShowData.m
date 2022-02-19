//
//  ShowData.m
//  ToDo_List
//
//  Created by Mohamed Kamal on 29/01/2022.
//

#import "ShowData.h"

@interface ShowData ()
{
    NSUserDefaults *defaults;
    NSString * pro;
}
@end

@implementation ShowData

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _name.text=_str_name;
    _desc.text=_str_desc;
    _contentOfFile.text=_str_contentOfFile;
    _priority.image=[UIImage imageNamed:_str_priority];
    _date.text=_str_date;
    
    defaults = [NSUserDefaults standardUserDefaults];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    datepicker=[[UIDatePicker alloc] init];
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker.preferredDatePickerStyle=UIDatePickerStyleWheels;
    [self.date setInputView:datepicker];
    UIToolbar * toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,100,340,44)];
    [toolbar setTintColor:[UIColor blueColor]];
    UIBarButtonItem * doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(showSelectedDate)];
    UIBarButtonItem * cancelButton =[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(cancel)];
    UIBarButtonItem * space =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton,space,doneButton, nil]];
    [self.date setInputAccessoryView:toolbar];
}
-(void) showSelectedDate
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.date.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datepicker.date]];
    [self.date resignFirstResponder];

}
-(void) cancel{
    [self.date resignFirstResponder];
}
- (IBAction)remove:(id)sender
{
    filePath=@"/Users/mohamedkamal/Documents/sqliteDatabase/ToDo_List.sqlite";
    fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath]==YES)
    {
        if(sqlite3_open([filePath UTF8String],&db)==SQLITE_OK)
        {

            NSString *deleteTable = [[NSString alloc]initWithFormat:@"DELETE FROM ToDo_List WHERE Name='%@' AND Date='%@'",[NSString stringWithFormat:@"%@",_name.text],[NSString stringWithFormat:@"%@",_date.text]];


            if(sqlite3_exec(db, [deleteTable UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
            {
                NSString *alertMessage =@"Remove Done";
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Alert"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                });

            }
            else
            {
                NSString *alertMessage =@"Item Not Found";
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Alert"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            
            
        }
    }
}

}
- (IBAction)edit:(id)sender {
    //Name TEXT,Description TEXT,AttachFile TEXT,Priority TEXT,Date TEXT
    filePath=@"/Users/mohamedkamal/Documents/sqliteDatabase/ToDo_List.sqlite";
    fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath]==YES)
    {
    if(sqlite3_open([filePath UTF8String],&db)==SQLITE_OK)
    {
        
                    
                        NSString *alertMessage =@"Are You Sure";
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController
                                                                  alertControllerWithTitle:@"Confirm"
                                                                  message:alertMessage
                                                                  preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                        {
                                NSString *updateTable = [[NSString alloc]initWithFormat:@"Update ToDo_List SET Name='%@',Description='%@',AttachFile='%@',Priority='%@',Date='%@' WHERE Name='%@' AND Date='%@'",self->_name.text,self->_desc.text,self->_contentOfFile.text,self->pro,self->_date.text,self->_str_name,self->_str_date];
                                if(sqlite3_exec(self->db, [updateTable UTF8String], NULL, NULL, &self->errorMsg)==SQLITE_OK)
                                {
                                    NSString *alertMessage =@"Update Done";
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController *alertController = [UIAlertController
                                                                              alertControllerWithTitle:@"Alert"
                                                                              message:alertMessage
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                                        [self presentViewController:alertController animated:YES completion:nil];
                                    });
                                        
                                }
                            }]];
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
        if(_str_desc!=NULL&&_str_date!=NULL&&_str_priority!=NULL&&_str_name!=NULL)
        {
            
            [defaults setBool:YES forKey:@"notificationIsActive"];
            [defaults synchronize];
            
            
            NSString *str1 = _date.text;
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
            localNotification.alertBody = self.name.text;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
                   
                    
                
           
        }

    }
    }

}
- (IBAction)hig:(id)sender {
    NSString * h=@"high";
    self.priority.image=[UIImage imageNamed:h];
}

- (IBAction)nom:(id)sender {
    NSString * h=@"normal";
    self.priority.image=[UIImage imageNamed:h];
}
- (IBAction)lo:(id)sender {
    NSString * h=@"low1";
    self.priority.image=[UIImage imageNamed:h];
}

@end
