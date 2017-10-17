//    File: TiledPDFView.m
//Abstract: This view is backed by a CATiledLayer into which the PDF page is rendered into.
// Version: 1.0
//
//Copyright (C) 2010 Apple Inc. All Rights Reserved.
//


#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>


@implementation TiledPDFView


- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale
{
    if ((self = [super initWithFrame:frame])) {
        
        pdfScale = scale;
                
    }
    return self;
}




// Set the CGPDFPageRef for the view.
- (void)setPage:(CGPDFPageRef)newPage
{
    CGPDFPageRelease(pdfPage);
    pdfPage = CGPDFPageRetain(newPage);
}


-(void)drawRect:(CGRect)r
{
    // UIView uses the existence of -drawRect: to determine if it should allow its CALayer
    // to be invalidated, which would then lead to the layer creating a backing store and
    // -drawLayer:inContext: being called.
    // By implementing an empty -drawRect: method, we allow UIKit to continue to implement
    // this logic, while doing our real drawing work inside of -drawLayer:inContext:
	// First fill the background with white.
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
//    NSLog(@"[%s]",__FUNCTION__);    

	// First fill the background with white.
    CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1.0);
    CGContextFillRect(ctx,self.bounds);
	
	// Flip the context so that the PDF page is rendered
	// right side up.
	CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
    //	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextScaleCTM(ctx, pdfScale,-pdfScale);	
	
	CGContextSaveGState(ctx);
	// Scale the context so that the PDF page is rendered 
	// at the correct size for the zoom level.
    //	CGContextScaleCTM(context, myScale,myScale);	
    
	CGContextDrawPDFPage(ctx, pdfPage);
    
	CGContextRestoreGState(ctx);
}

// Clean up.
- (void)dealloc {
	CGPDFPageRelease(pdfPage);
	
}


@end
