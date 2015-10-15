//
//  ReadTweetsData.swift
//  Spark Insights
//
//  Created by Barbara Gomes on 5/28/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation
import UIKit

class ReadTweetsData
{
    private class func getJSONFilePath() -> String?
    {
        let filePath = NSBundle.mainBundle().pathForResource("Tweets", ofType:"json")
        return filePath
    }
    
    // Read JSON file and get its content as NSDictionary if it is possible
    private class func getJSONSwift() -> NSData?
    {
        if let filePath = getJSONFilePath()
        {
            var readError:NSError?
            do {
                let data = try NSData(contentsOfFile:filePath,
                    options: NSDataReadingOptions.DataReadingUncached)
                return data
            } catch let error as NSError {
                readError = error
            }
            
        }
        return nil
    }
    
    class func readJSON() -> JSON?
    {
        if let fileData = ReadTweetsData.getJSONSwift()
        {
            var parseError: NSError?
            do {
                let JSONObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(fileData, options: NSJSONReadingOptions.AllowFragments)
                let jsonTweets = JSON(JSONObject!)
                return jsonTweets["tweets"]
            } catch let error as NSError {
                parseError = error
            }
        }
        
        return nil
    }
    
    private class func getTweetsObjects(tweets: JSON) ->  Array<TwitterTweet>?
    {
        var tweetsObj = Array<TwitterTweet>()
        for (var i = 0; i < tweets.array?.count; i++)
        {
            let user_name = tweets[i]["user"]["name"].stringValue
            let user_screen_name = tweets[i]["user"]["screen_name"].stringValue
            let user_profile_image = (tweets[i]["user"]["profile_image_url"].stringValue).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let dateTime = tweets[i]["created_at"].stringValue
            let retweet_count = tweets[i]["retweet_count"].stringValue
            let favorite_count = tweets[i]["favorite_count"].stringValue
            let text = tweets[i]["text"].stringValue
            
            let tweet = TwitterTweet()
            tweet.setUserName(user_name)
            tweet.setUserhandle(user_screen_name, addAt: true)
            if (favorite_count == "")
            {
                tweet.setFavorites(0)
            }
            else
            {
                tweet.setFavorites(Int(favorite_count)!)
            }
            if (retweet_count == "")
            {
                tweet.setRetweets(0)
            }
            else
            {
                tweet.setRetweets(Int(retweet_count)!)
            }
            tweet.setTweetText(text)
            tweet.setDateTime(nil, stringFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z", stringDate: dateTime)
            if let urlImage = NSURL(string: user_profile_image)
            {
                if let dataImage = NSData(contentsOfURL: urlImage){
                    tweet.setUserProfileImage(UIImage(data: dataImage)!)
                    
                }
            }
            tweetsObj.append(tweet)
        }
        return tweetsObj
    }

}