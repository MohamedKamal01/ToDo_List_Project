//
//  ToDo.m
//  ToDo_List
//
//  Created by Mohamed Kamal on 27/01/2022.
//

#import "ToDo.h"
#import"ShowData.h"
@interface ToDo ()
{
    NSData* imgData;
    NSString *strSQL;
//    NSInteger num_row;
    NSMutableArray * names;
    NSMutableArray * dates;
    NSMutableArray * priorities;
    NSMutableArray * attachFile;
    NSMutableArray * describtions;
    NSMutableArray * search;
    NSMutableArray * m;
    BOOL isFiltered;
    BOOL flag;
    ShowData * view;
}
@end

@implementation ToDo
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        filePath=@"/Users/mohamedkamal/Documents/sqliteDatabase/ToDo_List.sqlite";
        fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:filePath]==YES)
        {
            printf("\nFile ToDo_List Found.");
            NSString * createTable=@"CREATE TABLE IF NOT EXISTS ToDo_List (Name TEXT,Description TEXT,AttachFile TEXT,Priority TEXT,Date TEXT)";
            if(sqlite3_open([filePath UTF8String],&db)==SQLITE_OK)
            {
                if(sqlite3_exec(db, [createTable UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
                {
                    printf("\nTable ToDo_List Created.");
                }
                else
                {
                    printf("\nTable ToDo_List NOT Created.");
                }
            }
       }
       else
       {
           printf("\nFile ToDo_List Not Found.");
           [fm createFileAtPath:filePath contents:NULL attributes:NULL];
       }
    }
    
    
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    names=[NSMutableArray new];
    dates=[NSMutableArray new];
    priorities=[NSMutableArray new];
    attachFile=[NSMutableArray new];
    describtions=[NSMutableArray new];
    m=[NSMutableArray new];
    isFiltered=NO;
    flag=NO;
    self.searchPar.delegate=self;
    //num_row=0;
    strSQL = @"SELECT * FROM ToDo_List";
    if (sqlite3_open([filePath UTF8String], &db) == SQLITE_OK)
    {
        if( sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &allRecord, NULL) == SQLITE_OK )
        {
            while (sqlite3_step(allRecord) == SQLITE_ROW)
            {
                NSString *str1 = [NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,4)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                NSDate *dte1 = [dateFormat dateFromString:str1];
                
                
                
                NSString *str2 = [dateFormat stringFromDate:[NSDate date]];
                NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                [dateFormat1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                NSDate *dte2 = [dateFormat1 dateFromString:str2];

                NSTimeInterval startTime =[dte1 timeIntervalSinceDate:dte2];
                if(startTime>0)
                {
                [names addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,0)]];
                [priorities addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,3)]];
                [describtions addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,1)]];
                [attachFile addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,2)]];
                [dates addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,4)]];
                }
               // num_row++;
                
            }
        }
        else{
            NSString *alertMessage =@"First Insert Data";
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Confirm"
                                                      message:alertMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }
    [self.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blueColor]];
    [self.tableView reloadData];

    self.tableView.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back1"]];
    

}
//search par deleget method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length==0)
    {
        isFiltered=NO;
    }
    else{
        isFiltered=YES;
        search=[[NSMutableArray alloc] init];
        for (NSString* name in names) {
            NSRange nameRange=[name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location!=NSNotFound)
            {
                [search addObject:name];
                
                
            }
        }
        if([names count]==0)
        {
            NSString *alertMessage =@"No Items To Search";
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Sarch"
                                                      message:alertMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        if([search count]==0)
        {
            NSString *alertMessage =@"This Name Not Found";
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Sarch"
                                                      message:alertMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }
    [self.tableView reloadData];
}
- (IBAction)addToList:(id)sender {
        addview =[self.storyboard instantiateViewControllerWithIdentifier:@"add"];
        [self.navigationController pushViewController:addview animated:YES];
        addview.p=self;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(isFiltered)
    {
        return search.count;
    }
    return [names count];//num_row;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(isFiltered)
    {
        //cell.imageView.image=NULL;
        cell.textLabel.text=search[indexPath.row];
    }
    else
    {
        //cell.imageView.image=[UIImage imageNamed:[priorities objectAtIndex:indexPath.row]];
        cell.textLabel.text=[names objectAtIndex:indexPath.row];

    }
    return cell;
}

-(void) adddata
{
    const char* sqliteQuery = "INSERT INTO ToDo_List (Name,Description,AttachFile,Priority,Date) VALUES (?, ?,?,?,?)";
        sqlite3_stmt* statement;
    
        if( sqlite3_prepare_v2(db, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {

            sqlite3_bind_text(statement, 1,addview.dataOfName, -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2,addview.dataofdecription, -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3,addview.dataOfAttachFile, -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4,addview.dataOfPriority, -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5,addview.dataOfDate, -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
        }
        else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );

    [addview setP:self];
    NSString *alertMessage =@"Successfully Insert Data";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Insert Done"
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    [names removeAllObjects];
    //num_row=0;
    strSQL = @"SELECT * FROM ToDo_List";
    if (sqlite3_open([filePath UTF8String], &db) == SQLITE_OK)
    {
        if( sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &allRecord, NULL) == SQLITE_OK )
        {
            while (sqlite3_step(allRecord) == SQLITE_ROW)
            {
                [names addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,0)]];
                //num_row++;
                
            }
        }
    }
    self.tableView.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back1"]];
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    view=[self.storyboard instantiateViewControllerWithIdentifier:@"show"];
    [self.navigationController pushViewController:view animated:YES];
    [view setStr_name:[names objectAtIndex:indexPath.row] ];
    [view setStr_contentOfFile:[attachFile objectAtIndex:indexPath.row] ];
    [view setStr_priority:[priorities objectAtIndex:indexPath.row] ];
    [view setStr_desc:[describtions objectAtIndex:indexPath.row] ];
    [view setStr_date:[dates objectAtIndex:indexPath.row] ];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

        switch (indexPath.section) {
            case 0:
                if(sqlite3_open([filePath UTF8String],&db)==SQLITE_OK)
                {

                    NSString *deleteTable = [[NSString alloc]initWithFormat:@"DELETE FROM ToDo_List WHERE Name='%@' AND Date='%@'",[NSString stringWithFormat:@"%@",[names objectAtIndex:indexPath.row]],[NSString stringWithFormat:@"%@",[dates objectAtIndex:indexPath.row]]];


                    if(sqlite3_exec(db, [deleteTable UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
                    {
                       
                        [names removeObjectAtIndex:indexPath.row];
                        [dates removeObjectAtIndex:indexPath.row];
                        if(names.count==0)
                        {
                            [self empty];
                        }
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
                        printf("\nDelete Failed.");
                    }
                }
                break;
            default:
                break;
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}
-(void) empty
{
    self.tableView.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"data"]];
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
