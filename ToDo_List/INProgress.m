//
//  INProgress.m
//  ToDo_List
//
//  Created by Mohamed Kamal on 29/01/2022.
//

#import "INProgress.h"

@interface INProgress ()
{
    NSString *strSQL;
    NSInteger num_row_low;
    NSInteger num_row_med;
    NSInteger num_row_high;
    
    BOOL low;
    BOOL med;
    BOOL high;
    NSMutableArray * namesLow;
    NSMutableArray * datesLow;
    NSMutableArray * imagesLow;
    
    NSMutableArray * namesMed;
    NSMutableArray * datesMed;
    NSMutableArray * imagesMed;
    
    NSMutableArray * namesHigh;
    NSMutableArray * datesHigh;
    NSMutableArray * imagesHigh;
}
@end

@implementation INProgress

-(void) viewDidAppear:(BOOL)animated
{
    high=NO;
    med=NO;
    low=NO;
    namesLow=[NSMutableArray new];
    datesLow=[NSMutableArray new];
    imagesLow=[NSMutableArray new];
    namesMed=[NSMutableArray new];
    datesMed=[NSMutableArray new];
    imagesMed=[NSMutableArray new];
    namesHigh=[NSMutableArray new];
    datesHigh=[NSMutableArray new];
    imagesHigh=[NSMutableArray new];
    filePath=@"/Users/mohamedkamal/Documents/sqliteDatabase/ToDo_List.sqlite";
    fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath]==YES)
    {
        num_row_low=0;
        num_row_high=0;
        num_row_med=0;
        
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
              
                        
                        if ([[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,3)] isEqual:@"high"])
                        {
                            high=YES;
                            [namesHigh addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,0)]];
                            [datesHigh addObject:str1];
                            [imagesHigh addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,3)]];
                            num_row_high++;
                        }
                        if ([[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,3)] isEqual:@"normal"]) {
                            med=YES;
                            [namesMed addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,0)]];
                            [datesMed addObject:str1];
                            [imagesMed addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,3)]];
                            num_row_med++;
                        }
                        if ([[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,3)] isEqual:@"low1"]) {
                            low=YES;
                            [namesLow addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,0)]];
                            [datesLow addObject:str1];
                            [imagesLow addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(allRecord,3)]];
                            num_row_low++;
                        }
                        


                    }

                    
                }
            }
        }
        
        
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back1"]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blueColor]];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sec=0;
    if(high==YES&&med==YES&&low==YES)
    {
        sec=3;
    }
    else if ((high==YES&&med==YES)||(high==YES&&low==YES)||(med==YES&&low==YES))
    {
        sec=2;
    }
    else if (high==YES||med==YES||low==YES)
    {
        sec=1;
    }
    else
    {
        sec=0;
    }
    
    return sec;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows=0;
    if(high==YES&&med==YES&&low==YES)
    {
        switch(section)
        {
            case 0:
                rows=[namesHigh count];
                break;
            case 1:
                rows=[namesMed count];
                break;
            case 2:
                rows=[namesLow count];
                break;
            default:
                rows=0;
                break;

                
        }
    }
    else if ((high==YES&&med==YES)||(high==YES&&low==YES)||(med==YES&&low==YES))
    {
        if((high==YES&&med==YES))
        {
            switch(section)
            {
                case 0:
                    rows=[namesHigh count];
                    break;
                case 1:
                    rows=[namesMed count];
                    break;
                default:
                    rows=0;
                    break;

                    
            }
        }
        else if (high==YES&&low==YES)
        {
            switch(section)
            {
                case 0:
                    rows=[namesHigh count];
                    break;
                case 1:
                    rows=[namesLow count];
                    break;
                default:
                    rows=0;
                    break;

                    
            }
        }
        else if (med==YES&&low==YES)
        {
            switch(section)
            {
                case 0:
                    rows=[namesMed count];
                    break;
                case 1:
                    rows=[namesLow count];
                    break;
                default:
                    rows=0;
                    break;

                    
            }
        }
    }
    else if (high==YES||med==YES||low==YES)
    {
        if(high==YES)
        {
            switch(section)
            {
                case 0:
                    rows=[namesHigh count];
                    break;
                default:
                    rows=0;
                    break;
            }
                    
        }
        else if(med==YES)
        {
            switch(section)
            {
                case 0:
                    rows=[namesMed count];
                    break;
                default:
                    rows=0;
                    break;
            }
                    
        }
        else if(low==YES)
        {
            switch(section)
            {
                case 0:
                    rows=[namesLow count];
                    break;
                default:
                    rows=0;
                    break;
            }
                    
        }
    }

    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInprogress" forIndexPath:indexPath];

    if(high==YES&&med==YES&&low==YES)
    {
        switch(indexPath.section)
        {
            case 0:
                cell.textLabel.text=[namesHigh objectAtIndex:indexPath.row];
                cell.detailTextLabel.text=[datesHigh objectAtIndex:indexPath.row];
                cell.imageView.image=[UIImage imageNamed:[imagesHigh objectAtIndex:indexPath.row]];
                break;
            case 1:
                cell.textLabel.text=[namesMed objectAtIndex:indexPath.row];
                cell.detailTextLabel.text=[datesMed objectAtIndex:indexPath.row];
                cell.imageView.image=[UIImage imageNamed:[imagesMed objectAtIndex:indexPath.row]];
                break;
            case 2:
                cell.textLabel.text=[namesLow objectAtIndex:indexPath.row];
                cell.detailTextLabel.text=[datesLow objectAtIndex:indexPath.row];
                cell.imageView.image=[UIImage imageNamed:[imagesLow objectAtIndex:indexPath.row]];
                break;
            default:
                break;
        }
    }
    else if ((high==YES&&med==YES)||(high==YES&&low==YES)||(med==YES&&low==YES))
    {
        if(high==YES&&med==YES)
        {
            switch(indexPath.section)
            {
                case 0:
                    cell.textLabel.text=[namesHigh objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesHigh objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesHigh objectAtIndex:indexPath.row]];
                    break;
                case 1:
                    cell.textLabel.text=[namesMed objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesMed objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesMed objectAtIndex:indexPath.row]];
                    break;
                default:
                    break;
            }
        }
        else if (high==YES&&low==YES)
        {
            switch(indexPath.section)
            {
                case 0:
                    cell.textLabel.text=[namesHigh objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesHigh objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesHigh objectAtIndex:indexPath.row]];
                    break;
                case 1:
                    cell.textLabel.text=[namesLow objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesLow objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesLow objectAtIndex:indexPath.row]];
                    break;
                default:
                    break;
            }
        }
        else if (med==YES&&low==YES)
        {
            switch(indexPath.section)
            {
                case 0:
                    cell.textLabel.text=[namesMed objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesMed objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesMed objectAtIndex:indexPath.row]];
                    break;
                case 1:
                    cell.textLabel.text=[namesLow objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesLow objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesLow objectAtIndex:indexPath.row]];
                    break;
                default:
                    break;
            }
        }
    }
    else if (high==YES||med==YES||low==YES)
    {
        if (high==YES)
        {
            switch(indexPath.section)
            {
                case 0:
                    cell.textLabel.text=[namesHigh objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesHigh objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesHigh objectAtIndex:indexPath.row]];
                    break;
                default:
                    break;
            }
        }
        else if(med==YES)
        {
            switch(indexPath.section)
            {
                case 0:
                    cell.textLabel.text=[namesMed objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesMed objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesMed objectAtIndex:indexPath.row]];
                    break;
                default:
                    break;
            }
        }
        else if (low==YES)
        {
            switch(indexPath.section)
            {
                case 0:
                    cell.textLabel.text=[namesLow objectAtIndex:indexPath.row];
                    cell.detailTextLabel.text=[datesLow objectAtIndex:indexPath.row];
                    cell.imageView.image=[UIImage imageNamed:[imagesLow objectAtIndex:indexPath.row]];
                    break;
                default:
                    break;
            }
        }
    }

    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * sec_name;
    if(high==YES&&med==YES&&low==YES)
    {
        if(section==0)
        {
            sec_name=@"High";
        }
        else if(section==1)
        {
            sec_name= @"Normal";
        }
        else
        {
            sec_name= @"Low";
        }
    }
    else if ((high==YES&&med==YES)||(high==YES&&low==YES)||(med==YES&&low==YES))
    {
        if(high==YES&&med==YES)
        {
            if(section==0)
            {
                sec_name=@"High";
            }
            else if(section==1)
            {
                sec_name= @"Normal";
            }
        }
        else if (high==YES&&low==YES)
        {
            if(section==0)
            {
                sec_name=@"High";
            }
            else if(section==1)
            {
                sec_name= @"Low";
            }
        }
        else if (med==YES&&low==YES)
        {
            if(section==0)
            {
                sec_name=@"Normal";
            }
            else if(section==1)
            {
                sec_name= @"Low";
            }
        }
    }
    else if (high==YES||med==YES||low==YES)
    {
        if (high==YES)
        {
            if(section==0)
            {
                sec_name=@"High";
            }
        }
        else if (med==YES)
        {
            if(section==0)
            {
                sec_name=@"Normal";
            }
        }
        else if (low==YES)
        {
            if(section==0)
            {
                sec_name=@"Low";
            }
        }
        
    }
    
    return sec_name;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
