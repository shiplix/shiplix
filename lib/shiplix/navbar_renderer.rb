module Shiplix
  class NavbarRenderer < SimpleNavigation::Renderer::Base
    def render(item_container)
      list_content = item_container.items.each_with_object([]) do |item, list|
        content = tag_for(item)

        if include_sub_navigation?(item)
          content << render_sub_navigation_for(item)
        end

        css_class = item.selected? ? 'active' : nil

        list << content_tag(:li, content, class: css_class)
      end.join

      if item_container.level == 1
        list_content.html_safe
      else
        content_tag(:ul, list_content)
      end
    end

    def tag_for(item)
      icon = item.html_options[:icon]

      item_html = content_tag(:i, '', class: "fa #{icon}")
      item_html << content_tag(:span, item.name, class: 'xn-text')

      link_to(item_html.html_safe, item.url, options_for(item))
    end
  end
end
