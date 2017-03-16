//
//  UIWebView+Https.m
//  LisztUIWebView+Https
//
//  Created by Liszt on 2017/1/19.
//  Copyright © 2017年 Liszt. All rights reserved.
//

#import "UIWebView+Https.h"
static char UrlConnection;
static char Authenticated;
static char Request;
static char HttpsLoadFinish;
static char HttpsBeginLoad;

@interface UIWebView (Https)
/*请求池*/
@property (nonatomic, strong) NSURLConnection *urlConnection;
/*是否授权*/
@property (nonatomic, assign) BOOL authenticated;
/*请求*/
@property (nonatomic, strong) NSMutableURLRequest *tp_request;
@end

@implementation UIWebView (Https)
- (void)tp_configHttps:(NSString *)https{
    if(!self.delegate)
    {
        self.delegate = self;
    }
    if(!self.tp_request){
        self.tp_request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:https]];
    }
    self.tp_request.URL = [NSURL URLWithString:https];
    
    if(https){
        [self loadRequest:self.tp_request];
    }
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(self.tp_httpsBeginLoadingBlock){
        self.tp_httpsBeginLoadingBlock();
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(self.tp_httpsLoadingFinishBlock){
        self.tp_httpsLoadingFinishBlock(TPHttpsLoadFaild);
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(self.tp_httpsLoadingFinishBlock){
        self.tp_httpsLoadingFinishBlock(TPHttpsLoadSuccess);
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if (!self.authenticated) {
        self.authenticated = NO;
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [self.urlConnection start];
        return NO;
    }
    return YES;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0)
    {
        self.authenticated = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // remake a webview call now that authentication has passed ok.
    self.authenticated = YES;
    [self loadRequest:self.tp_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [self.urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

#pragma mark - get and set
- (void)setUrlConnection:(NSURLConnection *)urlConnection{
    objc_setAssociatedObject(self, &UrlConnection, urlConnection, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSURLConnection *)urlConnection{
    return objc_getAssociatedObject(self, &UrlConnection);
}
- (void)setAuthenticated:(BOOL)authenticated{
    objc_setAssociatedObject(self, &Authenticated, @(authenticated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (BOOL)authenticated{
    return objc_getAssociatedObject(self , &Authenticated);
}
- (void)setTp_request:(NSMutableURLRequest *)tp_request{
    objc_setAssociatedObject(self, &Request, tp_request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableURLRequest *)tp_request{
    return objc_getAssociatedObject(self, &Request);
}
- (void)setTp_httpsLoadingFinishBlock:(void (^)(TPHttpsLoadingState))tp_httpsLoadingFinishBlock{
    objc_setAssociatedObject(self, &HttpsLoadFinish, tp_httpsLoadingFinishBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(TPHttpsLoadingState))tp_httpsLoadingFinishBlock{
    return objc_getAssociatedObject(self, &HttpsLoadFinish);
}
- (void)setTp_httpsBeginLoadingBlock:(void (^)(void))tp_httpsBeginLoadingBlock{
    objc_setAssociatedObject(self, &HttpsBeginLoad, tp_httpsBeginLoadingBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(void))tp_httpsBeginLoadingBlock{
    return objc_getAssociatedObject(self, &HttpsBeginLoad);
}
@end
