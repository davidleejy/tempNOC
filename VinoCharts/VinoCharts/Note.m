//
//  Note.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define DBG_NOTE_CLASS 0

#import "Note.h"
#import "Constants.h"
#import "ViewHelper.h"
#import "DebugHelper.h"
#import "NoteM.h"

@interface Note ()


@end

@implementation Note

-(void)updatePos {
    //Updating
    _view.transform = _body.affineTransform;
    
    // Correcting velocity
    if (cpvlength(_body.vel)>0 && cpvlength(_body.vel)<5) {
        _body.vel = cpv(0,0);
    }
    else {
        _body.vel = cpvmult(_body.vel,0.5); //dampening velocity
    }
    
    // dampening angle
    _body.angVel *=0.5;
    // Correcting angle
    
    if (_body.angle >0.1 && fabs(_body.angVel)<0.3) {
        _body.angVel = -0.4;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (_body.angle <-0.1 && fabs(_body.angVel)<0.3) {
        _body.angVel = 0.4;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (_body.angle >0.001 && fabs(_body.angVel)<0.4) {
        _body.angVel = -0.1;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (_body.angle <-0.001 && fabs(_body.angVel)<0.4){
        _body.angVel = 0.1;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (fabs(_body.angle) <= 0.001 && fabs(_body.angVel)<0.3){
        _body.angVel *= 0.5;
        if (fabs(_body.angVel)<0.1)
            _body.angVel = 0.0;
    }
    
}

-(id)initWithText:(NSString*)t{
    
    if(self = [super init]){
        
        _view = [[NoteView alloc]initWithFrame:CGRectMake(0,0, NOTE_DEFAULT_WIDTH ,NOTE_DEFAULT_HEIGHT) AndText:t];
        _view.bounds = CGRectMake(0, 0, NOTE_DEFAULT_WIDTH, NOTE_DEFAULT_HEIGHT);
        
        [_view setFont:[UIFont fontWithName:fHELVETICA_NEUE size:FONT_DEFAULT_SIZE]];
        [_view setMaterialWithPictureFileName:NOTE_MATERIAL_BLUE_PAPER];
        [_view setUserInteractionEnabled:YES];
        [_view setDelegate:self];
        
        
        //Set states
        _beingPanned = NO;
        
        
		// Set up Chipmunk objects.
		cpFloat mass = 50;
		
		// The moment of inertia is like the rotational mass of an object.
		// Chipmunk provides a number of helper functions to help you estimate the moment of inertia.
		cpFloat moment = cpMomentForBox(mass, NOTE_DEFAULT_WIDTH, NOTE_DEFAULT_HEIGHT);
        
		
		// A rigid body is the basic skeleton you attach joints and collision shapes too.
		// Rigid bodies hold the physical properties of an object such as the postion, rotation, and mass of an object.
		// You attach collision shapes to rigid bodies to define their shape and allow them to collide with other objects,
		// and you can attach joints between rigid bodies to connect them together.
		_body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
		_body.pos = cpv(0, 0); //TODO set to 0,0 if possible.
        

        
		// Chipmunk supports a number of collision shape types. See the documentation for more information.
		// Because we are storing this into a local variable instead of an instance variable, we can use the autorelease constructor.
		// We'll let the chipmunkObjects NSSet hold onto the reference for us.
		ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:_body width:NOTE_DEFAULT_WIDTH height:NOTE_DEFAULT_HEIGHT];
		
		// The elasticity of a shape controls how bouncy it is.
		shape.elasticity = 1.0f;
		// The friction propertry should be self explanatory. Friction values go from 0 and up- they can be higher than 1f.
		shape.friction = 0.2f;
		
		// Set the collision type to a unique value (the class object works well)
		// This type is used as a key later when setting up callbacks.
		shape.collisionType = [Note class];
		
		// Set data to point back to this object.
		// That way you can get a reference to this object from the shape when you are in a callback.
		shape.data = self;
		
		// Keep in mind that you can attach multiple collision shapes to each rigid body, and that each shape can have
		// unique properties. You can make the player's head have a different collision type for instance. This is useful
        // for brain damage.
		
		// Now we just need to initialize the instance variable for the chipmunkObjects property.
		// ChipmunkObjectFlatten() is an easy way to build this set. You can pass any object to it that
		// implements the ChipmunkObject protocol and not just primitive types like bodies and shapes.
		
		// Notice that we didn't even have to keep a reference to 'shape'. It was created using the autorelease convenience function.
		// This means that the chipmunkObjects NSSet will manage the memory for us. No need to worry about forgetting to call
		// release later when you're using Objective-Chipmunk!
		
		// Note the nil terminator at the end! (this is how it knows you are done listing objects)
		_chipmunkObjects = [[NSArray alloc] initWithObjects:_body, shape, nil];
	}
	
	return self;
    
}


-(void)setTextColor:(UIColor*)myColor{
    [_view setTextColor:myColor];
}

//temporary TODO fix
-(void)setTextColorGZColorString:(NSString*)GZColorHexValue{
    [_view setTextColorGZColorString:GZColorHexValue];
}

-(UIColor*)getTextColor{
    return [_view getTextColor];
}

//temporary TODO fix
-(NSString*)getTextColorGZColorString{
    return [_view getTextColorGZColorString];
}

-(void)setBodyTopLeftPoint:(CGPoint)myFrameOrigin{
    //Set body ONLY!
    _body.pos = cpv(myFrameOrigin.x+_view.bounds.size.width/2.0,
                    myFrameOrigin.y+_view.bounds.size.height/2.0);
    //DON'T SET THE VIEW! THE UPDATEPOS WILL UPDATE THE VIEW CORRECTLY IF THE VIEW AND BODY MIRROR ONE ANOTHER!
}

-(CGPoint)getBodyTopLeftPoint{
    return CGPointMake(self.body.pos.x-_view.bounds.size.width/2.0,
                       self.body.pos.y-_view.bounds.size.height/2.0);
}

-(void)setFont:(UIFont*)myFont{
    [_view setFont:myFont];
}

-(UIFont*)getFont{
    return [_view getFont];
}


-(void)setMaterialWithPictureFileName:(NSString*)myMaterial{
    [_view setMaterialWithPictureFileName:myMaterial];
}

-(void)setMaterial:(UIColor*)myMaterial{
    [_view setMaterial:myMaterial];
}

-(UIColor*)getMaterial{
    return [_view getMaterial];
}

-(NSString*)getMaterialFileName{
    return [_view getMaterialFileName];
}

-(void)setContent:(NSString*)content{
    [_view setText:content];
}

-(NSString*)content{
    return [_view getText];
}

-(NoteM*)generateModel{
    NoteM* model = [[NoteM alloc]init];
    model.content = [self content];
    model.x = [self getBodyTopLeftPoint].x;
    model.y = [self getBodyTopLeftPoint].y;
    model.fontColor = [self getTextColorGZColorString];
    model.material = [self getMaterialFileName];
    model.font = [self getFont];
    return model;
}

-(void)loadWithModel:(NoteM*)myModel{
    [self setContent:myModel.content];
    [self setBodyTopLeftPoint:CGPointMake(myModel.x, myModel.y)];
    [self setTextColorGZColorString:myModel.fontColor];
    [self setMaterialWithPictureFileName:myModel.material];
    [self setFont:myModel.font];
}

-(NSString*)vitalsToString{
    return [NSString stringWithFormat:@"Content: %@ \nFrame Origin x %.2f y %.2f Font Color:%@ Material:%@ Font:%@",
            [self content],[self getBodyTopLeftPoint].x,[self getBodyTopLeftPoint].y,[self getTextColor],[self getMaterial],[self getFont]];
}

@end
