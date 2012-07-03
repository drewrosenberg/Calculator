//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Andrew Rosenberg on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
    @property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

    @synthesize operandStack = _operandStack;

////////////// OPERAND STACK METHODS //////////////////////////
    - (NSMutableArray *)operandStack
    {
        if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
        return _operandStack;
    }
    
    - (void)pushOperand:(double)operand
    {
        [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
    }

    - (void)clearOperands
    {
        [self.operandStack removeAllObjects];
    }
    
    - (double)popOperand
    {
        NSNumber *operandObject = [self.operandStack lastObject];
        if (operandObject)[self.operandStack removeLastObject];
        return [operandObject doubleValue];
    }
//////////////////////////////////////////////////////////////


////////////// PERFORM OPERATION /////////////////////////////
    - (double)performOperation:(NSString * ) operation
    {
        NSLog(@"Stack before:%@\nOperation:%@",self,operation);
        double result = 0;
        
        //------------calculate result --------------------//
        {
        //+++++++++++++++++++++++++++++++++++++++++++++++++//
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperand] + [self popOperand];
        //*************************************************//
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperand] * [self popOperand];
        /////////////////////////////////////////////////////
        } else if ([@"/" isEqualToString:operation]) {
            result = [self popOperand]; //make result divisor
            result = [self popOperand] / result;
        //-------------------------------------------------//
        } else if ([@"-" isEqualToString:operation]) {
            result = (0 - [self popOperand])+ [self popOperand];
        //SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN  //
        } else if ([@"SIN" isEqualToString:operation]){
            result = sin([self popOperand]);
        //COS COS COS COS COS COS COS COS COS COS COS COS  //
        } else if ([@"COS" isEqualToString:operation]){
            result = cos([self popOperand]);
        //SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT//
        } else if ([@"SQRT" isEqualToString:operation]){
            result = sqrt([self popOperand]);
        //PI PI PI PI PI PI PI PI PI PI PI PI PI PI PI PI  //
        } else if ([@"Pi" isEqualToString:operation]){
            result = M_PI;
        //+/- +/- +/- +/- +/- +/- +/- +/- +/- +/- +/- +/- //
        } else if ([@"+/-" isEqualToString:operation]){
            result = 0 - [self popOperand];
        }

    }

        NSLog(@"Stack after:%@",self);

        return result;
    }
//////////////////////////////////////////////////////////////
- (NSString *)description
{
    return [NSString stringWithFormat:@"stack = %@", self.operandStack];
}
@end
