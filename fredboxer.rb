require "rubygems"
require "sinatra/base"

class Fredboxer < Sinatra::Base

  get "/spawn" do
    if params[:auth_token] == "valid"
      path = "/home/juliosantos/apps/fredbox/fredbox.html"
      original_text = File.read path
      new_text = original_text.gsub( /<title>.*<\/title>/, "<title>#{params[:name]}</title>" )
      new_text = new_text.gsub( /<h1>.*<small>/, "<h1>#{params[:name]} <small>" )
      File.open( path, "w" ) do |file|
        file.puts new_text
      end

      #`sed -i 's/<title>.*<\/title>/<title>#{params[:name]}<\/title>/' /home/juliosantos/apps/fredbox/fredbox.html`
      #`sed -i 's/<h1>.*<\/small>/<h1>#{params[:name]} <\/small>/' /home/juliosantos/apps/fredbox/fredbox.html`
      #`cat /home/juliosantos/apps/fredbox/fredbox.html`

      output = `cd /home/juliosantos/apps/fredbox; meteor deploy #{params[:name]}.meteor.com`
      output.match( /Now serving at (.*)/ )[1]
    else
      halt 401, "Not authorized\n"
    end
  end

end
