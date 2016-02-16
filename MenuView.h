//
//  MenuView.h
//  RuiLift
//
//  Created by lay on 15/12/1.
//  Copyright © 2015年 lay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dismissCompletion)(void);



typedef enum : NSUInteger {
    kLeftTriangle,
    kRightTriangle,
} TriangleDirection;

typedef enum : NSUInteger {
    kTableView,
    kCollectionView,
} MenuType;

@protocol MenuViewDelegate <NSObject>

- (void)MenuItemDidSelected:(id)scrollerView indexPath:(NSIndexPath*)indexPath;

@end


@interface MenuView : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) id<MenuViewDelegate>delegate;

/**
 *  初始化方法
 *
 *  @param titleArray 每个title
 *  @param imageArray 每个title对应的imageName
 *  @param origin     菜单的起始点
 *  @param rowWidth   item的宽度
 *  @param rowHeight  item的高度
 *  @param direct     TriangleDirection三角位置kLeftTriangle左，kRightTriangle右
 *  @param type       菜单类型
 */
- (id)initWithTitleArray:(NSArray*)titleArray imageArray:(NSArray*)imageArray origin:(CGPoint)origin rowWidth:(CGFloat)width rowHeight:(CGFloat)rowHeight Direct:(TriangleDirection)triDirect MenuType:(MenuType)type;

///**
// *  隐藏
// *
// *  @param completion 隐藏后block
// */
//- (void)dismissMenuView:(dismissCompletion)completion;

@end

/**
 *  自定义CollectionViewCell
 */


@interface MenuCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) UIImage * image;
@property (nonatomic,strong) void (^itemSellectBlock)();
@end
