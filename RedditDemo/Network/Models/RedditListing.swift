//
//  RedditListing.swift
//  RedditDemo
//
//  Created by Muhammad Usman on 22/10/2021.
//

import Foundation

struct RedditData:Codable{
    var after:String? = nil
    var dist:Int? = nil
    var modhash:String? = nil
    var geo_filter:String? = nil
    var before:String? = nil
    var children:[ListingsItems]? = nil
}
struct ListingsItems:Codable{
    var kind:String? = nil
    var data:ItemList? = nil
}
struct ItemList:Codable{
    var approved_at_utc : String? = nil
    var subreddit : String? = nil
    var selftext : String? = nil
    var author_fullname : String? = nil
    var saved : Bool? = nil
    var mod_reason_title : String? = nil
    var gilded : Int? = nil
    var clicked : Bool? = nil
    
    var score : Int? = nil
    var title : String? = nil
    var thumbnail : String? = nil
    var thumbnail_height : Int? = nil
    var thumbnail_width : Int? = nil
    var num_comments : Int? = nil
    // NOt Being Used
////    var link_flair_richtext : [String]? = nil
//    var subreddit_name_prefixed : String? = nil
//    var hidden : Bool? = nil
//    var pwls : Int? = nil
//    var link_flair_css_class : String? = nil
//    var downs : Int? = nil
//    var top_awarded_type : String? = nil
//    var hide_score : Bool? = nil
//    var name : String? = nil
//    var quarantine : Bool? = nil
//    var link_flair_text_color : String? = nil
//    var upvote_ratio : Double? = nil
//    var author_flair_background_color : String? = nil
//    var subreddit_type : String? = nil
//    var ups : Int? = nil
//    var total_awards_received : Int? = nil
////    var media_embed : Media_embed? = nil
//    var author_flair_template_id : String? = nil
//    var is_original_content : Bool? = nil
//    var user_reports : [String]? = nil
////    var secure_media : String? = nil
//    var is_reddit_media_domain : Bool? = nil
//    var is_meta : Bool? = nil
//    var category : String? = nil
////    var secure_media_embed : Secure_media_embed? = nil
//    var link_flair_text : String? = nil
//    var can_mod_post : Bool? = nil
//    var approved_by : String? = nil
//    var is_created_from_ads_ui : Bool? = nil
//    var author_premium : Bool? = nil
//    var edited : Bool? = nil
//    var author_flair_css_class : String? = nil
////    var author_flair_richtext : [String]? = nil
//    var gildings : Glidings? = nil
//    var post_hint : String? = nil
//    var content_categories : String? = nil
//    var is_self : Bool? = nil
//    var mod_note : String? = nil
//    var created : Double? = nil
//    var link_flair_type : String? = nil
//    var wls : Int? = nil
//    var removed_by_category : String? = nil
//    var banned_by : String? = nil
//    var author_flair_type : String? = nil
//    var domain : String? = nil
//    var allow_live_comments : Bool? = nil
//    var selftext_html : String? = nil
//    var likes : String? = nil
//    var suggested_sort : String? = nil
//    var banned_at_utc : String? = nil
//    var url_overridden_by_dest : String? = nil
//    var view_count : String? = nil
//    var archived : Bool? = nil
//    var no_follow : Bool? = nil
//    var is_crosspostable : Bool? = nil
//    var pinned : Bool? = nil
//    var over_18 : Bool? = nil
//    var preview : PreviewsItem? = nil
////    var all_awardings : [AllRewardItem]? = nil
////    var awarders : [String]? = nil
//    var media_only : Bool? = nil
//    var can_gild : Bool? = nil
//    var spoiler : Bool? = nil
//    var locked : Bool? = nil
//    var author_flair_text : String? = nil
//    var treatment_tags : [String]? = nil
//    var visited : Bool? = nil
//    var removed_by : String? = nil
//    var num_reports : String? = nil
//    var distinguished : String? = nil
//    var subreddit_id : String? = nil
//    var author_is_blocked : Bool? = nil
//    var mod_reason_by : String? = nil
//    var removal_reason : String? = nil
//    var link_flair_background_color : String? = nil
//    var id : String? = nil
//    var is_robot_indexable : Bool? = nil
//    var report_reasons : String? = nil
//    var author : String? = nil
//    var discussion_type : String? = nil
//    var send_replies : Bool? = nil
//    var whitelist_status : String? = nil
//    var contest_mode : Bool? = nil
//    var mod_reports : [String]? = nil
//    var author_patreon_flair : Bool? = nil
//    var author_flair_text_color : String? = nil
//    var permalink : String? = nil
//    var parent_whitelist_status : String? = nil
//    var stickied : Bool? = nil
//    var url : String? = nil
//    var subreddit_subscribers : Int? = nil
//    var created_utc : Double? = nil
//    var num_crossposts : Int? = nil
////    var media : String? = nil
//    var is_video : Bool? = nil
}

struct Glidings:Codable{
    var gid_1 : Int? = nil
}
struct PreviewsItem:Codable{
    var images : [ImagesArray]? = nil
    var  enabled : Bool? = nil
}

struct ImagesArray:Codable{
    var source : AllRewardItem? = nil
    var resolutions : [AllRewardItem]? = nil
//    var variants : Variants? = nil
    var id : String? = nil
}

struct AllRewardItem:Codable{
    var giver_coin_reward : Int? = nil
    var subreddit_id : String? = nil
    var is_new : Bool? = nil
    var days_of_drip_extension : Int? = nil
    var coin_price : Int? = nil
    var id : String? = nil
    var penny_donate : Int? = nil
    var award_sub_type : String? = nil
    var coin_reward : Int? = nil
    var icon_url : String? = nil
    var days_of_premium : Int? = nil
    var tiers_by_required_awardings : String? = nil
    var resized_icons : [ResizeItem]? = nil
    var icon_width : Int? = nil
    var static_icon_width : Int? = nil
    var start_date : String? = nil
    var is_enabled : Bool? = nil
    var awardings_required_to_grant_benefits : String? = nil
    var description : String? = nil
    var end_date : String? = nil
    var subreddit_coin_reward : Int? = nil
    var count : Int? = nil
    var static_icon_height : Int? = nil
    var name : String? = nil
    var resized_static_icons : [ResizeItem]? = nil
    var icon_format : String? = nil
    var icon_height : Int? = nil
    var penny_price : String? = nil
    var award_type : String? = nil
    var static_icon_url : String? = nil

}

struct ResizeItem:Codable{
    var url : String? = nil
    var width : Int? = nil
    var height : Int? = nil
}
