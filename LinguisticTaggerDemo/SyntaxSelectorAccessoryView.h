//
//  SyntaxSelectorAccessoryView.h
//  LinguisticTaggerDemo
//
//  Created by Simeon on 20/12/2013.
//  Copyright (c) 2013 Two Lives Left. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SyntaxSelectorTokenType
{
    SyntaxSelectorTokenTypeAll,
    SyntaxSelectorTokenTypeNoun,
    SyntaxSelectorTokenTypeAdjective,
    SyntaxSelectorTokenTypeVerb,
    SyntaxSelectorTokenTypeAdverb,
    SyntaxSelectorTokenTypeParticle,
    SyntaxSelectorTokenTypePreposition,
    SyntaxSelectorTokenTypePronoun,
    SyntaxSelectorTokenTypeDeterminer,
    SyntaxSelectorTokenTypeConjunction,
} SyntaxSelectorTokenType;

@class SyntaxSelectorAccessoryView;

@protocol SyntaxSelectorDelegate <NSObject>

- (void) syntaxSelector:(SyntaxSelectorAccessoryView*)selector selectedTokenType:(SyntaxSelectorTokenType)type;

@end

@interface SyntaxSelectorAccessoryView : UIInputView

@property (nonatomic, weak) id<SyntaxSelectorDelegate> delegate;

@end
