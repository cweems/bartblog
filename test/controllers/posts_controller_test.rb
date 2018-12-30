require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "it creates a post with title and body" do
    sign_in users(:one)
    post "/posts", params: { post: { title: "My great tite", body: "Everything I ever wanted to say" } }
    assert_response :redirect

    @post = Post.last
    assert_equal "My great tite", @post.title
    assert_equal "Everything I ever wanted to say", @post.body
  end

  test "it should redirect to sign in if no user" do
    get "/posts"
    assert_redirected_to '/users/sign_in'
  end

  test "it only shows posts that belong to active user" do
    sign_in users(:one)
    post "/posts", params: { post: { title: "User one post", body: "Everything I ever wanted to say" } }
    sign_out users(:one)

    sign_in users(:two)
    get "/posts"

    # Access @posts instance variable
    assert_equal 0, @controller.view_assigns['posts'].length
  end

  test "it groups posts by car title" do
    sign_in users(:one)

    post "/posts", params: { post: { title: "1234", body: "Everything I ever wanted to say" } }
    post "/posts", params: { post: { title: "1234", body: "Everything I ever wanted to say" } }
    post "/posts", params: { post: { title: "4567", body: "Everything I ever wanted to say" } }
    post "/posts", params: { post: { title: "4567", body: "Everything I ever wanted to say" } }
    post "/posts", params: { post: { title: "4567", body: "Everything I ever wanted to say" } }

    get "/posts"
    assert_equal 2, @controller.view_assigns['grouped_posts']['1234'].length
    assert_equal 3, @controller.view_assigns['grouped_posts']['4567'].length
  end

  test "SHOW it shows posts from the same car" do
    sign_in users(:one)

    post "/posts", params: { post: { title: "1234", body: "Everything I ever wanted to say" } }
    post "/posts", params: { post: { title: "1234", body: "Everything I ever wanted to say" } }
    post "/posts", params: { post: { title: "1234", body: "Everything I ever wanted to say" } }

    get "/posts/#{Post.last.id}"
    assert_equal 2, @controller.view_assigns['related_posts'].length

  end
end
