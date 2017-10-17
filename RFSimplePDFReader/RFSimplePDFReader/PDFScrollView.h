//    File: PDFScrollView.h
//Copyright (C) 2010 Apple Inc. All Rights Reserved.
//

#import <UIKit/UIKit.h>

@class TiledPDFView;

@interface PDFScrollView : UIScrollView <UIScrollViewDelegate> {
	// The TiledPDFView that is currently front most
	TiledPDFView *pdfView;
	// The old TiledPDFView that we draw on top of when the zooming stops
	TiledPDFView *oldPDFView;
	

	// current pdf zoom scale
	CGFloat pdfScale;
	
	CGPDFPageRef page;
	CGPDFDocumentRef pdf;
    
    UIToolbar *_toolbar;
    
//    NSInteger _pageNumber;
//    NSInteger _pageCount;

}
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger pageCount;
- (instancetype)initWithFrame:(CGRect)frame resource:(NSString *)resource;
-(void)clickPre;
-(void)clickNext;

@end
