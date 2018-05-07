//
//  FileDonwloaderViewModel.h
//  File Downloader
//
//  Created by Gabriel I Leyva Merino on 5/6/18.
//  Copyright © 2018 Gabriel Leyva Merino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGDownloadAcceleration.h"

@interface FileDonwloaderViewModel : NSObject
@property (nonatomic) double progress; //progress variable
@property (nonatomic) bool completed;

-(void) downloadFileWith:(NSURL *)url withChunks: (int)chuncks withPath: (NSString *)filePath withFileSize: (long long) size;
@end
