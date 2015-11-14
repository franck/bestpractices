# Decorator PORO Style

# serve a similar purpose to callbacks
# For cases where callback logic only needs to run in some circumstances
# or including it in the model would give the model too many responsibilities, a Decorator is useful.

# Posting a comment on a blog post might trigger a post to someone’s Facebook wall, but that doesn’t mean the logic should be hard wired into the Comment class

# source : http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/#service-objects)

class FacebookCommentNotifier
  def initialize(comment)
    @comment = comment
  end

  def save
    @comment.save && post_to_wall
  end

private

  def post_to_wall
    Facebook.post(title: @comment.title, user: @comment.author)
  end
end


# Controller migth look like :
class CommentsController < ApplicationController
  def create
    @comment = FacebookCommentNotifier.new(Comment.new(params[:comment]))

    if @comment.save
      redirect_to blog_path, notice: "Your comment was posted."
    else
      render "new"
    end
  end
end
