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


#pragma mark - static variables
//STATIC VARIABLES
static NSDictionary *OPERATION_LIST = nil;

@implementation CalculatorBrain
/// list of supported operations///
+(NSDictionary *)operationList{
    /// dictionary key is operation, value is number of operands
    if (!OPERATION_LIST){
        OPERATION_LIST = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:2], @"+",
                          [NSNumber numberWithInt:2], @"-",
                          [NSNumber numberWithInt:2], @"/",
                          [NSNumber numberWithInt:2], @"*",
                          [NSNumber numberWithInt:1], @"SIN",
                          [NSNumber numberWithInt:1], @"COS",
                          [NSNumber numberWithInt:1], @"SQRT",
                          [NSNumber numberWithInt:1], @"±",
                          [NSNumber numberWithInt:0], @"Pi",
                          nil];
    }
    
    return OPERATION_LIST;
}

@synthesize programStack = _programStack;

#pragma mark - Legacy Methods

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
    return [[CalculatorBrain runProgram:self.program] doubleValue];
}

- (id)program
{
    return [self.programStack copy];
}


#pragma mark - API Methods
/////// API Methods /////////////////

+ (NSSet *)variablesUsedInProgram:(id)program
{
    //initialize set
    NSSet *result = [NSSet set];
    
    id thisObject = nil; //object from program in focus
    
    //use introspection on program to make sure it is an array
    if ([program isKindOfClass:[NSArray self]]){
        //go through program to find variables
        for (int index = 0;index < [program count]; index++){
            thisObject = [program objectAtIndex:index];
            //use introspection on thisObject to find strings
            if ([thisObject isKindOfClass:[NSString self]]){
                //if it is not an operation then it must be a variable
                if (![self isOperation:[program objectAtIndex:index]]){
                    result = [result setByAddingObject:[program objectAtIndex:index]];
                }
            }
        }
    }
    return result;
    
}


//Test if an operation takes two operands
+(BOOL) is2Operation: (id)operation
{
    return [[self operationList] objectForKey:operation] == [NSNumber numberWithInt:2];
}

//Test if an operation takes one operand
+(BOOL) is1Operation: (id)operation
{
    return [[self operationList] objectForKey:operation] == [NSNumber numberWithInt:1];}

//Test if the string is an operation
+(BOOL) isOperation:(id)operation
{
    return [[self operationList] objectForKey:operation] != nil;
}


//description of stack method
+ (NSString *) descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *result;
    //get the last object off of the stack and remove it if it exists
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //if 2 number operation then:
    if ([self is2Operation:topOfStack]){
        //parameter 2 = descriptionOfTopOfStack, remove ", "
        NSString * param2 = [self descriptionOfTopOfStack:stack];
        //     param2 = [self removeTrailingComma:param2];
        //parameter 1 = descriptionOfTopOfStack, remove ", "
        NSLog(@"param2=%@",param2);
        
        NSString * param1 = [self descriptionOfTopOfStack:stack];
        //      param1 = [self removeTrailingComma:param1];
        NSLog(@"param1=%@",param1);
        //result = (parameter 2 concat operation concat parameter 1)
        
        
        result = [NSString stringWithFormat:@"(%@%@%@)",param1,topOfStack,param2];
        NSLog(@"result=%@",result);
    }
    
    //if 1 number operation then
    else if ([self is1Operation:topOfStack]){
        //result = operation concat ( concat descriptionofTopOfStack concat )
        NSString * param = [self descriptionOfTopOfStack:stack];
        result = [NSString stringWithFormat:@"%@(%@)",topOfStack,param];
    }
    
    //if number
    else if ([topOfStack isKindOfClass:[NSNumber self]]){
        //result = descriptionofTopOfStack concat topOfStack
        result = [topOfStack stringValue];
    }
    
    else{
        //must be a variable or 0 number operation
        result = topOfStack;
    }
    NSLog(@"result =%@\n",result);
    return result;
}

//description of program operation
+ (NSString *) descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    
    //set the stack if an array was passed in
    if ([program isKindOfClass:[NSArray self]]){
        stack = [program mutableCopy];
    }
    NSString *result = [self descriptionOfTopOfStack:stack];
    
    //run through the stack and build the description of program string
    while ([stack lastObject]) {
        result = [NSString stringWithFormat:@"%@, %@",[self descriptionOfTopOfStack:stack],result];
    }
    
    return result;
}

+(id) perform1OperandOperaton:(id)operation withOperand:(id)operand{
    id result;
    
    //test for errors, return them if there are any
    if (![operand isKindOfClass:[NSNumber class]]){ return operand;}
    
    //perform operations
    //SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN SIN  //
    if ([operation isEqualToString:@"SIN"]){
        result = [NSNumber numberWithDouble:sin([operand doubleValue])];
    }
    
    //COS COS COS COS COS COS COS COS COS COS COS COS  //
    else if ([operation isEqualToString:@"COS"]){
        result = [NSNumber numberWithDouble:cos([operand doubleValue])];
    }
    
    //SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT SQRT//
    else if ([operation isEqualToString:@"SQRT"]){
        result = [NSNumber numberWithDouble:sqrt([operand doubleValue])];
        if (result == [NSNumber numberWithDouble:NAN]){ result = @"Error: √(-1)";}
    }
    
    //± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ±  //
    else if ([operation isEqualToString:@"±"]){
        if ([operand doubleValue] == 0){
            return operand;
        }
        else{
            result = [NSNumber numberWithDouble:-[operand doubleValue] ];
        }
    }
    
    return result;
}

+(id) perform2OperandOperation:(id)operation operand1:(id)operand1 operand2:(id)operand2{
    id result;
    
    //test for errors, return them if there are any
    if (![operand1 isKindOfClass:[NSNumber class]]){ return operand1;}
    if (![operand2 isKindOfClass:[NSNumber class]]){ return operand2;}
    
    //perform operations
    //+++++++++++++++++++++++++++++++++++++++++++++++++//
    if ([operation isEqualToString:@"+"]) {
        result =
        [NSNumber numberWithDouble:
         [operand1 doubleValue] +
         [operand2 doubleValue]];
        //*************************************************//
    } else if ([operation isEqualToString:@"*"]){
        result =
        [NSNumber numberWithDouble:
         [operand1 doubleValue] *
         [operand2 doubleValue]];
        /////////////////////////////////////////////////////
    } else if ([operation isEqualToString:@"/"]){
        if ([operand1 doubleValue] == 0) {
            result = @"ERROR: Divide by 0";
        }
        else{
            result =
            [NSNumber numberWithDouble:
             [operand2 doubleValue] /
             [operand1 doubleValue]];
        }
        //-------------------------------------------------//
    } else if ([operation isEqualToString:@"-"]){
        result =
        [NSNumber numberWithDouble:
         [operand2 doubleValue] -
         [operand1 doubleValue]];
    }
    
    return result;
}


+ (id) popItemOffStack:(NSMutableArray *)stack
{
    //get the last object off of the stack and remove it if it exists
    id result = [stack lastObject];
    if (result) [stack removeLastObject];
    
    
    //if it is a two operand operation, pull two more operands, test for errors, then perform operation
    if ([self is2Operation:result]){
        
        id operand1 = [self popItemOffStack:stack];
        id operand2 = [self popItemOffStack:stack];
        
        //pass the operation (current value of result and two
        result = [self perform2OperandOperation:result operand1:operand1 operand2:operand2];
        
    }
    
    //if it is a single operand operation, pull the operand, test for errors, then perform operation
    if ([self is1Operation:result]){
        id operand = [self popItemOffStack:stack];
        result = [self perform1OperandOperaton:result withOperand:operand];
        
    }
    
    //address individual strings (no operand operations and anything else we come up with later)
    if ([result isKindOfClass:[NSString class]]){
        //PI PI PI PI PI PI PI PI PI PI PI PI PI PI PI PI  //
        if([result isEqualToString:@"Pi"]){
            result = [NSNumber numberWithDouble:M_PI];
        }
    }
    
    // if result is not an operation, then return it as is
    // if it is an NSNumber, then the NSNumber will pass through
    // if it is an NSString (error message), then that will pass through as well
    return result;
}

#pragma mark - RunProgram Methods
//// RunProgram Methods /////

+ (id) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray self]]){
        stack = [program mutableCopy];
    }
    return [self popItemOffStack:stack];
}

+ (id) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray self]]){
        stack = [program mutableCopy];
    }
    
    //---Go through program and replace all variables with their values
    //for index = 0 to number of objects in program
    for (int index=0; index < stack.count; index++){
        //if object is a string
        if ([[stack objectAtIndex:index] isKindOfClass:[NSString class]]){
            //if object is a variable
            if (![self isOperation:[stack objectAtIndex:index]]){
                //replaceObjectAtIndex: index withObject: variablevalue
                [stack replaceObjectAtIndex:index withObject:[variableValues objectForKey:[stack objectAtIndex:index]]];
            }
        }
    }
    //then runProgram
    return ([self popItemOffStack:stack]);
}
@end