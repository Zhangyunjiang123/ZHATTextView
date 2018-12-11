# ZHATTextView

今天项目新增的话题功能，类似于新浪微博，可以@他人、并且@他人和话题的文本必须是高亮状态。
![image](https://github.com/Zhangyunjiang123/ZHATTextView/blob/master/at_1.gif)
其实实现名字高亮状态特别的简单，只需要通过正则表达式进行字符搜索，将特定字符改变颜色

    NSString *pattern1 = @"\\@(.*?)\\ ";
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:pattern1 options: NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches1 = [regex1 matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result1 in matches1) {
    NSRange range1 = [result1 rangeAtIndex:0];
    NSAttributedString *talkTitle_A = [attrStr attributedSubstringFromRange:NSMakeRange(range1.location + 1, range1.length - 2)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(range1.location, length1)];
    }


其中“\\@(.*?)\\ ”这个表示搜索从“@”符号到“空格”符号的范围的结果，根据这个搜索结果将特定范围的字符改变颜色；
但是并不是所有的@符号到空格符号里面的内容都是用户名称，所以我特意加了一个判断，通过查找是否在@他人里列表里面；

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

这写代码都是放在UITextView 的代理

    - (void)textViewDidChange:(UITextView *)textView

然后又发现了一个问题，在删除的时候发现只能通过一个字符一个字符的删除，查看了微博的发布页面，发现发布页面也是通过一个字符一个字符进行删除，但是微信是可以将名字和@符号一起删除，所以又实现了下面方法。

![image](https://github.com/Zhangyunjiang123/ZHATTextView/blob/master/at_2.gif)

通过在UITextView 的代理

    - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

实现监听删除空格的时候，查询是否存在用户名称和@符号然后进行统一删除

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



最后又发现了光标的问题，我在移动光标到特定@他人的名字中插入数据，但是对应的字符并没有发生变化，对此，网上有一下方法是通过控制光标不能跳转到指定的位置，我认为这中方法也是可行的。我在这里的处理方式是任你插入数据，只是如果你插入数据，我查询判断你没有在我@用户的列表里面，我自动将颜色改变为黑色；


![image](https://github.com/Zhangyunjiang123/ZHATTextView/blob/master/at_2.gif)



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
