module Jekyll
  class LangFrTag < Liquid::Tag
    
    def initialize(tag_name, link, tokens)
      super
      @link = link
    end
    
    def render(context)
      html = ""
      html << "<p>"
      html << "<a href=\"#{@link}\">View this page in french</a>"
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
      html << "<a href=\"#{@link}\">Voir cette page en anglais</a>"
      html << "</p>"
      html
    end
  end

end

Liquid::Template.register_tag('langfr', Jekyll::LangFrTag)
Liquid::Template.register_tag('langen', Jekyll::LangEnTag)
