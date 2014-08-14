//
//  InternetRequest.m
//  ProjectModel
//
//  Created by dongway on 14-8-9.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import "InternetRequest.h"

@implementation InternetRequest


+(NSDictionary *)loadDataWithUrlString:(NSString *)urlString
{
    NSError *error;
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStringEncoding);
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStringEncoding]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (response != nil && error == nil) {
        return [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    } else {
        return  nil;
    }
}


@end
