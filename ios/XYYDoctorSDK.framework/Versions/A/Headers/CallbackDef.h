//
//  CallbackDef.h
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#ifndef CallbackDef_h
#define CallbackDef_h


typedef void (^OperatorCallback)(int code, NSString* msg); //操作返回回调 成功code＝0 其他失败
typedef void (^DataCallback)(id data); // 数据返回回调 成功不为nil

#endif
