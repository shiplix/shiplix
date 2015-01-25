module PageInfo
  class Meta
    attr_accessor :controller
    alias :c :controller

    attr_accessor :title_variables,
                  :title_key,
                  :header_key,
                  :description_key,
                  :custom_title,
                  :custom_header

    def initialize(controller)
      @controller = controller
    end

    # вычисление названия страницы
    def page_title
      return c.last_error if c.respond_to?(:last_error?) && c.last_error?
      return compact_spaces(@custom_title) if @custom_title.present?

      key = nil_if_blank(title_key) || :title
      vars = (title_variables || {}).merge(
        :scope => action_scope
      )

      compact_spaces(I18n.t!(key, vars) + title_postfix)
    end

    # вычисление заголовка (h1) страницы
    def page_header
      return '' if c.last_error?
      return compact_spaces(@custom_header) if @custom_header.present?

      key = nil_if_blank(header_key) || :header

      vars = (title_variables || {}).merge(
        :scope => action_scope,
        :default => ''
      )

      compact_spaces(I18n.t!(key, vars))
    end

    # вычисление описания страницы
    def page_description
      return '' if c.last_error?

      key = nil_if_blank(description_key) || :description
      vars = (title_variables || {}).merge(
        :scope => action_scope,
        :default => ''
      )

      compact_spaces(I18n.t!(key, vars))
    end

    # постфикс названия страницы
    def title_postfix
      key = :postfix
      action_key = action_scope.join('.') + ".#{key}"
      controller_key = controller_scope.join('.') + ".#{key}"
      default_key = default_scope.join('.') + ".default_#{key}"

      vars = (title_variables || {}).merge(
        :default => [controller_key.to_sym, default_key.to_sym]
      )
      I18n.t!(action_key, vars)
    end

    protected

    def nil_if_blank(string)
      string.is_a?(String) && !string.blank? ? string : nil
    end

    def action_scope
      @action_scope ||= [
        :pages,
        c.class.name.underscore.gsub('/', '.').gsub(/_controller$/, ''),
        c.params[:action]
      ]
    end

    def controller_scope
      @controller_scope ||= [
        :pages,
        c.class.name.underscore.gsub('/', '.').gsub(/_controller$/, '')
      ]
    end

    def default_scope
      @default_scope ||= [
        :pages
      ]
    end

    def compact_spaces(value)
      value.gsub(/[ ]+/, ' ').gsub(/ ([\,\.\:\!])/, '\1')
    end
  end
end
