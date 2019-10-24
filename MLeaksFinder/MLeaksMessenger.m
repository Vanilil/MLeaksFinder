/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "MLeaksMessenger.h"

static __weak UIAlertController *alertView;

@implementation MLeaksMessenger

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self alertWithTitle:title message:message delegate:nil additionalButtonTitle:nil];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
              delegate:(id<MLeaksAlertDelegate>)delegate
 additionalButtonTitle:(NSString *)additionalButtonTitle {
    UIAlertController *alertViewTemp = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertViewTemp addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [delegate alertViewClickedButtonAtIndex:0];
    }]];
    
    NSString *defaultTitle = ((additionalButtonTitle != nil) ? additionalButtonTitle : @"Default");
    [alertViewTemp addAction:[UIAlertAction actionWithTitle:defaultTitle
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [delegate alertViewClickedButtonAtIndex:1];
    }]];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (@available(iOS 13.0, *)) {
        UIScene *scene = [UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        if (scene && [scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (windowScene.windows.count > 0)
                window = [windowScene.windows objectAtIndex:0];
        }
    }
    
    if (window != nil && window.rootViewController != nil) {
        [window.rootViewController presentViewController:alertViewTemp animated:YES completion:nil];
    }
    
    alertView = alertViewTemp;
    
    NSLog(@"%@: %@", title, message);
}

@end
