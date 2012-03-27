//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Andrew Rosenberg on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

    @synthesize programStack = _programStack;

////////////// OPERAND STACK METHODS //////////////////////////
    - (NSMutableArray *)programStack
    {
        if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
        return _programStack;
    }
    
    - (void)pushOperand:(double)operand
    {
        [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    }

    - (void)clearOperands
    {
        [self.programStack removeAllObjects];
    }
    
//////////////////////////////////////////////////////////////


////////////// PERFORM OPERATION /////////////////////////////
    - (double)performOperation:(NSString * ) operation
    {
        [self.programStack addObject:operation];
        return [CalculatorBrain runProgram:self.program];
    }

////////////// program //////////////////////
    - (id)program
    {
        return [self.programStack copy];
    }

+ (NSString *) descriptionOfProgram:(id)program
    {
        return @"implement in HW assignment 2";
    }

+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]){
        {
            NSString *operation = topOfStack;
            //+++++++++++++++++++++++++++++++++++++++++++++++++//
            if ([operation isEqualToString:@"+"]) {
                result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
                //*************************************************//
            } else if ([@"*" isEqualToString:operation]) {
                result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
                /////////////////////////////////////////////////////
            } else if ([@"/" isEqualToString:operation]) {
                result = [self popOperandOffStack:stack]; //make result divisor
                result = [self popOperandOffStack:stack]; // result;
                //-------------------------------------------------//
            } else if ([@"-" isEqualToString:operation]) {
                result = (0 - [self popOperandOffStack:stack])+ [self popOperandOffStack:stack];
                //SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN  //
            } else if ([@"SIN" isEqualToString:operation]){
                result = sin([self popOperandOffStack:stack]);
                //COS COS COS COS COS COS COS COS COS COS COS COS  //
            } else if ([@"COS" isEqualToString:operation]){
                result = cos([self popOperandOffStack:stack]);
                //SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT//
            } else if ([@"SQRT" isEqualToString:operation]){
                result = sqrt([self popOperandOffStack:stack]);
                //PI PI PI PI PI PI PI PI PI PI PI PI PI PI PI PI  //
            } else if ([@"Pi" isEqualToString:operation]){
                result = 2*acos(0);
            }
        }
    }
    
    return result;
}
// am I supposed to create a second method or just update this one?
+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray self]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}
@end