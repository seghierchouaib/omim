#import "AddSetVC.h"
#import "AddSetTableViewCell.h"
#import "SwiftBridge.h"
#import "UIViewController+Navigation.h"

#include "Framework.h"

@interface AddSetVC () <AddSetTableViewCellProtocol>

@property (nonatomic) AddSetTableViewCell * cell;

@end

@implementation AddSetVC

- (instancetype)init
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSaveClicked)];
  [(UIViewController *)self showBackButton];
  self.title = L(@"add_new_set");
  [self.tableView registerWithCellClass:[AddSetTableViewCell class]];
}

- (void)onSaveClicked
{
  auto text = self.cell.textField.text;
  auto data = [text dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  [self onDone:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
}

- (void)onDone:(NSString *)text
{
  if (text.length == 0)
    return;
  [self.delegate addSetVC:self didAddSetWithIndex:static_cast<int>(GetFramework().AddCategory([text UTF8String]))];
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.cell = static_cast<AddSetTableViewCell *>(
      [tableView dequeueReusableCellWithCellClass:[AddSetTableViewCell class] indexPath:indexPath]);
  self.cell.delegate = self;
  return self.cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(AddSetTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  [cell.textField becomeFirstResponder];
}

@end
