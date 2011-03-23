# -*- coding: utf-8 -*-
module Jekyll
  class LangFrTag < Liquid::Tag
    
    def initialize(tag_name, link, tokens)
      super
      @link = link
    end
    
    def render(context)
      html = ""
      html << "<p>"
      html << "<a href=\"#{@link}\">View in French/Lire en Français</a>"
      html << "</p>"
      html
    end
  end

  class LangEnTag < Liquid::Tag
    
    def initialize(tag_name, link, tokens)
      super
      @link = link
    end
    
    def render(context)
      html = ""
      html << "<p>"
      html << "<a href=\"#{@link}\">View in English/Lire en Anglais</a>"
      html << "</p>"
      html
    end
  end

end

Liquid::Template.register_tag('langfr', Jekyll::LangFrTag)
Liquid::Template.register_tag('langen', Jekyll::LangEnTag)
