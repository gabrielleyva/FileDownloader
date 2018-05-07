//
//  ViewController.m
//  File Downloader
//
//  Created by Gabriel I Leyva Merino on 5/6/18.
//  Copyright © 2018 Gabriel Leyva Merino. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *chunksTextField;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ViewController 


#pragma Lazy Instantiation
-(FileDonwloaderViewModel*)fileDownloader {
    if(!_fileDownloader){
        _fileDownloader = [FileDonwloaderViewModel alloc];
    }
    
    return _fileDownloader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self prepareProgressBar];
    [self prepareLabel];
    [self prepareDownloadButton];
    [self prepareTextFields];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateProgress{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text = [NSString stringWithFormat:@"Progress: %.2f%%", self.fileDownloader.progress];
        [self.progressBar setProgress: ((float) self.fileDownloader.progress) / 100.00];
        
        if (self.fileDownloader.completed) {
            [self.downloadButton setEnabled:YES]; //enable start button when file is done downloading
            [self.downloadButton setTitle:@"Start" forState: UIControlStateNormal];
            [self.timer invalidate];
        }
    });
}

-(void)startTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(updateProgress)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)prepareLabel {
    self.label.text = @"Progress: 0.00%";
}

-(void)prepareProgressBar {
    self.progressBar.progress = 0.0;
}

-(void)prepareTextFields {
    self.textField.delegate = self;
    self.sizeTextField.delegate = self;
    self.chunksTextField.delegate = self;
}

-(void)prepareDownloadButton {
    [self.downloadButton setEnabled:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField endEditing:YES]; //dismiss keyboard after return key is hit
    [self.sizeTextField endEditing:YES];
    [self.chunksTextField endEditing:YES];
    
    //enable downlaod button if input is entered
    if (self.textField.text != nil && self.sizeTextField.text != nil && self.chunksTextField.text != nil){
        [self.downloadButton setEnabled:YES];
    }
}

- (IBAction)downloadButtonPressed:(id)sender {
    
    [self startTimer];
    
    //TEST URL: http://bddfce4297151.bwtest-aws.pravala.com/384MB.jar
    NSURL *url = [NSURL URLWithString:self.textField.text];
    NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myFile.jar"];
    int chuncks = [self.chunksTextField.text intValue];
    
    // 1 MiB = 2^20 Bytes
    long long size = (1048576 * [self.sizeTextField.text intValue]);
    [self.fileDownloader downloadFileWith:url withChunks:chuncks withPath:file withFileSize: size];

    [self.downloadButton setTitle:@"Downloading" forState: UIControlStateNormal];
    [self.downloadButton setEnabled:NO]; //Disable start button when process starts
 
}

#pragma UITextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField endEditing:YES]; //dismiss keyboard after return key is hit
    [self.sizeTextField endEditing:YES];
    [self.chunksTextField endEditing:YES];
    
    //enable downlaod button if input is entered
    if (self.textField.text != nil && self.sizeTextField.text != nil && self.chunksTextField.text != nil){
        [self.downloadButton setEnabled:YES];
    }
    return YES;
}

@end
