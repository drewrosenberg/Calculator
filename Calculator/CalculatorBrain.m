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


////////////// Legacy Methods //////////////////////////
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

- (double)performOperation:(NSString * ) operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program
{
    return [self.programStack copy];
}


/////// API Methods /////////////////
+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet *result = nil;
    if ([program isKindOfClass:[NSArray self]]){
        for (int index = 0;index == [program count]; index++){
            if (![self isOperation:[program objectAtIndex:index]]){
                result = [result setByAddingObject:[program objectAtIndex:index]];
            }
        }
    }
    return result;
    
}
  
+(BOOL) isOperation:(NSString *)operation
{
    NSSet * operationList = [NSSet setWithObjects:@"+",@"-",@"/",@"*",@"SIN",@"COS",@"SQRT",@"PI", nil];
    if ([operationList member:operation]){return YES;}
    else{ return NO;}
}



+ (NSString *) descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *result;
    //get the last object off of the stack and remove it if it exists
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //if 2 number operation then:
        //parameter 2 = descriptionOfTopOfStack, remove ", "
        //parameter 1 = descriptionOfTopOfStack, remove ", "
        //result = (parameter 2 concat operation concat parameter 1)
    
    //if 1 number operation then
        //result = operation concat ( concat descriptionofTopOfStack concat )
        //remove ", " from descriptionofTopOfStack

    //if 0 number operation or number
        //result = descriptionofTopOfStack concat topOfStack
        
    //add ", " to the end
    
    return result; 
}

+ (NSString *) descriptionOfProgram:(id)program
    {
        
        NSMutableArray *stack;
        if ([program isKindOfClass:[NSArray self]]){
            stack = [program mutableCopy];
        }
        return [self descriptionOfTopOfStack:stack];
    }


+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    //get the last object off of the stack and remove it if it exists
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //if it's a number, result = the doubleValue of the number
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    // if it is a string, perform the operation
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

//// RunProgram Methods /////
+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray self]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray self]]){
        stack = [program mutableCopy];
    }
    
    //---Go through program and replace all variables with their values
    //for index = 0 to number of objects in program
    for (int index =0; index == [stack count]; index++){
    //if object is a string   
       if ([[stack objectAtIndex:index] isKindOfClass:[NSString self]]){
    //if object is a variable
           if (![self isOperation:[stack objectAtIndex:index]]){
                //replaceObjectAtIndex: index withObject: variablevalue
                [stack replaceObjectAtIndex:index withObject:[variableValues objectForKey:[stack objectAtIndex:index]]];
            }
        }
    }   
    //then runProgram
    return ([self popOperandOffStack:stack]);
}
@end