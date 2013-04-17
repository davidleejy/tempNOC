//
//  NoteViewTwo.m
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/13/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NoteView.h"
#import "ViewHelper.h"
#import "GzColors.h"

@interface NoteView ()
@property(nonatomic,weak,readwrite) IBOutlet id <NoteViewDelegate> delegate;
@property (readonly) UILabel* content;
@end

// For Hendy's note materials...
static int leftIndent = 12;
static int topIndent = 30;

@implementation NoteView

@synthesize delegate = _delegate;
@synthesize content = _content;

- (id)initWithFrame:(CGRect)f AndText:(NSString*)s
{
    self = [super initWithFrame:f];
    if (self) {
        _content = [[UILabel alloc]initWithFrame:CGRectMake(leftIndent, topIndent, f.size.width-leftIndent, f.size.height-topIndent)];
        [self addSubview:_content];
        [_content setNumberOfLines:0];
        [_content setBackgroundColor:[UIColor clearColor]];
        [_content setUserInteractionEnabled:YES]; //impt
        [_content setText:s];
        [_content setTextColor:[GzColors colorFromHex:Black]];
        _textColorGZColorString = Black;
        [self alignTextToTopLeftOfHendysMaterial];
    }
    return self;
}


-(void)setDelegate:(id<NoteViewDelegate>)aDelegate{
    _delegate = aDelegate;
}

-(void)setText:(NSString*)myText{
    [_content setText:myText];
    [self alignTextToTopLeftOfHendysMaterial];
}

-(NSString*)getText{
    return [_content text];
}

-(void)setTextColor:(UIColor*)myColor{
    [_content setTextColor:myColor];
}

-(void)setTextColorGZColorString:(NSString*)GZColorHexValue{
    _textColorGZColorString = GZColorHexValue;
    [self setTextColor:[GzColors colorFromHex:GZColorHexValue]];
}

-(UIColor*)getTextColor{
    return [_content textColor];
}

-(NSString*)getTextColorGZColorString{
    return _textColorGZColorString;
}

-(void)setFont:(UIFont*)myFont{
    [_content setFont:myFont];
    [self alignTextToTopLeftOfHendysMaterial];
}

-(UIFont*)getFont{
    return [_content font];
}

-(void)setMaterialWithPictureFileName:(NSString*)myMaterial{
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:myMaterial]]];
    _materialFileName = myMaterial;
}

-(void)setMaterial:(UIColor*)myMaterial{
    [self setBackgroundColor:myMaterial];
}

-(UIColor*)getMaterial{
    return self.backgroundColor;
}

-(NSString*)getMaterialFileName{
    return _materialFileName;
}

-(CGPoint)getFrameOrigin{
    return self.frame.origin;
}

-(void)setFrameOrigin:(CGPoint)myFrameOrigin{
    self.frame = CGRectMake(myFrameOrigin.x,
                            myFrameOrigin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

/**** HELPER FUNCTION ****/
-(void)alignTextToTopLeftOfHendysMaterial{
    _content.frame = CGRectMake(leftIndent, topIndent, self.bounds.size.width-leftIndent, self.bounds.size.height-topIndent);
    [_content sizeToFit];
    _content.frame = CGRectMake(leftIndent, topIndent, _content.frame.size.width, _content.frame.size.height);
}

@end
