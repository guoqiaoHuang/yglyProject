//
//  StringMsgDefine.h
//  VenusIphone
//
//  Created by wanghaibo on 12-2-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef VenusIphone_StringMsgDefine_h
#define VenusIphone_StringMsgDefine_h


#define ERROR_UNKOWNERROR @"Unkown Error"
#define ERROR_EMAILNULL  @"电子邮箱地址不能为空."
#define ERROR_PASSWORDNULL  @"密码不能为空."
#define ERROR_EMAILFORMATE  @"必须是电子邮箱地址格式."
#define ERROR_NICKNAMENULL  @"昵称不能为空."
#define ERROR_NICKNAMELIMIT  @"昵称不能大于20个字节."
#define ERROR_NICKNAMEWITHSPACE  @"昵称不能包含空白符号."
#define ERROR_PASSWORDLIMIT  @"密码介于4-15个字节."

#define WARNING_NICKNAMERENAME @"昵称重复，请在详细资料页面重新填写"

#define GANK51COLOR [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]
#define GANK102COLOR [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]
#define GANK153COLOR [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]
#define REGEX_EMAIL @"(?:\\w+\\.{1})*\\w+@(\\w+)(\\.\\w{2,3}){1,2}"
#define REGEX_NICKNAME @"[\\u4e00-\\u9fa5\\w]+$"
#define REGEX_PASSWORD @".{6,16}"

#define REGEX_GANKTITLE @"^[^\\s]{3,20}$"
#endif
