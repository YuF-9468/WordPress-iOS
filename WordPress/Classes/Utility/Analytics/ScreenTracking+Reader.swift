import Foundation

/// Identifies a screen in the Reader module.
enum ReaderScreen: String, ScreenIdentifier {
    case sidebar = "reader_sidebar"
    case discover = "reader_discover"
    case following = "reader_following"
    case saved = "reader_saved"
    case likes = "reader_likes"
    case tag = "reader_tag"
    case site = "reader_site"
    case list = "reader_list"
    case organization = "reader_organization"
    case search = "reader_search"
    case article = "reader_article"
    case comments = "reader_comments"
    case selectInterests = "reader_select_interests"
}

/// The UI element that triggered a navigation action.
enum ReaderTriggerComponent: String, TrackingIdentifier {
    case sidebar
    case postCard = "post_card"
    case postHeader = "post_header"
    case channelTab = "channel_tab"
    case suggestedSitesCard = "suggested_sites_card"
    case suggestedTagsCard = "suggested_tags_card"
    case relatedPosts = "related_posts"
    case articleLink = "article_link"
    case articleHeader = "article_header"
    case tagChip = "tag_chip"
    case commentsSection = "comments_section"
    case toolbar
    case likesSection = "likes_section"
    case contextMenu = "context_menu"
    case searchResult = "search_result"
    case notification
}

/// The specific action the user took on a trigger component.
enum ReaderTriggerAction: String, TrackingIdentifier {
    case tap
    case tapSiteName = "tap_site_name"
    case tapSiteIcon = "tap_site_icon"
    case tapAuthorName = "tap_author_name"
    case tapTag = "tap_tag"
    case tapSite = "tap_site"
    case tapPost = "tap_post"
    case tapComment = "tap_comment"
    case tapLikes = "tap_likes"
    case selectChannel = "select_channel"
}
