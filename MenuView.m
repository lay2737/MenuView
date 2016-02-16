//
//  MenuView.m
//  RuiLift
//
//  Created by lay on 15/12/1.
//  Copyright © 2015年 lay. All rights reserved.
//

#import "MenuView.h"

#define TopToView 10.0f
#define LeftToView 10.0f
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height

@implementation MenuView
{
    NSArray *_titleArray;
    NSArray *_imageArray;
    
    CGPoint _origin;
    CGFloat _width;
    CGFloat _height;
    TriangleDirection _direct;
    MenuType _type;
    
    UITableView *_tableView;
    UICollectionView * _collectionView;
    
}

- (id)initWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray origin:(CGPoint)origin rowWidth:(CGFloat)rowWidth rowHeight:(CGFloat)rowHeight Direct:(TriangleDirection)triDirect MenuType:(MenuType)type
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        _titleArray = [titleArray copy];
        _imageArray = [imageArray copy];
        _origin = origin;
        _width = rowWidth;
        _height = rowHeight;
        _direct = triDirect;
        _type = type;
        
        
        
        if (type == kTableView) {
            
            _height = rowHeight < 44 ? 44 : rowHeight;
            
            CGFloat o_x = _direct == kLeftTriangle?LeftToView + origin.x:origin.x-LeftToView-_width;
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(o_x, TopToView + origin.y, _width, titleArray.count*_height) style:UITableViewStylePlain];
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
            _tableView.layer.cornerRadius = 5;
            _tableView.bounces = NO;
            _tableView.showsHorizontalScrollIndicator = NO;
            _tableView.showsVerticalScrollIndicator = NO;
            [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ide"];
            
            //设置cell举例table的距离
            // _tableView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5);
            
            //分割线位置
            _tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
            
            [self addSubview:_tableView];
        }else if(type == kCollectionView){
            
            if (titleArray.count*rowWidth > kScreenWidth-2*LeftToView) {
                _width = kScreenWidth-2*LeftToView;
                //rowWidth = (kScreenWidth-2*LeftToView)/titleArray.count;
            }else{
                _width = titleArray.count*rowWidth;
                
            }
            CGFloat o_x = _direct == kLeftTriangle?LeftToView + origin.x:origin.x-LeftToView-_width;
            
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.itemSize = CGSizeMake(rowWidth, _height);//item的大小
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(o_x, TopToView + origin.y, _width, _height) collectionViewLayout:layout];
            
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
            _collectionView.layer.cornerRadius = 5;
            _collectionView.bounces = NO;
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.showsVerticalScrollIndicator = NO;
            [_collectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:@"clt"];
            
            [self addSubview:_collectionView];
        }
        
    }
    return self;
}


- (id)initCollectionViewWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray origin:(CGPoint)origin width:(CGFloat)width rowHeight:(CGFloat)rowHeight Direct:(TriangleDirection)triDirect
{
    if (self = [super init]) {
        _titleArray = [titleArray copy];
        _imageArray = [imageArray copy];
        _origin = origin;
        //_width = width;
        _direct = triDirect;
        
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ide"];
    cell.backgroundColor = [UIColor clearColor];
    
    //设置cell的选中状态
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
    
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [cell.textLabel sizeToFit];
    
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(MenuItemDidSelected:indexPath:)]) {
        [self.delegate MenuItemDidSelected:tableView indexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissMenuView:nil];
}

- (void)dismissMenuView:(dismissCompletion)completion
{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        UIView * view = _type == kTableView?_tableView:_collectionView;
        weakSelf.alpha = 0;
        if (_direct == kLeftTriangle) {
            view.frame = CGRectMake(LeftToView + _origin.x, TopToView + _origin.y, 0, 0);
        }
        else
        {
            view.frame = CGRectMake(_origin.x-LeftToView, TopToView + _origin.y, 0, 0);
        }
        view.alpha = 0;
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

- (void)drawRect:(CGRect)rect
{
    //拿到当前视图准备好的画板
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    if (_direct == kLeftTriangle)
    {
        CGContextMoveToPoint(context,
                             (_origin.x + LeftToView) + 10, (_origin.y + TopToView) - 5);//设置起点
        
        CGContextAddLineToPoint(context,
                                (_origin.x + LeftToView) + 5, (_origin.y + TopToView));
        
        CGContextAddLineToPoint(context,
                                (_origin.x + LeftToView) + 15, (_origin.y + TopToView));
    }
    else
    {
        CGContextMoveToPoint(context,
                             (_origin.x- LeftToView-10) + 0, (_origin.y + TopToView) - 5);//设置起点
        
        CGContextAddLineToPoint(context,
                                (_origin.x- LeftToView-10) - 5, (_origin.y + TopToView));
        
        CGContextAddLineToPoint(context,
                                (_origin.x- LeftToView-10) + 5, (_origin.y + TopToView));
    }
    
    //CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    //    [self.tableView.backgroundColor setFill]; //设置填充色
    //
    //    [self.tableView.backgroundColor setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissMenuView:^{
        
    }];
}

#pragma mark - collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titleArray.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"clt" forIndexPath:indexPath];
    [cell sizeToFit];
    cell.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.title = _titleArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:(120 / 255.0) green:((50 * indexPath.row)/255.0) blue:((10 * indexPath.row)/255.0) alpha:1.0f];
    cell.itemSellectBlock = ^(){
        if ([self.delegate respondsToSelector:@selector(MenuItemDidSelected:indexPath:)]) {
            [self.delegate MenuItemDidSelected:collectionView indexPath:indexPath];
        }
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self dismissMenuView:nil];
    };
    return cell;
}

@end


/**
 *
 */

@implementation MenuCollectionViewCell
{
    UIButton * button;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self action:@selector(sellectItem) forControlEvents:UIControlEventTouchUpInside];
        // button.backgroundColor = [UIColor redColor];
        [self addSubview:button];
    }
    return self;
    
}

-(void)setTitle:(NSString *)title{
    [button setTitle:title forState:UIControlStateNormal];
}
-(void)setImage:(UIImage *)image{
    [button setImage:image forState:UIControlStateNormal];
}
-(void)sellectItem{
    self.itemSellectBlock();
}
-(NSString *)title{
    return button.titleLabel.text;
}

@end
