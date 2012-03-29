//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Andrew Rosenberg on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

//instance methods
- (void)pushOperand:(double)operand;
- (void)clearOperands;
- (double)performOperation:(NSString * ) operation;
@property (readonly) id program; 

//class methods
+ (double) runProgram:(id)program;

+ (double) runProgram:(id)program 
        usingVariableValues:(NSDictionary *)variableValues;

+ (NSSet *)variablesUsedInProgram:(id)program;

+ (NSString *) descriptionOfProgram:(id)program;
@end