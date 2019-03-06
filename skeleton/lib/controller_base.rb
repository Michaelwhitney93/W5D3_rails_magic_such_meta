require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params)
    @params = params
    @req = req 
    @res = res 
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "double render" if already_built_response?
    @res.status = 302
    @res['Content-Type'] = 'text/html'
    @res['Location'] = url 
    @already_built_response = true
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "double render" if already_built_response?
    @already_built_response = true
    @res['Content-Type'] = content_type
    @res.body = [content]
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    index = self.class.to_s.index('Controller')  #=> 4
    folder_name = self.class.to_s[0...index].downcase
    template = File.read("views/#{folder_name}_controller/#{template_name}.html.erb") 
    rendering = ERB.new(template).result(binding)
    render_content(rendering, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
   Router.send(name)
  end
end

