//
//  ViewController.h
//  File Downloader
//
//  Created by Gabriel I Leyva Merino on 5/6/18.
//  Copyright © 2018 Gabriel Leyva Merino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDonwloaderViewModel.h"
#import "JGDownloadAcceleration.h"

@interface ViewController : UIViewController
@property (weak, nonatomic)  NSTimer *timer;
@property (nonatomic, strong) FileDonwloaderViewModel *fileDownloader;


@end

