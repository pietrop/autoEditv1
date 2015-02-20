require 'rss'
class BlogController < ApplicationController
	def index
     begin
       @latest_blog_posts = RSS::Parser.parse(open('http://blog.autoedit.io/feeds/posts/default?alt=rss').read,false).items

     rescue
       # Do nothing, just continue.  The view will skip the blog section if the feed is nil.
       @latest_blog_posts = nil
     end
  end

  def show

  	begin
       @latest_blog_posts = RSS::Parser.parse(open('http://blog.autoedit.io/feeds/posts/default?alt=rss').read,false).items



     rescue
       # Do nothing, just continue.  The view will skip the blog section if the feed is nil.
       @latest_blog_posts = nil
     end
 
				 @latest_blog_posts.each do |post|
				 	if post.guid.content.split('tag:blogger.com,1999:blog-7149222418289544135.post-')[1] == params[:id]
				 		@post = post
				 	end

				end 
   
  # if.where.

  # post.guid.content.split('tag:blogger.com,1999:blog-7149222418289544135.post-')[1]

  end 

end
