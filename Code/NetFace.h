
//
//  NetFace.h
//  果壳精选
//
//  Created by 韩金 on 16/7/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#ifndef NetFace_h
#define NetFace_h

#define kScrolVUrl @"http://www.guokr.com/apis/flowingboard/item/handpick_carousel.json"
#define kToday @"http://www.guokr.com/apis/handpick/v2/article.json?limit=20&retrieve_type=by_offset&ad=1&offset=%ld" //!< 参数 默认为0
#define kOther @"http://www.guokr.com/apis/handpick/v2/article.json?limit=20&retrieve_type=by_offset&ad=1&offset=%ld&category=%@" //!< 后面跟类型
#define kRecommend @"http://www.guokr.com/apis/handpick/v2/article.json?limit=3&retrieve_type=by_recommend"
#define kDetail @"http://jingxuan.guokr.com/pick/v2/%ld/"
#define kFirstPage @"http://www.guokr.com/apis/flowingboard/item/handpick_open_screen_page.json" //!< 启动页
#define kScrolVDetail @"http://www.guokr.com/apis/handpick/v2/article.json?pick_id=%ld&pick_id=%ld&pick_id=%ld&pick_id=%ld"

#define kHotWord @"http://www.guokr.com/apis/flowingboard/flowingboard.json?name=handpick_search_keywords"
#define kSearch @"http://www.guokr.com/apis/handpick/search.json?offset=%ld&limit=20&wd=%@"

#endif /* NetFace_h */
