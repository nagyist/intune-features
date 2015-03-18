//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "WaveformViewController.h"
#import "IntuneLab-Swift.h"

#import "VMFilePickerController.h"
#import <tempo/modules/ReadFromFileModule.h>


@interface WaveformViewController ()

@property (weak, nonatomic) IBOutlet VMWaveformView *waveformView;

@end


@implementation WaveformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadWaveform:(NSString*)file {
    tempo::ReadFromFileModule fileReader(file.UTF8String);
    auto length = fileReader.lengthInFrames();

    tempo::UniqueBuffer<Float32> buffer(length);
    auto numberOfFramesRead = fileReader.render(buffer);
    [self.waveformView setSamples:buffer.data() count:numberOfFramesRead];
}

- (IBAction)openFile:(UIButton*)sender {
    VMFilePickerController *filePicker = [[VMFilePickerController alloc] init];
    filePicker.selectionBlock = ^(NSString* file, NSString* filename) {
        [self loadWaveform:file];
    };
    [filePicker presentInViewController:self sourceRect:sender.frame];
}

@end
