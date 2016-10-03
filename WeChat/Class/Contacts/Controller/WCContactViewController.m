//
//  WCContactViewController.m
//  WeChat
//
//  Created by huhang on 16/9/25.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "WCContactViewController.h"
#import "WCChatViewController.h"

@interface WCContactViewController ()<NSFetchedResultsControllerDelegate>

/** 请求结果控制器 */
@property (nonatomic,strong)NSFetchedResultsController *resultVC;

@end

@implementation WCContactViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    
    //获取上下文对象
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //请求查询哪张表
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    //过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subscription != %@",@"none"];
    fetchRequest.predicate = predicate;
    
    //执行请求
    NSFetchedResultsController *resultVC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    //设置代理
    resultVC.delegate = self;
    
    NSError *error = nil;
    [resultVC performFetch:&error];
    _resultVC = resultVC;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultVC.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    XMPPUserCoreDataStorageObject *user = _resultVC.fetchedObjects[indexPath.row];
    
    cell.textLabel.text = user.displayName;
    
    switch ([user.sectionNum integerValue]) {
        case 0:
             cell.detailTextLabel.text = @"在线";
            break;
        case 1:
             cell.detailTextLabel.text = @"离开";
            break;
        case 2:
             cell.detailTextLabel.text = @"离线";
            break;
            
        default:
             cell.detailTextLabel.text = @"未知";
            break;
    }
    
    //显示好友头像
    if (user.photo) {//默认情况,不是已启动就有头像的
        cell.imageView.image = user.photo;
    }else{//从服务器获取头像
     NSData *photoData = [[WCXMPPTool sharedWCXMPPTool].avatar photoDataForJID:user.jid];
     cell.imageView.image = [UIImage imageWithData:photoData];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    XMPPUserCoreDataStorageObject *user = _resultVC.fetchedObjects[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[WCXMPPTool sharedWCXMPPTool].roster removeUser:user.jid];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    XMPPUserCoreDataStorageObject *user = _resultVC.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"toChatVcSegue" sender:user.jid];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[WCChatViewController class]]) {
        WCChatViewController *chatVC = destVC;
        chatVC.friendJid = sender;
    }

}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{

    [self.tableView reloadData];
}


@end
