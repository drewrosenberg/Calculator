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

//program is alwas guaranteed to be a property list
@property (readonly) id program;

//class methods
+ (id) runProgram:(id)program;

+ (id) runProgram:(id)program
  usingVariableValues:(NSDictionary *)variableValues;

+ (NSSet *)variablesUsedInProgram:(id)program;

+ (NSString *) descriptionOfProgram:(id)program;
@end