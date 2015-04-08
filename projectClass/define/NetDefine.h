//
//  Header.h
//  VENUS
//
//  Created by wanghaibo on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef LHSHARE_NetDefine_h
#define LHSHARE_NetDefine_h

#define VERSION 
#define HOSTNAME @"www.baidu.com"

#define USE_TEST_URL
#ifdef USE_TEST_URL
    #define CONNECTION_SITE        @"http://app.mdd123.com/api/Interface/index.php"
    #define CONNECTION_IMGSITE      @"http://www.lhshare.com/api/"
    #define URL_CONNECTION_IMGSITE  @"http://www.lhshare.com"
#else
    #define CONNECTION_SITE        @"http://www.leihai.com/api/"
    #define CONNECTION_IMGSITE      @"http://www.leihai.com/api/"
    #define URL_CONNECTION_IMGSITE  @"http://www.leihai.com"
#endif


//登陆
#define app_logout                    @"?m=member&c=app&a=logout"
#define app_login                     @"?m=member&c=app&a=mobile_login"
#define app_auto_login         @"?m=member&c=app&a=auto_login"
#define app_register                  @"?m=member&c=app&a=mobile_register"
#define app_public_checkname_ajax     @"?m=member&c=app&a=public_checkname_ajax"
#define app_public_checkemail_ajax    @"?m=member&c=app&a=public_checkemail_ajax"

//用户信息
#define app_account_manag       @"?m=member&c=appuser&a=account_manage"
#define app_account_manage_info  @"?m=member&c=appuser&a=account_manage_info"
#define app_account_manage_password     @"?m=member&c=appuser&a=account_manage_password"
#define app_account_manage_email     @"?m=member&c=appuser&a=account_manage_email"
#define app_account_manage_avatar      @"?m=member&c=appuser&a=account_manage_avatar"
#define app_account_manage_avatar_get  @"?m=member&c=appuser&a=account_manage_avatar_get"

#define app_account_manage_password_lost     @"?m=member&c=appuser&a=account_manage_password_lost"

//带你玩
#define app_dainiwan_list          @"?m=content&c=app&a=dainiwan_list"
#define app_dainiwan_info          @"?m=content&c=app&a=dainiwan_info"
#define app_xlte_info         @"?m=content&c=app&a=xlte_info"
#define app_xcxq_info         @"?m=content&c=app&a=xcxq_info"
#define app_ydxq_info        @"?m=content&c=app&a=ydxq_info"
//主题玩
#define app_zhuti_list        @"?m=content&c=app&a=zhuti_list"
#define app_zhuti_info     @"?m=content&c=app&a=zhuti_info"
#define app_zhuti_yxtype_add     @"?m=content&c=app&a=yxtype_add"
#define app_zhuti_djs_list     @"?m=content&c=app&a=djs_list"

#define app_zhuti_djs_add     @"?m=content&c=app&a=djs_add"

//搜索链接
#define app_zhuti_search_zthd    @"?m=content&c=search&a=search_zthd"
#define app_zhuti_search_tswf    @"?m=content&c=search&a=search_tswf"
#define app_zhuti_search_xl    @"?m=content&c=search&a=search_xl"

//首页
#define app_shouye_data @"?m=content&c=app&a=shouye_show"

//预定详情接口
#define app_order_chuli @"?m=order&c=app&a=order_chuli"

//订单－ 用户订单
#define app_dingdan_yonghu_list @"?m=order&c=app&a=xy_orderlist"
//订单－ 商户订单
#define app_dingdan_shanghu_list @"?m=order&c=app&a=xs_orderlist"

//用户订单详情
#define app_dingdan_yonghu_detail @"?m=order&c=app&a=xy_orderinfo"
#define app_dingdan_yonghu_yanzheng @"?m=order&c=app&a=xy_yanzhengdate"
#define app_dingdan_shanghu_detail @"?m=order&c=app&a=xs_orderinfo"

//app意见反馈
#define app_dingdan_yonghu_yjfk @"?m=order&c=app&a=yjfk"


//商家用户联系验证
#define app_dingdan_shanghu_lianxi @"?m=order&c=app&a=xs_checklx"
#define app_dingdan_shanghu_tixi @"?m=member&c=message&a=send_userid"

//商家订单验证
#define app_dingdan_shanghu_yanzheng @"?m=order&c=app&a=xs_checkyzm"

#define app_yonghu_shoucang @"?m=order&c=app&a=xy_shoucang"



#define app_registration_statement @"http://app.mdd123.com/api/Interface/index.php?m=content&c=index&a=webcontent&types=4"
#endif
