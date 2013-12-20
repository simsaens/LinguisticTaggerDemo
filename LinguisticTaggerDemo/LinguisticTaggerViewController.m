/*
   Incredibly naive and simple linguistic tagger implementation
   based on Apple's TextKit demo
 */

/*
     File: TKDInteractiveTextColoringViewController.m
 Abstract: 
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */

#import "LinguisticTaggerViewController.h"
#import "TKDInteractiveTextColoringTextStorage.h"

#import "SyntaxSelectorAccessoryView.h"

@interface LinguisticTaggerViewController ()<SyntaxSelectorDelegate>

@end

@implementation LinguisticTaggerViewController
{
    NSDictionary *tagTypeLookup;
}

-(void)createLookup
{
    tagTypeLookup = @{
                       @(SyntaxSelectorTokenTypeNoun) : @"Noun",
                       @(SyntaxSelectorTokenTypeVerb) : @"Verb",
                       @(SyntaxSelectorTokenTypeAdverb) : @"Adverb",
                       @(SyntaxSelectorTokenTypeAdjective) : @"Adjective",
                       @(SyntaxSelectorTokenTypeParticle) : @"Particle",
                       @(SyntaxSelectorTokenTypePreposition) : @"Preposition",
                       @(SyntaxSelectorTokenTypePronoun) : @"Pronoun",
                       @(SyntaxSelectorTokenTypeDeterminer) : @"Determiner",
                       @(SyntaxSelectorTokenTypeConjunction) : @"Conjunction",
                     };
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    CGRect newTextViewRect = CGRectInset(self.view.bounds, 8., 20.);

    self.textStorage = [[TKDInteractiveTextColoringTextStorage alloc] init];

    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];

    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(newTextViewRect.size.width, CGFLOAT_MAX)];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];

    UITextView *newTextView = [[UITextView alloc] initWithFrame:newTextViewRect textContainer:container];
    newTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    newTextView.scrollEnabled = YES;
    newTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    SyntaxSelectorAccessoryView *syntaxBar = [[SyntaxSelectorAccessoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    syntaxBar.delegate = self;
    
    newTextView.inputAccessoryView = syntaxBar;
    newTextView.font = [UIFont fontWithName:@"Georgia" size:17.0f];
    
    [self.view addSubview:newTextView];
    self.textView = newTextView;
    self.textView.textColor = [UIColor lightGrayColor];
    
    self.textView.text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Alice" ofType:@"txt"] usedEncoding:nil error:NULL];
    
    [self disableHighlighting];
    
    [self createLookup];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
    
    self.textView.selectedRange = NSMakeRange(0, 0);
}

#pragma mark - Linguistic Tagger Stuff

- (void) disableHighlighting
{
    self.textView.textColor = [UIColor blackColor];
    self.textStorage.tokens = @{};
}

- (void) enableHighlighting
{
    self.textView.textColor = [UIColor lightGrayColor];
}

- (NSString*) tagTypeFromSyntaxType:(SyntaxSelectorTokenType)type
{
    return tagTypeLookup[@(type)];
}

- (void) syntaxSelector:(SyntaxSelectorAccessoryView *)selector selectedTokenType:(SyntaxSelectorTokenType)type
{
    switch (type)
    {
        case SyntaxSelectorTokenTypeAll:
            [self disableHighlighting];
            return;
            
        default:
            [self enableHighlighting];
            break;
    }
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeLexicalClass] options:NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames | NSLinguisticTaggerOmitWhitespace];
    
    NSString *textBody = self.textView.text;
    NSString *activeTag = [self tagTypeFromSyntaxType:type];
    
    __block NSMutableSet *foundMatchingWords = [NSMutableSet set];
    
    [tagger setString:textBody];
    
    [tagger enumerateTagsInRange:NSMakeRange(0, self.textView.text.length) scheme:NSLinguisticTagSchemeLexicalClass options:NSLinguisticTaggerOmitPunctuation|NSLinguisticTaggerJoinNames|NSLinguisticTaggerOmitWhitespace usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
    {
        NSArray *tagScores;
        NSArray *tags = [tagger possibleTagsAtIndex:tokenRange.location scheme:NSLinguisticTagSchemeLexicalClass tokenRange:NULL sentenceRange:NULL scores:&tagScores];
        
        if( tags.count > 0 )
        {
            if( [tags[0] isEqualToString:activeTag] )
            {
                [foundMatchingWords addObject:[textBody substringWithRange:tokenRange]];
            }
            
            //NSLog(@"Tagging %@ (%@)", [textBody substringWithRange:tokenRange], tags[0]);
        }
    }];
    
    NSMutableDictionary *tokens = [NSMutableDictionary dictionary];
    
    for( NSString *match in foundMatchingWords )
    {
        tokens[match] = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
    }
    
    self.textStorage.tokens = tokens;
}

@end

