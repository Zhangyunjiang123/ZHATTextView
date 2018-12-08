//
//  PostMessageViewController.m
//  WolfClient
//
//  Created by 张云江 on 2018/12/3.
//  Copyright © 2018年 shsx. All rights reserved.
//

#import "PostMessageViewController.h"
#import "TPFriendsChooseViewController.h"

static const int NAVIGATION_HEIGHT = 64;
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PostMessageViewController () <UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TPFriendsChooseViewControllerProtocol>
{
    NSUInteger      lowerLimit;
    
    NSMutableArray  *_photoArray;
    int             _photoupdateCurrId;
    BOOL            _isAddDefault;
    UIView          *header;
    UILabel         *positioningLabel;
    UIButton        *visibleAllBtnIcon;
    UIButton        *visibleSelfBtnIcon;
    UIButton        *rightBtn;
    UILabel         *_footRightLab;
    int             _visibleMode;
    NSString        *_hiddentextStr;
    NSString        *_updateImageStr;
    NSString        *_addressStr;
}
@property(nonatomic,strong)UIView         *photoView;
@property(nonatomic,strong)UIView         *footView;
@property(nonatomic,strong)UITextView     *textView;
@property(nonatomic,strong)NSMutableDictionary *chooseDataDic;
@end

@implementation PostMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _visibleMode = 1;
    _photoupdateCurrId = -1;
    _addressStr = @"";
    _photoArray = [NSMutableArray array];
    _chooseDataDic = [NSMutableDictionary dictionary];
    self.info = [[TPListInfo alloc]init];
    self.info.talk_title = [NSString stringWithFormat:@"话题"];
    self.info.talk_id = 4;
    [self creatUI];
    [self setCustomNavBar];
    [self onOpenKeyBoard];
}

- (void)setCustomNavBar
{
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)creatUI
{
    header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(NAVIGATION_HEIGHT + 1);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(165 + 88);
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor blackColor];
    [header addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(110);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    self.textView.text = [NSString stringWithFormat:@"#%@#",_info.talk_title];
    lowerLimit = self.textView.text.length;
    [self findAllKeywordsChangeColor:self.textView];
    
    _photoView = [[UIView alloc] init];
    [header addSubview:_photoView];
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(5);
        make.height.mas_equalTo(88);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    UIButton *addImage = [[UIButton alloc]init];
    [addImage setImage:[UIImage imageNamed:@"tp_home_postmessage_add_image"] forState:UIControlStateNormal];
    [addImage setImage:[UIImage imageNamed:@"tp_home_postmessage_add_image"] forState:UIControlStateHighlighted];
    [addImage addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:addImage];
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_left);
        make.top.equalTo(self.photoView.mas_top);
        make.height.width.mas_equalTo(78);
    }];
    
    UIButton *positioningBtn = [[UIButton alloc]init];
    positioningBtn.backgroundColor = [UIColor lightGrayColor];
    positioningBtn.layer.cornerRadius = 5;
    positioningBtn.layer.masksToBounds = YES;
    [header addSubview:positioningBtn];
    [positioningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.mas_equalTo(24);
    }];
    
    positioningLabel = [[UILabel alloc]init];
    [positioningBtn addSubview:positioningLabel];
    [positioningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(positioningBtn.mas_centerY);
        make.left.equalTo(positioningBtn.mas_left).offset(5);
        make.right.equalTo(positioningBtn.mas_right).offset(-5);
    }];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"tp_common_positioning_icon"];
    attach.bounds = CGRectMake(0, -2, 10, 14);
    NSAttributedString *iconAttStr = [NSAttributedString attributedStringWithAttachment:attach];
    NSDictionary *dictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSAttributedString *countAttStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" 你在那里？"] attributes:dictionary];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:iconAttStr];
    [attributedString appendAttributedString:countAttStr];
    
    positioningLabel.attributedText = attributedString;
    
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footView];
    
    _footRightLab = [[UILabel alloc]init];
    _footRightLab.text = [NSString stringWithFormat:@"%lu/500",(unsigned long)_textView.text.length];
    _footRightLab.textAlignment = NSTextAlignmentRight;
    _footRightLab.textColor = [UIColor lightGrayColor];
    _footRightLab.font = [UIFont systemFontOfSize:14];
    [_footView addSubview:_footRightLab];
    [_footRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.footView.mas_right).offset(-15);
        make.centerY.equalTo(self.footView.mas_centerY);
    }];
    
    UIButton *footImage = [[UIButton alloc]init];
    [footImage setImage:[UIImage imageNamed:@"tp_home_postmessage_photo_icon"] forState:UIControlStateNormal];
    [footImage setImage:[UIImage imageNamed:@"tp_home_postmessage_photo_icon"] forState:UIControlStateHighlighted];
    [footImage addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:footImage];
    [footImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footView.mas_left).offset(15);
        make.centerY.equalTo(self.footView.mas_centerY);
    }];
    
    UIButton *footAticon = [[UIButton alloc]init];
    [footAticon setImage:[UIImage imageNamed:@"tp_home_postmessage_@_icon"] forState:UIControlStateNormal];
    [footAticon setImage:[UIImage imageNamed:@"tp_home_postmessage_@_icon"] forState:UIControlStateHighlighted];
    [footAticon addTarget:self action:@selector(onFootAticonClick) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:footAticon];
    [footAticon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footImage.mas_right).offset(30);
        make.centerY.equalTo(self.footView.mas_centerY);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MoveViewWhenShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MoveViewWhenHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - click
- (void)onVisibleAllBtnClick
{
    _visibleMode = 1;
    visibleSelfBtnIcon.selected = NO;
    visibleAllBtnIcon.selected = YES;
}

- (void)onVisibleSelfBtnClick
{
    _visibleMode = 0;
    visibleSelfBtnIcon.selected = YES;
    visibleAllBtnIcon.selected = NO;
}

- (void)onFootAticonClick
{
    [self onHideKeyBoard];
    TPFriendsChooseViewController *friendsChoose = [[TPFriendsChooseViewController alloc]init];
    friendsChoose.delegate = self;
    [self.navigationController pushViewController:friendsChoose animated:YES];
}

- (void)addImageClick
{
    [self onHideKeyBoard];
}

- (void)onBackClick
{
    [self onHideKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSendMessageClick:(UIButton *)btn
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        NSRange rangeDefault = textView.selectedRange;
        NSString *last = [textView.text substringWithRange:NSMakeRange(rangeDefault.location - 1, 1)];
        if ([last isEqualToString:@" "]) {
            NSString *textViewStr = [textView.text substringToIndex:rangeDefault.location - 1];
            NSRange nameRange = [textViewStr rangeOfString:@"@" options:NSBackwardsSearch];
            if (nameRange.length > 0) {
                NSString *nameStr = [textViewStr substringFromIndex:nameRange.location + 1];
                for (Friend *friend in _chooseDataDic.allValues) {
                    if ([nameStr isEqualToString:friend.nickName]) {
                        NSMutableString *newtextView = [NSMutableString stringWithFormat:@"%@",textView.text];
                        [newtextView deleteCharactersInRange:NSMakeRange(nameRange.location + 1, nameStr.length + 1)];
                        textView.text = newtextView;
                    }
                }
            }
        }
    }
    if ([text isEqualToString:@"@"]) {
        [self onFootAticonClick];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length <= lowerLimit) {
        self.textView.text = [NSString stringWithFormat:@"#%@#",_info.talk_title];
    }
    _footRightLab.text = [NSString stringWithFormat:@"%lu/500",(unsigned long)self.textView.text.length];
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        [self findAllKeywordsChangeColor:textView];
    }
}

- (void)findAllKeywordsChangeColor:(UITextView *)textView
{
    NSString *string = textView.text;
    NSRange rangeDefault = textView.selectedRange;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range: NSMakeRange(0, string.length)];
    NSString *pattern = @"\\#(.*?)\\#";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options: NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (!matches || matches.count == 0) {
        return;
    }
    NSTextCheckingResult *result = matches[0];
    NSRange range = [result rangeAtIndex:0];
    if (range.location > 0) {
        [attrStr deleteCharactersInRange:NSMakeRange(0, range.location)];
        textView.text = attrStr.string;
        [self findAllKeywordsChangeColor:textView];
        return;
    }
    NSAttributedString *talkTitle = [attrStr attributedSubstringFromRange:range];
    if (![talkTitle.string isEqualToString:[NSString stringWithFormat:@"#%@#",_info.talk_title]]) {
        [attrStr replaceCharactersInRange:range withString:[NSString stringWithFormat:@"#%@#",_info.talk_title]];
        textView.text = attrStr.string;
        [self findAllKeywordsChangeColor:textView];
        return;
    }
    
    NSString *pattern1 = @"\\@(.*?)\\ ";
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:pattern1 options: NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches1 = [regex1 matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result1 in matches1) {
        NSRange range1 = [result1 rangeAtIndex:0];
        NSAttributedString *talkTitle_A = [attrStr attributedSubstringFromRange:NSMakeRange(range1.location + 1, range1.length - 2)];
        for (Friend *friend in _chooseDataDic.allValues) {
            if ([friend.nickName isEqualToString:talkTitle_A.string]) {
                NSString *subStr1 = [attrStr.string substringWithRange:range1];
                NSUInteger length1 = subStr1.length;
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(range1.location, length1)];
                [attrStr addAttribute:NSFontAttributeName value:textView.font range:NSMakeRange(0, string.length)];
            }
        }
    }
    NSString *subStr = [attrStr.string substringWithRange:range];
    NSUInteger length = subStr.length;
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(range.location, length)];
    [attrStr addAttribute:NSFontAttributeName value:textView.font range:NSMakeRange(0, string.length)];
    textView.attributedText = attrStr;
    NSRange rangeNow = NSMakeRange(rangeDefault.location, 0);
    textView.selectedRange = rangeNow;
    
    _hiddentextStr = textView.text;
    
}

#pragma mark - KeyBoardNotification
- (void)MoveViewWhenShowKeyBoard:(NSNotification *)notification
{
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.footView setFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - kbHeight, SCREEN_WIDTH, 50)];
    }];
}

- (void)MoveViewWhenHideKeyBoard:(NSNotification *)notification
{
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.footView setFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    }];
}

- (void)onHideKeyBoard
{
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
}

- (void)onOpenKeyBoard
{
    [_textView becomeFirstResponder];
}

#pragma mark - TPFriendsChooseViewControllerProtocol
- (void)onTPFriendsChooseViewControllerBack:(NSMutableArray *)array
{
    for (Friend *friend in array) {
        NSString *friendStr = [NSString stringWithFormat:@" @%@ ",friend.nickName];
        _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,friendStr];
        [_chooseDataDic setObject:friend forKey:[NSString stringWithFormat:@"%d",friend.userId]];
    }
    [self onOpenKeyBoard];
    [self textViewDidChange:_textView];
}
@end
