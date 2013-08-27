//
//  SUWebParser.h
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUWebParser : NSObject

+(void)loadCommitteesListWithResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror;
//categories ,groups

+(void)loadCommittee:(NSString*)committeeString withResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror;
//title, content

+(void)loadItinerarywithResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror;
//days, times

+(void)loadMapWithResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror;
//content


@end
