//
//  WCProfileViewController.m
//  WeChat
//
//  Created by  夏发启 on 16/8/14.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditVCardViewController.h"

@interface WCProfileViewController ()<WCEditVCardViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weChatNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮箱
@property (nonatomic,strong)UIImagePickerController *imagePicker;

@end

@implementation WCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    XMPPvCardTemp *vCardTemp = [WCXMPPTool sharedWCXMPPTool].vCardModule.myvCardTemp;
    if (vCardTemp.photo) {
        self.avatarImage.image = [UIImage imageWithData:vCardTemp.photo];
        self.avatarImage.clipsToBounds = YES;
    }
    self.nickNameLabel.text = vCardTemp.nickname;
    self.weChatNumLabel.text = [WCAccount shareAccount].loginUserName;
    self.orgNameLabel.text = vCardTemp.orgName;
    if (vCardTemp.orgUnits.count) {
        self.departmentLabel.text = [vCardTemp.orgUnits firstObject];
    }
    self.jobLabel.text = vCardTemp.title;
    //self.telephoneLabel.text = vCardTemp.telecomsAddresses[0];
    //使用note充当电话
    self.telephoneLabel.text = vCardTemp.note;
    self.emailLabel.text = vCardTemp.mailer;
}

- (void)editVCardViewController:(WCEditVCardViewController *)editVC didFinishSave:(id)sender{
    //把数据保存到服务器
    XMPPvCardTemp *vCardTemp = [WCXMPPTool sharedWCXMPPTool].vCardModule.myvCardTemp;
    vCardTemp.photo = UIImageJPEGRepresentation(self.avatarImage.image, 1);
    vCardTemp.nickname = self.nickNameLabel.text;
    vCardTemp.orgName = self.orgNameLabel.text;
    if (self.departmentLabel.text.length) {
        vCardTemp.orgUnits = @[self.departmentLabel.text];
    }
    vCardTemp.title = self.jobLabel.text;
    /*
    if (self.telephoneLabel.text.length) {
        vCardTemp.telecomsAddresses = @[self.telephoneLabel.text];
    }
     */
    vCardTemp.note = self.telephoneLabel.text;
    vCardTemp.mailer = self.emailLabel.text;
    [[WCXMPPTool sharedWCXMPPTool].vCardModule updateMyvCardTemp:vCardTemp];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     根据cell的不同tag进行不同的操作
     tag = 0，换头像
     tag = 1，进入下一个控制器
     tag = 2，不作任何操作
     */
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    switch (selectCell.tag) {
        case 0:
            [self chooseImage];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toEditVCSegue" sender:selectCell];
            break;
        default:
            break;
    }
}

- (void)chooseImage{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    [alertController addAction:takePhotoAction];
    UIAlertAction *selectAlbumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    [alertController addAction:selectAlbumAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    self.avatarImage.image = editImage;
    [self editVCardViewController:nil didFinishSave:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVC =  [segue destinationViewController];
    if ([destVC isKindOfClass:[WCEditVCardViewController class]]) {
        WCEditVCardViewController *editVCardVC = destVC;
        editVCardVC.cell = sender;
        editVCardVC.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

@end
