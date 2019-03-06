require 'json'
require 'byebug'
class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req
    if req.cookies["_rails_lite_app"]
      @session = JSON.parse(req.cookies["_rails_lite_app"])
    else
      @session = {}
    end
  end

  def [](key)
    # debugger
    @session[key]
  end

  def []=(key, val)
    # debugger
    
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    @res = res 
    @res.set_cookie("_rails_lite_app", {path: "/", value: @session.to_json })
    # debugger 
  end
end
