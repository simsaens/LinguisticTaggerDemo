//
//  SyntaxSelectorAccessoryView.m
//  LinguisticTaggerDemo
//
//  Created by Simeon on 20/12/2013.
//  Copyright (c) 2013 Two Lives Left. All rights reserved.
//

#import "SyntaxSelectorAccessoryView.h"

@implementation SyntaxSelectorAccessoryView
{
    UISegmentedControl *syntaxSelector;
    
    NSDictionary *itemsToTokens;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        itemsToTokens = @{
                           @"All": @(SyntaxSelectorTokenTypeAll),
                           @"Nouns": @(SyntaxSelectorTokenTypeNoun),
                           @"Adjectives": @(SyntaxSelectorTokenTypeAdjective),
                           @"Verbs": @(SyntaxSelectorTokenTypeVerb),
                           @"Adverbs": @(SyntaxSelectorTokenTypeAdverb),
                           @"Particle": @(SyntaxSelectorTokenTypeParticle),
                           @"Preposition": @(SyntaxSelectorTokenTypePreposition),
                           @"Pronoun": @(SyntaxSelectorTokenTypePronoun),
                           @"Determiner": @(SyntaxSelectorTokenTypeDeterminer),
                           @"Conjunction": @(SyntaxSelectorTokenTypeConjunction),
                         };
        
        NSArray *items = @[ @"All", @"Nouns", @"Adjectives", @"Verbs", @"Adverbs"];
        
        syntaxSelector = [[UISegmentedControl alloc] initWithItems:items];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            for( int i = 0; i < items.count; i++ )
            {
                [syntaxSelector setWidth:60 forSegmentAtIndex:i];
            }
        }
        
        [self addSubview:syntaxSelector];
        
        syntaxSelector.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        [syntaxSelector addTarget:self action:@selector(syntaxValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        syntaxSelector.selectedSegmentIndex = 0;
    }
    return self;
}

- (void) syntaxValueChanged:(UISegmentedControl*)sender
{
    if( [delegate respondsToSelector:@selector(syntaxSelector:selectedTokenType:)] )
    {
        NSString *title = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
        
        SyntaxSelectorTokenType type = (SyntaxSelectorTokenType)[itemsToTokens[title] integerValue];
        
        [delegate syntaxSelector:self selectedTokenType:type];
    }
}

@end
