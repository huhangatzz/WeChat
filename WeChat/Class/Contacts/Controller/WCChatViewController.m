//
//  WCChatViewController.m
//  WeChat
//
//  Created by huhang on 2016/9/27.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "WCChatViewController.h"

@interface WCChatViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 执行请求 */{
NSFetchedResultsController *_resultController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 * 输入框容器距离底部的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 加载数据库聊天数据
    //1.上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].megArchivingStorage.mainThreadManagedObjectContext;
    
    //2.查询请求
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //过滤
    NSString *loginUser = [WCXMPPTool sharedWCXMPPTool].xmppStream.myJID.bare;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",loginUser,self.friendJid.bare];
    fetchRequest.predicate = predicate;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    //3.执行请求
    _resultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    NSError *error;
    [_resultController performFetch:&error];
    NSLog(@"%@",_resultController);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    XMPPMessageArchiving_Message_CoreDataObject *msgObj = _resultController.fetchedObjects[indexPath.row];
    //获取原始xml数据
    XMPPMessage *message = msgObj.message;
    //获取附件类型
    NSString *bodyType = [message attributeStringValueForName:@"bodyType"];
    if ([bodyType isEqualToString:@"image"]) {
        //2.遍历message子节点
        NSArray *childs = message.children;
        for (XMPPElement *note in childs) {
            if ([[note name] isEqualToString:@"attachment"]) {
                //获取附件字符串
                NSString *imgBase64Str = [note stringValue];
                NSData *imgData = [[NSData alloc]initWithBase64EncodedString:imgBase64Str options:0];
                UIImage *img = [UIImage imageWithData:imgData];
                cell.imageView.image = img;
            }
        }
    }else{
        cell.textLabel.text = msgObj.body;
    }
    
    return cell;
}

#pragma mark -键盘的通知
#pragma mark 键盘将显示
-(void)kbWillShow:(NSNotification *)noti{
    //显示的时候改变bottomContraint
    
    // 获取键盘高度
    NSLog(@"%@",noti.userInfo);
    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    self.bottomConstraint.constant = kbHeight;
}

#pragma mark 键盘将隐藏
-(void)kbWillHide:(NSNotification *)noti{
    self.bottomConstraint.constant = 0;
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_resultController.fetchedObjects.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSString *chat = textField.text;
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [message addBody:chat];
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:message];
    
    //清空数据
    textField.text = nil;
    
    return YES;
}

#pragma mark 点击发送图片
- (IBAction)clickAddImageAction:(id)sender {
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.delegate = self;
    
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark 用户选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    //发送附件
    [self sendAttachmentWithData:UIImagePNGRepresentation(img) bodyType:@"image"];
    
    //隐藏图片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 发送图片附件
- (void)sendAttachmentWithData:(NSData *)data bodyType:(NSString *)bodyType{
    
    //发送图片
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    //设置类型
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    
    //设置body
    [msg addBody:bodyType];
    
    //把附件经过base 64编码转成字符串
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    //定义附件
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64Str];
    
    //添加子节点
    [msg addChild:attachment];
    
    //上传服务器
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:msg];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
