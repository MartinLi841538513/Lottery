//
//  InternetRequest.h
//  ProjectModel
//
//  Created by dongway on 14-8-9.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetRequest : NSObject


+(NSDictionary *)loadDataWithUrlString:(NSString *)urlString;

@end
