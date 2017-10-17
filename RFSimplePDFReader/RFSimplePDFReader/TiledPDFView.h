//    File: TiledPDFView.h
//Abstract: This view is backed by a CATiledLayer into which the PDF page is rendered into.
// Version: 1.0
//Copyright (C) 2010 Apple Inc. All Rights Reserved.
//

#import <UIKit/UIKit.h>


@interface TiledPDFView : UIView {
	CGPDFPageRef pdfPage;
	CGFloat pdfScale;
}

- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale;

- (void)setPage:(CGPDFPageRef)newPage;

@end
