//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Andrew Rosenberg on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
- (void)pushOperand:(double)operand;
- (void)clearOperands;
- (double)performOperation:(NSString * ) operation;

@property (readonly) id program; 
+ (double) runProgram:(id)program;
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *) descriptionOfProgram:(id)program;
@end
