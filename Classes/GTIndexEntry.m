//
//  GTIndexEntry.m
//  ObjectiveGitFramework
//
//  Created by Timothy Clem on 2/28/11.
//  Copyright 2011 GitHub Inc. All rights reserved.
//

#import "GTIndexEntry.h"
#import "NSString+Git.h"
#import "NSError+Git.h"

@implementation GTIndexEntry

@synthesize entry;
@synthesize path;
@synthesize sha;
@synthesize mTime;
@synthesize cTime;
@synthesize fileSize;
@synthesize dev;
@synthesize ino;
@synthesize mode;
@synthesize uid;
@synthesize gid;
@synthesize flags;
@synthesize stage;
@synthesize isValid;


+ (id)indexEntryWithEntry:(git_index_entry *)theEntry {
	
	return [[[GTIndexEntry alloc] initWithEntry:theEntry] autorelease];
}

- (id)initWithEntry:(git_index_entry *)theEntry {
	
	if(self = [super init]) {
		self.entry = theEntry;
	}
	return self;
}

- (id)init {
	
	if(self = [super init]) {
		self.entry = malloc(sizeof(git_index_entry));
		memset(self.entry, 0x0, sizeof(git_index_entry));
	}
	return self;
}

- (NSString *)path {
	
	if(self.entry->path == NULL)return nil;
	return [NSString stringForUTF8String:self.entry->path];
}
- (void)setPath:(NSString *)thePath {
	
	if(self.entry->path != NULL)
		free(self.entry->path);
	
	entry->path = (char *)[NSString utf8StringForString:thePath];
}

- (NSString *)sha {
	
	char hex[41];
	git_oid_fmt(hex, &entry->oid);
	hex[40] = 0;
	return [NSString stringForUTF8String:hex];
}
- (void)setSha:(NSString *)theSha{

	git_oid_mkstr(&entry->oid, [NSString utf8StringForString:theSha]);
//	if(gitError != GIT_SUCCESS){
//		if(error != NULL)
//			*error = [NSError gitErrorForMkStr:gitError];
//	}
}

- (NSDate *)mTime {
	
	double time = self.entry->mtime.seconds + (self.entry->mtime.nanoseconds/1000);
	return [NSDate dateWithTimeIntervalSince1970:time];
}
- (void)setMTime:(NSDate *)time {
	
	NSTimeInterval t = [time timeIntervalSince1970];
	self.entry->mtime.seconds = (int)t;
	self.entry->mtime.nanoseconds = 1000 * (t - (int)t);
}

- (NSDate *)cTime {
	
	double time = self.entry->ctime.seconds + (self.entry->ctime.nanoseconds/1000);
	return [NSDate dateWithTimeIntervalSince1970:time];
}
- (void)setCTime:(NSDate *)time {
	
	NSTimeInterval t = [time timeIntervalSince1970];
	self.entry->ctime.seconds = (int)t;
	self.entry->ctime.nanoseconds = 1000 * (t - (int)t);
}

- (long long)fileSize {	return self.entry->file_size; }
- (void)setFileSize:(long long) size { self.entry->file_size = size; }

- (NSUInteger)dev {	return self.entry->dev; }
- (void)setDev:(NSUInteger)theDev {	self.entry->dev = theDev; }

- (NSUInteger)ino {	return self.entry->ino; }
- (void)setIno:(NSUInteger)theIno {	self.entry->ino = theIno; }

- (NSUInteger)mode { return self.entry->mode; }
- (void)setMode:(NSUInteger)theMode {	self.entry->mode = theMode; }

- (NSUInteger)uid {	return self.entry->uid; }
- (void)setUid:(NSUInteger)theUid {	self.entry->uid = theUid; }

- (NSUInteger)gid { return self.entry->gid; }
- (void)setGid:(NSUInteger)theGid {	self.entry->gid = theGid; }

- (NSUInteger)flags { 
	
	return (self.entry->flags & 0xFFFF) | (self.entry->flags_extended << 16); 
}
- (void)setFlags:(NSUInteger)theFlags {	
	
	self.entry->flags = (unsigned short)(theFlags & 0xFFFF);
	self.entry->flags_extended = (unsigned short)((theFlags >> 16) & 0xFFFF);
}

- (BOOL)isValid {
	return (self.flags & GIT_IDXENTRY_VALID) != 0;
}

- (NSUInteger)stage {
	
	return (self.entry->flags & GIT_IDXENTRY_STAGEMASK) >> GIT_IDXENTRY_STAGESHIFT;
}
- (void)setStage:(NSUInteger)theStage {
	
	if(theStage < 0 || theStage > 3){
		return;
//		if(error != NULL)
//			*error = [NSError gitErrorForIndexStageValue];
	}
	
	self.entry->flags &= ~GIT_IDXENTRY_STAGEMASK;
	self.entry->flags |= (theStage << GIT_IDXENTRY_STAGESHIFT);
}

@end