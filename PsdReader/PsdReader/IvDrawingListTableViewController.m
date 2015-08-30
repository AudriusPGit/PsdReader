//
//  psdDrawingListTableController.m
//  psdViewer
//
//  Created by Brolis on 8/29/15.
//  Copyright (c) 2015 psd. All rights reserved.
//

#import "IvDrawingListTableViewController.h"
#import "IvCanvasViewController.h"
#import "IvPSDDocumentManager.h"
#import "IvPSDDocument.h"
#import "IvPSDLayer.h"

@implementation IvDrawingListTableViewController


-(id) init
{
    self = [super init];
    
    if(self)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        tableView.delegate = self;
        tableView.dataSource = self;
        self.view = tableView;
        
        //<navigation bar
        self.title = @"Drawing List";
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[IvPSDDocumentManager instance] getDocumentsSize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IvPSDLayer *layer = [[IvPSDDocumentManager instance] getDocumentAtIndex:indexPath.row].layer;
    
    IvCanvasViewController *canvasController = [[IvCanvasViewController alloc] initWithUIImage:layer.image];

    [self.navigationController pushViewController:canvasController animated:false];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"dont know";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = @"hireMe";
    
    return cell;
}

@end
