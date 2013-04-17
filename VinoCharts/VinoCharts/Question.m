//
//  Question.m
//  VinoCharts
//
//  Created by Ang Civics on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Question.h"

@implementation Question

-(id)init{
    self = [super init];
    if(self){
        self.options = [[NSArray alloc] init];
    }
    return self;
}

-(NSArray*)getInfo {
    return [[NSArray alloc]initWithObjects:self.title,self.type,self.options, nil];
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.type forKey:kType];
    [encoder encodeObject:self.title forKey:kTitle];
    [encoder encodeObject:self.options forKey:kOption];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self.title = [decoder decodeObjectForKey:kTitle];
    self.type = [decoder decodeObjectForKey:kType];
    self.options = [decoder decodeObjectForKey:kOption];
    return  self;
}
@end
