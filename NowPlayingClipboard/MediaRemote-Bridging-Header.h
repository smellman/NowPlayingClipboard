#ifndef MediaRemote_Bridging_Header_h
#define MediaRemote_Bridging_Header_h

#import <Foundation/Foundation.h>

extern NSString *kMRMediaRemoteNowPlayingInfoTitle;
extern NSString *kMRMediaRemoteNowPlayingInfoArtist;
extern NSString *kMRMediaRemoteNowPlayingInfoAlbum;

typedef void (^MRMediaRemoteGetNowPlayingInfoCallback)(NSDictionary *info);
void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t queue, MRMediaRemoteGetNowPlayingInfoCallback block);
void MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_queue_t queue);

#endif
