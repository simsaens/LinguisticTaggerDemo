/*
   Incredibly naive and simple linguistic tagger implementation
   based on Apple's TextKit demo
 */

/*
 Originally:
 
  File: TKDInteractiveTextColoringViewController.m
  Abstract:
  Version: 1.0
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
        //enumerateTagsInRange appears to provide the best quality result
        if( [tag isEqualToString:activeTag] )
        {
            [foundMatchingWords addObject:[textBody substringWithRange:tokenRange]];
        }

        //The following method retrieves a probability for each possibly lexical class the word
        // could fall into. The result seems inferior to just using the match provided in the
        // enumeration block.
        /*
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
        */
    }];
    
    NSMutableDictionary *tokens = [NSMutableDictionary dictionary];
    
    for( NSString *match in foundMatchingWords )
    {
        tokens[match] = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
    }
    
    self.textStorage.tokens = tokens;
}

@end

